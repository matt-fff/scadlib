include <BOSL2/std.scad>;

width = 57.5;
height = 89;
depth = 0.3;

cuboid(
    [
        width,
        height,
        depth
    ],
    rounding=5,
    edges="Z"
);