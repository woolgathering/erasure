// daily function
// this runs every day at midnight
{|parent|
  var yesterday, email, hist, plot;

  hist = parent.hist; // make life easier
  // email = File(PathName.tmp, "a+")// open an emtpy file for writing (or a string?)
  yesterday = Date.getDate.yesterday.format("%a").toLower.asSymbol; // get yesterday and make it a symbol

  hist.countDay(yesterday); // another day has passed, so count it
  hist.calc(yesterday, hist.tmpArray); // recalculate the history for yesterday
  hist.tmpArray = Array.fill(144, 0); // reset the array

  hist.makeArchive; // make an Archive of the history

  plot = 

  // some sort of function that saves the history data as an Archive so we can get it later if something breaks
  // maybe it can also email me some update so I know it hasn't crashed


}
