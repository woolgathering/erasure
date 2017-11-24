(
var parent, hist;

parent = (); // an empty dict
hist = File.include("path/to/hist");
parent.hist = hist; // set it
parent.timer = DayTimer.(\erasure); // a DayTimer for the installation
parent.server = Server.default; // to make sure all things are correct

// function that starts the piece. Execute after everything is loaded.
parent.startup = File.include(parent.thisDir++"/sc/funcs/startup.scd");
// function that scheudles the events for the day and does maintainence, evaluated at midnight
parent.maintainence = File.include(parent.thisDir++"/sc/funcs/daily.scd");
parent.checkStatus = File.include(parent.thisDir++"/sc/funcs/updateVisitors.scd");

// installation status functions
parent.sendAlert = File.include(parent.thisDir++"/sc/funcs/sendAlert.scd");
parent.sendEmail = File.include(parent.thisDir++"/sc/funcs/sendEmail.scd");
// parent.doChecks = File.include(parent.thisDir++"/sc/funcs/doChecks.scd"); // check to make sure everything is still functioning as it should

File.include(parent.thisDir++"/sc/synths/synths.scd"); // load the synths
parent.busses = (
  mainOut: Bus.audio(parent.server, 4);
  volume: Bus.control(parent.server, 1)
  // fxBus: Bus.audio(parent.server, 4);
  // revBus: Bus.audio(parent.server, 4);
);

// somewhere here load the impulse response for the reverb?


fork {
  // start the sections

  // get the current number of people (even if it's a placeholder)

  // figure out where we are in the section (will be number from 0-1 that updates every 10 minutes)

  // put inside a task? (PLACEHOLDER:: MAKE IT DYNAMIC)
  // loop {
  //   case
  //     {pos < 0.2} {parent.section1.set(\pause, 0)} // and pause everything else??
  // }

}

)
