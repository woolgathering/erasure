// (un)pause groups
{|parent, array|
  // array is an array the size of the number of sections.
  // i.e. sections=5, array = [0,1,1,0,0]. Resume sections 2 and 3, pause everything else
  // this is HARDCODED!!!

  var debug = parent.debugLevel;

  if(array[0]==0)
    {parent.sections.section1.run(false);
      if(debug>1) {"Section1 paused!".postln};
    }
    {parent.sections.section1.run(true);
      if(debug>1) {"Section1 running...".postln};
    };
  if(array[1]==0)
    {parent.sections.section2.run(false);
      if(debug>1) {"Section2 paused!".postln};
    }
    {parent.sections.section2.run(true);
      if(debug>1) {"Section2 running...".postln};
    };
  if(array[2]==0)
    {parent.sections.section3.run(false);
      if(debug>1) {"Section3 paused!".postln};
    }
    {parent.sections.section3.run(true);
      if(debug>1) {"Section3 running...".postln};
    };
  if(array[3]==0)
    {parent.sections.section4.run(false);
      if(debug>1) {"Section4 paused!".postln};
    }
    {parent.sections.section4.run(true);
      if(debug>1) {"Section4 running...".postln};
    };
  if(array[4]==0)
    {parent.sections.section5.run(false);
      if(debug>1) {"Section5 paused!\n".postln};
    }
    {parent.sections.section5.run(true);
      if(debug>1) {"Section5 running...\n".postln};
    };

}
