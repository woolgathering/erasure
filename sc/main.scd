(
var parent;

parent = (); // an empty dict
parent.thisDir = "/home/roger/Documents/jacob/pieces/erasure"; // this directory
parent.hist = File.include(parent.thisDir++"/sc/hist.scd"); // set it
parent.timer = DayTimer.(\erasure); // a DayTimer for the installation
parent.server = Server.default; // to make sure all things are correct

parent.startup = File.include(parent.thisDir++"/sc/funcs/startup.scd"); // function that starts the piece. Execute after everything is loaded.
parent.maintainence = File.include(parent.thisDir++"/sc/funcs/maintainence.scd"); // function that scheudles the events for the day and does maintainence, evaluated at midnight
parent.updateVisitors = File.include(parent.thisDir++"/sc/funcs/updateVisitors.scd"); // function that actually updates the stuff in the work
parent.delineateSections = File.include(parent.thisDir++"/sc/funcs/delineateSections.scd"); // function that figures out where to break the sections when panning through episodes/sections
parent.makeSection = File.include(parent.thisDir++"/sc/funcs/makeSection.scd"); // function that makes the sections
// parent.prepareReverb = File.include(parent.thisDir++"/sc/funcs/prepareReverb.scd"); // function to prepare the reverbs

// installation status functions
parent.sendAlert = File.include(parent.thisDir++"/sc/funcs/sendAlert.scd"); // send an alart if broken
parent.sendEmail = File.include(parent.thisDir++"/sc/funcs/sendEmail.scd"); // send an email with information
parent.doChecks = File.include(parent.thisDir++"/sc/funcs/doChecks.scd"); // check to make sure everything is still functioning as it should

File.include(parent.thisDir++"/sc/synths/synths.scd"); // load the synths
parent.busses = (
  mainOut: Bus.audio(parent.server, 4),
  rev: Bus.audio(parent.server, 4),
  volume: Bus.control(parent.server, 1),
  sectionFader: Bus.control(parent.server, 1), // fader for the sections
);

// somewhere here load the impulse response for the reverb?
parent.prepareReverb = File.include(parent.thisDir++"/sc/funcs/prepareReverb.scd"); // load the func to load impulse responses

File.include(parent.thisDir++"/sc/funcs/debug.scd").(parent, level: 0, interval: 15); // start the debug function


fork {
  // actually prepare the reverb
  parent.prepareReverb(parent, parent.thisDir++"/sound/ir/MYPATH.wav"); // prepare the reverb

  // prepare the history
  parent.hist = parent.hist(parent); // evaluate the function and set the environment (do it in line 6?)

  // make the sections
  parent.sections = ();
  5.do{|i|
    var sectionName, episodeFiles, thisSection;
    sectionName = "section%".format(i+1).asSymbol; // get the name
    episodeFiles = (parent.thisDir++"/sound/%/*.wav".format(sectionName)).pathMatch; // get the directory
    thisSection = parent.makeSection(episodeFiles, overlap: 0.25, start: i+1, end: i+2); // default arguments. Make sure start and end make sense!
    parent.sections.put(sectionName, thisSection); // remember this section
  };

  // get the number of visitors and set the thing in motion. This also occurs every 10 minutes on the minute but appears here since we can't be sure we will start the work on the minute
  parent.updateVisitors;

  // put inside a task? (PLACEHOLDER:: MAKE IT DYNAMIC) Maybe get the divisions of the sections dynamically and work from there?
  // loop {
  //   case
  //     {pos < 0.2} {parent.pauseGroups([1,1,0,0,0])} // run only the first two groups
  //     {(pos>0.2) and: (pos<0.4)} {parent.pauseGroups([0,1,1,0,0])} // run only the first two groups
  //     {(pos>0.35) and: (pos<0.6)} {parent.pauseGroups([0,0,1,1,0])}; // run only the first two groups
  //     // etc...
  //
  //     30.wait; // run every 30 seconds
  // }

}

)
