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

  // given a sectionFader position, pause the groups appropriately:
  fork {
    case
      {faderVal<2.5} {parent.pauseGroups([1,1,0,0,0])}
      {(faderVal>2.5) and: (faderVal<3.5)} {parent.pauseGroups([0,1,1,0,0])}
      {(faderVal>3.5) and: (faderVal<4.5)} {parent.pauseGroups([0,1,1,0,0])}
      {faderVal>4.5} {parent.pauseGroups([0,1,1,0,0])};
  };

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
