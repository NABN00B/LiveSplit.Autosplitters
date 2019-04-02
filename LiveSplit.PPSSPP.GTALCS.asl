/* GTA Liberty City Stories Autosplitter for PPSSPP
 * Currently only supports PPSSPP v1.8.0 64-bit executable
 * and v1 American (ULUS10041) version of LCS
 * Made by NABN00B and zazaza691
 * Testers: Fryterp23
 * Thanks to Powdinet for Rampage State values and address finding advice,
 * Nick007J for Control Lock values and Patrick for early Cheat Engine advice
 */

state("PPSSPPWindows64") //64-bit version only
{
	uint controlLock : 0xDC8FB0, 0x8B89D26; //Player Control Lock (bit field), values in hex below
	//0x0: no lock, 0x4: locked by garage service, 0x20: locked by mission script, 0xA0: locked by cinematic cutscene
	int onMissionFlag : 0xDC8FB0, 0x9F6C4C0; //OnMission Flag ($560)
	int missionAttempts : 0xDC8FB0, 0x8B5E1A4; //Mission Attempts Counter
	int missionsPassed : 0xDC8FB0, 0x8B5E1A8; //Missions Passed Counter (not stored in saves)
	float completionPoints : 0xDC8FB0, 0x8B5E158; //Completion Points Counter
	
	int finalBossDefeated : 0xDC8FB0, 0x9F6FD2C; //The Sicilian Gambit Helicopter Boss Defeated
	
	int hiddenPackagesFound : 0xDC8FB0, 0x8B89AD4; //Hidden Packages Collected Counter (text only)
	int rampageState : 0xDC8FB0, 0x8B5E45C; //Rampage State, 1: On Rampage, 2: Rampage Passed, 3: Rampage Failed
	int rampagesPassed : 0xDC8FB0, 0x8B5E1E4; //Rampages Passed Counter (text only)
	int uniqueStuntsCompleted : 0xDC8FB0, 0x8B5E19C; //Unique Stunts Completed Counter (text only)
	int currentIsland : 0xDC8FB0, 0x8B5E354; //Current Island, 1: Portland, 2: Staunton, 3: Shoreside, 4: Subway
	
	int seagullsSniped : 0xDC8FB0, 0x8B5E1FC; //Seagulls Sniped Counter
	int outfitChanges : 0xDC8FB0, 0x8B5E30C; //Outfit Changes Counter
	int musicChannel : 0xDC8FB0, 0x8DCE71C; //Music Channel ID (overwriting has no effect)
}

startup
{
	refreshRate = 1000/30; //Reduce CPU usage
	
	settings.Add("s_main", true, "Main Splits");
	settings.Add("mstart", true, "Mission Start", "s_main");
	settings.SetToolTip("mstart", "Splits when the Mission Attempts counter is increased, but only if the Missions Passed counter is increased between two attempts.");
	settings.Add("mpass", false, "Mission Pass", "s_main");
	settings.SetToolTip("mpass", "Splits when the Missions Passed counter is increased.");
	settings.Add("cpoint", false, "100% Completion Progress", "s_main");
	settings.SetToolTip("cpoint", "Splits when the Completion Points counter is increased.");
	
	settings.Add("s_collect", false, "Collectibles");
	settings.Add("c_package", false, "Hidden Package Collection", "s_collect");
	settings.SetToolTip("c_package", "Splits when the Hidden Packages Found counter is increased.");
	settings.Add("c_packno2", false, "Don't Split on First Two Packages", "c_package"); //Proposed by zazaza691
	settings.SetToolTip("c_packno2", "Prevents splitting on the first two Hidden Packages. Helps to avoid fake best times using the 49:53 route.");
	settings.Add("c_rstart", false, "Rampage Start", "s_collect");
	settings.SetToolTip("c_rstart", "Splits when the Rampage State is set to 1, but only if the Rampages Passed counter is increased between two attempts.");
	settings.Add("c_rpass", false, "Rampage Pass", "s_collect");
	settings.SetToolTip("c_rpass", "Splits when the Rampages Passed counter is increased.");
	settings.Add("c_usj", false, "Unique Stunt Completion", "s_collect");
	settings.SetToolTip("c_usj", "Splits when the Unique Stunts Completed counter is increased.");
	settings.Add("c_island", false, "Next Island", "s_collect");
	settings.SetToolTip("c_island", "Splits on the loading screen when entering Staunton Island from Portland, or Shoreside Vale from Staunton Island.");
	
	settings.Add("s_final", false, "Final Splits");
	settings.Add("f_anyfin", false, "Any% Final Split", "s_final");
	settings.SetToolTip("f_anyfin", "Splits when the player loses control after defeating the final boss.");
	settings.Add("f_ighundo", false, "Ingame 100% Final Split", "s_final");
	settings.SetToolTip("f_ighundo", "Splits when the Completion Points counter goes above 170 for the first time.");
	
	settings.Add("s_memes", false, "Memes");
	settings.Add("m_gull", false, "Seagull Snipe", "s_memes");
	settings.SetToolTip("m_gull", "Splits when the Seagulls Sniped counter is increased.");
	settings.Add("m_outfit", false, "Outfit Change", "s_memes");
	settings.SetToolTip("m_outfit", "Splits when the Outfit Changes counter is increased.");
	settings.Add("m_music", false, "Music Channel Change (PoC)", "s_memes");
	settings.SetToolTip("m_music", "Splits when the Music Channel is changed. Can be used through the Pause Menu to test if the autosplitter is working.");
}

init
{
	vars.splitMissionStart = false;
	vars.splitRampageStart = true;
}

update
{
	if (settings["mstart"])
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

split
{
	if (settings["mstart"])
	{
		//Split only if player completed a new mission AND counter is increased
		if (vars.splitMissionStart && current.missionAttempts > old.missionAttempts)
		{
			vars.splitMissionStart = false; //Must complete a new mission before we can split again
			return true;
		}
	}
	if (settings["mpass"])
	{
		if (current.missionsPassed > old.missionsPassed) //Split if counter is increased
			return true;
	}
	if (settings["cpoint"])
	{
		if (current.completionPoints > old.completionPoints) //Split if counter is increased
			return true;
	}
	
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
		if (vars.splitRampageStart && current.rampageState == 1 && old.rampageState != 1)
		{
			vars.splitRampageStart = false; //Must complete a new rampage before we can split again
			return true;
		}
	}
	if (settings["c_rpass"])
	{
		if (current.rampagesPassed > old.rampagesPassed) //Split if counter is increased
			return true;
	}
	if (settings["c_usj"])
	{
		if (current.uniqueStuntsCompleted > old.uniqueStuntsCompleted) //Split if counter is increased
			return true;
	}
	if (settings["c_island"])
	{
		//Split if entering Staunton Island from Portland, or Shoreside Vale from Staunton Island
		if ((current.currentIsland == 2 && old.currentIsland == 1) || (current.currentIsland == 3 && old.currentIsland == 2))
			return true;
	}
	
	if (settings["f_anyfin"])
	{
		//Split if control is locked by cutscene and final boss is defeated.
		if (current.finalBossDefeated == 1 && current.controlLock == 32 && old.controlLock == 0 && current.onMissionFlag == 1)
			return true;
	}
	if (settings["f_ighundo"])
	{
		if (current.completionPoints > 170 && old.completionPoints < 171) //Split if counter goes above 170 for the first time
			return true;
	}
	
	if (settings["m_gull"])
	{
		if (current.seagullsSniped > old.seagullsSniped) //Split if counter is increased
			return true;
	}
	if (settings["m_outfit"])
	{
		if (current.outfitChanges > old.outfitChanges) //Split if counter is increased
			return true;
	}
	if (settings["m_music"])
	{
		if (current.musicChannel != old.musicChannel) //Split if value is changed
			return true;
	}
}

reset
{
	if (current.missionAttempts == 0 && current.controlLock == 160) //Reset if counter is set to 0 and control is locked by cutscene
	{
		vars.splitMissionStart = false;
		vars.splitRampageStart = true;
		return true;
	}
}

start
{
	//Start if player gains control during the first mission
	if (current.onMissionFlag == 1 && current.missionAttempts == 1 && current.controlLock == 0 && old.controlLock == 32)
		return true;
}
