(
var parent;
// parent = (); // an empty dict
parent = ~parent; // capture it in the global environment so we can interact with it later
parent.freeables = List.new(0); // an emtpy list for things that can be freed
parent.initRun = true; // to correctly set the starting section
parent.hist = File.include(parent.thisDir++"/sc/dicts/hist.scd", parent); // compile and evaluate the hist dictionary
parent.vis = File.include(parent.thisDir++"/sc/dicts/vis.scd", parent); // compile and evaluate the visual dictionary
parent.timer = DayTimer(\erasure); // a DayTimer for the installation

parent.startup = File.include(parent.thisDir++"/sc/funcs/startup.scd"); // function that starts the piece. Execute after everything is loaded.
parent.maintainence = File.include(parent.thisDir++"/sc/funcs/maintainence.scd"); // function that scheudles the events for the day and does maintainence, evaluated at midnight
parent.updateVisitors = File.include(parent.thisDir++"/sc/funcs/updateVisitors.scd"); // function that actually updates the stuff in the work
parent.delineateSections = File.include(parent.thisDir++"/sc/funcs/delineateSections.scd"); // function that figures out where to break the sections when panning through episodes/sections
parent.makeSection = File.include(parent.thisDir++"/sc/funcs/makeSection.scd"); // function that makes the sections
parent.prepareReverb = File.include(parent.thisDir++"/sc/funcs/prepareReverb.scd"); // function to prepare the reverb
parent.demoPattern = File.include(parent.thisDir++"/sc/funcs/demoMode.scd", parent); // get the demo mode pattern
parent.pauseGroups = File.include(parent.thisDir++"/sc/funcs/pauseGroups.scd");

// installation status functions
parent.sendAlert = File.include(parent.thisDir++"/sc/funcs/sendAlert.scd"); // send an alart if broken
parent.sendEmail = File.include(parent.thisDir++"/sc/funcs/sendEmail.scd"); // send an email with information
parent.doChecks = File.include(parent.thisDir++"/sc/funcs/doChecks.scd"); // check to make sure everything is still functioning as it should

parent.busses = (
  mainOut: Bus.audio(parent.server, 4),
  rev: Bus.audio(parent.server, 4),
  volume: Bus.control(parent.server, 1),
  sectionFader: Bus.control(parent.server, 1), // fader for the sections
);

// the two main groups that capture all the sections and the one that captures the reverb and output
parent.groups = ();
parent.groups.put(\sections, Group.new(parent.server, \addToHead));
parent.groups.put(\revAndOut, Group.after(parent.groups.sections));

////////
/*
  Start the piece!
*/
////////
fork {
  // actually prepare the reverb
  parent.prepareReverb(parent.thisDir++"/sound/ir/BatteryBenson.wav"); // prepare the reverb
  parent.server.sync;

  // load all the synthdefs in the /sc/synths/ directory
  File.include(parent.thisDir++"/sc/synths/synths_splayAz.scd", parent); // <---- things only work when loaded from the SAME FILE???? Check if it's a bug..
  parent.server.sync;

  // parent.spat = File.include(parent.thisDir++"/sc/dicts/vbapSpat.scd", parent); // compile and evaluate the spat diction. This needs to stay for now; check commit 3be928c0659144ea87ddd023fe18c426b5570d40 comment
  parent.server.sync;

  // run the startup function after reverb since it starts the reverb synth
  parent.startup(0.1); // startup as 10% overlap between sections
  parent.server.sync;

  // make the sections
  parent.sections = (); // an empty dictionary
  5.do{|i|
    var sectionName, episodeFiles, thisSection;
    "Making Section %...\n".postf(i+1); // tell us what section we're on during boot
    sectionName = "section%".format(i+1).asSymbol; // get the name
    episodeFiles = (parent.thisDir++"/sound/%/*.wav".format(sectionName)).pathMatch; // get the directory
    thisSection = parent.makeSection(episodeFiles.scramble, 0.1, i); // default arguments. Make sure start and end make sense!
    parent.server.sync; // wait for stuff to finish
    parent.sections.put(sectionName, thisSection); // remember this section
  };

  // get the number of visitors and set the thing in motion. This also occurs every 10 minutes on the minute but appears here since we can't be sure we will start the work on the minute
  parent.updateVisitors;
  parent.server.sync;

  // make the CmdPeriod function
  File.include(parent.thisDir++"/sc/funcs/cmdPeriod.scd", parent);

  //////// debugging ///////
  File.include(parent.thisDir++"/sc/funcs/debug.scd").(parent, level: parent.debugLevel, interval: 10); // start the debug function
  /////////////////////////
};

)
