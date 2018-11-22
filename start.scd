(
~parent = ();
~parent.server = Server.default;
~parent.thisDir = "~/Desktop/erasure".standardizePath;
~parent.startSection = 5;
~parent.debugLevel = 1;
~parent.demoMode = true;

~parent.vis = (ip: "127.0.0.1", port: 8338); // the info for the visuals machine
~parent.raspberryPi = (ip: "127.0.0.1", port: 9999); // info for the pi (recieve)

File.include(~parent.thisDir ++ "/sc/serverSettings.scd", ~parent);
~parent.server.waitForBoot({
  "\nStarting erasure...\n---------------------------------------------\n".post;
  File.include(~parent.thisDir ++ "/sc/main.scd", ~parent);
  ~parent.server.makeGui;
});
"";
)
