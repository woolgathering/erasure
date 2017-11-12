// send the content of a file via email
{|parent, subject, path, attachment|
  var mailString;
  mailString = "cat % | mail -s % -a % jacob.sundstrom@gmail.com".format(path, subject, attachment);
  mailString.unixCmd; // email it
}
