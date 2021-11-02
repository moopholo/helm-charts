#!/usr/bin/env bash
export PROJECT_DIR="${GITHUB_WORKSPACE:-$(git rev-parse --show-toplevel)}"

# shellcheck disable=SC1091
source "$PROJECT_DIR/.github/scripts/utils.sh"

function main() {
  local -r modified_charts=("$@")
  declare -a updated_charts
  declare -a updated_changelogs

  for chart_file in "${modified_charts[@]}"; do
    local chart_name chart_path git_chglog_config_template git_chglog_config_file

    chart_name="$(yq e '.name' "$chart_file")"
    chart_path="charts/$chart_name"

    git_chglog_config_template="$GITHUB_WORKSPACE/.github/chglog/config.yml.tpl"
    git_chglog_config_file="$GITHUB_WORKSPACE/.github/chglog/${chart_name}.yml"

    echo "---> Updating changelog for $chart_name"
    env CHART_NAME="$chart_name" envsubst <"$git_chglog_config_template" >"$git_chglog_config_file"
    git-chglog \
      --config "$git_chglog_config_file" \
      --path "$chart_path" \
      --output "$chart_path/CHANGELOG.md"

    rm -f "$git_chglog_config_file"
    git add "$chart_path/CHANGELOG.md"
    updated_charts+=("$chart_name")
    updated_changelogs+=("$chart_path/CHANGELOG.md")
  done

  # shellcheck disable=SC2068
  echo "::set-output name=updated-charts::$(join_by ',' ${updated_charts[@]})"
  # shellcheck disable=SC2068
  echo "::set-output name=updated-changelogs::$(join_by ',' ${updated_changelogs[@]})"
  git commit --message "ci(docs): update chart changelogs [skip ci]"
  git push
}

main "$@"
