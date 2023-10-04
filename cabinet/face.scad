include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>

module face_plate_outline(
    depth=undef,
    height=undef,
    width=undef,
    face_thickness=undef,
    face_width=undef,
    face_material=undef,
    division_width=undef
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    width = val_or_default(width, TOT_WIDTH);
    face_width = val_or_default(face_width, FACE_WIDTH);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    face_material = val_or_default(face_material, FACE_MATERIAL);
    division_width = val_or_default(division_width, TOT_WIDTH / 3);

    material = face_material;
    part = "face_plate_outline";
    rail_width = width - face_width*2;

    TORIGHT()
    g(
        Y(depth - face_width/2),
        TOREAR()
    ){
        //
        // FRAME OUTLINE
        //
        
        X(face_width)
        // Bottom
        logbox(
            face_thickness,
            x=rail_width,
            h=face_width,
            part=part,
            material=material,
            subpart="bottom"
        )
        // Top
        Z(height - face_width/2)
        logbox(
            face_thickness,
            x=rail_width,
            h=face_width,
            part=part,
            material=material,
            subpart="top"
        );
        
        
        Z((height - face_width/2)/2)
        // Right
        logbox(
            face_thickness,
            x=face_width,
            h=height + face_width/2,
            part=part,
            material=material,
            subpart="right"
        )
        // Left
        X(width - face_width)
        logbox(
            face_thickness,
            x=face_width,
            h=height + face_width/2,
            part=part,
            material=material,
            subpart="left"
        );
        
        //
        // FRAME VERTICAL DIVIDERS
        //
        
        Z((height - face_width/2)/2)
        X(division_width - face_width/2)
        pieces(2)
        X(span(division_width))
        logbox(
            face_thickness,
            x=face_width,
            h=(
                height - 
                face_width * 1.5
            ),
            part=part,
            material=material,
            subpart=vRepeat("right_divider", "left_divider")
        );
    }
    children();
}

module face_plate_storage(
    depth=undef,
    height=undef,
    width=undef,
    face_width=undef,
    face_thickness=undef,
    face_material=undef,
    division_width=undef,
    drawer_height=undef
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    width = val_or_default(width, TOT_WIDTH);
    face_width = val_or_default(face_width, FACE_WIDTH);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    face_material = val_or_default(face_material, FACE_MATERIAL);
    division_width = val_or_default(division_width, TOT_WIDTH / 3);
    drawer_height = val_or_default(drawer_height, DRAWER_HEIGHT);

    material = face_material;
    part = "face_plate_storage";
    TORIGHT()
    g(
        Y(depth - face_width/2),
        TOREAR()
    ){
        //
        // SIDE HORIZONTAL DIVIDERS
        //
        
        Z(
            height - 
            face_width/2 - 
            drawer_height
        )
        X(face_width)
        // Right Horizontal Divider
        logbox(
            face_thickness,
            x=(
                division_width - 
                face_width - 
                face_width/2
            ),
            h=face_width,
            part=part,
            material=material,
            subpart="right_divider"
        )
        // Left Horizontal Divider
        X(division_width*2 - face_width/2)
        logbox(
            face_thickness,
            x=(
                division_width - 
                face_width - 
                face_width/2
            ),
            h=face_width,
            part=part,
            material=material,
            subpart="left_divider"
        );
        
        //
        // CENTER HORIZONTAL DIVIDERS
        //
        
        X(division_width + face_width/2)
        Z(drawer_height)
        logbox(
            face_thickness,
            x=(
                division_width - 
                face_width
            ),
            h=face_width,
            part=part,
            material=material,
            subpart="center_divider"
        )
        // Bottom Horizontal Divider
        Z(drawer_height)
        logbox(
            face_thickness,
            x=(
                division_width - 
                face_width
            ),
            h=face_width,
            part=part,
            material=material,
            subpart="center_divider"
        );
    }
    children();
}


