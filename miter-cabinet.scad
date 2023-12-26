include <scadlib/cabinet/cabinet.scad>
include <scadlib/cabinet/const.scad>


miter_depth = inch_to_mm(27.75);


cabinet(
  depth=inch_to_mm(12.75),
  width=inch_to_mm(157),
  face_width=inch_to_mm(1.685),
  face_overlay=0,
  storage_protrusion=0,
  explode=0,
  divisions=[
    [
      [DRAWER, 0.40, SLAB],
      [DRAWER, 0.20, SLAB],
      [DRAWER, 0.20, SLAB],
      [DRAWER, 0.20, SLAB],
    ],

    [
      [BLANK, 0.25],
      [BLANK, 0.25],
      [DOUBLE_DOOR, 0.50]
    ],
    
    [
      [DOOR, 0.333],
      [DOOR, 0.333],
      [DOOR, 0.333]
    ],


    [
      [DRAWER, 0.25],
      [DOOR, 0.75]
    ],

    [
      [DOUBLE_DOOR, 0.50],
      [DRAWER, 0.25],
      [DRAWER, 0.25]
    ],

    [
      [DOOR, 0.75],
      [DRAWER, 0.25]
    ]
  ],
  hide=[]
);

