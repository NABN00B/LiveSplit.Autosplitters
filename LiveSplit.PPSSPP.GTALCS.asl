//GTA LCS Autosplitter Test for PPSSPP v1.8.0 64-bit
//Only tested with v1 American (ULUS10041)
//By NABN00B
//Thanks to Patrick

state("PPSSPPWindows64") //64-bit version
{
	int hp : 0xDC8FB0, 0x09F6C4C4; //Collected Hidden Packages Counter
	int rs : 0xDC8FB0, 0x08dce71c; //Music Channel ID
}

startup
{
	settings.Add("hp", true, "Hidden Package Collected");
/*	settings.Add("rs", false, "Music Channel Changed (Test)");  disabled by zazaza691*/
}

split
{
	if (settings["hp"])
	{
		if (current.hp < 3) //don't split on the first two packages (by zazaza691)
			return false;
		if (current.hp > old.hp) //Split if counter is increased
			return true;
	}
/*	if (settings["rs"])
	{
		if (current.rs != old.rs) //Split if music ID is changed
			return true;
	} disabled by zazaza691*/
}

reset
{
	if (current.hp < old.hp)
		return true;
}
