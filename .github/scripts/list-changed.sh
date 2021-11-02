#!/usr/bin/env bash
export PROJECT_DIR="${GITHUB_WORKSPACE:-$(git rev-parse --show-toplevel)}"

source "$PROJECT_DIR/.github/scripts/utils.sh"

function charts_with_changes_json_array() {
  declare -a changes
  declare -a charts

  if [[ $# -eq 0 ]]; then
    mapfile -t changes < <(ct list-changed --config "$PROJECT_DIR/.github/chart-testing.yml")
  else
    changes=("$@")
  fi

  for c in "${changes[@]}"; do
    if [[ $c =~ ^charts ]]; then
      charts+=("$(echo "$c" | cut -d/ -f2)")
    fi
  done

  # shellcheck disable=SC2068
  echo "[\"$(join_by '","' ${charts[@]})\"]"
}

echo "---> building changed-charts matrix"
changed="$(charts_with_changes_json_array "$@")"
echo "changed charts: $changed"
echo "::set-output name=matrix::{\"chart-name\":$changed}"
if [[ $changed == '[""]' ]]; then
  echo "::set-output name=changes::false"
else
  echo "::set-output name=changes::true"
fi
