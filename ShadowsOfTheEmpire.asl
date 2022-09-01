// Shadows of the Empire autosplitter
// Auto start/split/reset

state("Shadows")
{
	int startFlag	: "Shadows.exe", 0x0CADD4;	// 0 - in menu, 1 - in game
	int level		: "Shadows.exe", 0x4D6330;	// 0-9 currently loaded level
	int selected	: "Shadows.exe", 0x0CAD64;	// 0-9 currently selected level from menu screen
	bool loading	: "Shadows.exe", 0x2EEB59;	// 0 - not loading, 1 - loading //might have slight delays in updating, not sure
	float levelEnd	: "Shadows.exe", 0x0CAF4C;	// Changes from 0.0 to 9.5ish at the end-level screen, and then decreases until 2.5
}

startup
{
	// Asks user to change to Real Time if LiveSplit is currently set to Game Time
	if (timer.CurrentTimingMethod == TimingMethod.GameTime)
	{
		var timingMessage = MessageBox.Show (
			"This game uses Real Time as the main timing method.\n"+
			"LiveSplit is currently set to show in-game time (without loads)\n"+
			"Would you like to set the timing method to Real Time?",
			"LiveSplit | Shadows of the Empire",
			MessageBoxButtons.YesNo,MessageBoxIcon.Question
		);
		if (timingMessage == DialogResult.Yes)
		{
			timer.CurrentTimingMethod = TimingMethod.RealTime;
		}
	}
}

start
{
    return (
		current.startFlag == 1 &&	// a level is active
		old.startFlag == 0			// immediately after being on main menu
	);
}

reset
{
    return (
		current.startFlag == 1 &&	// a level is active
		old.startFlag == 0 &&		// immediately after being on main menu
		current.selected == 0		// hoth selected
	);
}

split
{
	return(
		old.levelEnd == 0.0 &&		// level has ended
		current.levelEnd < 9.6 &&	// level-end screen has initialized
		current.levelEnd > 9.4		// and is in the expected value range
	);
}

isLoading
{
    return current.loading;			// pause while game is loading
}
