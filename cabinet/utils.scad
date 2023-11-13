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
