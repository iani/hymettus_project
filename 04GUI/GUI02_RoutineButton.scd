//:
(
var window, on_off_button, routine;
window = Window ("routine start-stop").front;
window.view.layout = VLayout (
	on_off_button = Button ()
	.states_ ([["start"], ["stop"]])
	.action_ ({ | me |
		if (me.value > 0) {
			routine = {
			    inf do: { | i |
					i.postln;
					{ WhiteNoise.ar (EnvGen.kr (Env.perc, 1, doneAction: 2) * 0.1).dup }.play;
					1.wait;
				};
			}.fork;
			CmdPeriod add: { on_off_button.value = 0 };
		}{
			routine.stop;
		}
	});
);
window.onClose = { routine.stop; };
)
//:
(
var window, on_off_button, routineFunc, routine;

routineFunc = {
	15 do: { | i |
		i.postln;
		{ WhiteNoise.ar (EnvGen.kr (Env.perc (0.01, 0.1), 1, doneAction: 2) * 0.1).dup }.play;
		0.2.wait;
	}
};

window = Window ("routine: ubpdate on stop").front;
window.view.layout = VLayout (
	on_off_button = Button ()
	.states_ ([["start"], ["stop"]])
	.action_ ({ | me |
		if (me.value > 0) {
			routine = {
			    routineFunc.value;
				{ on_off_button.value = 0 }.defer;
			}.fork;
			CmdPeriod add: { on_off_button.value = 0 };
		}{
			routine.stop;
		}
	});
);
window.onClose = { routine.stop; };
)
//: