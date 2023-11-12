include <constructive/constructive-compiled.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/const.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/drawer.scad>
include <scadlib/cabinet/door.scad>

module storage_subdivision(
    storage_type,
    opening_depth,
    opening_width,
    opening_height,
    face_trim_thickness=undef,
    face_trim_material=undef,
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
  face_overlay = val_or_default(face_overlay, FACE_OVERLAY);



  if(DRAWER == storage_type){
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
        hide=hide,
        part="drawer",
        explode=explode
      );
  }
  if(DOOR == storage_type){
      door(
        opening_depth,
        opening_width,
        opening_height,
        carcas_thickness=carcas_thickness,
        face_trim_thickness=face_trim_thickness,
        face_trim_material=face_trim_material,
        face_panel_thickness=face_panel_thickness,
        face_panel_material=face_panel_material,
        face_overlay=face_overlay,
        dado_depth=dado_depth,
        face_width=face_width,
        part="door",
        explode=explode
      );
  }
  if(DOUBLE_DOOR == storage_type){
      door_width = opening_width/2 - face_overlay;

      pieces(2)
      X(vRepeat(0, opening_width/2 + face_overlay))
      door(
        opening_depth,
        door_width,
        opening_height,
        carcas_thickness=carcas_thickness,
        face_trim_thickness=face_trim_thickness,
        face_trim_material=face_trim_material,
        face_panel_thickness=face_panel_thickness,
        face_panel_material=face_panel_material,
        face_overlay=face_overlay,
        dado_depth=dado_depth,
        face_width=face_width,
        part="double-door",
        explode=explode
      );
  }
}

module storage_division(
    division,
    opening_depth,
    opening_width,
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
    types = [for (d = division) d[0]];
    heights = [for (d = division) carcas_height*d[1]];
    cumulative_heights = [ for (
      a=0, b=0;
      a < len(heights);
      a= a+1, b=b+heights[a-1])
        b
    ];

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
      pieces(len(division))
      g(){
        index = every(1);
        nominal_height = heights[index];
        opening_height = nominal_height - 2*face_trim_thickness;
        height_offset = cumulative_heights[index];

        //echo(str("index, height, height_offset: ", str([index, height, height_offset])));

        Z(height_offset)
        storage_subdivision(
          types[index],
          opening_depth,
          opening_width,
          opening_height,
          carcas_height=carcas_height,
          face_width=face_width,
          face_trim_thickness=face_trim_thickness,
          face_trim_material=face_trim_material,
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
  face_overlay = val_or_default(face_overlay, FACE_OVERLAY);
  divisions = val_or_default(divisions, DIVISIONS);
  division_width = width / len(divisions);
  opening_depth = depth - panel_thickness - carcas_thickness;

  
  // exterior is limited by face width, 
  // since it's larger than and flush with the carcas
  side_ext_offset = face_width;
  // interior is limited by the carcas plus the face overlap
  side_int_offset = face_width - 2*carcas_thickness + carcas_thickness;

  opening_width = division_width - 2*carcas_thickness;
  
  X(max(face_width - face_overlay, carcas_thickness))
  pieces(len(divisions))
  X( 
    spanAllButLast(width)
  )
  storage_division(
    divisions[every(1)],
    opening_depth,
    opening_width,
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

