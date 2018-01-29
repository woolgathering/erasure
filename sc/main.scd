(
var parent;

parent = (); // an empty dict
~parent = parent; // capture it in the global environment so we can interact with it later
parent.thisDir = "/home/roger/Documents/jacob/pieces/erasure"; // this directory
parent.server = Server.default; // to make sure all things are correct
parent.demoMode = true; // demo mode to not read from sensors?
parent.freeables = List.new(0); // an emtpy list for things that can be freed
parent.spat = File.include(parent.thisDir++"/sc/dicts/vbapSpat.scd", parent); // compile and evaluate the spat diction.
parent.hist = File.include(parent.thisDir++"/sc/dicts/hist.scd", parent); // compile and evaluate the hist dictionary
parent.vis = File.include(parent.thisDir++"/sc/dicts/vis.scd", parent); // compile and evaluate the visual dictionary
parent.timer = DayTimer.(\erasure); // a DayTimer for the installation

parent.startup = File.include(parent.thisDir++"/sc/funcs/startup.scd"); // function that starts the piece. Execute after everything is loaded.
parent.maintainence = File.include(parent.thisDir++"/sc/funcs/maintainence.scd"); // function that scheudles the events for the day and does maintainence, evaluated at midnight
parent.updateVisitors = File.include(parent.thisDir++"/sc/funcs/updateVisitors.scd"); // function that actually updates the stuff in the work
parent.delineateSections = File.include(parent.thisDir++"/sc/funcs/delineateSections.scd"); // function that figures out where to break the sections when panning through episodes/sections
parent.makeSection = File.include(parent.thisDir++"/sc/funcs/makeSection.scd"); // function that makes the sections
parent.prepareReverb = File.include(parent.thisDir++"/sc/funcs/prepareReverb.scd"); // function to prepare the reverb
parent.demoPattern = File.include(parent.thisDir++"/sc/funcs/demoMode.scd"); // get the demo mode pattern

// installation status functions
parent.sendAlert = File.include(parent.thisDir++"/sc/funcs/sendAlert.scd"); // send an alart if broken
parent.sendEmail = File.include(parent.thisDir++"/sc/funcs/sendEmail.scd"); // send an email with information
parent.doChecks = File.include(parent.thisDir++"/sc/funcs/doChecks.scd"); // check to make sure everything is still functioning as it should

// load all the synthdefs in the /sc/synths/ directory
(parent.thisDir++"/sc/synths/*.scd").pathMatch.do{|path|
  File.include(path, parent); // evaluate the file; no need for return
};

parent.busses = (
  mainOut: Bus.audio(parent.server, 16),
  rev: Bus.audio(parent.server, 16),
  volume: Bus.control(parent.server, 1),
  sectionFader: Bus.control(parent.server, 1), // fader for the sections
);

parent.groups = (
  sections: Group.new(parent.server, \addToHead),
  revAndOut: Group.after(parent.groups.sections)
);

/////// debugging ///////
File.include(parent.thisDir++"/sc/funcs/debug.scd").(parent, level: 0, interval: 15); // start the debug function
/////////////////////////

////////
/*
  Start the piece!
*/
////////
fork {
  // actually prepare the reverb
  parent.prepareReverb(parent, parent.thisDir++"/sound/ir/MYPATH.wav"); // prepare the reverb

  // run the startup function after reverb since it starts the reverb synth
  parent.startup.(parent);

  // make the sections
  parent.sections = (); // an empty dictionary
  5.do{|i|
    var sectionName, episodeFiles, thisSection;
    sectionName = "section%".format(i+1).asSymbol; // get the name
    episodeFiles = (parent.thisDir++"/sound/%/*.wav".format(sectionName)).pathMatch; // get the directory
    thisSection = parent.makeSection(episodeFiles, overlap: 0.25, start: i+1, end: i+2); // default arguments. Make sure start and end make sense!
    parent.sections.put(sectionName, thisSection); // remember this section
  };

  // get the number of visitors and set the thing in motion. This also occurs every 10 minutes on the minute but appears here since we can't be sure we will start the work on the minute
  parent.updateVisitors;

}

)
