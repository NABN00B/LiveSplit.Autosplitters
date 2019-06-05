/* GTA Liberty City Stories Autosplitter for PPSSPP
 *   Made by NABN00B with help from zazaza691
 * Currently supports:
 *   PPSSPP: v1.8.0 64-bit executable (ONLY)
 *   GTA LCS: v1 American (ULUS10041) UMD version (ONLY)
 * Thanks to:
 *   Fryterp23 for continuous testing
 *   iguana for the idea of splitting when mission titles get displayed
 *   Nick007J for Control Lock values
 *   Patrick for early Cheat Engine advice
 *   Powdinet for Rampage State values and variable/address finding advice
 */

state("PPSSPPWindows64") //64-bit version only
{
	int gameLoading : 0xDC8FB0, 0x8B9289C; //Game Loading Flag
	uint controlLock : 0xDC8FB0, 0x8B89D26; //Player Control Lock (bit field), values below
	//0 (0x0): no lock, 4 (0x4): locked by garage service, 32 (0x20): locked by mission script, 160 (0xA0): locked by cinematic cutscene
	int onMissionFlag : 0xDC8FB0, 0x9F6C4C0; //OnMission Flag ($560)
	
	string64 missionTitle : 0xDC8FB0, 0x8B91310; //Current Mission Title
	int missionAttempts : 0xDC8FB0, 0x8B5E1A4; //Mission Attempts Counter
	int missionsPassed : 0xDC8FB0, 0x8B5E1A8; //Missions Passed Counter (not stored in saves: be careful when comparing!)
	float completionPoints : 0xDC8FB0, 0x8B5E158; //Completion Points Counter
	
	int finalBossDefeated : 0xDC8FB0, 0x9F6FD2C; //The Sicilian Gambit Helicopter Boss Defeated ($4171)
	int missionSalvatoreSSV : 0xDC8FB0, 0x9F6C2F8; //Salvatore Leone Shoreside Mission Chain Counter ($446)
	int missionMaria : 0xDC8FB0, 0x9F6BFF4; //Maria Mission Chain Counter ($253)
	
	int hiddenPackagesFound : 0xDC8FB0, 0x9F6C4C4; //Hidden Packages Found Counter (reset and updated after loading a save: be careful when comparing!)
	int rampageState : 0xDC8FB0, 0x8B5E45C; //Rampage State, 1: On Rampage, 2: Rampage Passed, 3: Rampage Failed
	int rampagesPassed : 0xDC8FB0, 0x9F6E4B0; //Rampages Passed Counter (reset and updated after loading a save: be careful when comparing!)
	int uniqueStuntsCompleted : 0xDC8FB0, 0x9F6CCD8; //Unique Stunts Completed Counter (reset and updated after loading a save: be careful when comparing!)
	int vehiclesDelivered : 0xDC8FB0, 0x8E41658; //Cars found for Love Media Counter (reset and updated after loading a save: be careful when comparing!)
	
	int seagullsSniped : 0xDC8FB0, 0x8B5E1FC; //Seagulls Sniped Counter
	int outfitChanges : 0xDC8FB0, 0x8B5E30C; //Outfit Changes Counter
	int currentIsland : 0xDC8FB0, 0x8B5E354; //Current Island, 1: Portland, 2: Staunton, 3: Shoreside, 4: Subway
	int musicChannel : 0xDC8FB0, 0x8DCE71C; //Music Channel ID (overwriting has no effect)
	
	//NOT USED IN THIS VERSION
	/*
	string textOutput : 0xDC8FB0, 0x8B79C4C; //Last Text Output
	*/
}

startup
{
	refreshRate = 1000/30; //Reduce CPU usage
	
	settings.Add("s_main", true, "Main Splits");
	settings.Add("m_mtitle", true, "Mission Title Displayed", "s_main");
	settings.SetToolTip("m_mtitle", "Splits when the Mission Title variable changes, but only if the Missions Passed counter is increased between two attempts.");
	settings.Add("m_mattempt", false, "Mission Attempted", "s_main");
	settings.SetToolTip("m_mattempt", "Splits when the Mission Attempts counter is increased, but only if the Missions Passed counter is increased between two attempts.");
	settings.Add("m_mpass", false, "Mission Passed", "s_main");
	settings.SetToolTip("m_mpass", "Splits when the Missions Passed counter is increased.");
	settings.Add("m_cpoint", false, "100% Completion Progress Made", "s_main");
	settings.SetToolTip("m_cpoint", "Splits when the Completion Points counter is increased.");
	
	settings.Add("s_final", true, "Final Splits");
	settings.Add("f_anyfin", true, "Any% Final Split", "s_final");
	settings.SetToolTip("f_anyfin", "Splits when the player loses control after defeating the final boss.");
	settings.Add("f_tsg", false, "The Sicilian Gambit Passed", "s_final");
	settings.SetToolTip("f_tsg", "Splits when the Salvatore Leone Shoreside Mission Chain Counter goes above 5.");
	settings.Add("f_oot", false, "Overdose of Trouble Passed", "s_final");
	settings.SetToolTip("f_oot", "Splits when the Maria Mission Chain Counter goes above 5.");
	settings.Add("f_ighundo", false, "Ingame 100% Final Split", "s_final");
	settings.SetToolTip("f_ighundo", "Splits when the Completion Points counter goes above 170.");
	
	settings.Add("s_collect", false, "Collectibles");
	settings.Add("c_package", false, "Hidden Package Collected", "s_collect");
	settings.SetToolTip("c_package", "Splits when the Hidden Packages Found counter is increased.");
	settings.Add("c_packno2", false, "Don't Split on First Two Packages", "c_package");
	settings.SetToolTip("c_packno2", "Prevents splitting on the first two Hidden Packages. Helps to avoid fake best times using the 49:53 route.");
	settings.Add("c_rstart", false, "Rampage Started", "s_collect");
	settings.SetToolTip("c_rstart", "Splits when the Rampage State is set to 1, but only if the Rampages Passed counter is increased between two attempts.");
	settings.Add("c_rpass", false, "Rampage Passed", "s_collect");
	settings.SetToolTip("c_rpass", "Splits when the Rampages Passed counter is increased.");
	settings.Add("c_usj", false, "Unique Stunt Completed", "s_collect");
	settings.SetToolTip("c_usj", "Splits when the Unique Stunts Completed counter is increased.");
	settings.Add("c_export", false, "Vehicle Delivered", "s_collect");
	settings.SetToolTip("c_export", "Splits when the Cars found for Love Media counter is increased.");
	
	settings.Add("s_misc", false, "Miscellaneous");
	settings.Add("o_gull", false, "Seagull Sniped", "s_misc");
	settings.SetToolTip("o_gull", "Splits when the Seagulls Sniped counter is increased.");
	settings.Add("o_outfit", false, "Outfit Changed", "s_misc");
	settings.SetToolTip("o_outfit", "Splits when the Outfit Changes counter is increased.");
	settings.Add("o_island", false, "Next Island Reached", "s_misc");
	settings.SetToolTip("o_island", "Splits on the loading screen when entering Staunton Island from Portland, or Shoreside Vale from Staunton Island. Useful for collectible runs.");
	settings.Add("o_music", false, "Music Channel Changed (PoC)", "s_misc");
	settings.SetToolTip("o_music", "Splits when the Music Channel is changed. Can be used through the Pause Menu to test if the autosplitter is working.");
	
	settings.Add("s_lgsp", true, "Load Game Split Prevention");
	settings.SetToolTip("s_lgsp", "Prevents splitting when loading a save file or restarting the game.");
	
	//Initialise autosplitter script variables
	vars.splitPrevention = true;
	vars.splitMissionStart = false;
	vars.splitRampageStart = false;
}

init { }

exit
{
	if (settings["s_lgsp"])
		vars.splitPrevention = true;
}

update
{
	if (settings["s_lgsp"])
	{
		if (current.gameLoading == 1 && old.gameLoading == 0) //Enable Split Prevention if game is loading
			vars.splitPrevention = true;
	}
	if (vars.splitPrevention) //Check if Split Prevention is active
	{
		//Disable Split Prevention if player gains control after loading save or if control is taken away by cutscene (during first mission)
		if ((current.controlLock == 0 && old.controlLock == 32) || current.controlLock == 160)
			vars.splitPrevention = false;
		return false;
	}
	else
	{
		if (settings["m_mtitle"] || settings["m_mattempt"])
		{
			if (current.missionsPassed > old.missionsPassed) //Check if player completed a new mission
				vars.splitMissionStart = true;
		}
		if (settings["c_rstart"])
		{
			if (current.rampagesPassed > old.rampagesPassed) //Check if player completed a new rampage
				vars.splitRampageStart = true;
		}
	}
}

split
{
	//FINAL SPLITS
	if (settings["f_anyfin"])
	{
		//Split if final boss is defeated and control is locked by cutscene
		if (current.finalBossDefeated == 1 && current.controlLock == 32 && old.controlLock == 0 && current.missionSalvatoreSSV == 5 && current.onMissionFlag == 1)
			return true;
	}
	if (settings["f_tsg"])
	{
		if (current.missionSalvatoreSSV >= 6 && old.missionSalvatoreSSV <= 5) //Split if counter goes above 5 for the first time
			return true;
	}
	if (settings["f_oot"])
	{
		if (current.missionMaria >= 6 && old.missionMaria <= 5) //Split if counter goes above 5 for the first time
			return true;
	}
	if (settings["f_ighundo"])
	{
		if (current.completionPoints >= 171 && old.completionPoints <= 170) //Split if counter goes above 170 for the first time
			return true;
	}
	
	//MAIN SPLITS
	if (settings["m_mtitle"])
	{
		//Split only if player completed a new mission AND mission title is updated
		if (current.missionTitle != old.missionTitle && vars.splitMissionStart)
		{
			vars.splitMissionStart = false; //Must complete a new mission before we can split again
			return true;
		}
	}
	if (settings["m_mattempt"])
	{
		//Split only if player completed a new mission AND counter is increased
		if (current.missionAttempts > old.missionAttempts && vars.splitMissionStart)
		{
			vars.splitMissionStart = false; //Must complete a new mission before we can split again
			return true;
		}
	}
	if (settings["m_mpass"])
	{
		if (current.missionsPassed > old.missionsPassed) //Split if counter is increased
			return true;
	}
	if (settings["m_cpoint"])
	{
		if (current.completionPoints > old.completionPoints) //Split if counter is increased
			return true;
	}
	
	//COLLECTIBLES
	if (settings["c_package"])
	{
		if (current.hiddenPackagesFound > old.hiddenPackagesFound) //Split if counter is increased
		{
			if (current.hiddenPackagesFound > 2 || !settings["c_packno2"]) //Don't split if it's disabled for first 2 packages
				return true;
		}
	}
	if (settings["c_rstart"])
	{
		//Split only if player completed a new rampage AND Rampage State is set to 1
		if (current.rampageState == 1 && old.rampageState != 1 && vars.splitRampageStart)
		{
			vars.splitRampageStart = false; //Must complete a new rampage before we can split again
			return true;
		}
	}
	if (settings["c_rpass"])
	{
		if (current.rampagesPassed > old.rampagesPassed && current.rampageState == 2) //Split if counter is increased and rampage is passed
			return true;
	}
	if (settings["c_usj"])
	{
		if (current.uniqueStuntsCompleted > old.uniqueStuntsCompleted) //Split if counter is increased
			return true;
	}
	if (settings["c_export"])
	{
		if (current.vehiclesDelivered > old.vehiclesDelivered) //Split if counter is increased
			return true;
	}
	
	//MISCELLANEOUS
	if (settings["o_gull"])
	{
		if (current.seagullsSniped > old.seagullsSniped) //Split if counter is increased
			return true;
	}
	if (settings["o_outfit"])
	{
		if (current.outfitChanges > old.outfitChanges) //Split if counter is increased
			return true;
	}
	if (settings["o_island"])
	{
		//Split if entering Staunton Island from Portland, or Shoreside Vale from Staunton Island
		if ((current.currentIsland == 2 && old.currentIsland == 1) || (current.currentIsland == 3 && old.currentIsland == 2))
			return true;
	}
	if (settings["o_music"])
	{
		if (current.musicChannel != old.musicChannel) //Split if value is changed
			return true;
	}
}

reset
{
	if (current.missionAttempts == 0 && current.controlLock == 160) //Reset if counter is set to 0 and control is locked by cutscene
		return true;
}

start
{
	//Start if player gains control during the first mission
	if (current.controlLock == 0 && old.controlLock == 32 && current.missionAttempts == 1 && current.onMissionFlag == 1)
	{
		vars.splitPrevention = false;
		vars.splitMissionStart = false;
		vars.splitRampageStart = true;
		return true;
	}
}
