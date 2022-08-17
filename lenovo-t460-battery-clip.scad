include <BOSL2/std.scad>;

width = 7.67;
height = 13.42;
depth = 1.1;

cuboid(
    [
        width,
        height,
        depth
    ],
    anchor=BOTTOM,
    rounding=0.5,
    edges="Z"
);

tab_width = 0.9;
tab_height = 2.76;
tab_depth = 5.8;
tab_offset = 4.4 / 2;
tab_latch_width = 1.35;
tab_latch_depth = 1.45;


module tab() {
    cuboid(
        [
            tab_width,
            tab_height,
            tab_depth
        ],
        anchor=BOTTOM,
        rounding=0.2
    );
    yrot(25)
    left(tab_width)
    cuboid(
        [
            tab_width,
            tab_height,
            tab_depth * 0.38
        ],
        anchor=BOTTOM,
        rounding=0.2
    );
    up(tab_depth - tab_latch_depth)
    left((tab_latch_width - tab_width) / 2)
    difference() {
        cuboid(
            [
                tab_latch_width,
                tab_height,
                tab_latch_depth
            ],
            anchor=BOTTOM,
            rounding=0.2
        );
        up(tab_latch_depth * 3/4)
        left(tab_latch_width)
        yrot(45)
        cuboid(
            [
                tab_latch_width,
                tab_height,
                tab_latch_depth
            ],
            anchor=BOTTOM
        );
        
        
    }
}


left(tab_offset)tab();
right(tab_offset)zrot(180)tab();