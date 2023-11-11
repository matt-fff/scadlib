include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>

BRACE_WIDTH = inch_to_mm(3.125);

module frame_outline(
    depth=undef,
    height=undef,
    width=undef,
    thickness=undef,
    brace_width=undef,
    col=yellow
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    width = val_or_default(width, TOT_WIDTH);
    thickness = val_or_default(thickness, CARCAS_THICKNESS);
    brace_width = val_or_default(brace_width, BRACE_WIDTH);

    part = "frame_outline";
    material = CARCAS_MATERIAL;
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
    depth=undef,
    height=undef,
    width=undef,
    thickness=undef,
    brace_width=undef,
    panel_thickness=undef,
    col=yellow,
    explode=0
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    width = val_or_default(width, TOT_WIDTH);
    thickness = val_or_default(thickness, CARCAS_THICKNESS);
    brace_width = val_or_default(brace_width, BRACE_WIDTH);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    explode_back_offset = explode * 125;
    explode_top_offset = explode * 75;

    part = "frame_braces";
    material = CARCAS_MATERIAL;
    opaq(col)
    g(){
        Y(-explode_back_offset)
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

        Z(explode_top_offset)
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
    depth=undef,
    height=undef,
    width=undef,
    face_width=undef,
    face_thickness=undef,
    carcas_thickness=undef,
    divisions=undef,
    drawer_height=undef,
    dado_depth=undef,
    panel_thickness=undef,
    should_log=true,
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    width = val_or_default(width, TOT_WIDTH);
    face_width = val_or_default(face_width, FACE_WIDTH);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    drawer_height = val_or_default(drawer_height, DRAWER_HEIGHT);
    dado_depth = val_or_default(dado_depth, DADO_DEPTH);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);

    divisions = val_or_default(divisions, DIVISIONS);
    division_width = width / len(divisions);

    part = "frame_storage";
    material = CARCAS_MATERIAL;
    
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
