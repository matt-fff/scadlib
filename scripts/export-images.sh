#!/bin/bash

find models \
	-type f \
	-iregex '.*\.scad' \
	-exec sh -c \
	'f="$1"; base=$(basename "$f" .scad); openscad "$f" --render --viewall --autocenter --imgsize=1920,1080 -o "exports/img/${base}.png"' \
	shell {} \;
