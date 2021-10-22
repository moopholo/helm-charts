{{ range .Versions }}
<a name="{{ .Tag.Name }}"></a>
## {{ if .Tag.Previous }}[{{ .Tag.Name }}]({{ $.Info.RepositoryURL }}/compare/{{ .Tag.Previous.Name }}...{{ .Tag.Name }}){{ else }}{{ .Tag.Name }}{{ end }}

> {{ datetime "2006-01-02" .Tag.Date }}

{{ if .CommitGroups }}
### What's Changed
{{ if .NoteGroups -}}
{{ range .NoteGroups -}}
### {{ .Title }}

{{ range .Notes }}
{{ .Body }}
{{ end }}
{{ end }}
{{ end -}}

{{ range .CommitGroups -}}
### {{ .Title }}

{{ range .Commits -}}
- {{ .Subject }}
{{ end }}
{{ end -}}
{{ else -}}
No Changes
{{ end -}}
{{ end -}}
