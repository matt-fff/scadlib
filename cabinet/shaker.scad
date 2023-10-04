include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/cabinet/defaults.scad>



TENON_DEPTH = DADO_DEPTH * 3;
TENON_THICKNESS = FACE_THICKNESS / 3;

module rail(
  width,
  height,
  thickness=undef,
  tenon_depth=undef,
  tenon_thickness=undef,
  is_top=true,
  part="face",
  should_log=true
){
  thickness = val_or_default(thickness, FACE_THICKNESS);
  tenon_depth = val_or_default(tenon_depth, TENON_DEPTH);
  tenon_thickness = val_or_default(tenon_thickness, TENON_THICKNESS);

  width_with_tenon = width + tenon_depth*2;
  tenon_void_thickness = thickness - tenon_thickness*2;


  assemble(){
    add()
    logbox(
      thickness,
      x=width_with_tenon,
      h=height,
      part=part,
      subpart="rail",
      should_log=should_log
    );

    remove()
    pieces(2)
    Y(vRepeat(0, 1) * (thickness - tenon_thickness))
    pieces(2)
    X(vRepeat(1, -1) * width_with_tenon/2)
    box(
      tenon_void_thickness,
      x=tenon_depth,
      h=height
    );

    tenon_vert_offset = (
      height -
      tenon_depth 
    );

    remove()
    Y(tenon_void_thickness)
    Z(tenon_vert_offset * (is_top ? -1 : 1))
    box(
      // This multiplier is necessary due to 
      // floating point rounding on tenon_void_thickness
      tenon_thickness * 1.0001,
      x=width_with_tenon,
      h=tenon_depth
    );
  }
  children();
}

module stile(
  width,
  height,
  thickness=undef,
  tenon_depth=undef,
  tenon_thickness=undef,
  is_left=true,
  part="face",
  should_log=true
){
  thickness = val_or_default(thickness, FACE_THICKNESS);
  tenon_depth = val_or_default(tenon_depth, TENON_DEPTH);
  tenon_thickness = val_or_default(tenon_thickness, TENON_THICKNESS);
  
  tenon_void_thickness = thickness - tenon_thickness*2;
  assemble(){
    add()
    logbox(
      thickness,
      x=width,
      h=height,
      part=part,
      subpart="stile",
      should_log=should_log
    );

    tenon_horiz_offset = (
      width -
      tenon_depth 
    );

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

module shaker_face(
  width,
  height,
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
    trim_thickness = val_or_default(trim_thickness, FACE_THICKNESS);
    trim_width = val_or_default(trim_width, FACE_WIDTH);
    trim_overlay = val_or_default(trim_overlay, FACE_OVERLAY);
    trim_material = val_or_default(trim_material, FACE_MATERIAL);
    tenon_thickness = val_or_default(tenon_thickness, TENON_THICKNESS);
    tenon_depth = val_or_default(tenon_depth, TENON_DEPTH);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    panel_material = val_or_default(panel_material, PANEL_MATERIAL);

    // Rails
    g(
      Z(-(height - trim_width)/2),
      X(width/2)
    ){
      pieces(2)
      Z(span(height - trim_width))
      add()
      rail(
        width=width - trim_width*2,
        height=trim_width,
        thickness=trim_thickness,
        tenon_depth=tenon_depth,
        tenon_thickness=tenon_thickness,
        is_top=vRepeat(false, true),
        part=part
      );
      children();
    }

    // Stiles
    //X(trim_width - tenon_depth)
    pieces(2)
    X(span(width - trim_width))
    stile(
      width=trim_width,
      height=height,
      thickness=trim_thickness,
      tenon_depth=tenon_depth,
      tenon_thickness=tenon_thickness,
      is_left=vRepeat(false, true),
      part=part
    );
    children();
}
