{|parent, level = 0, interval = 15|

  /*
    Debugging function. Defaults to off (0) and an interval of 15s.
  */

  var hist, busses, sections, debugFunc, cond;
  hist = parent.hist;
  busses = parent.busses;
  sections = parent.sections;

  if(level>0) {
    // always post this information first
    "DEBUG INFO:\n\n".post;
    Date.getDate.postln; // post the date and time
    sections.keysValuesDo{|sectionName, dict|
      "%:\n".format(sectionName).toUpper.post; // post the section name
      "\tNumber of episodes: %\n".postf(dict.episodes.size); // number of episodes
      "\tDivisions of sections: %\n\n".postf(dict.divisions.round(0.01)); // post the divisions
      dict.episodes.keysValuesDo{|episodeName, dict|
        "\t%:\n".format(episodeName).toUpper.post; // the name of the episodeSection
        "\t\tPath: %\n".postf(dict.buffer.path); // post the path
        if(level>1) { // if it's greater than one, give the NodeID's of the synths
          "\t\tPlayer NodeID: %\n".postf(dict.player.nodeID); // post the nodeID
          "\t\tFx NodeID: %\n".postf(dict.fx.nodeID);  // post the nodeID
        };
      };
    };

    "\n%\n\n".postf(parent.server.queryAllNodes); // this can be posted but not captured

    switch (level)
      {1} {
        debugFunc = {
          "Debugging...\n\n".post; // two newlines
          "Avg. CPU: %\n".postf(parent.server.avgCPU.round(0.1));
          "Peak CPU: %\n".postf(parent.server.peakCPU.round(0.1));
          "---------------------------------\n\n".post;
        };
      }
      {2} {
        debugFunc = {
          cond = false; // set it to false
          "Debugging...\n\n".post; // two newlines
          "Avg. CPU: %\n".postf(parent.server.avgCPU.round(0.1));
          "Peak CPU: %\n\n".postf(parent.server.peakCPU.round(0.1));

          "Parent Bus Positions:\n".post;
          parent.busses.volume.get({|val|
            "\tOverall Amplitude: %\n".postf(val.ampdb); // say what the amplitude is right now
            cond = true;
          });
          while{cond.not} {0.05.wait}; // wait until we've got the value before moving to preserve formatting
          cond = false;
          parent.busses.sectionFader.get({|val|
            "\tSection Fader: %\n".postf(val); // where are we in the sections
            cond = true;
          });
          while{cond.not} {0.05.wait}; // wait until we've got the value before moving to preserve formatting
          "---------------------------------\n\n".post;
        };
      }
      { // default function: level>2
        debugFunc = {
          cond = false; // set it to false
          "Debugging...\n\n".post; // two newlines
          "Avg. CPU: %\n".postf(parent.server.avgCPU.round(0.1));
          "Peak CPU: %\n\n".postf(parent.server.peakCPU.round(0.1));

          "Parent Bus Positions:\n".post;
          parent.busses.volume.get({|val|
            "\tOverall Amplitude: %\n".postf(val.ampdb); // say what the amplitude is right now
            cond = true;
          });
          while{cond.not} {0.05.wait}; // wait until we've got the value before moving to preserve formatting
          cond = false;
          parent.busses.sectionFader.get({|val|
            "\tSection Fader: %\n".postf(val); // where are we in the sections
            cond = true;
          });
          while{cond.not} {0.05.wait}; // wait until we've got the value before moving to preserve formatting

          "Section Info:\n".post;
          // register the nodes to NodeWatcher to check their current status? Could be valuable but will be
          // additional overhead...
          sections.keysValuesDo{|sectionName, dict|
            cond = false; // set it to false
            "%:\n".format(sectionName).toUpper.post; // post the section name
            "\tNumber of episodes: %\n".postf(dict.episodes.size); // number of episodes
            dict.busses.episodeFader.get({|val|
              "\tBus Position: %\n".postf(val);
              cond = true;
            });
            while{cond.not} {0.05.wait}; // wait until we've got the value before moving to preserve formatting
          };
          "---------------------------------\n\n".post;
        };
      }

  };

  Task({
    loop {
      debugFunc.();
      interval.wait; // wait the interval
    };
  }).play;

}
