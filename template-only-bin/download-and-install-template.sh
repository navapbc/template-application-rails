#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script installs a template application to your project.
# Run this script your project's root directory.
# -----------------------------------------------------------------------------
set -euo pipefail

TEMPLATE_NAME="template-application-nextjs"

echo "Fetch latest version of $(TEMPLATE_NAME)"
git clone --single-branch --branch main --depth 1 git@github.com:navapbc/$(TEMPLATE_NAME).git

echo "Install template"
./$(TEMPLATE_NAME)/template-only-bin/install-template.sh $TEMPLATE_NAME

# Store template version in a file
cd $(TEMPLATE_NAME)
git rev-parse HEAD >../.$(TEMPLATE_NAME)-version
cd -

echo "Clean up $(TEMPLATE_NAME) folder"
rm -fr $(TEMPLATE_NAME)
