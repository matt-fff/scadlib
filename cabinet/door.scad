include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/shaker.scad>

DOOR_WIDTH = DIVISION_WIDTH;

module door(
    opening_depth,
    opening_width,
    opening_height,
    carcas_thickness=undef,
    face_trim_thickness=undef,
    face_trim_material=undef,
    face_panel_thickness=undef,
    face_panel_material=undef,
    face_overlay=undef,
    face_width=undef,
    dado_depth=undef
) {
    face_trim_thickness = val_or_default(face_trim_thickness, FACE_THICKNESS);
    face_trim_material = val_or_default(face_trim_material, FACE_MATERIAL);
    face_panel_thickness = val_or_default(face_panel_thickness, FACE_PANEL_THICKNESS);
    face_panel_material = val_or_default(face_panel_material, FACE_PANEL_MATERIAL);
    face_overlay = val_or_default(face_overlay, FACE_OVERLAY);
    face_width = val_or_default(face_width, FACE_WIDTH);
    part = "door";

    X(
      // TODO Might be bullshit
      carcas_thickness/2
    ) 
    Y(opening_depth)
    X(-face_trim_thickness/2)
    shaker_face(
      opening_width=opening_width,
      opening_height=opening_height,
      trim_thickness=face_trim_thickness,
      trim_width=face_width,
      trim_material=face_trim_material,
      trim_overlay=face_overlay,
      panel_thickness=face_panel_thickness,
      panel_material=face_panel_material,
      part="door_face"
    );
    children();
}
