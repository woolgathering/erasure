////////////////////////////////
/*
  4-channel synths
*/
////////////////////////////////
{|parent|

  SynthDef(\playFile_2ch, {|outBus = 0, buff, envBuff, envBuffSize, pos, start = 0, end = 1, pause = 0|
    var sig, env;
    sig = VDiskIn.ar(2, buff, BufRateScale.kr(buff), loop: 1); // play a buffer (possible to eliminate computations by calculating the rate as an argument)
    pos = pos.linlin(start, end, 0, envBuffSize).clip(0,envBuffSize); // convert stuff; clip it before passing
    env = IndexL.kr(envBuff, pos.lag2(1)); // get our current amplitude and smooth it a bit
    sig = sig*env; // multiply
    // PauseSelf.kr(pause); // pause me when triggered
    Out.ar(outBus, sig); // send it out
  }).add;

  // simple processing: noise volume, distortion, delay(?), etc. No reverb.
  SynthDef(\fxSynth_2ch, {|inBus, outBus, impulseResp, noiseLev, dryWetMix = 0.5, amp = 1, pause = 0|
    var sig;
    sig = In.ar(inBus, 2); // signal in
    // sig = NoiseVol.ar(sig, noiseLev); // noise volume before reverb
    // sig = Distortion.ar(sig, dist);

    // PauseSelf.kr(pause);
    Out.ar(outBus, sig); // send it out
  }).add;

  SynthDef(\VBAP_2ch, {|outBus, inBus, vbapBuff, aziSpeed = 0.01, eleSpeed = 0.01, spread = 50, pause = 1|
    var sig, azi, ele;
    sig = In.ar(inBus, 2); // signal in
    // -180/+180
    azi = [LFNoise1.kr(aziSpeed).range(-45,45), LFNoise1.kr(aziSpeed).range(45,135)]; // these values are WRONG for 2 channels!!! But it's a placeholder
    azi = azi + LFNoise1.kr(aziSpeed*0.33).range(-180,180); // rotate the signal slowly
    // azi = azi.circleRamp; // make wrapping more real
    azi = azi.collect{|ugen| ugen.circleRamp};
    // essentially from -90 to something like -30 on one side to the opposite on the other
    ele = [LFNoise1.kr(eleSpeed).range(30,90).circleRamp(-90,-30) ! 2]; // not sure if this is right
    sig = VBAP(16, sig, vbapBuff, azi, ele, spread.lag2); // spatialize me
    // sig = NoiseVol.ar(sig, lev); // put noise volume here to be on each speaker??? Could be more interesting
    Out.ar(outBus, sig);
  }).add;

}
