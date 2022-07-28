use <BOSL2/std.scad>

module bearing(
    depth,
    inner_diam,
    outer_diam,
    chamfer=0.25
){
    difference(){
        cyl(
            d=outer_diam,
            h=depth, 
            chamfer=chamfer
        );
        cyl(
            d=inner_diam,
            h=depth,
            chamfer=-chamfer
        );
    }
}

module bearing_holder(
    depth,
    inner_diam,
    outer_diam,
    cover_thick
) {
    half_diam = (inner_diam + outer_diam)/2;
    difference(){
        down(cover_thick)
        cyl(h=cover_thick + depth, d=outer_diam + (cover_thick * 2));
        union(){
            bearing(
                depth=depth + cover_thick,
                inner_diam=inner_diam,
                outer_diam=outer_diam
            );
            down(depth/2 + cover_thick)
            bearing(
                depth=cover_thick + 1,
                inner_diam=half_diam * 0.75,
                outer_diam=half_diam * 1.25
            );
        }
    }
}

// For the midside 22mm ball bearings
bearing_holder(
    depth=8,
    inner_diam=8.35,
    outer_diam=22.05,
    cover_thick=0.75
);
