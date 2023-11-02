include <scadlib/common/utils.scad>
include <scadlib/cabinet/defaults.scad>

module back_panel(
    height,
    width,
    carcas_thickness=undef,
    panel_thickness=undef,
    panel_material=undef,
    dado_depth=undef,
    col=black,
    should_log=true
){
    carcas_thickness = val_or_default(carcas_thickness, CARCAS_THICKNESS);
    panel_thickness = val_or_default(panel_thickness, PANEL_THICKNESS);
    panel_material = val_or_default(panel_material, PANEL_MATERIAL);
    dado_depth = val_or_default(dado_depth, DADO_DEPTH);

    material = panel_material;
    part = "back_panel";

    // Back Panel
    clear(col)
    Z(carcas_thickness-dado_depth)
    TOREAR()
    TORIGHT()
    X(carcas_thickness - dado_depth)
    Y(carcas_thickness)
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

module back_panel_set(
    height=undef,
    width=undef,
    carcas_thickness=undef,
    panel_thickness=undef,
    panel_material=undef,
    dado_depth=undef,
    divisions=undef,
    should_log=true,
    explode=0
){
    width = val_or_default(width, TOT_WIDTH);
    divisions = val_or_default(divisions, DIVISIONS);
    division_width = width / divisions;
    explode_offset = explode * 75;

    col1 = pink;
    col2 = red;
    col3 = orange;
    Y(-explode_offset)
    g(TOUP()) {
        clear(gray)
        pieces(divisions)
        X(span(width - division_width))
        // Add the actual back panel
        back_panel(
            height=height,
            width=division_width,
            carcas_thickness=carcas_thickness,
            panel_thickness=panel_thickness,
            panel_material=panel_material,
            dado_depth=dado_depth,
            col=vRepeat(col1, col2, col3),
            should_log=should_log
        );
        
    }
    children();
}
