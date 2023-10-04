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
    face_overlay = val_or_default(face_overlay, FACE_OVERLAY);
    face_width = val_or_default(face_width, FACE_WIDTH);
    bottom_material = val_or_default(bottom_material, PANEL_MATERIAL);

    part = "drawer";
    height_gap = bottom_gap + top_gap;
    center_offset = (width - shell_thickness) / 2;
    shell_height = height - height_gap - face_overlay*2;

    // Align everything with the bottom of the drawer
    //Z((face_width - face_overlay)
    //TOUP()
    assemble() { 
      // Rear
      add()
      //Z(bottom_recess)
      X(center_offset)
      logbox(
          shell_thickness,
          x=width - (width_gap + shell_thickness)*2,
          h=shell_height - bottom_recess,
          part=part,
          material=shell_material,
          subpart="rear"
      );

      // Bottom panel
      //Z(-(height + bottom_thickness)/2)
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
          h=shell_height,
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
          h=shell_height,
          part=part,
          material=shell_material,
          subpart="side"
      );

      // Face
      add()
      Y(depth)
      shaker_face(
        width=width,
        height=height,
        trim_thickness=face_trim_thickness,
        trim_width=face_width,
        trim_material=face_trim_material,
        trim_overlay=face_overlay,
        panel_thickness=face_panel_thickness,
        panel_material=face_panel_material,
        part="drawer_face"
      );
    }
    children();
}
