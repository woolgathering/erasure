////////////////////////
/*
  Controls and Dictionaries for the Visial Processing.
  Includes:
    - OSC communication with the visuals
    - a dictionary that contains arrays for special trajectories of the visuals
*/
////////////////////////

{|parent|
  var vis, server, oscFuncs, distort, slice, localization, visArrays;
  vis = (); // an empty dictionary for the visuals
  vis.put(\interval, 10); // the default interpolation interval in seconds (see the forked visual routine in updateVisitors() at the bottom)
  oscFuncs = (); // an emtpy dictionary
  server = NetAddr("172.27.2.5", 8338); // IP address and port of visual processing server

  // this might not be necessary. Only if we want a special trajectory.
  visArrays = (
    distort: Object.readArchive(parent.thisDir++"/sc/arrays/distort"),
    slice: Object.readArchive(parent.thisDir++"/sc/arrays/slice"),
    localization: Object.readArchive(parent.thisDir++"/sc/arrays/localization")
  );
  vis.put(\visArrays, visArrays); // add it to the master visual dictionary

  distort = OSCFunc({|msg, time|
      // OSC message in here
    },
  '/tr', server.addr);
  oscFuncs.put(\distort, distort); // put this function in the dictionary

  slice = OSCFunc({|msg, time|
      // OSC message in here
    },
  '/tr', server.addr);
  oscFuncs.put(\slice, slice); // put this function in the dictionary

  localization = OSCFunc({|msg, time|
      // OSC message in here
    },
  '/tr', server.addr);
  oscFuncs.put(\localization, localization); // put this function in the dictionary
  parent.freeables.addAll(oscFuncs); // add all the OSC funcs to freeables

  vis.put(\oscFuncs, oscFuncs); // add the OSC function dictionary to the main vis dict
  vis.put(\server, server); // put the server in the dictionary
  vis; // return the dictionary
}
