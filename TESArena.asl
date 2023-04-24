//Autosplitter for The Elder Scrolls: Arena
//Written by SabulineHorizon

state("DosBox")
{
    byte menuScreen	 		: "DosBox.exe", 0x193A1A0, 0x4CF21; //61 when on menu, 1 in most other places
	byte traveling 			: "DosBox.exe", 0x34B728; //0 no, 32 yes
	byte camping			: "DosBox.exe", 0x1FFDBE0; //162 camp screen open
	byte dreaming			: "DosBox.exe", 0x1915628; //34 when playing dream cutscene
	byte staffPieces		: "DosBox.exe", 0x193A1A0, 0x3E3A7; //1-9
	byte fetchQuestDone		: "DosBox.exe", 0x193A1A0, 0x3E3AD; //1 found, 0 not found
	int frameCounter		: "DosBox.exe", 0x193A1A0, 0x4A0EC; //Increases while not in a menu
	string50 location		: "DosBox.exe", 0x193A1A0, 0x3DE52; //Current player location
	string50 targetLocation		: "DosBox.exe", 0x193A1A0, 0x3ED59; //Selected travel target location on map
}

startup
{
	//Split on travel
	settings.Add("splitOnTravel", true, "Split On Travel");
	settings.SetToolTip("splitOnTravel", "Split when travel screen appears if conditions are met");
	
		settings.Add("travelPrison", true, "Leaving Prison", "splitOnTravel");
		settings.SetToolTip("travelPrison", "Split when traveling away from the Imperial Dungeons");
	
		settings.Add("travelToDungeonStaff", true, "To Dungeon For Staff Piece", "splitOnTravel");
		settings.SetToolTip("travelToDungeonStaff", "Split when traveling to a dungeon for a staff piece");
	
		settings.Add("travelFromDungeonStaff", true, "From Dungeon After Staff Piece", "splitOnTravel");
		settings.SetToolTip("travelFromDungeonStaff", "Split when traveling away from a dungeon after collecting a staff piece");
	
		settings.Add("travelToDungeonFetch", true, "To Dungeon For Fetch Quest", "splitOnTravel");
		settings.SetToolTip("travelToDungeonFetch", "Split when traveling to a dungeon for a fetch quest item");
	
		settings.Add("travelFromDungeonFetch", true, "From Dungeon After Fetch Quest", "splitOnTravel");
		settings.SetToolTip("travelFromDungeonFetch", "Split when traveling away from a dungeon after collecting a fetch quest item");
	
	//Split on dreams
	settings.Add("splitOnDream", false, "Split On Dreams");
	settings.SetToolTip("splitOnDream", "Split when dreams appear if conditions are met");
	
		settings.Add("dreamCreation", true, "After Character Creation", "splitOnDream");
		settings.SetToolTip("dreamCreation", "Split on dream after character creation");
	
		settings.Add("dreamTwo", true, "After Level Two", "splitOnDream");
		settings.SetToolTip("dreamTwo", "Split on dream after reaching level two");
	
		settings.Add("dreamStaff", true, "After Staff Pieces", "splitOnDream");
		settings.SetToolTip("dreamStaff", "Split on dream after collecting a staff piece");
		
	//Split on quest items
	settings.Add("splitOnQuestItem", false, "Split On Quest Items");
	settings.SetToolTip("splitOnQuestItem", "Split when quest items are collected");
	
		settings.Add("questItemStaff", true, "Staff Pieces", "splitOnQuestItem");
		settings.SetToolTip("questItemStaff", "Split when a staff piece is collected");
	
		settings.Add("questItemFetch", true, "Fetch Quests", "splitOnQuestItem");
		settings.SetToolTip("questItemFetch", "Split when a Fetch Quest item is collected");
		
	//Additional splits
	settings.Add("additionalSplits", true, "Additional Splits");
	settings.SetToolTip("additionalSplits", "Additional optional splits");
	
		settings.Add("characterCreation", false, "Character Creation Split", "additionalSplits");
		settings.SetToolTip("characterCreation", "Split when the Imperial Dungeons start, after character creation");
	
		settings.Add("leavingPrison", false, "Leaving Prison", "additionalSplits");
		settings.SetToolTip("leavingPrison", "Split when leaving the Imperial Dungeons");
		
		settings.Add("spamFinalSplit", true, "Spam Final Split", "additionalSplits");
		settings.SetToolTip("spamFinalSplit", "Once the final split triggers, it will keep triggering until the timer stops in case some splits were missed");
}

init
{
	// initialize flag variables
	vars.creationFlag = false;			// used to check if end-of-character-creation split has ended yet
	vars.gameStartedFlag = false;			// used to check if gameplay has started yet
	vars.prisonEndFlag = false;			// used to check if end-of-prison split has happened yet
	vars.travelFlag = false;			// used to check if travel is allowed to trigger splits
	vars.travelToQuestFlag = false;			// used to check if travel to a quest location is allowed to trigger splits
	vars.dreamsFlag = false;			// used to check if dreams are allowed to trigger splits
	vars.questItemFlag = false;				// used to check if a quest item has been collected
	vars.questLocationSelected = false;		// used to check if travel target is a quest location
	vars.sleepOrTravelFlag = false;			// used to avoid travel false positives when sleeping
	vars.finalSplitFlag = false;			// triggers the final split immediately
	
	vars.dungeonList = new List<string>() {
		"Stonekeep",
		"Fang Lair",
		"Fortress of Ice",
		"Labrynthian",
		"Selene's Web",
		"Elden Grove",
		"Temple of Agamanus",
		"Halls of Colossus",
		"Temple of Mad God",
		"Crystal Tower",
		"Mines of Khuras",
		"Crypt of Hearts",
		"Vaults of Gemin",
		"Murkwood",
		"Black Gate",
		"Dagoth-Ur",
		"Imperial City"
	};
}

start
{
	//Timer starts if menuScreen changed from 61 to something else
	//There will be false positives when loading a saved game
	return (
		(old.menuScreen == 61) &&
		(current.menuScreen != 61)
	);
}

onStart
{
	// initialize variables
	vars.creationFlag = false;
	vars.gameStartedFlag = false;
	vars.prisonEndFlag = false;
	vars.travelFlag = false;
	vars.travelToQuestFlag = false;
	vars.dreamsFlag = false;
	vars.questItemFlag = false;
	vars.questLocationSelected = false;
	vars.sleepOrTravelFlag = false;
	vars.finalSplitFlag = false;
	
	//Set flags for post-prison splits
	if(settings["travelPrison"] || settings["dreamTwo"] || settings["leavingPrison"]) vars.prisonEndFlag = true;
	
	//Set flags for post-character creation splits
	if(settings["characterCreation"]) vars.creationFlag = true;
	if(settings["dreamCreation"]) vars.dreamsFlag = true;
}

update
{
	//Set flag once the Imperial Dungeons start after character creation is finished
	if(!vars.gameStartedFlag)
		if((current.frameCounter > old.frameCounter))
		vars.gameStartedFlag = true;
	
	if(vars.prisonEndFlag)
	{
		//if prison loaded, it's now safe to set travelFlag and dreamFlag
		if(vars.gameStartedFlag) //check if prison loaded
		{
			if(settings["travelPrison"]) vars.travelFlag = true;
			if(settings["dreamTwo"]) vars.dreamsFlag = true;
			if(!settings["leavingPrison"]) vars.prisonEndFlag = false;
		}
	}
	
	
	//Keep track of which was opened more recently, camp or map. This is to avoid false positives during dreams
	//targetLocation is always cleared when opening world map, so player can't travel without changing targetLocation
	if(current.camping == 162) //opened camping menu
		vars.sleepOrTravelFlag = false;
	if(current.targetLocation != old.targetLocation) //selected a travel destination
		vars.sleepOrTravelFlag = true;
	
	//Keep track of whether a quest location is selected or not
	if(current.targetLocation != old.targetLocation)
	{
		if(vars.dungeonList.Contains(current.targetLocation))
			vars.questLocationSelected = true;
		else
			vars.questLocationSelected = false;
	}
	
	//Travel to a quest dungeon to get a staff piece
	if(settings["travelToDungeonStaff"] && vars.questLocationSelected && (current.fetchQuestDone == 1))
		vars.travelToQuestFlag = true;
	//Travel to a quest dungeon for a fetch quest
	else if(settings["travelToDungeonFetch"] && vars.questLocationSelected && (current.fetchQuestDone == 0))
		vars.travelToQuestFlag = true;
	else
		vars.travelToQuestFlag = false;
	
	//Travel from a dungeon after getting a staff piece
	//if staffPieces is increased
	if (settings["travelFromDungeonStaff"] && current.staffPieces > old.staffPieces)
		vars.travelFlag = true;
	
	//Travel from a dungeon after a fetch quest
	if (settings["travelFromDungeonFetch"] && current.fetchQuestDone > old.fetchQuestDone)
		vars.travelFlag = true;
	
	//Dream after getting a staff piece
	if (settings["dreamStaff"] && current.staffPieces > old.staffPieces)
		vars.dreamsFlag = true;
	
	//Collected a staff piece
	if (settings["questItemStaff"] && current.staffPieces > old.staffPieces)
		vars.questItemFlag = true;

	//Collected a fetch quest item
	if (settings["questItemFetch"] && (current.fetchQuestDone > old.fetchQuestDone))
		vars.questItemFlag = true;
	
	//Final split
	if((current.staffPieces == 9) && (old.staffPieces != 9))
	{
		vars.finalSplitFlag = true;
	}
	
	// print("staffPieces is:");
	// print(current.staffPieces.ToString());
}

split
{
	//if traveling starts while flagged
	if((old.traveling != 32) &&
		(current.traveling == 32) &&		//travel animation started
		vars.gameStartedFlag &&			//Avoids false positive on first dream after character creation
		vars.sleepOrTravelFlag &&		//Avoids other false positives from dreams
		(vars.travelFlag || vars.travelToQuestFlag)){ //Conditions for a split have been met
			print("TRAVELING SPLIT\n");
			vars.travelFlag = false;
			return true;}
	//if dreaming starts while flagged
	else if((old.dreaming != 34) && (current.dreaming == 34) && vars.dreamsFlag){
		print("DREAMING SPLIT\n");
		vars.dreamsFlag = false;
		return true;}
	//if character creation ends while flagged
	else if(vars.gameStartedFlag && vars.creationFlag){
		print("CHARACTER CREATION END SPLIT\n");
		vars.creationFlag = false;
		return true;}
	//if quest item was collected
	else if(vars.questItemFlag){ 
		print("QUEST ITEM COLLECTED SPLIT\n");
		vars.questItemFlag = false;
		return true;}
	//if leaving prison while flagged
	else if((old.location == "Imperial Dungeons") && (current.location != "Imperial Dungeons") && vars.prisonEndFlag && vars.gameStartedFlag){
		print("LEAVING PRISON SPLIT\n");
		vars.prisonEndFlag = false;
		return true;}
	//final split, collected everything
	else if(vars.finalSplitFlag){
		print("FINAL SPLIT\n");
		if(!settings["spamFinalSplit"]) vars.finalSplitFlag = false;
		return true;
	}
}

reset
{
	// Timer resets if menuScreen gets set to 61
	// There will be false positives if starting the game after crash or using main menu to load a saved game
	return (
		(old.menuScreen != 61) &&
		(current.menuScreen == 61)
	);
}

onReset
{
	// initialize variables
	vars.creationFlag = false;
	vars.gameStartedFlag = false;
	vars.prisonEndFlag = false;
	vars.travelFlag = false;
	vars.travelToQuestFlag = false;
	vars.dreamsFlag = false;
	vars.questItemFlag = false;
	vars.questLocationSelected = false;
	vars.sleepOrTravelFlag = false;
	vars.finalSplitFlag = false;
}
