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
  shelf_dado_depth=0,
  has_storage_faceplate=false,
  uniform_carcas_widths=true,
  divisions=[
    [
      [BLANK, 0.19],
      [BLANK, 0.19],
      [BLANK, 0.19],
      [BLANK, 0.43],
    ],

    [
      [BLANK, 0.50],
      [BLANK, 0.25],
      [BLANK, 0.25],
    ],
    
    [
      [BLANK, 0.43],
      [BLANK, 0.19],
      [BLANK, 0.19],
      [BLANK, 0.19],
    ],

    [
      [BLANK, 0.25],
      [BLANK, 0.25],
      [BLANK, 0.50],
    ],

    [
      [BLANK, 0.43],
      [BLANK, 0.19],
      [BLANK, 0.19],
      [BLANK, 0.19],
    ],
    
    [
      [BLANK, 0.50],
      [BLANK, 0.25],
      [BLANK, 0.25],
    ],

    [
      [BLANK, 0.19],
      [BLANK, 0.19],
      [BLANK, 0.19],
      [BLANK, 0.43],
    ],
  ],
  hide=[]
);

