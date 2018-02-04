(
~parent = ();
~parent.server = Server.default;
~parent.thisDir = "~/Documents/jacob/pieces/erasure".standardizePath;
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

~parent.busses.volume.scope;
~parent.server.plotTree;
~parent.server.meter
~parent.sections.section1.busses.pipeBus.scope

~parent.spat

m = Monitor.new;

m.play(69,1,0,1)
Stethoscope(s, 4, 53)
2.pow(15)

// 0.2.wait;
~parent.sections.section1.episodes.episode1.keysValuesDo{|key, val| "%:\t%\n".postf(key,val)};

~parent.revBuffs
