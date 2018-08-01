////////////////////////////////////
/*
  Demo Pattern
  Function that runs the visitors on brownian motion instead of reading from the sensor. This is used
  when we're demonstrating the piece instead of letting it run.
*/
////////////////////////////////////

{|parent|
  var stream, fader;
  stream = Pbrown(0,20,2,inf).asStream; // between 0 and 20 people, maximum 2 enter at a time for infinity
  fader = Pbrown(2,22,8,inf).asStream; // fader as a stream. MUST divide by two; done this way so that it moves in increments of 0.5. Line 66 in updateVisitors.scd
  parent.faderStream = fader;
  stream; // return the stream
}
