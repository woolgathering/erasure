(
////////////////////////
/*
  Speaker test. This cycles through numSpeakers with PinkNoise of amplitude amp
  at the interval. Server needs to set up outside this file.
*/
////////////////////////

var numSpeakers, interval, amp, firstOutputBus;

numSpeakers = 16; // RML
interval = 2; // two seconds
amp = -6.dbamp;
firstOutputBus = 0;

SynthDef(\noiseTest, {|outBus = 0, amp = 0.2, interval = 1|
  var sig, ramp;
  ramp = Line.kr(dur: interval, doneAction: 2); // kill after the interval
  sig = PinkNoise.ar(amp);
  Out.ar(outBus, sig);
}).send(s);

SynthDef(\sweepTest, {|outBus = 0, amp = 0.2, interval = 1|
  var sig, freq;
  freq = XLine.ar(1, 18000, interval, doneAction: 2);
  sig = SinOsc.ar(freq, mul: amp*0.707); // down a little more...
  Out.ar(outBus, sig);
}).send(s);

fork {
  var speaker = 0;
  speaker = speaker+firstOutputBus;
  s.sync;
  loop {
    Synth(\noiseTest, [outBus: speaker, interval: interval, amp: amp]);
    "Testing outputBus (speaker) %...\n".postf(speaker);
    interval.wait;
    speaker = (speaker+1)%numSpeakers;
  }
};

"Testing Speakers......................";  // print this

)
