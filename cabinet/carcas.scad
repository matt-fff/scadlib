include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/frame.scad>
include <scadlib/cabinet/back_panel.scad>

module carcas(
    depth=undef,
    height=undef,
    width=undef,
    face_thickness=undef,
    face_width=undef,
    carcas_thickness=undef,
    drawer_height=undef,
    panel_thickness=undef,
    dado_depth=undef,
    divisions=undef,
    explode=0
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT);
    width = val_or_default(width, TOT_WIDTH);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    face_width = val_or_default(face_width, FACE_WIDTH);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    drawer_height= val_or_default(drawer_height, DRAWER_HEIGHT);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    dado_depth = val_or_default(dado_depth, DADO_DEPTH);
    divisions = val_or_default(divisions, DIVISIONS);
    division_width= width / len(divisions);
    explode_offset = explode * 100;
  
    // TODO scalable colors
    col1 = pink;
    col2 = red;
    col3 = orange;
    g(TOUP()) {
        clear(gray)
        pieces(len(divisions))
        X(spanAllButLast(width))
        frame_braces(
            depth=depth,
            height=height,
            width=division_width,
            col=vRepeat(col1, col2, col3),
            explode=explode
        );
    }
    clear(gray)
    frame_storage(
        depth=depth,
        height=height,
        width=width,
        face_thickness=face_thickness,
        face_width=face_width,
        carcas_thickness=carcas_thickness,
        divisions=divisions,
        dado_depth=dado_depth,
        panel_thickness=panel_thickness
    );
    assemble()
    {
        add()
        g(TOUP()) {
            pieces(len(divisions))
            X(spanAllButLast(width))
            assemble() {
                add()
                frame_outline(
                    depth=depth,
                    height=height,
                    width=division_width,
                    col=vRepeat(col1, col2, col3)
                );
                // Hollow out a channel for the panel
                remove()
                back_panel(
                    height=height, // intentionally large
                    width=division_width,
                    carcas_thickness=carcas_thickness,
                    panel_thickness=panel_thickness,
                    dado_depth=dado_depth,
                    should_log=false
                );
            }
        }
        // Hollow out a channel for the shelves
        remove()
        frame_storage(
            depth=depth,
            height=height,
            width=width,
            face_thickness=face_thickness,
            face_width=face_width,
            carcas_thickness=carcas_thickness,
            divisions=divisions,
            dado_depth=dado_depth,
            panel_thickness=panel_thickness,
            should_log=false
        );
    }
    children();
}
