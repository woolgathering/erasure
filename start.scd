(
~parent = ();
~parent.server = Server.default;
~parent.thisDir = "~/Desktop/erasure".standardizePath;
~parent.startSection = 3;
~parent.debugLevel = 1;
~parent.demoMode = true;

~parent.vis = (ip: "127.0.0.1", port: 8338); // the info for the visuals machine
~parent.raspberryPi = (ip: "172.16.3.88", port: 59131); // info for the pi (recieve)

File.include(~parent.thisDir ++ "/sc/serverSettings.scd", ~parent);
~parent.server.waitForBoot({
  "\nStarting erasure...\n---------------------------------------------\n".post;
  File.include(~parent.thisDir ++ "/sc/main.scd", ~parent);
  ~parent.server.makeGui;
});
"";
)