// synths
SynthDef(\playFile, {|outBus = 0, buff, amp = 0.707, gate = 1, att = 10, dec = 10|
  var sig, env;
  sig = PlayBuf.ar(4, buff, BufRateScale.kr(buff), loop: 1); // play a buffer
  env = EnvGen.kr(
    env: Env.asr(att, 0, dec),
    gate: gate,
    levelScale: amp,
    doneAction: 1 // pause synth?
  );
  sig = sig*env;
  Out.ar(outBus, sig); // send it out
}).send(s);

// reverb
SynthDef(\reverb_noiseVol, {|inBus, outBus, impulseResp, noiseLev, dry = 0.5, wet = 0.5|
  var sig;
  sig = In.ar(inBus, 4); // signal in
  // sig = NoiseVol.ar(sig, noiseLev); // noise volume before reverb
  // PartConv
  // Out.ar(outBus, sig); // send it out
}).send(s);
