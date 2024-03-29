include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/face.scad>

DOOR_WIDTH = DIVISION_WIDTH;

module door(
    opening_depth,
    opening_width,
    opening_height,
    face_style=undef,
    carcas_thickness=undef,
    face_trim_thickness=undef,
    face_trim_material=undef,
    face_panel_thickness=undef,
    face_panel_material=undef,
    face_overlay=undef,
    face_width=undef,
    dado_depth=undef,
    part="door",
    explode=0
) {
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    face_trim_thickness = val_or_default(face_trim_thickness, FACE_THICKNESS);

    X(
      // TODO Might be bullshit
      carcas_thickness/2
    ) 
    Y(opening_depth - face_trim_thickness/2)
    X(-face_trim_thickness/2)
    g(){
        storage_face(
          face_style=face_style,
          opening_width=opening_width,
          opening_height=opening_height,
          trim_thickness=face_trim_thickness,
          trim_width=face_width,
          trim_material=face_trim_material,
          trim_overlay=face_overlay,
          panel_thickness=face_panel_thickness,
          panel_material=face_panel_material,
          part=part
        );
    }
    children();
}
