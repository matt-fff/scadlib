include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/shaker.scad>

FACE_PANEL_MATERIAL = "1/2 plywood";
FACE_PANEL_THICKNESS = inch_to_mm(0.5);

DRAWER_WIDTH = DIVISION_WIDTH;
DRAWER_WIDTH_GAP = 42 - FACE_WIDTH;
DRAWER_DEPTH = inch_to_mm(15);
DRAWER_TOP_GAP = 10;
DRAWER_BOTTOM_GAP = 14;
DRAWER_BOTTOM_RECESS = 13;

module drawer_bottom(
    depth=undef,
    width=undef,
    width_gap=undef,
    shell_thickness=undef,
    panel_thickness=undef,
    material=undef,
    dado_depth=undef,
    should_log=true
){
    depth = val_or_default(depth, DRAWER_DEPTH);
    width = val_or_default(width, DRAWER_WIDTH);
    width_gap = val_or_default(width_gap, DRAWER_WIDTH_GAP);
    shell_thickness = val_or_default(shell_thickness, CARCAS_THICKNESS);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    material = val_or_default(material, PANEL_MATERIAL);
    dado_depth = val_or_default(dado_depth, DADO_DEPTH);
    

    part = "drawer";
    Y(shell_thickness)
    logbox(
        depth - shell_thickness*2 + dado_depth,
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
    depth=undef,
    height=undef,
    width=undef,
    width_gap=undef,
    top_gap=undef,
    bottom_gap=undef,
    bottom_recess=undef,
    bottom_thickness=undef,
    bottom_material=undef,
    shell_thickness=undef,
    shell_material=undef,
    face_trim_thickness=undef,
    face_trim_material=undef,
    face_panel_thickness=undef,
    face_panel_material=undef,
    face_overlay=undef,
    face_width=undef,
    dado_depth=undef
) {
    depth = val_or_default(depth, DRAWER_DEPTH);
    height = val_or_default(height, DRAWER_HEIGHT);
    width = val_or_default(width, DRAWER_WIDTH);
    width_gap = val_or_default(width_gap, DRAWER_WIDTH_GAP);
    top_gap = val_or_default(top_gap, DRAWER_TOP_GAP);
    bottom_gap = val_or_default(bottom_gap, DRAWER_BOTTOM_GAP);
    bottom_recess = val_or_default(bottom_recess, DRAWER_BOTTOM_RECESS);
    bottom_thickness = val_or_default(bottom_thickness, PANEL_THICKNESS);
    shell_thickness = val_or_default(shell_thickness, CARCAS_THICKNESS);
    shell_material = val_or_default(shell_material, CARCAS_MATERIAL);
    face_trim_thickness = val_or_default(face_trim_thickness, FACE_THICKNESS);
    face_trim_material = val_or_default(face_trim_material, FACE_MATERIAL);
    face_panel_thickness = val_or_default(face_panel_thickness, FACE_PANEL_THICKNESS);
    face_panel_material = val_or_default(face_panel_material, FACE_PANEL_MATERIAL);
    bottom_material = val_or_default(bottom_material, PANEL_MATERIAL);

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
        should_log=true,
        dado_depth=dado_depth
      )
      remove()
      drawer_bottom(
        depth=depth,
        width=width,
        width_gap=width_gap,
        shell_thickness=shell_thickness,
        material=bottom_material,
        should_log=false,
        dado_depth=dado_depth
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

      // Face
      add()
      Y(depth + 100)
      shaker_face(
        width=width,
        height=height,
        trim_thickness=face_trim_thickness,
        trim_width=face_width,
        trim_material=face_trim_material,
        trim_overlay=face_overlay,
        panel_thickness=panel_thickness,
        panel_material=face_panel_material,
        part="drawer_face"
      );
    }
    children();
}

module drawers(
    depth=undef,
    height=undef,
    width=undef,
    face_width=undef,
    face_trim_thickness=undef,
    face_trim_material=undef,
    division_width=undef,
    drawer_height=undef,
    dado_depth=undef,
    panel_thickness=undef,
    panel_material=undef,
    carcas_thickness=undef,
    carcas_material=undef,
    bottom_material=undef,
    face_panel_thickness=undef,
    face_panel_material=undef,
    face_overlay=undef,
    top_thickness=undef,
    open=false
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT);
    width = val_or_default(width, TOT_WIDTH);
    face_width = val_or_default(face_width, FACE_WIDTH);
    face_trim_thickness = val_or_default(face_trim_thickness, FACE_THICKNESS);
    division_width = val_or_default(division_width, DIVISION_WIDTH);
    drawer_height = val_or_default(drawer_height, DRAWER_HEIGHT);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    top_thickness = val_or_default(top_thickness, TOP_THICKNESS);
    
    // from drawer slide specs
    // min top clearance = 6mm
    // min bottom clearance (omitting recess) = 14mm
    // min INTERIOR width_gap = 42;
    // The specs are pretty idiotic in how they lay it out
    width_gap = 42 - face_trim_thickness;
    bottom_gap = 16;
    top_gap = 8;
    bottom_recess = 13;
    
    drawer_depth = (
        depth - 
        face_width/2 -
        panel_thickness -
        face_trim_thickness
    );

    center_drawer_width = division_width;
    side_drawer_width = center_drawer_width - face_width/2;

    // For optional
    open_offset = open ? (
      drawer_depth - 
      carcas_thickness -
      face_trim_thickness
    ) : 0;
    
    g(
        Y(
            panel_thickness + 
            carcas_thickness +
            face_trim_thickness +
            open_offset
        ),
        X(carcas_thickness / 2),
        TOREAR(),
        TORIGHT()
    ){
        //
        // SIDE DRAWERS
        //
        
        g(
            Z(
                height
                //- drawer_height/2
                - top_thickness
                - carcas_thickness
                - top_gap
            ),
            X(face_width/2)
        ){
            pieces(2)
            X(span(
              width
              - side_drawer_width
              - face_width
            ))
            drawer(
              depth=drawer_depth,
              height=drawer_height,
              width=side_drawer_width,
              width_gap=width_gap,
              top_gap=top_gap,
              bottom_gap=bottom_gap,
              bottom_recess=bottom_recess,
              bottom_thickness=panel_thickness,
              bottom_material=bottom_material,
              shell_thickness=carcas_thickness,
              shell_material=carcas_material,
              face_trim_thickness=face_trim_thickness,
              face_trim_material=face_trim_material,
              face_panel_thickness=face_panel_thickness,
              face_panel_material=face_panel_material,
              face_overlay=face_overlay,
              dado_depth=dado_depth
            );

        }
        
        //
        // CENTER DRAWERS
        //
        g(
            X(
                division_width
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
              bottom_thickness=panel_thickness,
              bottom_material=bottom_material,
              shell_thickness=carcas_thickness,
              shell_material=carcas_material,
              face_trim_thickness=face_trim_thickness,
              face_trim_material=face_trim_material,
              face_panel_thickness=face_panel_thickness,
              face_panel_material=face_panel_material,
              face_overlay=face_overlay,
              dado_depth=dado_depth
          );
          drawer(
              depth=drawer_depth,
              height=drawer_height,
              width=center_drawer_width,
              width_gap=width_gap,
              top_gap=top_gap,
              bottom_gap=bottom_gap,
              bottom_recess=bottom_recess,
              bottom_thickness=panel_thickness,
              bottom_material=bottom_material,
              shell_thickness=carcas_thickness,
              shell_material=carcas_material,
              face_trim_thickness=face_trim_thickness,
              face_trim_material=face_trim_material,
              face_panel_thickness=face_panel_thickness,
              face_panel_material=face_panel_material,
              face_overlay=face_overlay,
              dado_depth=dado_depth
          );
        }
    }
    children();
}
