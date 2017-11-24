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

// reverb
SynthDef(\fxSynth, {|inBus, outBus, impulseResp, noiseLev, dryWetMix = 0.5, amp = 1, pause = 0|
  var sig;
  sig = In.ar(inBus, 4); // signal in
  // sig = NoiseVol.ar(sig, noiseLev); // noise volume before reverb
  // PartConv
  PauseSelf.kr(pause)
  // Out.ar(outBus, sig); // send it out
}).send(s);

SynthDef(\epiFader, {|outBus, value = 0, fadeTime = 10|
  var sig;
  // sig =
}).send(s);
