#!/bin/bash

# set -o errexit
set -o nounset

readonly source_dir="${1}"
readonly output_dir="../output"

# Enable debug output for troubleshooting purposes
set -x

cd "/bp/${source_dir}"

# Find all main .tex files (containing the \documentclass command)
source_files=$(grep --files-with-match '\\documentclass' ./*.tex)

set +x

# Loop over all found .tex source files and compile
for latex_file in ${source_files}; do
  echo "========== Compiling ${latex_file} =========="
  set -x
  latexmk -f \
    -file-line-error \
    -interaction=nonstopmode \
    -output-directory="${output_dir}" \
    -shell-escape \
    -synctex=1 \
    -xelatex \
    "${latex_file}"
  set +x

  # # Run makeglossaries to process the glossary entries
  # echo "========== Processing glossaries for ${latex_file} =========="
  # set -x
  # makeglossaries -d "${output_dir}" "${latex_file%.*}"
  # set +x

  # # Re-run latexmk to include the processed glossary
  # echo "========== Re-compiling ${latex_file} with glossaries =========="
  # set -x
  # latexmk \
  #   -file-line-error \
  #   -interaction=nonstopmode \
  #   -output-directory="${output_dir}" \
  #   -shell-escape \
  #   -synctex=1 \
  #   -xelatex \
  #   -g \  # Force a full recompile
  #   "${latex_file}"
  # set +x
done
latexmk -c -output-directory="${output_dir}"
find "${output_dir}" -type f \( -name "*.bbl" -o -name "*.lol" -o -name "*.run.xml" -o -name "*.synctex.gz" -o -name "*.xdv" \) -exec rm -f {} +