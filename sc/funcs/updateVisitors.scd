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
  var hist, good, errorMsg, vis, now, numVistors, thisIdx, prevVisitors, recentHistRatio, faderVal, scaler, day, attributes;

  hist = parent.hist; // make life easier
  vis = parent.vis; // get the visual dictionary
  now = Date.getDate; // get the date and time now
  day = now.format("%a").toLower.asSymbol; // get the name of the day as a symbol
  attributes = Array.fill(5, {0}); // make an array with 0's just in case

  // get the current number of people in the space and save it to our temporary array
  numVistors = if(parent.demoMode)
    {parent.demoPattern.next} // if we're using the pattern in demo mode
    {parent.sensor.currentCount}; // else, we're doing it for real so get the value from the sensor
  if(numVistors.isNil || (numVisitors<0)) {parent.demoPattern.next}; // just in case, check it
  thisIdx = ((now.hour*12)+(now.minute*0.2)).floor; // the index into the tmpArray, floor corrects for when we start on a minute that is not a multiple of 5
  hist.tmpArray[thisIdx] = numVistors; // set the current number of visitors into the tmpArray

  /*
    weight, method of calculation

    0.7, numVisitors
      |
      -----> 0.5, numVistors (scaled between min (0) and max (30))
      -----> 0.2, numVistors/avgVisitors_atThisTime

    0.2, stats
      |
      -----> 0.1, avgVisitors_thisDay / maxVisitors_thisDay
      -----> 0.1, avgVisitors_atThisTime/ avgVisitors_thisDay

    0.1, noise (gauss)
  */
  attributes[0] = (numVistors/30) * 0.5; // scale it
  attributes[1] = (numVistors/hist.at(day)[thisIdx]) * 0.2; // scale it
  attributes[2] = (hist.stats.at(day).avgVisitors / hist.stats.at(day).maxVisitors) * 0.1; // scale it
  attributes[3] = (hist.at(day)[thisIdx] / hist.stats.at(day).avgVisitors) * 0.1; // scale it
  attributes[4] = gauss(0.05, 0.015).clip(0,0.1); // noise

  // the scaler is calculated on the recent history ratio
  // scaler modulates between max (6??) and higher depending on how quickly people file in. The descending rate is constant but the upward rate can be faster.
  prevVisitors = if(thisIdx != 0) {hist.tmpArray[thisIdx-1].max(1)} {1}; // set it to 1 if it's midnight or if it was 0 (to not mess things up below)
  recentHistRatio = numVistors/prevVisitors; // get the ratio
  scaler = recentHistRatio.lincurve(1,3,6,18,-0.75,\max).max(0.1); // scale the ratio
  // scaler = recentHistRatio.linlin(1,3,6,18,\max).max(0.1); // scale it

  // scale the entire thing (ok if attributes.sum is greater than 1 since it's clipped before it's sent out)
  faderVal = attributes.sum * scaler;

  if(debug>0){
    "\n\nAttributes for calculating the faderVal: %\n\n".postf(attributes);
  };

  if(parent.initRun) {
    parent.oldFaderVal = parent.startSection; // set our starting section IF it's the first time
    parent.initRun = false; // don't do this again
  };

  // FOR TESTING
  // faderVal = (parent.faderStream.next * 0.15).clip(0.5,5.5); // brownian motion. Divide by two so that we move in increments of 0.5. See line 12 in demoMode.scd

  ////////////////////////////////////
  //    SOUND
  ////////////////////////////////////
  fork {
    var counter = 1, inc; // count the iterations. At 10 seconds, 5 minutes is 30.
    inc = (faderVal-parent.oldFaderVal)/30; // find the increment
    while({counter<=31},
      {
        var vol, rot, val, rev;
        val = (inc*counter)+parent.oldFaderVal;
        val = val.clip(0.5,6); // clip it
        parent.busses.sectionFader.set((val * rrand(0.98,1.02)).clip(0.5,5.5)); // set the value every 10 seconds. Lagging happens in the Ugens

        // and master volume!!!
        vol = parent.arrays.volume.blendAt(val.linlin(0.5,5.5,0,2047) * rrand(0.98,1.02)); // index
        parent.busses.volume.set(vol.dbamp); // convert dB to linear amplitude and set it

        rot = parent.arrays.rotation.blendAt(val.linlin(0.5,5.5,0,2047) * rrand(0.98,1.02)); // index
        parent.groups.sections.set(\rotSpd, rot.reciprocal); // reciporcal and set it

        rev = parent.arrays.reverb.blendAt(val.linlin(0.5,5.5,0,2047) * rrand(0.98,1.02)); // index
        parent.groups.revAndOut.set(\mix, rev);

        counter = counter + 1;
        if(counter==31) {parent.oldFaderVal = faderVal};
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
        var visServer, distort, sliced, localization, speed, focalLength, val;
        val = (inc*counter)+parent.oldFaderVal;
        val = val.clip(0.5,6); // clip it
        visServer = parent.vis.server;
        // maybe add some noise to someVALUE? i.e. +/- 5%?
        // send some OSC message to the visuals machine

        // distort = {SOMETHING with faderVal}.value; // or whatever
        // visServer.sendMsg("/erasure/distort", distort, 10); // for instance where distort is the value and 10 is the lag time that's sent to the visual

        // index into the arrays
        distort = vis.visArrays.distort.blendAt((val*rrand(0.98,1.02)).linlin(0.5,5.5,0,2047));
        sliced = vis.visArrays.sliced.blendAt((val*rrand(0.98,1.02)).linlin(0.5,5.5,0,2047));
        localization = vis.visArrays.localization.blendAt((val*rrand(0.98,1.02)).linlin(0.5,5.5,0,2047));
        speed = vis.visArrays.speed.blendAt((val*rrand(0.98,1.02)).linlin(0.5,5.5,0,2047));
        focalLength = vis.visArrays.focalLength.blendAt((val*rrand(0.98,1.02)).linlin(0.5,5.5,0,2047));

        // print debugging information. To be moved to debug.scd
        if(parent.debugLevel>0) {"distort: %\nsliced: %\nlocal: %\nspeed: %\nfocal_length: %\n\n".postf(distort, sliced, localization, speed, focalLength)};

        // send the values to the visual machine
        vis.server.sendMsg("/erasure/distort", distort, 180); // lag really long to act as a lp filter
        vis.server.sendMsg("/erasure/sliced", sliced, 180);
        vis.server.sendMsg("/erasure/localization", localization, 180);
        vis.server.sendMsg("/erasure/speed", speed, 30);
        vis.server.sendMsg("/erasure/focal_length", focalLength, 180);

        counter = counter + 1;
        10.wait; // wait 10 seconds.
      };
    );
  };
}
