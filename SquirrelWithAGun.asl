//Written by SabulineHorizon

//Current version as of Oct 16 2024
state("SquirrelGun-Win64-Shipping", "1.2.0.11") {
	// string30 projectVersion: 0x765B470, 0x1B8, 0x2B0, 0x30, 0x0;			//GWorld, OwningGameInstance, ProjectVersionData, FString Version
	double bossMaxHealth: 0x765B470, 0x30, 0x98, 0x4A0, 0x340, 0xC8, 0x8;		//GWorld, PersistentLevel, ???, BP_BlackHawk_C_1?, AC_HealthAndStats_C, StatsPlus, MaxHealth
	double bossHealth: 0x765B470, 0x30, 0x98, 0x4A0, 0x340, 0xC8, 0x10;		//GWorld, PersistentLevel, ???, BP_BlackHawk_C_1?, AC_HealthAndStats_C, StatsPlus, Health
	byte cutsceneActive: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0xA22;			//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, CinematicActive
	bool notLoading: 0x762BB58;							//0 loading, 1 not - brief false positives during gameplay, this address probably needs to be replaced
	double playerX: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x128;		//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, CapsuleComponent, RelativeLocation+0
	double playerY: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x130;		//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, CapsuleComponent, RelativeLocation+8
	double playerZ: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x138;		//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, CapsuleComponent, RelativeLocation+16
	double checkpointX: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0xAC0;			//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, CurrentCheckPointXF+20
	double checkpointY: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0xAC8;			//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, CurrentCheckPointXF+28
	string200 mapFile: 0x7657930, 0xAF8, 0x0;					//GEngine, FString TransitionDescription
	double maxAmmo: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x640, 0xC8, 0x88;	//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, AC_HealthAndStats, StatsPlus, MaxAmmo
	byte accessory: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0xE2A;		//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, Accessory
	byte fur: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0xE2B;			//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, Fur
	byte clothing: 0x765B470, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0xE2C;			//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, Clothing
	string200 nutName: 0x7657930, 0x190, 0xE90, 0x1A8, 0x78, 0x508, 0x0;		//GEngine, WorldSettingsClass, ??, ??, ??, Fstring ??
}

// //Todo: Add code to detect version and add this back in
// //Older version 1.0.2.25
// state("SquirrelGun-Win64-Shipping", "1.0.2.25") {
	// double bossMaxHealth: 0x765A2F0, 0x30, 0x98, 0x4A0, 0x340, 0xC8, 0x8;	//GWorld, PersistentLevel, ???, BP_BlackHawk_C_1?, AC_HealthAndStats_C, StatsPlus, MaxHealth
	// double bossHealth: 0x765A2F0, 0x30, 0x98, 0x4A0, 0x340, 0xC8, 0x10;		//GWorld, PersistentLevel, ???, BP_BlackHawk_C_1?, AC_HealthAndStats_C, StatsPlus, Health
	// byte cutsceneActive: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0xA22;		//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, CinematicActive
	// bool notLoading: 0x762A9D8;							//0 loading, 1 not - brief false positives during gameplay, this address probably needs to be replaced
	// double playerX: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x128;	//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, CapsuleComponent, RelativeLocation+0
	// double playerY: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x130;	//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, CapsuleComponent, RelativeLocation+8
	// double playerZ: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x138;	//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, CapsuleComponent, RelativeLocation+16
	// double checkpointX: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0xAC0;		//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, CurrentCheckPointXF+20
	// double checkpointY: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0xAC8;		//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, CurrentCheckPointXF+28
	// string200 mapFile: 0x76567B0, 0xAF8, 0x0;					//GEngine, FString TransitionDescription
	// double maxAmmo: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0x640, 0xC8, 0x88;	//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, AC_HealthAndStats, StatsPlus, MaxAmmo
	// byte accessory: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0xE2A;		//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, Accessory
	// byte fur: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0xE2B;			//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, Fur
	// byte clothing: 0x765A2F0, 0x1B8, 0x38, 0x0, 0x30, 0x2E0, 0xE2C;		//GWorld, OwningGameInstance, LocalPlayers, index[0], PlayerController, Character, Clothing
	// string200 nutName: 0x76567B0, 0x190, 0xE90, 0x1A8, 0x78, 0x508, 0x0;		//GEngine, WorldSettingsClass, ??, ??, ??, Fstring ??
// }

startup {
	settings.Add("splits", false, "Optional Splits");
		settings.Add("splitBunker", false, "Split when leaving Bunker", "splits");
		settings.SetToolTip("splitBunker", "Split while loading from Bunker into Neighborhood for the first time");
		settings.Add("splitTough", false, "Split when skipping to Tough Streets", "splits");
		settings.SetToolTip("splitTough", "Split while reloading checkpoint to skip from Mean Streets to Tough Streets for the first time");
		settings.Add("splitTower", false, "Split when entering Tower", "splits");
		settings.SetToolTip("splitTower", "Split while loading from Neighborhood into Tower for the first time");
		settings.Add("splitGoldNut", false, "Split on Golden Nuts", "splits");
		settings.SetToolTip("splitGoldNut", "Split when a golden nut is collected for the first time");
			settings.Add("Top Secret Acorn", false, "Top Secret Acorn", "splitGoldNut");
			settings.Add("Hiding Underneath", false, "Hiding Underneath", "splitGoldNut");
			settings.Add("Scorching Walkway", false, "Scorching Walkway", "splitGoldNut");
			settings.Add("Polecat... Err... Polesquirrel", false, "Polecat... Err... Polesquirrel", "splitGoldNut");
			settings.Add("Tippy Top Secret Acorn", false, "Tippy Top Secret Acorn", "splitGoldNut");
			settings.Add("Brolly Bouncing", false, "Brolly Bouncing", "splitGoldNut");
			settings.Add("Jogger Stopper", false, "Jogger Stopper", "splitGoldNut");
			settings.Add("Top Shelf Prize", false, "Top Shelf Prize", "splitGoldNut");
			settings.Add("Climb And Leap To The Roof", false, "Climb And Leap To The Roof", "splitGoldNut");
			settings.Add("The Floor Is Lava", false, "The Floor Is Lava", "splitGoldNut");
			settings.Add("Crawl Space Maze", false, "Crawl Space Maze", "splitGoldNut");
			settings.Add("Top O' The Yellow House", false, "Top O' The Yellow House", "splitGoldNut");
			settings.Add("Light The Golden Gas Tank", false, "Light The Golden Gas Tank", "splitGoldNut");
			settings.Add("Flash Fried Patties", false, "Flash Fried Patties", "splitGoldNut");
			settings.Add("Chiropractor", false, "Chiropractor", "splitGoldNut");
			settings.Add("Squirrel On A Hot Tin Roof", false, "Squirrel On A Hot Tin Roof", "splitGoldNut");
			settings.Add("The Sovereign Citizen", false, "The Sovereign Citizen", "splitGoldNut");
			settings.Add("In Landmine Guy's House", false, "In Landmine Guy's House", "splitGoldNut");
			settings.Add("High In The Skate Park", false, "High In The Skate Park", "splitGoldNut");
			settings.Add("Highest In The Skate Park", false, "Highest In The Skate Park", "splitGoldNut");
			settings.Add("Gold Agents On The Road", false, "Gold Agents On The Road", "splitGoldNut");
			settings.Add("Not So Straight-And-Narrow", false, "Not So Straight-And-Narrow", "splitGoldNut");
			settings.Add("Canopy Crossing", false, "Canopy Crossing", "splitGoldNut");
			settings.Add("Under Old Management", false, "Under Old Management", "splitGoldNut");
			settings.Add("Cactupuncture", false, "Cactupuncture", "splitGoldNut");
			settings.Add("Salooney Goons", false, "Salooney Goons", "splitGoldNut");
			settings.Add("Stealing From The Till", false, "Stealing From The Till", "splitGoldNut");
			settings.Add("Party Pole", false, "Party Pole", "splitGoldNut");
			settings.Add("Certified Greek", false, "Certified Greek", "splitGoldNut");
			settings.Add("Bachelor Party", false, "Bachelor Party", "splitGoldNut");
			settings.Add("Pro Basketball", false, "Pro Basketball", "splitGoldNut");
			settings.Add("Touchdown", false, "Touchdown", "splitGoldNut");
			settings.Add("Field Goal", false, "Field Goal", "splitGoldNut");
			settings.Add("Gold Agents In The Waterway", false, "Gold Agents In The Waterway", "splitGoldNut");
			settings.Add("High-Speed Pneumatic Tube", false, "High-Speed Pneumatic Tube", "splitGoldNut");
			settings.Add("Water Ski Adventure", false, "Water Ski Adventure", "splitGoldNut");
			settings.Add("Industrial Drainage Pipeline", false, "Industrial Drainage Pipeline", "splitGoldNut");
			settings.Add("Tower Reservoir", false, "Tower Reservoir", "splitGoldNut");
			settings.Add("Gold Agents On The Highway", false, "Gold Agents On The Highway", "splitGoldNut");
			settings.Add("Truss Me", false, "Truss Me", "splitGoldNut");
			settings.Add("Sniper Squirrel", false, "Sniper Squirrel", "splitGoldNut");
			settings.Add("Water Slide Fast Pass", false, "Water Slide Fast Pass", "splitGoldNut");
			settings.Add("Rocket Jump!", false, "Rocket Jump!", "splitGoldNut");
			settings.Add("High Above The Bouncy Castle", false, "High Above The Bouncy Castle", "splitGoldNut");
			settings.Add("Bouncy Rocket Blockers", false, "Bouncy Rocket Blockers", "splitGoldNut");
			settings.Add("Rocket Ragdolls", false, "Rocket Ragdolls", "splitGoldNut");
			settings.Add("Anchor Management", false, "Anchor Management", "splitGoldNut");
			settings.Add("Rocky Smashing Squirrel", false, "Rocky Smashing Squirrel", "splitGoldNut");
			settings.Add("Jelly Jumping", false, "Jelly Jumping", "splitGoldNut");
			settings.Add("Patch O' Jack-O'-Lanterns", false, "Patch O' Jack-O'-Lanterns", "splitGoldNut");
			settings.Add("Spooky Roof", false, "Spooky Roof", "splitGoldNut");
			settings.Add("Door To The Spooky House", false, "Door To The Spooky House", "splitGoldNut");
			settings.Add("Light My Fire", false, "Light My Fire", "splitGoldNut");
			settings.Add("Resident Squirrel", false, "Resident Squirrel", "splitGoldNut");
			settings.Add("Bonking The Big Bottom Button ", false, "Bonking The Big Bottom Button ", "splitGoldNut");
			settings.Add("Hitting The Huge Higher Button", false, "Hitting The Huge Higher Button", "splitGoldNut");
		settings.Add("splitWedge", false, "Split on Ammo Wedge", "splits");
		settings.SetToolTip("splitWedge", "Split every time a reload upgrade wedge is collected");
		settings.Add("splitOutfit", false, "Split on Outfit", "splits");
		settings.SetToolTip("splitOutfit", "Split every time a new outfit piece is equipped for the first time");
			settings.Add("splitAccessory", true, "Split on Accessory", "splitOutfit");
			settings.SetToolTip("splitAccessory", "Split every time a new outfit accessory (hat) is equipped for the first time");
			settings.Add("splitClothing", true, "Split on Clothing", "splitOutfit");
			settings.SetToolTip("splitClothing", "Split every time a new Clothing (body) is equipped for the first time");
			settings.Add("splitFur", true, "Split on Fur", "splitOutfit");
			settings.SetToolTip("splitFur", "Split every time a new outfit fur is equipped for the first time");
			settings.Add("splitChipmunk", true, "Split on Chipmunk", "splitOutfit");
			settings.SetToolTip("splitChipmunk", "Split when the Chipmunk fur type is equipped the first time. This is usually the end condition of the 100% run");
				settings.Add("spamChipmunkSplit", true, "Spam Chipmunk Split", "splitChipmunk");
				settings.SetToolTip("spamChipmunkSplit", "Chipmunk split triggers repeatedly to end the timer in case there are too many splits remaining");
	settings.Add("splitFinalBoss", true, "Split final boss");
	settings.SetToolTip("splitFinalBoss", "Split when Mother's health reaches 0 in the helicopter final boss fight");
	settings.Add("spamFinalSplit", true, "Spam Final Split");
	settings.SetToolTip("spamFinalSplit", "Final split (Mother boss defeated) triggers repeatedly to end the timer in case there are too many splits remaining");
	settings.Add("experimentalLoads", false, "Experimental Load Remover");
	settings.SetToolTip("experimentalLoads", "This might not be reliable, it needs more testing to know");
	
	//declare variables. These get initialized in onStart{}
	vars.bunkerSplit = false;
	vars.toughSplit = false;
	vars.towerSplit = false;
	vars.completedNutSplits = new List<string>();
	vars.finalSplitTriggered = false;
	vars.maxAmmoCount = 0.0;
	vars.accessoryCollected = new List<byte>();
	vars.furCollected = new List<byte>();
	vars.clothingCollected = new List<byte>();
}

update {
	// //debug output for mapFile
	// if(current.mapFile != old.mapFile)
		// print("mapFile changed to: " + current.mapFile.ToString() + " from: " + old.mapFile.ToString());
}

start {
	//Start if a cutscene finished while player is at the bunker start coordinates
	return(
		old.cutsceneActive == 1 && current.cutsceneActive == 0 &&
		current.mapFile == "/Game/Maps/Bunker0" &&
		(Math.Abs(current.playerX - (199.03)) < 10.0) &&
		(Math.Abs(current.playerY - (-1.38)) < 10.0) &&
		(Math.Abs(current.playerZ - (98.39)) < 10.0)
	);
}

onStart {
	//initialize split variables
	vars.bunkerSplit = false;
	vars.toughSplit = false;
	vars.towerSplit = false;
	vars.completedNutSplits = new List<string>();
	vars.finalSplitTriggered = false;
	vars.maxAmmoCount = current.maxAmmo;
	vars.accessoryCollected = new List<byte>(){0, current.accessory};
	vars.furCollected = new List<byte>(){0, current.fur};
	vars.clothingCollected = new List<byte>(){0, current.clothing};
}

split {
	//split if the player moves from Bunker to Neighborhood
	if(settings["splitBunker"] &&
			!vars.bunkerSplit &&
			current.mapFile == "/Game/Maps/Neighborhood" &&
			old.mapFile == "/Game/Maps/Bunker0"){
		vars.bunkerSplit = true;
		print("Split for leaving Bunker");
		return true;
	}
	//split if the player reloads the checkpoint that's used to skip from Mean Streets to Tough Streets
	else if(settings["splitTough"] &&
			!vars.toughSplit &&
			current.mapFile == "/Game/Maps/Neighborhood" &&
			(Math.Abs(current.checkpointX - (1600.0)) < 1.0) &&
			(Math.Abs(current.checkpointY - (-3690.0)) < 1.0) &&
			(Math.Abs(current.playerX - current.checkpointX) < 1.0) &&
			(Math.Abs(current.playerY - current.checkpointY) < 1.0)){
		vars.toughSplit = true;
		print("Split for skipping to Tough Streets");
		return true;
	}
	//split if the player moves from Neighborhood to Tower
	else if(settings["splitTower"] &&
			!vars.towerSplit &&
			current.mapFile == "/Game/Maps/SingleMapsInGame/Bunker2/Bunker2_DroneGauntlet" &&
			old.mapFile == "/Game/Maps/Neighborhood"){
		vars.towerSplit = true;
		print("Split for entering Tower");
		return true;
	}
	//Split when collecting an ammo wedge
	else if(settings["splitWedge"] &&
			current.maxAmmo == (vars.maxAmmoCount + 25) &&
			current.notLoading)
	{
		vars.maxAmmoCount = current.maxAmmo;
		print("Split for ammo wedge. current count: " + (current.maxAmmo / 25).ToString());
		return true;
	}
	
	//Split when collecting a golden nut
	else if(!String.IsNullOrEmpty(current.nutName) && settings.ContainsKey(current.nutName) && settings["" + current.nutName] && !vars.completedNutSplits.Contains(current.nutName)){
		vars.completedNutSplits.Add(current.nutName);
		print("Split for golden nut: " + current.nutName);
		return true;
	}
	
	//Split when wearing a new accessory (hat)
	else if(settings["splitAccessory"] &&
			!vars.accessoryCollected.Contains(current.accessory) &&
			current.accessory != 0 &&
			current.notLoading)
	{
		vars.accessoryCollected.Add(current.accessory);
		print("Split for new outfit accessory. current accessory id: " + current.accessory.ToString());
		return true;
	}
	//Split when wearing a new clothing (body)
	else if(settings["splitClothing"] &&
			!vars.clothingCollected.Contains(current.clothing) &&
			current.clothing != 0 &&
			current.notLoading)
	{
		vars.clothingCollected.Add(current.clothing);
		print("Split for new outfit clothing. current clothing id: " + current.clothing.ToString());
		return true;
	}
	//Split when wearing a new fur
	else if(settings["splitFur"] &&
			!vars.furCollected.Contains(current.fur) &&
			current.fur != 0 &&
			current.notLoading)
	{
		vars.furCollected.Add(current.fur);
		print("Split for new outfit fur. current fur id: " + current.fur.ToString());
		return true;
	}
	//Split when wearing chipmunk fur for the first time
	else if(settings["splitChipmunk"] &&
			current.fur == 11 && (old.fur != 11 || settings["spamChipmunkSplit"]) &&
			current.notLoading)
	{
		print("Split for chipmunk fur. current fur id: " + current.fur.ToString());
		return true;
	}
	//split if the final boss reaches 0 health
	else if(settings["splitFinalBoss"] &&
			current.mapFile == "/Game/Maps/SingleMapsInGame/Bunker2/Bunker2_Boss" &&
			(current.bossMaxHealth == 1180) && //this is to check if health is initialized
			(current.bossHealth == 0) &&
			(!vars.finalSplitTriggered || settings["spamFinalSplit"]))
	{
		vars.finalSplitTriggered = true;
		print("Split for final boss");
		return true;
	}
}

reset {
	//Reset if player is teleported from initial loading position in Bunker to the first cutscene start position
	return(
		current.mapFile == "/Game/Maps/Bunker0" &&
		(Math.Abs(old.playerX - (199.03)) < 1.0) &&
		(Math.Abs(old.playerY - (-1.38)) < 1.0) &&
		(Math.Abs(old.playerZ - (98.39)) < 1.0) &&
		(Math.Abs(current.playerX - (36.0)) < 1.0) &&
		(Math.Abs(current.playerY - (-9.47)) < 1.0) &&
		(Math.Abs(current.playerZ - (633.48)) < 1.0)
	);
}

isLoading {
	//This load address isn't completely reliable, it needs to be replaced with a better one
	//It flips to 0 for a single update tick every now and then during gameplay
	//It seems to stay consistent during loading, although it looks like it ends slightly before loading finishes?
	//The old.notLoading check just adds a one-update buffer to double check before pausing for loads
	return(!current.notLoading && !old.notLoading && settings["experimentalLoads"]);
}
