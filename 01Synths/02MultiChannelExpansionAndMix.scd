//: Expands to an array output to contiguous channels
{ SinOsc.ar ([400, 500], 0, 0.1) }.play;
//: In a stereo syste, the third channel is not heard
{ SinOsc.ar ([400, 500, 600], 0, 0.1) }.play;
//: Mix to one channel
{ Mix (SinOsc.ar ([400, 500, 600], 0, 0.1)) }.play;
//:
{ Mix (SinOsc.ar ((4..10) * 100, 0, 0.01)) }.play;
//:
{ Mix (FSinOsc.ar ((1..10) * 100, 0.5, (1..10).reciprocal * 0.05)) }.play;
//: Additive synthesis of saw
{ Mix (FSinOsc.ar ((1..100) * 100, 0.5, (1..100).reciprocal * 0.01)) }.play;
//: Additive synthesis of square pulse
{ Mix (FSinOsc.ar ((1..100) * 400, 0, (1..100).reciprocal * { [0.05, 0] }.dup (50).flat)) }.play;
//: Less harmonics
{ Mix (FSinOsc.ar ((1..10) * 400, 0, (1..10).reciprocal * { [0.1, 0] }.dup (5).flat)) }.play;
//: Texture / timbre changing in time
(
{ Mix (FSinOsc.ar ((1..10) * 400, 0, (1..10).reciprocal *
	{ [LFNoise1.kr (0.1, 0.1), 0] }.dup (5).flat
)) }.play;
)
//:
(
{ Mix (FSinOsc.ar ((1..50) * 100, 0, (1..50).reciprocal *
	{ [LFNoise1.kr (Rand (0.1, 0.5), 0.1), 0] }.dup (25).flat
)) }.play;
)
//:
(
{ Mix (FSinOsc.ar ((1..50) * 100, 0, (1..50).reciprocal *
	{ [LFNoise1.kr (Rand (5, 15), 0.1), 0] }.dup (25).flat
)) }.play;
)
//:
(
{ Mix (FSinOsc.ar ((1..50) * 50, 0, (50..100).reciprocal *
	{ [LFNoise1.kr (Rand (0.1, 0.5), 0.9), 0] }.dup (25).flat
)) }.play;
)
//:
(
{ Mix (FSinOsc.ar ((1..50) * 100, 0, 
	{ [LFNoise1.kr (Rand (0.1, 0.5), 0.02), 0] }.dup (25).flat
)) }.play;
)
//: