////////////////////////////////////
/*
  updateVisitors
    This is the main driver of the piece and runs every 5 minutes. This is where we calculate all the values
    that are eventually passed to the sound process AND the visuals. This runs inside of the DayTimer function
    called \checkStatus that is defined inside startup.scd.
*/
////////////////////////////////////

// every 5 minutes
{|parent|
  var hist, good, errorMsg, vis, now, numVistors, thisIdx, prevVisitors;

  hist = parent.hist; // make life easier
  vis = parent.vis; // get the visual dictionary
  now = Date.getDate; // get the date and time now

  // get the current number of people in the space and save it to our temporary array
  numVistors = if(parent.demoMode)
    {parent.demoPattern.next} // if we're using the pattern in demo mode
    {parent.sensor.currentCount}; // else, we're doing it for real so get the value from the sensor

  thisIdx = (now.hour*12)+(now.minute*0.2); // the index into the tmpArray
  hist.tmpArray[thisIdx] = numVistors; // set the current number of visitors into the tmpArray

  // get the number of visitors in the last poll if it's not midnight
  prevVisitors = if(thisIdx != 0) {hist.tmpArray[thisIdx-1]} {0}; // set it to 0 if it's midnight

  /*
    Math magic here to figure out where the sound+video should be given the history and present
    visitation. Also some other stuff? Random processes?

    diff = numVistors - prevVisitors; // get the difference (gives the slope)
    faderVal = SOMETHING COOL

    // faderVal should range between 1 and 5; as such it will indicate which section we're in and
    // how far in between sections we are.
  */

  // get the largest number of visitors ever
  maxVisitors = (hist.sun++hist.mon++hist.tue++hist.wed++hist.thu++hist.fri++hist.sat).maxItem;
  vistorRatio = (numVistors/maxVisitors)*0.4; // make a ratio and multiply it by the weight
  histRatio = hist.at(now.format("%a").toLower.asSymbol)[(d.hour*6)+(d.minute*0.1)]; // what's our usual visitiation right now?
  // histRatio = numVistors/histRatio; // get the ratio of our visitation

  faderVal = (vistorRatio + histRatio + recentHistRatio)*5; // weights add to one

  ////////////////////////////////////
  //    SOUND
  ////////////////////////////////////
  fork {
    var counter = 1, inc; // count the iterations. At 10 seconds, 5 minutes is 30.
    inc = faderVal/30; // find the increment
    while({counter<=31},
      {
        // maybe add some noise to someVALUE? i.e. +/- 5%?
        parent.busses.sectionFader.set(inc*counter); // set the value every 10 seconds.

        // also set the localized distorion, noiseVol, reverb, etc.

        10.wait; // wait 10 seconds.
      };
    );
  };

  ////////////////////////////////////
  //    VISUALS
  ////////////////////////////////////
  fork {
    var counter = 1, inc; // count the iterations. At 10 seconds, 10 minutes is 60.
    inc = visualVal/30; // find the increment
    while({counter<=31},
      {
        var visServer, distort, slice, localization;
        visServer = parent.vis.server;
        // maybe add some noise to someVALUE? i.e. +/- 5%?
        // send some OSC message to the visuals machine

        // distort = {SOMETHING with faderVal}.value; // or whatever
        // visServer.sendMsg("/erasure/distort", distort, 10); // for instance where distort is the value and 10 is the lag time that's sent to the visual machine

        10.wait; // wait 10 seconds.
      };
    );
  };
}
