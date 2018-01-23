f////////////////////////////////
/*
  4-channel synths
*/
////////////////////////////////

SynthDef(\playFile_4ch, {|outBus = 0, buff, envBuff, envBuffSize, pos, start = 0, end = 1, pause = 0|
  var sig, env;
  sig = VDiskIn.ar(8, buff, BufRateScale.kr(buff), loop: 1); // play a buffer (possible to eliminate computations by calculating the rate as an argument)
  pos = pos.linlin(start, end, 0, envBuffSize).clip(0,envBuffSize); // convert stuff; clip it before passing
  env = IndexL.kr(envBuff, pos.lag2(1)); // get our current amplitude and smooth it a bit
  sig = sig*env; // multiply
  PauseSelf.kr(pause); // pause me when triggered
  Out.ar(outBus, sig); // send it out
}).send(s);

// simple processing: noise volume, distortion, delay(?), etc. No reverb.
SynthDef(\fxSynth_8ch, {|inBus, outBus, impulseResp, noiseLev, dryWetMix = 0.5, amp = 1, pause = 0|
  var sig;
  sig = In.ar(inBus, 4); // signal in
  // sig = NoiseVol.ar(sig, noiseLev); // noise volume before reverb
  // sig = Distortion.ar(sig, dist);

  PauseSelf.kr(pause)
  // Out.ar(outBus, sig); // send it out
}).send(s);

SynthDef(\VBAP_8ch, {|outBus, inBus, vbapBuff, aziSpeed = 0.01, eleSpeed = 0.008333, spread = 50, pause = 1|
  var sig, azi, ele;
  sig = In.ar(inBus, 8); // signal in
  sig = HPF.ar(sig, 60); // hipass
  // -180/+180
  azi = [LFNoise1.kr(aziSpeed).range(-22.5,22.5), LFNoise1.kr(aziSpeed).range(22.5,67.5), LFNoise1.kr(aziSpeed).range(67.5,112.5), LFNoise1.kr(aziSpeed).range(112.5,157.5), LFNoise1.kr(aziSpeed).range(-157.5,157.5), LFNoise1.kr(aziSpeed).range(-157.5,-112.5), LFNoise1.kr(aziSpeed).range(-112.5,-67,5), LFNoise1.kr(aziSpeed).range(-67.5,-22.5)];
  azi = azi + LFNoise1.kr(aziSpeed*0.33).range(-180,180); // rotate the signal slowly
  azi = azi.circleRamp; // make wrapping more real
  // essentially from -90 to something like -30 on one side to the opposite on the other
  ele = [LFNoise1.kr(eleSpeed).range(30,90).circleRamp(-90,-30) ! 8]; // not sure if this is right
  sig = VBAP(16, sig, vbapBuff, azi, ele, spread.lag2); // spatialize me
  OutBus.ar(outBus, sig);
}).send(s);
