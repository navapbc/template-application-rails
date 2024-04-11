#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script installs a template application to your project.
# Run this script your project's root directory.
# -----------------------------------------------------------------------------
set -euo pipefail

CUR_DIR=$(pwd)
TEMPLATE_NAME=$(basename $CUR_DIR)
SCRIPT_DIR=$(dirname $0)
TEMPLATE_DIR="$SCRIPT_DIR/.."

echo "CUR_DIR: $CUR_DIR"
echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "TEMPLATE_DIR: $TEMPLATE_DIR"
echo "TEMPLATE_NAME: $TEMPLATE_NAME"

# echo "Copy files from $(TEMPLATE_NAME)"
# cd $TEMPLATE_DIR
# # Note: Keep this list of paths in sync with INCLUDE_PATHS in update-template.sh
# cp -r \
#   .github \
#   .gitignore \
#   .grype.yml \
#   app \
#   docker-compose.yml \
#   docs \
#   $CUR_DIR
# cd -

# echo "Remove files relevant only to template development"
# # Note: Keep this list of paths in sync with EXCLUDE_OPT in update-template.sh
# rm .github/workflows/template-only-*
# rm -rf .github/ISSUE_TEMPLATE
# rm -rf docs/decisions/template
