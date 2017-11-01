// every 10 minutes
{|parent|
  var hist, good, info, visuals;

  hist = parent.hist; // make life easier
  visuals = parent.visuals;
  // get the current number of people in the space and save it to our temporary array
  hist.tmpArray[(d.hour*6)+(d.minute*0.1)] = parent.sensor.getCurrent;

  # good, info = parent.doChecks; // check to make sure we're still talking to the visuals and the sensor
  if(good.not) {
    parent.sendAlert(info); // if something is no good, tell me that we're broken
  };

  // down here, do calculations to send information to the visuals and adjust the sound

}
