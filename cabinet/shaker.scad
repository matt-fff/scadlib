include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/cabinet/defaults.scad>



tenon_depth = dado_depth * 3;
tenon_thickness = face_thickness / 3;

module rail(
  width,
  height,
  thickness=face_thickness,
  tenon_depth=tenon_depth,
  tenon_thickness=tenon_thickness,
  is_top=true,
  part="face",
  should_log=true
){
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
  thickness=face_thickness,
  tenon_depth=tenon_depth,
  tenon_thickness=tenon_thickness,
  is_left=true,
  part="face",
  should_log=true
){
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
  trim_thickness=face_thickness,
  trim_width=face_width,
  trim_overlay=face_overlay,
  trim_material=face_material,
  tenon_thickness=tenon_thickness,
  tenon_depth=tenon_depth,
  panel_thickness=panel_thickness,
  panel_material=panel_material,
  part="face"
){
    // Rails
    g(
      Z(-(height - trim_width)/2),
      X(width/2)
    ){
      pieces(2)
      Z(span(height - trim_width))
      add()
      rail(
        width=width - trim_width,
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
    pieces(2)
    X(span(width))
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
