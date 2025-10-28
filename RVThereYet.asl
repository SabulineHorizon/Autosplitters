//RV There Yet autosplitter
// Auto start and split. Written by SabulineHorizon
// Using asl-help component https://github.com/just-ero/asl-help/raw/main/lib/asl-help

state("Ride-Win64-Shipping") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.splits = new HashSet<string>();
	vars.splitsQueue = 0;
	
	settings.Add("splits", true, "Splits");
	settings.SetToolTip("splits", "Enable or disable specific splits");
		settings.Add("checkpoints", false, "Checkpoints", "splits");
		settings.SetToolTip("checkpoints", "Split when each selected checkpoint is first reached");
			settings.Add("1", true, "Checkpoint 1", "checkpoints");
			settings.Add("2", true, "Checkpoint 2", "checkpoints");
			settings.Add("3", true, "Checkpoint 3", "checkpoints");
			settings.Add("4", true, "Checkpoint 4", "checkpoints");
			settings.Add("5", true, "Checkpoint 5", "checkpoints");
			settings.Add("6", true, "Checkpoint 6", "checkpoints");
			settings.Add("7", true, "Checkpoint 7", "checkpoints");
			settings.Add("8", true, "Checkpoint 8", "checkpoints");
			settings.Add("9", true, "Checkpoint 9", "checkpoints");
			settings.Add("10", true, "Checkpoint 10", "checkpoints");
			settings.Add("11", true, "Checkpoint 11", "checkpoints");
			settings.Add("12", true, "Checkpoint 12", "checkpoints");
			settings.Add("13", true, "Checkpoint 13", "checkpoints");
			settings.Add("14", true, "Checkpoint 14", "checkpoints");
			settings.Add("15", true, "Checkpoint 15", "checkpoints");
			settings.Add("16", true, "Checkpoint 16", "checkpoints");
			settings.Add("17", true, "Checkpoint 17", "checkpoints");
		settings.Add("finalSplit", true, "Final Split", "splits");
		settings.SetToolTip("finalSplit", "Split when triggering the end credits");
			settings.Add("spamFinalSplit", true, "Spam Final Split", "finalSplit");
			settings.SetToolTip("spamFinalSplit", "Repeatedly trigger final split to just in case there are too many splits");
}

init
{
	IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
	
	if (gWorld == IntPtr.Zero)
	{
		print("Failed to find gWorld signature");
		vars.Helper.Game = null;
		return;
	}
	
	vars.Helper["bIsActive"] = vars.Helper.Make<bool>(gWorld, 0x228, 0x38, 0x0, 0x30, 0x788, 0x3E0); // 0 inactive, 1 active (activates before loading screen at start too)
	vars.Helper["seconds"] = vars.Helper.Make<double>(gWorld, 0x1b0, 0x2d8); // ReplicatedWorldTimeSecondsDouble
	vars.Helper["checkpoint"] = vars.Helper.Make<int>(gWorld, 0x228, 0x1F0); // Current checkpoint index 0-17
	vars.Helper["credits"] = vars.Helper.Make<long>(gWorld, 0x228, 0x38, 0x0, 0x30, 0x788, 0x690); // Pointer to the credits music component
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	// print(current.credits.ToString());
}

start {
	return( !old.bIsActive && current.bIsActive && current.seconds != 0 && current.checkpoint == 0);
}

onStart {
	vars.splits.Clear();
}

split {
	string settingID = "";
	
	//Check if a new checkpoint has been reached
	if(
		current.checkpoint != null && current.checkpoint != 0 &&
		settings[settingID = current.checkpoint.ToString()] &&
		vars.splits.Add(settingID)
	)
	{vars.splitsQueue++; print(settingID);}
	
	//Final split
	if(
		current.checkpoint == 17 &&
		current.credits != null && current.credits != 0 &&
		settings[settingID = "finalSplit"] &&
		(settings["spamFinalSplit"] || vars.splits.Add(settingID))
	)
	{vars.splitsQueue++; print(settingID);}
	
	//Trigger one queued split this update cycle if there are any
	if(vars.splitsQueue > 0)
	{
		vars.splitsQueue--;
		if(vars.splitsQueue > 0)
			print(vars.splitsQueue.ToString() + " split(s) queued for next update cycle");
		return true;
	}
}

onReset
{
	vars.splitsQueue = 0;
}
