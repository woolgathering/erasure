// startup func
// function that initializes the piece and creates the functions that run on a timer
{|parent|
  var hist;
  hist = parent.hist; // make life easier

  // parent.dailyFunc = File.include("myPath").(parent); 

  // DayTimer // use this class to schedule events for the day!!
  // // check how many people are in the space every 10 minutes, basically
  // // that function should also call another function (or set of functions)
  // // that tell the server (audio) what to do and send OSC commands to visual program, as well

  hist.tmpArray = Array.fill(144, 0); // a new temporary array (this will be made anew every day)

  parent.timer = DayTimer(\mainLoop); // make a main timer that we'll put everything in

  // this runs every 10 minutes to update the 'historical record'
  parent.timer.putDate(\statusCheck,
    {|date| #[0,10,20,30,40,50].includes(date.minute)}, // true every 10 minutes
    {
      hist.getCurrentCount; // get the current number of vistors and remember it
      parent.checkStatus; // check the status of the installation and send an email if anything is blowing up
    }
  });

  // run this every day at midnight
  parent.timer.putDate(\maintainence,
    {|date| (date.hour+date.minute+date.second)==0}, // true if it's midnight
    parent.dailyFunc // run the dailyFunc
  );

}
