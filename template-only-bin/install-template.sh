#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script installs an application template to your project.
# Run this script using ./download-and-install-template.sh
#
# Positional parameters:
#   TEMPLATE_NAME (required) – the name of the template to install
# -----------------------------------------------------------------------------
set -euo pipefail

CUR_DIR=$(pwd)
SCRIPT_DIR=$(dirname $0)
TEMPLATE_DIR="$SCRIPT_DIR/.."
TEMPLATE_NAME=$1
# Use shell parameter expansion to get the last word, where the delimiter between
# words is `-`.
# See https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
TEMPLATE_SHORT_NAME="app-${TEMPLATE_NAME##*-}"

echo "Copying files from $TEMPLATE_NAME..."
cd $TEMPLATE_DIR
# Note: Keep this list of paths in sync with INCLUDE_PATHS in update-template.sh
# @TODO: Add .grype.yml
cp -r \
  .github \
  .gitignore \
  $TEMPLATE_SHORT_NAME \
  docker-compose.yml \
  init-postgres.sql \
  docs \
  $CUR_DIR
cd - >& /dev/null

echo "Removing files relevant only to template development..."
# Note: Keep this list of paths in sync with EXCLUDE_OPT in update-template.sh
rm -rf .github/workflows/template-only-*
rm -rf .github/ISSUE_TEMPLATE
