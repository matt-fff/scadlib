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
    
module pad(
    textured=true,
    core_void_diam=pad_diam/4,
    tex_inset=1,
) {
    if (textured) {
        tex_size = 4;
        tex = texture(
            "trunc_pyramids_vnf",
            inset=0.3
        );
        rgn = [
            right(
                core_void_diam/2,
                p=rect(
                    [
                        pad_diam/2 - core_void_diam/2,
                        pad_depth
                    ],
                    anchor=LEFT
                )
            )
        ];

        rotate_sweep(
            rgn, texture=tex,
            tex_size=[tex_size, tex_size],
            tex_inset=tex_inset,
            tex_rot=true,
            angle=360
        );
    } else {
        tube(
            h=pad_depth,
            id=core_void_diam,
            od=pad_diam
        );
    }
}

module pads(
    textured=true,
) {
    // top pad
    up(depth / 2 - pad_inset)
    pad(textured=textured);

    // bottom pad
    down(depth / 2 - pad_inset)
    pad(textured=textured);
}

// core
//difference() {
//    cyl(d=core_diam, h=core_depth, rounding=4);
//    pads(textured=false);
//}
//pads();
pad();