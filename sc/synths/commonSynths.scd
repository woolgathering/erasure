//////////////////////////////////////////
/*
  Synths common to all episodes/sections. These do not need seperate versions depending on channels.
*/
//////////////////////////////////////////

SynthDef(\sectionPipe, {|inBus, outBus, fader, envBuff, envBuffSize, start, end, pause = 0|
  var sig, env;
  sig = In.ar(inBus, 16); // 16 channels in
  fader = fader.lag2(0.1); // 10 second lag (see Routine in updateVisitors)
  fader = fader.linlin(start, end, 0, envBuffSize).clip(0,envBuffSize); // convert shit; clip it before passing
  env = IndexL.kr(envBuff, fader).lag2; // get our current amplitude and smooth it a bit
  Out.ar(outBus, sig*env);
  PauseSelf.kr(pause);
}).send(s);

SynthDef(\table_LFO, {|outBus, table, speed|
  var sig, indexer;
  indexer = LFTri.kr(speed, iphase: Rand(0,4), mul: 500, add: 500); // a triangle wave to index into the table with an initial phase offset
  sig = IndexL.kr(table, indexer); // read into the table
  Out.kr(outBus, sig); // write it to the bus
}).send(s);

SynthDef(\section_LFO, {|outBus, speed, pause = 0|
  var trig, val;
  trig = Dust.kr(speed); // speed is the reciprocal of time; i.e. 20min = (20*60).reciprocal
  val = TRand(0, 1, trig).lag2(speed); // works?
  Out.kr(outBus, val);
}).send(s);

SynthDef(\reverb, {|inBus, outBus, impulseBuffs = #[0,0], initDel = 0.02, dry = 0.5, wet = 0.5, hp = 250|
  var sig, rev;
  sig = In.ar(inBus, 16); // 16 channels
  rev = DelayN.ar(sig, initDel, initDel); // initial delay
  // individual reverbs on each channel
  rev = [
    PartConv.ar(rev[0], 4098, impulseBuffs[0], 0.707),
    PartConv.ar(rev[1], 4098, impulseBuffs[1], 0.707),
    PartConv.ar(rev[2], 4098, impulseBuffs[0], 0.707),
    PartConv.ar(rev[3], 4098, impulseBuffs[1], 0.707),
    PartConv.ar(rev[4], 4098, impulseBuffs[0], 0.707),
    PartConv.ar(rev[5], 4098, impulseBuffs[1], 0.707),
    PartConv.ar(rev[6], 4098, impulseBuffs[0], 0.707),
    PartConv.ar(rev[7], 4098, impulseBuffs[1], 0.707),
    PartConv.ar(rev[8], 4098, impulseBuffs[0], 0.707),
    PartConv.ar(rev[9], 4098, impulseBuffs[1], 0.707),
    PartConv.ar(rev[10], 4098, impulseBuffs[0], 0.707),
    PartConv.ar(rev[11], 4098, impulseBuffs[1], 0.707),
    PartConv.ar(rev[12], 4098, impulseBuffs[0], 0.707),
    PartConv.ar(rev[13], 4098, impulseBuffs[1], 0.707),
    PartConv.ar(rev[14], 4098, impulseBuffs[0], 0.707),
    PartConv.ar(rev[15], 4098, impulseBuffs[1], 0.707),
  ];
  // subRev = PartConv.ar(rev.sum*0.0625, 4098, impulseBuffs[1], 0.707); // subwoofer reverb

  rev = HPF.ar(rev, hp); // highpass
  rev = CompanderD.ar(rev, 0.707, 1, 0.333); // compress it just to be safe
  OutBus.ar(outBus, (rev*wet)+(sig*dry)); // send it out
  // OutBus.ar(subBus, subRev*wet); // subwoofer reverb out
}).send(s);

SynthDef(\mainPipe, {|inBus, outBus, subBus, amp = 0.2|
  var sig, subSig;
  sig = In.ar(inBus, 16); // 16 channels in
  subSig = LPF.ar(sig.sum*0.0625*amp, 100); // lowpass the subwoofer signal
  Out.ar(subBus, subSig); // send to the sub (no reverb?)
  Out.ar(outBus, HPF.ar(sig*amp, 100)); // hipass and send it out
}).send(s);
