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
            chamfer=chamfer,
            circum=true
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
        cyl(
            h=cover_thick + depth,
            d=outer_diam + (cover_thick * 2),
            circum=true
        );
        union(){
            bearing(
                depth=depth + cover_thick,
                inner_diam=inner_diam,
                outer_diam=outer_diam
            );
            down(depth/2 + cover_thick)
            bearing(
                depth=cover_thick + 1,
                inner_diam=half_diam * 0.80,
                outer_diam=half_diam * 1.20
            );
        }
    }
}

// For the midside 22mm ball bearings
bearing_holder(
    depth=7.5,
    inner_diam=8.35,
    outer_diam=21.95,
    cover_thick=0.75
);

// NOTE slice at 0.12 concentric
// For the small 7mm ball bearings
fwd(20)bearing_holder(
    depth=3,
    inner_diam=3.15,
    outer_diam=7.05,
    cover_thick=0.5
);

// For the super small 3mm ball bearings
fwd(30)bearing_holder(
    depth=1.5,
    inner_diam=0.9,
    outer_diam=2.9,
    cover_thick=0.5
);
