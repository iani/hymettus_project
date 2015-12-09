
Server.default.boot;

//: Playing with the amplitude, rhythm variations, 
{ WhiteNoise.ar (0.1) } ++> \a;
//: Stereo
{ WhiteNoise.ar ([0.1, 0.1]) } ++> \a;
//: Stereo - variation 1
{ WhiteNoise.ar (0.1.dup) } ++> \a;
//: Stereo - variation 2
{ WhiteNoise.ar (0.1 ! 2) } ++> \a;
//: Stereo - variation 3: Requires 2 less UGens than variation 2.
// Only one WhiteNoise generator is created.  Perceived result is one virtual source
// centered between left and right speakers.
{ WhiteNoise.ar (0.1).dup } ++> \a;
//: Mouse control
{ WhiteNoise.ar (MouseX.kr (0, 0.3)) } ++> \a;
//: Mouse control - exponential (compare to above)
// This WILL NOT WORK. ERROR: Cannot use 0 or different signs (- ... +) in exponential
{ WhiteNoise.ar (MouseX.kr (0, 0.3, \exponential)) } ++> \a;
//: Both low and high limits must have the same sign:
{ WhiteNoise.ar (MouseX.kr (0.01, 0.3, \exponential)) } ++> \a;
//: Range Correction 1: 0.0 - 0.31
{ WhiteNoise.ar (MouseX.kr (0.01, 0.3, \exponential) - 0.01) } ++> \a;
//: Range Correction 2: 0.0 - 0.3
{ WhiteNoise.ar (MouseX.kr (0.01, 0.31, \exponential) - 0.01) } ++> \a;

// ================ "Beat" - events with sharp attack, produced with Decay ================

//: Steady beat rate (frequency): 1 Hz 
{ WhiteNoise.ar (Decay.kr (Impulse.kr (1))) * 0.2 } ++> \a;
//: Variable beat rate - with the mouse, exponentiall 1-10 Hz
{ WhiteNoise.ar (Decay.kr (Impulse.kr (MouseX.kr (1, 10, 1)))) * 0.2 } ++> \a; 

// ================ Varying the beat frequency algorithmically ================

// ================ Line, Xline

//: Using a Line UGen, from 1 to 10 in 10 seconds, linear change rate:
{ WhiteNoise.ar (Decay.kr (Impulse.kr (Line.kr (1, 10, 10)))) * 0.2 } ++> \a;
//: As above, but with exponential change rate
{ WhiteNoise.ar (Decay.kr (Impulse.kr (XLine.kr (1, 10, 10)))) * 0.2 } ++> \a;

// Use an envelope to stop the sound when the line ends

//: Version 1: Stops immediately when the maximum value is reached
(
{
	var env;
	env = Env ([1, 10], [10], \exp);
	WhiteNoise.ar (Decay.kr (Impulse.kr (EnvGen.kr (env, doneAction: 2)))) * 0.2
} ++> \a;
)
//: Version 2: Stop the beats (frequency=0), and wait for 1 second for the sound to fade
(
{
	var env;
	env = Env ([1, 10, 0, 0], [10, 0, 1], \exp);
	WhiteNoise.ar (Decay.kr (Impulse.kr (EnvGen.kr (env, doneAction: 2)))) * 0.2
} ++> \a;
)

// ================ Various other UGens as modulators of the beat frequency

//: Sine
{ WhiteNoise.ar (Decay.kr (Impulse.kr (SinOsc.kr (0.2).range (1, 10)))) * 0.2 } ++> \a;
//: Pulse
{ WhiteNoise.ar (Decay.kr (Impulse.kr (LFPulse.kr (0.2).range (1, 10)))) * 0.2 } ++> \a;
//: Saw
{ WhiteNoise.ar (Decay.kr (Impulse.kr (LFSaw.kr (0.2).range (1, 10)))) * 0.2 } ++> \a;
//: LFNoise0
{ WhiteNoise.ar (Decay.kr (Impulse.kr (LFNoise0.kr (0.2).range (1, 10)))) * 0.2 } ++> \a;
//: LFNoise0
{ WhiteNoise.ar (Decay.kr (Impulse.kr (LFNoise0.kr (0.2).range (0.5, 20)))) * 0.2 } ++> \a;
//: LFNoise1
{ WhiteNoise.ar (Decay.kr (Impulse.kr (LFNoise1.kr (0.2).range (0.5, 20)))) * 0.2 } ++> \a;
//: Dust: Random impulses with a mean frequency
{ WhiteNoise.ar (Decay.kr (Dust.kr (5))) * 0.2 } ++> \a;
//: Multichannel expansion creates 2 Dust UGens with independent random impulses
{ WhiteNoise.ar (Decay.kr (Dust.kr ([5, 5]))) * 0.2 } ++> \a;

// Adding variation of the amplitude of the Impulse, usind Demand ugens
//: Dwhite
(
{
	var trig, amp;
	trig = Impulse.kr (SinOsc.kr (0.2).range (1, 10));
	amp = Demand.kr (trig, 0, Dwhite (0.005, 0.05));
	WhiteNoise.ar (Decay.kr (trig * amp)).dup;
} ++> \a;
)
//: Dseq
({
	var trig, amp;
	trig = Impulse.kr (SinOsc.kr (0.2).range (1, 10));
	amp = Demand.kr (trig, 1, Dseq ([0.01, 0.01, 0.05], inf));
	WhiteNoise.ar (Decay.kr (trig * amp)).dup;
} ++> \a;
)
//: Dseq with LFNoise0
(
{
	var trig, amp;
	trig = Impulse.kr (LFNoise0.kr (0.5).range (1, 10));
	amp = Demand.kr (trig, 1, Dseq ([0.01, 0.01, 0.05], inf));
	WhiteNoise.ar (Decay.kr (trig * amp)).dup;
} ++> \a;
)
//: Dwhite with LFNoise1
(
{
	var trig, amp;
	trig = Impulse.kr (LFNoise1.kr (0.5).range (1, 10));
	amp = Demand.kr (trig, 1, Dwhite(0.001, 0.05));
	WhiteNoise.ar (Decay.kr (trig * amp)).dup;
} ++> \a;
)
//:
// ================ Controlling the amplitude through an Envelope
// ==== One - time only

(
{
	var env; // an envelope shape that is distinctly different from perc, adsr ... :
	env = Env ([0, 1, 0.2, 0.7, 0.4, 0.9, 0], [0.01, 0.3, 0.2, 0.6, 0.5, 1], -3);
	WhiteNoise.ar (EnvGen.kr (env, 1, 0.1, doneAction: 2)).dup;
} ++> \a;
)
//: ==== Using release to trigger the ending part of the sound
(
{
	var env;
	env = Env ([0, 1, 0.2, 0.7, 0.4, 0.9, 0], [0.01, 0.3, 0.2, 0.6, 0.5, 1], -3, 5);
	WhiteNoise.ar (EnvGen.kr (env, 1, 0.1, doneAction: 2)).dup;
} ++> \a;
)
//: release the above sound whenever wished: 
\a release: 3;
//: ==== Repeated, triggered by set.
{ | trig = 0 |
	var env; 
	env = Env ([0, 1, 0.2, 0.7, 0.4, 0.9, 0], [0.01, 0.3, 0.2, 0.6, 0.5, 1], -3);
	WhiteNoise.ar (EnvGen.kr (env, trig, 0.1, doneAction: 0)).dup;
} ++> \a;
//: Do this at arbitrary points in time
1 +>.trig \a;
{ 0 +>.trig \a; } defer: 0.01; // reset to 0 to enable retriggering
//: alternative way to code the reset:
{ 1 +>.trig \a; 0.1.wait; 0 +>.trig \a }.fork;
// ================ Choosing Unit generators at random