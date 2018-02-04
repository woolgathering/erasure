{|parent, level = 0, path|

  /*
    Debugging function. Defaults to off (0) and an interval of 15s.
  */

  var hist, busses, sections, debugFunc, file, iterations, task;
  hist = parent.hist;
  busses = parent.busses;
  sections = parent.sections;
  path = path ? (Path.tmp ++ "erasureDEBUG-" Date.getDate.stamp); // /tmp/erasureDEBUG-DATESTAMP/ if nil
  file = File.open(path, "a+"); // new empty file
  iterations = 5;

  if(level>0) {

    // always write this information first
    file.write("DEBUG INFO:\n\n");
    sections.keysValuesDo{|sectionName, dict|
      file.write("%:\n".format(sectionName).toUpper); // write the section name
      file.write("\tNumber of episodes: %\n".format(dict.episodes.size)); // number of episodes
      file.write("\tDivisions of sections: %\n\n".format(dict.divisions)); // write the divisions
      dict.episodes.keysValuesDo{|episodeName, dict|
        file.write("\t%:\n".format(episodeName).toUpper); // the name of the episodeSection
        file.write("\t\tPath: %\n".format(dict.buffer.path)); // write the path
        if(level>1) { // if it's greater than one, give the NodeID's of the synths
          file.write("\t\tPlayer NodeID: %\n".format(dict.player.nodeID)); // write the nodeID
          file.write("\t\tFx NodeID: %\n".format(dict.fx.nodeID));  // write the nodeID
        };
      };
    };

    file.write("5 second intervals...\n\n"); // tell us what the intervals are

    // file.write("\n%\n\n".format(parent.server.queryAllNodes)); // this can be posted but not captured

    switch (level)
      {1} {
        debugFunc = {
          file.write("Debugging...\n\n"); // two newlines
          file.write("Avg. CPU: %\n".format(parent.server.avgCPU));
          file.write("Peak CPU: %\n".format(parent.server.peakCPU));
          file.write("\n\n"); // two newlines to end
        };
      }
      {2} {
        debugFunc = {
          file.write("Debugging...\n\n"); // two newlines
          file.write("Avg. CPU: %\n".format(parent.server.avgCPU));
          file.write("Peak CPU: %\n\n".format(parent.server.peakCPU));

          file.write("Parent Bus Positions:\n");
          parent.busses.volume.get({|val|
            file.write("\tOverall Amplitude: %\n".format(val.ampdb)); // say what the amplitude is right now
          });
          parent.busses.sectionFader.get({|val|
            file.write("\tSection Fader: %\n".format(val)); // where are we in the sections
          });
          file.write("\n\n"); // two newlines to end
        };
      }
      { // default function: level>2
        debugFunc = {
          file.write("Debugging...\n\n"); // two newlines
          file.write("Avg. CPU: %\n".format(parent.server.avgCPU));
          file.write("Peak CPU: %\n\n".format(parent.server.peakCPU));

          file.write("Parent Bus Positions:\n");
          parent.busses.volume.get({|val|
            file.write("\tOverall Amplitude: %\n".format(val.ampdb)); // say what the amplitude is right now
          });
          parent.busses.sectionFader.get({|val|
            file.write("\tSection Fader: %\n".format(val)); // where are we in the sections
          });

          file.write("Section Info:\n");
          // register the nodes to NodeWatcher to check their current status? Could be valuable but will be
          // additional overhead...
          sections.keysValuesDo{|sectionName, dict|
            file.write("%:\n".format(sectionName).toUpper); // post the section name
            file.write("\tNumber of episodes: %\n".foramt(dict.episodes.size)); // number of episodes
            dict.busses.episodeFader.get({|val|
              file.write("\tBus Position: %\n".format(val));
            });
          });
          file.write("\n\n"); // two newlines to end
        };
      }

    task = Task({
      loop {
        debugFunc.();
        iterations = iterations + 1;
        5.wait; // wait 5 seconds
      };
      while(iterations<10) {0.5.wait} {task.stop; file.close}; // stop the task after 10 iterations
    }).play;
  };

}
