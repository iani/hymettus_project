//: Simplest version: 
{
	var input, onsets;
	// Get the input from the FIRST INPUT CHANNEL of your card.
	input = In.ar (Server.default.options.numOutputBusChannels);
	// Detect onsets in the input:
	onsets = Onsets.kr (FFT(LocalBuf (1024), input));
	// Make a sound whenever an onset is found:
	WhiteNoise.ar (Decay.kr (onsets)) * 0.1;
}.play;
//: Variable threshold
~a = { | thresh = 0.5 |
	var input, onsets;
	// Get the input from the FIRST INPUT CHANNEL of your card.
	input = In.ar (Server.default.options.numOutputBusChannels);
	// Detect onsets in the input:
	onsets = Onsets.kr (FFT(LocalBuf (1024), input), thresh);
	// Make a sound whenever an onset is found:
	WhiteNoise.ar (Decay.kr (onsets)) * 0.1;
}.play;
//:
~a.set (\thresh, 0.9); // very high threshold...

//: On detecting an onset, get the spectral centroid 
~a = { | thresh = 0.5 |
	var input, fft, onsets, centroid;
	// Get the input from the FIRST INPUT CHANNEL of your card.
	input = In.ar (Server.default.options.numOutputBusChannels);
	// get the fft to use for various machine listening ugens:
	fft = FFT(LocalBuf (1024), input);
	// Detect onsets in the input:
	onsets = Onsets.kr (fft, thresh);
	// Make a sound whenever an onset is found:
	centroid = SpecCentroid.kr (fft);
	// WhiteNoise.ar (Decay.kr (onsets)) * 0.1;
	// Test the centroid by synthesizing a sound with it:
	SinOsc.ar (centroid / 4, 0, Decay.kr (onsets) * 0.1);
}.play;

//: Also send a trigger and use it to start another sound
~a = { | thresh = 0.5 |
	var input, fft, onsets, centroid;
	// Get the input from the FIRST INPUT CHANNEL of your card.
	input = In.ar (Server.default.options.numOutputBusChannels);
	// get the fft to use for various machine listening ugens:
	fft = FFT(LocalBuf (1024), input);
	// Detect onsets in the input:
	onsets = Onsets.kr (fft, thresh);
	// Make a sound whenever an onset is found:
	centroid = SpecCentroid.kr (fft);
	// WhiteNoise.ar (Decay.kr (onsets)) * 0.1;
	// Test the centroid by synthesizing a sound with it:
	SendTrig.kr (onsets, 1000, centroid / 4);
	// SinOsc.ar (centroid / 4, 0, Decay.kr (onsets) * 0.1);
	Silent.ar();
}.play;
//: Setup an OSCdef to respond to the trigger messages
OSCdef (\centroid, { | msg |
	(freq: msg [3]).play;
}, '/tr'
);