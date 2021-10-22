style: github
template: CHANGELOG.md.tpl
info:
  title: CHANGELOG
  repository_url: https://github.com/moopholo/helm-charts
options:
  tag_filter_pattern: "^${CHART_NAME}"
  commits:
    filters:
      Scope: ["${CHART_NAME}"]
  commit_groups:
    title_maps:
      feat: "Enhancements"
      fix: "Fixes"
      chore: "Changed"
  header:
    pattern: "^(\\w*)(?:\\(([\\w\\$\\.\\-\\*\\s]*)\\))?\\:\\s(.*)$"
    pattern_maps:
      - Type
      - Scope
      - Subject
  notes:
    keywords:
      - BREAKING CHANGE
