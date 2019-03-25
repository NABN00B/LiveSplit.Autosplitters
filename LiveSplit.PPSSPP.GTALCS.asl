//GTA LCS Autosplitter for PPSSPP v1.8.0 64-bit
//Only tested with v1 American (ULUS10041)
//By NABN00B
//Thanks to Patrick

state("PPSSPPWindows64") //64-bit version
{
	int missionAttempts : 0xDC8FB0, 0x08b5e1a4; //Mission Attempts Counter
	int missionPassed : 0xDC8FB0, 0x08b5e1a8; //Mission Passed Counter
	int hiddenPackages : 0xDC8FB0, 0x09F6C4C4; //Hidden Packages Collected Counter
	int musicChannel : 0xDC8FB0, 0x08dce71c; //Music Channel ID
}

startup
{
	settings.Add("ma", false, "Mission Attempted");
	settings.Add("mp", false, "Mission Passed");
	settings.Add("hp", false, "Hidden Package Collected");
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
	if (settings["hp"])
	{
		//to provide precise Sum of Best (SoB) we start splitting from the third package
		if (current.hiddenPackages < 3)
			return false;
		if (current.hiddenPackages > old.hiddenPackages) //Split if counter is increased
			return true;
	}
	if (settings["mc"])
	{
		if (current.musicChannel != old.musicChannel) //Split if music ID is changed
			return true;
	}
}

reset
{
	if (current.missionAttempts < old.missionAttempts) //Reset if counter is set to 0
	{
		vars.prevMissionCount = 0;
		vars.newMissionCount = 0;
		return true;
	}
}