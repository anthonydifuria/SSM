//PICCOLO PLAYER



//sample rate
o = Server.local.options;
o.sampleRate = 96000;


s.boot;

s.record;

(
// function load
f ={
b = Buffer.loadDialog(s, action: { arg buffer; //load file
});
	x.set(\f, b);
	y.set(\f, b);
};

//synth player
SynthDef(\player, {

	arg buf,trigger = 1,p,f,rate = 1, loop = 0, trigger_rate = 1,rate_sweep = 1,trigger_rel_rate = 1,init = 0,
	on_off_rate = 0,on_off_f_shift = 0, on_off_p_shift = 0,
	lin0 = 1, lin_inv = 0,
	log0 = 0, log_inv = 0,
	exp0 = 0, exp_inv = 0,
	lin0fs = 0, lin_invfs = 0,
	log0fs = 0, log_invfs = 0,
	exp0fs = 0, exp_invfs = 0,
	lin0ps = 0, lin_invps = 0,
	log0ps = 0, log_invps = 0,
	exp0ps = 0, exp_invps = 0,
	pitch_shift_man = 1,freq_shift_man = 0,
	trigger_pitch_shift = 1,trigger_freq_shift = 1,
	rate_pitch_shift_sweep = 1,rate_freq_shift_sweep = 1,
	pitch_add = 1,freq_add = 1,
	trigger_rel_f_shift = 1, trigger_rel_p_shift = 1,
	on_x = 1;

	var trig_rate,trig_freq,trig_pitch,env,out,out2,trig_rel_rate,trig_rel_freq_shift,trig_rel_pitch_shift,
	trig_lin = 0,trig_lin_inv = 0,
	trig_log = 0,trig_log_inv = 0,
	trig_exp = 0,trig_exp_inv = 0,
	trig_linfs = 0,trig_lin_invfs = 0,
	trig_logfs = 0,trig_log_invfs = 0,
	trig_expfs = 0,trig_exp_invfs = 0,
	trig_linps = 0,trig_lin_invps = 0,
	trig_logps = 0,trig_log_invps = 0,
	trig_expps = 0,trig_exp_invps = 0;





	//RsATE
	//sweep numerico lineare

	trig_rate = Sweep.kr(trigger_rate,rate_sweep);
	trig_rate = Clip.kr(trig_rate,0,1);

	trig_rel_rate = Sweep.kr(trigger_rel_rate,rate_sweep);
	trig_rel_rate = Clip.kr(trig_rel_rate,0,1);



	//linare
	trig_lin =
	LinLin.kr(trig_rate,0,1,0,1)
	+
	LinLin.kr(trig_rel_rate*trigger_rel_rate,0,1,0,-1);

	trig_lin = trig_lin*lin0;

	//lineare inversoc
	trig_lin_inv =
	LinLin.kr(trig_rate,0,1,0,-0.9)
	+
	LinLin.kr(trig_rel_rate*trigger_rel_rate,0,1,0,0.9);

	trig_lin_inv = trig_lin_inv*lin_inv;

	//log
	trig_log =
	LinLin.kr(trig_rate,0,1,1,2.71828182845904523536)
	+
	LinLin.kr(trig_rel_rate*trigger_rel_rate,0,1,2.4596031111569,1);

	trig_log = (log(trig_log)-0.413262)*log0;

	//log inverso
	trig_log_inv =
	LinLin.kr(trig_rate,0,1,2.4596031111569,1)
	+
	LinLin.kr(trig_rel_rate*trigger_rel_rate,0,1,1,2.71828182845904523536);

	trig_log_inv = ((log(trig_log_inv))-0.9)*log_inv;

	//exp
	trig_exp =
	LinExp.kr(trig_rate,0,1,0.0001,1)
	+
	LinLin.kr(trig_rel_rate*trigger_rel_rate,0,1,0.0001,-1);

	trig_exp = trig_exp*exp0;

	//exp inverso
	trig_exp_inv =
	LinExp.kr(trig_rate,0,1,0.0001,0.9)
	+
	LinLin.kr(trig_rel_rate*trigger_rel_rate,0,1,0.0001,-0.9);

	trig_exp_inv = (trig_exp_inv*(-1))*exp_inv;


	//sum rate
	trig_rate = (trig_lin+trig_lin_inv+trig_log+trig_log_inv+trig_exp+trig_exp_inv)*on_off_rate;


	Poll.kr(Impulse.kr(10), trig_rate, \test);




	//FREQ
	//sweep numerico lineare
	trig_freq = Sweep.kr(trigger_freq_shift,rate_freq_shift_sweep);
	trig_freq = Clip.kr(trig_freq,0,1);

	trig_rel_freq_shift = Sweep.kr(trigger_rel_f_shift,rate_freq_shift_sweep);
	trig_rel_freq_shift = Clip.kr(trig_rel_freq_shift,0,1);

	//linare
	trig_linfs =
	LinLin.kr(trig_freq,0,1,0,1)
	+
	LinLin.kr(trig_rel_freq_shift*trigger_rel_f_shift,0,1,0,-1);

	trig_linfs = trig_linfs*lin0fs;

	//lineare inversoc
	trig_lin_invfs = LinLin.kr(trig_freq,0,1,0,-0.9)
	+
	LinLin.kr(trig_rel_freq_shift*trigger_rel_f_shift,0,1,0,0.9);

	trig_lin_invfs = trig_lin_invfs*lin_invfs;

	//log
	trig_logfs = LinLin.kr(trig_freq,0,1,1,2.71828182845904523536)
		+
	LinLin.kr(trig_rel_freq_shift*trigger_rel_f_shift,0,1,2.71828182845904523536,1);

	trig_logfs = (log(trig_logfs))*log0fs;

	//log inverso
	trig_log_invfs =
	LinLin.kr(trig_freq,0,1,2.4596031111569,1)
	+
	LinLin.kr(trig_rel_freq_shift*trigger_rel_f_shift,0,1,1,2.4596031111569);

	trig_log_invfs = ((log(trig_log_invfs))-0.9)*log_invfs;

	//exp
	trig_expfs = LinExp.kr(trig_freq,0,1,0.0001,1)
	+
	LinLin.kr(trig_rel_freq_shift*trigger_rel_f_shift,0,1,1,0.0001);

	trig_expfs = trig_expfs*exp0fs;

	//exp inverso
	trig_exp_invfs = LinExp.kr(trig_freq,0,1,0.0001,0.9)
	+
	LinLin.kr(trig_rel_freq_shift*trigger_rel_f_shift,0,1,0.0001,-0.9);

	trig_exp_invfs = (trig_exp_invfs*(-1))*exp_invfs;



	trig_freq = (trig_linfs+trig_lin_invfs+trig_logfs+trig_log_invfs+trig_expfs+trig_exp_invfs)*on_off_f_shift;


	//PITCH
	//sweep numerico lineare

	trig_pitch = Sweep.kr(trigger_pitch_shift,rate_pitch_shift_sweep);
	trig_pitch = Clip.kr(trig_pitch,0,1);

	trig_rel_pitch_shift = Sweep.kr(trigger_rel_p_shift,rate_pitch_shift_sweep);
	trig_rel_pitch_shift = Clip.kr(trig_rel_pitch_shift,0,1);


	//linare
	trig_linps =
	LinLin.kr(trig_pitch,0,1,0,1)
	+
	LinLin.kr(trig_rel_pitch_shift*trigger_rel_p_shift,0,1,0,-1);

	trig_linps = trig_linps*lin0ps;

	//lineare inversoc
	trig_lin_invps =
	LinLin.kr(trig_pitch,0,1,0,-0.9)
	+
	LinLin.kr(trig_rel_pitch_shift*trigger_rel_p_shift,0,1,0,0.9);

	trig_lin_invps = trig_lin_invps*lin_invps;

	//log
	trig_logps =
	LinLin.kr(trig_pitch,0,1,1,2.71828182845904523536)
	+
	LinLin.kr(trig_rel_pitch_shift*trigger_rel_p_shift,0,1,2.71828182845904523536,1);

	trig_logps = (log(trig_logps))*log0ps;

	//log inverso
	trig_log_invps =
	LinLin.kr(trig_pitch,0,1,2.4596031111569,1)
	+
	LinLin.kr(trig_rel_pitch_shift*trigger_rel_p_shift,0,1,1,2.4596031111569);

	trig_log_invps = ((log(trig_log_invps))-0.9)*log_invps;

	//exp
	trig_expps =
	LinExp.kr(trig_pitch,0,1,0.0001,1)
	+
	LinLin.kr(trig_rel_pitch_shift*trigger_rel_p_shift,0,1,0.0001,-1);

	trig_expps = trig_expps*exp0ps;

	//exp inverso
	trig_exp_invps =
	LinExp.kr(trig_pitch,0,1,0.0001,0.9)
	+
	LinLin.kr(trig_rel_pitch_shift*trigger_rel_p_shift,0,1,0.0001,-0.9);

	trig_exp_invps = (trig_exp_invps*(-1))*exp_invps;



	trig_pitch = (trig_linps+trig_lin_invps+trig_logps+trig_log_invps+trig_expps+trig_exp_invps)*on_off_p_shift;





	out = PlayBuf.ar(2,f,rate+trig_rate,trigger,0,loop);

	out = FreqShift.ar(out,trig_freq*freq_add);

	out = PitchShift.ar(out,0.2,1+(trig_pitch*pitch_add));

	out = out*on_x;

        Out.ar([0,1],out);
}).add;


x = Synth(\player);x.run(false);

//synth player
SynthDef(\player1, {

	arg f, freq=1800, bw=0.2, fs=0, on_off_fs = 0, trigger = 0, loop = 0, on_y = 0;

	var out;


	out = PlayBuf.ar(2,f,1,trigger,0,loop);

	out = BBandPass.ar(BBandPass.ar(out, freq, bw), freq, bw);
	fs = fs*on_off_fs;
	out = FreqShift.ar(out,fs);

	out = out*on_y;

        Out.ar([0,1],out);
}).add;




y = Synth(\player1);y.run(false);
)








//GUI
(

var
w,b,b_trig,b_open,trig,freqsc,b_on_x,
s_rate,n_rate,title,rate,b_rate,s_rate_sweep,n_rate_sweep,
b_loop,b_trig_rate,b_trig_freq,b_trig_pitch,
menu_player_rate,menu_player_fshift,menu_player_pshift,
n_freq_shift,s_freq_shift,n_rate_freq_shift,s_rate_freq_shift,n_add_freq_shift,
n_pitch_shift,s_pitch_shift,n_rate_pitch_shift,s_rate_pitch_shift,n_add_pitch_shift,
b_rel_rate,b_rel_freq,b_rel_pitch,
b_nic1,s_nic1_freq,s_nic1_bw,s_nic_fs1;


w = GUI.window.new("PLAYER", Rect(1,400,1120,800)); w.front; w.view.background = Color.black;


// Create analyzer in a window
c = CompositeView(w, Rect(500, 60, 600, 410));
c.background = Color.gray;
freqsc = FreqScopeView(c, Rect(1, 1, 598, 380));
freqsc.freqMode = 1;
freqsc.active_(true); // turn it on the first time;

w.onClose_({ freqsc.kill }); // you must have this




//TEXT
title = StaticText(w, Rect(180, 1, 800, 40)); title.string = "SoundScape Manipulator"; title.background = Color.black;title.stringColor = Color.white;title.font_(Font("Courier", 40));
rate = StaticText(w, Rect(420, 112, 80, 20)); rate.string = "RATE"; rate.background = Color.black; rate.stringColor = Color.white;

// GUI  rate
b_rate = Button(w, Rect(190,60,100,40));

b_rate.states_([["RESET RATE", Color.white, Color.black]]);
b_rate.action_({
	arg me;
	var val = me.value.postln, reset1,reset2;
	reset1 = val+0.55;
	reset2 = val+1;
	s_rate.value = reset1;
	n_rate.value = reset2;
x.set(\rate, n_rate.value);
	});


n_rate = NumberBox(w, Rect(360,110,50,20));n_rate.background = Color.gray;n_rate.value = 1;

// s rate action
s_rate = Slider(w, Rect(10, 110,340,20));s_rate.background = Color.gray; s_rate.value = 0.55;
s_rate.action_({
	arg me;
	var v = me.value.linlin(0,1,-4,5).postln;
	x.set(\rate, v);

n_rate.value = v;
});


//   on/off
b = Button(w, Rect(10,60 ,100 , 40));
b.states_([["PLAY", Color.white, Color.black],["STOP", Color.white, Color.black]]);
b.action_({
	arg me, trigger ;
	var val = me.value.postln ;
	if(val == 1){x.run(true)}{x.run(false)};
	if(val == 1){y.run(true)}{y.run(false)};
	x.set(\trigger, val);
	y.set(\trigger, val);
	x.set(\init, val);
	});

// trig play
b_trig = Button(w, Rect(120,60,60,40));
b_trig.states_([["REPLAY", Color.white, Color.black],["OFF",Color.white,Color.black]]);
b_trig.action_({
	arg me;
	var val = me.value.postln;
	if(val == 0){x.set(true)}{x.set(false)};
	x.set(\trigger, val);
	y.set(\trigger, val)
});

// open panel
b_open = Button(w, Rect(400,60,60,40));
b_open.states_([["OPEN", Color.white, Color.black]]);
b_open.action_({
	arg me;
	var val = me.value.postln;
	if(val == 0){f.value(true)};
	});

//loop
b_loop = Button(w, Rect(300,60,80,40));
b_loop.states_([["LOOP ON", Color.white, Color.black],["LOOP OFF",Color.white,Color.black]]);
b_loop.action_({
	arg me;
	var val = me.value.postln;
	if(val == 0){x.set(true)}{x.set(false)};
	x.set(\loop, val);
	y.set(\loop, val);
    });



//Switch X - Y
b_on_x = Button(w, Rect(10,500,100,40));
b_on_x.states_([["ON first", Color.white, Color.black],["OFF first",Color.white,Color.black]]);
b_on_x.font_(Font("Courier", 15));
b_on_x.action_({
	arg me;
	var val = me.value.postln;
val.postln;
	x.set(\on_x, 1-val);
	y.set(\on_y, val);

    });



//Button trig transform RATE
b_trig_rate = Button(w, Rect(280,150,100,40));
b_trig_rate.states_([["RATE in", Color.white, Color.black],["RATE out",Color.white,Color.black]]);
b_trig_rate.font_(Font("Courier", 15));
b_trig_rate.action_({
	arg me;
	var val = me.value.postln;
val.postln;
	x.set(\trigger_rate, val);
	x.set(\trigger_rel_rate, 1-val);

    });

b_rel_rate = Button(w, Rect(390,150,80,40));
b_rel_rate.states_([["RATE ON", Color.white, Color.black],["RATE OFF",Color.white,Color.black]]);
b_rel_rate.font_(Font("Courier", 15));
b_rel_rate.action_({
	arg me;
	var val = me.value.postln;
val.postln;
	x.set(\on_off_rate, val);
	x.set(\trigger_rate, 0);


    });


menu_player_rate = PopUpMenu(w,Rect(10,150,180,40));
menu_player_rate.items = [
    "Linear","Linear Inverse","Logarithm","Logarithm Inverse","Exponential","Exponential Inverse"
];

menu_player_rate.background_(Color.black);        // only changes the look of displayed item
menu_player_rate.stringColor_(Color.white);            // only changes the look of displayed item
menu_player_rate.font_(Font("Courier", 15));           // only changes the look of displayed item
menu_player_rate.action = { arg menu;
    [menu.value, menu.item].postln;

	switch(
		menu.value;,
		0,{	x.set(\lin0, 1);
			x.set(\lin_inv, 0);
			x.set(\log0, 0);
			x.set(\log_inv, 0);
			x.set(\exp0, 0);
			x.set(\exp_inv, 0);
		},
		1,{ x.set(\lin0, 0);
			x.set(\lin_inv, 1);
			x.set(\log0, 0);
			x.set(\log_inv, 0);
			x.set(\exp0, 0);
			x.set(\exp_inv, 0);
		},
		2,{ x.set(\lin0, 0);
			x.set(\lin_inv, 0);
			x.set(\log0, 1);
			x.set(\log_inv, 0);
			x.set(\exp0, 0);
			x.set(\exp_inv, 0);
		},
		3,{ x.set(\lin0, 0);
			x.set(\lin_inv, 0);
			x.set(\log0, 0);
			x.set(\log_inv, 1);
			x.set(\exp0, 0);
			x.set(\exp_inv, 0);
		},
		4,{ x.set(\lin0, 0);
			x.set(\lin_inv, 0);
			x.set(\log0, 0);
			x.set(\log_inv, 0);
			x.set(\exp0, 1);
			x.set(\exp_inv, 0);
		},
		5,{ x.set(\lin0, 0);
			x.set(\lin_inv, 0);
			x.set(\log0, 0);
			x.set(\log_inv, 0);
			x.set(\exp0, 0);
			x.set(\exp_inv, 1);
		},
	);
};

//slide rate sweep
n_rate_sweep = NumberBox(w, Rect(360,200,50,20));n_rate_sweep.background = Color.gray;n_rate_sweep.value = 1;
s_rate_sweep = Slider(w, Rect(10, 200,340,20));s_rate_sweep.background = Color.gray; s_rate_sweep.value = 1;
s_rate_sweep.action_({
	arg me;
	var v = me.value.linlin(0,1,0.001,1).postln;
	x.set(\rate_sweep, v);
	n_rate_sweep.value = v;

});













//ADD FREQ SHIFT

rate = StaticText(w, Rect(420, 242, 80, 20)); rate.string = "F SHIFT"; rate.background = Color.black; rate.stringColor = Color.white;

//slide rate sweep
n_freq_shift = NumberBox(w, Rect(360,240,50,20));n_freq_shift.background = Color.gray;n_freq_shift.value = 0;
s_freq_shift = Slider(w, Rect(10, 240,340,20));s_freq_shift.background = Color.gray; s_freq_shift.value = 0.5;
s_freq_shift.action_({
	arg me;
	var v = me.value.linlin(0,1,-5000,5000).postln;
	x.set(\freq_shift_man, v);
	n_freq_shift.value = v;

});

//Button trig transform ADD FREQSHIFT
b_trig_freq = Button(w, Rect(280,270,100,40));
b_trig_freq.states_([["F SHIFT in", Color.white, Color.black],["F SHIFT out",Color.white,Color.black]]);
b_trig_freq.font_(Font("Courier", 15));
b_trig_freq.action_({
	arg me;
	var val = me.value.postln;
val.postln;
	x.set(\trigger_freq_shift, val);
	x.set(\trigger_rel_f_shift, 1-val);

    });

b_rel_freq = Button(w, Rect(390,270,80,40));
b_rel_freq.states_([["Rel ON", Color.white, Color.black],["Rel OFF",Color.white,Color.black]]);
b_rel_freq.font_(Font("Courier", 15));
b_rel_freq.action_({
	arg me;
	var val = me.value.postln;
val.postln;
	x.set(\on_off_f_shift, val);
	x.set(\trigger_freq_shift, 0);
    });


menu_player_fshift = PopUpMenu(w,Rect(10,270,180,40));
menu_player_fshift.items = [
    "Linear","Linear Inverse","Logarithm","Logarithm Inverse","Exponential","Exponential Inverse"
];

menu_player_fshift.background_(Color.black);        // only changes the look of displayed item
menu_player_fshift.stringColor_(Color.white);            // only changes the look of displayed item
menu_player_fshift.font_(Font("Courier", 15));           // only changes the look of displayed item
menu_player_fshift.action = { arg menu;
    [menu.value, menu.item].postln;

	switch(
		menu.value;,
		0,{	x.set(\lin0fs, 1);
			x.set(\lin_invfs, 0);
			x.set(\log0fs, 0);
			x.set(\log_invfs, 0);
			x.set(\exp0fs, 0);
			x.set(\exp_invfs, 0);
		},
		1,{ x.set(\lin0fs, 0);
			x.set(\lin_invfs, 1);
			x.set(\log0fs, 0);
			x.set(\log_invfs, 0);
			x.set(\exp0fs, 0);
			x.set(\exp_invfs, 0);
		},
		2,{ x.set(\lin0fs, 0);
			x.set(\lin_invfs, 0);
			x.set(\log0fs, 1);
			x.set(\log_invfs, 0);
			x.set(\exp0fs, 0);
			x.set(\exp_invfs, 0);
		},
		3,{ x.set(\lin0fs, 0);
			x.set(\lin_invfs, 0);
			x.set(\log0fs, 0);
			x.set(\log_invfs, 1);
			x.set(\exp0fs, 0);
			x.set(\exp_invfs, 0);
		},
		4,{ x.set(\lin0fs, 0);
			x.set(\lin_invfs, 0);
			x.set(\log0fs, 0);
			x.set(\log_invfs, 0);
			x.set(\exp0fs, 1);
			x.set(\exp_invfs, 0);
		},
		5,{ x.set(\lin0fs, 0);
			x.set(\lin_invfs, 0);
			x.set(\log0fs, 0);
			x.set(\log_invfs, 0);
			x.set(\exp0fs, 0);
			x.set(\exp_invfs, 1);
		},
	);
};

//slide rate sweep
n_rate_freq_shift = NumberBox(w, Rect(360,320,50,20));n_rate_freq_shift.background = Color.gray;n_rate_freq_shift.value = 1;
s_rate_freq_shift = Slider(w, Rect(10, 320,340,20));s_rate_freq_shift.background = Color.gray; s_rate_freq_shift.value = 1;
s_rate_freq_shift.action_({
	arg me;
	var v = me.value.linlin(0,1,0.001,1).postln;
	x.set(\rate_freq_shift_sweep, v);
	n_rate_freq_shift.value = v;

});

//frequenza da raggiungere
n_add_freq_shift = NumberBox(w, Rect(200,290,70,20));n_add_freq_shift.background = Color.gray;n_add_freq_shift.value = 0;
n_add_freq_shift.action = {arg numb; x.set(\freq_add,numb.value); };















//PITCH SHIFT

rate = StaticText(w, Rect(420, 372, 80, 20)); rate.string = "P SHIFT"; rate.background = Color.black; rate.stringColor = Color.white;
//slide rate sweep
n_pitch_shift = NumberBox(w, Rect(360,370,50,20));n_pitch_shift.background = Color.gray;n_pitch_shift.value = 1;
s_pitch_shift = Slider(w, Rect(10, 370,340,20));s_pitch_shift.background = Color.gray; s_pitch_shift.value = 0.55;
s_pitch_shift.action_({
	arg me;
	var v = me.value.linlin(0,1,0.125,4).postln;
	x.set(\pitch_shift_man, v);
n_pitch_shift.value = v;
});

//Button trig transform ADD FREQSHIFT
b_trig_pitch = Button(w, Rect(280,400,100,40));
b_trig_pitch.states_([["P SHIFT in", Color.white, Color.black],["P SHIFT out",Color.white,Color.black]]);
b_trig_pitch.font_(Font("Courier", 15));
b_trig_pitch.action_({
	arg me;
	var val = me.value.postln;
val.postln;
	x.set(\trigger_pitch_shift, val);
	x.set(\trigger_rel_p_shift, 1-val);

    });

b_rel_pitch = Button(w, Rect(390,400,80,40));
b_rel_pitch.states_([["Rel ON", Color.white, Color.black],["Rel OFF",Color.white,Color.black]]);
b_rel_pitch.font_(Font("Courier", 15));
b_rel_pitch.action_({
	arg me;
	var val = me.value.postln;
val.postln;
	x.set(\on_off_p_shift, val);
	x.set(\trigger_pitch_shift, 0);

    });


menu_player_pshift = PopUpMenu(w,Rect(10,400,180,40));
menu_player_pshift.items = [
    "Linear","Linear Inverse","Logarithm","Logarithm Inverse","Exponential","Exponential Inverse"
];

menu_player_pshift.background_(Color.black);        // only changes the look of displayed item
menu_player_pshift.stringColor_(Color.white);            // only changes the look of displayed item
menu_player_pshift.font_(Font("Courier", 15));           // only changes the look of displayed item
menu_player_pshift.action = { arg menu;
    [menu.value, menu.item].postln;

	switch(
		menu.value;,
		0,{	x.set(\lin0ps, 1);
			x.set(\lin_invps, 0);
			x.set(\log0ps, 0);
			x.set(\log_invps, 0);
			x.set(\exp0ps, 0);
			x.set(\exp_invps, 0);
		},
		1,{ x.set(\lin0ps, 0);
			x.set(\lin_invps, 1);
			x.set(\log0ps, 0);
			x.set(\log_invps, 0);
			x.set(\exp0ps, 0);
			x.set(\exp_invps, 0);
		},
		2,{ x.set(\lin0ps, 0);
			x.set(\lin_invps, 0);
			x.set(\log0ps, 1);
			x.set(\log_invps, 0);
			x.set(\exp0ps, 0);
			x.set(\exp_invps, 0);
		},
		3,{ x.set(\lin0ps, 0);
			x.set(\lin_invps, 0);
			x.set(\log0ps, 0);
			x.set(\log_invps, 1);
			x.set(\exp0ps, 0);
			x.set(\exp_invps, 0);
		},
		4,{ x.set(\lin0ps, 0);
			x.set(\lin_invps, 0);
			x.set(\log0ps, 0);
			x.set(\log_invps, 0);
			x.set(\exp0ps, 1);
			x.set(\exp_invps, 0);
		},
		5,{ x.set(\lin0ps, 0);
			x.set(\lin_invps, 0);
			x.set(\log0ps, 0);
			x.set(\log_invps, 0);
			x.set(\exp0ps, 0);
			x.set(\exp_invps, 1);
		},
	);
};

//slide rate sweep
n_rate_pitch_shift = NumberBox(w, Rect(360,450,50,20));n_rate_pitch_shift.background = Color.gray;n_rate_pitch_shift.value = 1;
s_rate_pitch_shift = Slider(w, Rect(10, 450,340,20));s_rate_pitch_shift.background = Color.gray; s_rate_pitch_shift.value = 1;
s_rate_pitch_shift.action_({
	arg me;
	var v = me.value.linlin(0,1,0.001,1).postln;
	x.set(\rate_pitch_shift_sweep, v);
n_rate_pitch_shift.value = v;
});

//pitch da raggiungere
n_add_pitch_shift = NumberBox(w, Rect(200,420,70,20));n_add_pitch_shift.background = Color.gray;n_add_pitch_shift.value = 0;
n_add_pitch_shift.action = {arg numb; x.set(\pitch_add,numb.value); };



//NICCHIE







s_nic_fs1 = Slider(w, Rect(10, 600,900,20));s_nic_fs1.background = Color.gray; s_nic_fs1.value = 0.5;
s_nic1_freq = Slider(w, Rect(10, 550, 900, 20));s_nic1_freq.background = Color.gray; s_nic1_freq.value = 0.5;
s_nic1_bw = Slider(w, Rect(10, 575, 900, 20));s_nic1_bw.background = Color.gray; s_nic1_bw.value = 0.5;


b_nic1 = Button(w, Rect(40,700,80,40));
b_nic1.states_([["Freez on", Color.white, Color.black],["Freez off",Color.white,Color.black]]);
b_nic1.font_(Font("Courier", 15));
b_nic1.action_({
	arg me;
	var val = me.value.postln;
	val.postln;


	y.set(\on_off_fs, val);




	switch (val,
		0,{
			s_nic1_freq.action_({arg me;var v = me.value.linlin(0,1,40,16000).postln;y.set(\freq, v);
			});
			s_nic1_bw.action_({arg me;var v = me.value.linlin(0,1,0.01,20).postln;y.set(\bw, v);
			});
			y.set(\fs, 0);
			s_nic_fs1.value = 0.5;
		},
		1, {
			s_nic_fs1.action_({arg me;var v = me.value.linlin(0,1,-3000,3000).postln;y.set(\fs, v);
			});
		}
	)

});










)








(
z = {
BBandPass.ar(
    BrownNoise.ar(0.1),
    MouseX.kr(20, 20000, \exponential),
    MouseY.kr(0.0, 20.0, \linear), // bw
    0.5); // mul
}.play)

s.freqscope