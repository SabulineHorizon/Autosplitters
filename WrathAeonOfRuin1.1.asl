//Wrath: Aeon of Ruin Autosplitter
//Written by SabulineHorizon

//Changelog:
//Jan 24 2022 [Version 1.1]
//		Added setting to ignore duplicate splits caused by collecting a relic that has already been collected (after reloading)
//		Added check for enterSplits and exitSplits to ignore split if it is caused by reloading a checkpoint from the menu, and a setting to increase the timer for this check
//
//Jan 22 2022 [Version 1.0]
//		Initial release

state("wrath")
{
	int loading: 0x6E75BC;			//0-Loading, 10-In Game, use loadingBackup when it's neither of these
	byte loadingBackup: 0xA26358;	//0-In Game (when stablized), 1-Loading
	int menu: 0x2F3F18;				//0-Menu Open, 1-Menu Closed
	int deathMenu: 0x2E61E0;		//0-In Game, 1-Menu Open
	int level: 0x6CD3CC;			//16-Mourningvale, 1-Undercrofts, 2-Mire, 3-Hollow, 4-Gardens, 5-Priory
	int weapons: 0x52456C;			//512-None, 544-Blade, 575-All
	float relics: 0x524678;			//1-Undercrofts, 2-Mire, 4-Hollow, 8-Gardens, 16-Priory, 31-All
	
	//Mourningvale hub stones. These are activated after collecting each of the corresponding relics
	byte undercroftsStone: 0x12ECADC8, 0x38;
	byte mireStone: 0x12ECADE0, 0x38;
	byte hollowStone: 0x12ECADF8, 0x38;
	byte gardensStone: 0x12ECAE10, 0x38;
	byte prioryStone: 0x12ECAE28, 0x38;
}
state("wrath-sdl")
{
	int loading: 0x6E74BC;
	byte loadingBackup: 0x1260A524;
	int menu: 0x2F3C98;
	int deathMenu: 0x2E5F60;
	int level: 0x3F6A90;
	int weapons: 0x52446C;
	float relics: 0x524578;
	
	//Mourningvale hub stones
	byte undercroftsStone: 0x12ECACC8, 0x38;
	byte mireStone: 0x12ECACE0, 0x38;
	byte hollowStone: 0x12ECACF8, 0x38;
	byte gardensStone: 0x12ECAD10, 0x38;
	byte prioryStone: 0x12ECAD28, 0x38;
}

init{
	vars.loadingBackupFlag = 0;
	vars.relicsArray = new bool[6] { false, false, false, false, false, false };
	vars.frameTimer = 0;
}

startup
{
	settings.Add("enterSplits", false, "Split at Level Starts");
	settings.SetToolTip("enterSplits", "Split when entering a level for the first time");
		settings.Add("longTimer", true, "Fix Loading Bug", "enterSplits");
		settings.SetToolTip("longTimer", "Loading saves can cause an extra split. This fixes that bug, but can also cause a split to fail if a menu was open too recently before entering a portal");
	settings.Add("relicSplits", true, "Split at Relics");
	settings.SetToolTip("relicSplits", "Split when a relic is collected");
		settings.Add("ignoreRelicDuplicates", true, "Ignore Duplicate Relics", "relicSplits"); 
		settings.SetToolTip("ignoreRelicDuplicates", "Does not split on collecting a relic if that relic has already triggered a split. This avoids extra splits that can happen after reloads");
	settings.Add("exitSplits", false, "Split at Level Ends");
	settings.SetToolTip("exitSplits", "Split when exiting a level for the first time after collecting its relic");
		settings.Add("longTimer2", true, "Fix Loading Bug", "exitSplits");
		settings.SetToolTip("longTimer2", "Loading saves can cause an extra split. This fixes that bug, but can also cause a split to fail if a menu was open too recently before entering a portal");
	settings.Add("stoneSplits", true, " Split at Relic Stones");
	settings.SetToolTip("stoneSplits", "Split when a relic stone is triggered after collecting the corresponding relic");
		settings.Add("finalStoneSplit", true, "Last Stone Only", "stoneSplits");
		settings.SetToolTip("finalStoneSplit", "Do not split until all relic stones have been activated");
	settings.Add("other", false, "Other");
	settings.SetToolTip("other", "Other options that are not used often and might make runs invalid. Only use these if you don't care about leaderboards");
		settings.Add("pauseInHub", false, "Pause Timer in Mourningvale", "other");
		settings.SetToolTip("pauseInHub", "Pause timer while in the Mourningvale hub");
		settings.Add("pauseMenu", false, "Pause Timer While Menu Open", "other");
		settings.SetToolTip("pauseMenu", "Pause the timer while the menu is open");
		settings.Add("startAfterLoads", false, "Start Timer After Loads", "other");
		settings.SetToolTip("startAfterLoads", "After every loading screen, start the timer if it isn't already running");
		settings.Add("splitAfterLoading", false, "Split After loads", "other");
		settings.SetToolTip("splitAfterLoading", "Split once after each loading screen (Might cause issues with number of splits)");
}

start
{	
	vars.loadingBackupFlag = 0;
	bool[] relicsArray = new bool[6] { false, false, false, false, false, false};
	
	return(
		//Start if weaponless in Mourningvale
		((current.level == 16) &&
		(current.weapons == 512) &&
		(current.loading == 10) &&
		(old.loading == 0)) |
		
		//Start timer after every load screen if it isn't already running
		(settings["startAfterLoads"] &&
		old.loading == 0 &&
		current.loading == 10)
	);
}

reset
{
	//Reset if weaponless in Mourningvale
	return(
		(current.level == 16) &&
		(current.weapons == 512) &&
		(current.weapons != old.weapons)
	); 
}

update{
	if (settings["enterSplits"] | settings["exitSplits"])
	{
		//Set a rough timer to the menus to assist with stopping reloads from being triggered as start/end levels
		//There's probably a better way to handle this since it can cause bugs, but it's unlikely to be an issue, so I'm leaving it as is
		if (current.deathMenu == 1 | current.menu == 0)
		{
			if (settings["longTimer"] | settings["longTimer2"])
				vars.frameTimer = 200;
			else
				vars.frameTimer = 50;
		}
		if (vars.frameTimer > 0)
		{
			vars.frameTimer--;
			vars.menuFlag = true;
		}
		else
			vars.menuFlag = false;
	}
}

split
{
	vars.relicCollected = false;
	if ((current.relics > old.relics) && ((current.loading == 10) | (vars.loadingBackupFlag == 1)) && (current.level <= 5))
	{
		//if relic hasn't been collected at all this run, flag for split
		if (vars.relicsArray[current.level] == false)
		{
			vars.relicCollected = true;
			vars.relicsArray[current.level] = true;
		}
	}
	
	//if current.loading is working, continue as normal
	if (current.loading == 10)
	{
		vars.loadingBackupFlag = 0;
	} else if (current.loading == 0)
	{
		//Loading is in progress
		vars.loadingBackupFlag = 3;
	}
	//current.loading failed
	else
	{
		//if current.loading just now broke, start using loadingBackupFlag
		if (vars.loadingBackupFlag == 0)
		{
			vars.loadingBackupFlag = 1;
			
			//If loading just now started, prepare to split
			if (current.loadingBackup == 1)
			{
				vars.loadingBackupFlag = 2; 
			}
		}
		//if current.loading is still broken
		else if (vars.loadingBackupFlag == 1)
		{
			//If loading just now started, prepare to split
			if (current.loadingBackup == 1)
			{
				vars.loadingBackupFlag = 2;
			}
		}
		//if loadingBackupFlag already caused a split last update, end search for a new split
		else if (vars.loadingBackupFlag == 2)
		{
			
			vars.loadingBackupFlag = 3;
		}
		//else if (vars.loadingBackupFlag == 3)
		//	no need to do anything in this case
	}
	
	return (
		//Split when relic stone is activated...
		(settings["stoneSplits"] &&
		(current.level == 16) &&
		((old.undercroftsStone == 38 && current.undercroftsStone == 39) |
		(old.mireStone == 38 && current.mireStone == 39) |
		(old.hollowStone == 38 && current.hollowStone == 39) |
		(old.gardensStone == 38 && current.gardensStone == 39) |
		(old.prioryStone == 38 && current.prioryStone == 39)) &&
		
		//...but if finalStoneSplit is set, don't split unless it's the final relic
		(!settings["finalStoneSplit"] |
			((current.undercroftsStone 
			+ current.mireStone 
			+ current.hollowStone 
			+ current.gardensStone 
			+ current.prioryStone)
			== 195)
		)) |
		
		//Split when entering a portal to go from the hub into a level (loading start)
		((settings["enterSplits"]) && (old.level == 16) && (((old.loading == 10) && (current.loading == 0)) | (vars.loadingBackupFlag == 2)) && !vars.menuFlag) |
		
		//Split after every loading screen
		((settings["splitAfterLoading"]) && ((old.loading == 0) && (current.loading == 10))) |

		//Split when a relic is collected
		((settings["relicSplits"]) && (current.relics > old.relics) && ((current.loading == 10) | (vars.loadingBackupFlag == 1)) && (!settings["ignoreRelicDuplicates"] | vars.relicCollected)) |

		//Split when entering a portal to go from a level back to the hub (loading start)
		((settings["exitSplits"]) && (old.level != 16) && (((old.loading == 10) && (current.loading == 0)) | (vars.loadingBackupFlag == 2)) && !vars.menuFlag)
	);
}

isLoading{
	return(
		(current.loading == 0) |
		(settings["pauseInHub"] && current.level == 16) |
		(settings["pauseMenu"] && current.menu == 0)
	);
}