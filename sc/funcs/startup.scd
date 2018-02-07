////////////////////////////////////
/*
  Startup Funcion
  This function creates the functions that run on a timer and the synths that capture all outputs
*/
////////////////////////////////////

{|parent, overlap|
  var hist, good, errorMsg, sine, table;
  parent.synths = (); // an emtpy dictionary for the synths
  hist = parent.hist; // make life easier
  // parent.timer = DayTimer(\mainLoop); // make a main timer that we'll put everything in
  parent.timer.start; // start the timer

  // this runs every 5 minutes to update the 'historical record'
  parent.timer.putDate(\checkStatus,
    {|date| #[0,5,10,15,20,25,30,35,40,45,50,55].includes(date.minute) && date.second==0}, // true every 5 minutes
    {
      if(parent.debugLevel>0) {Date.getDate.postln}; // if we're debugging, post the time every 5 minutes
      parent.updateVisitors; // run the funtion that updates everything
      // hist.getCurrentCount; // get the current number of vistors and remember it

      # good, errorMsg = parent.doChecks; // check to make sure we're still talking to the visuals and the sensor
      if(good.not) {
        // parent.sendAlert(errorMsg); // if something is no good, tell me that we're broken
      };
    }
  );

  // run this every day at midnight
  parent.timer.putDate(\maintainence,
    {|date| (date.hour+date.minute+date.second)==0}, // true if it's midnight
    parent.maintainence; // run the maintainence function
  );

  // do this every 30 seconds
  parent.timer.putDate(\pauseGroups,
    {|date| #[0,30].includes(date.second)}, // every 30 seconds
    {
      "Pausing nodes...".postln;
      // given a sectionFader position, pause the groups appropriately:
      parent.busses.sectionFader.get({|val|
        case
          {val<2.5} {parent.pauseGroups([1,1,0,0,0])}
          {(val>2.4) and: (val<3.6)} {parent.pauseGroups([0,1,1,0,0])}
          {(val>3.4) and: (val<4.6)} {parent.pauseGroups([0,0,1,1,0])}
          {val>4.4} {parent.pauseGroups([0,0,0,1,1])};
      }); // get the value of the section fader

    }
  );

  ////////////////////////////////
  // Make the envelopes
  ////////////////////////////////
  sine = Env.sine(600).asSignal.resamp1(1024); // a single period of a sine
  table = Env(levels: [0,1,1,0], times: [overlap,1-(overlap*2),overlap], curve: \sin).asSignal.resamp1(1024);
  parent.envs = (); // an empty dict for envelopes
  parent.envs.sine = Buffer.loadCollection(parent.server, sine); // a sine envelope, for use in episodes
  parent.envs.firstHalfSine = Buffer.loadCollection(parent.server, sine[..511]); // a sine envelope, for use in episodes
  parent.envs.secondHalfSine = Buffer.loadCollection(parent.server, sine[512..]); // a sine envelope, for use in episodes
  parent.envs.table = Buffer.loadCollection(parent.server, table); // for use between sections
  parent.envs.firstHalfTable = Buffer.loadCollection(parent.server, table[..511]); // for use between sections
  parent.envs.lastHalfTable = Buffer.loadCollection(parent.server, table[512..]); // for use between sections
  parent.freeables.addAll(parent.envs); // add all these to the freeables
  parent.server.sync;

  ////////////////////////////
  // Start synths through which everything is routed
  ////////////////////////////

  // reverb synth
  parent.synths.reverb = Synth(\reverb,
    [
    inBus: parent.busses.rev, outBus: parent.busses.mainOut, initDel: 0.02, mix: -0.7, leak: 0.005, hp: 50,
    impulseBuffs: [parent.revBuffs.left, parent.revBuffs.right]
    ],
    target: parent.groups.revAndOut, addAction: \addToHead
  );

  // make the main pipe for the output: THIS GOES TO THE MAINS!!!
  parent.synths.mainPipe = Synth(\mainPipe,
    [inBus: parent.busses.mainOut, outBus: 0, amp: parent.busses.volume.asMap],
    target: parent.groups.revAndOut, addAction: \addToTail
  );

}
