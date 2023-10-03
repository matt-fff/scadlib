include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/cabinet/defaults.scad>

module top(
    depth=tot_depth,
    width=tot_width,
    thickness=top_thickness,
    overhang=top_overhang
){
    material = top_material;
    part = "top";
    X(-overhang)
    Y(-overhang)
    TOREAR()
    TORIGHT()
    logbox(
        depth + overhang*2,
        x=width + overhang*2,
        h=top_thickness,
        part=part,
        material=material,
        subpart="top"
    );
    children();
}
