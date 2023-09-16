// Psycho Crab Autosplitter Version 1.0 Sept 16, 2023
// Written by SabulineHorizon
// Using the asl-help component written by Ero

state("Psycho Crab"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		vars.Helper["checkpoint"] = mono.Make<float>("ProgressHandler", "Checkpoint_Position");
		vars.Helper["time"] = mono.Make<float>("Timer", "time");
		vars.Helper["wins"] = mono.Make<float>("VictoryManager", "NumberOfWins");
		return true;
	});
}

start
{
	return old.time == 0 && current.time > 0;
}

split
{
	// return current.checkpoint > old.checkpoint;
	return current.checkpoint != old.checkpoint || current.wins > old.wins;
}

reset
{
	return (current.checkpoint == 0) && ((old.checkpoint != 0) || (old.time > 1 && current.time < 1));
}