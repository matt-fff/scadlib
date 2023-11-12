include <constructive/constructive-compiled.scad> 
include <scadlib/common/pipe.scad>

module log_header() {
    //echo(str("dim_header: ", str(DIMENSION_HEADER)));
}

module log_dims(dimensions) {
    //echo(str("dimensions: ", str(dimensions)));
}

module logbox(
    side=10,
    x=undef,
    y=undef,
    z=undef,
    h=heightInfo(),
    part="",
    subpart="",
    material="",
    count=1,
    should_log=true
) {
    // Copied from box module.
    z=(z==undef)?h:z;
    lx=(x==undef?side:x);
    ly=(y==undef?side:y);
    lz=(z==undef?side:z);
    
    dimensions = [
        part,
        subpart, 
        material, 
        lx,
        ly,
        lz,
        count
    ];
    assert(len(dimensions) == len(DIMENSION_HEADER));
    if (should_log) log_dims(dimensions);
    box(side=side, x=x, y=y, z=z, h=h);
    children();
}

module logpipe(
    length,
    diam,
    wall,
    part="",
    subpart="",
    material="pipe",
    count=1,
    should_log=true
) {
    dimensions = [
        part,
        subpart, 
        material, 
        length,
        diam,
        wall,
        count
    ];
    assert(len(dimensions) == len(DIMENSION_HEADER));
    if (should_log) log_dims(dimensions);
    pipe(length=length, diam=diam, wall=wall);
    children();
}

DIMENSION_HEADER = [
    "part",
    "subpart",
    "material",
    "lx", 
    "ly", 
    "lz", 
    "count"
];
log_header();
