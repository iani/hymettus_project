//:
(
var window;
window = Window ("simple").front;
window.view.layout = VLayout (
	Button ()
	.states_ ([["start"], ["stop"]])
	.action_ ({ | me |
		if (me.value > 0) {
			"starting".postln;
		}{
			"stopping".postln;
		}
	});
);
)
//:
(
var window, alert;
window = Window ("close alert").front;
window.view.layout = VLayout (
	Button ()
	.states_ ([["start"], ["stop"]])
	.action_ ({ | me |
		if (me.value > 0) {
			"starting".postln;
			alert = Window ("STARTED", Rect (100, 100, 300, 100)).front;
		}{
			"stopping".postln;
			alert.close;
		}
	});
);
)
//:
(
var window, alert;
window = Window ("simple").front;
window.view.layout = VLayout (
	Button ()
	.states_ ([["start"], ["stop"]])
	.action_ ({ | me |
		if (me.value > 0) {
			"starting".postln;
			alert = Window ("STARTED", Rect (100, 100, 300, 100)).front;
		}{
			"stopping".postln;
			alert.close;
		}
	});
);
window.onClose = { alert !? { alert.close } };
)
//:
(
var window, sound;
window = Window ("simple sound").front;
window.view.layout = VLayout (
	Button ()
	.states_ ([["start"], ["stop"]])
	.action_ ({ | me |
		if (me.value > 0) {
			"starting".postln;
			sound = { WhiteNoise.ar (0.1).dup }.play;
		}{
			"stopping".postln;
			sound.free;
		}
	});
);
window.onClose = { sound.free; };
)
//:
(
var window, on_off_button, sound;
window = Window ("auto-update sound").front;
window.view.layout = VLayout (
	on_off_button = Button ()
	.states_ ([["start"], ["stop"]])
	.action_ ({ | me |
		if (me.value > 0) {
			sound = { WhiteNoise.ar (0.1).dup }.play;
			NodeWatcher.register (sound);
			sound addDependant: { | sender, message |
				if (message == \n_end ) {
					{ on_off_button.value = 0 }.defer;
					sound.releaseDependants;
				};
			};
		}{
			sound.free;
		}
	});
);
window.onClose = { if (sound.isPlaying) { sound.free }; };
)
//:
(
var window, on_off_button, sound;
window = Window ("auto-update sound - self-ending").front;
window.view.layout = VLayout (
	on_off_button = Button ()
	.states_ ([["start"], ["stop"]])
	.action_ ({ | me |
		if (me.value > 0) {
			sound = {
				WhiteNoise.ar (EnvGen.kr(Env.perc, 1, doneAction: 2) * 0.1).dup
			}.play;
			NodeWatcher.register (sound);
			sound addDependant: { | sender, message |
				if (message == \n_end ) {
					{ on_off_button.value = 0 }.defer;
					sound.releaseDependants;
				};
			};
		}{
			sound.free;
		}
	});
);
window.onClose = { if (sound.isPlaying) { sound.free }; };
)
//:
// ================ Many windows + sounds
//: Version 1: "one time"
(
~makeWindow = { | name, func |
	var window, on_off_button, sound;
	window = Window (name, Rect (500.rand, 400.rand, 200, 100)).front;
	window.view.layout = VLayout (
		on_off_button = Button ()
		.states_ ([["start"], ["stop"]])
		.action_ ({ | me |
			if (me.value > 0) {
				sound = func.play;
				NodeWatcher.register (sound);
				sound addDependant: { | sender, message |
					if (message == \n_end ) {
						{ on_off_button.value = 0 }.defer;
						sound.releaseDependants;
					};
				};
			}{
				sound.free;
			}
		});
	);
	window.onClose = { if (sound.isPlaying) { sound.free }; };
};
)
//:
~makeWindow.("sound 1", {
	WhiteNoise.ar (EnvGen.kr(Env.perc, 1, doneAction: 2) * 0.1).dup	
});
//:
~makeWindow.("sound 2", { SinOsc.ar (Rand (400, 4000), 0, 0.1).dup; });
//:
//: Version 2: Sound persists even when window closes
(
~makeWindow = { | name, func |
	var window, on_off_button, sound, source;
	func !? {
		Library.put ('sounds', name, 'source', func);
	};
	window = Library.at ('sounds', name, 'window');
	if (window.notNil) {
		window.front;
	}{
		window = Window (name.asString, Rect (500.rand, 400.rand, 200, 100)).front;
		window.view.layout = VLayout (
			on_off_button = Button ()
			.states_ ([["start"], ["stop"]])
			.action_ ({ | me |
				if (me.value > 0) {
					source = Library.at ('sounds', name, 'source') ?? {
						{ WhiteNoise.ar (0.2).dup }	
					};
					Library.put ('sounds', name, 'source', source);
					sound = source.play;
					NodeWatcher.register (sound);
					Library.put ('sounds', name, 'synth', sound);
					sound addDependant: { | sender, message |
						if (message == \n_end ) {
							{ on_off_button.value = 0 }.defer;
							sound.releaseDependants;
						};
					};
				}{
					Library.at ('sounds', name, 'synth').free;
				}
			});
		);
		window.onClose = { Library.put ('sounds', name, 'window', nil); }
	};
};
)
//:
~makeWindow.('sound1');
~makeWindow.('sound2', { SinOsc.ar (Rand (400, 4000), 0, 0.1).dup });
//: Testing
Library.at ('sounds', 'sound1', 'synth').free;
Library.at ('sounds', 'sound2', 'synth') release: 5;
//:
(
~getSynth = { | name | Library.at ('sounds', name, 'synth'); };
~startSynth = { | name |
	if (Library.at ('sounds', name, 'synth').isPlaying.not) {
		Library.put ('sounds', name, 'synth',
			Library.at ('sounds', name, 'source').play
		)
	};
};
~restartSynth = { | name |
	if (Library.at ('sounds', name, 'synth').isPlaying) {
		Library.at ('sounds', name, 'synth').release;
	};
	Library.put ('sounds', name, 'synth',
		Library.at ('sounds', name, 'source').play
	)
};

~freeSynth = { | name | Library.at ('sounds', name, 'synth').free };
~releaseSynth = { | name, dur = 1 | Library.at ('sounds', name, 'synth') release: dur };
)
//:
~getSynth.('sound1');
//:
~startSynth.('sound1');
//:
~freeSynth.('sound1');
//:
~releaseSynth.('sound1');

// ================================================================
//: ================ Single window, many buttons
~makeWindow = { | key = 'synth_list' |
	var window;
	window = Library.at ('windows', key);
	if (window.isNil) {
		window = Window (key, Rect (0, 0, 200, 500)).front;
		~makeButtons.(window);
		Library.put ('windows', key, window);
		window.onClose = { Library.put ('windows', key, nil) };
	}{
		window.front;
	}
};

~makeButtons = { | window |
	window !? {
		window.view.removeAll;
		window.view.layout = VLayout (
			*(Library.at ('sounds') ?? { () }).keys.asArray.sort.collect ({ | key |
				~makeButton.(key);
			})
		)
	};
};

~makeButton = { | name |
	var source, synth, button, notifier;
	button = Button ()
	.states_ ([[format ("start %", name)], [format ("stop %", name)]])
	.action_ ({ | me |
		if (me.value > 0) {
			~makeSynth.(name);
		}{
			~stopSynth.(name);
		};
	});
	if (Library.at ('sounds', name, 'synth').isPlaying) {
		button.value = 1;
	};
	notifier = { | sender, message |
		if (message == \stopped ) {
			{ button.value = 0 }.defer;
		}{
			{ button.value = 1 }.defer;
		};
	};
	name addDependant: notifier;
	button.onClose = { name removeDependant: notifier };
	button;
};

~makeSynth = { | name, source |
	var synth;
	// release previous synth if playing: 
	~stopSynth.(name, false); // Avoid notification from previous synth
	// provide default source if needed
	source ?? {
		source = Library.at ('sounds', name, 'source') ?? {
			{ WhiteNoise.ar (0.2).dup }	
		}
	}; // store source
	Library.put ('sounds', name, 'source', source);
	synth = source.play; // create synth
	NodeWatcher.register (synth);
	Library.put ('sounds', name, 'synth', synth);
	synth addDependant: { | sender, message |
		if (message == \n_end) {
			name.changed (\stopped);
			synth.releaseDependants;
			Library.put ('sounds', name, 'synth', nil);
		}{
			name.changed (\started)
		};
	};
};

~stopSynth = { | name, notify = true |
	var synth;
	synth = Library.at ('sounds', name, 'synth');
	if (synth.isPlaying) {
		synth.release;
		if (notify) {} { synth.releaseDependants };
	};
};

~addSound = { | name, source |
	Library.put ('sounds', name, 'source', source);
	~makeButtons.(Library.at ('windows', 'synth_list'));
};

//: ================ TESTS
~makeWindow.('synth_list');

//:
~addSound.('test123', { BrownNoise.ar (LFNoise0.kr (5, 0.1)).dup });
//:
~addSound.('gray', { GrayNoise.ar (LFNoise0.kr (15, 0.1)).dup });
//:
~addSound.('blip', { Blip.ar (LFNoise0.kr (5, 400, 800), 10, 0.1).dup });
//:  Test replacing a sound source
~addSound.('test123', { PinkNoise.ar (Decay.kr (Dust.kr (10, 0.1))).dup });

//: Update test
w = Window ().front;
w.view.layout = VLayout (
	*(1..10) collect: { | i | Button ().states_([[format ("bla %", i)]])}
);
//:
w.view.layout = VLayout (
	*(1..10) collect: { | i | Button ().states_([[format ("blh %", 100.rand)]])}
);
//: Tests;
\blip.dependants;
~makeSynth.(\gray);
~stopSynth.(\gray);