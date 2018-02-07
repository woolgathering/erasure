// (un)pause groups
{|parent, array|
  // array is an array the size of the number of sections.
  // i.e. sections=5, array = [0,1,1,0,0]. Resume sections 2 and 3, pause everything else
  // this is HARDCODED!!!

  if(array[0]==0)
    {parent.sections.section1.run(false); "Section1 paused!".postln}
    {parent.sections.section1.run(true); "Section1 running...".postln};
  if(array[1]==0)
    {parent.sections.section2.run(false); "Section2 paused!".postln}
    {parent.sections.section2.run(true); "Section2 running...".postln};
  if(array[2]==0)
    {parent.sections.section3.run(false); "Section3 paused!".postln}
    {parent.sections.section3.run(true); "Section3 running...".postln};
  if(array[3]==0)
    {parent.sections.section4.run(false); "Section4 paused!".postln}
    {parent.sections.section4.run(true); "Section4 running...".postln};
  if(array[4]==0)
    {parent.sections.section5.run(false); "Section5 paused!".postln}
    {parent.sections.section5.run(true); "Section5 running...".postln};

}
