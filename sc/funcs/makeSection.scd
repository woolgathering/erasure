// start section
{|parent, episodes, overlap = 0.25|

  /*
  Start a section with composite episodes. Make everything necessary, including buffers, busses, groups, etc. Currently divides episodes evenly in the section
  */

  var server, thisDict, groups, busses, buffers, synths, divisions;

  thisDict = (); // an empty dictionary for this stuff
  // synths = (); // an empty dictionary for synths (better an array?)
  server = parent.server; // get the server

  busses = ();
  busses.episodeFader = Bus.control(server, 1); // a bus that tells us where we are in the episode lineage
  busses.fxBus = Bus.audio(server, 4); // a bus for processing

  groups = (); // an empty dict for groups
  groups.master = Group.new; // a new group
  groups.players = Group.head(group.master); // a group for the synth players
  groups.fx = Group.tail(group.master); // a group for the processing

  // even divisions. May be more interesting to specify them to be uneven.
  divisions = episodes.size.collect{|val|
    var div = 1/episodes.size;
    val = val+1;
    [(div*(val-1))-(div*overlap*0.5), (div*val)+(div*overlap*0.5)].clip(0,1);
  };

  fork {
    // make the buffers
    buffers = episodes.collect{|path, i|
      Buffer.read(server, path); // need to wait before moving on?
    };
    server.sync;

    // make the synths
    synths = buffers. collect{|buff, i|
      Synth(\playFile,
        [
          outBus: busses.fxBus, buff: buff, envBuff: parent.sineEnv,
          envBuffSize: parent.sineEnv.size, pos: busses.epiFader.asMap,
          start: divisions[i][0], end: divisions[i][1], pause: 1
        ], // default to paused
        target: groups.players, addAction: \addToTail
      );
    server.sync; // wait for everything

    Synth(\fxSynth,
      [
        inBus: busses.fxBus, outBus: parent.busses.mainOut, impulseResp: parent.impulse,
        noiseLev: 0, dryWetMix: 0.5, distort: 0, amp: parent.busses.volume.asMap, 
        pause: 1
      ],
      target: groups.fx, addAction: \addToHead
    );

  };


  };


  thisDict = (groups: groups, busses: busses, synths: synths, buffers: buffers);
  thisDict; // return thisDict
}
