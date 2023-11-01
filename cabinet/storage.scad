include <constructive/constructive-compiled.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/drawer.scad>
include <scadlib/cabinet/door.scad>


module middle_storage(
    opening_depth,
    opening_width,
    opening_height,
    face_trim_thickness=undef,
    face_trim_material=undef,
    nominal_drawer_height=undef,
    dado_depth=undef,
    panel_thickness=undef,
    panel_material=undef,
    carcas_height=undef,
    carcas_thickness=undef,
    carcas_material=undef,
    bottom_material=undef,
    face_panel_thickness=undef,
    face_panel_material=undef,
    face_overlay=undef,
    face_width=undef,
    depth_gap=undef,
    top_gap=undef,
    bottom_gap=undef,
    bottom_recess=undef,
    hide="",
    explode=0
){
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    depth_gap = val_or_default(depth_gap, DRAWER_DEPTH_GAP);
    bottom_gap = val_or_default(bottom_gap, DRAWER_BOTTOM_GAP);
    nominal_drawer_height = val_or_default(nominal_drawer_height, DRAWER_HEIGHT);
    face_overlay = val_or_default(face_overlay, FACE_OVERLAY);

    explode_offset = explode * opening_depth;


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
        TOREAR()
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
        dado_depth=dado_depth,
        face_width=face_width,
        part="mid_drawer_hi",
        hide=hide
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
        dado_depth=dado_depth,
        face_width=face_width,
        part="mid_drawer_low",
        hide=hide
      );

      // TODO this offset is obviously nonsense
      door_z_offset = carcas_height - nominal_drawer_height*2 + 119;

      door_height = (
        carcas_height 
        - nominal_drawer_height*2
        - face_width 
        - carcas_thickness
      );
      door_width = opening_width/2 - face_overlay;

      //
      // MIDDLE DOORS
      //
      Z(door_z_offset)
      pieces(2)
      X(vRepeat(0, opening_width/2 + face_overlay))
      door(
        opening_depth,
        door_width,
        door_height,
        carcas_thickness=carcas_thickness,
        face_trim_thickness=face_trim_thickness,
        face_trim_material=face_trim_material,
        face_panel_thickness=face_panel_thickness,
        face_panel_material=face_panel_material,
        face_overlay=face_overlay,
        dado_depth=dado_depth,
        face_width=face_width,
        part="mid_door"
      );
    }
    children();
}

module side_storage(
    opening_depth,
    opening_width,
    opening_height,
    carcas_height=undef,
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
    hide="",
    explode=0
){
    carcas_height = val_or_default(carcas_height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
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

    
    explode_offset = explode * opening_depth;
    actual_drawer_height = nominal_drawer_height - face_width/2;

    g(
        Y(
            carcas_thickness
            + panel_thickness
            + depth_gap
            + explode_offset
        ),
        TOREAR()
    ){
        //
        // SIDE DRAWERS
        //
        
        Z(
            // TODO offsets probably bullshit
            carcas_height
            - nominal_drawer_height
            - (nominal_drawer_height - actual_drawer_height)/2
            + bottom_gap
        )
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
          dado_depth=dado_depth,
          face_width=face_width,
          part="side_drawer",
          hide=hide
        );


        // TODO this offset is obviously nonsense
        door_z_offset = 227;

        door_height = (
          carcas_height 
          - nominal_drawer_height 
          - face_width 
          - carcas_thickness
        );
        //
        // SIDE DOORS
        //
        Z(door_z_offset)
        door(
          opening_depth,
          opening_width,
          door_height,
          carcas_thickness=carcas_thickness,
          face_trim_thickness=face_trim_thickness,
          face_trim_material=face_trim_material,
          face_panel_thickness=face_panel_thickness,
          face_panel_material=face_panel_material,
          face_overlay=face_overlay,
          dado_depth=dado_depth,
          face_width=face_width,
          part="side_door"
        );
    }
    children();
}

module storage(
    depth=undef,
    height=undef,
    width=undef,
    face_width=undef,
    face_trim_thickness=undef,
    face_trim_material=undef,
    divisions=undef,
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
    hide="",
    explode=0
){

  depth = val_or_default(depth, TOT_DEPTH);
  width = val_or_default(width, TOT_WIDTH);
  divisions = val_or_default(divisions, DIVISIONS);
  division_width = width / divisions;
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
  middle_storage(
    opening_depth,
    opening_width_middle,
    opening_height,
    face_trim_thickness=face_trim_thickness,
    face_trim_material=face_trim_material,
    nominal_drawer_height=drawer_height,
    dado_depth=dado_depth,
    panel_thickness=panel_thickness,
    panel_material=panel_material,
    carcas_height=height,
    carcas_thickness=carcas_thickness,
    carcas_material=carcas_material,
    bottom_material=bottom_material,
    face_panel_thickness=face_panel_thickness,
    face_panel_material=face_panel_material,
    face_overlay=face_overlay,
    depth_gap=depth_gap,
    hide=hide,
    explode=explode,
    face_width=face_width
  );

  side_split = (width - division_width)/2; 
  X(face_width)
  pieces(2)
  X(span(width - division_width - carcas_thickness))
  side_storage(
    opening_depth,
    opening_width_sides,
    opening_height,
    carcas_height=height,
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
    hide=hide,
    explode=explode
  );
}

