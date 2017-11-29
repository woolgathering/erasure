// (un)pause groups
{|parent, array|
  // array is an array the size of the number of sections.
  // i.e. sections=5, array = [0,1,1,0,0]. Resume sections 2 and 3, pause everything else
  // this is HARDCODED!!!

  if(array[0]==0) {parent.section1.set(\pause, 1)} {parent.section1.run};
  if(array[1]==0) {parent.section2.set(\pause, 1)} {parent.section2.run};
  if(array[2]==0) {parent.section3.set(\pause, 1)} {parent.section3.run};
  if(array[3]==0) {parent.section4.set(\pause, 1)} {parent.section4.run};
  if(array[4]==0) {parent.section5.set(\pause, 1)} {parent.section5.run};

}
