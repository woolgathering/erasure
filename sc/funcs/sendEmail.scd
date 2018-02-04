// send the content of a file via email
{|parent, subject, path, attachment|
  var mailString;
  if(attachment.isNil) {
    mailString =  "cat % | mail -s % jlsundst@ucsd.edu".format(path, subject); // no attachment
  } {
    if(attachment.isString) {
      // if it's a string, it's a path of a single attachment
      mailString = "cat % | mail -s % -a % jlsundst@ucsd.edu".format(path, subject, attachment);
    } {
      // else it's an Array with multiple attachments
      mailString = "cat % | mail -s %";
      attachment.do{|path|
        mailString = mailString ++ " -a %".format(path); // append the attachment path with it's own flag
      };
      mailString = mailString ++ " jlsundst@ucsd.edu"; // wrap it up
    };
  };
  mailString.unixCmd; // email it
}
