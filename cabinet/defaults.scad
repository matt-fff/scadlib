include <scadlib/common/utils.scad>

TOT_WIDTH = inch_to_mm(72);
TOT_HEIGHT = inch_to_mm(39);
TOT_DEPTH = inch_to_mm(18.5);

DIVISIONS = 3;
DIVISION_WIDTH = TOT_WIDTH / DIVISIONS;

TOP_THICKNESS = inch_to_mm(0.75);

FACE_MATERIAL = "3/4 hardwood";
FACE_THICKNESS = inch_to_mm(0.75);
FACE_WIDTH = inch_to_mm(1.75);
FACE_OVERLAY = inch_to_mm(0.5);

KICK_HEIGHT = inch_to_mm(3.5);

PANEL_MATERIAL = "1/4 plywood";
PANEL_THICKNESS = inch_to_mm(0.25);
DADO_DEPTH = inch_to_mm(0.25);

CARCAS_MATERIAL = "3/4 plywood";
CARCAS_THICKNESS = inch_to_mm(0.75);

DRAWER_HEIGHT = inch_to_mm(9);

FACE_PANEL_MATERIAL = "1/2 mdf";
FACE_PANEL_THICKNESS = inch_to_mm(0.5);
