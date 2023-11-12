include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/cabinet/defaults.scad>

TENON_DEPTH = DADO_DEPTH * 3;
TENON_THICKNESS = FACE_THICKNESS / 3;

// This multiplier is necessary due to 
// floating point rounding
FLOAT_COEFF = 1.0001;


module face_rail(
  width,
  height,
  thickness=undef,
  tenon_depth=undef,
  tenon_thickness=undef,
  material=undef,
  is_top=true,
  part="face",
  should_log=true
){
  thickness = val_or_default(thickness, FACE_THICKNESS);
  tenon_depth = val_or_default(tenon_depth, TENON_DEPTH);
  tenon_thickness = val_or_default(tenon_thickness, TENON_THICKNESS);
  material = val_or_default(material, FACE_MATERIAL);

  width_with_tenon = width + tenon_depth*2;
  tenon_void_thickness = thickness - tenon_thickness*2;


  Y(-tenon_void_thickness)
  assemble(){
    add()
    logbox(
      thickness,
      x=width_with_tenon,
      h=height,
      part=part,
      subpart="rail",
      should_log=should_log,
      material=material
    );

    remove()
    pieces(2)
    Y(vRepeat(0, 1) * (thickness - tenon_thickness))
    pieces(2)
    X(vRepeat(1, -1) * width_with_tenon/2 - tenon_depth/2)
    box(
      tenon_void_thickness,
      x=tenon_depth,
      h=height
    );

    tenon_vert_offset = (height + tenon_depth)/2 - tenon_depth;

    remove()
    Y(tenon_void_thickness)
    Z(tenon_vert_offset * (is_top ? -1 : 1))
    box(
      tenon_thickness * FLOAT_COEFF,
      x=width_with_tenon,
      h=tenon_depth
    );
  }
  children();
}

module face_stile(
  width,
  height,
  thickness=undef,
  tenon_depth=undef,
  tenon_thickness=undef,
  material=undef,
  is_left=true,
  part="face",
  should_log=true
){
  thickness = val_or_default(thickness, FACE_THICKNESS);
  tenon_depth = val_or_default(tenon_depth, TENON_DEPTH);
  tenon_thickness = val_or_default(tenon_thickness, TENON_THICKNESS);
  material = val_or_default(material, FACE_MATERIAL);
  
  tenon_void_thickness = thickness - tenon_thickness*2;
  Y(-tenon_void_thickness)
  assemble(){
    add()
    logbox(
      thickness,
      x=width,
      h=height,
      part=part,
      subpart="stile",
      material=material,
      should_log=should_log
    );

    tenon_horiz_offset = (width + tenon_depth)/2 - tenon_depth;

    remove()
    Y(tenon_void_thickness)
    X(tenon_horiz_offset * (is_left ? -1 : 1))
    box(
      // This multiplier is necessary due to 
      // floating point rounding on tenon_void_thickness
      tenon_thickness * 1.0001,
      x=tenon_depth,
      h=height
    );
  }
  children();
}


module face_panel(
  opening_width,
  opening_height,
  trim_width=undef,
  trim_overlay=undef,
  tenon_thickness=undef,
  tenon_depth=undef,
  thickness=undef,
  material=undef,
  part="face",
  should_log=true
){
  thickness = val_or_default(thickness, FACE_PANEL_THICKNESS);
  tenon_depth = val_or_default(tenon_depth, TENON_DEPTH);
  tenon_thickness = val_or_default(tenon_thickness, TENON_THICKNESS);
  material = val_or_default(material, FACE_PANEL_MATERIAL);
  trim_overlay = val_or_default(trim_overlay, FACE_OVERLAY);
  
  tenon_void_thickness = thickness - tenon_thickness;

  face_width = opening_width + 2*trim_overlay;
  face_height = opening_height + 2*trim_overlay;

  overlay_offset = (trim_width - tenon_depth);
  width = opening_width - overlay_offset;
  height = opening_height - overlay_offset;
  Y(-tenon_void_thickness)
  X(opening_width/2)
  assemble(){
    add()
    logbox(
      thickness,
      x=width,
      h=height,
      part=part,
      subpart="panel",
      material=material,
      should_log=should_log
    );

    remove()
    Z(-(height - tenon_depth)/2)
    pieces(2) 
    Z(span(height - tenon_depth))
    box(
      tenon_void_thickness,
      x=width,
      h=tenon_depth * FLOAT_COEFF
    );
    
    remove()
    X(-(width - tenon_depth)/2)
    pieces(2) 
    X(span(width - tenon_depth))
    box(
      tenon_void_thickness,
      x=tenon_depth * FLOAT_COEFF,
      h=height
    );
  }
  children();
}

module face_trim(
  opening_width,
  opening_height,
  trim_thickness=undef,
  trim_width=undef,
  trim_overlay=undef,
  trim_material=undef,
  tenon_thickness=undef,
  tenon_depth=undef,
  panel_thickness=undef,
  panel_material=undef,
  part="face",
  should_log=true
){
  trim_thickness = val_or_default(trim_thickness, FACE_THICKNESS);
  trim_width = val_or_default(trim_width, FACE_WIDTH);
  trim_overlay = val_or_default(trim_overlay, FACE_OVERLAY);
  trim_material = val_or_default(trim_material, FACE_MATERIAL);
  tenon_thickness = val_or_default(tenon_thickness, TENON_THICKNESS);
  tenon_depth = val_or_default(tenon_depth, TENON_DEPTH);
  panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
  panel_material = val_or_default(panel_material, PANEL_MATERIAL);

  face_width = opening_width + 2*trim_overlay;
  face_height = opening_height + 2*trim_overlay;

  // TODO might be bullshit
  horiz_offset = (face_width - trim_width - opening_width)/2 + tenon_depth;
  vert_offset = (face_height - trim_width)/2;

  // Rails
  add()
  X((opening_width/2))
  g(Z(-vert_offset)){
    pieces(2)
    Z(span(face_height - trim_width))
    add()
    face_rail(
      width=face_width - trim_width*2,
      height=trim_width,
      thickness=trim_thickness,
      tenon_depth=tenon_depth,
      tenon_thickness=tenon_thickness,
      is_top=vRepeat(false, true),
      part=part,
      material=trim_material,
      should_log=should_log
    );
  }

  // Stiles
  add()
  X(horiz_offset)
  pieces(2)
  X(span(face_width - trim_width))
  face_stile(
    width=trim_width,
    height=face_height,
    thickness=trim_thickness,
    tenon_depth=tenon_depth,
    tenon_thickness=tenon_thickness,
    is_left=vRepeat(false, true),
    part=part,
    material=trim_material,
    should_log=should_log
  );
  children();
}

module shaker_face(
  opening_width,
  opening_height,
  trim_thickness=undef,
  trim_width=undef,
  trim_overlay=undef,
  trim_material=undef,
  tenon_thickness=undef,
  tenon_depth=undef,
  panel_thickness=undef,
  panel_material=undef,
  part="face"
){
    Z(opening_height/2)
    assemble() {

      // Technically this isn't the right size,
      // but we're just going to use the face trim
      // to carve it down to the right size.
      add()
      face_panel(
        opening_width,
        opening_height,
        trim_width=trim_width,
        trim_overlay=trim_overlay,
        thickness=panel_thickness,
        tenon_thickness=tenon_thickness,
        tenon_depth=tenon_depth,
        part=part
      );

      add()
      face_trim(
        opening_width,
        opening_height,
        trim_thickness=trim_thickness,
        trim_width=trim_width,
        trim_overlay=trim_overlay,
        trim_material=trim_material,
        tenon_thickness=tenon_thickness,
        tenon_depth=tenon_depth,
        part=part
      );
    }
    children();
}
