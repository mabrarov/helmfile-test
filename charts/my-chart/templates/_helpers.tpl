{{/*
Expand the name of the chart.
*/}}
{{- define "my-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "my-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "my-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "my-chart.labels" -}}
helm.sh/chart: {{ include "my-chart.chart" . | quote }}
{{ include "my-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "my-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "my-chart.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{/*
Name of config map.
*/}}
{{- define "my-chart.configMapName" -}}
{{ include "my-chart.fullname" . }}
{{- end }}

{{/*
Name of deployment.
*/}}
{{- define "my-chart.deploymentName" -}}
{{ include "my-chart.fullname" . }}
{{- end }}

{{/*
Name of service.
*/}}
{{- define "my-chart.serviceName" -}}
{{ include "my-chart.fullname" . }}
{{- end }}

{{/*
Name of ingress.
*/}}
{{- define "my-chart.ingressName" -}}
{{ include "my-chart.fullname" . }}
{{- end }}

{{/*
Name of test pod.
*/}}
{{- define "my-chart.testPodName" -}}
{{ include "my-chart.fullname" . }}-test
{{- end }}

{{/*
Web content filename.
*/}}
{{- define "my-chart.contentFilename" -}}
http.js
{{- end }}
