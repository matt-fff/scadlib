include <scadlib/common/screws.scad>
include <BOSL2/std.scad>;

module set_collar(height=3, in_diam=2.8, out_diam=6) {

  difference() {
    cyl(d=out_diam, h=height);
    cyl(d=in_diam, h=height*1.01);

    left(in_diam/2.01)
    rotate([0, 90, 0])
    m25_hole(height=(out_diam-in_diam)*1.1, self_cut=true);
  }
}

set_collar();
