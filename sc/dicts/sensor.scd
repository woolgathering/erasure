////////////////////////////////
/*
  Sensor dictionary
  Contains:
    - OSC funcs that communicate with the Raspberry Pi
*/
////////////////////////////////
{|parent|
  var sensor = ();

  parent.sensor = sensor; // set it so we can get it elsewhere
  sensor.currentCount = 0; // default to 0
  // sensor.server = NetAddr("127.0.0.1", 8000); // some random address for now
  sensor.server = NetAddr(parent.raspberryPi.ip, parent.raspberryPi.port); // probably not needed

  // get the current count from the sensor module
  sensor.getCount = OSCFunc({|msg,time|
      // set sensor.currentCount to whatever it is that our sensor module is reading as the current
      sensor.currentCount = msg[0].asInteger; // asInteger returns 0 if it's a string of letters
      "\n\n::::::There are currently % people in the space.\n\tsensor.getCount returned: %\n\n".postf(sensor.currentCount, msg[0]); // tell me what's going on
    },
  '/howmanypeoplearearound', /* sensor.server */);
  parent.freeables.add(sensor.getCurrent); // add this OSC func to freeables

  // reset the sensor count in the sensor module (happens at midnight)
  // THIS HAPPENS IN maintainence.scd!!

}
