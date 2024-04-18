#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script renames the application template in your project.
# Run this script in your project's root directory.
#
# Positional parameters:
#   NEW_NAME (required) - the new name for the application, in either snake- or kebab-case
#   OLD_NAME (optional) – the old name for the application, in either snake- or kebab-case
#       Defaults to the template's short name (e.g. app-rails)
# -----------------------------------------------------------------------------
set -euo pipefail

# Helper to get the correct sed -i behavior for both GNU sed and BSD sed (installed by default on macOS)
# Hat tip: https://stackoverflow.com/a/38595160
sedi () {
  sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@"
}
# Export the function so it can be used in the `find -exec` calls later on
export -f sedi

NEW_NAME=$1
OLD_NAME=${2:-"app-rails"}

# Don't make assumptions about whether the arguments are snake- or kebab-case. Handle both.
# Get kebab-case names
OLD_NAME_KEBAB=$(echo $OLD_NAME | tr "_" "-")
NEW_NAME_KEBAB=$(echo $NEW_NAME | tr "_" "-")

# Get snake-case names
OLD_NAME_SNAKE=$(echo $OLD_NAME | tr "-" "_")
NEW_NAME_SNAKE=$(echo $NEW_NAME | tr "-" "_")

# Rename the app directory
if [ -d "$OLD_NAME" ]; then
  echo "Renaming $OLD_NAME to $NEW_NAME..."
  mv "$OLD_NAME" "$NEW_NAME"
fi

# Rename all kebab-case instances
echo "Performing a find-and-replace for all instances of (kebab-case) '$OLD_NAME_KEBAB' with '$NEW_NAME_KEBAB'..."
LC_ALL=C find . -type f -exec bash -c "sedi \"s/$OLD_NAME_KEBAB/$NEW_NAME_KEBAB/g\" \"{}\"" \;

# Rename all snake-case instances
echo "Performing a find-and-replace for all instances of (snake-case) '$OLD_NAME_SNAKE' with '$NEW_NAME_SNAKE'..."
LC_ALL=C find . -type f -exec bash -c "sedi \"s/$OLD_NAME_SNAKE/$NEW_NAME_SNAKE/g\" \"{}\"" \;

echo "...Done."
