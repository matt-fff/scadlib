include <BOSL2/std.scad>



module propeller(width, length){
    cuboid([width, width/25, 20], rounding=3, teardrop=true);
}

propeller(1000)