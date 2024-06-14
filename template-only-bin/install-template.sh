#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script installs an application template to your project.
# Run this script using ./download-and-install-template.sh. Expected to be run
# from the project's root directory.
#
# Positional parameters:
#   template_name (required) – the name of the template to install
#   app_name (required) – the name of the application
# -----------------------------------------------------------------------------
set -euo pipefail

template_name=$1
# Use shell parameter expansion to get the last word, where the delimiter between
# words is `-`.
# See https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
template_short_name="app-${template_name##*-}"
app_name=$2

echo "template_short_name: ${template_short_name}"
echo "app_name: ${app_name}"

curr_dir=$(pwd)

cd "${template_name}"

if [ "${template_short_name}" != "${app_name}" ]; then
  echo "Modifying template to use ${app_name} instead of ${template_short_name}..."
  "./template-only-bin/rename-template-app.sh" "${template_short_name}" "${app_name}"
fi

# Note: Keep this list in sync with the files listed in update-template.sh
# Copy only relevant files that should be included in the project repo.
echo "Copying files from ${template_name}..."
# Copy top level paths.
cp -r \
  .grype.yml \
  "${app_name}" \
  docker-compose.yml \
  docker-compose.mock-production.yml \
  ${curr_dir}
# Copy nested paths.
cp ".github/workflows/ci-${app_name}.yml" "${curr_dir}/.github/workflows"
cp -r "docs/${app_name}" "${curr_dir}/docs"

cd - >& /dev/null