// start section
{|parent, episodeFiles, overlap = 0.25, start = 0, end = 1|

  /*
  Start a section with composite episodes. Make everything necessary, including buffers, busses, groups, etc. Currently divides episodes evenly in the section
  */

  var server, thisDict, groups, busses, buffers, episodes, divisions, sectionFader, pipe, lfoTable;

  thisDict = (); // an empty dictionary for this stuff
  episodes = ();
  server = parent.server; // get the server

  busses = (); // an empty dict for busses
  busses.episodeFader = Bus.control(server, 1); // a bus that tells us where we are in the episode lineage
  busses.fxBus = Bus.audio(server, 4); // a bus for processing
  busses.pipeBus = Bus.audio(server, 4); // a bus to pipe out stuff from each episode

  groups = (); // an empty dict for groups
  groups.master = Group.new; // a new group to encapsulate all of the synths for the section
  groups.players = Group.head(groups.master); // a group for the synth players
  groups.fx = Group.tail(groups.master); // a group for the processing

  // even divisions. May be more interesting to specify them to be uneven.
  divisions = parent.delineateSections(episodeFiles.size, overlap);

  // actually make the section
  fork {
    // make our LFO table that we use to fade between different episodes
    // lfoTable = Array.noiseInterpolate(0,1,rrand(19,23),0.1); // a noisey line
    // lfoTable = lfoTable.resamp2(1000); // resample to size 1000
    // lfoTable = Buffer.loadCollection(server, lfoTable); // load it on the server as a buffer
    // server.sync;
    //
    // // make the fader for the sections
    // sectionFader = Synth(\table_LFO,
    //   [outBus: busses.episodeFader, table: lfoTable, speed: rrand(60*60, 90*60).reciprocal],
    //   target: groups.master, addAction: \addToHead
    // );

    // or just this...
    sectionFader = Synth(\section_LFO,
      [outBus: busses.episodeFader, speed: rrand(60*60, 90*60).reciprocal, pause: 1],
      target: groups.master, addAction: \addToHead
    );

    // make the synths, buffers, etc and stick them in a dictionary
    episodeFiles.collect{|path, i|
      var player, fx, buffer, fxBus, thisEpisode, episodeName;
      episodeName = "episode%".format(i+1).asSymbol; // get a symbolic name
      fxBus = Bus.audio(server, 4); // a bus for this particular episode's processing
      buffer = Buffer.read(server, path); // read the file and load it to the server
      server.sync; // wait for it to finish loading

      // set the player
      player = Synth(\playFile,
        [
          outBus: fxBus, buff: buffer, envBuff: parent.sineEnv,
          envBuffSize: parent.sineEnv.size, pos: busses.episodeFader.asMap,
          start: divisions[i][0], end: divisions[i][1], pause: 1
        ], // default to paused
        target: groups.players, addAction: \addToTail
      );
      server.sync; // wait for everything

      // set the processing
      fx = Synth(\fxSynth,
        [
          inBus: fxBus, outBus: busses.pipeBus, impulseResp: parent.impulse,
          noiseLev: 0, dryWetMix: 0.5, distort: 0, amp: parent.busses.volume.asMap,
          pause: 1
        ],
        target: groups.fx, addAction: \addToHead
      );
      server.sync;

      // put it all together
      thisEpisode = (player:  player, fx: fx, buffer: buffer);
      episodes.put(episodeName, thisEpisode); // remember it
    };

  };

  // a synth that pipes everything (to control overall fades between sections)
  pipe = Synth(\sectionPipe,
    [
      inBus: busses.pipeBus, outBus: parent.busses.rev, fader: parent.busses.sectionFader.asMap,
      envBuff: parent.sineEnv, envBuffSize: parent.sineEnv.size, start: start, end: end
    ],
    target: groups.master, addAction: \addToTail
  );


  thisDict = (groups: groups, busses: busses, episodes: episodes, divisions: divisions);
  thisDict; // return thisDict
}
