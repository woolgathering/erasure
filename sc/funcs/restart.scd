// Restart function
// this is identical to start.scd except it is a function which is passed the section of the spot we're in now (no, we keep ~parent mostly and just recall main.scd where everything actually lives)
// this will *hopefully* get rid of the "command FIFO full" problems by restarting the server (and everything, unfortunetly) every day at midnight

(
if(~parent.notNil) {
  if(~parent.server.serverRunning) {
    CmdPeriod.run; // run CmdPeriod if we've already got a running server so we don't have doubles
    ~parent.server.quit; // shutdown the server
	Server.killAll;
  };
};

~parent.startSection = ~parent.lastSection ? 3;

"\n\n".post;
"RESTARTING...\n\n".warn;
"\n\n".post;

~parent.server.waitForBoot({
  "\nStarting erasure...\n---------------------------------------------\n".post;
  ~parent.server.sync; // sync just in case we just ran CmdPeriod
  File.include(~parent.thisDir ++ "/sc/main.scd", ~parent);
  // ~parent.server.makeGui;
  // ~parent.server.meter;
});
"";
)
