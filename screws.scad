include <BOSL2/std.scad>;

// for metric screws to self-cut threads
module screwTest() {
    depth = 5;
    height = 7;
    width = 55;
    difference() {
        cuboid([width,height,depth], rounding=3, edges="Z");
        union() {
            // m2
            left(width * 0.35)union(){
                cyl(d=2.2, h=depth);
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
                cyl(d=2.7, h=depth);
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
                cyl(d=3.2, h=depth);
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
                cyl(d=4.2, h=depth);
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
                cyl(d=5, h=depth);
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
module insertTest() {
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
module nutTest() {
    depth = 5;
    height = 9;
    width = 60;
    difference() {
        cuboid([width,height,depth], rounding=2, edges="Z");
        union() {
            // m2
            left(width * 0.36)union(){
                cyl(d=3, h=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(7)
                text3d(
                    "m2",
                    size=3
                );
                inset = 2;
                width = 4.5;
                height = 1.65;
                fwd(inset)cuboid(
                    [width, width + inset + 1.5, height]
                );
            }
            // m2.5
            left(width * 0.14)union(){
                cyl(d=3.5, h=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(10.5)
                text3d(
                    "m2.5",
                    size=3
                );
                inset = 2;
                width = 5.5;
                height = 2;
                fwd(inset)cuboid(
                    [width, width + inset + 1.5, height]
                );
            }
            // m3
            right(width * 0.035)union(){
                cyl(d=4, h=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(7.5)
                text3d(
                    "m3",
                    size=3
                );
                inset = 2;
                width = 6.5;
                height = 2.7;
                fwd(inset)cuboid(
                    [width, width + inset + 1.5, height]
                );
            }
            // m4
            right(width * 0.22)union(){
                cyl(d=5, h=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(8)
                text3d(
                    "m4",
                    size=3
                );
                inset = 3;
                width = 7.5;
                height = 3;
                fwd(inset)cuboid(
                    [width, width + inset + 1.5, height]
                );
            }
            // m5
            right(width * 0.41)union(){
                cyl(d=6, h=depth);
                up(depth * 0.5 - 1)
                fwd(1)
                left(8.5)
                text3d(
                    "m5",
                    size=3
                );
                inset = 3;
                width = 9;
                height = 3.3;
                fwd(inset)cuboid(
                    [width, width + inset + 1.5, height]
                );
            }
        }
    }
}



screwTest();
//fwd(13)insertTest();
//back(10)xrot(-90)nutTest();
