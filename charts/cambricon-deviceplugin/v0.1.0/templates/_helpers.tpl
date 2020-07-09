{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cambricon-devica-plugin.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cambricon-devica-plugin.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cambricon-devica-plugin.labels" -}}
helm.sh/chart: {{ include "cambricon-devica-plugin.chart" . }}
{{ include "cambricon-devica-plugin.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cambricon-devica-plugin.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cambricon-devica-plugin.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
