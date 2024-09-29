use <BOSL2/std.scad>

module spool(
    depth,
    diam,
    chamfer=0.25
){
    cyl(
        d=diam,
        h=depth, 
        chamfer=chamfer,
        circum=true
    );
}

module spool_holder(
    depth,
    inner_diam,
    outer_diam,
    side_thick,
    spool_overlap
) {
    difference(){
        cyl(
            h=depth,
            d=outer_diam,
            circum=true
        );
        union(){
            up(side_thick)
            spool(
                depth=depth,
                diam=inner_diam
            );
            down(side_thick)
            spool(
                depth=depth + 1,
                diam=inner_diam - (spool_overlap * 2)
            );
        }
    }
}

$fn = 200;
// For the midside 22mm ball spools
spool_holder(
    depth=5,
    inner_diam=194,
    outer_diam=200,
    side_thick=1,
    spool_overlap=5
);
