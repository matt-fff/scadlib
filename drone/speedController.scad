include <BOSL2/std.scad>;
use <scadlib/screws.scad>;


module screw_tab(
    thickness,
    width,
    height,
    anchor=CENTER,
    edges=EDGES_ALL
) {
    difference(){
        cuboid(
            [
                thickness,
                height,
                width,
            ],
            anchor=anchor,
            rounding=0.5,
            edges=edges
        );
        up(width/2)
        yrot(90)
            m25_hole(thickness);
    }
}

module speed_controller(
    width,
    height,
    depth=9,
    shell_thickness=1.5,
    capacitor_height=12,
    wire_width=22,
    wire_depth=6,
    screw_tabs=false
) {
    double_thick = 2 * shell_thickness;
    if (screw_tabs) {
        tab_height = 8;
        tab_width = 7;
        
        // capacitor tabs
        fwd((height + tab_height)/2 - 1)
        up(shell_thickness + (depth - tab_width) / 2)
        union(){
            left((width + shell_thickness)/2)
                screw_tab(
                    shell_thickness,
                    tab_width,
                    tab_height,
                    anchor=BOTTOM
                );
            right((width + shell_thickness)/2)
                screw_tab(
                    shell_thickness,
                    tab_width,
                    tab_height,
                    anchor=BOTTOM
                );
        }
        
        tab_height = 7;
        tab_width = 9;
        
        // motor tabs
        back((height - tab_height)/2 + shell_thickness)
        down(depth - shell_thickness - 1)
        union(){
            left((width + shell_thickness)/2)
                screw_tab(
                    shell_thickness,
                    tab_width,
                    tab_height,
                    anchor=BOTTOM
                );
            right((width + shell_thickness)/2)
                screw_tab(
                    shell_thickness,
                    tab_width,
                    tab_height,
                    anchor=BOTTOM
                );
        }
        
    }
    
    difference() {
        // shell
        cuboid(
            [
                double_thick + width,
                double_thick + height,
                double_thick + depth
            ],
            anchor=BOTTOM,
            except=BACK,
            rounding=2
        );
        union() {
            up(shell_thickness)union() {
                // controller void
                cuboid(
                    [width, height, depth],
                    anchor=BOTTOM,
                    chamfer=1
                );
                // wire void
                back(shell_thickness * 2)
                up((depth - wire_depth) / 2)
                cuboid(
                    [
                        wire_width,
                        height,
                        wire_depth
                    ],
                    anchor=BOTTOM,
                    rounding=2
                );
                // label window
                back((height / 2) - 10)up(depth)
                cuboid(
                    [width, 6, shell_thickness],
                    anchor=BOTTOM+BACK,
                    edges="Z",
                    rounding=1
                );
            }
            // capacitor void
            fwd(capacitor_height * 2)
            cuboid(
                [
                    width,
                    capacitor_height * 2,
                    double_thick + depth
                ],
                anchor=BOTTOM,
                chamfer=2
                
            );
        }
    }
}

xrot(-90)speed_controller(27, 50, screw_tabs=true);