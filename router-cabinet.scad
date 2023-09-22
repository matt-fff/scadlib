include <constructive/constructive-compiled.scad> 

// Function to convert inches to millimeters
function inches_to_mm(inches) = inches * 25.4;

tot_width = inches_to_mm(72);
tot_height = inches_to_mm(39);
tot_depth = inches_to_mm(18.5);

carcas_thickness = inches_to_mm(0.75);
brace_width = inches_to_mm(3.125);

top_thickness = inches_to_mm(0.75);
top_overhang = inches_to_mm(0.75);

face_thickness = inches_to_mm(0.75);
face_width = carcas_thickness * 2;

kick_height = inches_to_mm(3.5);
drawer_height = inches_to_mm(9);


panel_thickness = inches_to_mm(0.25);
dado_depth = inches_to_mm(0.25);

//module drawer_slide(
//    depth=inches_to_mm(15.51),
//    height=inches_to_mm(2.01),
//    width=inches_to_mm(2.01)
//){
//    box(
//        height,
//        x=width,
//        y=depth
//    );
//}


module kick_plate(
    depth=tot_depth,
    height=kick_height,
    width=tot_width,
    thickness=carcas_thickness,
    kick_inset=inches_to_mm(3)
){
    Y(thickness)
    union() {
        // Runners
        TOFRONT()
        TORIGHT()
        pieces(2)
        Y(span(depth - kick_inset))
        box(
            thickness,
            x=width,
            h=height
        );
        
        // Sides
        TOFRONT()
        TORIGHT()
        pieces(2)
        X(span(width - thickness))
        turnXY(90)
        box(
            thickness,
            x=depth - kick_inset - thickness,
            h=height
        );
    }
}

module frame_outline(
    depth=tot_depth,
    height=tot_height - kick_height - top_thickness,
    width=tot_width,
    thickness=carcas_thickness,
    brace_width=brace_width,
    col=yellow
){
    
    clear(col)
    union() {
        stack(TOUP)
        TOREAR()
        TORIGHT()
        // Bottom
        box(
            width,
            y=depth - thickness,
            h=thickness
        )
        // Sides
        pieces(2)
        X(span(width - thickness))
        box(
            thickness,
            y=depth - thickness,
            h=height - thickness
        );
        
        // Back Braces
        TOREAR()
        TORIGHT()
        pieces(2)
        Z(span(
            height - brace_width - thickness
        ))
        X(thickness)
        box(
            thickness,
            x=width-thickness*2,
            h=brace_width
        );

        // Top Braces
        TOREAR()
        TORIGHT()
        Z(height - thickness)
        pieces(2)
        Y(span(
            depth - brace_width - thickness
        ))
        X(thickness)
        box(
            brace_width,
            x=width-thickness*2,
            h=thickness
        );
    }
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
    panel_thickness=panel_thickness
){
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
    
    echo(divider_depth);
    
    Y(
        panel_thickness + 
        carcas_thickness
    ) 
    TOREAR()
    TORIGHT()
    union(){
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
        box(
            divider_depth,
            x=divider_width,
            h=carcas_thickness
        )
        // Left Horizontal Divider
        X(division_width*2)
        box(
            divider_depth,
            x=divider_width,
            h=carcas_thickness
        );
        
        //
        // CENTER HORIZONTAL DIVIDERS
        //
        
        Z((face_width-carcas_thickness)/2)
        X(division_width + face_width/2 - dado_depth)
        Z(drawer_height*2)
        box(
            divider_depth,
            x=divider_width,
            h=carcas_thickness
        );
    }
}

module back_panel(
    height=tot_height - kick_height - top_thickness,
    width=tot_width,
    carcas_thickness=carcas_thickness,
    panel_thickness=panel_thickness,
    dado_depth=dado_depth,
    col=black
){
    
    // Back Panel
    clear(col)
    Z(carcas_thickness-dado_depth)
    TOREAR()
    TORIGHT()
    X(carcas_thickness - dado_depth)
    Y(carcas_thickness)
    box(
        panel_thickness,
        x=width + (dado_depth - carcas_thickness)*2,
        h=height + dado_depth - carcas_thickness*2
    );

}

module face_plate_outline(
    depth=tot_depth,
    height=tot_height - kick_height - top_thickness,
    width=tot_width,
    face_thickness=face_thickness,
    face_width=face_width,
    carcas_thickness=carcas_thickness,
    division_width=tot_width / 3
){
    Y(depth - carcas_thickness)
    TOREAR()
    TORIGHT()
    union(){
        //
        // FRAME OUTLINE
        //
        
        X(carcas_thickness*2)
        // Bottom
        box(
            face_thickness,
            x=width - carcas_thickness*4,
            h=face_width
        )
        // Top
        Z(height - carcas_thickness)
        box(
            face_thickness,
            x=width - carcas_thickness*4,
            h=face_width
        );
        
        
        Z((height - carcas_thickness)/2)
        // Right
        box(
            face_thickness,
            x=face_width,
            h=height + carcas_thickness
        )
        // Left
        X(width - face_width)
        box(
            face_thickness,
            x=face_width,
            h=height + carcas_thickness
        );
        
        //
        // FRAME VERTICAL DIVIDERS
        //
        
        Z((height - carcas_thickness)/2)
        // Right Vertical Divider
        X(division_width - carcas_thickness)
        box(
            face_thickness,
            x=face_width,
            h=(
                height - 
                face_width - 
                carcas_thickness
            )
        )
        // Left Vertical Divider
        X(division_width)
        box(
            face_thickness,
            x=face_width,
            h=(
                height - 
                face_width - 
                carcas_thickness
            )
        );

    }
}

module face_plate_storage(
    depth=tot_depth,
    height=tot_height - kick_height - top_thickness,
    width=tot_width,
    face_width=face_width,
    face_thickness=face_thickness,
    carcas_thickness=carcas_thickness,
    division_width=tot_width / 3,
    drawer_height=drawer_height
){
    Y(depth - carcas_thickness)
    TOREAR()
    TORIGHT()
    union(){
        //
        // SIDE HORIZONTAL DIVIDERS
        //
        
        Z(
            height - 
            carcas_thickness - 
            drawer_height
        )
        X(face_width)
        // Right Horizontal Divider
        box(
            face_thickness,
            x=(
                division_width - 
                face_width - 
                carcas_thickness
            ),
            h=face_width
        )
        // Left Horizontal Divider
        X(division_width*2 - face_width/2)
        box(
            face_thickness,
            x=(
                division_width - 
                face_width - 
                carcas_thickness
            ),
            h=face_width
        );
        
        //
        // CENTER HORIZONTAL DIVIDERS
        //
        
        X(division_width + face_width/2)
        Z(drawer_height)
        box(
            face_thickness,
            x=(
                division_width - 
                face_width
            ),
            h=face_width
        )
        // Bottom Horizontal Divider
        Z(drawer_height)
        box(
            face_thickness,
            x=(
                division_width - 
                face_width
            ),
            h=face_width
        );
    }
}

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

    TODOWN()
    union() {
        clear(col1)
        kick_plate(
            depth=depth,
            height=kick_height,
            width=division_width
        );
        
        clear(col2)
        X(division_width)
        kick_plate(
            depth=depth,
            height=kick_height,
            width=division_width
        );
        
        clear(col3)
        X(division_width * 2)
        kick_plate(
            depth=depth,
            height=kick_height,
            width=division_width
        );
    }
    TOUP()
    union() {
        union() {
            back_panel(
                height=(
                    height - 
                    kick_height -
                    top_thickness
                ),
                width=division_width,
                carcas_thickness=carcas_thickness,
                col=col1
            );
            frame_outline(
                depth=depth,
                height=(
                    height - 
                    kick_height -
                    top_thickness
                ),
                width=division_width,
                col=col1
            );
        }
        
        X(division_width)
        union() {
            back_panel(
                height=(
                    height - 
                    kick_height -
                    top_thickness
                ),
                width=division_width,
                carcas_thickness=carcas_thickness,
                col=col2
            );
            frame_outline(
                depth=depth,
                height=(
                    height - 
                    kick_height -
                    top_thickness
                ),
                width=division_width,
                col=col2
            );
        }

        X(division_width * 2)
        union() {
            back_panel(
                height=(
                    height - 
                    kick_height -
                    top_thickness
                ),
                width=division_width,
                carcas_thickness=carcas_thickness,
                col=col3
            );
            frame_outline(
                depth=depth,
                height=(
                    height - 
                    kick_height -
                    top_thickness
                ),
                width=division_width,
                col=col3
            );
        }
    }
    clear(black)
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
        carcas_thickness=carcas_thickness,
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
        carcas_thickness=carcas_thickness,
        division_width=division_width
    );
}

module top(
    depth=tot_depth,
    width=tot_width,
    thickness=top_thickness,
    overhang=top_overhang
){
    X(-overhang)
    Y(-overhang)
    TOREAR()
    TORIGHT()
    box(
        depth + overhang*2,
        x=width + overhang*2,
        h=top_thickness
    );
}

carcas(
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
    dado_depth=dado_depth
);
clear()
Z(
    tot_height -
    kick_height -
    top_thickness/2
)top(
    depth=tot_depth,
    width=tot_width,
    thickness=top_thickness,
    overhang=top_overhang
);