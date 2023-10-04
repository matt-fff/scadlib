include <scadlib/common/cutlist.scad>
include <scadlib/cabinet/defaults.scad>

TOP_MATERIAL = "3/4 top";
TOP_OVERHANG = inch_to_mm(0.75);

module top(
    depth=undef,
    width=undef,
    thickness=undef,
    overhang=undef,
    material=undef
){
    depth = val_or_default(depth, TOT_DEPTH);
    width = val_or_default(width, TOT_WIDTH);
    thickness = val_or_default(thickness, TOP_THICKNESS);
    overhang = val_or_default(overhang, TOP_OVERHANG);
    material = val_or_default(material, TOP_MATERIAL);

    part = "top";
    X(-overhang)
    Y(-overhang)
    TOREAR()
    TORIGHT()
    logbox(
        depth + overhang*2,
        x=width + overhang*2,
        h=thickness,
        part=part,
        material=material,
        subpart="top"
    );
    children();
}
