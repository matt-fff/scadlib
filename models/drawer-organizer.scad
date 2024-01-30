include <openscad-tray/tray.scad>
include <constructive/constructive-compiled.scad>

height = 100 - 20;
width = 420;
depth = 280;
thickness = 4;

//tray(
//    [width, depth, height],
//    n_rows=[4,2,3],
//    n_columns=3,
//    rows=[false, false, [0.25, 0.5]],
//    columns=[0.25, 0.50],
//    thickness=thickness,
//    bottom_bevel_radius=2
//);
//
//
//right(width+10)

union(){
    tray(
        [width/2, depth/2, height],
        n_rows=[2,1],
        n_columns=2,
        thickness=thickness,
        bottom_bevel_radius=2
    );
    
    Y(depth/2)tray(
        [width/2, depth/2, height],
        n_rows=[2,1],
        n_columns=2,
        thickness=thickness,
        bottom_bevel_radius=2
    );

    right(width/2)
    union(){
        tray(
            [width/2, depth/2, height],
            n_rows=2,
            n_columns=1,
            thickness=thickness,
            bottom_bevel_radius=2
        );
        
        Y(depth/2)tray(
            [width/2, depth/2, height],
            n_rows=1,
            n_columns=1,
            thickness=thickness,
            bottom_bevel_radius=2
        );
    }
}