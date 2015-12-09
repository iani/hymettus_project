(
f = {
	var a;
	a = { WhiteNoise.ar (0.1) }.play;
	0.5.wait;
	a.free;
}
)
//:
f.fork;
//:
(
f = {
	loop {var a;
		a = { WhiteNoise.ar (0.1) }.play;
		0.5.wait;
		a.free;
		0.1.wait;
	};
}
)
//:
f.fork;
//:
(
f = {
	loop {
		var a;
		a = { WhiteNoise.ar (Rand (0.05, 0.2)) }.play;
		[0.05, 0.15].choose.wait;
		a.free;
		0.01.rrand (0.05).wait;
	};
}
)
//:
f.fork;
