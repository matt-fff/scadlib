include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/carcas.scad>
include <scadlib/cabinet/face.scad>
include <scadlib/cabinet/drawer.scad>
include <scadlib/cabinet/top.scad>

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
        open=false,
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

    if(!in("carcas", hide)) {
      carcas(
          depth=depth,
          height=height,
          width=width,
          kick_height=kick_height,
          top_thickness=top_thickness,
          face_width=face_width,
          face_thickness=face_thickness,
          carcas_thickness=carcas_thickness,
          drawer_height=drawer_height,
          panel_thickness=panel_thickness,
          dado_depth=dado_depth
      );
    }
    if(!in("drawer", hide)) {
      clear(orange)
      drawers(
        depth=depth,
        height=height,
        width=width,
        face_width=face_width,
        face_trim_thickness=face_thickness,
        drawer_height=drawer_height,
        dado_depth=dado_depth,
        panel_thickness=panel_thickness,
        carcas_thickness=carcas_thickness,
        top_thickness=top_thickness,
        open=open
      );
    }
    if(!in("top", hide)) {
      clear()
      Z(
          height -
          kick_height -
          top_thickness/2
      )top(
          depth=depth,
          width=width,
          thickness=top_thickness
      );
    }
}

cabinet(open=true, hide="");

