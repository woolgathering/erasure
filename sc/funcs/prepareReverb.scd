{|parent, path|
  var impulseL, impulseR, specL, specR, buffSize;

  // load the responses from each channel. Echo Thief responses are stereo.
  impulseL = Buffer.readChannel(parent.server, path, channels: [0]);
  impulseR = Buffer.readChannel(parent.server, path, channels: [1]);
  1.wait;
  parent.server.sync;

  buffSize = PartConv.calcBufSize(4096, impulseL); // should be the same size for both channels
  specL = Buffer.alloc(parent.server, buffSize, 1);
  specR = Buffer.alloc(parent.server, buffSize, 1);
  0.2.wait;
  specL.preparePartConv(impulseL, 4096);
  specR.preparePartConv(impulseR, 4096);
  0.2.wait;

  [impulseL, impulseR].do(_.free); // free those buffers. No longer needed.

  parent.revBuffs = (left: specL, right: specL); // return a Dictionary
}
