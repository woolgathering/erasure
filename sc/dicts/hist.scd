{|parent|
var hist = ();

hist.tmpArray = Array.fill(288, 0); // a temporary array (this will be made anew every day)

// arrays to hold the number of visitors every 5 minutes as set by updateVisitors()
hist.sun = Array.rand(288, 0, 20); // random values to start
hist.mon = Array.rand(288, 0, 20); // random values to start
hist.tue = Array.rand(288, 0, 20); // random values to start
hist.wed = Array.rand(288, 0, 20); // random values to start
hist.thu = Array.rand(288, 0, 20); // random values to start
hist.fri = Array.rand(288, 0, 20); // random values to start
hist.sat = Array.rand(288, 0, 20); // random values to start

hist.dayCount = (); // another dictionary to count the days elapsted
hist.dayCount.sun = 1;
hist.dayCount.mon = 1;
hist.dayCount.tue = 1;
hist.dayCount.wed = 1;
hist.dayCount.thu = 1;
hist.dayCount.fri = 1;
hist.dayCount.sat = 1;

hist.calc = {|dict, day, new|
  var old, array;
  old = dict.at(day) * (dict.dayCount.at(day)-1); // calculate the weights
  array = old + new; // add the two arrays together
  array = array/dict.dayCount.at(day); // get the average
  dict.put(day, array); // set it internally
  // array; // make sure to return the new average
};

hist.dayCountDay = {|dict, day|
  dict.dayCount.put(day, dict.dayCount.at(day) + 1); // add another day
  // dict.dayCount.at(day) = dict.dayCount.at(day) + 1; // add another day
};

hist.getHistory = {|dict, day, date|
  date = (6 * date.hour.asInteger) + (date.minute.asInteger/10).round; // get the index of the time
  dict.dayCount.at(day)[date]; // return the value
};

// fucntion not necessary?
hist.getCurrentCount{|dict|
  var day, date;
  date = Date.getDate;
  day = date.format("%a").toLower.asSymbol;
  // date = (6 * d.hour.asInteger) + (d.minute.asInteger/10).round; // get the index of the time
  // parent.tmpArray[date] = parent.tracking.getCount; // get the current number of visitors in the space and remember it
};

// a function to save the history to an Archive
hist.makeArchive = {|dict|
  var path, archive = (), file; // an empty dict for the Archive
  path = parent.thisDir++"/archives/"++Date.getDate.stamp; // get the path
  archive.dayCounts = dict.dayCount; // the number of days that have elapsted
  archive.history = (
    sun: hist.sun,
    mon: hist.mon,
    tue: hist.tue,
    wed: hist.wed,
    thu: hist.thu,
    fri: hist.fri,
    sat: hist.sat,
  );
  archive.writeArchive(path); // write the archive
  path; // return the path for emailing it
};

// a function that restores the history from an Archive
hist.restore = {|dict, path|
  var archive;
  archive = Object.readArchive(path); // read in the Archive
  hist.dayCount = archive.dayCount; // set the days that have elapsed
  archive.history.keysValuesDo{|key, value|
    hist.put(key, value); // set it
  };
};

hist; // return the dictionary

}
