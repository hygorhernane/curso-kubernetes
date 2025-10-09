{{/*
Expand the name of the chart.
*/}}
{{- define "app5-v2-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app5-v2-chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app5-v2-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "app5-v2-chart.labels" -}}
helm.sh/chart: {{ include "app5-v2-chart.chart" . }}
{{ include "app5-v2-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "app5-v2-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app5-v2-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "app5-v2-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "app5-v2-chart.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
==============================================================================
= Template para um Deployment de um único microsserviço
==============================================================================
*/}}
{{- define "app5-v2-chart.microservice-deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "app5-v2-chart.fullname" . }}-{{ .service.name }}
  labels:
    {{- include "app5-v2-chart.labels" . | nindent 4 }}
    app.kubernetes.io/component: {{ .service.name }}
spec:
  replicas: 1
  selector:
    matchLabels:
      {{- include "app5-v2-chart.selectorLabels" . | nindent 6 }}
      app.kubernetes.io/component: {{ .service.name }}
  template:
    metadata:
      labels:
        {{- include "app5-v2-chart.selectorLabels" . | nindent 8 }}
        app.kubernetes.io/component: {{ .service.name }}
    spec:
      serviceAccountName: {{ include "app5-v2-chart.serviceAccountName" . }}
      securityContext:
        {{- toYaml .root.Values.securityContext | nindent 8 }}
      volumes:
        {{- toYaml .root.Values.volumes | nindent 8 }}
      containers:
        - name: {{ .service.name }}
          image: "{{ .service.image.repository }}:{{ .service.image.tag }}"
          imagePullPolicy: {{ .service.image.pullPolicy }}
          {{- with .service.port }}
          ports:
            - name: http
              containerPort: {{ . }}
              protocol: TCP
          {{- end }}
          envFrom:
            - configMapRef:
                name: {{ include "app5-v2-chart.fullname" .root }}-config
            {{- if .service.useSecret }}
            - secretRef:
                name: {{ include "app5-v2-chart.fullname" .root }}-secret
            {{- end }}
          {{- with .service.probes }}
          livenessProbe:
            {{- toYaml .liveness | nindent 12 }}
          {{- if .readiness }}
          readinessProbe:
            {{- toYaml .readiness | nindent 12 }}
          {{- end }}
          {{- end }}
          volumeMounts:
            {{- toYaml .service.volumeMounts | nindent 12 }}
{{- end -}}