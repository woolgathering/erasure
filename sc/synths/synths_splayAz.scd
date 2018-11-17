{|parent|

  SynthDef(\sectionPipe, {|inBus, outBus, fader, envBuff, envBuffSize, start, end, pause = 0|
    var sig, env;
    sig = In.ar(inBus, 4); // 16 channels in
    fader = fader.lag2(45); // 10 second lag (see Routine in updateVisitors)
    fader = fader.linlin(start, end, 0, envBuffSize).clip(0,envBuffSize); // convert shit; clip it before passing
    env = IndexL.kr(envBuff, fader).lag2(45); // get our current amplitude and smooth it a bit
    Out.ar(outBus, sig*env);
    PauseSelf.kr(pause);
  }).send(parent.server);

  SynthDef(\table_LFO, {|outBus, table, speed|
    var sig, indexer;
    indexer = LFTri.kr(speed, iphase: Rand(0,4), mul: 500, add: 500); // a triangle wave to index into the table with an initial phase offset
    sig = IndexL.kr(table, indexer).lag2(1); // read into the table
    Out.kr(outBus, sig); // write it to the bus
  }).send(parent.server);

  SynthDef(\section_LFO, {|outBus, speed, pause = 0|
    var trig, val;
    // val = LFNoise2.kr(speed).range(0,1);
    val = LFDNoise3.kr(speed).range(0,1);
    // PauseSelf.kr(pause);
    Out.kr(outBus, val);
  }).send(parent.server);

  SynthDef(\reverb, {|inBus, outBus, impulseBuffs = #[0,0], initDel = 0.02, mix = -1, leak = 0.01, hp = 250|
    var sig, rev, leakSig;
    sig = In.ar(inBus, 4); // 16 channels
    mix = mix.lag3(30); // low pass the mix signal
    rev = DelayN.ar(sig, (initDel+Rand(0.0,0.001) ! 4), initDel+0.001); // initial delay
    leakSig = Mix(rev)*leak; // a little bit of everything for each channel, regardless of position
    // individual reverbs on each channel
    rev = [
      PartConv.ar(rev[0]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[1]+leakSig, 4096, impulseBuffs[1], 0.707),
      PartConv.ar(rev[2]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[3]+leakSig, 4096, impulseBuffs[1], 0.707),
      // PartConv.ar(rev[4]+leakSig, 4096, impulseBuffs[0], 0.707),
      // PartConv.ar(rev[5]+leakSig, 4096, impulseBuffs[1], 0.707),
      // PartConv.ar(rev[6]+leakSig, 4096, impulseBuffs[0], 0.707),
      // PartConv.ar(rev[7]+leakSig, 4096, impulseBuffs[1], 0.707),
      // PartConv.ar(rev[8]+leakSig, 4096, impulseBuffs[0], 0.707),
      // PartConv.ar(rev[9]+leakSig, 4096, impulseBuffs[1], 0.707),
      // PartConv.ar(rev[10]+leakSig, 4096, impulseBuffs[0], 0.707),
      // PartConv.ar(rev[11]+leakSig, 4096, impulseBuffs[1], 0.707),
      // PartConv.ar(rev[12]+leakSig, 4096, impulseBuffs[0], 0.707),
      // PartConv.ar(rev[13]+leakSig, 4096, impulseBuffs[1], 0.707),
      // PartConv.ar(rev[14]+leakSig, 4096, impulseBuffs[0], 0.707),
      // PartConv.ar(rev[15]+leakSig, 4096, impulseBuffs[1], 0.707),
    ];
    // subRev = PartConv.ar(rev.sum*0.0625, 4098, impulseBuffs[1], 0.707); // subwoofer reverb

    rev = HPF.ar(rev, hp); // highpass
    rev = CompanderD.ar(rev, 0.707, 1, 0.666); // compress it just to be safe
    sig = XFade2.ar(sig, rev*0.17782, mix.lag2(5)); // mix wet and dry
    sig = LeakDC.ar(sig); // make sure we're cool
    Out.ar(outBus, sig); // send it out
    // Out.ar(outBus, (rev*wet*0.17782)+(sig*dry)); // send it out
  }).send(parent.server);

  SynthDef(\mainPipe, {|inBus, outBus, amp = 0.2|
    var sig, lev;
    sig = In.ar(inBus, 4); // 16 channels in
    // lev = MouseX.kr(0,1);
    // sig = sig.collect{|chan| NoiseVol.ar(chan, lev)};
    sig = BAllPass.ar(sig, (Rand(1000, 10000) ! 4), 0.8); // change the phases of each speaker
    Out.ar(outBus, HPF.ar(sig*amp, 50)); // hipass and send it out
  }).send(parent.server);

  ////////////////////////////////
  /*
    4-channel synths
  */
  ////////////////////////////////

  SynthDef(\playFile_4ch, {|outBus = 0, buff, envBuff, envBuffSize, pos, start = 0, end = 1, dur = 100|
    var sig, env, diskEnv;
    sig = VDiskIn.ar(4, buff, BufRateScale.kr(buff), loop: 1);
    diskEnv = EnvGen.kr(
      Env.circle([0,1,1,0], [0.05,0.9,0.05], \sine),
      timeScale: dur
    );
    sig = sig*diskEnv;
    pos = pos.linlin(start, end, 0, envBuffSize).clip(0,envBuffSize); // convert stuff; clip it before passing
    env = IndexL.kr(envBuff, pos.lag2(10)); // get our current amplitude and smooth it a bit
    sig = sig*env; // multiply
    Out.ar(outBus, sig);
  }).send(parent.server);

  // simple processing: noise volume, distortion, delay(?), etc. No reverb.
  SynthDef(\fxSynth_4ch, {|inBus, outBus, noiseLev = 1, dryWetMix = 0.5|
    var sig;
    sig = In.ar(inBus, 4); // signal in
    // sig = sig.collect{|chan|
    //   var val;
    //   val = MouseX.kr(0,1);
    //   NoiseVol.ar(chan, val) * val.linexp(0,1,3,1); // noise volume before reverb
    // };
    // sig = NoiseVol.ar(sig, MouseX.kr(0,1)); // noise volume before reverb
    // sig = Distortion.ar(sig, dist);

    Out.ar(outBus, sig); // send it out
  }).send(parent.server);

  SynthDef(\spat_4ch, {|outBus, inBus, rotSpd = 0.1|
    var sig, lev;
    sig = In.ar(inBus, 4); // signal in
    sig = SplayAz.ar(4, sig, spread: 1, level: 1, width: LFNoise1.kr(0.01).range(2,3), center: 1, orientation: LFNoise1.kr(rotSpd).range(0,7));
    // sig = sig.collect{|chan| Pan2.ar(chan, LFNoise1.kr(0.01).range(-1, 0.5))}; // collect them into pairs
    // sig = [
    //   // lower ring
    //   sig[0][0],sig[1][0],sig[2][0],sig[3][0],sig[4][0],sig[5][0],sig[6][0],sig[7][0],
    //   // upper ring
    //   sig[0][1],sig[1][1],sig[2][1],sig[3][1],sig[4][1],sig[5][1],sig[6][1],sig[7][1]
    // ];
    // sig = NoiseVol.ar(sig, lev); // put noise volume here to be on each speaker??? Could be more interesting
    Out.ar(outBus, sig);
  }).send(parent.server);

  ////////////////////////////////
  /*
    8-channel synths
  */
  ////////////////////////////////

  SynthDef(\playFile_8ch, {|outBus = 0, buff, envBuff, envBuffSize, pos, start = 0, end = 1, dur = 100|
    var sig, env, diskEnv;
    sig = VDiskIn.ar(8, buff, BufRateScale.kr(buff), loop: 1);
    diskEnv = EnvGen.kr(
      Env.circle([0,1,1,0], [0.05,0.9,0.05], \sine),
      timeScale: dur
    );
    sig = sig*diskEnv;
    pos = pos.linlin(start, end, 0, envBuffSize).clip(0,envBuffSize); // convert stuff; clip it before passing
    env = IndexL.kr(envBuff, pos.lag2(10)); // get our current amplitude and smooth it a bit
    sig = sig*env; // multiply
    Out.ar(outBus, sig);
  }).send(parent.server);

  // simple processing: noise volume, distortion, delay(?), etc. No reverb.
  SynthDef(\fxSynth_8ch, {|inBus, outBus, noiseLev, dryWetMix = 0.5|
    var sig;
    sig = In.ar(inBus, 8); // signal in
    // sig = sig.collect{|chan|
    //   var val;
    //   val = MouseX.kr(0,1);
    //   NoiseVol.ar(chan, val) * val.linexp(0,1,3,1); // noise volume before reverb
    // };
    // sig = NoiseVol.ar(sig, noiseLev); // noise volume before reverb
    // sig = Distortion.ar(sig, dist);

    Out.ar(outBus, sig); // send it out
  }).send(parent.server);

  SynthDef(\spat_8ch, {|outBus, inBus, rotSpd = 0.1|
    var sig, lev;
    sig = In.ar(inBus, 8); // signal in
    sig = SplayAz.ar(4, sig, spread: 1, level: 1, width: LFNoise1.kr(0.01).range(2,3), center: 1, orientation: LFNoise1.kr(rotSpd).range(0,7));
    // sig = sig.collect{|chan| Pan2.ar(chan, LFNoise1.kr(0.01).range(-1, 0.5))}; // collect them into pairs
    // sig = [
    //   // lower ring
    //   sig[0][0],sig[1][0],sig[2][0],sig[3][0],sig[4][0],sig[5][0],sig[6][0],sig[7][0],
    //   // upper ring
    //   sig[0][1],sig[1][1],sig[2][1],sig[3][1],sig[4][1],sig[5][1],sig[6][1],sig[7][1]
    // ];
    // sig = NoiseVol.ar(sig, lev); // put noise volume here to be on each speaker??? Could be more interesting
    Out.ar(outBus, sig);
  }).send(parent.server);

}
