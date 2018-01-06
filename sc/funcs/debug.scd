{|parent, level = 0, interval = 15|

  /*
    Debugging function. Defaults to off (0) and an interval of 15s.
  */

  var hist, busses, sections, debugFunc;
  hist = parent.hist;
  busses = parent.busses;
  sections = parent.sections;

  if(level>0) {

    // always post this information first
    "DEBUG INFO:\n\n".post;
    sections.keysValuesDo{|sectionName, dict|
      "%:\n".format(sectionName).toUpper.post; // post the section name
      "\tNumber of episodes: %\n".postf(dict.episodes.size); // number of episodes
      "\tDivisions of sections: %\n\n".postf(dict.divisions); // post the divisions
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
          "Avg. CPU: %\n".postf(parent.server.avgCPU);
          "Peak CPU: %\n\n".postf(parent.server.peakCPU);
        };
      }
      {2} {
        debugFunc = {
          "Debugging...\n\n".post; // two newlines
          "Avg. CPU: %\n".postf(parent.server.avgCPU);
          "Peak CPU: %\n\n".postf(parent.server.peakCPU);

          "Parent Bus Positions:\n".post;
          parent.busses.volume.get({|val|
            "\tOverall Amplitude: %\n".postf(val.ampdb); // say what the amplitude is right now
          });
          parent.busses.sectionFader.get({|val|
            "\tSection Fader: %\n".postf(val); // where are we in the sections
          });
        };
      }
      { // default function: level>2
        debugFunc = {
          "Debugging...\n\n".post; // two newlines
          "Avg. CPU: %\n".postf(parent.server.avgCPU);
          "Peak CPU: %\n\n".postf(parent.server.peakCPU);

          "Parent Bus Positions:\n".post;
          parent.busses.volume.get({|val|
            "\tOverall Amplitude: %\n".postf(val.ampdb); // say what the amplitude is right now
          });
          parent.busses.sectionFader.get({|val|
            "\tSection Fader: %\n".postf(val); // where are we in the sections
          });

          "Section Info:\n".post;
          // register the nodes to NodeWatcher to check their current status? Could be valuable but will be
          // additional overhead...
          sections.keysValuesDo{|sectionName, dict|
            "%:\n".format(sectionName).toUpper.post; // post the section name
            "\tNumber of episodes: %\n".postf(dict.episodes.size); // number of episodes
            dict.busses.episodeFader.get({|val|
              "\tBus Position: %\n".postf(val)
            });
          });
        };
      }

  };

  Task({
    loop {
      debugFunc.();
      interval.wait; // wait the interval
    };
  }).run;

}
