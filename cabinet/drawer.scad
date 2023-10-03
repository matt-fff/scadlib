include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>

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
