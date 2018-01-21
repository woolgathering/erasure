// every 10 minutes
{|parent|
  var hist, good, errorMsg, visuals, numVistors;

  hist = parent.hist; // make life easier
  visuals = parent.visuals;
  // get the current number of people in the space and save it to our temporary array
  numVistors = parent.sensor.getCurrent;  // <------- fucntion does not yet exist!
  hist.tmpArray[(d.hour*6)+(d.minute*0.1)] = numVistors;

  /*
    Math magic here to figure out where the sound+video should be given the history and present
    visitation. Also some other stuff? Random processes?

    faderVal = SOMETHING COOL

    // faderVal should range between 1 and 5; as such it will indicate which section we're in and
    // how far in between sections we are.
  */

  // get the largest number of visitors ever
  maxVisitors = (hist.sun++hist.mon++hist.tue++hist.wed++hist.thu++hist.fri++hist.sat).maxItem;
  vistorRatio = (numVistors/maxVisitors)*0.4; // make a ratio and multiply it by the weight
  histRatio = hist.at(THISDAYNAME)[(d.hour*6)+(d.minute*0.1)]; // what's our usual visitiation right now?
  histRatio =

  faderVal = (vistorRatio + histRatio + recentHistRatio)*5; // weights add to one

  ////////////////////////////////////
  //    SOUND
  ////////////////////////////////////
  fork {
    var counter = 1, inc; // count the iterations. At 10 seconds, 10 minutes is 60.
    inc = faderVal/60; // find the increment
    while({counter<=61},
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
    inc = visualVal/60; // find the increment
    while({counter<=61},
      {
        // maybe add some noise to someVALUE? i.e. +/- 5%?
        // send some OSC message to the visuals machine

        10.wait; // wait 10 seconds.
      };
    );
  };
}
