include <scadlib/cabinet/cabinet.scad>
include <scadlib/cabinet/const.scad>

cabinet(
  width=inch_to_mm(72),
  face_width=inch_to_mm(1.685),
  divisions=[
    [[DOOR, 0.75, SHAKER],
      [DRAWER, 0.25, SHAKER]],

    [[DRAWER, 0.25, SHAKER],
      [DRAWER, 0.25, SHAKER],
      [DOUBLE_DOOR, 0.50, SHAKER]],

    [[DOOR, 0.75, SHAKER],
      [DRAWER, 0.25, SHAKER]],
  ],
  explode=0,
  hide=[]
);

