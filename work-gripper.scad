include <BOSL2/std.scad>;

depth = 25;
core_depth = 20;
core_diam = 75.80;
pad_depth = 5;
pad_diam = 69; // nice...
pad_rounding = 1.5;
pad_inset = -(
        depth - 
        core_depth - 
        (pad_depth * 2)
    ) / 2;
    
module pad() {
    tex = texture("trunc_pyramids_vnf");
    cyl(
        h=pad_depth,
        r=pad_diam/2,
        rounding=pad_rounding,
        texture="trunc_pyramids_vnf",
        tex_size=[1,1],
        tex_style="concave"
    );
//    rotate_sweep(
//        circle(d=pad_diam),
//        h=pad_depth,
//        tex_size=[1,1]
//    );
}

module pads() {
    // top pad
    up(depth / 2 - pad_inset)
    pad();

    // bottom pad
    down(depth / 2 - pad_inset)
    pad();
}

// core
//difference() {
//    cyl(d=core_diam, h=core_depth, rounding=4);
//    pads();
//}
pads();