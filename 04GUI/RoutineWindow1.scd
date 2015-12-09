
(
f = { | amplo = 0.05, amphi = 0.3, durs, waitlo = 0.01, waithi = 0.05, freq = 400 |
	// if (durs.isNil) { durs = [0.05, 0.15] };
	durs ?? { durs = [0.05, 0.15] };
	{
		loop {
			var a, duration;
			duration = durs.choose;
			a = { | dur = 1 |
				var attack = 0.01, env;
				env = Env.perc(attack, dur - attack max: 0.05);
				HPF.ar (
					GrayNoise.ar (
						EnvGen.kr (env, 1, Rand (amplo, amphi), doneAction: 2)
					), freq
				);
			}.play (args: [\dur, duration]);
			(duration + 0.01.rrand (0.05)).wait;
		}
	}.fork;
}
)
//:
r = f.(freq: 6000);
q = f.(0.01, 0.1, [0.5, 1, 1.5, 2, 5], 1, 5, 200);

//: ================ GUI ================
w = Window ("GUI").front;
w.view.layout = VLayout (
	HLayout (
		StaticText ().string_("amplo").fixedWidth_(100),
		Slider ().orientation_ (\horizontal)
	),
	HLayout (
		StaticText ().string_("amphi").fixedWidth_ (100),
		Slider ().orientation_ (\horizontal)
	),
	HLayout (
		StaticText ().string_("durs").fixedWidth_ (100),
		TextField ().action_ ({ | me |
			me.value.split ($ ).collect (_.interpret).postln;
		})
	),
	HLayout (
		StaticText ().string_("freq").fixedWidth_ (100),
		Slider ().orientation_ (\horizontal)
	)
);

//:
~valslider = { | ctlname, lo, hi |
	var envir, spec, val, numbox;
	envir = currentEnvironment;
	if (lo.isNil) {
		spec = ctlname.asSpec;
	}{
		spec = ControlSpec (lo, hi);
	};
	spec = ControlSpec (lo, hi);
	HLayout (
		StaticText ().string_(ctlname.asString).fixedWidth_(100),
		Slider ().orientation_ (\horizontal).action_ ({ | me |
			val = spec.map (me.value);
			numbox.value = val;
			envir [ctlname] = val;
		}),
		numbox = NumberBox ().fixedWidth_ (50)
	);
}
//:
w = Window ("test").front;
w.view.layout = VLayout (
	Button ().states_([["start"], ["stop"]]).action_ ({ | me |
		if (me.value > 0) {
			"starting".postln; 
		}{
			"stopping".postln;
		}
	}),
	~valslider.(\alpha, 10, 100),
	~valslider.(\beta, -10, -5),
	~valslider.(\freq);
);
//:
~alpha;
~beta;

//:
/*
~synthslider = { | ctlname, lo, hi |
	var envir, spec, val, numbox;
	envir = currentEnvironment;
	if (lo.isNil) {
		spec = ctlname.asSpec;
	}{
		spec = ControlSpec (lo, hi);
	};
	HLayout (
		StaticText ().string_(ctlname.asString).fixedWidth_(100),
		Slider ().orientation_ (\horizontal).action_ ({ | me |
			val = spec.map (me.value);
			numbox.value = val;
			envir [\synth].set (ctlname, val);
		}),
		numbox = NumberBox ().fixedWidth_ (50)
	)
}
*/
