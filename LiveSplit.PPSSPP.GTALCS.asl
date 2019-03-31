/* GTA LCS Autosplitter for PPSSPP
 * Currently only supports PPSSPP v1.8.0 64-bit exe
 * and v1 American (ULUS10041) version of LCS
 * By NABN00B
 * Contributors: zazaza691
 * Testers: Fryterp23, zazaza691
 * Thanks to Patrick for early Cheat Engine advice
 * Thanks to Nick007J for "player doesn't have controls" value
 */

state("PPSSPPWindows64") //64-bit version only
{
	int missionAttempts : 0xDC8FB0, 0x8B5E1A4; //Mission Attempts Counter
	int missionsPassed : 0xDC8FB0, 0x8B5E1A8; //Missions Passed Counter (not stored in saves)
	float completionPoints : 0xDC8FB0, 0x8B5E158; //Completion Points Counter
	int hiddenPackages : 0xDC8FB0, 0x8B89AD4; //Hidden Packages Collected Counter
	int rampages: 0xDC8FB0, 0x8B5E1E4; //Rampages Passed Counter
	int uniqueStunts : 0xDC8FB0, 0x8B5E19C; //Unique Stunts Completed Counter
	int seagulls : 0xDC8FB0, 0x8B5E1FC; //Seagulls Sniped Counter
	int musicChannel : 0xDC8FB0, 0x8DCE71C; //Music Channel ID
	
	uint hasControls : 0xDC8FB0, 0x8B89D26; //track whether player has controls or not
}

startup
{
	settings.Add("mstart", false, "Mission Attempted");
	settings.Add("mpass", false, "Mission Passed");
	settings.Add("cpoint", false, "Progress Made Towards 100% Completion");
	settings.Add("package", false, "Hidden Package Collected");
	settings.Add("packno2", false, "Don't Split on First Two Packages", "package"); //Proposed by zazaza691
	settings.SetToolTip("packno2", "Provides precise Sum of Best");
	settings.Add("rpass", false, "Rampage Passed");
	settings.Add("usj", false, "Unique Stunt Completed");
	settings.Add("gull", false, "Seagull Sniped");
	settings.Add("music", false, "Music Channel Changed (Test)");
}

init
{
	vars.splitMStart = false;
}

update
{
	if (settings["mstart"])
	{
		if (current.missionsPassed > old.missionsPassed) //Check if player completed a new mission
			vars.splitMStart = true;
	}
}

start
{
	if (current.hasControls == 0 && old.hasControls == 32)
		return true;
}

split
{
	if (settings["mstart"])
	{
		//Split only if player completed a new mission AND counter is increased
		if (vars.splitMStart && current.missionAttempts > old.missionAttempts)
		{
			vars.splitMStart = false; //Must complete a mission before we can split again
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
	if (settings["package"])
	{
		if (current.hiddenPackages > old.hiddenPackages) //Split if counter is increased
		{
			if (current.hiddenPackages > 2 || !settings["packno2"]) //Don't split if it's disabled for first 2 packages
				return true;
		}
	}
	if (settings["rpass"])
	{
		if (current.rampages > old.rampages) //Split if counter is increased
			return true;
	}
	if (settings["usj"])
	{
		if (current.uniqueStunts > old.uniqueStunts) //Split if counter is increased
			return true;
	}
	if (settings["gull"])
	{
		if (current.seagulls > old.seagulls) //Split if counter is increased
			return true;
	}
	if (settings["music"])
	{
		if (current.musicChannel != old.musicChannel) //Split if value is changed
			return true;
	}
}

reset
{
	if (current.missionAttempts < old.missionAttempts && current.missionAttempts == 0) //Reset if counter is set to 0
	{
		vars.splitMStart = false;
		return true;
	}
}