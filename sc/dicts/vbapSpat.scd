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
  spat.spkrArray = VBAPSpeakerArray(3, [
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90],
    [0,-90]
  ]);
  spat.buff = spat.spkrArray.loadToBuffer(parent.server); // load the speaker array to a buffer
  "Loaded VBAP with % speakers\n".postf(spat.spkrArray.numSpeakers); // tell us how many speakers we're running
  // spat.bus = Bus.audio(parent.server, 16); // 16-channel bus for output to main speakers
  parent.freeables.addAll(spat.buff); // bus is not necessary? I think.

  spat; // return the dictionary
}
