// (un)pause groups
{|parent, array|
  // array is an array the size of the number of sections.
  // i.e. sections=5, array = [0,1,1,0,0]. Resume sections 2 and 3, pause everything else
  // this is HARDCODED!!!

  if(array[0]==0) {parent.sections.section1.set(\pause, 1)} {parent.sections.section1.run};
  if(array[1]==0) {parent.sections.section2.set(\pause, 1)} {parent.sections.section2.run};
  if(array[2]==0) {parent.sections.section3.set(\pause, 1)} {parent.sections.section3.run};
  if(array[3]==0) {parent.sections.section4.set(\pause, 1)} {parent.sections.section4.run};
  if(array[4]==0) {parent.sections.section5.set(\pause, 1)} {parent.sections.section5.run};

}
