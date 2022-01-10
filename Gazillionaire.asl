//Gazillionaire Autosplitter
//Written by SabulineHorizon
//Jan 10 2022 - Version 1.0

state("Gazillionaire"){
	//Normal Calculations
	double netWorth: "Adobe AIR.dll", 0x012F9810, 0xC8, 0xC8, 0x3C0; //Only updates at the end/start of each week
	byte currentScene: "Adobe AIR.dll", 0x012F9800, 0x830, 0x4E0, 0x8, 0xE08; //For details, see comment block at bottom
	
	//Alternate Calculations
	double cash: "Adobe AIR.dll", 0x012F9810, 0xC8, 0xC8, 0x370;
	double bank: "Adobe AIR.dll", 0x012F9810, 0xC8, 0xC8, 0x3D0;
	double unionLoan: "Adobe AIR.dll", 0x012F9810, 0xC8, 0xC8, 0x3A8;
	double zinnLoan: "Adobe AIR.dll", 0x012F9810, 0xC8, 0xC8, 0x430;
}

startup{
	settings.Add("splitEveryMillion", true, "Split Every Million");
	settings.SetToolTip("splitEveryMillion", "Split every time the player's Net Worth reaches another million");

	settings.Add("wreeee", false, "WREEEE");
	settings.SetToolTip("wreeee", "All splits are delayed until the player visits Zinn");

	settings.Add("alternateCalculations", false, "Use Alternate Net Worth Calculations (Incomplete)");
	settings.SetToolTip("alternateCalculations", "Calculate net worth instead of reading the game's Net Worth variable. This can be unreliable");

	settings.Add("splitDuringWeek", false, "Split During Week", "alternateCalculations");
	settings.SetToolTip("splitDuringWeek", "Don't wait for the current week to end before splitting. This uses alternate calculations and can be unreliable");

	settings.Add("includedData", true, "Included Data", "alternateCalculations");
	settings.SetToolTip("includedData", "Detailed choice of values to include in the alternate calculations");

	settings.Add("includeCash", true, "Include Cash", "includedData");
	settings.SetToolTip("includeCash", "Include current cash in Net Worth calculations");

	settings.Add("includeBank", true, "Include Bank", "includedData");
	settings.SetToolTip("includeBank", "Include current bank balance in Net Worth calculations");

	settings.Add("includeUnionLoan", true, "Include Union Loan", "includedData");
	settings.SetToolTip("includeUnionLoan", "Include Trader's Union loan in Net Worth calculations");

	settings.Add("includeZinnLoan", true, "Include Zinn's Loan", "includedData");
	settings.SetToolTip("includeZinnLoan", "Include Zinn's loan in Net Worth calculations");

	settings.Add("includeStocks", true, "Include Stocks (Not implemented yet)", "includedData");
	settings.SetToolTip("includeStocks", "This doesn't work. Stocks cannot currently be included in the alternate calculations");
}

init{
	vars.goalFirstDigit = 0.0;
	vars.goalMultiplier = 10000000.0;
	vars.currentGoal = 5000000.0;
	vars.nextMillion = 1000000.0;
	vars.splitFlag = 0;
	vars.alternateNetWorth = 0;
}

start{
	vars.goalFirstDigit = 0.0;
	vars.goalMultiplier = 10000000.0;
	vars.currentGoal = 5000000.0;
	vars.nextMillion = 1000000.0;
	vars.splitFlag = 0;
	vars.alternateNetWorth = 0;
	return old.currentScene == 14 && current.currentScene != 14;
}

update{
	if (settings["alternateCalculations"])
	{
		vars.oldAlternateNetWorth = vars.alternateNetWorth;
		if (settings["includeCash"]){vars.alternateNetWorth = current.cash;}
			else {vars.alternateNetWorth = 0;}
		if (settings["includeBank"]){vars.alternateNetWorth += current.bank;}
		if (settings["includeUnionLoan"]){vars.alternateNetWorth -= current.unionLoan;}
		if (settings["includeZinnLoan"]){vars.alternateNetWorth -= current.zinnLoan;}
		if (settings["includeStocks"]){/*Cannot use stocks in alternate calculations yet*/}
	}
}

split{
	//Normal Calculations
	if (!settings["alternateCalculations"])
	{
		//if game netWorth changes (this happens between weeks)
		if (current.netWorth != old.netWorth)
		{
			//if we have passed the previous goal and aren't duplicating splits with splitEveryMillion
			if (current.netWorth >= vars.currentGoal)
			{
				//set next goal
				if (vars.goalFirstDigit > 9.0)
				{
					vars.goalFirstDigit = 1.0;
					vars.goalMultiplier *= 10;
				}
				vars.goalFirstDigit++;
				vars.currentGoal = vars.goalFirstDigit * vars.goalMultiplier;
				if (!settings["splitEveryMillion"])
				{
					vars.splitFlag++;
				}
			}
		}
		
		//if past a million and settings support it
		if (settings["splitEveryMillion"] && current.netWorth >= vars.nextMillion)
		{
			vars.nextMillion += 1000000.0;
			vars.splitFlag++;
		}
		
		//if one or more splits are in the queue
		if(vars.splitFlag > 0)
		{
			//if a victory/split screen is open
			if ((current.currentScene == 30 && settings["wreeee"]) | (current.currentScene == 14 && !settings["wreeee"]))
			{
				vars.splitFlag--;
				return true;
			}
		}
	}
	else //Alternate Calculations (These aren't as reliable, but they're included for flexibility)
	{
		//if game netWorth changes (this happens between weeks)
		if (vars.alternateNetWorth != vars.oldAlternateNetWorth)
		{
			//if we have passed the previous goal and aren't duplicating splits with splitEveryMillion
			if (vars.alternateNetWorth >= vars.currentGoal)
			{
				//set next goal
				if (vars.goalFirstDigit > 9.0)
				{
					vars.goalFirstDigit = 1.0;
					vars.goalMultiplier *= 10;
				}
				vars.goalFirstDigit++;
				vars.currentGoal = vars.goalFirstDigit * vars.goalMultiplier;
				if (!settings["splitEveryMillion"])
				{
					vars.splitFlag++;
				}
			}
		}
		
		//if past a million and settings support it
		if (settings["splitEveryMillion"] && vars.alternateNetWorth >= vars.nextMillion)
		{
			vars.nextMillion += 1000000.0;
			vars.splitFlag++;
		}
		
		//if one or more splits are in the queue
		if(vars.splitFlag > 0)
		{
			//if a victory screen is open
			if ((current.currentScene == 30 && settings["wreeee"]) | (current.currentScene == 14 && !settings["wreeee"]) | settings["splitDuringWeek"] && (!settings["wreeee"] | current.currentScene == 30))
			{
				vars.splitFlag--;
				return true;
			}
		}
	}
}

reset{
	//Triggers when player first enters the New Game/Difficulty screen
	return (current.currentScene == 9 && old.currentScene != 9);
}

/*
byte currentScene: "Adobe AIR.dll", 0x012F9800, 0x830, 0x4E0, 0x8, 0xE08;

This is a list of the pages that eacy of the values correlates with
Some of the pages are still unknown
Known pages are listed below:

1 - Intro Splash Screen
2 - 
3 - 
4 - Main Menu
5 - About LavaMind
6 - About Zapitalism
7 - About Profitania
8 - About Gazillionaire
9 - New Game (Difficulty)
10 - Player Count
11 - Planet Setup
12 - Competitors Info
13 - Customize Company
14 - Start/Next Turn
15 - Victory
16 - News Victory
17 - Continue After Victory?
18 - 
19 - Economic Event
20 - 
21 - Planet Splash Screen
22 - 
23 - Net Worth/Market Strength Graphs
24 - Main Planet Screen
25 - Stock Exchange
26 - Money
27 - Ship Info
28 - Bank
29 - Union Loan
30 - Zinn's Loan
31 - Marketplace
32 - Supply
33 - Warehouse
34 - Passengers
35 - Advertise
36 - Crew
37 - Taxes
38 - Insurance
39 - Explore Planet
40 - Special
41 - Weather
42 - News
43 - Time
44 - About Planet
45 - File Options
46 - Save Game
47 - Load Game
48 - Shortcuts
49 - Gas
50 - Planets Chart
51 - Distance Chart/Facilities Chart
52 - Bankrupt
53 - News Bankrupt
54 - 
55 - Travel
56 - Opportunity Event
57 - Competetor Event
*/