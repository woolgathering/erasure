// every 10 minutes
{|parent|
  var hist, good, errorMsg, visuals, numVistors;

  hist = parent.hist; // make life easier
  visuals = parent.visuals;
  // get the current number of people in the space and save it to our temporary array
  hist.tmpArray[(d.hour*6)+(d.minute*0.1)] = parent.sensor.getCurrent; // <------- fucntion does not yet exist!
  numVistors = parent.sensor.getCurrent; // remember this value


  // down here, do calculations to send information to the visuals and adjust the sound
  // this is vital!!!

  // visuals.
}
