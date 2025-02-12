// A Game About Digging A Hole
// Auto start, split, reset. Written by SabulineHorizon
// Using asl-help component https://github.com/just-ero/asl-help/raw/main/lib/asl-help

state("DiggingGame"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.splits = new HashSet<string>();
	vars.splitsQueue = 0;
	
	settings.Add("splits", true, "Splits");
		settings.Add("upgrades", false, "Upgrades", "splits");
		settings.SetToolTip("upgrades", "Split when each selected upgrade is purchased");
			settings.Add("shovel", false, "Shovel", "upgrades");
				settings.Add("shovel1", false, "20cm Radius", "shovel");
				settings.Add("shovel2", false, "27cm Radius", "shovel");
				settings.Add("shovel3", false, "34cm Radius", "shovel");
				settings.Add("shovel4", false, "40cm Radius", "shovel");
				settings.Add("shovel5", false, "50cm Upgrade to Drill!", "shovel");
				settings.Add("shovel6", false, "90cm I AM SHOVEL!", "shovel");
			settings.Add("inventory", false, "Inventory", "upgrades");
				settings.Add("inventory1", false, "6 Slots", "inventory");
				settings.Add("inventory2", false, "12 Slots", "inventory");
				settings.Add("inventory3", false, "15 Slots", "inventory");
				settings.Add("inventory4", false, "20 Slots", "inventory");
				settings.Add("inventory5", false, "25 Slots", "inventory");
				settings.Add("inventory6", false, "40 Slots", "inventory");
			settings.Add("battery", false, "Battery", "upgrades");
				settings.Add("battery1", false, "200 Battery Size", "battery");
				settings.Add("battery2", false, "400 Battery Size", "battery");
				settings.Add("battery3", false, "800 Battery Size", "battery");
				settings.Add("battery4", false, "1600 Battery Size", "battery");
				settings.Add("battery5", false, "3000 Battery Size", "battery");
				settings.Add("battery6", false, "5000 Battery Size", "battery");
			settings.Add("jetpack", false, "Jet Pack", "upgrades");
				settings.Add("jetpack1", false, "Unlock Jetpack", "jetpack");
				settings.Add("jetpack2", false, "50 Jetpack Strength", "jetpack");
				settings.Add("jetpack3", false, "80 Jetpack Strength", "jetpack");
				settings.Add("jetpack4", false, "130 Jetpack Strength", "jetpack");
				settings.Add("jetpack5", false, "200 Jetpack Strength", "jetpack");
				settings.Add("jetpack6", false, "To the Moon!", "jetpack");
		settings.Add("ores", false, "Ores", "splits");
		settings.SetToolTip("ores", "Split the first time each selected ore type is collected");
			settings.Add("ores0", false, "Stone", "ores");
			settings.Add("ores1", false, "Coal", "ores");
			settings.Add("ores2", false, "Iron", "ores");
			settings.Add("ores3", false, "Copper", "ores");
			settings.Add("ores4", false, "Silver", "ores");
			settings.Add("ores5", false, "Gold", "ores");
			settings.Add("ores6", false, "Platinum", "ores");
			settings.Add("ores7", false, "Diamond", "ores");
		settings.Add("achievements", false, "Achievements", "splits");
		settings.SetToolTip("achievements", "Split the first time each selected achievement is reached");
			settings.Add("longFall", false, "Long Fall", "achievements");		settings.SetToolTip("longFall", "Fall 4 seconds");
			settings.Add("wasted", false, "Wasted", "achievements");		settings.SetToolTip("wasted", "Waste 50 ores");
			settings.Add("shoveled", false, "Shoveled", "achievements");		settings.SetToolTip("shoveled", "Shovel 4000 times");
			settings.Add("boom", false, "Boom", "achievements");			settings.SetToolTip("boom", "Throw 100 Dynamites");
			settings.Add("moneymaker", false, "Moneymaker", "achievements");	settings.SetToolTip("moneymaker", "Earn $20000");
			settings.Add("time", false, "Time", "achievements");			settings.SetToolTip("time", "Beat game under 30m");
			settings.Add("stonemason", false, "Stonemason", "achievements");	settings.SetToolTip("stonemason", "Collect 100 stones");
			settings.Add("specialOre", false, "Special Ore", "achievements");	settings.SetToolTip("specialOre", "Collect 5 rainbow ores");
		settings.Add("depth", false, "Depth (not implemented yet)", "splits");
		settings.SetToolTip("depth", "Split the first time each selected depth is reached");
			settings.Add("-10", false, "10 Meters", "depth");
			settings.Add("-25", false, "25 Meters", "depth");
			settings.Add("-50", false, "50 Meters", "depth");
			settings.Add("-75", false, "70 Meters", "depth");
			settings.Add("-100", false, "100 Meters", "depth");
		settings.Add("finalSplit", true, "Final Split", "splits");
		settings.SetToolTip("finalSplit", "Split when opening the chest to trigger final cutscene");
			settings.Add("spamFinalSplit", true, "Spam Final Split", "finalSplit");
			settings.SetToolTip("spamFinalSplit", "Repeatedly trigger final split to just in case there are too many splits");
}

init
{
	IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
	IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
	
	if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero)
	{
		print("Failed to find one or more signatures");
		vars.Helper.Game = null;
		return;
	}
	
	//Some of the offsets are pretty large, so it's possible the pointers aren't right, but they seem to work for now
	//These pointer paths were traced manually since none of the Unreal dumpers would work for me on this game
	vars.Helper["map"] = vars.Helper.MakeString(gEngine, 0xAF8, 0x0);
	vars.Helper["moveLocked"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x8C4);
	vars.Helper["inventory"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x8E4);
	vars.Helper["shovel"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x8E8);
	vars.Helper["jetpack"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x8F0);
	vars.Helper["battery"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x8F8);
	vars.Helper["lastOreIndex"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x88C);
	vars.Helper["playerX"] = vars.Helper.Make<double>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x338, 0x260);
	vars.Helper["playerY"] = vars.Helper.Make<double>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x338, 0x268);
	vars.Helper["playerZ"] = vars.Helper.Make<double>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x338, 0x270);
	vars.Helper["longFall"] = vars.Helper.Make<double>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x18D0);	//Fall 4.0s
	vars.Helper["wasted"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x18D8);		//Waste 50 ores
	vars.Helper["shoveled"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x18DC);		//Shovel 4000 times
	vars.Helper["boom"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x18E0);		//Throw 100 Dynamites
	vars.Helper["moneymaker"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x18E4);	//Earn $20000
	vars.Helper["time"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x18E8);		//Beat game under 30m (1800s)
	vars.Helper["stonemason"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x18EC);	//Collect 100 stones
	vars.Helper["specialOre"] = vars.Helper.Make<int>(gWorld, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x18F0);	//Collect 5 rainbow ores
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
}

start
{
	return(current.moveLocked == 0 && old.moveLocked == 256 && current.map == "/Game/Maps/MainLevel");
}

onStart
{
	vars.splits.Clear();
}

split
{
	string settingID = "";
	
	//Check if equipment was upgraded and if that upgrade is selected in the settings
	if(current.shovel > old.shovel && settings[settingID = "shovel" + current.shovel.ToString()] && vars.splits.Add(settingID))		{vars.splitsQueue++; print(settingID);}
	if(current.inventory > old.inventory && settings[settingID = "inventory" + current.inventory.ToString()] && vars.splits.Add(settingID))	{vars.splitsQueue++; print(settingID);}
	if(current.battery > old.battery && settings[settingID = "battery" + current.battery.ToString()] && vars.splits.Add(settingID)) 	{vars.splitsQueue++; print(settingID);}
	if(current.jetpack > old.jetpack && settings[settingID = "jetpack" + current.jetpack.ToString()] && vars.splits.Add(settingID)) 	{vars.splitsQueue++; print(settingID);}
	
	//Check if a new ore was collected and if that ore is selected in the settings
	if(current.lastOreIndex != old.lastOreIndex && settings[settingID = "ores" + current.lastOreIndex.ToString()] && vars.splits.Add(settingID))	{vars.splitsQueue++; print(settingID);}
	
	//Check if each achievement's requirements are met and if it is selected in the settings
	if(current.longFall >= 4.0 && settings[settingID = "longFall"] && vars.splits.Add(settingID))		{vars.splitsQueue++; print(settingID);}
	if(current.wasted >= 50 && settings[settingID = "wasted"] && vars.splits.Add(settingID))		{vars.splitsQueue++; print(settingID);}
	if(current.shoveled >= 4000 && settings[settingID = "shoveled"] && vars.splits.Add(settingID))		{vars.splitsQueue++; print(settingID);}
	if(current.boom >= 100 && settings[settingID = "boom"] && vars.splits.Add(settingID))			{vars.splitsQueue++; print(settingID);}
	if(current.moneymaker >= 20000 && settings[settingID = "moneymaker"] && vars.splits.Add(settingID))	{vars.splitsQueue++; print(settingID);}
	if(current.time <= 1800 && settings[settingID = "time"] && vars.splits.Add(settingID))			{vars.splitsQueue++; print(settingID);}
	if(current.stonemason >= 100 && settings[settingID = "stonemason"] && vars.splits.Add(settingID))	{vars.splitsQueue++; print(settingID);}
	if(current.specialOre >= 5 && settings[settingID = "specialOre"] && vars.splits.Add(settingID))		{vars.splitsQueue++; print(settingID);}
	
	//Calculate current depth from playerZ. It would be better to just use a pointer to the depth address, but this is easier for now
	float highZ = 33.7f;	//playerZ at 0 meters
	float lowZ = -6769.17f;	//playerZ at 100 meters
	float depth = (int)Math.Floor((100 / (highZ - lowZ)) * ((float)current.playerZ - highZ));
	
	//Check if player is low enough to trigger any selected depth splits
	if(
		(depth <= -10 && settings[settingID = "-10"] && vars.splits.Add("-10")) ||
		(depth <= -25 && settings[settingID = "-25"] && vars.splits.Add("-25")) ||
		(depth <= -50 && settings[settingID = "-50"] && vars.splits.Add("-50")) ||
		(depth <= -75 && settings[settingID = "-75"] && vars.splits.Add("-75")) ||
		(depth <= -100 && settings[settingID = "-100"] && vars.splits.Add("-100"))
	)
	{
		vars.splitsQueue++; print(settingID);
	}
	
	//Final split if player is within 200 units of chest and has locked movement (unfortunately triggers a false positive when pausing in the area)
	if(settings["finalSplit"] &&
		current.moveLocked == 256 &&
		old.moveLocked == 0 &&
		(Math.Abs(current.playerX - (31635.0)) < 500.0) &&
		(Math.Abs(current.playerY - (5640.0)) < 500.0) &&
		(Math.Abs(current.playerZ - (-7570.0)) < 500.0))
	{
		print("finalSplit");
		vars.splitsQueue++;
		if(settings["spamFinalSplit"])
			vars.splitsQueue += 100;
	}
	
	//Trigger one queued split this update cycle if there are any
	if(vars.splitsQueue > 0)
	{
		vars.splitsQueue--;
		if(vars.splitsQueue > 0)
			print(vars.splitsQueue.ToString() + " split(s) queued for next update cycle");
		return true;
	}
}

reset
{
	return(current.map == "/Game/Maps/MainMenu" && old.map != "/Game/Maps/MainMenu");
}
