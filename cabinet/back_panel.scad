include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>

module back_panel(
    width,
    height,
    carcas_thickness=undef,
    panel_thickness=undef,
    panel_material=undef,
    dado_depth=undef,
    should_log=true,
    explode=0
){
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    panel_material = val_or_default(panel_material, PANEL_MATERIAL);
    dado_depth = val_or_default(dado_depth, DADO_DEPTH);

    explode_offset = explode * 75;
    material = panel_material;
    part = "back_panel";

    // Back Panel

    TOUP()
    TOREAR()
    TORIGHT()
    Z(carcas_thickness - dado_depth)
    X(carcas_thickness - dado_depth)
    Y(carcas_thickness - explode_offset)
    logbox(
        panel_thickness,
        x=width + (dado_depth - carcas_thickness)*2,
        h=height + dado_depth - carcas_thickness,
        part=part,
        material=material,
        subpart="panel",
        should_log=should_log
    );
    children();
}

