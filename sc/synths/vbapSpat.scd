{|parent|

  var spat;
  spat = ();
  parent.spat = spat; // take it to the top

  // place holder
  spat.spkrArray = VBAPSpeakerArray(3, [[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90]]);
  spat.buff = spat.spkrArray.loadToBuffer(parent.server); // load the speaker array to a buffer
  "Loaded VBAP with % speakers\n".postf(spat.spkrArray.numSpeakers); // tell us how many speakers we're running

  // spatSynths
  SynthDef(\VBAP_4ch, {|outBus, inBus, vbapBuff, aziSpeed = 0.01, eleSpeed = 0.01, spread = 50|
    var sig, azi, ele;
    sig = In.ar(inBus, 4); // signal in
    sig = HPF.ar(sig, 60); // hipass
    // -180/+180
    azi = [LFNoise1.kr(aziSpeed).range(-45,45), LFNoise1.kr(aziSpeed).range(45,135), LFNoise1.kr(aziSpeed).range(-135,135), LFNoise1.kr(aziSpeed).range(-135,-45)];
    azi = azi + LFNoise1.kr(aziSpeed*0.1).range(-180,180); // rotate the signal slowly
    azi = azi.circleRamp; // make wrapping more real
    // essentially from -90 to something like -30 on one side to the opposite on the other
    ele = [LFNoise1.kr(eleSpeed).range(30,90).circleRamp(-90,-30) ! 4]; // not sure if this is right
    sig = VBAP(16, sig, vbapBuff, azi, ele, spread.lag2); // spatialize me
    OutBus.ar(outBus, sig);
  }).send(s);

  SynthDef(\VBAP_8ch, {|outBus, inBus, vbapBuff, aziSpeed = 0.01, eleSpeed = 0.01, spread = 50|
    var sig, azi, ele;
    sig = In.ar(inBus, 8); // signal in
    sig = HPF.ar(sig, 60); // hipass
    // -180/+180
    azi = [LFNoise1.kr(aziSpeed).range(-22.5,22.5), LFNoise1.kr(aziSpeed).range(22.5,67.5), LFNoise1.kr(aziSpeed).range(67.5,112.5), LFNoise1.kr(aziSpeed).range(112.5,157.5), LFNoise1.kr(aziSpeed).range(-157.5,157.5), LFNoise1.kr(aziSpeed).range(-157.5,-112.5), LFNoise1.kr(aziSpeed).range(-112.5,-67,5), LFNoise1.kr(aziSpeed).range(-67.5,-22.5)];
    azi = azi + LFNoise1.kr(aziSpeed*0.1).range(-180,180); // rotate the signal slowly
    azi = azi.circleRamp; // make wrapping more real
    // essentially from -90 to something like -30 on one side to the opposite on the other
    ele = [LFNoise1.kr(eleSpeed).range(30,90).circleRamp(-90,-30) ! 8]; // not sure if this is right
    sig = VBAP(16, sig, vbapBuff, azi, ele, spread.lag2); // spatialize me
    OutBus.ar(outBus, sig);
  }).send(s);

}
