#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script renames the application template in your project.
# Run this script in your project's root directory.
#
# Positional parameters:
#   new_name (required) - the new name for the application, in either snake- or kebab-case
#   old_name (required) – the old name for the application, in either snake- or kebab-case
# -----------------------------------------------------------------------------
set -euo pipefail

# Helper to get the correct sed -i behavior for both GNU sed and BSD sed (installed by default on macOS)
# Hat tip: https://stackoverflow.com/a/38595160
sedi () {
  sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@"
}
# Export the function so it can be used in the `find -exec` calls later on
export -f sedi

new_name=$1
old_name=$2

# Don't make assumptions about whether the arguments are snake- or kebab-case. Handle both.
# Get kebab-case names
old_name_kebab=$(echo $old_name | tr "_" "-")
new_name_kebab=$(echo $new_name | tr "_" "-")

# Get snake-case names
old_name_snake=$(echo $old_name | tr "-" "_")
new_name_snake=$(echo $new_name | tr "-" "_")

# Rename the app directory
if [ -d "$old_name" ]; then
  echo "Renaming ${old_name} to ${new_name}..."
  mv "${old_name}" "${new_name}"
fi

# Rename all kebab-case instances
echo "Performing a find-and-replace for all instances of (kebab-case) '$old_name_kebab' with '$new_name_kebab'..."
LC_ALL=C find . -type f -not -path "./.git/*" -exec bash -c "sedi \"s/$old_name_kebab/$new_name_kebab/g\" \"{}\"" \;

# Rename all snake-case instances
echo "Performing a find-and-replace for all instances of (snake-case) '$old_name_snake' with '$new_name_snake'..."
LC_ALL=C find . -type f -not -path "./.git/*" -exec bash -c "sedi \"s/$old_name_snake/$new_name_snake/g\" \"{}\"" \;

echo "...Done."
