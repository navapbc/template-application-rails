#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This script renames the template application in a project.
# Run this script in a project's root directory.
#
# The project name is the name of the folder in your project's root directory. Use
# lowercase letters and hyphens. Do not use spaces. Underscores may have unexpected side
# effects. Choose a unique string that will avoid collisions with commonly used words.
# By default, the application name is `app-rails`.
#
# Positional parameters:
#   current_name (required) – the current name for the application
#   new_name (required) - the new name for the application
# -----------------------------------------------------------------------------
set -euo pipefail

# Helper to get the correct sed -i behavior for both GNU sed and BSD sed (installed by default on macOS)
# Hat tip: https://stackoverflow.com/a/38595160
sedi () {
  sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@"
}
# Export the function so it can be used in the `find -exec` calls later on
export -f sedi

current_name=$1
new_name=$2
default_name="app-rails"

# Debug:
echo "---------------------------------------------------------------------"
echo "current_name: ${current_name}"
echo "new_name: ${new_name}"
echo

if [[ "${current_name}" == "${new_name}" ]]; then
  # Debug:
  echo "No rename required: ${current_name} == ${new_name}"
  exit 0
fi

# Note: Keep this list in sync with the files copied in install-template and update-template
declare -a include_paths
include_paths=(.github/workflows/ci-app-rails.yml)
include_paths+=(.grype.yml)
include_paths+=(app-rails)
include_paths+=(docker-compose.yml)
include_paths+=(docker-compose.mock-production.yml)
include_paths+=(docs/app-rails)

# Loop through the paths to be included in this template.
for include_path in "${include_paths[@]}"; do
  # If the application does not use the default name (i.e. it has already been renamed),
  # change the include path to use the correct current_name.
  if [[ "${current_name}" != "${default_name}" ]]; then
    include_path=$(echo "${include_path}" | sed "s/${default_name}/${current_name}/g")
  fi

  echo "Checking '${include_path}' to rename '${current_name}' to '${new_name}'..."

  # Skip if the path does not exist.
  if [[ ! -d "${include_path}" ]] && [[ ! -f "${include_path}" ]]; then
    echo "Skipping ahead. ${include_path} does not exist in this repo"
    continue
  fi

  # Construct the correct string substitution that respects word boundaries.
  # Hat tip: https://unix.stackexchange.com/a/393968
  if sed --version >/dev/null 2>&1; then
    word_boundary_replacement="s/\<${current_name}\>/${new_name}/g"
  else
    word_boundary_replacement="s/[[:<:]]${current_name}[[:>:]]/${new_name}/g"
  fi

  # Replace occurrances of the current_name with the new_name in the path.
  # If the path is a file, replace in the file.
  # If the path is a directory, recursively replace in all files in the directory.
  LC_ALL=C find "${include_path}" -type f -exec bash -c "sedi \"${word_boundary_replacement}\" \"{}\"" \;

  # Rename included paths that contain the current_name.
  if [[ "${include_path}" =~ "${current_name}" ]]; then
    new_include_path=$(echo "${include_path}" | sed "s/${current_name}/${new_name}/g")
    echo "Renaming path from '${include_path}' to '${new_include_path}'..."
    mv "${include_path}" "${new_include_path}"
  fi
done
