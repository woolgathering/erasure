// startup func
// function that initializes the piece and creates the functions that run on a timer
{|parent|
  var hist, good, errorMsg;
  hist = parent.hist; // make life easier
  hist.tmpArray = Array.fill(144, 0); // a new temporary array (this will be made anew every day)
  parent.timer = DayTimer(\mainLoop); // make a main timer that we'll put everything in

  // this runs every 10 minutes to update the 'historical record'
  parent.timer.putDate(\checkStatus,
    {|date| #[0,10,20,30,40,50].includes(date.minute)}, // true every 10 minutes
    {
      parent.updateVisitors; // run the funtion that updates everything
      // hist.getCurrentCount; // get the current number of vistors and remember it
      # good, errorMsg = parent.doChecks; // check to make sure we're still talking to the visuals and the sensor
      if(good.not) {
        parent.sendAlert(errorMsg); // if something is no good, tell me that we're broken
      };
    }
  );

  // run this every day at midnight
  parent.timer.putDate(\maintainence,
    {|date| (date.hour+date.minute+date.second)==0}, // true if it's midnight
    parent.maintainence; // run the maintainence function
  );

  // do this every 30 seconds instead of 10 minutes inside updateVisitors()
  parent.timer.putDate(\pauseGroups,
    {|date| #[0,30].includes(date.second)}, // every 30 seconds
    {
      // given a sectionFader position, pause the groups appropriately:
      case
        {faderVal<2.5} {parent.pauseGroups([1,1,0,0,0])}
        {(faderVal>2.5) and: (faderVal<3.5)} {parent.pauseGroups([0,1,1,0,0])}
        {(faderVal>3.5) and: (faderVal<4.5)} {parent.pauseGroups([0,1,1,0,0])}
        {faderVal>4.5} {parent.pauseGroups([0,1,1,0,0])};
    }
  );

}
