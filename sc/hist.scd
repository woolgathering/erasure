{|parent|
var hist = ();

// parent.hist = (); // an emtpy dict for history
hist.sun = Array.rand(144, 0, 20); // random values to start
hist.mon = Array.rand(144, 0, 20); // random values to start
hist.tue = Array.rand(144, 0, 20); // random values to start
hist.wed = Array.rand(144, 0, 20); // random values to start
hist.thu = Array.rand(144, 0, 20); // random values to start
hist.fri = Array.rand(144, 0, 20); // random values to start
hist.sat = Array.rand(144, 0, 20); // random values to start

hist.count = (); // another dictionary to count the days elapsted
hist.count.sun = 1;
hist.count.mon = 1;
hist.count.tue = 1;
hist.count.wed = 1;
hist.count.thu = 1;
hist.count.fri = 1;
hist.count.sat = 1;

hist.calc = {|dict, day, new|
  var old, array;
  old = dict.at(day) * (dict.count.at(day)-1); // calculate the weights
  array = old + new; // add the two arrays together
  array = array/dict.count.at(day); // get the average
  dict.put(day, array); // set it internally
  // array; // make sure to return the new average
};

hist.countDay = {|dict, day|
  dict.count.put(day, dict.count.at(day) + 1); // add another day
  // dict.count.at(day) = dict.count.at(day) + 1; // add another day
};

hist.getHistory = {|dict, day, date|
  date = (6 * d.hour.asInteger) + (d.minute.asInteger/10).round; // get the index of the time
  dict.count.at(day)[date]; // return the value
};

// fucntion not necessary?
hist.getCurrentCount{|dict|
  var day, date;
  date = Date.getDate;
  day = date.format("%a").toLower.asSymbol;
  // date = (6 * d.hour.asInteger) + (d.minute.asInteger/10).round; // get the index of the time
  // parent.tmpArray[date] = parent.tracking.getCount; // get the current number of visitors in the space and remember it
};

hist.makeArchive = {|dict|
  var path, archive = (); // an empty dict for the Archive
  path = parent.thisDir++"/archives/"++Date.getDate.stamp; // get the path
  archive.counts = dict.count; // the number of days that have elapsted
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


}
