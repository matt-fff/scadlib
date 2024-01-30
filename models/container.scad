module container(
    width,
    depth,
    height,
    wall_width
){

    difference(){
        cube([width, depth, height]);
        translate([
            wall_width,
            wall_width,  
            wall_width]
        )cube(
          [
            width - 2 * wall_width,
            depth - 2 * wall_width,
            height
          ]
        );
    }
}

function inch_to_mm(inches) = inches * 25.4;

width = inch_to_mm(3.0);
depth = inch_to_mm(3.75);
height = 70;
wall_width = inch_to_mm(0.07);

container(
    width,
    depth,
    height,
    wall_width
);

scale = 0.985;
/*
translate([
    wall_width * scale,
    wall_width * scale,
    -wall_width]
)cube([
    width - 2 * wall_width,
    depth - 2 * wall_width,
    wall_width
]);*/

bottom_width = (width - 2 * wall_width);

bottom_depth = (depth - 2 * wall_width);

translate([
    wall_width,
    wall_width,
    -wall_width]
)polyhedron(
  [
  [ bottom_width * (1-scale),
    bottom_depth * (1-scale),
    0
  ],  //0
  [ bottom_width * scale,  bottom_depth * (1-scale),  0 ],  //1
  [ bottom_width * scale,  bottom_depth * scale,  0 ],  //2
  [  bottom_width * (1-scale),  bottom_depth * scale,  0 ],  //3
  [  0,  0,  wall_width ],  //4
  [ bottom_width,  0,  wall_width ],  //5
  [ bottom_width,  bottom_depth,  wall_width ],  //6
  [  0,  bottom_depth,  wall_width ]],
  
  [[0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]
 );