{|parent|

  SynthDef(\sectionPipe, {|inBus, outBus, fader, envBuff, envBuffSize, start, end, pause = 0|
    var sig, env;
    sig = In.ar(inBus, 16); // 16 channels in
    fader = fader.lag2(10); // 10 second lag (see Routine in updateVisitors)
    fader = fader.linlin(start, end, 0, envBuffSize).clip(0,envBuffSize); // convert shit; clip it before passing
    env = IndexL.kr(envBuff, fader).lag2; // get our current amplitude and smooth it a bit
    Out.ar(outBus, sig*env);
    PauseSelf.kr(pause);
  }).send(parent.server);

  SynthDef(\table_LFO, {|outBus, table, speed|
    var sig, indexer;
    indexer = LFTri.kr(speed, iphase: Rand(0,4), mul: 500, add: 500); // a triangle wave to index into the table with an initial phase offset
    sig = IndexL.kr(table, indexer); // read into the table
    Out.kr(outBus, sig); // write it to the bus
  }).send(parent.server);

  SynthDef(\section_LFO, {|outBus, speed, pause = 0|
    var trig, val;
    val = LFNoise1.kr(speed).range(0,1);
    // PauseSelf.kr(pause);
    Out.kr(outBus, val);
  }).send(parent.server);

  SynthDef(\reverb, {|inBus, outBus, impulseBuffs = #[0,0], initDel = 0.02, dry = 0.5, wet = 0.5, leak = 0.01, hp = 250|
    var sig, rev, leakSig;
    sig = In.ar(inBus, 16); // 16 channels
    rev = DelayN.ar(sig, (initDel+Rand(0.0,0.01) ! 16), initDel+0.01); // initial delay
    leakSig = Mix(rev)*leak; // a little bit of everything for each channel, regardless of position
    // individual reverbs on each channel
    rev = [
      PartConv.ar(rev[0]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[1]+leakSig, 4096, impulseBuffs[1], 0.707),
      PartConv.ar(rev[2]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[3]+leakSig, 4096, impulseBuffs[1], 0.707),
      PartConv.ar(rev[4]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[5]+leakSig, 4096, impulseBuffs[1], 0.707),
      PartConv.ar(rev[6]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[7]+leakSig, 4096, impulseBuffs[1], 0.707),
      PartConv.ar(rev[8]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[9]+leakSig, 4096, impulseBuffs[1], 0.707),
      PartConv.ar(rev[10]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[11]+leakSig, 4096, impulseBuffs[1], 0.707),
      PartConv.ar(rev[12]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[13]+leakSig, 4096, impulseBuffs[1], 0.707),
      PartConv.ar(rev[14]+leakSig, 4096, impulseBuffs[0], 0.707),
      PartConv.ar(rev[15]+leakSig, 4096, impulseBuffs[1], 0.707),
    ];
    // subRev = PartConv.ar(rev.sum*0.0625, 4098, impulseBuffs[1], 0.707); // subwoofer reverb

    rev = HPF.ar(rev, hp); // highpass
    rev = CompanderD.ar(rev, 0.707, 1, 0.333); // compress it just to be safe
    Out.ar(outBus, (rev*wet)+(sig*dry)); // send it out
    // OutBus.ar(subBus, subRev*wet); // subwoofer reverb out
  }).send(parent.server);

  SynthDef(\mainPipe, {|inBus, outBus, subBus, amp = 0.2|
    var sig, subSig;
    sig = In.ar(inBus, 16); // 16 channels in
    sig = BAllPass.ar(sig, (Rand(1000, 10000) ! 16), 0.8); // change the phases of each speaker
    subSig = LPF.ar(Mix(sig)*0.0625*amp, 50); // lowpass the subwoofer signal
    Out.ar(outBus, HPF.ar(sig*amp, 50)); // hipass and send it out
  }).send(parent.server);

  ////////////////////////////////
  /*
    4-channel synths
  */
  ////////////////////////////////

  SynthDef(\playFile_4ch, {|outBus = 0, buff, envBuff, envBuffSize, pos, start = 0, end = 1, pause = 0|
    var sig, env;
    sig = VDiskIn.ar(4, buff, BufRateScale.kr(buff), loop: 1);
    pos = pos.linlin(start, end, 0, envBuffSize).clip(0,envBuffSize); // convert stuff; clip it before passing
    env = IndexL.kr(envBuff, pos.lag2(1)); // get our current amplitude and smooth it a bit
    PauseSelf.kr(pause);
    sig = sig*env; // multiply
    Out.ar(outBus, sig);
  }).send(parent.server);

  // simple processing: noise volume, distortion, delay(?), etc. No reverb.
  SynthDef(\fxSynth_4ch, {|inBus, outBus, noiseLev, dryWetMix = 0.5, pause = 0|
    var sig;
    sig = In.ar(inBus, 4); // signal in
    // sig = NoiseVol.ar(sig, noiseLev); // noise volume before reverb
    // sig = Distortion.ar(sig, dist);

    PauseSelf.kr(pause);
    Out.ar(outBus, sig); // send it out
  }).send(parent.server);

  SynthDef(\VBAP_4ch, {|outBus, inBus, vbapBuff, aziSpeed = 0.01, eleSpeed = 0.01, spread = 50, pause = 1|
    var sig, azi, ele;
    PauseSelf.kr(pause);
    sig = In.ar(inBus, 4); // signal in
    // -180/+180
    azi = [
      LFNoise1.kr(aziSpeed).range(-45,45),
      LFNoise1.kr(aziSpeed).range(45,135),
      LFNoise1.kr(aziSpeed).range(-135,135),
      LFNoise1.kr(aziSpeed).range(-135,-45)
    ];
    azi = azi + LFNoise1.kr(aziSpeed*0.33).range(-180,180); // rotate the signal slowly
    azi = azi.collect{|ugen| ugen.circleRamp};
    // essentially from -90 to something like -30 on one side to the opposite on the other
    ele = 4.collect{LFNoise1.kr(eleSpeed).range(0,30).circleRamp(-90,30)};
    sig = VBAP.ar(16, sig, vbapBuff, azi, ele, spread.lag2); // spatialize me
    sig = Mix(sig); // mix it down
    // sig = NoiseVol.ar(sig, lev); // put noise volume here to be on each speaker??? Could be more interesting
    Out.ar(outBus, sig);
  }).send(parent.server);

}
