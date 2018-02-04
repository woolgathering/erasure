/////////////////////////////////
/*
  Server Settings

  Change server settings here. This file is evaluated in main.scd before anything else.
  If using OSX or something other than Linux, ensure you don't try to use supernova.
*/
/////////////////////////////////
{|parent|
  var server = parent.server;

  Server.scsynth; // use supernova (Linux only)
  server.options.numOutputBusChannels = 17; // 17 output (16.1)
  server.options.numInputBusChannels = 0; // no input
  server.options.memSize = 2.pow(16); // lots of memory; don't get cheap on me
  server.options.sampleRate = 48000; // 48k
  server.options.memoryLocking = true; // locking memory is a good thing?
  server.options.numAudioBusChannels = 1024; // default value ready to be changed
  server.options.maxSynthDefs = 2048; // twice as large as default
  server.options.maxNodes = 2048; // double
  server.options.numWireBufs = 256;
  server.options.loadDefs = false; // we have everything we need here
  server.options.threads = nil; // default to 1 per CPU on supernova
}
