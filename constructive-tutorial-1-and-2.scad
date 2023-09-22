include <constructive/constructive-compiled.scad>
//TODOWN()TORIGHT()box(10);
//TOUP()TOLEFT()tube(d=10,h=10,solid=true);

module vert_stack(){
    chamfer(1,-2,-3) TOUP()  stack(TOUP)
    box(20)
    box(15)
    box(10,h=30)
    tube(d=10,wall=2,h=20)
    tube(d=5,h=10,solid=true)
    turnXY(45)box(5);
}

module horiz_stack(){
    chamfer(-2,-2)
    TODOWN()
    TORIGHT()
    TOREAR()
    stack(TORIGHT)
        box(20)
        box(15)
        box(10,h=30)
        tube(d=10,wall=2,h=20)
        tube(d=5,h=10,solid=true)
        turnXY(45)box(5);
}

module line(){
    right(15)
    up(5)
    bentStripXZ(
        places=[
            X(20),
            turnXZ(60),
            X(20),
            turnXZ(-45),
            X(10)
        ],
        y=5,
        thick=10
    );
}

// Vertical Stack
clear(yellow)
vert_stack();

// Horizontal Stack
opaq(orange)
horiz_stack();

// Mirror the Horizontal Stack
reflectX() TOFRONT()
{
    opaq(blue)
    horiz_stack();
}

// Wavy line
clear(red)
line();

// Wavy line scaled
down(10)
    cscale(x=2)
    line();
         
         
// Duplicating boxes
clear(pink)
TOFRONT()
TODOWN()
pieces(7)
X(every(-20))
box(10);
    
// Scaled duplicating boxes
TOFRONT()
down(30)
pieces(7)
X(every(20))
box(10,h=10+every(5));

// Duplicating boxes with a set total width
TOFRONT()
down(60)
pieces(5)
X(span(100))
box(10);

// Duplicating rotating boxes with a set total width
TOFRONT()
down(75)
pieces(8) X(span(100)) turnYZ(span(90)) box(10);


TOFRONT()
down(100)
pieces(15) X(span(200))
  Y(vRepeat(0,10,30,70))
    color(vRepeat(red,green,blue,cyan))
      ball(15);`

// Mirror ball pieces across X
up(50)
pieces(2)
X(sides(15))
ball(10);

// Mirror cube pieces across y
opaq(pink)
up(50)
two()
Y(sides(15))
turnXZ(-sides(30))
box(10);
