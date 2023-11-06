include <constructive/constructive-compiled.scad>
include <scadlib/common/utils.scad>


PIPE_DIAM = 21.5;
PIPE_MOUNT_DIAM = 78;
PIPE_THREAD_LEN = 21.5;
PIPE_WALL_WIDTH = 3;
COUPLER_DIAM = 31.5;
COUPLER_LEN = 35.5;

module pipe(
    length=102.5,
    diam=PIPE_DIAM,
    wall=PIPE_WALL_WIDTH,
){
    tube(
        d=diam,
        h=length,
        wall=wall
    );
    
//    threaded_rod(
////        d=diam,
//        l=length,
//        pitch=2,
//        $fa=1,
//        $fs=1,
//        end_len=1.5,
//        bevel=true
//    );
    children();
}

module coupler_duo(
    length=COUPLER_LEN,
    diam=COUPLER_DIAM,
    wall=COUPLER_DIAM-PIPE_DIAM,
    angle=90
){
    radius = diam/2;
    inner_radius = 0;
    bend_radius = length/2;

    angle_1 = 0;
    angle_2 = angle;
    // bend

    
    X(-diam)
    Z(-diam)
    turnYZ(90)
    difference() {
      // torus
      rotate_extrude()
      translate([bend_radius + radius, 0, 0])
      circle(r=radius);

      // torus cutout
      rotate_extrude()
      translate([bend_radius + radius, 0, 0])
      circle(r=inner_radius);

      mult = ((angle_2 - angle_1) <= 180) ? 1 : 0;

      // lower cutout
      rotate([0, 0, angle_1])
      translate(
        [
          -50 * mult,
          -100,
          -50
        ]
      )
      cube([100, 100, 100]);

      // upper cutout
      rotate([0, 0, angle_2])
      translate([-50 * mult, 0, -50])
      cube([100, 100, 100]);
    }
    children();
}

