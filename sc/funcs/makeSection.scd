// start section
{|parent, episodeFiles, overlap = 0.25, start = 0, end = 1|

  /*
  Start a section with composite episodes. Make everything necessary, including buffers, busses, groups, etc. Currently divides episodes evenly in the section
  */

  var server, sectionDict, groups, busses, buffers, episodes, divisions, sectionFader, pipe, lfoTable;

  sectionDict = (); // an empty dictionary for this stuff
  episodes = (); // an empty dict for the episodes
  server = parent.server; // get the server

  busses = (); // an empty dict for busses
  busses.episodeFader = Bus.control(server, 1); // a bus that tells us where we are in the episode lineage
  busses.fxBus = Bus.audio(server, 4); // a bus for processing
  busses.pipeBus = Bus.audio(server, 16); // a bus to pipe out stuff from each episode post-spatialization

  groups = (); // an empty dict for groups
  groups.master = Group.tail(parent.groups.sections); // a new group to encapsulate all of the synths for the section
  groups.players = Group.head(groups.master); // a group for the synth players
  groups.fx = Group.tail(groups.master); // a group for the processing
  groups.spat = Group.tail(groups.master); // a group for the spatailization of each (eats lots of CPU??)

  // even divisions. May be more interesting to specify them to be uneven.
  divisions = parent.delineateSections(episodeFiles.size, overlap);

  // add the previous things to freeables
  parent.freeables.addAll(busses);
  parent.freeables.addAll(groups);

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
      [outBus: busses.episodeFader, speed: rrand(600,700).reciprocal, pause: 0],
      target: groups.master, addAction: \addToHead
    );

    // make the synths, buffers, etc and stick them in a dictionary
    // note that each synth is particular to a number of channels and that the symbol is created on the fly
    episodeFiles.collect{|path, i|
      var player, fx, spat, buffer, sf, numChannels, fxBus, spatBus, thisEpisode, episodeName;
      episodeName = "episode%".format(i+1).asSymbol; // get a symbolic name
      sf = SoundFile.openRead(path); // open as a soundfile
      if(sf.isNil) {"% failed to open!!".format(path).error}; // tell us if it failed
      numChannels = sf.numChannels; // read into number of channels
      sf.close; // close the soundfile since we have what we need
      buffer = Buffer.cueSoundFile(server, path, numChannels: numChannels, bufferSize: 32768); // read the file and prepare for reading from disk
      server.sync; // wait
      fxBus = Bus.audio(server, numChannels); // a bus for this particular episode's processing
      spatBus = Bus.audio(server, numChannels); // a bus for spatailization
      server.sync; // wait
      parent.freeables.addAll([buffer,fxBus]); // add this stuff to freeables
      1.wait; // just to be sure

      // set the player
      player = Synth("playFile_%ch".format(numChannels).asSymbol,
        [
          outBus: fxBus, buff: buffer, envBuff: parent.sineEnv,
          envBuffSize: parent.sineEnv.numFrames, pos: busses.episodeFader.asMap,
          start: divisions[i][0], end: divisions[i][1], pause: 0
        ], // default to paused
        target: groups.players, addAction: \addToTail
      );
      server.sync; // wait for everything

      // set the processing
      fx = Synth("fxSynth_%ch".format(numChannels).asSymbol,
        [
          inBus: fxBus, outBus: spatBus, noiseLev: 0, dryWetMix: 0.5, distort: 0, pause: 0
        ],
        target: groups.fx, addAction: \addToHead
      );
      server.sync;

      // spatialize and send it out, braj. Initial speed is between 30 and 45 seconds of movement, spread varies depending on numChannels: the more channels there are, the lower the spread.
      spat = Synth("VBAP_%ch".format(numChannels).asSymbol,
        [
          inBus: spatBus, outBus: busses.pipeBus, vbapBuff: parent.spat.buff.bufnum,
          aziSpeed: rrand(0.0222, 0.0333), eleSpeed: rrand(0.0222, 0.0333),
          spread: numChannels.reciprocal * rrand(150,175), pause: 0
        ],
        target: groups.spat, addAction: \addToHead
      );

      // put it all together
      thisEpisode = (player: player, fx: fx, spat: spat, buffer: buffer, spatBus: spatBus, fxBus: fxBus);
      episodes.put(episodeName, thisEpisode); // remember it
    };
  };

  // a synth that pipes everything to the main reverb (to control overall fades between sections)
  pipe = Synth(\sectionPipe,
    [
      inBus: busses.pipeBus, outBus: parent.busses.rev, fader: parent.busses.sectionFader.asMap,
      envBuff: parent.sineEnv, envBuffSize: parent.sineEnv.numFrames, start: start, end: end
    ],
    target: groups.master, addAction: \addToTail
  );

  server.sync;
  sectionDict = (groups: groups, busses: busses, episodes: episodes, divisions: divisions, pipe: pipe);
  sectionDict; // return sectionDict
}
