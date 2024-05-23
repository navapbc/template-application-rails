#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script installs an application template to your project.
# Run this script using ./download-and-install-template.sh
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

curr_dir=$(pwd)
script_dir=$(dirname $0)
template_dir="${script_dir}/.."

if [ "$template_short_name" = "$app_name" ]; then
  echo "Modifying template to use ${app_name} instead of ${template_short_name}..."
  "./${template_name}/template-only-bin/rename-template.sh" "${app_name}" "${template_short_name}"
fi

echo "Copying files from $template_name..."
cd $template_dir
# Note: Keep this list of paths in sync with INCLUDE_PATHS in update-template.sh
# @TODO: Add .grype.yml
cp -r \
  .github \
  .gitignore \
  "${app_name}" \
  docker-compose.yml \
  docker-compose.mock-production.yml \
  docs \
  $curr_dir
cd - >& /dev/null

echo "Removing files relevant only to template development..."
# Note: Keep this list of paths in sync with EXCLUDE_OPT in update-template.sh
rm -rf .github/workflows/template-only-*
rm -rf .github/ISSUE_TEMPLATE
