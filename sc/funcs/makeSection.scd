// start section
{|parent, episodeFiles, overlap = 0.25, secIdx = 0|

  /*
  Start a section with composite episodes. Make everything necessary, including buffers, busses, groups, etc. Currently divides episodes evenly in the section
  */

  var server, sectionDict, groups, busses, buffers, episodes, divisions, sectionFader, pipe, lfoTable, cond, secEnvelope, start, end;

  sectionDict = (); // an empty dictionary for this stuff
  episodes = (); // an empty dict for the episodes
  server = parent.server; // get the server
  cond = false; // condition to wait for the section to finish building before moving on
  start = secIdx + 1; // set the start
  end = secIdx + 2; // set the end


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
  divisions = parent.delineateSections(episodeFiles.size, overlap*2);

  // add the previous things to freeables
  parent.freeables.addAll(busses);
  parent.freeables.addAll(groups);

  // actually make the section
  fork {
    // move through the episodes in a section
    sectionFader = Synth(\section_LFO,
      [outBus: busses.episodeFader, speed: rrand(600,700).reciprocal, pause: 1],
      target: groups.master, addAction: \addToHead
    );

    // make the synths, buffers, etc and stick them in a dictionary
    // note that each synth is particular to a number of channels and that the symbol is created on the fly
    episodeFiles.collect{|path, i|
      var player, fx, spat, buffer, sf, numChannels, fxBus, spatBus, thisEpisode, episodeName, envelope, dur;
      episodeName = "episode%".format(i+1).asSymbol; // get a symbolic name
      sf = SoundFile.openRead(path); // open as a soundfile
      if(sf.isNil) {"% failed to open!!".format(path).error}; // tell us if it failed
      numChannels = sf.numChannels; // read into number of channels
      dur = sf.duration; // get the duration
      sf.close; // close the soundfile since we have what we need
      buffer = Buffer.cueSoundFile(server, path, numChannels: numChannels, bufferSize: 131072); // read the file and prepare for reading from disk
      server.sync; // wait
      fxBus = Bus.audio(server, numChannels); // a bus for this particular episode's processing
      spatBus = Bus.audio(server, numChannels); // a bus for spatailization
      server.sync; // wait
      parent.freeables.addAll([buffer,fxBus, spatBus]); // add this stuff to freeables
      switch (i) // choose the correct envelope
        {0} {envelope = parent.envs.firstHalfTable} // when it's the first episode
        {episodeFiles.size-1} {envelope = parent.envs.lastHalfTable} // when it's the last episode
        {envelope = parent.envs.table}; // default
      1.wait; // just to be sure

      // set the player
      player = Synth("playFile_%ch".format(numChannels).asSymbol,
        [
          outBus: fxBus, buff: buffer, envBuff: envelope,
          envBuffSize: envelope.numFrames, pos: busses.episodeFader.asMap,
          start: divisions[i][0], end: divisions[i][1], dur: dur
        ], // default to paused
        target: groups.players, addAction: \addToTail
      );
      server.sync; // wait for everything

      // set the processing
      fx = Synth("fxSynth_%ch".format(numChannels).asSymbol,
        [
          inBus: fxBus, outBus: spatBus, noiseLev: 0, dryWetMix: 0.5, distort: 0
        ],
        target: groups.fx, addAction: \addToHead
      );
      server.sync;

      // spatialize and send it out, braj. Initial speed is between 30 and 45 seconds of movement, spread varies depending on numChannels: the more channels there are, the lower the spread.
      spat = Synth("spat_%ch".format(numChannels).asSymbol,
        [inBus: spatBus, outBus: busses.pipeBus, rotSpd: 180.reciprocal],
        target: groups.spat, addAction: \addToHead
      );

      // put it all together
      thisEpisode = (player: player, fx: fx, spat: spat, buffer: buffer, spatBus: spatBus, fxBus: fxBus);
      episodes.put(episodeName, thisEpisode); // remember it
      if(i==4) {cond = true};
    };
  };

  // wait for the above to finish
  // while{cond.not} {0.05.wait};

  // a synth that pipes everything to the main reverb (to control overall fades between sections)
  pipe = Synth(\sectionPipe,
    [
      inBus: busses.pipeBus, outBus: parent.busses.rev, fader: parent.busses.sectionFader.asMap,
      envBuff: parent.envs.table, envBuffSize: parent.envs.table.numFrames, start: start-overlap, end: end+overlap
    ],
    target: groups.master, addAction: \addToTail
  );

  server.sync;
  sectionDict = (groups: groups, busses: busses, episodes: episodes, divisions: divisions, pipe: pipe);
  sectionDict; // return sectionDict
}
