////////////////////////////////
/*
  Sensor dictionary
  Contains:
    - OSC funcs that communicate with the Raspberry Pi
*/
////////////////////////////////
{|parent|
  var sensor = ();

  sensor.currentCount = 0; // default to 0
  sensor.server = NetAddr("127.0.0.1", 8000); // some random address for now

  // get the current count from the sensor module
  sensor.getCount = OSCFunc({|msg,time|
      // set sensor.currentCount to whatever it is that our sensor module is reading as the current
      // sensor.currentCount = msg[0]; // or something like that. Make sure it's an integer.
    },
  '/tr', sensor.server.addr);
  parent.freeables.add(sensor.getCurrent); // add this OSC func to freeables

  // reset the sensor count in the sensor module (happens at midnight)
  // THIS HAPPENS IN maintainence.scd!!

}
