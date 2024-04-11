#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script installs an application template to your project.
# Run this script in your project's root directory.
#
# Positional parameters:
#   TARGET_VERSION (optional) – the version of the template application to install.
#     Defaults to main. Can be any target that can be checked out, including a branch,
#     version tag, or commit hash.
# -----------------------------------------------------------------------------
set -euo pipefail

TARGET_VERSION=${1:-"main"}
TEMPLATE_NAME="template-application-rails"

git clone "https://github.com/navapbc/$TEMPLATE_NAME.git"
cd "$TEMPLATE_NAME"

echo "Checking out $TARGET_VERSION..."
git checkout "$TARGET_VERSION"
cd - &> /dev/null

echo "Installing $TEMPLATE_NAME..."
"./$TEMPLATE_NAME/template-only-bin/install-template.sh" "$TEMPLATE_NAME"

echo "Storing template version in a file..."
cd "$TEMPLATE_NAME"
git rev-parse HEAD >../".$TEMPLATE_NAME-version"
cd - &> /dev/null

echo "Cleaning up $TEMPLATE_NAME folder..."
rm -fr "$TEMPLATE_NAME"

echo "...Done."