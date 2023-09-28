include <constructive/constructive-compiled.scad> 

module log_dims(dimensions) {
    echo(str("dimensions: ", str(dimensions)));
}

module logbox(
    side=10,
    x=undef,
    y=undef,
    z=undef,
    h=heightInfo(),
    part=undef,
    subpart=undef,
    material=undef,
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
    assert(len(dimensions) == len(dimension_header));
    if (should_log) log_dims(dimensions);
    box(side=side, x=x, y=y, z=z, h=h);
    children();
}

dimension_header = [
    "part",
    "subpart",
    "material",
    "lx", 
    "ly", 
    "lz", 
    "count"
];
log_dims(dimension_header);