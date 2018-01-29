////////////////////////////////////
/*
  Demo Pattern
  Function that runs the visitors on brownian motion instead of reading from the sensor. This is used
  when we're demonstrating the piece instead of letting it run.
*/
////////////////////////////////////

{|parent|
  var stream;
  stream = Pbrown(0,20,2,inf).asStream; // between 0 and 20 people, maximum 2 enter at a time for infinity
  stream; // return the stream
}
