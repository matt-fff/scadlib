include <constructive/constructive-compiled.scad> 

// Function to convert inches to millimeters
function inches_to_mm(inches) = inches * 25.4;

tot_width = inches_to_mm(72);
tot_height = inches_to_mm(39);
tot_depth = inches_to_mm(20);

carcas_thickness = inches_to_mm(0.75);
top_thickness = inches_to_mm(0.75);
kick_height = inches_to_mm(3.5);



module kick_plate(
    height=kick_height,
    thickness=carcas_thickness
){

    TOFRONT()
    TORIGHT()
    pieces(2)
    Y(span(tot_depth))
    box(
        thickness,
        x=tot_width,
        h=height
    );
    
    TOFRONT()
    TORIGHT()
    pieces(2)
    X(span(tot_width - thickness))
    turnXY(90)
    box(
        thickness,
        x=tot_depth - thickness,
        h=height
    );
}

module frame(
    height=tot_height - kick_height - top_thickness,
    thickness=carcas_thickness
){

    TOFRONT()
    TORIGHT()
    pieces(2)
    Y(span(tot_depth))
    box(
        thickness,
        x=tot_width,
        h=height
    );
    
    TOFRONT()
    TORIGHT()
    pieces(2)
    X(span(tot_width - thickness))
    turnXY(90)
    box(
        thickness,
        x=tot_depth - thickness,
        h=height
    );
}

module carcas(){
    TODOWN()opaq(blue)kick_plate();
    TOUP()opaq(pink)frame();
}

carcas();