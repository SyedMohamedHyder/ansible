{{/*
Expand the name of the chart.
*/}}
{{- define "ansible.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ansible.fullname" -}}
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
{{- define "ansible.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ansible.labels" -}}
helm.sh/chart: {{ include "ansible.chart" . }}
{{ include "ansible.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ansible.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ansible.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the ansible home to use
*/}}
{{- define "ansible.home" -}}
{{- include "ansible.fullname" . }}-home
{{- end }}

{{/*
Create the name of the ansible home pvc to use
*/}}
{{- define "ansible.home.pvc" -}}
{{- include "ansible.home" . }}-pvc
{{- end }}

{{/*
Create the name of the shared ansible
*/}}
{{- define "ansible.shared" -}}
{{- include "ansible.fullname" . }}-shared
{{- end }}

{{/*
Create the name of the shared ansible pv to use
*/}}
{{- define "ansible.shared.pv" -}}
{{- include "ansible.shared" . }}-pv
{{- end }}

{{/*
Create the name of the shared ansible pvc to use
*/}}
{{- define "ansible.shared.pvc" -}}
{{- include "ansible.shared" . }}-pvc
{{- end }}

{{/*
Helper function to provide default values for resources if not specified in values.yaml
*/}}
{{- define "ansible.defaultResources" -}}
limits:
  cpu: "1"
  memory: "512Mi"
requests:
  cpu: "0.5"
  memory: "256Mi"
{{- end }}

{{/*
Helper function to provide default values for target readinessProbe if not specified in values.yaml
*/}}
{{- define "ansible.target.readinessProbe" -}}
exec:
  command:
  - /bin/sh
  - -c
  - |
    ssh -q -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=3 localhost exit
initialDelaySeconds: 10
periodSeconds: 5
timeoutSeconds: 3
successThreshold: 1
failureThreshold: 3
{{- end }}
