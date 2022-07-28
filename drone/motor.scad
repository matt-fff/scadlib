include <BOSL2/std.scad>;
use <scadlib/screws.scad>;

module screw_holes(height, anchor=CENTER) {
    width1 = (13 + 18.5) / 2;
    width2 = (16 + 21.5) / 2;
    fwd(width1/2)
        m3_hole(height, self_cut=false, anchor=anchor);
    back(width1/2)
        m3_hole(height, self_cut=false, anchor=anchor);
    zrot(90)union() {
        fwd(width2/2)
            m3_hole(height, self_cut=false, anchor=anchor);
        back(width2/2)
            m3_hole(height, self_cut=false, anchor=anchor);
    }
}

module air_hole(height) {
    cuboid(
        // idk why the height needs bumped
        [8, 4, height * 1.01],
        anchor=BOTTOM,
        edges="Z",
        rounding=2
    );
}

module air_holes(height) {
    width = (13 + 22.5) / 2;
    fwd(width/2)air_hole(height);
    back(width/2)air_hole(height);
    zrot(90)union() {
        fwd(width/2)air_hole(height);
        back(width/2)air_hole(height);
    }
}


module motor_mount(
    motor_diam=28,
    shell_thickness=1.5,
    shell_lip=5,
    wire_width=7,
){
    double_thick = shell_thickness * 2;
    difference() {
        // shell
        cyl(
            d=motor_diam + double_thick,
            h=shell_lip + shell_thickness,
            anchor=BOTTOM,
            chamfer2=1
        );
        up(shell_thickness)union() {
            // motor negative space
            cyl(
                d=motor_diam,
                h=shell_lip + shell_thickness,
                anchor=BOTTOM,
                chamfer=1
            );
            // wire negative space
            fwd(shell_thickness)cuboid(
            [
                wire_width,
                motor_diam,
                shell_lip + shell_thickness
            ], anchor=BOTTOM);

            // holes
            down(shell_thickness)union() {
                // m3 screw holes
                zrot(-45)
                    screw_holes(shell_thickness, anchor=BOTTOM);
                // air holes
                air_holes(shell_thickness);
            }
        }
    }
}

motor_mount();
