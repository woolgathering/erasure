/////////////////////////////
/*
  Spatialization dictionary and synths. This is setup for 16.1 channel sound; the subwoofer is not included
  in the VBAPSpeakerArray. Could be good to set speaker positions from main.scd instead of in here.
*/
/////////////////////////////

{|parent|
  var spat;
  spat = (); // an empty Dictionary
  // parent.spat = spat; // take it to the top

  // place holder
  // spat.spkrArray = VBAPSpeakerArray(3, [
  //   // lower ring
  //   [-45,0],
  //   [0,0],
  //   [45,0],
  //   [90,0],
  //   [135,0],
  //   [180,0],
  //   [-135,0],
  //   [-90,0],
  //   // upper ring
  //   [-45,15],
  //   [0,15],
  //   [45,15],
  //   [90,15],
  //   [135,15],
  //   [180,15],
  //   [-135,15],
  //   [-90,15],
  // ]);
  spat.spkrArray = VBAPSpeakerArray(2, [-45,0,45,90,135,180,-135,-90]); // one ring only
  spat.buff = spat.spkrArray.loadToBuffer(parent.server); // load the speaker array to a buffer
  "Loaded VBAP with % speakers\n".postf(spat.spkrArray.numSpeakers); // tell us how many speakers we're running
  // spat.bus = Bus.audio(parent.server, 16); // 16-channel bus for output to main speakers
  parent.freeables.addAll(spat.buff); // bus is not necessary? I think.

  spat; // return the dictionary
}
