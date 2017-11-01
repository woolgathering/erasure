{|parent, info|
  var subject, body;

  subject = "ALERT!!! ERASURE IS BROKEN!!!";
  body = "The following was returned by doChecks():\n\n";
  body = body++info; // append the strings together
  parent.sendEmail(subject, body); // send it
}
