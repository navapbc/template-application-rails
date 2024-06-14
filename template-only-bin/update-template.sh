#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script updates an application template in your project.
# This script from your project's root directory.
#
# Positional parameters:
#   target_version (optional) – the version of the template application to install.
#     Defaults to main. Can be any target that can be checked out, including a branch,
#     version tag, or commit hash.
#   app_name (optional) – the name of the application, in either snake- or kebab-case
#     Defaults to app-rails.
# -----------------------------------------------------------------------------
set -euo pipefail

template_name="template-application-rails"
# Use shell parameter expansion to get the last word, where the delimiter between
# words is `-`.
# See https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
template_short_name="app-${template_name##*-}"

target_version=${1:-"main"}
app_name=${2:-"${template_short_name}"}
current_version=$(cat ".${template_name}-version")

git clone "https://github.com/navapbc/${template_name}.git"

echo "Checking out $target_version..."
cd "${template_name}"
git checkout "$target_version"
cd - &> /dev/null

if [ "$template_short_name" != "$app_name" ]; then
  cd "${template_name}"
  echo "Modifying template to use ${app_name} instead of ${template_short_name}..."
  "./template-only-bin/rename-template-app.sh" "${template_short_name}" "${app_name}"
  cd - &> /dev/null
fi

# Note: Keep this list in sync with the files copied in install-template.sh
cd "${template_name}"
include_paths=" \
  .github/workflows/ci-${app_name}.yml
  .grype.yml \
  ${app_name} \
  docker-compose.yml \
  docker-compose.mock-production.yml \
  docs/${app_name}"
git diff $current_version $target_version -- $include_paths > update.patch
cd - &> /dev/null

echo "Applying patch..."
git apply --allow-empty "${template_name}/update.patch"

echo "Storing template version in a file..."
cd "${template_name}"
git rev-parse HEAD >../".${template_name}-version"
cd - &> /dev/null

echo "Cleaning up ${template_name} folder..."
rm -fr "${template_name}"

echo "...Done."