#!/usr/bin/env bash
export PROJECT_DIR="${GITHUB_WORKSPACE:-$(git rev-parse --show-toplevel)}"

source "$PROJECT_DIR/.github/scripts/utils.sh"

pushd "$PROJECT_DIR" 2>/dev/null || exit 1

git config user.name "$GITHUB_ACTOR"
git config user.email "$GITHUB_ACTOR@users.noreply.github.com"

rm -rf "$PROJECT_DIR/.helm"
mkdir -p "$PROJECT_DIR/.helm"

cr_config="$PROJECT_DIR/.github/chart-release.yml"

for chart in $PROJECT_DIR/charts/*; do
  if [[ -f "$chart/Chart.yaml" ]]; then
    echo "---> Packaging chart $(basename "$chart")"
    cr package "$chart" --config "$cr_config"
  fi
done

echo "---> Creating chart releases"
cr upload --config "$cr_config"

echo "---> Updating chart index"
cr index --config "$cr_config"
