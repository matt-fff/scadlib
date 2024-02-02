include <scadlib/common/utils.scad>
include <bladegen/bladegen.scad>
include <BOSL2/std.scad>
include <BOSL2/turtle3d.scad>
include <BOSL2/skin.scad>


function blade_outline(
  thickness,
  cheek_width,
  bevel_len
) = 
  assert(
    bevel_len*2 > thickness,
    "Bevel length must be more than twice the blade thickness"
  )
  let(
    point_angle = acos(
      (2*pow(bevel_len, 2) - pow(thickness, 2))
      /
      (2*pow(bevel_len, 2))
    ),
    bevel_angle = (180 - point_angle)/2,
    poly = turtle([
      "move", thickness,
      "turn",
      "move", cheek_width, 
      "angle", 90-bevel_angle, "turn",
      "move", bevel_len,
      "angle", 180-point_angle, "turn",
      "move", bevel_len,
      "angle", 90-bevel_angle, "turn",
      "move", cheek_width
    ])
  )
  poly;

module handle_guard(
  coeff,
  angle,
  diam
){
  // The Guard
  rotate([0,-90,90])
  union(){
    sweep(
      egg(diam*1.01, diam/2, diam/2, 60),
      turtle3d([
          // TODO try to make this more gradual so that it prints cleaner
          ["move", coeff*0.05, "grow", 1.15, "steps", 20], 
          ["move", coeff*0.1, "grow", 1.15, "steps", 20], 
          "move", coeff*0.1,
          ["arc", coeff, "up", angle, "steps", 80],
          ["move", coeff*0.6, "grow", 1.05, "steps", 20],
          ["move", coeff*0.1, "grow", 1.07, "steps", 20], 
          ["move", coeff*0.05, "grow", 1.05, "steps", 20], 
          ["move", coeff*0.05, "shrink", 1.05, "steps", 20], 
          ["move", coeff*0.05, "shrink", 1.05, "steps", 20], 
          ["move", coeff*0.01, "shrink", 1.05, "steps", 20], 
          ["move", coeff*0.01, "shrink", 1.05, "steps", 20], 
          ["move", coeff*0.01, "shrink", 1.05, "steps", 20], 
        ],
        state=RIGHT,
        transforms=true
      )
    );

    bolt_height = diam*1.5;
    // The guard bolts
    
    // Bullshit translation
    translate([coeff/1.3, 0, 0])
    rotate([0,90, 90])
    cyl(
      h=bolt_height,
      d=inch_to_mm(0.25),
      rounding=3
    );
  }
}

module handle_interlock(
  length,
  diam,
  male=false,
  margin_ratio=0.02,
  magnet_diam=8,
  magnet_depth=6
){
    multiplier = male ? -1: 1;
    size_adj = 1 + margin_ratio*multiplier;
     
    difference(){
      cyl(
        h=length*size_adj,
        d=diam*size_adj
      );

      if(male){
        translate([0, 0, (magnet_diam/2)*multiplier])
        rotate([0,90,0])
        cyl(h=diam, d=magnet_diam);
      }
    }
    translate([0, 0, (magnet_diam/2)*multiplier])
    rotate([0,90,0])
    cyl(h=diam+(magnet_depth*2*multiplier*size_adj), d=magnet_diam);

    children();
}

module handle_half(
  length,
  diam,
  guard_angle,
  wall_thickness=inch_to_mm(0.2),
  male=false
) {

  core_len = length * 0.7;

  interlock_len = core_len/2-wall_thickness;
  interlock_diam = diam-wall_thickness*2;

  union(){
    translate([0, 0, core_len/4])
    union(){
      difference(){

        // Handle
        cyl(
          h=core_len/2,
          d=diam
        );

        // Void for interlock
        if(!male) {
          translate([0, 0, -wall_thickness])
          handle_interlock(interlock_len, interlock_diam, male=male);
        }
      }

      // Extension for interlock
      if(male) {
        translate([0, 0, -core_len/2+wall_thickness])
        handle_interlock(interlock_len, interlock_diam, male=male);
      }
    }

    guard_coeff = (length - core_len) / 2;

    translate([0, 0, core_len/2-1])
    handle_guard(
      coeff=guard_coeff,
      angle=guard_angle,
      diam=diam
    );
  }
}

module blade_half(
  thickness=10,
  cheek_width=12,
  bevel_len=20,
  explode=0
){

  blade_poly = blade_outline(
    bevel_len=bevel_len,
    cheek_width=cheek_width,
    thickness=thickness
  );
  total_width = cheek_width + sqrt(pow(bevel_len, 2) - 0.25*pow(thickness, 2));


  translate([0, -total_width/2, thickness/2])
  sweep(
    polygon_parts(blade_poly),
    turtle3d(
      [
          ["arc", 40, "right", 10, "steps", 20],
          ["arc", 80, "right", 30, "grow", 1.1, "steps", 20],
          ["arc", 140, "right", 60, "shrink", 1.5, "steps", 100],
          ["arc", 90, "right", 20, "shrink", 2, "steps", 100],
          ["arc", 90, "right", 5, "shrink", 2.4, "steps", 100],
          ["arc", 20, "right", 10, "shrink", 10, "steps", 100]
      ],
      state=RIGHT,
      transforms=true
    )
  );
}

module dagger_half(
  handle_len=inch_to_mm(4.5),
  handle_diam=inch_to_mm(1),
  guard_angle=25,
  blade_thickness=inch_to_mm(0.62),
  blade_cheek_width=12,
  blade_bevel_len=20,
  male=false,
  explode=0,
) {
  blade_void_mult = 1.05;
  total_blade_width = blade_cheek_width + 
    sqrt(pow(blade_bevel_len, 2) - 
    0.25*pow(blade_thickness, 2));

  difference() {
    rotate([0,90,0])
    handle_half(
      length=handle_len,
      diam=handle_diam,
      guard_angle=guard_angle,
      male=male
    );

    rotate([0,0,-guard_angle])
    // NOTE These translate numbers are bullshit
    translate([
      handle_len/2,
      (total_blade_width + blade_cheek_width)/2,
      0
    ])
    blade_half(
      thickness=blade_thickness*blade_void_mult,
      cheek_width=blade_cheek_width*blade_void_mult,
      bevel_len=blade_bevel_len*blade_void_mult
    );
  }

  split = explode*30;
  rotate([0,0,-guard_angle])
  // NOTE These translate numbers are bullshit
  translate([
    handle_len/2 + split,
    (total_blade_width + blade_cheek_width)/2,
    0
  ])
  blade_half(
    thickness=blade_thickness,
    cheek_width=blade_cheek_width,
    bevel_len=blade_bevel_len
  );
}

module double_dagger(
  handle_len=inch_to_mm(4.5),
  handle_diam=inch_to_mm(1),
  explode=0
) {
  split = explode * 50;
  
  translate([split, 0, 0])
  dagger_half(
    handle_len=handle_len,
    handle_diam=handle_diam,
    male=false,
    explode=explode
  );

  translate([-split, 0, 0])
  mirror([1, 0, 0])
  dagger_half(
    handle_len=handle_len,
    handle_diam=handle_diam,
    male=true,
    explode=explode
  );
}

double_dagger(explode=0.4);
