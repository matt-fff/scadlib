#!/bin/bash

find models \
	-type f \
	-iregex '.*\.scad' \
	-exec sh -c \
	'f="$1"; base=$(basename "$f" .scad); openscad "$f" -o "exports/stl/${base}.stl"' \
	shell {} \;
