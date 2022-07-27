include <BOSL2/std.scad>

width = 1000;

cuboid([width, width/25, 20], rounding=10, teardrop=true);
cuboid([width/25, width, 20], rounding=10, teardrop=true);
