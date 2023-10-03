include <scadlib/common/utils.scad>

tot_width = inch_to_mm(72);
tot_height = inch_to_mm(39);
tot_depth = inch_to_mm(18.5);

carcas_material = "3/4 plywood";
carcas_thickness = inch_to_mm(0.75);
brace_width = inch_to_mm(3.125);

top_material = "3/4 top";
top_thickness = inch_to_mm(0.75);
top_overhang = inch_to_mm(0.75);

face_material = "3/4 hardwood";
face_thickness = inch_to_mm(0.75);
face_width = carcas_thickness * 2;

kick_height = inch_to_mm(3.5);
drawer_height = inch_to_mm(9);

panel_material = "1/4 plywood";
panel_thickness = inch_to_mm(0.25);
dado_depth = inch_to_mm(0.25);
