{|parent, path|
  var impulseL, impulseR, specL, specR, buffSize;

  // load the responses from each channel. Echo Thief responses are stereo.
  impulseL = Buffer.readChannel(parent.server, path, channels: [0]);
  impulseR = Buffer.readChannel(parent.server, path, channels: [1]);
  parent.server.sync; // sync

  buffSize = PartConv.calcBufSize(4098, impulseL); // should be the same size for both channels
  specL = Buffer.alloc(parent.server, buffSize, 1);
  specR = Buffer.alloc(parent.server, buffSize, 1);
  specL.preparePartConv(impulseL, 4098);
  specR.preparePartConv(impulseR, 4098);
  parent.server.sync;

  [impulseL, impulseR].do(_.free); // free those buffers. No longer needed.

  parent.revBuffs = (left: specL, right: specR); // return a Dictionary
}
