#!/bin/bash

if [[ $# -eq 0 ]]; then
	echo "No arguments provided"
	exit 1
fi

targetFolder="$1"

# Make webp copies of everything
find "${targetFolder}" \
	-type f \
	-regextype posix-extended \
	-iregex ".*\.png" \
	-exec sh -c \
	'f="$1"; base=$(basename "$f" .png); cwebp -q 100 "$f" -o "exports/img/${base}.webp"' \
	shell {} \;
