{{- /*
Defines common labels across all blockscout components.
*/ -}}
{{- define "celo.blockscout.labels" -}}
app: blockscout
chart: blockscout
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
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
        command: ["/bin/sh", "-c", "until nc -z {{ .Database.proxy.host }}:{{ .Database.proxy.port }}; do sleep 1; done"]
  command:
  - /bin/sh
  args:
  - -c
  - |
    /cloud_sql_proxy \
    -instances={{ .Database.connectionName }}=tcp:{{ .Database.port }} \
    -credential_file=/secrets/cloudsql/credentials.json &
    CHILD_PID=$!
    (while true; do if [[ -f "/tmp/pod/main-terminated" ]]; then kill $CHILD_PID; fi; sleep 1; done) &
    wait $CHILD_PID
    if [[ -f "/tmp/pod/main-terminated" ]]; then exit 0; fi
  securityContext:
    runAsUser: 2  # non-root user
    allowPrivilegeEscalation: false
  volumeMounts:
  - name: blockscout-cloudsql-credentials
    mountPath: /secrets/cloudsql
    readOnly: true
  - mountPath: /tmp/pod
    name: temporary-dir
    readOnly: true
{{- end -}}

{{- /* Defines the volume with CloudSQL proxy credentials file. */ -}}
{{- define "celo.blockscout.volume.cloudsql-credentials" -}}
- name: blockscout-cloudsql-credentials
  secret:
    defaultMode: 420
    secretName: blockscout-cloudsql-credentials
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
        command: ["/bin/sh", "-c", "until nc -z {{ .Database.proxy.host }}:{{ .Database.proxy.port }}; do sleep 1; done"]
  command: ["/cloud_sql_proxy",
            "-instances={{ .Database.connectionName }}=tcp:{{ .Database.port }}",
            "-credential_file=/secrets/cloudsql/credentials.json",
            "-term_timeout=30s"]
  {{- with .Database.proxy.livenessProbe }}
  livenessProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Database.proxy.readinessProbe }}
  readinessProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Database.proxy.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  securityContext:
    runAsUser: 2  # non-root user
    allowPrivilegeEscalation: false
  volumeMounts:
    - name: blockscout-cloudsql-credentials
      mountPath: /secrets/cloudsql
      readOnly: true
{{- end -}}

{{- /*
Defines shared environment variables for all
blockscout components.
*/ -}}
{{- define "celo.blockscout.env-vars" -}}
- name: DATABASE_USER
  value: {{ .Values.blockscout.shared.secrets.dbUser }}
- name: DATABASE_PASSWORD
  value: {{ .Values.blockscout.shared.secrets.dbPassword }}
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
  value: {{ .Values.blockscout.shared.secrets.dbUser }}
- name: DATABASE_DB
  value: {{ .Database.name }}
- name: DATABASE_HOSTNAME
  value: {{ .Database.proxy.host | quote }}
- name: DATABASE_PORT
  value: {{ .Database.proxy.port | quote }}
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
