(
~parent = ();
~parent.server = Server.default;
~parent.thisDir = "~/Documents/erasure/erasure".standardizePath;
~parent.startSection = 5;
~parent.debugLevel = 1;
~parent.demoMode = true;

~parent.vis = (ip: "127.0.0.1", port: 8338); // the info for the visuals machine

File.include(~parent.thisDir ++ "/sc/serverSettings.scd", ~parent);
~parent.server.waitForBoot({
  "\nStarting erasure...\n---------------------------------------------\n".post;
  File.include(~parent.thisDir ++ "/sc/main.scd", ~parent);
  ~parent.server.makeGui;
});
"";
)

Quarks

Platform.userExtensionDir

~parent.busses.volume.scope;
~parent.server.plotTree;
~parent.server.meter
~parent.sections.section1.busses.fxBus.scope

~parent.server.inputStreamsEnabled = "0";

~parent.server.makeGui

a = 500.collect{~parent.faderStream.next * 0.25}
a.plot
a.maxItem

s.makeGui

22*0.25

~parent.spat

~parent.arrays.volume.plot

"~/Documents/erasure/erasure".standardizePath;
