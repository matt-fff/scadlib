
include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/utils.scad>
include <scadlib/cabinet/frame.scad>
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
        hide=[]
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

    explode_offset = explode * 150;

    ext_parts = [
      "kick",
      "top",
      "face",
      "braces",
      "frame",
      "back",
      "storage"
    ];

    int_parts = [
      "frame-shelves"
    ];
   

    // OVERLAY COMPONENTS
    // These are parts that have to have context 
    // on the overall cabinet layout
    assemble(
      fmt_parts(ext_parts, hide),
      fmt_parts(int_parts, hide)
    ) autoColor() {
      add("kick")
      Z(-explode_offset)
      TODOWN()
      kick_plate(
          depth=depth,
          height=kick_height,
          width=width,
          divisions=divisions
      );

      add("top")
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

      add("face")
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

      // MODULAR COMPONENTS
      // These are parts that only need
      // to know their own dimensions

      division_widths = division_carcas_widths(
        width, face_width, carcas_thickness, divisions
      );

      cumulative_widths = accumulate(division_widths);

      pieces(len(division_widths))
      g() {
        index = every(1);
        div_width = division_widths[index];
        cumu_width = cumulative_widths[index];
        division = divisions[index];
        modular_height = height - kick_height - top_thickness;
        
        g(X(cumu_width)) {
          add("braces")
          frame_braces(
              depth=depth,
              height=modular_height,
              width=div_width,
              explode=explode
          );

          add("frame")
          assemble(){ 
            add()
            TOUP()
            frame_outline(
                depth=depth,
                height=modular_height,
                width=div_width
            );

            remove()
            frame_storage(
                div_width,
                division,
                depth=depth,
                height=modular_height,
                face_thickness=face_thickness,
                carcas_thickness=carcas_thickness,
                dado_depth=dado_depth,
                panel_thickness=panel_thickness,
                should_log=false
            );

            remove()
            back_panel(
                div_width,
                height=height, // intentionally large
                carcas_thickness=carcas_thickness,
                panel_thickness=panel_thickness,
                dado_depth=dado_depth,
                should_log=false
            );
          }

          add("frame-shelves")
          frame_storage(
              div_width,
              division,
              depth=depth,
              height=modular_height,
              face_thickness=face_thickness,
              carcas_thickness=carcas_thickness,
              dado_depth=dado_depth,
              panel_thickness=panel_thickness
          );


          add("back")
          back_panel(
              div_width,
              height=modular_height,
              carcas_thickness=carcas_thickness,
              panel_thickness=panel_thickness,
              dado_depth=dado_depth,
              explode=explode
          );


          add("storage")
          storage(
            div_width,
            division,
            depth=depth,
            height=modular_height,
            face_width=face_width,
            face_trim_thickness=face_thickness,
            drawer_height=drawer_height,
            dado_depth=dado_depth,
            panel_thickness=panel_thickness,
            carcas_thickness=carcas_thickness,
            explode=explode
          );
        }
      }
    }
}
