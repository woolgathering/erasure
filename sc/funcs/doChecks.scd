// doChecks
{|parent|
  /*
    Function to run checks on different aspects of the system. Needs to check:
      - audio: is audio still running? Is the server still running?
      - visuals: are we still connected to the visuals?
      - vistor sensor: are we still talking to the device that counts visitors?
  */

  var errorMsg, good, server;
  good = true; // true if everything is okay, false if not. Default to true.
  server = parent.server; // remember the server
  errorMsg = "ERROR!!\n\n"; // a string to start
  // checks here...

  if(parent.server.unresponsive) {
    good = false; // it's not good.
    errorMsg = errorMsg ++ "\tServer is no longer running! ::: %\n\n".format(Date.getDate.stamp);
  };

  // check the visuals

  // check the sensor

  [good, errorMsg]; // return an array
}
