// send the content of a file via email
{|parent, subject, path, attachment|
  var mailString;
  if(attachment.notNil) {
    mailString = "cat % | mail -s % -a % jlsundst@ucsd.edu".format(path, subject, attachment);
  } {
    mailString = "cat % | mail -s % jlsundst@ucsd.edu".format(path, subject, attachment);
  };
  mailString.unixCmd; // email it
}
