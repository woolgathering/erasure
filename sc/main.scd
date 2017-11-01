(
var parent, hist;

parent = (); // an empty dict
hist = File.include("path/to/hist");
parent.hist = hist; // set it
parent.timer = DayTimer.(\erasure); // a DayTimer for the installation

// function that starts the piece. Execute after everything is loaded.
parent.startup = File.include(parent.thisDir++"/sc/funcs/startup.scd");
// function that scheudles the events for the day and does maintainence, evaluated at midnight
parent.maintainence = File.include(parent.thisDir++"/sc/funcs/daily.scd");
parent.checkStatus = File.include(parent.thisDir++"/sc/funcs/updateVisitors.scd");

parent.sendUpdate = {
  // send email with updates here
};

parent.sendAlert = File.include(parent.thisDir++"/sc/funcs/sendAlert.scd");
parent.sendEmail = File.include(parent.thisDir++"/sc/funcs/sendEmail.scd");


)
