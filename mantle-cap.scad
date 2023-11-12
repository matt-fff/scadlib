include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>


module mantle_cap(
  intern_width=inch_to_mm(52 + 1/8),
  intern_height=inch_to_mm(3),
  intern_top_depth=inch_to_mm(9 + 5/8),
  intern_bottom_depth=inch_to_mm(5 + 3/4),
  intern_margin=inch_to_mm(1/4),
  thickness=inch_to_mm(0.25),
  material="plywood"
) {
    part = "mantle_cap"; 

    width = intern_width + (
      intern_margin + thickness
    ) * 2;

    height = intern_height + thickness + intern_margin;

    top_depth = intern_top_depth + thickness + intern_margin;
    bottom_depth = intern_bottom_depth + thickness + intern_margin;

    
    g(
      TOREAR()
    ) {
      logbox(
        top_depth,
        x=width,
        h=thickness,
        part=part,
        subpart="top",
        material=material
      );

      Z(-height)
      logbox(
        bottom_depth,
        x=width,
        h=thickness,
        part=part,
        subpart="bottom",
        material=material
      );


      g(
        Z(-(height + thickness)/2)
      ) {
        X(thickness)
        pieces(2)
        X(span(width-thickness) - (width + thickness)/2)
        logbox(
          top_depth,
          x=thickness,
          h=height,
          part=part,
          subpart="side",
          material=material
        );

        logbox(
          thickness,
          x=width,
          h=height,
          part=part,
          subpart="face",
          material=material
        );
      }
    }
}

opaq(brown)
mantle_cap();
