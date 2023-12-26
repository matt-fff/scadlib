include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>
include <scadlib/cabinet/faces/slab.scad>
include <scadlib/cabinet/faces/shaker.scad>

module storage_face(
  opening_width,
  opening_height,
  face_style=undef,
  trim_thickness=undef,
  trim_width=undef,
  trim_overlay=undef,
  trim_material=undef,
  tenon_thickness=undef,
  tenon_depth=undef,
  panel_thickness=undef,
  panel_material=undef,
  part=undef,
  hide=[]
){

    face_style = val_or_default(face_style, SLAB);

    if(face_style == SHAKER) {
      shaker_face(
        opening_width=opening_width,
        opening_height=opening_height,
        trim_thickness=trim_thickness,
        trim_width=trim_width,
        trim_material=trim_material,
        trim_overlay=trim_overlay,
        panel_thickness=panel_thickness,
        panel_material=panel_material,
        part=part
      );
    } else if(face_style == SLAB) {
      slab_face(
        opening_width=opening_width,
        opening_height=opening_height,
        face_overlay=trim_overlay,
        thickness=trim_thickness,
        material=trim_material,
        part=part
      );
    }
}

module face_plate(
    depth=undef,
    height=undef,
    width=undef,
    face_thickness=undef,
    face_width=undef,
    carcas_thickness=undef,
    divisions=undef
){

  g(
    Y(depth - face_thickness)
  ) {
    face_plate_outline(
        depth=depth,
        height=height,
        width=width,
        face_thickness=face_thickness,
        face_width=face_width,
        carcas_thickness=carcas_thickness,
        divisions=divisions
    );
    face_plate_storage(
        depth=depth,
        height=height,
        width=width,
        face_thickness=face_thickness,
        face_width=face_width,
        carcas_thickness=carcas_thickness,
        divisions=divisions
    );
  }
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
    divisions=undef
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
    width = val_or_default(width, TOT_WIDTH);
    face_width = val_or_default(face_width, FACE_WIDTH);
    face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
    face_material = val_or_default(face_material, FACE_MATERIAL);
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    divisions = val_or_default(divisions, DIVISIONS);

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
        Z(face_carcas_diff),
        TOREAR()
    ){
        //
        // FRAME RAILS
        //
        
        // Top and bottom
        pieces(2)
        Z(
          span(
            height - 
            min(carcas_thickness, face_width)
          )
        )
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
          // FRAME VERTICAL DIVIDERS
          //
          
          pieces(len(divisions) + 1)
          X( 
            span(width - face_width)
          )
          logbox(
              face_thickness,
              x=face_width,
              h=stile_height,
              part=part,
              material=material,
              subpart="vert-divider"
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
    divisions=undef
){
  depth = val_or_default(depth, TOT_DEPTH);
  height = val_or_default(height, TOT_HEIGHT - KICK_HEIGHT - TOP_THICKNESS);
  width = val_or_default(width, TOT_WIDTH);
  face_width = val_or_default(face_width, FACE_WIDTH);
  face_thickness = val_or_default(face_thickness, FACE_THICKNESS);
  face_material = val_or_default(face_material, FACE_MATERIAL);
  carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
  divisions = val_or_default(divisions, DIVISIONS);


  material = face_material;
  part = "face_plate_storage";

  overall_opening_height = height - (
    max(carcas_thickness, face_width)
    + carcas_thickness
  );

  rail_width = (
    width - (
      max(2, len(divisions) + 1) * face_width
    )
  ) / len(divisions);
  
  X(face_width)
  pieces(len(divisions))
  X( 
    spanAllButLast(width - face_width)
  )
  g() {
    division = divisions[every(1)];

    opening_heights = pct_to_val(overall_opening_height, division, split_size=face_width, idx=1);
    nominal_heights = pct_to_val(height, division, idx=1);
    cumulative_heights = accumulate(opening_heights);

    g(
        Z(
            carcas_thickness/2
        ),
        TOREAR()
    ){
      pieces(len(division) - 1)
      g(){
        index = every(1) + 1;
        height_offset = cumulative_heights[index] + index*face_width;

        X(rail_width/2)
        Z(height_offset - (face_width - carcas_thickness)/2)
        logbox(
            face_thickness,
            x=rail_width,
            h=face_width,
            part=part,
            material=material,
            subpart="horiz-divider"
        );
      }
    }
  }

  children();
}


