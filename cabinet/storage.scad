include <constructive/constructive-compiled.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/drawer.scad>

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
    explode=false
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
    explode_offset = explode ? (
      drawer_depth
    ) : 0;
    
    g(
        Y(
            panel_thickness + 
            carcas_thickness +
            face_trim_thickness +
            explode_offset
        ),
        X(carcas_thickness / 2),
        TOREAR(),
        TORIGHT()
    ){
        //
        // SIDE DRAWERS
        //
        
        g(
            //Z(
            //    height
            //    //- drawer_height/2
            //    //- top_thickness
            //    //- carcas_thickness
            //    //- top_gap
            //),
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
            //Z(drawer_height/2),
            X(division_width)
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
