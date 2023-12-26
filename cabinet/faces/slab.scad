include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/cabinet/defaults.scad>

TENON_DEPTH = DADO_DEPTH * 3;
TENON_THICKNESS = FACE_THICKNESS / 3;

// This multiplier is necessary due to 
// floating point rounding
FLOAT_COEFF = 1.0001;

module slab_face(
  opening_width,
  opening_height,
  face_overlay=undef,
  thickness=undef,
  material=undef,
  part="face",
  should_log=true,
  hide=[]
){
  face_overlay = val_or_default(face_overlay, FACE_OVERLAY);
  thickness = val_or_default(thickness, FACE_THICKNESS);
  material = val_or_default(material, FACE_MATERIAL);

  face_width = opening_width + 2*face_overlay;
  face_height = opening_height + 2*face_overlay;

  Z(opening_height/2)
  assemble(
    fmt_parts(["slab-face"], hide)
  )autoColor() {
    X((opening_width/2))
    g(){
      logbox(
        thickness,
        x=face_width,
        h=face_height,
        part=part,
        subpart="face",
        material=material,
        should_log=should_log
      );
    }
  }

  children();
}

