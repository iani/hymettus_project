
Server.default.boot;

//: Playing with the amplitude, rhythm variations, 
a = { WhiteNoise.ar (0.1) }.play;
//: Stereo
a = { WhiteNoise.ar ([0.1, 0.1]) }.play;
//: Stereo - variation 1
a = { WhiteNoise.ar (0.1.dup) }.play;
//: Stereo - variation 2
a = { WhiteNoise.ar (0.1 ! 2) }.play;
//: Stereo - variation 3
// Note: this repeats the same UGen subgraph without generating a copy
// It is therefore the most economical.
// Compare with above: Using (0.1.dup) creates 12 UGens, using dup at the end creates 10 UGens.
a = { WhiteNoise.ar (0.1).dup }.play;
//: Mouse control
a = { WhiteNoise.ar (MouseX.kr (0, 0.3)) }.play;
//: Mouse control - exponential (compare to above)
// This WILL NOT WORK. ERROR: Cannot use 0 or different signs (- ... +) in exponential
a = { WhiteNoise.ar (MouseX.kr (0, 0.3, \exponential)) }.play;//: Mouse control - exponential (compare to above)
//: Correction 1
a = { WhiteNoise.ar (MouseX.kr (0.01, 0.3, \exponential) - 0.01) }.play;
//: Correction 2
a = { WhiteNoise.ar (MouseX.kr (0.01, 0.31, \exponential) - 0.01) }.play;

// ================ Next lets introduce algorithmic variations ================

//: "Beat".  Beat rate: 1 Hz
a = { WhiteNoise.ar (Decay.kr (Impulse.kr (1))) * 0.2 }.play;
//: Variable Beat rate - with the mouse
a = { WhiteNoise.ar (Decay.kr (Impulse.kr (MouseX.kr (1, 10, 1)))) * 0.2 }.play;
//: Variable Beat rate - with a Line Unit Generator (UGen)
// From 1 to 10 in 10 seconds, exponentially
a = { WhiteNoise.ar (Decay.kr (Impulse.kr (Line.kr (1, 10, 10)))) * 0.2 }.play;
//: Compare this to Exponential Line:
a = { WhiteNoise.ar (Decay.kr (Impulse.kr (XLine.kr (1, 10, 10)))) * 0.2 }.play;

// But how do we make this sound *stop* when the line ends?
// Answer: Use an ENVELOPE.

//: Envelope example 1
(

a = {
	var env;
	env = Env ([1, 10], [10], \exp);
	WhiteNoise.ar (Decay.kr (Impulse.kr (EnvGen.kr (env, doneAction: 2))))
}.play;
)
//: Envelope example 1 - "corrected"
// 
(

a = {
	var env;
	env = Env ([1, 10, 0, 0], [10, 0, 3], \exp);
	WhiteNoise.ar (Decay.kr (Impulse.kr (EnvGen.kr (env, doneAction: 2))))
}.play;
)