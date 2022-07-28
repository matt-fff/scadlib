include <BOSL2/std.scad>;
use <scadlib/screws.scad>;


module screwTab(thickness, width, height) {
    difference(){
        cuboid(
            [
                thickness,
                height,
                width,
            ],
            anchor=BOTTOM,
            rounding=0.5,
            except=BACK
        );
        up(width/2)
        yrot(90)
            m25Hole(thickness);
    }
}

module speedController(
    width,
    height,
    depth=9,
    shellThickness=1.5,
    capacitorHeight=12,
    wireWidth=22,
    wireDepth=6,
    screwTabs=false
) {
    doubleThick = 2 * shellThickness;
    if (screwTabs) {
        tabHeight = 8;
        tabWidth = 7;
        
        // capacitor tabs
        fwd((height + tabHeight)/2 - 1)
        up(shellThickness + (depth - tabWidth) / 2)
        union(){
            left((width + shellThickness)/2)
                screwTab(
                    shellThickness,
                    tabWidth,
                    tabHeight
                );
            right((width + shellThickness)/2)
                screwTab(
                    shellThickness,
                    tabWidth,
                    tabHeight
                );
        }
        
        tabHeight = 7;
        tabWidth = 9;
        
        // motor tabs
        back((height - tabHeight)/2 + shellThickness)
        down(depth - shellThickness - 1)
        union(){
            left((width + shellThickness)/2)
                screwTab(
                    shellThickness,
                    tabWidth,
                    tabHeight
                );
            right((width + shellThickness)/2)
                screwTab(
                    shellThickness,
                    tabWidth,
                    tabHeight
                );
        }
        
    }
    
    difference() {
        // shell
        cuboid(
            [
                doubleThick + width,
                doubleThick + height,
                doubleThick + depth
            ],
            anchor=BOTTOM,
            except=BACK,
            rounding=2
        );
        union() {
            up(shellThickness)union() {
                // controller void
                cuboid(
                    [width, height, depth],
                    anchor=BOTTOM,
                    chamfer=1
                );
                // wire void
                back(shellThickness * 2)
                up((depth - wireDepth) / 2)
                cuboid(
                    [
                        wireWidth,
                        height,
                        wireDepth
                    ],
                    anchor=BOTTOM,
                    rounding=2
                );
                // label window
                back((height / 2) - 10)up(depth)
                cuboid(
                    [width, 6, shellThickness],
                    anchor=BOTTOM+BACK,
                    edges="Z",
                    rounding=1
                );
            }
            // capacitor void
            fwd(capacitorHeight * 2)
            cuboid(
                [
                    width,
                    capacitorHeight * 2,
                    doubleThick + depth
                ],
                anchor=BOTTOM,
                chamfer=2
                
            );
        }
    }
}

xrot(-90)speedController(27, 50, screwTabs=true);