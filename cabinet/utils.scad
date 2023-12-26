include <scadlib/common/utils.scad>
include <scadlib/cabinet/const.scad>
 
function division_carcas_widths(
  tot_width,
  face_width,
  carcas_thickness,
  divisions
) = (
  len(divisions) <= 2 ? (
  let(
      div_width = len(divisions) > 0 ? tot_width / len(divisions) : 0
    ) [for (i=divisions) div_width]
  ) : (
  let(
    side_width = (
      (tot_width / len(divisions)) + (2*face_width - 3*carcas_thickness)/2)
  ) let(
    middle_width = (tot_width - side_width*2) / (len(divisions) - 2)
  ) [
    side_width,
    each([for (i = [1 : len(divisions) - 2]) middle_width]),
    side_width
  ]
  )
);

function fmt_parts(parts, hidden) = join(remove_intersection(parts, hidden), ",");

module validate_division(division) {
  for (div = division) {
    assert(len(div) >= 2);
    assert(len(div) <= 3);
    assert(in(div[0], [DOOR, DOUBLE_DOOR, DRAWER, BLANK]));
    assert(div[1] <= 1);
    assert(div[1] > 0);
  }

  proportions = [for (div = division) div[1]];
  total_prop = sum(proportions);
  assert(total_prop > 0.999);
  assert(total_prop < 1.001);
}

module validate_divisions(divisions) {
    for (division = divisions) {
      validate_division(division);
    }
}

function pct_to_val(
  overall,
  divisions,
  split_size=0,
  idx=undef
) = (
   [
     for (d = divisions) (
      overall - (
        split_size * (len(divisions) - 1)
      )
     )*(idx == undef ? d : d[idx])
   ]
);
