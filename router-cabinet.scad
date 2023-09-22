include <constructive/constructive-compiled.scad> 

// Function to convert inches to millimeters
function inches_to_mm(inches) = inches * 25.4;

tot_width = inches_to_mm(72);
tot_height = inches_to_mm(39);
tot_depth = inches_to_mm(20);


module kick_plate(
    height=inches_to_mm(3.5),
    thickness=inches_to_mm(0.75)
){ 
    rel_depth = tot_depth - thickness;
    rel_width = tot_width - thickness;


    TOFRONT()
    TORIGHT()
    box(
        thickness,
        x=tot_width,
        h=height
    )
    box(
        thickness,
        x=tot_width,
        h=height
    )
    pieces(2)
    X(span(rel_width))
    turnXY(90)
    box(
        thickness,
        x=tot_depth - thickness,
        h=height
    );
}

module carcas(){
    clear(pink)kick_plate();
}

carcas();