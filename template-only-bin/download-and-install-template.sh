#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script installs an application template to your project.
# Run this script in your project's root directory.
#
# Positional parameters:
#   target_version (optional) – the version of the template application to install.
#     Defaults to main. Can be any target that can be checked out, including a branch,
#     version tag, or commit hash.
#   app_name (optional) – the new name for the application, in either snake- or kebab-case
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

echo "template_short_name: ${template_short_name}"
echo "app_name: ${app_name}"
echo "target_version: ${target_version}"

git clone "https://github.com/navapbc/${template_name}.git"
cd "${template_name}"

echo "Checking out $target_version..."
git checkout "$target_version"
cd - &> /dev/null

echo "Installing ${template_name}..."
"./${template_name}/template-only-bin/install-template.sh" "${template_name}" "${app_name}"

echo "Storing template version in a file..."
cd "${template_name}"
git rev-parse HEAD >../".${template_name}-version"
cd - &> /dev/null

echo "Cleaning up ${template_name} folder..."
rm -fr "${template_name}"

echo "...Done."