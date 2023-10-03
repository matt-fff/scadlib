include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>

module carcas(
    depth=tot_depth,
    height=tot_height,
    width=tot_width,
    kick_height=kick_height,
    top_thickness=top_thickness,
    face_thickness=face_thickness,
    face_width=face_width,
    carcas_thickness=carcas_thickness,
    drawer_height=drawer_height,
    panel_thickness=panel_thickness,
    dado_depth=dado_depth
){
    division_width = width / 3;

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
    
    clear()
    face_plate_outline(
        depth=depth,
        height=(
            height -
            kick_height -
            top_thickness
        ),
        width=width,
        face_thickness=face_thickness,
        face_width=face_width,
        division_width=division_width
    );
    clear()
    face_plate_storage(
        depth=depth,
        height=(
            height -
            kick_height -
            top_thickness
        ),
        width=width,
        face_thickness=face_thickness,
        face_width=face_width,
        division_width=division_width
    );
    children();
}

module kick_plate(
    depth=tot_depth,
    height=kick_height,
    width=tot_width,
    thickness=carcas_thickness,
    kick_inset=inch_to_mm(3),
    left_exposed=false,
    right_exposed=false
){
    part = "kick_plate";
    material = carcas_material;

    TORIGHT()
    g(
        Y(thickness),
        TOFRONT()
    ) {
        // Runners
        X(thickness)
        logbox(
            thickness,
            x=width - thickness*2,
            h=height,
            part=part,
            material=material,
            subpart="back_runner"
        );
        Y(depth - kick_inset)
        logbox(
            thickness,
            x=width,
            h=height,
            part=part,
            material=material,
            subpart="front_runner"
        );
        
        // TODO technically this is wrong.
        // We make the sides oversized because
        // exposed corners need to be mitered
        side_width = depth - kick_inset;
        left_width = side_width + (left_exposed ? thickness : 0);
        right_width = side_width + (right_exposed ? thickness : 0);
        
        g(Y(-thickness)) {
            // Sides
            X(width - thickness)
            turnXY(90)
            logbox(
                thickness,
                x=left_width,
                h=height,
                part=part,
                material=material,
                subpart="left_side"
            );
            turnXY(90)
            logbox(
                thickness,
                x=right_width,
                h=height,
                part=part,
                material=material,
                subpart="right_side"
            );
        }
    }
    children();
}

module frame_outline(
    depth=tot_depth,
    height=tot_height - kick_height - top_thickness,
    width=tot_width,
    thickness=carcas_thickness,
    brace_width=brace_width,
    col=yellow
){
    part = "frame_outline";
    material = carcas_material;
    clear(col)
    TORIGHT()
    g(TOREAR()) {
        // Bottom
        X(thickness)
        logbox(
            width - thickness*2,
            y=depth - thickness,
            h=thickness,
            part=part,
            material=material,
            subpart="bottom"
        );
        // Sides
        pieces(2)
        X(span(width - thickness))
        logbox(
            x=thickness,
            y=depth - thickness,
            h=height,
            part=part,
            material=material,
            subpart="side"
        );
    }
    children();
}

module frame_braces(
    depth=tot_depth,
    height=tot_height - kick_height - top_thickness,
    width=tot_width,
    thickness=carcas_thickness,
    brace_width=brace_width,
    col=yellow,
    panel_thickness=panel_thickness
){
    part = "frame_braces";
    material = carcas_material;
    opaq(col)
    g(){
        // Back Braces
        TOREAR()
        TORIGHT()
        pieces(2)
        Z(span(
            height - brace_width
        ))
        X(thickness)
        logbox(
            thickness,
            x=width-thickness*2,
            h=brace_width,
            part=part,
            material=material,
            subpart="back"
        );

        // Top Braces
        TOREAR()
        TORIGHT()
        Z(height - thickness)
        Y(thickness + panel_thickness)
        pieces(2)
        Y(span(
            depth - 
            brace_width - 
            thickness*2 - 
            panel_thickness
        ))
        X(thickness)
        logbox(
            brace_width,
            x=width-thickness*2,
            h=thickness,
            part=part,
            material=material,
            subpart="top"
        );
    }
    children();
}

module frame_storage(
    depth=tot_depth,
    height=tot_height - kick_height - top_thickness,
    width=tot_width,
    face_width=face_width,
    face_thickness=face_thickness,
    carcas_thickness=carcas_thickness,
    division_width=tot_width / 3,
    drawer_height=drawer_height,
    dado_depth=dado_depth,
    panel_thickness=panel_thickness,
    should_log=true
){
    part = "frame_storage";
    material = carcas_material;
    
    divider_depth = (
        depth - 
        carcas_thickness -
        panel_thickness -
        face_thickness
    );
    
    divider_width = (
        division_width +
        (dado_depth - carcas_thickness)*2
    );
    
    
    TORIGHT()
    g(
        TOREAR(),
        Y(
            panel_thickness + 
            carcas_thickness
        )
    ){
        //
        // SIDE HORIZONTAL DIVIDERS
        //
        
        Z(-(face_width-carcas_thickness)/2)
        Z(
            height - 
            drawer_height
        )
        X(carcas_thickness - dado_depth)
        // Right Horizontal Divider
        logbox(
            divider_depth,
            x=divider_width,
            h=carcas_thickness,
            part=part,
            material=material,
            subpart="right_divider",
            should_log=should_log
        )
        // Left Horizontal Divider
        X(division_width*2)
        logbox(
            divider_depth,
            x=divider_width,
            h=carcas_thickness,
            part=part,
            material=material,
            subpart="left_divider",
            should_log=should_log
        );
        
        //
        // CENTER HORIZONTAL DIVIDERS
        //
        
        Z((face_width-carcas_thickness)/2)
        X(division_width + face_width/2 - dado_depth)
        Z(drawer_height*2)
        logbox(
            divider_depth,
            x=divider_width,
            h=carcas_thickness,
            part=part,
            material=material,
            subpart="center_divider",
            should_log=should_log
        );
    }
    children();
}

module back_panel(
    height=tot_height - kick_height - top_thickness,
    width=tot_width,
    carcas_thickness=carcas_thickness,
    panel_thickness=panel_thickness,
    dado_depth=dado_depth,
    col=black,
    should_log=true
){
    material = panel_material;
    part = "back_panel";

    // Back Panel
    clear(col)
    Z(carcas_thickness-dado_depth)
    TOREAR()
    TORIGHT()
    X(carcas_thickness - dado_depth)
    Y(carcas_thickness)
    logbox(
        panel_thickness,
        x=width + (dado_depth - carcas_thickness)*2,
        h=height + dado_depth - carcas_thickness,
        part=part,
        material=material,
        subpart="panel",
        should_log=should_log
    );
    children();
}
