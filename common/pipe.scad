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
    children();
}

module coupler_quad(
    length=COUPLER_LEN,
    diam=COUPLER_DIAM,
    wall=PIPE_WALL_WIDTH,
) {
  assert(length >= diam, "Error: 'length' must be greater than or equal to 'diam'"); 

  g(){
    pipe(
      length=length,
      diam=diam,
      wall=wall
    );
    
    turnXZ(90)
    pipe(
      length=length,
      diam=diam,
      wall=wall
    );
  }
  children();
}

module coupler_trio(
    length=COUPLER_LEN,
    diam=COUPLER_DIAM,
    wall=PIPE_WALL_WIDTH,
) {
  assert(length >= diam, "Error: 'length' must be greater than or equal to 'diam'"); 

  g(
){
    pipe(
      length=length,
      diam=diam,
      wall=wall
    );
    
    internal_offset = 10;
    side_len = length / 2 + internal_offset;
    X((diam + side_len)/2 - internal_offset)
    turnXZ(90)
    pipe(
      length=side_len,
      diam=diam,
      wall=wall
    );
  }
  children();
}

module coupler_duo(
    length=COUPLER_LEN,
    diam=COUPLER_DIAM,
    wall=COUPLER_DIAM-PIPE_DIAM,
    bend_radius=2,
    angle=90
){
    radius = diam/2;
    inner_radius = (diam-wall) / 2;

    angle_1 = 0;
    angle_2 = angle;
    // bend

    
    X(radius)
    Z(-radius)
    turnYZ(90)
    difference() {
      // torus
      rotate_extrude()
      translate([bend_radius + radius, 0, 0])
      circle(r=radius);

      if (inner_radius > 0) {
        // torus cutout
        rotate_extrude()
        translate([bend_radius + radius, 0, 0])
        circle(r=inner_radius);
      }

      mult = ((angle_2 - angle_1) <= 180) ? 1 : 0;
      cut_side = max(length, diam*2) * 2;

      // lower cutout
      rotate([0, 0, angle_1])
      translate(
        [
          -cut_side/2 * mult,
          -cut_side/2,
          -diam
        ]
      )
      cube([cut_side, cut_side/2, diam*2]);

      // upper cutout
      rotate([0, 0, angle_2])
      translate(
        [
          -cut_side/2 * mult,
          -cut_side/2,
          -diam
        ]
      )
      cube([cut_side, cut_side/2, diam*2]);
    }
    children();
}

