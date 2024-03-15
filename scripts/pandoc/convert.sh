#!/bin/sh

pandoc "${1}" \
  --lua-filter pagebreak.lua \
  --output "generated/$(basename "${1}" .md).docx" \
  --reference-doc reference.docx \
  --standalone
