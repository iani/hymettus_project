//:
{ WhiteNoise.ar (0.1).dup }.play;
//:
{ PinkNoise.ar (0.1).dup }.play;
//:
{ BrownNoise.ar (0.1).dup }.play;
//:
{ GrayNoise.ar (0.1).dup }.play;
//:
{ LFNoise0.ar (800, 0.1).dup }.play;
//:
{ LFNoise1.ar (800, 0.1).dup }.play;
//:
{ LFNoise2.ar (800, 0.1).dup }.play;
//:
{ Gbman2DC.ar(11025, 22050, -0.7, -2.7, 0.1).dup }.play;
//:
{ Gbman2DC.ar(2200, 8800, 1.2, 2.0002, 0.1).dup }.play;
//:
{ Gbman2DL.ar(11025, 22050, -0.7, -2.7, 0.1) }.play;
//:
{ Gbman2DL.ar(2200, 8800, 1.2, 2.0002, 0.1) }.play;
//:
{ HenonN.ar(400, 1.4, 0.3, 0, 0, 0.01).dup }.play;
//: freq=22050, a=1, b= -1, c= -0.75, xi=0, mul=1
{ QuadN.ar(400, 1, -1, -0.75, 0, 0.01).dup }.play;
//: freq=22050, a=1, b=1.9, xi=0, mul=1, add=0;
{ CuspN.ar (400, 1, 1.9, 0, 0.01).dup }.play;
//: freq=22050, a=1, b=3, c=0.5, d=0.5, xi=0.5, yi=0.5, mul=1.0, add=0.0;
{ LatoocarfianN.ar (400, 1, 3, 0.5, 0.5, 0.5, 0.5, 0.01).dup }.play;
//: freq=22050, a=1.1, c=0.13, m=1.0, xi=0, mul=1.0, add=0.0;
{ LinCongN.ar (400, 1.1, 0.13, 1.0, 0, 0.01).dup }.play;