{|parent, info|
  var subject, body, file;

  subject = "ALERT!!! ERASURE IS BROKEN!!!";
  body = "The following was returned by doChecks():\n\n";
  body = body++info; // append the strings together
  path = parent.thisDir++"/alerts/%".format(Date.getDate.stamp); // get the path
  file = File.open(path); // open the file
  file.write(body); // write the content to the file
  parent.sendEmail(subject, path); // send it
  file.close; // close the file
}
