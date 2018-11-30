(
~parent = ();
~parent.server = Server.default;
~parent.thisDir = "~/Desktop/erasure".standardizePath;
~parent.startSection = 3;
~parent.debugLevel = 1;
~parent.demoMode = true;

~parent.vis = (ip: "127.0.0.1", port: 8338); // the info for the visuals machine
<<<<<<< HEAD
~parent.raspberryPi = (ip: "127.0.0.1", port: 9999); // info for the pi (recieve)
~parent.loadHist = true;
=======
~parent.raspberryPi = (ip: "172.16.3.88", port: 59131); // info for the pi (recieve)
>>>>>>> aaf06d4a79711ad5516e4f18c7ed82d14a1a5e21

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