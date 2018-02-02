////////////////////////////////////
/*
  Startup Funcion
  This function creates the functions that run on a timer and the synths that capture all outputs
*/
////////////////////////////////////

{|parent|
  var hist, good, errorMsg;
  parent.synths = (); // an emtpy dictionary for the synths
  hist = parent.hist; // make life easier
  hist.tmpArray = Array.fill(144, 0); // a new temporary array (this will be made anew every day)
  parent.timer = DayTimer(\mainLoop); // make a main timer that we'll put everything in

  // this runs every 5 minutes to update the 'historical record'
  parent.timer.putDate(\checkStatus,
    {|date| #[0,5,10,15,20,25,30,35,40,45,50,55].includes(date.minute)}, // true every 5 minutes
    {
      if(debug>0) {Date.getDate.postln}; // if we're debugging, post the time every 5 minutes
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

  // do this every 30 seconds
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

  ////////////////////////////
  // Start synths through which everything is routed
  ////////////////////////////

  // reverb synth
  parent.synths.reverb = Synth(\reverb,
    [
    inBus: parent.busses.rev, outBus: parent.busses.mainOut, initDel: 0.02, dry: 1, wet: 0, leak: 0.01, hp: 150,
    impulseBuffs: [parent.revBuffs.left, parent.revBuffs.right]
    ],
    target: parent.groups.revAndOut, addAction: \addToHead
  );

  // make the main pipe for the output: THIS GOES TO THE MAINS!!!
  parent.synths.mainPipe = Synth(\mainPipe,
    [inBus: parent.busses.mainOut, outBus: 0, subBus: 16, amp: -3.dbamp],
    target: parent.groups.revAndOut, addAction: \addToTail
  );

}
