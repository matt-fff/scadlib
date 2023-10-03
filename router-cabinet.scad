include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/carcas.scad>
include <scadlib/cabinet/face.scad>
include <scadlib/cabinet/drawer.scad>
include <scadlib/cabinet/top.scad>

module cabinet(
        depth=tot_depth,
        height=tot_height,
        width=tot_width,
        kick_height=kick_height,
        top_thickness=top_thickness,
        face_width=face_width,
        face_thickness=face_thickness,
        carcas_thickness=carcas_thickness,
        drawer_height=drawer_height,
        panel_thickness=panel_thickness,
        dado_depth=dado_depth,
        open=false
){
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
    clear(orange)
    drawers(
      depth=tot_depth,
      height=(
          height -
          kick_height -
          top_thickness -
          carcas_thickness
      ),
      width=width,
      face_width=face_width,
      face_thickness=face_thickness,
      carcas_thickness=carcas_thickness,
      division_width=width / 3,
      drawer_height=drawer_height,
      dado_depth=dado_depth,
      panel_thickness=panel_thickness,
      drawer_thickness=carcas_thickness,
      open=open
    );
    clear()
    Z(
        height -
        kick_height -
        top_thickness/2
    )top(
        depth=depth,
        width=width,
        thickness=top_thickness,
        overhang=top_overhang
    );
}

cabinet(open=true);

