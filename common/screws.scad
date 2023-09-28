include <BOSL2/std.scad>;

module m2_hole(height, self_cut=true, anchor=CENTER) {
    diam = (self_cut) ? 2.2 : 3;
    cyl(
        d=diam,
        h=height,
        anchor=anchor
    );
}

module m25_hole(height, self_cut=true, anchor=CENTER) {
    diam = (self_cut) ? 2.7 : 3.5;
    cyl(
        d=diam,
        h=height,
        anchor=anchor
    );
}

module m3_hole(height, self_cut=true, anchor=CENTER) {
    diam = (self_cut) ? 3.2 : 4;
    cyl(
        d=diam,
        h=height,
        anchor=anchor
    );
}

module m4_hole(height, self_cut=true, anchor=CENTER) {
    diam = (self_cut) ? 4.2 : 5;
    cyl(
        d=diam,
        h=height,
        anchor=anchor
    );
}

module m5_hole(height, self_cut=true, anchor=CENTER) {
    diam = (self_cut) ? 5 : 6;
    cyl(
        d=diam,
        h=height,
        anchor=anchor
    );
}

module m2_captive_nut(height, inset=2, anchor=CENTER) {
    width = 4.5;
    cuboid(
        [width, width + inset + 1.5, height],
        anchor=anchor
    );
}

module m25_captive_nut(height, inset=2, anchor=CENTER) {
    width = 5.5;
    cuboid(
        [width, width + inset + 1.5, height],
        anchor=anchor
    );
}

module m3_captive_nut(height, inset=2, anchor=CENTER) {
    width = 6.5;
    cuboid(
        [width, width + inset + 1.5, height],
        anchor=anchor
    );
}

module m4_captive_nut(height, inset=3, anchor=CENTER) {
    width = 7.5;
    cuboid(
        [width, width + inset + 1.5, height],
        anchor=anchor
    );
}

module m5_captive_nut(height, inset=3, anchor=CENTER) {
    width = 9;
    cuboid(
        [width, width + inset + 1.5, height],
        anchor=anchor
    );
}

// for metric screws to self-cut threads
module screw_test() {
    depth = 5;
    height = 7;
    width = 55;
    difference() {
        cuboid([width,height,depth], rounding=3, edges="Z");
        union() {
            // m2
            left(width * 0.35)union(){
                m2_hole(height=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(7)
                text3d(
                    "m2",
                    size=3
                );
            }
            // m2.5
            left(width * 0.12)union(){
                m25_hole(height=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(10.5)
                text3d(
                    "m2.5",
                    size=3
                );
            }
            // m3
            right(width * 0.05)union(){
                m3_hole(height=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(7.5)
                text3d(
                    "m3",
                    size=3
                );
            }
            // m4
            right(width * 0.23)union(){
                m4_hole(height=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(8)
                text3d(
                    "m4",
                    size=3
                );
            }
            // m5
            right(width * 0.43)union(){
                m5_hole(height=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(8.5)
                text3d(
                    "m5",
                    size=3
                );
            }
        }
    }
}




// for metric screw inserts (hilitchi)
module insert_test() {
    depth = 10;
    height = 10;
    width = 50;
    difference() {
        cuboid([width,height,depth], rounding=3, edges="Z");
        union() {
            // m2
            left(width * 0.33)union(){
                cyl(d=3.5, h=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(8)
                text3d(
                    "m2",
                    size=3
                );
            }
            // m3
            left(width * 0.11)union(){
                cyl(d=5, h=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(8.5)
                text3d(
                    "m3",
                    size=3
                );
            }
            // m4
            right(width * 0.14)union(){
                cyl(d=6, h=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(9)
                text3d(
                    "m4",
                    size=3
                );
            }
            // m5
            right(width * 0.4)union(){
                cyl(d=6.9, h=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(9.5)
                text3d(
                    "m5",
                    size=3
                );
            }
        }
    }
}


// for testing captive metric screw nuts
module nut_test() {
    depth = 5;
    height = 9;
    width = 60;
    difference() {
        cuboid([width,height,depth], rounding=2, edges="Z");
        union() {
            // m2
            left(width * 0.36)union(){
                m2_hole(height=depth, self_cut=false);
                up(depth * 0.5 - 1)
                fwd(1)
                left(7)
                text3d(
                    "m2",
                    size=3
                );
                inset = 2;
                height = 1.65;
                fwd(inset)m2_captive_nut(height, inset);
                
            }
            // m2.5
            left(width * 0.14)union(){
                m25_hole(height=depth, self_cut=false);
                up(depth * 0.5 - 1)
                fwd(1)
                left(10.5)
                text3d(
                    "m2.5",
                    size=3
                );
                inset = 2;
                height = 2;
                fwd(inset)m25_captive_nut(height, inset);
            }
            // m3
            right(width * 0.035)union(){
                m3_hole(height=depth, self_cut=false);
                up(depth * 0.5 - 1)
                fwd(1)
                left(7.5)
                text3d(
                    "m3",
                    size=3
                );
                inset = 2;
                height = 2.7;
                fwd(inset)m3_captive_nut(height, inset);
            }
            // m4
            right(width * 0.22)union(){
                m4_hole(height=depth, self_cut=false);
                up(depth * 0.5 - 1)
                fwd(1)
                left(8)
                text3d(
                    "m4",
                    size=3
                );
                inset = 3;
                height = 3;
                fwd(inset)m4_captive_nut(height, inset);
            }
            // m5
            right(width * 0.41)union(){
                m5_hole(height=depth, self_cut=false);
                up(depth * 0.5 - 1)
                fwd(1)
                left(8.5)
                text3d(
                    "m5",
                    size=3
                );
                inset = 3;
                height = 3.3;
                fwd(inset)m5_captive_nut(height, inset);
            }
        }
    }
}

module screw_demo() {
    screw_test();
    fwd(25)insert_test();
    back(25)zrot(180)xrot(-9)nut_test();
}

screw_demo();