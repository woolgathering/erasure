//////////////////////////////
// CmdPeriod
/////////////////////////////
{|parent|

  CmdPeriod.doOnce{
    parent.freeables.do(_.free); // free all the freeables

    // timer stuff
    parent.timer.stop; // stop the timer
    parent.timer.removeAt(\checkStatus);
    parent.timer.removeAt(\maintainence);
    parent.timer.removeAt(\pauseGroups);

    // just to be safe
    Buffer.freeAll;
    Server.freeAll;
  };


}
