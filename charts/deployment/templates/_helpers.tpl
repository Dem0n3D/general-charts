{{/*
Expand the name of the chart.
*/}}
{{- define "deployment.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "deployment.fullname" -}}
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
{{- define "deployment.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "deployment.labels" -}}
{{- $labels := deepCopy $.Values.global.labels | merge $.Values.labels -}}
helm.sh/chart: {{ include "deployment.chart" . }}
{{- if $labels }}
{{ toYaml $labels }}
{{- end }}
{{ include "deployment.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "deployment.selectorLabels" -}}
app.kubernetes.io/name: {{ include "deployment.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod labels
*/}}
{{- define "deployment.podLabels" -}}
{{- $podLabels := deepCopy $.Values.global.podLabels | merge $.Values.podLabels -}}
{{ include "deployment.selectorLabels" . }}
{{- if $podLabels }}
{{ toYaml $podLabels }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "deployment.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "deployment.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}