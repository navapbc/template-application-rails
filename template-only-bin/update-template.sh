#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script updates an application template in your project.
# Run this script in your project's root directory.
#
# Positional parameters:
#   TEMPLATE_NAME (required) – the name of the template to update. Should be in the
#     format `template-application-<foo>`. This is case sensitive and  must match
#     the name of the application template git repo name.
#
#   TARGET_VERSION (optional) – the version of the template application to install.
#     Defaults to main. Can be any target that can be checked out, including a branch,
#     version tag, or commit hash.
# -----------------------------------------------------------------------------
set -euo pipefail

TEMPLATE_NAME=$1
TARGET_VERSION=${2:-"main"}
CURRENT_VERSION=$(cat ".$TEMPLATE_NAME-version")
# Use shell parameter expansion to get the last word, where the delimiter between
# words is `-`.
# See https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
TEMPLATE_SHORT_NAME="app-${TEMPLATE_NAME##*-}"

echo "Cloning $TEMPLATE_NAME..."
git clone "https://github.com/navapbc/$TEMPLATE_NAME.git"

echo "Creating patch..."
cd "$TEMPLATE_NAME"
git checkout "$TARGET_VERSION"

# Get version hash to update version file with after patch is successful
TARGET_VERSION_HASH=$(git rev-parse HEAD)

# Note: Keep this list in sync with the files copied in install-template.sh
# @TODO: Add .grype.yml
INCLUDE_PATHS=" \
  .github \
  .gitignore \
  $TEMPLATE_SHORT_NAME \
  docker-compose.yml \
  init-postgres.sql \
  docs"
git diff "$CURRENT_VERSION" "$TARGET_VERSION" -- "$INCLUDE_PATHS" >patch
cd - >& /dev/null

echo "Applying patch..."
# Note: Keep this list in sync with the removed files in install-template.sh
EXCLUDE_OPT="--exclude=.github/workflows/template-only-* \
  --exclude=.github/ISSUE_TEMPLATE"
git apply "$EXCLUDE_OPT" --allow-empty "$TEMPLATE_NAME/patch"

echo "Saving new template version to .$TEMPLATE_NAME-version..."
echo "$TARGET_VERSION_HASH" >".$TEMPLATE_NAME-version"

echo "Cleaning up $TEMPLATE_NAME folder..."
rm -rf "$TEMPLATE_NAME"

echo "...Done."
