(
~parent = ();
~parent.server = Server.default;
~parent.thisDir = "~/Desktop/erasure/erasure".standardizePath;
~parent.numSecs = 5;
~parent.debugLevel = 0;
~parent.demoMode = true;

File.include(~parent.thisDir ++ "/sc/serverSettings.scd", ~parent);
~parent.server.waitForBoot({
  "\nStarting erasure...\n---------------------------------------------\n".post;
  File.include(~parent.thisDir ++ "/sc/main.scd", ~parent);
});
// ~parent.server.meter;
"";
)

~parent.busses.volume.scope;
~parent.server.plotTree;
~parent.server.meter
~parent.sections.section1.busses.fxBus.scope
~parent.server.makeGui

~parent.spat
