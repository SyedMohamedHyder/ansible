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
Create the name of the shared target home to use
*/}}
{{- define "ansible.sharedTargetHome" -}}
{{- include "ansible.fullname" . }}-home
{{- end }}

{{/*
Create the name of the shared target pvc to use
*/}}
{{- define "ansible.sharedTargetHome.pvc" -}}
{{- include "ansible.sharedTargetHome" . }}-pvc
{{- end }}

{{/*
Create the name of the workplace ansible
*/}}
{{- define "ansible.workplace" -}}
{{- include "ansible.fullname" . }}-workplace
{{- end }}

{{/*
Create the name of the workplace ansible pv to use
*/}}
{{- define "ansible.workplace.pv" -}}
{{- include "ansible.workplace" . }}-pv
{{- end }}

{{/*
Create the name of the workplace ansible pvc to use
*/}}
{{- define "ansible.workplace.pvc" -}}
{{- include "ansible.workplace" . }}-pvc
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
Helper function to provide name of the target.
*/}}
{{- define "ansible.target.name" -}}
target-{{ .id }}
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

{{/*
Helper function to provide default command for controller if not specified in values.yaml
*/}}
{{- define "ansible.controller.command" -}}
- /bin/sh
- -c
{{- end }}

{{/*
Helper function to provide default args for controller if not specified in values.yaml
*/}}
{{- define "ansible.controller.args" -}}
- "while true; do sleep 60; done;"
{{- end }}

{{/*
Helper function to provide default values for controller readinessProbe if not specified in values.yaml
*/}}
{{- define "ansible.controller.readinessProbe" -}}
exec:
  command:
  - ansible
  - all
  - -m
  - ping
initialDelaySeconds: 10
periodSeconds: 5
timeoutSeconds: 5
successThreshold: 1
failureThreshold: 3
{{- end }}
