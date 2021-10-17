#!/usr/bin/env bash
export PROJECT_DIR="${GITHUB_WORKSPACE:-$(git rev-parse --show-toplevel)}"

source "$PROJECT_DIR/.github/scripts/utils.sh"

function charts_with_changes_json_array() {
  decalre -a charts
  for c in $(ct list-changed --config "$PROJECT_DIR/.github/chart-testing.yml"); do
    charts+=("${c##charts/}")
  done
  echo "[\"$(join_by '","' ${charts[@]})\"]"
}

changed="$(charts_with_changes_json_array)"
echo "::set-output name=matrix::{\"chart-name\":$changed}"
if [[ "$changed" = '[""]' ]]; then
  echo "::set-output name=changes::false"
else
  echo "::set-output name=changes::true"
fi
