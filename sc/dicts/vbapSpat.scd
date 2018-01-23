/////////////////////////////
/*
  Spatialization dictionary and synths. This is setup for 16.1 channel sound. Could be good to
  set speaker positions from main.scd instead of in here.
*/
/////////////////////////////

{|parent|
  var spat;
  spat = (); // an empty Dictionary
  // parent.spat = spat; // take it to the top

  // place holder
  spat.spkrArray = VBAPSpeakerArray(3, [[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90],[0,-90]]);
  spat.buff = spat.spkrArray.loadToBuffer(parent.server); // load the speaker array to a buffer
  "Loaded VBAP with % speakers\n".postf(spat.spkrArray.numSpeakers); // tell us how many speakers we're running
  // spat.bus = Bus.audio(parent.server, 16); // 16-channel bus for output to main speakers
  parent.freeables.addAll(spat.buff); // bus is not necessary? I think.

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

  spat; // return the dictionary
}
