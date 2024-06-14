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
#   target_script_branch (optional) - the branch of the template repo to use when
#     retrieving template-only-bin scripts. Used primarily for template development.
#     Defaults to `main`.
# -----------------------------------------------------------------------------
set -euo pipefail

template_name="template-application-rails"
# Use shell parameter expansion to get the last word, where the delimiter between
# words is `-`.
# See https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
template_short_name="app-${template_name##*-}"

target_version=${1:-"main"}
app_name=${2:-"${template_short_name}"}
target_script_branch=${3:-"main"}

git clone "https://github.com/navapbc/${template_name}.git"
cd "${template_name}"

echo "Checking out $target_version..."
git checkout "$target_version"
cd - &> /dev/null

echo "Installing ${template_name}..."
curl "https://raw.githubusercontent.com/navapbc/${template_name}/${target_script_branch}/template-only-bin/install-template.sh" | bash -s -- "${template_name}" "${app_name}" "${target_script_branch}"

echo "Storing template version in a file..."
cd "${template_name}"
git rev-parse HEAD >../".${template_name}-version"
cd - &> /dev/null

echo "Cleaning up ${template_name} folder..."
rm -fr "${template_name}"

echo "...Done."