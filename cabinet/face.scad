include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>

module face_plate_outline(
    depth=tot_depth,
    height=tot_height - kick_height - top_thickness,
    width=tot_width,
    face_thickness=face_thickness,
    face_width=face_width,
    carcas_thickness=carcas_thickness,
    division_width=tot_width / 3
){
    material = face_material;
    part = "face_plate_outline";

    TORIGHT()
    g(
        Y(depth - carcas_thickness),
        TOREAR()
    ){
        //
        // FRAME OUTLINE
        //
        
        X(carcas_thickness*2)
        // Bottom
        logbox(
            face_thickness,
            x=width - carcas_thickness*4,
            h=face_width,
            part=part,
            material=material,
            subpart="bottom"
        )
        // Top
        Z(height - carcas_thickness)
        logbox(
            face_thickness,
            x=width - carcas_thickness*4,
            h=face_width,
            part=part,
            material=material,
            subpart="top"
        );
        
        
        Z((height - carcas_thickness)/2)
        // Right
        logbox(
            face_thickness,
            x=face_width,
            h=height + carcas_thickness,
            part=part,
            material=material,
            subpart="right"
        )
        // Left
        X(width - face_width)
        logbox(
            face_thickness,
            x=face_width,
            h=height + carcas_thickness,
            part=part,
            material=material,
            subpart="left"
        );
        
        //
        // FRAME VERTICAL DIVIDERS
        //
        
        Z((height - carcas_thickness)/2)
        // Right Vertical Divider
        X(division_width - carcas_thickness)
        logbox(
            face_thickness,
            x=face_width,
            h=(
                height - 
                face_width - 
                carcas_thickness
            ),
            part=part,
            material=material,
            subpart="right_divider"
        )
        // Left Vertical Divider
        X(division_width)
        logbox(
            face_thickness,
            x=face_width,
            h=(
                height - 
                face_width - 
                carcas_thickness
            ),
            part=part,
            material=material,
            subpart="left_divider"
        );

    }
    children();
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
    material = face_material;
    part = "face_plate_storage";
    TORIGHT()
    g(
        Y(depth - carcas_thickness),
        TOREAR()
    ){
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
        logbox(
            face_thickness,
            x=(
                division_width - 
                face_width - 
                carcas_thickness
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
                carcas_thickness
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


