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
cut_margin = 5;
    
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

        up(cut_margin/2)
        difference() {
          rgn = [
              right(
                  core_void_diam/2,
                  p=rect(
                      [
                          pad_diam/2 - core_void_diam/2,
                          pad_depth + cut_margin
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

          // Remove a flat section to create a good base for printing
          up(pad_depth)
          tube(
              h=pad_depth + cut_margin,
              id=core_void_diam - cut_margin,
              od=pad_diam + cut_margin
          );
        }
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
    rotate([0, 180, 0])
    pad(textured=textured);

    // bottom pad
    down(depth / 2 - pad_inset)
    pad(textured=textured);
}


PAD = 1;
CORE = 2;
FULL = 3;
module gripper(
  show=FULL,
  textured=true
) {
  difference() {
    union() {
      if (show == CORE || show == FULL) {
        difference() {
          cyl(d=core_diam, h=core_depth, rounding=4);
          pads(textured=false);
        }
      }
    
      if (show == PAD) {
        rotate([0, 180, 0])
        pad(textured=textured);
      }
      if (show == FULL) {
        pads(textured=textured);
      }
    }
    edge_height = core_depth + pad_depth*2 + cut_margin;
    translate([-core_diam/2, core_diam/2 - cut_margin, -edge_height/2])
    cube([core_diam, core_diam, edge_height]);
  }
}

textured=true;

gripper(show=PAD, textured=textured);

//right(core_diam*1.5)
//gripper(show=CORE, textured=textured);

//left(core_diam*1.5)
//gripper(show=FULL, textured=textured);
