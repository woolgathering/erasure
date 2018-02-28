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
  var hist, good, errorMsg, vis, now, numVistors, thisIdx, prevVisitors, maxVisitors, visitorRatio, histRatio, recentHistRatio, faderVal;

  hist = parent.hist; // make life easier
  vis = parent.vis; // get the visual dictionary
  now = Date.getDate; // get the date and time now

  // get the current number of people in the space and save it to our temporary array
  numVistors = if(parent.demoMode)
    {parent.demoPattern.next} // if we're using the pattern in demo mode
    {parent.sensor.currentCount}; // else, we're doing it for real so get the value from the sensor
  thisIdx = ((now.hour*12)+(now.minute*0.2)).floor; // the index into the tmpArray, floor corrects for when we start on a minute that is not a multiple of 5
  hist.tmpArray[thisIdx] = numVistors; // set the current number of visitors into the tmpArray

  // get the number of visitors in the last poll if it's not midnight
  prevVisitors = if(thisIdx != 0) {hist.tmpArray[thisIdx-1]} {1}; // set it to 0 if it's midnight

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
  visitorRatio = (numVistors/maxVisitors)*0.4; // make a ratio and multiply it by the weight
  histRatio = hist.at(now.format("%a").toLower.asSymbol)[thisIdx].max(1); // what's our usual visitiation right now?
  histRatio = numVistors/histRatio; // get the ratio of our visitation


  recentHistRatio = numVistors/prevVisitors;

  faderVal = [visitorRatio, histRatio, recentHistRatio].normalizeSum; // make sure they add to one

  faderVal = (faderVal[0]+faderVal[1]+faderVal[2])*5; // weights add to one


  // "
  // thisIdx: %\n
  // numVistors: %\n
  // maxVisitors: %\n
  // visitorRatio: %\n
  // histRatio: %\n
  // recentHistRatio: %\n
  // faderVal: %\n
  // ---------------------\n\n
  // ".postf(thisIdx, numVistors, maxVisitors.round(0.01), visitorRatio.round(0.01), histRatio.round(0.01), recentHistRatio.round(0.01), faderVal.round(0.01));

  if(parent.initRun) {
    parent.oldFaderVal = parent.startSection; // set our starting section IF it's the first time
    parent.initRun = false; // don't do this again
  };

  // FOR TESTING
  faderVal = (parent.faderStream.next * 0.5).clip(1,5); // brownian motion. Divide by two so that we move in increments of 0.5. See line 12 in demoMode.scd

  ////////////////////////////////////
  //    SOUND
  ////////////////////////////////////
  fork {
    var counter = 1, inc; // count the iterations. At 10 seconds, 5 minutes is 30.
    inc = (faderVal-parent.oldFaderVal)/30; // find the increment
    while({counter<=31},
      {
        var vol, rot, val;
        val = (inc*counter)+parent.oldFaderVal;
        val = val.clip(1,5); // low clip
        // maybe add some noise to someVALUE? i.e. +/- 5%?
        parent.busses.sectionFader.set(val * rrand(0.98,1.02)); // set the value every 10 seconds. Lagging happens in the Ugens

        // also set the localized distorion, noiseVol, reverb, rotational speed, etc.


        // and master volume!!!
        vol = parent.arrays.volume.blendAt(val.linlin(1,5,0,2047) * rrand(0.98,1.02)); // index
        parent.busses.volume.set(vol.dbamp); // convert dB to linear amplitude and set it

        rot = parent.arrays.volume.blendAt(val.linlin(1,5,0,2047) * rrand(0.98,1.02)); // index
        parent.groups.sections.set(\rotSpd, rot.reciprocal); // reciporcal and set it

        counter = counter + 1;
        if(counter==30) {parent.oldFaderVal = faderVal};
        10.wait; // wait 10 seconds.
      };
    );
  };

  ////////////////////////////////////
  //    VISUALS
  ////////////////////////////////////
  fork {
    var counter = 1, inc; // count the iterations. At 10 seconds, 5 minutes is 30.
    inc = (faderVal-parent.oldFaderVal)/30; // find the increment
    while({counter<=31},
      {
        var visServer, distort, sliced, localization, val;
        val = (inc*counter)+parent.oldFaderVal;
        val = val.clip(1,5); // low clip
        visServer = parent.vis.server;
        // maybe add some noise to someVALUE? i.e. +/- 5%?
        // send some OSC message to the visuals machine

        // distort = {SOMETHING with faderVal}.value; // or whatever
        // visServer.sendMsg("/erasure/distort", distort, 10); // for instance where distort is the value and 10 is the lag time that's sent to the visual

        // index into the arrays
        distort = vis.visArrays.distort.blendAt((val*rrand(0.98,1.02)).linlin(1,5,0,2047));
        sliced = vis.visArrays.sliced.blendAt((val*rrand(0.98,1.02)).linlin(1,5,0,2047));
        localization = vis.visArrays.localization.blendAt((val*rrand(0.98,1.02)).linlin(1,5,0,2047));

        // print debugging information. To be moved to debug.scd
        if(parent.debugLevel>2) {"distort: %\nsliced: %\nlocal: %\n\n".postf(distort, sliced, localization)};

        // send the values to the visual machine
        vis.server.sendMsg("/erasure/distort", distort, 60); // lag really long to act as a lp filter
        vis.server.sendMsg("/erasure/sliced", sliced, 60);
        vis.server.sendMsg("/erasure/localization", localization, 60);

        counter = counter + 1;
        10.wait; // wait 10 seconds.
      };
    );
  };
}
