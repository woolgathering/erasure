(
~parent = ();
~parent.server = Server.default;
~parent.thisDir = "~/Desktop/erasure".standardizePath;
~parent.startSection = 5;
~parent.debugLevel = 1;
~parent.demoMode = true;

~parent.vis = (ip: "127.0.0.1", port: 8338); // the info for the visuals machine
~parent.raspberryPi = (ip: "127.0.0.1", port: 9999); // info for the pi (recieve)
~parent.loadHist = true;

File.include(~parent.thisDir ++ "/sc/serverSettings.scd", ~parent);

if(~parent.server.serverRunning) {
  CmdPeriod.run; // run CmdPeriod if we've already got a running server so we don't have doubles
}

~parent.server.waitForBoot({
  "\nStarting erasure...\n---------------------------------------------\n".post;
  ~parent.server.sync; // sync just in case we just ran CmdPeriod
  File.include(~parent.thisDir ++ "/sc/main.scd", ~parent);
  ~parent.server.makeGui;
});
"";
)
