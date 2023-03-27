{{- /*
Defines common labels across all blockscout components.
*/ -}}
{{- define "celo.blockscout.labels" -}}
app: blockscout
chart: blockscout
release: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- /*
Set a environment variable if the value is not empty.
*/ -}}
{{- define "celo.blockscout.conditional-env-var" -}}
{{- if .value -}}
- name: {{ .name }}
  value: {{ ternary .value (.value | quote) (kindIs "string" .value) }}
{{- end -}}
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

{{- define "celo.blockscout.instance-name" -}}
{{- $database := default .Values.infrastructure.database .Database -}}
{{- $connection := split ":" $database.connectionName -}}
{{ $connection._2 }}
{{- end -}}

{{- define "celo.blockscout.database-connection-string" -}}
{{- $database := default .Values.infrastructure.database .Database -}}
{{ $database.connectionName }}=tcp:{{ $database.port }}
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
{{- $database := default .Values.infrastructure.database .Database -}}
{{- if .Values.infrastructure.database.enableCloudSQLProxy -}}
- name: cloudsql-proxy
  image: gcr.io/cloudsql-docker/gce-proxy:1.19.1-alpine
  lifecycle:
    postStart:
      exec:
        command: [
          "/bin/sh", "-c",
          "sleep {{ .optionalSleep | default 0 }};",
          "until nc -z {{ $database.proxy.host }}:{{ $database.proxy.port }}; do sleep 1; done"
        ]
  command:
  - /bin/sh
  args:
  - -c
  - |
      /cloud_sql_proxy \
      -instances={{ include "celo.blockscout.database-connection-string" . }} &
      CHILD_PID=$!
      (while true; do if [[ -f "/tmp/pod/main-terminated" ]]; then kill $CHILD_PID; fi; sleep 1; done) &
      wait $CHILD_PID
      if [[ -f "/tmp/pod/main-terminated" ]]; then exit 0; fi
  securityContext:
    runAsUser: 2  # non-root user
    allowPrivilegeEscalation: false
  volumeMounts:
  - mountPath: /tmp/pod
    name: temporary-dir
    readOnly: true
{{- end -}}
{{- end -}}

{{- /*
Defines the CloudSQL proxy container that terminates
after termination of the main container.
Should be included as the last container as it contains
the `volumes` section.
*/ -}}
{{- define "celo.blockscout.container.init-container-wait-sql-instance" -}}
- name: wait-cloudsql
  image: gcr.io/google.com/cloudsdktool/google-cloud-cli:latest
  command:
  - /bin/sh
  args:
  - -c
  - |
      sleep {{ .optionalSleep | default 0 }}
      until gcloud sql instances describe {{ include "celo.blockscout.instance-name" . }} | grep state | grep RUNNABLE > /dev/null; do
        sleep 5;
      done
  securityContext:
    runAsUser: 1000  # non-root user
    allowPrivilegeEscalation: false
  volumeMounts:
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
{{- if .Values.infrastructure.database.enableCloudSQLProxy -}}
{{- $database_host := default .Values.infrastructure.database.proxy.host ((.Database).proxy).connectionName -}}
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
{{- end -}}
{{- end -}}

{{- /*
Defines shared environment variables for all
blockscout components.
*/ -}}
{{- define "celo.blockscout.env-vars" -}}
{{- $user := .Values.blockscout.shared.secrets.dbUser -}}
{{- $password := .Values.blockscout.shared.secrets.dbPassword -}}
- name: DATABASE_USER
  value: {{ $user }}
- name: DATABASE_PASSWORD
  value: {{ $password }}
{{ include "celo.blockscout.conditional-env-var" (dict "name" "ERLANG_COOKIE" "value" .Values.blockscout.shared.secrets.erlang_cookie) }}
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

{{- define "celo.blockscout.getHostName" -}}
{{- if eq .component "api" -}}
{{- $apiHost := ternary (printf "%s-api.%s" .Release.Name .Values.infrastructure.domainName) .Values.blockscout.api.hostname (eq .Values.blockscout.api.hostname "") -}}
{{ $apiHost }}
{{- else if eq .component "web" -}}
{{- $webHost := ternary (printf "%s.%s" .Release.Name .Values.infrastructure.domainName) .Values.blockscout.web.hostname (eq .Values.blockscout.web.hostname "") -}}
{{ $webHost }}
{{- else -}}
{{- fail "getHostname needs \"component\" parameter equals to \"web\" or \"api\"" -}}
{{- end -}}
{{- end -}}
