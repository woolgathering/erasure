`////////////////////////////////
/*
  Daily function
    this runs every day at midnight.
*/
////////////////////////////
{|parent|
  var yesterday, email, hist, plot, archivePath;

  hist = parent.hist; // make life easier
  // email = File.open(PathName.tmp++"erasureMaintainenceEmail", "a+"); // open an emtpy file for writing
  yesterday = Date.getDate.yesterday.format("%a").toLower.asSymbol; // get yesterday and make it a symbol
  hist.countDay(yesterday); // another day has passed, so count it
  hist.calc(yesterday, hist.tmpArray); // recalculate the history to include yesterday
  hist.tmpArray = Array.fill(288, 0); // reset the array
  archivePath = hist.makeArchive; // make an Archive of the history

  // this.executeFile("~/Desktop/erasure/sc/funcs/restart.scd".standardizePath, parent.busses.sectionFader.get);
  fork {
    // parent.server.quit;
    1.wait;
    // thisProcess.interpreter.executeFile("~/Desktop/erasure/sc/funcs/restart.scd".standardizePath, parent.busses.sectionFader.get); // restart at the same section
    thisProcess.interpreter.executeFile("~/Desktop/erasure/sc/funcs/restart.scd".standardizePath); // restart at the same section
  };

  // The function doChecks checks the status of the installation and tells if something has broken.
  // Since it runs every 5 minutes inside checkStatus(), duplicating it here is not necessary.

  // add plot attachment  after GNUPlot bash script is written. Not that important.
  // parent.sendEmail("Erasure Daily Update", PathName.tmp++"erasureMaintainenceEmail", archivePath);
  // email.close; // close the email file

  // reset the sensors in the module
  // parent.sensor.server.addr.sendMsg("/resetCount", 0); // reset to 0 in case something has gone wonky throughout the day
}
