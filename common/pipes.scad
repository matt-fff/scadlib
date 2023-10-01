include <constructive/constructive-compiled.scad>
include <scadlib/common/cutlist.scad>
include <scadlib/common/utils.scad>

include <BOSL2/threading.scad>
include <BOSL2/std.scad>

PIPE_DIAM = 21.5;
PIPE_MOUNT_DIAM = 78;
PIPE_THREAD_LEN = 21.5;
PIPE_THREAD_PITCH = 14;
PIPE_WALL_WIDTH = 3;
COUPLER_DIAM = 31.5;
COUPLE_LEN = 35.5;

module pipe(
    length=102.5,
    diam=PIPE_DIAM,
    wall=PIPE_WALL_WIDTH,
    thread_len=PIPE_THREAD_LEN,
    thread_pitch=PIPE_THREAD_PITCH
){
//    tube(
//        od=diam,
//        id=diam - wall*2,
//        length=length
//    );
//    projection(cut=true)
//    threaded_rod(
//        diam,
//        pitch=thread_pitch,
//        d1=20.25,
//        d2=16,
//        length=thread_length
//    );
    threaded_rod(
//        d=diam,
        l=length,
        pitch=2,
        $fa=1,
        $fs=1,
        end_len=1.5,
        bevel=true
    );
    children();
}

pipe();