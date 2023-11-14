include <scadlib/cabinet/cabinet.scad>
include <scadlib/cabinet/const.scad>

cabinet(
  width=inch_to_mm(72),
  face_width=inch_to_mm(1.685),
  divisions=[
    [[DOOR, 0.75],
      [DRAWER, 0.25]],

    [[DRAWER, 0.25],
      [DRAWER, 0.25],
      [DOUBLE_DOOR, 0.50]],

    [[DOOR, 0.75],
      [DRAWER, 0.25]],
  ],
  explode=0,
  hide=[]
);

