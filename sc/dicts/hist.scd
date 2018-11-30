{|parent|
var hist = ();

	hist.tmpArray = Array.fill(288, {rrand(1,15)}); // a temporary array (this will be made anew every day)

// arrays to hold the number of visitors every 5 minutes as set by updateVisitors()
hist.sun = Array.rand(288, 0, 15); // random values to start
hist.mon = Array.rand(288, 0, 15); // random values to start
hist.tue = Array.rand(288, 0, 15); // random values to start
hist.wed = Array.rand(288, 0, 15); // random values to start
hist.thu = Array.rand(288, 0, 15); // random values to start
hist.fri = Array.rand(288, 0, 15); // random values to start
hist.sat = Array.rand(288, 0, 15); // random values to start

hist.dayCount = (); // another dictionary to count the days elapsted
hist.dayCount.sun = 1;
hist.dayCount.mon = 1;
hist.dayCount.tue = 1;
hist.dayCount.wed = 1;
hist.dayCount.thu = 1;
hist.dayCount.fri = 1;
hist.dayCount.sat = 1;

// get some statistics
hist.stats = ();
hist.stats.sun = (maxVisitors: 5, minVisitors: 1, avgVisitors: 2);
hist.stats.mon = (maxVisitors: 5, minVisitors: 1, avgVisitors: 2);
hist.stats.tue = (maxVisitors: 5, minVisitors: 1, avgVisitors: 2);
hist.stats.wed = (maxVisitors: 5, minVisitors: 1, avgVisitors: 2);
hist.stats.thu = (maxVisitors: 5, minVisitors: 1, avgVisitors: 2);
hist.stats.fri = (maxVisitors: 5, minVisitors: 1, avgVisitors: 2);
hist.stats.sat = (maxVisitors: 5, minVisitors: 1, avgVisitors: 2);

hist.calc = {|dict, day, new|
  var array;
  // calculate new averages for every 5 minutes
  array = (dict.at(day)+new)/dict.dayCount.at(day); // get the average for every five minutes
  dict.put(day, (dict.at(day)+new)/dict.dayCount.at(day)); // set it internally

  // check if we have a new max
  if(dict.stats.at(day).maxVisitors <= new.maxItem) {dict.stats.at(day).maxVisitors = new.maxItem};

  // check if we have a new min
  if(dict.stats.at(day).minVisitors >= new.minItem) {dict.stats.at(day).minVisitors = new.minItem};

  // get a new average for the day
  dict.stats.at(day).avgVisitors = {
    var tmp;
    tmp = dict.stats.at(day).avgVisitors + (new.sum/new.sum.size); // add the new value
    dict.stats.at(day).avgVisitors = tmp / dict.dayCount.at(day); // get the new average
  }.value;
};

hist.countDay = {|dict, day|
		// dict.dayCount.at(day) = dict.dayCount.at(day) + 1; // add another day
		dict.dayCount.at(day).put(day, dict.dayCount.at(day)+1);
};

hist.getHistory = {|dict, day, date|
  date = (6 * date.hour.asInteger) + (date.minute.asInteger/10).round; // get the index of the time
  dict.dayCount.at(day)[date]; // return the value
};

// a function to save the history to an Archive
hist.makeArchive = {|dict|
  var path, archive = (), file; // an empty dict for the Archive
  path = parent.thisDir++"/archives/"++Date.getDate.yesterday.stamp++".archive"; // get the path
  archive.dayCounts = dict.dayCount; // the number of days that have elapsted
  archive.stats = dict.stats; // keep the stats
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
  if(path.notNil) {
    archive = Object.readArchive(path); // read in the Archive
    hist.dayCount = archive.dayCount; // set the days that have elapsed
    hist.stats = archive.stats;
    archive.history.keysValuesDo{|key, value|
      hist.put(key, value); // set it
    };
  } {
    // else the path is nil (no archives) so do nothing
    "No archives avaialble so none were loaded".warn; // but tell us
  };
};

// function to get the latest archives
hist.getLatestArchive = {|dict|
  var paths;
  paths = parent.thisDir++"/archives/*.archive".pathMatch; // get the paths in an array
  paths = p.collect{|path|
  	[path, path.basename.splitext[0].split($_)[0].asInteger];
  }.sort({|a,b| a[1] < b[1]}); // sort the paths by date
  paths[paths.size-1][1]; // return the path of the latest archive
};

hist; // return the dictionary

}
