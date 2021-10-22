#!/usr/bin/env bash
export PROJECT_DIR="${GITHUB_WORKSPACE:-$(git rev-parse --show-toplevel)}"

source "$PROJECT_DIR/.github/scripts/utils.sh"

function main() {
  local -r modified_files=("$@")
  declare -a updated

  for chart_file in "${modified_files[@]}"; do
    local -r chart_name="$(yq e '.name' "$chart_file")"
    local -r \
      chart_path="charts/$chart_name" \
      git_chglog_config_template="$GITHUB_WORKSPACE/.github/chglog/config.yml.tpl" \
      git_chglog_config_file="$GITHUB_WORKSPACE/.github/chglog/${chart_name}.yml"

    env CHART_NAME="$chart_name" envsubst <"$git_chglog_config_template" >"$git_chglog_config_file"
    git-chglog \
      --config "$git_chglog_config_file" \
      --path "$chart_path" \
      --output "$chart_path/CHANGELOG.md"

    rm -f "$git_chglog_config_file"
    git add "$chart_path/CHANGELOG.md"
    updated+=("$chart_path/CHANGELOG.md")
  done

  git commit --message "ci(): update chart changelogs"
  git push
}

main "$@"
