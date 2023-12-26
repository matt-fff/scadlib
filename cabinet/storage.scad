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
    face_style=undef,
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
    explode=0
){
  face_overlay = val_or_default(face_overlay, FACE_OVERLAY);


  if(DRAWER == storage_type){
      drawer(
        opening_depth,
        opening_width,
        opening_height,
        face_style=face_style,
        depth_gap=depth_gap,
        top_gap=top_gap,
        bottom_gap=bottom_gap,
        bottom_recess=bottom_recess,
        panel_thickness=panel_thickness,
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
        part="drawer",
        explode=explode
      );
  }
  if(DOOR == storage_type){
      door(
        opening_depth,
        opening_width,
        opening_height,
        face_style=face_style,
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
        face_style=face_style,
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
    explode=0
){

    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    depth_gap = val_or_default(depth_gap, DRAWER_DEPTH_GAP);
    bottom_gap = val_or_default(bottom_gap, DRAWER_BOTTOM_GAP);
    nominal_drawer_height = val_or_default(nominal_drawer_height, DRAWER_HEIGHT);
    face_overlay = val_or_default(face_overlay, FACE_OVERLAY);

    // The actual opening is the carcas_height minus the thickness
    // of the shell/trim on the top and bottom
    overall_opening_height = carcas_height - (face_width + carcas_thickness);
    overall_nominal_height = carcas_height + face_overlay*2;

    explode_offset = explode * opening_depth;
    types = [for (d = division) d[0]];
    opening_heights = pct_to_val(overall_opening_height, division, split_size=face_width, idx=1);
    nominal_heights = pct_to_val(overall_nominal_height, division, idx=1);
    styles = [for (d = division) len(d) < 3 ? SLAB : d[2]];
    cumulative_heights = accumulate(opening_heights);

    g(
        Y(
            explode_offset
            + depth_gap
        ),
        Z(
            carcas_thickness
        ),
        X(-opening_width/2),
        TOREAR()
    ){
      pieces(len(division))
      g(){
        index = every(1);
        opening_height = opening_heights[index];
        nominal_height = nominal_heights[index];
        height_offset = cumulative_heights[index] + index*face_width;

        Z(height_offset)
        storage_subdivision(
          types[index],
          opening_depth,
          opening_width,
          opening_height,
          face_style=styles[index],
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
          explode=explode,
          bottom_gap=bottom_gap
        );
      }
    }
    children();
}
module storage(
    width,
    division,
    protrusion=undef,
    depth=undef,
    height=undef,
    face_width=undef,
    face_trim_thickness=undef,
    face_trim_material=undef,
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
    explode=0
){

  depth = val_or_default(depth, TOT_DEPTH);
  face_overlay = val_or_default(face_overlay, FACE_OVERLAY);
  carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
  panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
  depth_gap = val_or_default(depth_gap, DRAWER_DEPTH_GAP);
  protrusion = val_or_default(protrusion, 0);
  opening_depth = depth - (
    panel_thickness 
    + carcas_thickness
  ) + protrusion;

  opening_width = width - max(2*carcas_thickness, face_width);
  
  X(width/2)
  storage_division(
    division,
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
    explode=explode
  );
}

