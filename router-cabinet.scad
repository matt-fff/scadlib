include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>

tot_width = inch_to_mm(72);
tot_height = inch_to_mm(39);
tot_depth = inch_to_mm(18.5);

carcas_material = "3/4 plywood";
carcas_thickness = inch_to_mm(0.75);
brace_width = inch_to_mm(3.125);

top_material = "3/4 top";
top_thickness = inch_to_mm(0.75);
top_overhang = inch_to_mm(0.75);

face_material = "3/4 hardwood";
face_thickness = inch_to_mm(0.75);
face_width = carcas_thickness * 2;

kick_height = inch_to_mm(3.5);
drawer_height = inch_to_mm(9);

panel_material = "1/4 plywood";
panel_thickness = inch_to_mm(0.25);
dado_depth = inch_to_mm(0.25);


//module drawer_slide(
//    depth=inch_to_mm(15.51),
//    height=inch_to_mm(2.01),
//    width=inch_to_mm(2.01)
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
    children();
}

module drawer_bottom(
    depth=inch_to_mm(15),
    width=tot_width/3 - carcas_thickness*2,
    width_gap=42 - (carcas_thickness * 2),
    shell_thickness=carcas_thickness,
    material=panel_material,
    should_log=true
){
    part = "drawer";
    logbox(
        depth + dado_depth - shell_thickness,
        x=width - (
          width_gap + 
          shell_thickness - 
          dado_depth
        )*2,
        h=panel_thickness,
        part=part,
        material=material,
        subpart="bottom",
        should_log=should_log
    );
    children();
}

module drawer(
    depth=inch_to_mm(15),
    height=drawer_height,
    width=tot_width/3 - carcas_thickness*2,
    width_gap=42 - (carcas_thickness * 2),
    top_gap=10,
    bottom_gap=14,
    bottom_recess=13,
    bottom_thickness=panel_thickness,
    shell_thickness=carcas_thickness,
    shell_material=carcas_material,
    face_thickness=face_thickness,
    face_trim_material=face_material,
    face_interior_material=face_material,
    bottom_material=panel_material
) {
    part = "drawer";
    height_gap = bottom_gap + top_gap;
    center_offset = (width - shell_thickness) / 2;

    assemble() { 
      // Rear
      add()
      Z(bottom_recess / 2)
      X(center_offset)
      logbox(
          shell_thickness,
          x=width - (width_gap + shell_thickness)*2,
          h=height - height_gap*2 - bottom_recess,
          part=part,
          material=shell_material,
          subpart="rear"
      );

      bottom_offset = -height/2 + bottom_gap + bottom_recess*2;

      // Bottom panel
      Z(bottom_offset)
      X(center_offset)
      add()
      drawer_bottom(
        depth=depth,
        width=width,
        width_gap=width_gap,
        shell_thickness=shell_thickness,
        material=bottom_material,
        should_log=true
      )
      remove()
      drawer_bottom(
        depth=depth,
        width=width,
        width_gap=width_gap,
        shell_thickness=shell_thickness,
        material=bottom_material,
        should_log=false
      );
    
      // Interior front
      add()
      Y(depth - shell_thickness)
      X(center_offset)
      logbox(
          shell_thickness,
          x=width - (width_gap + shell_thickness)*2,
          h=height - height_gap*2,
          part=part,
          material=shell_material,
          subpart="front"
      );

      // Sides
      add()
      pieces(2)
      X(width_gap)
      X(span(
          width - 
          width_gap*2 -
          shell_thickness
      ))
      logbox(
          depth,
          x=shell_thickness,
          h=height - height_gap*2,
          part=part,
          material=shell_material,
          subpart="side"
      );
    }
    children();
}

module drawers(
    depth=tot_depth,
    height=(
        tot_height -
        kick_height -
        top_thickness -
        carcas_thickness
    ),
    width=tot_width,
    face_width=face_width,
    face_thickness=face_thickness,
    carcas_thickness=carcas_thickness,
    division_width=tot_width / 3,
    drawer_height=drawer_height,
    dado_depth=dado_depth,
    panel_thickness=panel_thickness,
    drawer_thickness=carcas_thickness,
    open=false
){
    // from drawer slide specs
    // min top clearance = 6mm
    // min bottom clearance (omitting recess) = 14mm
    // min INTERIOR width_gap = 42;
    // The specs are pretty idiotic in how they lay it out
    width_gap = 42 - (carcas_thickness * 2);
    bottom_gap = 14;
    top_gap = 10;
    bottom_recess = 13;
    
    drawer_depth = (
        depth - 
        carcas_thickness -
        panel_thickness -
        face_thickness
    );

    center_dead_space = max(face_width, carcas_thickness*2);
    side_dead_space = max(face_width, carcas_thickness);

    center_drawer_width = division_width - center_dead_space;
    side_face_offset = max(face_width - carcas_thickness, 0);
    side_drawer_width = center_drawer_width - side_face_offset;

    // For optional
    open_offset = open ? (
      drawer_depth - 
      drawer_thickness -
      face_thickness
    ) : 0;
    
    g(
        Y(
            panel_thickness + 
            carcas_thickness +
            face_thickness +
            open_offset
        ),
        X(drawer_thickness / 2),
        TOREAR(),
        TORIGHT()
    ){
        //
        // SIDE DRAWERS
        //
        
        g(
            Z(
                height -
                drawer_height/2
            ),
            X(side_dead_space)

        ){
            pieces(2)
            X(span(
              width - 
              side_drawer_width - 
              2*side_dead_space
            ))
            drawer(
              depth=drawer_depth,
              height=drawer_height,
              width=side_drawer_width,
              width_gap=width_gap,
              top_gap=top_gap,
              bottom_gap=bottom_gap,
              bottom_recess=bottom_recess,
              bottom_thickness=drawer_thickness,
              shell_thickness=carcas_thickness,
              face_thickness=face_thickness
            );
        }
        
        //
        // CENTER DRAWERS
        //
        g(
            X(
                division_width + 
                carcas_thickness
            ),
            Z(drawer_height/2)
        ){

          pieces(2)
          Z(span(drawer_height))
          drawer(
              depth=drawer_depth,
              height=drawer_height,
              width=center_drawer_width,
              width_gap=width_gap,
              top_gap=top_gap,
              bottom_gap=bottom_gap,
              bottom_recess=bottom_recess,
              bottom_thickness=drawer_thickness,
              shell_thickness=carcas_thickness,
              face_thickness=face_thickness
          );
          drawer(
              depth=drawer_depth,
              height=drawer_height,
              width=center_drawer_width,
              width_gap=width_gap,
              top_gap=top_gap,
              bottom_gap=bottom_gap,
              bottom_recess=bottom_recess,
              bottom_thickness=drawer_thickness,
              shell_thickness=carcas_thickness,
              face_thickness=face_thickness
          );
        }
    }
    children();
}

module top(
    depth=tot_depth,
    width=tot_width,
    thickness=top_thickness,
    overhang=top_overhang
){
    material = top_material;
    part = "top";
    X(-overhang)
    Y(-overhang)
    TOREAR()
    TORIGHT()
    logbox(
        depth + overhang*2,
        x=width + overhang*2,
        h=top_thickness,
        part=part,
        material=material,
        subpart="top"
    );
    children();
}

module cabinet(
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
        dado_depth=dado_depth,
        open=false
){
    carcas(
        depth=depth,
        height=height,
        width=width,
        kick_height=kick_height,
        top_thickness=top_thickness,
        face_width=face_width,
        face_thickness=face_thickness,
        carcas_thickness=carcas_thickness,
        drawer_height=drawer_height,
        panel_thickness=panel_thickness,
        dado_depth=dado_depth
    );
    clear(orange)
    drawers(
      depth=tot_depth,
      height=(
          height -
          kick_height -
          top_thickness -
          carcas_thickness
      ),
      width=width,
      face_width=face_width,
      face_thickness=face_thickness,
      carcas_thickness=carcas_thickness,
      division_width=width / 3,
      drawer_height=drawer_height,
      dado_depth=dado_depth,
      panel_thickness=panel_thickness,
      drawer_thickness=carcas_thickness,
      open=open
    );
    clear()
    Z(
        height -
        kick_height -
        top_thickness/2
    )top(
        depth=depth,
        width=width,
        thickness=top_thickness,
        overhang=top_overhang
    );
}

cabinet(open=true);

