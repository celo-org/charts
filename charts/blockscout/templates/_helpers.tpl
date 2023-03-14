{{- /*
Defines common labels across all blockscout components.
*/ -}}
{{- define "celo.blockscout.labels" -}}
app: blockscout
chart: blockscout
release: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "celo.blockscout.elixir.labels" -}}
erlang-cluster: {{ .Release.Name }}
{{- end -}}

{{- /*
Defines common annotations across all blockscout components.
*/ -}}
{{- define "celo.blockscout.annotations" -}}
kubernetes.io/change-cause: {{ default "No change-cause provided" .Values.changeCause }}
{{- end -}}


{{- /*
Sanitize GCP Service account name
*/ -}}
{{- define "celo.blockscout.sanitize-gcp-service-account-name" -}}
{{- if lt (len .name) 6 }}
{{- fail "Google Service Account name is not valid. Lenght must be between 6 - 30 characters" }}
{{- end -}}
{{ trunc 30 (lower .name) | replace "_" "-" | replace "." "-" }}
{{- end -}}

{{- define "celo.blockscout.instance-name" -}}
{{- if .Values.infrastructure.configConnector.cloudSQL.create -}}
{{ .Values.infrastructure.configConnector.cloudSQL.instanceName | default .Release.Name | replace "_" "-" | replace "." "-" }}
{{- else -}}
{{ .Values.infrastructure.database.connectionName }}
{{- end -}}
{{- end -}}

{{- define "celo.blockscout.database-connection-string" -}}
{{- $connection_name := include "celo.blockscout.instance-name" . -}}
{{- $connection_port := ternary "5432" .Values.infrastructure.database.port .Values.infrastructure.configConnector.cloudSQL.create -}}
{{ $connection_name }}=tcp:{{ $connection_port }}
{{- end -}}

{{- define "celo.blockscout.hook-annotations" -}}
helm.sh/hook: pre-install, pre-upgrade
helm.sh/hook-weight: "{{ .weight | default 0 }}"
helm.sh/hook-delete-policy: {{ .delete_policy | default "before-hook-creation" }}
helm.sh/resource-policy: keep
{{- end -}}


{{- /*
Defines the CloudSQL proxy container that terminates
after termination of the main container.
Should be included as the last container as it contains
the `volumes` section.
*/ -}}
{{- define "celo.blockscout.container.db-terminating-sidecar" -}}
- name: cloudsql-proxy
  image: gcr.io/cloudsql-docker/gce-proxy:1.19.1-alpine
  lifecycle:
    postStart:
      exec:
        command: [
          "/bin/sh", "-c",
          "sleep {{ .optionalSleep | default 0 }};",
          "until nc -z {{ .Values.infrastructure.database.proxy.host }}:{{ .Values.infrastructure.database.proxy.port }}; do sleep 1; done"
        ]
  command:
  - /bin/sh
  args:
  - -c
  - |
      /cloud_sql_proxy \
      {{- if .Values.infrastructure.configConnector.overrideCloudSQLGcloudSA }}
      -credential_file=/secrets/cloudsql/credentials.json \
      {{- end }}
      -instances={{ include "celo.blockscout.database-connection-string" . }} &
      CHILD_PID=$!
      (while true; do if [[ -f "/tmp/pod/main-terminated" ]]; then kill $CHILD_PID; fi; sleep 1; done) &
      wait $CHILD_PID
      if [[ -f "/tmp/pod/main-terminated" ]]; then exit 0; fi
  securityContext:
    runAsUser: 2  # non-root user
    allowPrivilegeEscalation: false
  volumeMounts:
  {{- if .Values.infrastructure.configConnector.overrideCloudSecretsGcloudSA }}
  - name: blockscout-cloudsql-credentials
    mountPath: /secrets/cloudsql
    readOnly: true
  {{- end }}
  - mountPath: /tmp/pod
    name: temporary-dir
    readOnly: true
{{- end -}}

{{- /* Defines the volume with CloudSQL proxy credentials file. */ -}}
{{- define "celo.blockscout.volume.cloudsql-credentials" -}}
{{- if .Values.infrastructure.configConnector.overrideCloudSecretsGcloudSA -}}
- name: blockscout-cloudsql-credentials
  secret:
    defaultMode: 420
    secretName: blockscout-cloudsql-credentials
{{- end -}}
{{- end -}}

{{- /* Defines an empty dir volume with write access for temporary pid files. */ -}}
{{- define "celo.blockscout.volume.temporary-dir" -}}
- name: temporary-dir
  emptyDir: {}
{{- end -}}

{{- /* Defines NFS volumes for storing various compilers versions. */ -}}
{{- define "celo.blockscout.volume.compilers" -}}
- name: vyper-compilers
  persistentVolumeClaim:
    claimName: {{ .Release.Name }}-nfs-vyper-compilers-volume
- name: solc-compilers
  persistentVolumeClaim:
    claimName: {{ .Release.Name }}-nfs-solc-compilers-volume
{{- end -}}

{{- /* Defines init container copying secrets-init to the specified directory. */ -}}
{{- define "celo.blockscout.initContainer.secrets-init" -}}
- name: secrets-init
  image: "doitintl/secrets-init:0.4.2"
  args:
    - copy
    - /secrets/
  volumeMounts:
  - mountPath: /secrets
    name: temporary-dir
{{- end -}}

{{- /*
Defines the CloudSQL proxy container that provides
access to the database to the main container.
Should be included as the last container as it contains
the `volumes` section.
*/ -}}
{{- define "celo.blockscout.container.db-sidecar" -}}
- name: cloudsql-proxy
  image: gcr.io/cloudsql-docker/gce-proxy:1.19.1-alpine
  lifecycle:
    postStart:
      exec:
        command: [
          "/bin/sh", "-c", 
          "until nc -z {{ .Values.infrastructure.database.proxy.host }}:{{ .Values.infrastructure.database.proxy.port }}; do sleep 1; done"
        ]
  command:
  - /bin/sh
  - -c
  args:
  - |
    /cloud_sql_proxy \
    {{- if .Values.infrastructure.configConnector.overrideCloudSQLGcloudSA }}
    -credential_file=/secrets/cloudsql/credentials.json \
    {{- end }}
    -instances={{ include "celo.blockscout.database-connection-string" . }} \
    -term_timeout=30s
  {{- with .Values.infrastructure.database.proxy.livenessProbe }}
  livenessProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.infrastructure.database.proxy.readinessProbe }}
  readinessProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- $resources := default .Values.infrastructure.database.proxy.resources (((.Database).proxy).resources) }}
  {{- with $resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  securityContext:
    runAsUser: 2  # non-root user
    allowPrivilegeEscalation: false
  {{- if .Values.infrastructure.configConnector.overrideCloudSecretsGcloudSA }}
  volumeMounts:
    - name: blockscout-cloudsql-credentials
      mountPath: /secrets/cloudsql
      readOnly: true
  {{- end }}
{{- end -}}

{{- /*
Defines shared environment variables for all
blockscout components.
*/ -}}
{{- define "celo.blockscout.env-vars" -}}
{{- $user := ternary .Values.infrastructure.configConnector.cloudSQL.username .Values.blockscout.shared.secrets.dbUser .Values.infrastructure.configConnector.cloudSQL.create -}}
{{- $password := ternary .Values.infrastructure.configConnector.cloudSQL.userPassword .Values.blockscout.shared.secrets.dbPassword .Values.infrastructure.configConnector.cloudSQL.create -}}
- name: DATABASE_USER
  value: {{ $user }}
- name: DATABASE_PASSWORD
  value: {{ $password }}
- name: ERLANG_COOKIE
  value: {{ .Values.blockscout.shared.secrets.erlang.cookie }}
- name: POD_IP
  valueFrom:
    fieldRef:
      fieldPath: status.podIP
- name: EPMD_SERVICE_NAME
  value: {{ .Release.Name }}-epmd-service
- name: NETWORK
  value: Celo
- name: SUBNETWORK
  value: {{ .Values.network.name }}
- name: COIN
  value: CELO
- name: COIN_NAME
  value: CELO
- name: ECTO_USE_SSL
  value: "false"
- name: ETHEREUM_JSONRPC_VARIANT
  value: geth
- name: ETHEREUM_JSONRPC_HTTP_URL
  value: {{ .Values.network.nodes.archiveNodes.jsonrpcHttpUrl }}
- name: ETHEREUM_JSONRPC_WS_URL
  value: {{ .Values.network.nodes.archiveNodes.jsonrpcWsUrl }}
- name: PGUSER
  value: {{ $user }}
- name: DATABASE_DB
  value: {{ .Values.infrastructure.database.name }}
- name: DATABASE_HOSTNAME
  value: {{ .Values.infrastructure.database.proxy.host | quote }}
- name: DATABASE_PORT
  value: {{ .Values.infrastructure.database.proxy.port | quote }}
- name: WOBSERVER_ENABLED
  value: "false"
- name: HEALTHY_BLOCKS_PERIOD
  value: {{ .Values.blockscout.shared.healthyBlocksPeriod | quote }}
- name: MIX_ENV
  value: prod
- name: LOGO
  value: /images/celo_logo.svg
- name: BLOCKSCOUT_VERSION
  value: {{ .Values.blockscout.shared.image.tag }}
{{- end -}}

{{- /*
Set a environment variable if the value is not empty.
*/ -}}
{{- define "celo.blockscout.conditional-env-var" -}}
{{- if .value -}}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end -}}
{{- end -}}

{{- define "celo.blockscout.all-secrets-from-secretmanager-names" -}}
{{- $result := "" -}}
{{- $maps := "" -}}
{{- range $key, $value := .Values.blockscout.shared.secrets -}}
  {{- if $value -}}
    {{- if kindIs "map" $value -}}
      {{- range $keyl2, $valuel2 := $value -}}
        {{- $secret_name := split "/" $valuel2 -}}
        {{- if (trim $secret_name._3) -}}
          {{ $result = printf "%s,%s" $result (trim $secret_name._3) }}
        {{- else -}}
          {{ fail (printf "Error A at \"celo.blockscout.all-secrets-from-secretmanager-names\". Incorrect secret format for key %s with value %s and secret $s" $keyl2 $valuel2 $secret_name) }}
        {{- end -}}
      {{- end -}}
    {{- else if kindIs "string" $value -}}
      {{- $secret_name := split "/" $value -}}
      {{- if (trim $secret_name._3) -}}
        {{ $result = printf "%s,%s" $result (trim $secret_name._3) }}
      {{- else -}}
        {{ fail (printf "Error B at \"celo.blockscout.all-secrets-from-secretmanager-names\". Incorrect secret format for key %s with value %s" $key $value) }}
      {{- end -}}
    {{- end -}}
    {{- end -}}
  {{- end -}}
{{- trimPrefix "," $result }}
{{- end -}}

{{- define "celo.blockscout.all-secrets-from-secretmanager-names-new" -}}
{{- $result := "" -}}
{{- $values := values .Values.blockscout.shared.secrets -}}
{{- range $value := $values -}}
  {{- if $value -}}
    {{- if kindIs "map" $value -}}
      {{- $values2 := values $value -}}
      {{- range $value2 := $values2 -}}
        {{- if $value2 -}}
          {{- $secret_name := split "/" $value2 -}}
          {{- if (trim $secret_name._3) -}}
            {{ $result = printf "%s,%s" $result (trim $secret_name._3) }}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- else if kindIs "string" $value -}}
      {{- $secret_name := split "/" $value -}}
      {{- if (trim $secret_name._3) -}}
        {{ $result = printf "%s,%s" $result (trim $secret_name._3) }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- trimPrefix "," $result }}
{{- end -}}
