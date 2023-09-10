include <BOSL2/std.scad>;

top_height = 1.5;
module plank(
    width=11.0,
    length=8 * 12,
    height=top_height,
    rounding=0.35,
    anchor=BOTTOM+FWD
){
    xrot(90)cuboid(
        [
            width,
            height,
            length
        ],
        anchor=anchor,
        rounding=rounding,
        edges="Z"
    );
}


offset = 11.1;
module tabletop(){
    
    shortlen = 4 * 12;
    right(offset * 0.5)difference() {
        union(){
            plank(length=shortlen);
            right(1 * offset)
            plank(length=shortlen);
            right(1.75 * offset)
            plank(length=shortlen, width=5.5);
        }
        fwd(39.6)
        zrot(-20.77)
        down(0.1)
        plank(width=50, height=1.8);
    }
    right(2.75 * offset)plank(length=6*12, width=5.5);
    right(3.5 * offset)plank(length=6*12);
    right(4.5 * offset)plank(length=6*12);
}

module leg(
    width=3.5,
    length=3.5,
    height=37,
    anchor=BOTTOM+LEFT
){
    xrot(90)fwd(height/2)cuboid(
        [
            width,
            height,
            length
        ],
        anchor=anchor,
        rounding=0.35,
        edges="Y"
    );
}

toplen = offset * 5;
inset = 1.25;
leg_width = 3.5;
module legs(){
    width = leg_width;
    
    // Short side legs
    fwd(inset)
    right(inset)
    union(){
        leg(width=width);
        fwd(3*12-width)leg(width=width);
    }
    
    // Long side legs
    right(toplen-inset-width)
    union(){
        fwd(inset)leg(width=width);
        fwd(3*12-width + inset)leg(width=width);
        fwd(6*12-width-inset)leg(width=width);
    };
    
    // Middle legs long side
    right(toplen/2 + inset)
    union(){
        fwd(inset)leg(width=width);
        
        fwd(6*12-width-inset)
        leg(width=width);

        fwd(3*12-width + inset)
        leg(width=width);
    }
    
    // Middle legs short side
    right(toplen/2 - inset - leg_width)
    union(){
        fwd(inset)leg(width=width);

        fwd(3*12-width + inset)
        leg(width=width);
    }
    
}

module rail(
    height=3.5,
    width=1.5,
    length=3 * 12,
    anchor=BOTTOM+LEFT,
    rounding=0.35
) {
    plank(
        height=height,
        width=width,
        length=length,
        anchor=anchor,
        rounding=rounding
    );
}

total_height = 37 + 1.5;
ground_offset = 7.5;
top_offset = total_height - ground_offset;
module rails(
    scale=1.0,
    rounding=0.35
){
    height=3.5;
    width=1.5;
    length=3 * 12;
    
    scaled_height = height * scale;
    scaled_width = width * scale;
    scaled_length = length * scale;

    
    down(top_offset)
    fwd(inset)
    union() {
        // Short side rail
        right(inset)
        rail(
            height=scaled_height,
            width=scaled_width,
            length=scaled_length,
            rounding=rounding
        );
        
        // Long side rail
        right(toplen - width - inset)
        rail(
            height=scaled_height,
            width=scaled_width,
            length=(length-inset)*2*scale,
            rounding=rounding
        );
        
        // Connector long rail
    right(toplen/2 + inset)
        rail(
            height=scaled_height,
            width=scaled_width,
            length=(length-inset)*2*scale,
            rounding=rounding
        );
        // Connector short rail
        
    right(toplen/2 - inset - width)
        rail(
            height=scaled_height,
            width=scaled_width,
            length=scaled_length,
            rounding=rounding
        );
        
    }
}


module crossbraces(is_upper=false) {
    height=3.5;
    width=1.5;
    length=3 * 12;
    rounding = 0.35;

    down(top_offset)
    fwd(inset)
    union() {
        // Corner width cross
        right(inset+leg_width)
        fwd(length-leg_width/3)
        zrot(90)
        rail(
            height=height,
            width=width,
            length=toplen/2 - (inset+leg_width)*2,
            rounding=rounding
        );
        
        // Long width cross
        right(inset+leg_width+toplen/2)
        fwd(length-leg_width/3)
        zrot(90)
        rail(
            height=height,
            width=width,
            length=toplen/2 - (inset+leg_width)*2,
            rounding=rounding
        ); 
        
        if(is_upper) {
            // Long short end cross
            right(inset+leg_width+toplen/2)
            fwd(length*2-leg_width)
            zrot(90)
            rail(
                height=height,
                width=width,
                length=toplen/2 - leg_width*2,
                rounding=rounding
            );
        }
        
        // Back cross
        right(inset+leg_width)
        fwd((inset+leg_width)/2)
        zrot(90)
        rail(
            height=height,
            width=width,
            length=toplen/2 - (inset+leg_width)*2,
            rounding=rounding
        );
        right(inset+leg_width+toplen/2)
        fwd((inset+leg_width)/2)
        zrot(90)
        rail(
            height=height,
            width=width,
            length=toplen/2 - (inset+leg_width)*2,
            rounding=rounding
        );
        
        
    }
}



module shelves() {
    length=toplen/2 - (top_height+inset)*2;
    height=0.75;
    width=5.5;
    rounding = 0.35;

    down(top_offset-height)
    fwd(inset+leg_width+top_height)
    right(inset+top_height)
    zrot(90)
    union() {
        plank(
            height=height,
            width=width,
            length=length,
            rounding=rounding
        );
        left(width)plank(
            height=height,
            width=width,
            length=length,
            rounding=rounding
        );
        left(width*2)plank(
            height=height,
            width=width,
            length=length,
            rounding=rounding
        );
        left(width*3)plank(
            height=height,
            width=width,
            length=length,
            rounding=rounding
        );
        left(width*4)plank(
            height=height,
            width=width,
            length=length,
            rounding=rounding
        );
        shortwidth = 3.5;
        left(width*5 - 1)
        plank(
            height=height,
            width=shortwidth,
            length=length,
            rounding=rounding
        );
    }
    
}


tabletop();

upper_cross_offset = top_offset - top_height;


difference() {
    legs();
    union() {
        rails(scale=1.05, rounding=0);
        up(upper_cross_offset)rails(scale=1.05, rounding=0);
    }
}
rails();
crossbraces();

up(upper_cross_offset)
union() {
    rails();
    crossbraces(is_upper=true);
}

shelves();
right(toplen/2)shelves();