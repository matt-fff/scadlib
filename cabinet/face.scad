include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>


module face(
    depth=undef,
    height=undef,
    width=undef,
    face_thickness=undef,
    face_width=undef,
    carcas_thickness=undef,
    division_width=undef
){
  face_plate_outline(
      depth=depth,
      height=height,
      width=width,
      face_thickness=face_thickness,
      face_width=face_width,
      carcas_thickness=carcas_thickness,
      division_width=division_width
  );
  face_plate_storage(
      depth=depth,
      height=height,
      width=width,
      face_thickness=face_thickness,
      face_width=face_width,
      carcas_thickness=carcas_thickness,
      division_width=division_width
  );
  children();
}

module face_plate_outline(
    depth=undef,
    height=undef,
    width=undef,
    face_thickness=undef,
    face_width=undef,
    face_material=undef,
    carcas_thickness=undef,
    division_width=undef
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    width = val_or_default(width, TOT_WIDTH);
    face_width = val_or_default(face_width, FACE_WIDTH);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    face_material = val_or_default(face_material, FACE_MATERIAL);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    division_width = val_or_default(division_width, DIVISION_WIDTH);

    material = face_material;
    part = "face_plate_outline";
    rail_width = width;
    stile_height = height - face_width - carcas_thickness;

    face_carcas_diff = -(face_width/2 - carcas_thickness);

    //
    // FRAME OUTLINE
    //
    TORIGHT()
    g(
        Y(depth - face_thickness),
        Z(face_carcas_diff),
        TOREAR()
    ){
        //
        // FRAME RAILS
        //
        
        // Top and bottom
        pieces(2)
        Z(span(height - carcas_thickness))
        logbox(
            face_thickness,
            x=rail_width,
            h=face_width,
            part=part,
            material=material,
            subpart=vRepeat("bottom", "top")
        );

        g(
          Z((stile_height + face_width)/2)
        ){
          //
          // FRAME STILES
          //
          // Right and left
          pieces(2)
          X(span(width - face_width))
          logbox(
              face_thickness,
              x=face_width,
              h=stile_height,
              part=part,
              material=material,
              subpart=vRepeat("right", "left")
          );
          
          //
          // FRAME VERTICAL DIVIDERS
          //
          
          X(division_width - face_width/2 + face_carcas_diff)
          pieces(2)
          X(span(division_width - face_carcas_diff*2))
          logbox(
              face_thickness,
              x=face_width,
              h=stile_height,
              part=part,
              material=material,
              subpart=vRepeat("right_divider", "left_divider")
          );
        }
    }
    children();
}

module face_plate_storage(
    depth=undef,
    height=undef,
    width=undef,
    face_width=undef,
    face_thickness=undef,
    face_material=undef,
    carcas_thickness=undef,
    division_width=undef,
    drawer_height=undef
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    width = val_or_default(width, TOT_WIDTH);
    face_width = val_or_default(face_width, FACE_WIDTH);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    face_material = val_or_default(face_material, FACE_MATERIAL);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    division_width = val_or_default(division_width, DIVISION_WIDTH);
    drawer_height = val_or_default(drawer_height, DRAWER_HEIGHT);

    face_carcas_diff = -(face_width/2 - carcas_thickness);

    material = face_material;
    part = "face_plate_storage";
    TORIGHT()
    g(
        Y(depth - face_thickness),
        Z(face_carcas_diff),
        TOREAR()
    ){
        //
        // SIDE HORIZONTAL DIVIDERS
        //

        side_drawer_width = (
            division_width
            - face_width
            - face_width/2
            + face_carcas_diff
        );
        
        Z(
            height - 
            face_width/2 - 
            drawer_height
        )
        X(face_width)
        // Right Horizontal Divider
        logbox(
            face_thickness,
            x=side_drawer_width,
            h=face_width,
            part=part,
            material=material,
            subpart="right_divider"
        )
        // Left Horizontal Divider
        X(division_width*2 - face_width/2 - face_carcas_diff)
        logbox(
            face_thickness,
            x=side_drawer_width,
            h=face_width,
            part=part,
            material=material,
            subpart="left_divider"
        );
        
        //
        // CENTER HORIZONTAL DIVIDERS
        //

        middle_drawer_width = (
            division_width
            - face_width 
            - face_carcas_diff*2
        );
        
        X(division_width + face_width/2 + face_carcas_diff)
        Z(drawer_height - face_carcas_diff/2)
        logbox(
            face_thickness,
            x=middle_drawer_width,
            h=face_width,
            part=part,
            material=material,
            subpart=vRepeat("bottom_center_divider", "top_center_divider")
        )
        // Bottom Horizontal Divider
        Z(drawer_height - face_carcas_diff/2)
        logbox(
            face_thickness,
            x=middle_drawer_width,
            h=face_width,
            part=part,
            material=material,
            subpart="center_divider"
        );
    }
    children();
}


