#!/bin/bash

find . -type f -iregex '.*\.scad' | \
xargs -I{} -n 1 openscad {} -o exports/stl/{}.stl

find . -type f -iregex '.*\.scad\.stl' | \
sed -E 's/(.*)(\.scad\.stl)/\0 \1.stl/ig' |
xargs -n 2 mv

