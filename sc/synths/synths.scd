// synths
SynthDef(\playFile, {|outBus = 0, buff, envBuff, envBuffSize, pos, start = 0, end = 1, pause = 0|
  var sig, env;
  sig = PlayBuf.ar(4, buff, BufRateScale.kr(buff), loop: 1); // play a buffer
  pos = pos.linlin(start, end, 0, envBuffSize).clip(0,envBuffSize); // convert shit; clip it before passing
  env = IndexL.kr(envBuff, pos.lag2(1)); // get our current amplitude and smooth it a bit
  sig = sig*env; // multiply
  PauseSelf.kr(pause); // pause me when triggered
  Out.ar(outBus, sig); // send it out
}).send(s);

// simple processing: noise volume, distortion, delay(?), etc. No reverb.
SynthDef(\fxSynth, {|inBus, outBus, impulseResp, noiseLev, dryWetMix = 0.5, amp = 1, pause = 0|
  var sig;
  sig = In.ar(inBus, 4); // signal in
  // sig = NoiseVol.ar(sig, noiseLev); // noise volume before reverb
  // sig = Distortion.ar(sig, dist);
  // sig = Spatializer.ar(sig, spat); individualized spatialization? Maybe simple rotation is all that's needed.

  PauseSelf.kr(pause)
  // Out.ar(outBus, sig); // send it out
}).send(s);

SynthDef(\sectionPipe, {|inBus, outBus, fader, envBuff, envBuffSize, start, end, pause = 0|
  var sig, env;
  sig = In.ar(inBus, 4); // four channels in
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

SynthDef(\reverb, {|inBus, outBus, impulseBuff, initDel = 0.02, dry = 0.5, wet = 0.5, hp = 250|
  var sig, rev;
  sig = In.ar(inBus, 4); // four channels in for kicks
  // rev = PartConv.ar()
}).send(s);

SynthDef(\mainPipe, {|inBus, outBus, amp = 0.2|
  var sig;
  sig = In.ar(inBus, 4); // four channels in
  Out.ar(outBus, sig*amp); // send it out
}).send(s);
