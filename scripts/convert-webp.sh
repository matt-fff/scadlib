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
	-iregex ".*\.(png|jpg)" \
	-exec cwebp -q 100 {} -o {}.webp \;

# Fix the webp copy locations
find "${targetFolder}" \
	-type f \
	-regextype posix-extended \
	-iregex ".*\.(png|jpg)\.webp" \
	-exec sh -c 'for f; do mv "$f" "${f%.*}.webp"; done' sh {} +
