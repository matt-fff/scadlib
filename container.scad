module container(
    width,
    depth,
    height,
    wallWidth
){

    difference(){
        cube([width, depth, height]);
        translate([
            wallWidth,
            wallWidth,  
            wallWidth]
        )cube(
          [
            width - 2 * wallWidth,
            depth - 2 * wallWidth,
            height
          ]
        );
    }
}

function inchToMm(inches) = inches * 25.4;

width = inchToMm(3.0);
depth = inchToMm(3.75);
height = 70;
wallWidth = inchToMm(0.07);

container(
    width,
    depth,
    height,
    wallWidth
);

scale = 0.985;
/*
translate([
    wallWidth * scale,
    wallWidth * scale,
    -wallWidth]
)cube([
    width - 2 * wallWidth,
    depth - 2 * wallWidth,
    wallWidth
]);*/

bottomWidth = (width - 2 * wallWidth);

bottomDepth = (depth - 2 * wallWidth);

translate([
    wallWidth,
    wallWidth,
    -wallWidth]
)polyhedron(
  [
  [ bottomWidth * (1-scale),
    bottomDepth * (1-scale),
    0
  ],  //0
  [ bottomWidth * scale,  bottomDepth * (1-scale),  0 ],  //1
  [ bottomWidth * scale,  bottomDepth * scale,  0 ],  //2
  [  bottomWidth * (1-scale),  bottomDepth * scale,  0 ],  //3
  [  0,  0,  wallWidth ],  //4
  [ bottomWidth,  0,  wallWidth ],  //5
  [ bottomWidth,  bottomDepth,  wallWidth ],  //6
  [  0,  bottomDepth,  wallWidth ]],
  
  [[0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]
 );