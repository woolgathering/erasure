(
var parent, hist;

parent = (); // an empty dict
hist = File.include("path/to/hist");
parent.hist = hist; // set it
parent.timer = DayTimer.(\erasure); // a DayTimer for the installation

parent.startup = {|dict|
  // function that initializes the piece and schedules events for that day

  hist.tmpArray = Array.fill(144, 0); // a new temporary array


  DayTimer // use this class to schedule events for the day!!
  // check how many people are in the space every 10 minutes, basically
  // that function should also call another function (or set of functions)
  // that tell the server (audio) what to do and send OSC commands to visual program, as well

  // this runs every 10 minutes to update the 'historical record'
  parent.timer.putDate(\getHist,
    {|date| #[0,10,20,30,40,50].includes(date.minute)}, // true every 10 minutes
    {
      hist.getCurrentCount; // get the current number of vistors and remember it
      parent.checkStatus; // check the status of the installation and send an email if anything is blowing up
    }
  );

  // run this every day at midnight
  parent.timer.putDate(\maintainence,
    {|date| (date.hour+date.minute+date.second)==0}, // true if it's midnight
    parent.dailyFunc // run the dailyFunc
  );


};

// function that scheudles the events for the day and does maintainence, evaluated at midnight
parent.dailyFunc = {|dict|
  var yesterday, email;
  // email = // open an emtpy file for writing (or a string?)
  yesterday = Date.getDate.yesterday.format("%a").toLower.asSymbol; // get yesterday and make it a symbol
  hist.countDay(yesterday); // another day has passed
  hist.calc(yesterday, hist.tmpArray); // recalculate the history for yesterday
  hist.tmpArray = Array.fill(144, 0); // reset the array

  // some sort of function that saves the history data as an Archive so we can get it later if something breaks
  // maybe it can also email me some update so I know it hasn't crashed

  DayTimer // use this class to schedule events for the day!!
  // check how many people are in the space every 10 minutes, basically
  // that function should also call another function (or set of functions)
  // that tell the server (audio) what to do and send OSC commands to visual program, as well
};


parent.sendUpdate = {
  // send email with updates here
};




)
