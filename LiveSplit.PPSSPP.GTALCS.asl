/* GTA LCS Autosplitter for PPSSPP
 * Currently only supports PPSSPP v1.8.0 64-bit exe
 * and v1 American (ULUS10041) version of LCS
 * By NABN00B
 * Contributors: zazaza691
 * Testers: Fryterp23, zazaza691
 * Thanks to Patrick for early Cheat Engine advice
 */

state("PPSSPPWindows64") //64-bit version only
{
	int missionAttempts : 0xDC8FB0, 0x08B5E1A4; //Mission Attempts Counter
	int missionPassed : 0xDC8FB0, 0x08B5E1A8; //Mission Passed Counter (not stored in saves)
	float completionProgress : 0xDC8FB0, 0x08B5E158; //100% Completion Progress Points Counter
	int hiddenPackages : 0xDC8FB0, 0x8B89AD4; //Hidden Packages Collected Counter
	int musicChannel : 0xDC8FB0, 0x08DCE71C; //Music Channel ID
}

startup
{
	settings.Add("ma", false, "Mission Attempted");
	settings.Add("mp", false, "Mission Passed");
	settings.Add("cp", false, "Progress Made Towards 100% Completion");
	settings.Add("hp", false, "Hidden Package Collected");
	settings.Add("hpno2", false, "Don't Split on First Two Packages", "hp"); //Proposed by zazaza691
	settings.SetToolTip("hpno2", "Provides precise Sum of Best");
	settings.Add("mc", false, "Music Channel Changed (Test)");
}

init
{
	vars.prevMissionCount = 0;
	vars.newMissionCount = 0;
}

update
{
	if (settings["ma"])
	{
		if (current.missionPassed > old.missionPassed) //Check if player completed a new mission
		{
			vars.prevMissionCount = vars.newMissionCount;
			vars.newMissionCount++;
		}
	}
}

split
{
	if (settings["ma"])
	{
		//Split only if player completed a new mission AND counter is increased
		if (vars.prevMissionCount != vars.newMissionCount && current.missionAttempts > old.missionAttempts)
		{
			vars.prevMissionCount = vars.newMissionCount;
			return true;
		}
	}
	if (settings["mp"])
	{
		if (current.missionPassed > old.missionPassed) //Split if counter is increased
			return true;
	}
	if (settings["cp"])
	{
		if (current.completionProgress > old.completionProgress) //Split if counter is increased
			return true;
	}
	if (settings["hp"])
	{
		if (current.hiddenPackages > old.hiddenPackages) //Split if counter is increased
		{
			if (settings["hpno2"] && current.hiddenPackages < 3) //Don't split if it's disabled for first 2 packages
				return false;
			return true;
		}
	}
	if (settings["mc"])
	{
		if (current.musicChannel != old.musicChannel) //Split if value is changed
			return true;
	}
}

reset
{
	if (current.missionAttempts < old.missionAttempts && current.missionAttempts == 0) //Reset if counter is set to 0
	{
		vars.prevMissionCount = 0;
		vars.newMissionCount = 0;
		return true;
	}
}