#!/bin/bash


if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi


targetFolder="$1"

# Make webp copies of everything
find $targetFolder -type f -regextype posix-extended -iregex ".*\.(png|jpg)" | \
xargs -I{} -n 1 cwebp -q 100 {} -o {}.webp

# Fix the webp copy locations
find $targetFolder  -type f -regextype posix-extended -iregex ".*\.(png|jpg)\.webp" | 
sed -E 's/(.*)(\.(png|jpg)\.webp)/\0 \1.webp/gi' |
xargs -n 2 mv
