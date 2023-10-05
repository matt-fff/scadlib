include <constructive/constructive-compiled.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/drawer.scad>


module middle_drawers(
    opening_depth,
    opening_width,
    opening_height,
    face_trim_thickness=undef,
    face_trim_material=undef,
    nominal_drawer_height=undef,
    dado_depth=undef,
    panel_thickness=undef,
    panel_material=undef,
    carcas_thickness=undef,
    carcas_material=undef,
    bottom_material=undef,
    face_panel_thickness=undef,
    face_panel_material=undef,
    face_overlay=undef,
    depth_gap=undef,
    top_gap=undef,
    bottom_gap=undef,
    bottom_recess=undef,
    explode=false
){
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    depth_gap = val_or_default(depth_gap, DRAWER_DEPTH_GAP);
    bottom_gap = val_or_default(bottom_gap, DRAWER_BOTTOM_GAP);
    nominal_drawer_height = val_or_default(nominal_drawer_height, DRAWER_HEIGHT);

    explode_offset = explode ? opening_depth : 0;


    g(
        Y(
            carcas_thickness
            + panel_thickness
            + depth_gap
            + explode_offset
        ),
        Z(
            carcas_thickness/2
            + bottom_gap
        ),
        TOREAR(),
        TORIGHT()
    ){
      //
      // CENTER DRAWERS
      //
      Z(nominal_drawer_height)
      drawer(
        opening_depth,
        opening_width,
        opening_height,
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
        opening_depth,
        opening_width,
        opening_height,
        depth_gap=depth_gap,
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
    children();
}

module side_drawer(
    opening_depth,
    opening_width,
    opening_height,
    cabinet_height=undef,
    face_width=undef,
    face_trim_thickness=undef,
    face_trim_material=undef,
    nominal_drawer_height=undef,
    dado_depth=undef,
    panel_thickness=undef,
    panel_material=undef,
    carcas_thickness=undef,
    carcas_material=undef,
    bottom_material=undef,
    face_panel_thickness=undef,
    face_panel_material=undef,
    face_overlay=undef,
    width_gap=undef,
    depth_gap=undef,
    top_gap=undef,
    bottom_gap=undef,
    bottom_recess=undef,
    explode=false
){
    cabinet_height = val_or_default(cabinet_height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    face_width = val_or_default(face_width, FACE_WIDTH);
    face_trim_thickness = val_or_default(face_trim_thickness, FACE_THICKNESS);
    nominal_drawer_height = val_or_default(nominal_drawer_height, DRAWER_HEIGHT);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    depth_gap = val_or_default(depth_gap, DRAWER_DEPTH_GAP);
    width_gap = val_or_default(width_gap, DRAWER_WIDTH_GAP);
    top_gap = val_or_default(top_gap, DRAWER_TOP_GAP);
    bottom_gap = val_or_default(bottom_gap, DRAWER_BOTTOM_GAP);
    bottom_recess = val_or_default(bottom_recess, DRAWER_BOTTOM_RECESS);

    
    explode_offset = explode ? opening_depth : 0;
    actual_drawer_height = nominal_drawer_height - face_width/2;

    g(
        Y(
            carcas_thickness
            + panel_thickness
            + depth_gap
            + explode_offset
        ),
        Z(
            // TODO offsets probably bullshit
            cabinet_height
            - nominal_drawer_height
            - (nominal_drawer_height - actual_drawer_height)/2
            + bottom_gap
        ),
        TOREAR()
    ){
        //
        // SIDE DRAWERS
        //
        
        drawer(
          opening_depth,
          opening_width,
          opening_height,
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
    depth_gap=undef,
    explode=false
){

  depth = val_or_default(depth, TOT_DEPTH);
  division_width = val_or_default(division_width, DIVISION_WIDTH);
  opening_depth = depth - panel_thickness - carcas_thickness;

  
  // exterior is limited by face width, 
  // since it's larger than and flush with the carcas
  side_ext_offset = face_width;
  // interior is limited by the carcas plus the face overlap
  side_int_offset = face_width - 2*carcas_thickness + carcas_thickness;

  opening_width_middle = division_width - 2*carcas_thickness;
  opening_width_sides = (
    division_width
    - side_ext_offset
    - side_int_offset
  );
  opening_height = drawer_height - face_width;
  
  X( 
    division_width + carcas_thickness 
  )
  middle_drawers(
    opening_depth,
    opening_width_middle,
    opening_height,
    face_trim_thickness=face_trim_thickness,
    face_trim_material=face_trim_material,
    nominal_drawer_height=drawer_height,
    dado_depth=dado_depth,
    panel_thickness=panel_thickness,
    panel_material=panel_material,
    carcas_thickness=carcas_thickness,
    carcas_material=carcas_material,
    bottom_material=bottom_material,
    face_panel_thickness=face_panel_thickness,
    face_panel_material=face_panel_material,
    face_overlay=face_overlay,
    depth_gap=depth_gap,
    explode=explode
  );

  side_split = (width - division_width)/2; 
  //X(side_split + (face_width - carcas_thickness))
  //X((side_ext_offset + side_int_offset))
  X(face_width)
  pieces(2)
  X(span(width - division_width - carcas_thickness))
  side_drawer(
    opening_depth,
    opening_width_sides,
    opening_height,
    cabinet_height=height,
    face_width=face_width,
    face_trim_thickness=face_trim_thickness,
    face_trim_material=face_trim_material,
    nominal_drawer_height=drawer_height,
    dado_depth=dado_depth,
    panel_thickness=panel_thickness,
    panel_material=panel_material,
    carcas_thickness=carcas_thickness,
    carcas_material=carcas_material,
    bottom_material=bottom_material,
    face_panel_thickness=face_panel_thickness,
    face_panel_material=face_panel_material,
    face_overlay=face_overlay,
    depth_gap=depth_gap,
    explode=explode
  );
}
