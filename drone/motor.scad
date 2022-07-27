include <BOSL2/std.scad>

module m3Hole(height) {
    cyl(
        d=3.4,
        h=height,
        anchor=BOTTOM
    );
}

module screwHoles(height) {
    width1 = (13 + 18.5) / 2;
    width2 = (16 + 21.5) / 2;
    fwd(width1/2)
        m3Hole(height);
    back(width1/2)
        m3Hole(height);
    zrot(90)union() {
        fwd(width2/2)
            m3Hole(height);
        back(width2/2)
            m3Hole(height);
    }
}

module airHole(height) {
    cuboid(
        // idk why the height needs bumped
        [8, 4, height * 1.01],
        anchor=BOTTOM,
        edges="Z",
        rounding=2
    );
}

module airHoles(height) {
    width = (13 + 22.5) / 2;
    fwd(width/2)airHole(height);
    back(width/2)airHole(height);
    zrot(90)union() {
        fwd(width/2)airHole(height);
        back(width/2)airHole(height);
    }
}


module motorMount(
    motorDiam=28,
    shellThickness=1.5,
    shellLip=6,
    wireWidth=7,
){
    doubleThick = shellThickness * 2;
    difference() {
        // shell
        cyl(
            d=motorDiam + doubleThick,
            h=shellLip + shellThickness,
            anchor=BOTTOM,
            chamfer2=1
        );
        up(shellThickness)union() {
            // motor negative space
            cyl(
                d=motorDiam,
                h=shellLip + shellThickness,
                anchor=BOTTOM,
                chamfer=1
            );
            // wire negative space
            fwd(shellThickness)cuboid(
            [
                wireWidth,
                motorDiam,
                shellLip + shellThickness
            ], anchor=BOTTOM);

            // holes
            down(shellThickness)union() {
                // m3 screw holes
                zrot(-45)
                    screwHoles(shellThickness);
                // air holes
                airHoles(shellThickness);
            }
        }
    }
}

motorMount();
