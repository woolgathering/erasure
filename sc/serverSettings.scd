/////////////////////////////////
/*
  Server Settings

  Change server settings here. This file is evaluated in main.scd before anything else.
  If using OSX or something other than Linux, ensure you don't try to use supernova.
*/
/////////////////////////////////
{|parent|
  var server = parent.server;

  Platform.case(
    \osx, {
      // Server.supernova; // DiskIn doesn't work with supernova?? Also, nodes come in out of order even if order is explicitly given
      server.options.device = ServerOptions.devices[2]; // use the RME fireface
    },
    \linux, {
      // Server.supernova; // use supernova (Linux only)
    },
    \windows, {
			server.options.outDevice = "MME : Analog out 01-08 (AudioFire 12)";
			// server.options.outDevice = nil;
    }
  );
  server.options.numOutputBusChannels = 12; // 16 output (16.2). Subs are routed externally
  server.options.numInputBusChannels = 1; // no input
  // server.options.inputStreamsEnabled = "0"; // no input
  server.options.memSize = 2.pow(16); // lots of memory; don't get cheap on me
  server.options.sampleRate = 48000; // 48k
  server.options.memoryLocking = false; // locking memory is a good thing?
  server.options.numAudioBusChannels = 2048; // default value ready to be changed (double)
  server.options.maxSynthDefs = 4096; // quadruple as large as default
  server.options.maxNodes = 4096; // quadruple
  server.options.numWireBufs = 128; // double
  server.options.loadDefs = false; // we have everything we need here
  server.options.threads = nil; // default to 1 per CPU on supernovas
}
