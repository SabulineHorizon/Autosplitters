//Aquanox Autosplitter
//Written by SabulineHorizon
//Sept 27 2022 - Version 1.0

state("Aqua"){
	int cutscene		: "binkw32.dll", 0x5E064;	// Cutscene is active when this is greater than 0
	byte loading		: 0x10DBC0, 0x1D8;		// 43 - loading
	byte activeStation	: 0x292F5C, 0x8, 0x28;		// Shows station number after station becomes active
	byte nextStation	: 0x263258, 0x1C, 0x28;		// Shows station number both during loading and while station is active
	string64 mapPath	: 0x2676C0, 0x7C, 0x40, 0x60;	// Resource path of current level
	string32 menu1		: 0x26323C, 0xA0, 0x2F4, 0x0;	// Menu selection 1 - "Dipol Auto Activate: 0"
	string32 menu2		: 0x26323C, 0xA0, 0x340, 0x0;	// Menu selection 2 - "Activate Dipol"
}

startup{
	// Asks user to change to Game Time if LiveSplit is currently set to Real Time
	if (timer.CurrentTimingMethod == TimingMethod.RealTime){
		var timingMessage = MessageBox.Show (
			"This game uses Game Time as the main timing method.\n"+
			"LiveSplit is currently set to show Real Time (with loads)\n"+
			"Would you like to set the timing method to Game Time?",
			"LiveSplit | Aquanox",
			MessageBoxButtons.YesNo,MessageBoxIcon.Question
		);
		if (timingMessage == DialogResult.Yes){
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
}

start{
	//if cutscene ended and next station is Magellan
	return (old.cutscene > 0 && current.cutscene == 0 && current.nextStation == 2);
}

split{
	return (
		(old.menu1 == "Dipol Auto Activate: 0" &&	// Automatic timer splits - level-end countdown finished
		current.menu1 != old.menu1 &&			// Automatic timer splits - only split once 
		current.mapPath != "map\\6h4\\script\\6h4") ||	// Automatic timer splits - avoid double split at the end of run
		(old.menu2 == "Activate Dipol" &&		// Manual splits - "Activate Dipol" is most recent selection
		current.menu2 == null) || 			// Manual splits - menu2 changed to null because loading started
		(current.menu1 == "Dipol Auto Activate: 20" &&	// End split - level-end countdown started
		current.menu1 != old.menu1 &&			// End split - only split once
		current.mapPath == "map\\6h4\\script\\6h4")	// End split - while on final level
	);
}

reset{
	// if cutscene started and next station is Magellan
	return (old.cutscene == 0 && current.cutscene > 0 && current.nextStation == 2 && current.activeStation != 2);
}

isLoading{
	return (current.loading == 43);
}

exit{
    timer.IsGameTimePaused = true;
}
