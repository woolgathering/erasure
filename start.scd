(
~parent = ();
~parent.server = Server.default;
~parent.thisDir = "~/Documents/jacob/pieces/erasure".standardizePath;
~parent.startSection = 1;
~parent.debugLevel = 3;
~parent.demoMode = true;

File.include(~parent.thisDir ++ "/sc/serverSettings.scd", ~parent);
~parent.server.waitForBoot({
  "\nStarting erasure...\n---------------------------------------------\n".post;
  File.include(~parent.thisDir ++ "/sc/main.scd", ~parent);
});
// ~parent.server.meter;
"";
)

~parent.busses.volrume.scope;
~parent.server.plotTree;
~parent.server.meter
~parent.sections.section1.busses.fxBus.scope


~parent.server.makeGui

~parent.spat



~parent.server.record("~/Desktop/erasure_take3.wav", 0, 8, duration: 1300);
fork {1301.wait; CmdPeriod.run}
