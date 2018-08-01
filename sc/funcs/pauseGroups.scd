// (un)pause groups
{|parent, array|
  // array is an array the size of the number of sections.
  // i.e. sections=5, array = [0,1,1,0,0]. Resume sections 2 and 3, pause everything else
  // this is HARDCODED!!!

  var debug = parent.debugLevel, section1, section2, section3, section4, section5;

  section1 = parent.section1PauseDict;
  section2 = parent.section2PauseDict;
  section3 = parent.section3PauseDict;
  section4 = parent.section4PauseDict;
  section5 = parent.section5PauseDict;

  if(array[0]==0)
    {
      if (section1.goingToPause == false) {
        section1.goingToPause = true; // we're now going to pause
        section1.pauseRoutine = fork {
          60.wait; // wait 1 minute
          parent.sections.section1.run(false); // pause
          if(debug>1) {"Section1 paused!".postln}; // debug
        };
      };
    }
    {
      if(section1.goingToPause == true) {
        section1.goingToPause = false; // we're not going to pause anymore
        section1.pauseRoutine.stop; // stop the routine
        parent.sections.section1.run(true); // run it
        if(debug>1) {"Section1 running...".postln}; // debug
      };
    };
  if(array[1]==0)
    {
      if (section2.goingToPause == false) {
        section2.goingToPause = true; // we're now going to pause
        section2.pauseRoutine = fork {
          60.wait; // wait 1 minute
          parent.sections.section2.run(false); // pause
          if(debug>1) {"Section2 paused!".postln}; // debug
        };
      };
    }
    {
      if(section2.goingToPause == true) {
        section2.goingToPause = false; // we're not going to pause anymore
        section2.pauseRoutine.stop; // stop the routine
        parent.sections.section2.run(true); // run it
        if(debug>1) {"Section2 running...".postln}; // debug
      };
    };
  if(array[2]==0)
    {
      if (section3.goingToPause == false) {
        section3.goingToPause = true; // we're now going to pause
        section3.pauseRoutine = fork {
          60.wait; // wait 1 minute
          parent.sections.section3.run(false); // pause
          if(debug>1) {"Section3 paused!".postln}; // debug
        };
      };
    }
    {
      if(section3.goingToPause == true) {
        section3.goingToPause = false; // we're not going to pause anymore
        section3.pauseRoutine.stop; // stop the routine
        parent.sections.section3.run(true); // run it
        if(debug>1) {"Section3 running...".postln}; // debug
      };
    };
  if(array[3]==0)
    {
      if (section4.goingToPause == false) {
        section4.goingToPause = true; // we're now going to pause
        section4.pauseRoutine = fork {
          60.wait; // wait 1 minute
          parent.sections.section4.run(false); // pause
          if(debug>1) {"Section4 paused!".postln}; // debug
        };
      };
    }
    {
      if(section4.goingToPause == true) {
        section4.goingToPause = false; // we're not going to pause anymore
        section4.pauseRoutine.stop; // stop the routine
        parent.sections.section4.run(true); // run it
        if(debug>1) {"Section4 running...".postln}; // debug
      };
    };
  if(array[4]==0)
    {
      if (section5.goingToPause == false) {
        section5.goingToPause = true; // we're now going to pause
        section5.pauseRoutine = fork {
          60.wait; // wait 1 minute
          parent.sections.section5.run(false); // pause
          if(debug>1) {"Section5 paused!".postln}; // debug
        };
      };
    }
    {
      if(section5.goingToPause == true) {
        section5.goingToPause = false; // we're not going to pause anymore
        section5.pauseRoutine.stop; // stop the routine
        parent.sections.section5.run(true); // run it
        if(debug>1) {"Section5 running...".postln}; // debug
      };
    };

}
