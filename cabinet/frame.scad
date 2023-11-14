include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/const.scad>

BRACE_WIDTH = inch_to_mm(3.125);

module frame_outline(
    width,
    depth=undef,
    height=undef,
    thickness=undef,
    brace_width=undef,
    material=undef
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    thickness = val_or_default(thickness, CARCAS_THICKNESS);
    brace_width = val_or_default(brace_width, BRACE_WIDTH);
    material = val_or_default(material, CARCAS_MATERIAL);

    part = "frame_outline";
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
    width,
    depth=undef,
    height=undef,
    thickness=undef,
    brace_width=undef,
    panel_thickness=undef,
    explode=0
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    thickness = val_or_default(thickness, CARCAS_THICKNESS);
    brace_width = val_or_default(brace_width, BRACE_WIDTH);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    explode_back_offset = explode * 125;
    explode_top_offset = explode * 75;

    part = "frame_braces";
    material = CARCAS_MATERIAL;
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
    width,
    division,
    depth=undef,
    height=undef,
    face_thickness=undef,
    carcas_thickness=undef,
    dado_depth=undef,
    panel_thickness=undef,
    should_log=true,
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    dado_depth = val_or_default(dado_depth, DADO_DEPTH);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);


    part = "frame_storage";
    material = CARCAS_MATERIAL;
    
    divider_depth = (
        depth - 
        carcas_thickness -
        panel_thickness -
        face_thickness
    );
    
    divider_width = (
        width +
        (dado_depth - carcas_thickness)*2
    );
    

    heights = [for (d = division) height*d[1]];
    cumulative_heights = accumulate(heights);

    g(
        TOREAR(),
        Y(
            panel_thickness + 
            carcas_thickness
        ),
        Z(carcas_thickness/2),
        X(width/2)
    ){
      pieces(len(division))
      g(){
        index = every(1);
        height_offset = cumulative_heights[index];
        type = division[index][0];

        // We only need dividers for door boundaries
        needs_divider = index != 0 && (
          type == DOOR || type == DOUBLE_DOOR || type != division[index-1][0]
        );

        if (needs_divider)
          Z(height_offset)
          logbox(
              divider_depth,
              x=divider_width,
              h=carcas_thickness,
              part=part,
              material=material,
              subpart="horiz-divider",
              should_log=should_log
          );
      }
    }

    children();
}
