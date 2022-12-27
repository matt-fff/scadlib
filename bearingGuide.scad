use <BOSL2/std.scad>
use <scadlib/bearing.scad>;

module bearing_guide(
    depth,
    inner_diam,
    outer_diam,
    cover_thick,
    guide_center_offset=0,
    guide_edge_offset=0
) {
    half_height = cover_thick + depth / 2;
    guide_center_diam = outer_diam + cover_thick + guide_center_offset;
    guide_edge_diam = outer_diam + cover_thick + guide_edge_offset;
    difference(){
        down(cover_thick)
        union(){
            cyl(
                h=half_height,
                d2=guide_center_diam,
                d1=guide_edge_diam,
                circum=true
            );
            up(half_height)
            cyl(
                h=half_height,
                d1=guide_center_diam,
                d2=guide_edge_diam,
                circum=true
            );
        }
        union(){
            cyl(
                h=depth + cover_thick,
                d=outer_diam,
                circum=true,
                chamfer=0.25
            );
            cyl(
                h=(depth + cover_thick) * 2,
                d=inner_diam,
                circum=true
            );
        }
    }
}


bearing_guide(
    depth=7,
    inner_diam=7,
    outer_diam=21.95,
    cover_thick=1.5,
    guide_edge_offset=5
);
