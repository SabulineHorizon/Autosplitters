// People who collectively worked on this:
// DrTChops
// Glurmo
// TheFuncannon
// loitho
// sychotixx
// Instagibz
// blairmadison11
// heny
// Meta
// SabulineHorizon
// probably more

//===NOTES AND CHANGELOG===//

//Known Bugs: Auto-reset sometimes causes the timer start to fail in the intro for a classic start

//SabulineHorizon               @08\27\24:  Widened the search region for start player position to make start more reliable
//Meta & SabulineHorizon        @08\15\24:  Updated loading address, updated code logic, fixed some bugs, removed legacy code
//SabulineHorizon               @07\18\24:  Updated the splitter for 1,0,0,1 version (in progress, there are probably some bugs)
//SabulineHorizon               @08\12\21:  Added Auto-Reset, added split for Spider Mastermind Skip, fixed timer start delays, fixed optional intro split bug, fixed random intro timer starts, fixed UN start split
//Meta                          @03\08\21:  Added popup that detects real time & asks if you want game time comparison. Added livesplit cycle fix that otherwise starts timer @ 0.00 - 0.06 
//heny                          @21\08\20:  Added setting to optionally split at the end of the intro section
//heny                          @21\08\20:  Updated the splitter for the latest 6,1,1,321 version to support OpenGL + added setting to optionally split between Lazarus Labs 1 & 2
//Glurmo                        @23\01\19:  Removed steam api ("tier0_s64.dll") dependency to prevent steam client updates breaking autosplitter + Add NG+ support
//Glurmo                        @21\01\19:  Fixed map name pointer for steam update (4.89.17.15) + added skipping of rune loadscreens for 100%
//Instagibz                     @04\04\18:  Updated the splitter for latest 6,1,1,321 version, VULKAN only
//Loitho                        @13\10\17:  Fixed mapname variable. Invalid pointer caused by a steam update of the tier0_s64.dll | Works for Steam >= 4.17.60.88
//Loitho                        @09\09\17:  Fixed the splitter for auto split on last boss hit 6,1,1,818 - Vulkan only
//blairmadison11                @02\09\17:  Partially updated the splitter for the latest 6,1,1,818, VULKAN only
//Instagibz & blairmadison11    @22\07\17:  Updated the splitter for the latest 6,1,1,513 version, VULKAN only for now. Note: Versioning changed back from 6,1,1,1219 to 6,1,1,513
//Instagibz                     @29\01\17:  Updated the splitter for latest steam-api change
//Instagibz                     @20\12\16:  Updated the splitter for latest 6,1,1,1219 version, VULKAN only for now
//Instagibz                     @08\12\16:  Updated the splitter for latest 6,1,1,1201 version, VULKAN only for now
//Instagibz                     @14\11\16:  Updated the splitter for latest 6,1,1,1109 version
//Instagibz                     @19\10\16:  Updated the splitter for latest 6,1,1,1012 version
//Instagibz                     @30\09\16:  Added auto-end to 6,1,1,706 also changed auto-start, was broken for me a few times
//TheFuncannon                  @30\09\16:  Updated the OGL version 6,1,1,706 to auto-start
//Instagibz                     @30\09\16:  Updated the vulkan and OGL version 6,1,1,920 to auto-start, auto-split and auto-end the run. Requires 13 splits
//===NOTES AND CHANGELOG===//


// 2024-04-11 Patch (Vulkan)
state("DOOMx64vk", "1, 0, 0, 1") {
	float bossHealth: 0x2F60468, 0x30, 0x4E8, 0x2F0, 0x1B4;
	float playerX: 0x5BB6058;
	float playerY: 0x5BB605C;
	float playerZ: 0x5BB6060;
	// bool start: 0x597FCD0; //Removed because replacement wasn't found. Intro cutscene start now relies on player position
	bool finalHit: 0x35EB8EC;
	bool notLoading: 0x360FF58; //0 is loading, 1 is not loading
	bool menuOpen: 0x360F644;
	byte menuSelection: 0x5BE3778, 0x218, 0x2C8, 0x1B8, 0x1A4; //0-Resume, 1-Settings , 2-Load Checckpoint , 3-Restart Mission , 4-Exit to Main Menu , 5-Exit to Desktop
	byte deathReset: 0x5FA9ACA; //44 when death menu appears, and 36 when resetting
	byte difficulty: 0x5D4C9A0; //0-I'm Too Young To Die, 1-Hurt Me Plenty, 2-Ultra-Violence, 3-Nightmare 4 = Ultra-Nightmare
	int finalCutscene: 0x7068D98;
	string60 mapFile: 0x66E13B5;
}

startup {
	vars.TimerStart = (EventHandler) ((s, e) => timer.IsGameTimePaused = true);
	timer.OnStart += vars.TimerStart;
	//^ Ensures the timer starts at 0.00, thanks Gelly for this
	
	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // Pops up if real time comparison is detected, asking if you want to switch to Game Time. Thanks Micrologist for this.
	{        
		var timingMessage = MessageBox.Show (
		   "This game uses Time without Loads (Game Time) as the main timing method.\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"Would you like to set the timing method to Game Time?",
			"LiveSplit | DOOM 2016",
		   MessageBoxButtons.YesNo,MessageBoxIcon.Question
		);
	
		if (timingMessage == DialogResult.Yes)
		{
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
	
    settings.Add("optionalSplits", true, "Optional Splits (Game Version 6, 1, 1, 321 and 1, 0, 0, 1)");
    settings.Add("splitForIntro", true, "Intro", "optionalSplits");
    settings.Add("splitForLazarusLabs1", true, "Lazarus Labs 1", "optionalSplits");
    settings.Add("noCheckpointResets", false, "No checkpoint reset");
    settings.Add("spamFinalSplit", false, "Spam split on final cutscene");
    settings.SetToolTip("optionalSplits", "Optionally split for special situations/in special locations (currently only working on game version 6, 1, 1, 321)");
    settings.SetToolTip("splitForIntro", "Split when smashing the elevator button panel in the intro section");
    settings.SetToolTip("splitForLazarusLabs1", "Split at the end of the first part of Lazarus Labs");
    settings.SetToolTip("noCheckpointResets", "Do not reset the timer when reloading checkpoint at the start of Intro");
    settings.SetToolTip("spamFinalSplit", "Repeatedly trigger final split when the final cutscene starts");

    vars.visitedMapFiles = new List<string>();
    vars.introMapFile = "game/sp/intro/intro"; // UAC
    vars.mapFileSplits = new List<string>() {
        "game/sp/resource_ops/resource_ops", // Resource Operations
        "game/sp/resource_ops_foundry/resource_ops_foundry", // Foundry
        "game/sp/surface1/surface1", // Argent Facility
        "game/sp/argent_tower/argent_tower", // Argent Energy Tower
        "game/sp/blood_keep/blood_keep", // Kadingir Sanctum
        "game/sp/surface2/surface2", // Argent Facility (Destroyed)
        "game/sp/bfg_division/bfg_division", // Advanced Research Complex
        "game/sp/lazarus/lazarus", // Lazarus Labs (1)
        "game/sp/blood_keep_b/blood_keep_b", // Titan's Realm
        "game/sp/blood_keep_c/blood_keep_c", // The Necropolis
        "game/sp/polar_core/polar_core", // VEGA Central Processing
        "game/sp/titan/titan", // Argent D'Nur
    };
}

init {
    vars.hasSplitForIntro = false;
	vars.resetType = 0;
	vars.pauseStart = false;
	vars.endCutsceneCanTrigger = false;
	
    var firstModule = modules.First();
    version = firstModule.FileVersionInfo.FileVersion;
    print(version);
}

update {
	if (vars.pauseStart){
		vars.pauseStart = current.menuOpen;
	}
}

exit {
    timer.IsGameTimePaused = true;
}

start {
    vars.hasSplitForIntro = false;
    vars.visitedMapFiles = new List<string>();
	vars.pauseStart = false;
	vars.resetType = 0;
	vars.endCutsceneCanTrigger = false;

    if (settings["splitForLazarusLabs1"]) {
        vars.mapFileSplits.Add("game/sp/lazarus_2/lazarus_2");
    } else {
        vars.mapFileSplits.Remove("game/sp/lazarus_2/lazarus_2");
    }
	
	//If we're starting UN instead of another difficulty
	if (!old.notLoading && current.notLoading && (current.difficulty == 4)){
		Thread.Sleep(3560);
		return (
			(Math.Abs(current.playerX - (-10200.00)) < 1) &&
			(Math.Abs(current.playerY - (-2624.00)) < 1) &&
			(Math.Abs(current.playerZ - (9540.00)) < 6)
		);
	}
	if (
		//reload checkpoint or failed restart mission
		current.mapFile == vars.introMapFile &&
		((!old.notLoading &&
		current.notLoading &&
		(Math.Abs(current.playerX - (-18101.34)) < 2) &&
		(Math.Abs(current.playerY - (-2782.34)) < 2) &&
		(Math.Abs(current.playerZ - (3076.90)) < 2))
		|| //new game or restart mission
		(current.notLoading &&
		// !old.start &&
		// current.start &&
		(Math.Abs(current.playerX - (-18029.99)) < 2) &&
		(Math.Abs(current.playerY - (-2736.30)) < 2) &&
		(Math.Abs(current.playerZ - (3073.49)) < 2)
		)
		)
	){
		vars.pauseStart = true; //pause timer on start if menu is open during loading (usually caused by alt+tabbing during load)
		return true;
	}
}

reset {
	if (current.difficulty == 4){
		//UN difficulty
		return (
			old.deathReset == 36 &&
			current.deathReset == 44 &&
			current.mapFile == "game/sp/intro/intro"
		);
	} else {
		//Other difficulty
		if (current.menuSelection == 2){ vars.resetType = 2;}
		else if (current.menuSelection == 3){ vars.resetType = 3;}
		return (
			current.mapFile == vars.introMapFile &&
			!current.notLoading &&
			(
				(
					old.notLoading &&
					current.menuSelection == 3
				)  ||
				(
					// current.menuSelection == 2 &&
					!settings["noCheckpointResets"] &&
					(Math.Abs(current.playerX - (-18101.34)) < 2) &&
					(Math.Abs(current.playerY - (-2782.34)) < 2) &&
					(Math.Abs(current.playerZ - (3076.90)) < 2)
				)
			)
		);
	}
}

split {
	bool finalSplit = !current.finalHit && current.bossHealth == 1;
	bool levelSplit = !String.IsNullOrEmpty(current.mapFile) &&
		!String.IsNullOrEmpty(old.mapFile) &&
		old.mapFile != current.mapFile &&
		!current.notLoading &&
		!old.mapFile.Contains("challenges/") &&
		vars.mapFileSplits.Contains(current.mapFile);
	if (finalSplit) {
		return true;
	} else if (levelSplit && !vars.visitedMapFiles.Contains(current.mapFile)) {
		// Track to prevent splitting twice in 100%
		vars.visitedMapFiles.Add(current.mapFile);
		return true;
	}  else if (current.mapFile == "game/sp/intro/intro") {
		if (!vars.hasSplitForIntro && settings["splitForIntro"]) { // Optional intro split when smashing the panel
			bool inUAC = current.mapFile.Equals("game/sp/intro/intro");
			bool correctIntroSplitXPos = Math.Abs(current.playerX - (-10152.54)) < 0.1;
			bool correctIntroSplitYPos = Math.Abs(current.playerY - (-2685.575)) < 0.1;
			bool correctIntroSplitZPos = Math.Abs(current.playerZ - 3148.311) < 0.1;
			bool correctIntroSplitPos = correctIntroSplitXPos && correctIntroSplitYPos && correctIntroSplitZPos;

			if (inUAC && correctIntroSplitPos) {
				vars.hasSplitForIntro = true;
				return true;
			}
		}
	} else if (current.mapFile == "game/sp/titan/titan") {
		//Spider Mastermind Skip
		if (
			(current.playerX > -80) &&
			(current.playerX < 215) &&
			(current.playerY > -80) &&
			(current.playerY < 215) &&
			(current.playerZ > -10080) &&
			(current.playerZ < -9800) &&
			(current.finalCutscene == 5) &&
			(old.finalCutscene != 5)
		){
			vars.endCutsceneCanTrigger = true;
		}
		//Trigger final split
		if (vars.endCutsceneCanTrigger) {
			if(!settings["spamFinalSplit"])
				vars.endCutsceneCanTrigger = false;
			return true;
		}
	} else if (!current.notLoading && vars.endCutsceneCanTrigger) {vars.endCutsceneCanTrigger = false;}

	return false;
}

isLoading { return (!current.notLoading | vars.pauseStart); }

shutdown{
    timer.OnStart -= vars.TimerStart;
}
