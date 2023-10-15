include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>

PIPE_DIAM = 21.5;
PIPE_MOUNT_DIAM = 78;
PIPE_THREAD_LEN = 21.5;
PIPE_WALL_WIDTH = 3;
COUPLER_DIAM = 31.5;
COUPLE_LEN = 35.5;

module pipe(
    length=102.5,
    diam=PIPE_DIAM,
    wall=PIPE_WALL_WIDTH,
){
    tube(
        d=diam,
        h=length,
        wall=wall
    );
    
//    threaded_rod(
////        d=diam,
//        l=length,
//        pitch=2,
//        $fa=1,
//        $fs=1,
//        end_len=1.5,
//        bevel=true
//    );
    children();
}

//pipe();
