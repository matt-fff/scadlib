include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/frame.scad>
include <scadlib/cabinet/kick_plate.scad>

module carcas(
    depth=undef,
    height=undef,
    width=undef,
    kick_height=undef,
    top_thickness=undef,
    face_thickness=undef,
    face_width=undef,
    carcas_thickness=undef,
    drawer_height=undef,
    panel_thickness=undef,
    dado_depth=undef
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT);
    width = val_or_default(width, TOT_WIDTH);
    kick_height = val_or_default(kick_height, KICK_HEIGHT);
    top_thickness = val_or_default(top_thickness, TOP_THICKNESS);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    face_width = val_or_default(face_width, FACE_WIDTH);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    drawer_height= val_or_default(drawer_height, DRAWER_HEIGHT);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    dado_depth = val_or_default(dado_depth, DADO_DEPTH);

    division_width = DIVISION_WIDTH;

    col1 = pink;
    col2 = red;
    col3 = orange;
    col_loop = vRepeat(col1, col2, col3);

    g(TODOWN()) {
        pieces(3)
        clear(vRepeat(col1, col2, col3))
        X(division_width * vRepeat(0, 1, 2))
        kick_plate(
            depth=depth,
            height=kick_height,
            width=division_width,
            right_exposed=vRepeat(true, false, false),
            left_exposed=vRepeat(false, false, true)
        );
    }
    g(TOUP()) {
        clear(gray)
        pieces(3)
        X(division_width * vRepeat(0, 1, 2))
        frame_braces(
            depth=depth,
            height=(
                height - 
                kick_height -
                top_thickness
            ),
            width=division_width,
            col=vRepeat(col1, col2, col3)
        )
        // Add the actual back panel
        back_panel(
            height=(
                height - 
                kick_height -
                top_thickness
            ),
            width=division_width,
            carcas_thickness=carcas_thickness,
            col=vRepeat(col1, col2, col3)
        );
        
    }
    clear(gray)
    frame_storage(
        depth=depth,
        height=(
            height -
            kick_height -
            top_thickness
        ),
        width=width,
        face_thickness=face_thickness,
        face_width=face_width,
        carcas_thickness=carcas_thickness,
        division_width=division_width,
        dado_depth=dado_depth,
        panel_thickness=panel_thickness
    );
    assemble()
    {
        add()
        g(TOUP()) {
            pieces(3)
            X(division_width * vRepeat(0, 1, 2))
            assemble() {
                add()
                frame_outline(
                    depth=depth,
                    height=(
                        height - 
                        kick_height -
                        top_thickness
                    ),
                    width=division_width,
                    col=vRepeat(col1, col2, col3)
                );
                // Hollow out a channel for the panel
                remove()
                back_panel(
                    height=height, // intentionally large
                    width=division_width,
                    carcas_thickness=carcas_thickness,
                    col=vRepeat(col1, col2, col3),
                    should_log=false,
                    dado_depth=dado_depth,
                    panel_thickness=panel_thickness
                );
            }
        }
        // Hollow out a channel for the shelves
        remove()
        frame_storage(
            depth=depth,
            height=(
                height -
                kick_height -
                top_thickness
            ),
            width=width,
            face_thickness=face_thickness,
            face_width=face_width,
            carcas_thickness=carcas_thickness,
            division_width=division_width,
            dado_depth=dado_depth,
            panel_thickness=panel_thickness,
            should_log=false
        );
    }
    children();
}
