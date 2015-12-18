{ SinOsc.ar (400, 0, 0.1).dup }.play;
//:
{ LFSaw.ar (400, 0, 0.1).dup }.play;
//:
{ LFTri.ar (400, 0, 0.1).dup }.play;
//:
{ LFPulse.ar (400, 0, 0.5, 0.1).dup }.play;
//:
{ Blip.ar (400, 5, 0.1).dup }.play;
//:
{ Blip.ar (400, 10, 0.1).dup }.play;
//:
{ Blip.ar (400, 20, 0.1).dup }.play;
//: fundfreq: 440, formfreq: 1760, bwfreq: 880, mul: 1, add: 0
{ Formant.ar (400, 1760, 880, 0.1).dup }.play;
//: 
{ Formant.ar (400, 1760, 440, 0.1).dup }.play;
//: 
{ Formant.ar (400, 600, 880, 0.1).dup }.play;
//: 
{ Formant.ar (400, 6000, 880, 0.1).dup }.play;
//:
{ Klang.ar(`[ [800, 1000, 1200], [0.1, 0.05, 0.01], [pi, pi, pi]], 0.5).dup }.play;
//:
{ Klang.ar(`[ Array.rand(6, 600.0, 1000.0), 0.02, nil ]).dup }.play;
//:
{ Klang.ar(`[ Array.rand(12, 600.0, 1000.0), 0.01, nil ]).dup }.play;
//:
{ Klang.ar(`[ Array.rand(120, 600.0, 1000.0), 0.005, nil ]).dup }.play;
//:
{ Klang.ar(`[ Array.rand(360, 300.0, 3000.0), 0.001, nil ]).dup }.play;
//:
{ SinOscFB.ar(440, 2, 0.1).dup }.play;
//:
{ SinOscFB.ar(440, 3, 0.1).dup }.play;
//:
{ SinOscFB.ar(144, 6, 0.1).dup }.play;
//:
{ PMOsc.ar(300, 500, 3, 0, 0.1).dup }.play;
//:
{ PMOsc.ar(300, 600, 3, 0, 0.1).dup }.play;

////////////////////////////////////////////////////////////////
/*
Free the previous synth before starting a new one: 
*/
//: Create a function that frees the previous synth.
(
p = { | func |
	if (~synth.isPlaying) { ~synth.free };
	~synth = func.play;
	NodeWatcher register: ~synth;
}
); 
//: Try it out:
p value: { WhiteNoise.ar (0.1)};
//: Try it out:
p value: { PinkNoise.ar (0.1)};
//: