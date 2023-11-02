include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>

KICK_INSET = inch_to_mm(3);

module kick_plate(
    depth=undef,
    height=undef,
    width=undef,
    thickness=undef,
    kick_inset=undef,
    divisions=undef,
    left_exposed=false,
    right_exposed=false
){
    depth = val_or_default(depth, TOT_DEPTH);
    height = val_or_default(height, KICK_HEIGHT);
    width = val_or_default(width, TOT_WIDTH);
    thickness = val_or_default(thickness, CARCAS_THICKNESS);
    kick_inset = val_or_default(kick_inset, KICK_INSET);
    divisions = val_or_default(divisions, DIVISIONS);
    division_width = width / divisions;

    part = "kick_plate";
    material = CARCAS_MATERIAL;

    TORIGHT()
    g(
        Y(thickness),
        TOFRONT()
    ) {
        // Runners
        X(thickness)
        logbox(
            thickness,
            x=width - thickness*2,
            h=height,
            part=part,
            material=material,
            subpart="back_runner"
        );
        Y(depth - kick_inset)
        logbox(
            thickness,
            x=width,
            h=height,
            part=part,
            material=material,
            subpart="front_runner"
        );
        

        // TODO explicit miter
        // We make the sides oversized because
        // exposed corners need to be mitered
        side_width = depth - kick_inset + thickness;
        brace_width = depth - kick_inset - thickness;
        
        g(Y(-thickness)) {
            // Sides
            X(width - thickness)
            turnXY(90)
            logbox(
                thickness,
                x=side_width,
                h=height,
                part=part,
                material=material,
                subpart="left_side"
            );
            turnXY(90)
            logbox(
                thickness,
                x=side_width,
                h=height,
                part=part,
                material=material,
                subpart="right_side"
            );
            // Braces 
            X(division_width)
            pieces(divisions - 1)
            X(span(width - division_width*2 - thickness))
            Y(thickness)
            turnXY(90)
            logbox(
                thickness,
                x=brace_width,
                h=height,
                part=part,
                material=material,
                subpart="brace"
            );
        }
    }
    children();
}

