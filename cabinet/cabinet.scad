
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
        shelf_dado_depth=undef,
        panel_dado_depth=undef,
        divisions=undef,
        face_overlay=undef,
        storage_protrusion=undef,
        has_storage_faceplate=true,
        uniform_carcas_widths=false,
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
    panel_dado_depth = val_or_default(panel_dado_depth, DADO_DEPTH);
    shelf_dado_depth = val_or_default(shelf_dado_depth, DADO_DEPTH);
    divisions = val_or_default(divisions, DIVISIONS);
    face_overlay = val_or_default(face_overlay, FACE_OVERLAY);
    storage_protrusion = val_or_default(
      storage_protrusion,
      face_overlay == 0 ? 0 : face_thickness
    );
    div_count = len(divisions);
    division_width = width / div_count;

    assert(face_width > carcas_thickness*2);


    explode_offset = explode * 150;

    ext_parts = [
      "kick",
      "top",
      "face-outline",
      "braces",
      "frame",
      "back",
      "face-stiles",
      "face-rails"
    ];

    int_parts = [
      "frame-shelves",
      "storage"
    ];


    validate_divisions(divisions);
   

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

      add("face-outline")
      Y(explode_offset)
      clear(beige)
      face_plate(
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

      division_widths = division_widths(
        width,
        face_width,
        carcas_thickness,
        divisions,
        force_uniform=uniform_carcas_widths
      );
      nominal_widths = [for (i = [0 : div_count - 1]) width/div_count];

      cumu_actual_widths = accumulate(division_widths);
      cumu_nominal_widths = accumulate(nominal_widths);

      pieces(div_count)
      g() {
        index = every(1);
        is_first = index == 0;
        is_last = index == div_count - 1;
        div_width = division_widths[index];
        division = divisions[index];
        modular_height = height - kick_height - top_thickness;
        
        // Because of the way the face sides may overhange inwards on
        // the edge cabinets, we sometimes need to cut the size of components
        should_reduce = is_first || is_last;
        edge_reduction = face_width/2;

        g(X(cumu_actual_widths[index])) {
          add("braces")
          TOUP()
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
                face_width=face_width,
                face_thickness=face_thickness,
                carcas_thickness=carcas_thickness,
                dado_depth=shelf_dado_depth,
                panel_thickness=panel_thickness,
                should_log=false
            );

            remove()
            back_panel(
                div_width,
                height=height, // intentionally large
                carcas_thickness=carcas_thickness,
                panel_thickness=panel_thickness,
                dado_depth=panel_dado_depth,
                should_log=false
            );
          }

          add("frame-shelves")
          frame_storage(
              div_width,
              division,
              depth=depth,
              height=modular_height,
              face_width=face_width,
              face_thickness=face_thickness,
              carcas_thickness=carcas_thickness,
              dado_depth=shelf_dado_depth,
              panel_thickness=panel_thickness
          );


          add("back")
          back_panel(
              div_width,
              height=modular_height,
              carcas_thickness=carcas_thickness,
              panel_thickness=panel_thickness,
              dado_depth=panel_dado_depth,
              explode=explode
          );

          
           
          add("storage")
          X(is_first ? edge_reduction : 0)
          storage(
            div_width - (should_reduce ? edge_reduction : 0),
            division,
            protrusion=storage_protrusion,
            depth=depth,
            height=modular_height,
            face_width=face_width,
            face_trim_thickness=face_thickness,
            face_overlay=face_overlay,
            drawer_height=drawer_height,
            dado_depth=panel_dado_depth,
            panel_thickness=panel_thickness,
            carcas_thickness=carcas_thickness,
            explode=explode
          );
        }

        stile_offset = uniform_carcas_widths ? cumu_nominal_widths[index] : cumu_actual_widths[index];
        g(X(stile_offset)) {
          overall_opening_height = height - face_width - carcas_thickness - kick_height - top_thickness;
          g(
            Y(depth - face_thickness/2)
            //X((face_width/2 - carcas_thickness)/2)
          ){
            //
            // FRAME VERTICAL DIVIDERS
            //
            if (!is_first) {
              add("face-stiles")
              Z((overall_opening_height)/2+face_thickness)
              logbox(
                  face_thickness,
                  x=face_width,
                  h=overall_opening_height,
                  part="face_plate",
                  material=FACE_MATERIAL,
                  subpart="vert-divider"
              );
            }

            if (has_storage_faceplate) {
              opening_heights = pct_to_val(overall_opening_height, division, split_size=face_width, idx=1);
              nominal_heights = pct_to_val(height, division, idx=1);
              cumulative_heights = accumulate(opening_heights);

              rail_width = div_width - face_width*(
                should_reduce ? 1.5 : 1
              );

              add("face-rails")
              g(
                  Z(
                      carcas_thickness/2
                  ),
                  X((rail_width+face_width)/2),
                  X(is_first ? edge_reduction : 0)
              ){
                pieces(len(division) - 1)
                g(){
                  index = every(1) + 1;

                  height_offset = cumulative_heights[index] + index*face_width;

                  Z(height_offset - (face_width - carcas_thickness)/2)
                  logbox(
                      face_thickness,
                      x=rail_width,
                      h=face_width,
                      part=part,
                      material=material,
                      subpart="horiz-divider"
                  );
                }
              }
            }
          }
        }
      }
    }
}
