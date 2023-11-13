
include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/carcas.scad>
include <scadlib/cabinet/face.scad>
include <scadlib/cabinet/storage.scad>
include <scadlib/cabinet/kick_plate.scad>
include <scadlib/cabinet/top.scad>
include <scadlib/cabinet/back_panel.scad>

module cabinet(
        depth=undef,
        height=undef,
        width=undef,
        kick_height=undef,
        top_thickness=undef,
        face_width=undef,
        face_thickness=undef,
        carcas_thickness=undef,
        drawer_height=undef,
        panel_thickness=undef,
        dado_depth=undef,
        divisions=undef,
        explode=0,
        hide=""
){
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT);
    width = val_or_default(width, TOT_WIDTH);
    kick_height = val_or_default(kick_height, KICK_HEIGHT);
    top_thickness = val_or_default(top_thickness, TOP_THICKNESS);
    face_width = val_or_default(face_width, FACE_WIDTH);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    drawer_height = val_or_default(drawer_height, DRAWER_HEIGHT);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    dado_depth = val_or_default(dado_depth, DADO_DEPTH);
    divisions = val_or_default(divisions, DIVISIONS);
    division_width = width / len(divisions);

    col1 = pink;
    col2 = red;
    col3 = orange;
    explode_offset = explode * 150;

    // OVERLAY COMPONENTS
    // These are parts that have to have context 
    // on the overall cabinet layout
    if(!in("kick", hide)) {
      Z(-explode_offset)
      TODOWN()
      kick_plate(
          depth=depth,
          height=kick_height,
          width=width,
          divisions=divisions
      );
    }
    if(!in("top", hide)) {
      Z(explode_offset)
      clear()
      Z(
          height -
          kick_height -
          top_thickness/2
      )
      top(
          depth=depth,
          width=width,
          thickness=top_thickness
      );
    }
    if(!in("face", hide)) {
      Y(explode_offset)
      clear(beige)
      face(
          depth=depth,
          height=height - kick_height - top_thickness,
          width=width,
          face_thickness=face_thickness,
          face_width=face_width,
          divisions=divisions,
          carcas_thickness=carcas_thickness
      );
    }

    // MODULAR COMPONENTS
    // These are parts that only need
    // to know their own dimensions
    if(!in("carcas", hide)) {
      clear()
      carcas(
          depth=depth,
          height=height - kick_height - top_thickness,
          width=width,
          face_width=face_width,
          face_thickness=face_thickness,
          carcas_thickness=carcas_thickness,
          drawer_height=drawer_height,
          panel_thickness=panel_thickness,
          dado_depth=dado_depth,
          divisions=divisions,
          explode=explode
      );
    }
    if(!in("back_panel", hide)) {
      back_panel_set(
          height=height - kick_height - top_thickness,
          width=width,
          carcas_thickness=carcas_thickness,
          panel_thickness=panel_thickness,
          dado_depth=dado_depth,
          divisions=divisions,
          explode=explode
      );
    }
    if(!in("storage", hide)) {
      clear(gold)
      storage(
        depth=depth,
        height=height - kick_height - top_thickness,
        width=width,
        face_width=face_width,
        face_trim_thickness=face_thickness,
        drawer_height=drawer_height,
        dado_depth=dado_depth,
        panel_thickness=panel_thickness,
        carcas_thickness=carcas_thickness,
        divisions=divisions,
        hide=hide,
        explode=explode
      );
    }
}
