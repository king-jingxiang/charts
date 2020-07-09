{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nvidia-gpushare-device-plugin.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nvidia-gpushare-device-plugin.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nvidia-gpushare-device-plugin.labels" -}}
helm.sh/chart: {{ include "nvidia-gpushare-device-plugin.chart" . }}
{{ include "nvidia-gpushare-device-plugin.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nvidia-gpushare-device-plugin.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nvidia-gpushare-device-plugin.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
