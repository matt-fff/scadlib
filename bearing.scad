use <BOSL2/std.scad>

module bearing(
    depth,
    innerDiam,
    outerDiam,
    chamfer=0.25
){
    difference(){
        cyl(
            d=outerDiam,
            h=depth, 
            chamfer=chamfer
        );
        cyl(
            d=innerDiam,
            h=depth,
            chamfer=-chamfer
        );
    }
}

module bearingHolder(
    depth,
    innerDiam,
    outerDiam,
    coverThick
) {
    halfDiam = (innerDiam + outerDiam)/2;
    difference(){
        down(coverThick)
        cyl(h=coverThick + depth, d=outerDiam + (coverThick * 2));
        union(){
            bearing(
                depth=depth + coverThick,
                innerDiam=innerDiam,
                outerDiam=outerDiam
            );
            down(depth/2 + coverThick)
            bearing(
                depth=coverThick + 1,
                innerDiam=halfDiam * 0.75,
                outerDiam=halfDiam * 1.25
            );
        }
    }
}

// For the midside 22mm ball bearings
bearingHolder(
    depth=8,
    innerDiam=8.12,
    outerDiam=22.1,
    coverThick=0.75
);
