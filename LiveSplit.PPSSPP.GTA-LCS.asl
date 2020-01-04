/*	GTA Liberty City Stories Autosplitter (2020.01.04.)
 *		Made by NABN00B
 *		https://github.com/DavidTamas/LiveSplit.Autosplitters
 *	Currently supports:
 * 		PPSSPP: 64-bit executable, v1.4 and later, standard or Gold
 *		GTA LCS: v1 (MAIN.SCM from 12/10/2005) American (serial ULUS10041) UMD (disc) version ONLY
 *	Contributors: zazaza691
 *	Testers: Fryterp23, PowerSlaveAlfons
 *	Thanks to:
 *		Nick007J for Control Lock values,
 *		Parik for emulator version detection via signature scanning,
 *		Patrick for early Cheat Engine advice,
 *		Powdinet for Rampage State values and telling me how to find offsets of global MAIN.SCM variables,
 *		iguana, KZ_FREW, pitp0, tduva and zoton2 for their previous work
 *			on autosplitters for other GTA titles and solutions that inspired this code
 */

// 64-bit exe only
state("PPSSPPWindows64", "unknown") { }
state("PPSSPPWindows64", "detected") { }


startup
{
	// INITIAL SETUP
	// Reduce CPU usage
	refreshRate = 1000/30;
	
	// Initialise variables used for emulator version control
	version = "unknown";
	vars.EmulatorVersion = "unknown";
	vars.OffsetToGame = 0x0;
	
	// Initialise variables used in autosplitter logic
	vars.PrevTimerPhase = null;
	vars.SplitPrevention = false;
	vars.SplitMissionStart = false;
	vars.SplitRampageStart = true;
	
	// Initialise debug output functions
	Action<string, IntPtr> DebugOutputSigScan = (source, ptr) =>
	{
		print(String.Format("{0} {1}\n{0} ResultPointer: 0x{2:X}", "[GTA LCS Autosplitter]", source, (long)ptr));
	};
	vars.DebugOutputSigScan = DebugOutputSigScan;
	Action<string> DebugOutputVersion = (source) =>
	{
		print(String.Format("{0} {1}\n{0} EmulatorVersion: {2}, OffsetToGame: 0x{3:X}, (StateDescriptor: {4})", "[GTA LCS Autosplitter]", source, vars.EmulatorVersion, vars.OffsetToGame, version));
	};
	vars.DebugOutputVersion = DebugOutputVersion;
	Action<string> DebugOutputVars = (source) =>
	{
		print(String.Format("{0} {1}\n{0} SplitPrevention: {2}\n{0} SplitMissionStart: {3}\n{0} SplitRampageStart: {4}\n", "[GTA LCS Autosplitter]", source, vars.SplitPrevention.ToString(), vars.SplitMissionStart.ToString(), vars.SplitRampageStart.ToString()));
	};
	vars.DebugOutputVars = DebugOutputVars;
	// INITIAL SETUP END
	
	// SETTINGS
	settings.Add("MT", true, "Mission Title Displayed");
	settings.SetToolTip("MT", "Splits when a Mission Title gets displayed, but only if the Missions Passed Counter is increased between two attempts.");
	settings.Add("MP", false, "Mission Passed");
	settings.SetToolTip("MP", "Splits when the Missions Passed Counter increases.");
	
	settings.Add("COLL", false, "Collectibles");
	settings.Add("COLL_PACK", false, "Hidden Package Collected", "COLL");
	settings.SetToolTip("COLL_PACK", "Splits when the Hidden Packages Collected Counter increases.");
	settings.Add("COLL_PACK_NO2", false, "Don't Split on First Two Packages", "COLL_PACK");
	settings.SetToolTip("COLL_PACK_NO2", "Prevents splitting on the first two Hidden Packages. Helps to avoid fake splits using the 48:59 route.");
	settings.Add("COLL_RAMPS", false, "Rampage Started", "COLL");
	settings.SetToolTip("COLL_RAMPS", "Splits when the Rampage State changes to 1, but only if the Rampages Passed Counter is increased between two attempts.");
	settings.Add("COLL_RAMPP", false, "Rampage Completed", "COLL");
	settings.SetToolTip("COLL_RAMPP", "Splits when the Rampages Completed Counter increases.");
	settings.Add("COLL_USJ", false, "Unique Stunt Completed", "COLL");
	settings.SetToolTip("COLL_USJ", "Splits when the Unique Stunts Completed Counter increases.");
	
	settings.Add("FIN", true, "Final Splits");
	settings.Add("FIN_ANY", true, "Any% Final Split", "FIN");
	settings.SetToolTip("FIN_ANY", "Splits when the player loses control after defeating the final boss.");
	settings.Add("FIN_SALH5", false, "The Sicilian Gambit Passed", "FIN");
	settings.SetToolTip("FIN_SALH5", "Splits when the Salvatore Leone Shoreside Mission Chain Counter goes above 5.");
	settings.Add("FIN_MAR5", false, "Overdose of Trouble Passed", "FIN");
	settings.SetToolTip("FIN_MAR5", "Splits when the Maria Mission Chain Counter goes above 5.");
	settings.Add("FIN_IGHUNDO", false, "Ingame 100% Final Split", "FIN");
	settings.SetToolTip("FIN_IGHUNDO", "Splits when the Completion Points Counter goes above 170.");
	settings.Add("FIN_PACK", false, "All Hidden Packages Final Split", "FIN");
	settings.SetToolTip("FIN_PACK", "Splits when the Hidden Packages Collected Counter goes above 99.");
	settings.Add("FIN_99PACK", false, "99/100 Hidden Packages Final Split", "FIN");
	settings.SetToolTip("FIN_99PACK", "Splits when the Hidden Packages Collected Counter goes above 98.");
	settings.Add("FIN_RAMP", false, "All Rampages Final Split", "FIN");
	settings.SetToolTip("FIN_RAMP", "Splits when the Rampages Completed Counter goes above 19.");
	settings.Add("FIN_USJ", false, "All Unique Stunts Final Split", "FIN");
	settings.SetToolTip("FIN_USJ", "Splits when the Unique Stunts Completed Counter goes above 25.");
	settings.Add("FIN_25USJ", false, "25/26 Unique Stunts Final Split", "FIN");
	settings.SetToolTip("FIN_25USJ", "Splits when the Unique Stunts Completed Counter goes above 24.");
	settings.Add("FIN_EXPORT", false, "All Import/Export Vehicles Final Split", "FIN");
	settings.SetToolTip("FIN_EXPORT", "Splits when the player delivers the last Import/Export Vehicle.");
	
	settings.Add("MISC", false, "Miscellaneous");
	settings.Add("MISC_ISLAND", false, "Next Island Reached", "MISC");
	settings.SetToolTip("MISC_ISLAND", "Splits on the loading screen when entering Staunton Island from Portland, or Shoreside Vale from Staunton Island. Useful for segmenting collectible runs.");
	settings.Add("MISC_GULL", false, "Seagull Snipe% Final Split", "MISC");
	settings.SetToolTip("MISC_GULL", "Splits when the Seagulls Sniped Counter goes above 0.");
	
	settings.Add("MISC_OBS", false, "Obsolete", "MISC");
	settings.Add("MISC_OBS_MA", false, "Mission Attempted", "MISC_OBS");
	settings.SetToolTip("MISC_OBS_MA", "Splits when the Mission Attempts Counter increases, but only if the Missions Passed Counter is increased between two attempts.");
	settings.Add("MISC_OBS_PERC", false, "Completion Percentage Awarded", "MISC_OBS");
	settings.SetToolTip("MISC_OBS_PERC", "Splits when the Completion Points Counter increases.");
	
	settings.Add("LGSP", true, "'Load Game' Split Prevention (Recommended)");
	settings.SetToolTip("LGSP", "Prevents splitting when loading a save file or restarting the game.");
	settings.Add("STARTT", false, "Start Timer upon Displaying a Mission Title");
	settings.SetToolTip("STARTT", "Starts the timer when a Mission Title gets displayed. Useful for segment practice.");
	// SETTINGS END
}

init
{
	// EMULATOR VERSION CONTROL
	////vars.DebugOutputVersion("INIT - DETECTING EMULATOR VERSION...");
	// Scan for the signature of `static int sceMpegRingbufferAvailableSize(u32 ringbufferAddr)` to get the address that's 22 bytes off the instruction that accesses the memory pointer
	var page = modules.First();
    var scanner = new SignatureScanner(game, page.BaseAddress, page.ModuleMemorySize);
    IntPtr ptr = scanner.Scan(new SigScanTarget(22, "41 B9 ?? 05 00 00 48 89 44 24 20 8D 4A FC E8 ?? ?? ?? FF 48 8B 0D ?? ?? ?? 00 48 03 CB"));
	////vars.DebugOutputSigScan("INIT - BASE OFFSET SIGSCAN", ptr);
	
	if (ptr != IntPtr.Zero)
	{
		vars.OffsetToGame = (int) ((long)ptr - (long)page.BaseAddress + game.ReadValue<int>(ptr) + 0x4);
		version = "detected";
		vars.EmulatorVersion = modules.First().FileVersionInfo.FileVersion;
	}
	else
	{
		// Switch to manual version detection if the signature scan fails
		switch (modules.First().FileVersionInfo.FileVersion)	
		{
			// Add new versions to the top
			case "v1.9.3": version = "detected"; vars.EmulatorVersion = "v1.9.3" ; vars.OffsetToGame = 0xD8C010; break;
			case "v1.9"  : version = "detected"; vars.EmulatorVersion = "v1.9"   ; vars.OffsetToGame = 0xD8AF70; break;
			case "v1.8.0": version = "detected"; vars.EmulatorVersion = "v1.8.0" ; vars.OffsetToGame = 0xDC8FB0; break;
			case "v1.7.4": version = "detected"; vars.EmulatorVersion = "v1.7.4" ; vars.OffsetToGame = 0xD91250; break;
			case "v1.7.1": version = "detected"; vars.EmulatorVersion = "v1.7.1" ; vars.OffsetToGame = 0xD91250; break;
			case "v1.7"  : version = "detected"; vars.EmulatorVersion = "v1.7"   ; vars.OffsetToGame = 0xD90250; break;
			default      : version = "unknown" ; vars.EmulatorVersion = "unknown"; vars.OffsetToGame = 0x0     ; break;
		}
	}
	////vars.DebugOutputVersion("INIT - EMULATOR VERSION DETECTED");
	// EMULATOR VERSION CONTROL END
	
	// MEMORY WATCHERS
	if (vars.EmulatorVersion != "unknown")
	{
		vars.MemoryWatchers = new MemoryWatcherList();
		vars.ExportWatchers = new MemoryWatcherList();
		
		// Game Variables, General
		vars.MemoryWatchers.Add(new MemoryWatcher<float>(new DeepPointer(vars.OffsetToGame, 0x8B5E158)) { Name = "CompletionPoints" });
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x8B5E354)) { Name = "CurrentIsland" });
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x8B5E45C)) { Name = "RampageState" });
		vars.MemoryWatchers.Add(new MemoryWatcher<uint>(new DeepPointer(vars.OffsetToGame, 0x8B89D26)) { Name = "PlayerControlLock" });
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x8B9289C)) { Name = "GameLoadingFlag" });
		
		// Game Variables, Statistics
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x8B5E1A4)) { Name = "MissionAttemptsCounter" });
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x8B5E1A8)) { Name = "MissionsPassedCounter" });
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x8B5E1FC)) { Name = "SeagullsSnipedCounter" });
		
		// Game Variables, Output
		vars.MemoryWatchers.Add(new StringWatcher(new DeepPointer(vars.OffsetToGame, 0x8B91310), 64) { Name = "CurrentMissionTitle" });
		
		// MAIN.SCM Variables, General
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x9F6C4C0)) { Name = "OnMissionFlag" });
		
		// MAIN.SCM Variables, Mission Chains
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x9F6BFF4)) { Name = "MariaMissionChainCounter" });
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x9F6C2F8)) { Name = "SalvatoreLeoneShoresideMissionChainCounter" });
		
		// MAIN.SCM Variables, Story Missions
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x9F6FD2C)) { Name = "TheSicilianGambit_HelicopterBossDefeated" });
		
		// MAIN.SCM Variables, Collectibles
		for (int i = 0; i < 16; i++)
			vars.ExportWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x9F6C294 + 4 * i)));
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x9F6C4C4)) { Name = "HiddenPackagesCollected" });
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x9F6CCD8)) { Name = "UniqueStuntsCompleted" });
		vars.MemoryWatchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.OffsetToGame, 0x9F6E4B0)) { Name = "RampagesCompleted" });
	}
	// MEMORY WATCHERS END
}

exit
{
	// Activate the Split Prevention Mechanism if it's enabled in settings
	if (settings["LGSP"])
		vars.SplitPrevention = true;
	
	// Set emulator version to unrecognised
	version = "unknown";
	vars.EmulatorVersion = "unknown";
	vars.OffsetToGame = 0x0;
	
	////vars.DebugOutputVersion("EXIT");
	////vars.DebugOutputVars("EXIT");
}

update
{
	// Reset script variables when the timer is reset, so we don't need to rely on the start action in this script
	if (timer.CurrentPhase != vars.PrevTimerPhase)
	{
		if (timer.CurrentPhase == TimerPhase.NotRunning)
		{
			vars.SplitPrevention = false;
			vars.SplitMissionStart = false;
			vars.SplitRampageStart = true;
			////vars.DebugOutputVars("UPDATE - RESET VARS");
		}
		vars.PrevTimerPhase = timer.CurrentPhase;
	}
	
	// Prevent undefined functionality if emulator version is not recognised
	if (vars.EmulatorVersion == "unknown")
	{
		////vars.DebugOutputVersion("UNKNOWN EMULATOR VERSION");
		return false;
	}
	
	// Update Memory Watchers to get the new values of the emulator/game variables
	vars.MemoryWatchers.UpdateAll(game);
	vars.ExportWatchers.UpdateAll(game);
	
	// Update script variables
	if (settings["MT"] || settings["MISC_OBS_MA"])
	{
		// Reactivate splitting on the start of a mission when the Missions Passed Counter increases
		if (vars.MemoryWatchers["MissionsPassedCounter"].Current > vars.MemoryWatchers["MissionsPassedCounter"].Old)
		{
			vars.SplitMissionStart = true;
			////vars.DebugOutputVars("UPDATE - SET VARS");
		}
	}
	if (settings["COLL_RAMPS"])
	{
		// Reactivate splitting on the start of a rampage when the Rampages Completed counter increases
		if (vars.MemoryWatchers["RampagesCompleted"].Current > vars.MemoryWatchers["RampagesCompleted"].Old)
		{
			vars.SplitRampageStart = true;
			////vars.DebugOutputVars("UPDATE - SET VARS");
		}
	}
	
	// SPLIT PREVENTION MECHANISM
	// This is far from foolproof, but it works for now
	// Activate the Split Prevention Mechanism if the game is loading
	if (settings["LGSP"])
	{
		if (vars.MemoryWatchers["GameLoadingFlag"].Current == 1 && vars.MemoryWatchers["GameLoadingFlag"].Old == 0)
		{
			vars.SplitPrevention = true;
			////vars.DebugOutputVars("UPDATE - LGSP");
		}
	}
	
	// Deactivate the Split Prevention Mechanism if player gains control after loading save or if control is taken away by cutscene (during first mission)
	if (vars.SplitPrevention)
	{
		if ((vars.MemoryWatchers["PlayerControlLock"].Current == 0 && vars.MemoryWatchers["PlayerControlLock"].Old == 32) || vars.MemoryWatchers["PlayerControlLock"].Current == 160)
		{
			vars.SplitPrevention = false;
			////vars.DebugOutputVars("UPDATE - LGSP");
		}
	}
	// SPLIT PREVENTION MECHANISM END
}

split
{
	// Prevent further functionality if the Split Prevention Mechanism is active
	if (vars.SplitPrevention)
		return false;
	
	// FINAL SPLITS
	if (settings["FIN_ANY"])
	{
		// Split when the player loses control after defeating the final boss
		if (vars.MemoryWatchers["TheSicilianGambit_HelicopterBossDefeated"].Current == 1 && vars.MemoryWatchers["PlayerControlLock"].Current == 32 &&  vars.MemoryWatchers["PlayerControlLock"].Old == 0 && vars.MemoryWatchers["SalvatoreLeoneShoresideMissionChainCounter"].Current == 5 && vars.MemoryWatchers["OnMissionFlag"].Current == 1)
			return true;
	}
	
	if (settings["FIN_SALH5"])
	{
		// Split when the Salvatore Leone Shoreside Mission Chain Counter goes above 5 for the first time
		if (vars.MemoryWatchers["SalvatoreLeoneShoresideMissionChainCounter"].Current >= 6 && vars.MemoryWatchers["SalvatoreLeoneShoresideMissionChainCounter"].Old <= 5)
			return true;
	}
	
	if (settings["FIN_MAR5"])
	{
		// Split when the Maria Mission Chain Counter goes above 5 for the first time
		if (vars.MemoryWatchers["MariaMissionChainCounter"].Current >= 6 && vars.MemoryWatchers["MariaMissionChainCounter"].Old <= 5)
			return true;
	}
	
	if (settings["FIN_IGHUNDO"])
	{
		// Split when Completion Points counter goes above 170 for the first time
		if (vars.MemoryWatchers["CompletionPoints"].Current >= 171 && vars.MemoryWatchers["CompletionPoints"].Old <= 170)
			return true;
	}
	
	if (settings["FIN_PACK"])
	{
		 // Split when the Hidden Packages Collected counter goes above 99 for the first time
		if (vars.MemoryWatchers["HiddenPackagesCollected"].Current >= 100 && vars.MemoryWatchers["HiddenPackagesCollected"].Old <= 99)
			return true;
	}
	
	if (settings["FIN_99PACK"])
	{
		 // Split when the Hidden Packages Collected counter goes above 98 for the first time
		if (vars.MemoryWatchers["HiddenPackagesCollected"].Current >= 99 && vars.MemoryWatchers["HiddenPackagesCollected"].Old <= 98)
			return true;
	}
	
	if (settings["FIN_RAMP"])
	{
		// Split when the Rampages Completed counter goes above 19 for the first time when a rampage is passed
		if (vars.MemoryWatchers["RampagesCompleted"].Current >= 20 && vars.MemoryWatchers["RampagesCompleted"].Old <= 19 && vars.MemoryWatchers["RampageState"].Current == 2)
			return true;
	}
	
	if (settings["FIN_USJ"])
	{
		// Split when the Unique Stunts Completed counter goes above 25 for the first time
		if (vars.MemoryWatchers["UniqueStuntsCompleted"].Current >= 26 && vars.MemoryWatchers["UniqueStuntsCompleted"].Old <= 25)
			return true;
	}
	
	if (settings["FIN_25USJ"])
	{
		// Split when the Unique Stunts Completed counter goes above 24 for the first time
		if (vars.MemoryWatchers["UniqueStuntsCompleted"].Current >= 25 && vars.MemoryWatchers["UniqueStuntsCompleted"].Old <= 24)
			return true;
	}
	
	if (settings["FIN_EXPORT"])
	{
		// Split when all elements of the Import/Export Vehicles Delivered Array go above 0 for the first time
		MemoryWatcherList vehicleDeliveries = vars.ExportWatchers;
		try
		{
			if (vehicleDeliveries.All(delivery => (int)delivery.Current >= 1) && !vehicleDeliveries.All(delivery => (int)delivery.Old >= 1))
				return true;
		}
		catch (System.NullReferenceException) { }
	}
	// FINAL SPLITS END
	
	// MAIN SPLITS
	if (settings["MT"])
	{
		// Split when the Current Mission Title changes but only if the Missions Passed Counter is increased between two attempts
		if (vars.MemoryWatchers["CurrentMissionTitle"].Current != String.Empty && vars.MemoryWatchers["CurrentMissionTitle"].Old == String.Empty && vars.SplitMissionStart)
		{
			// Deactivate splitting for the next attempt
			vars.SplitMissionStart = false;
			////vars.DebugOutputVars("SPLIT - SET VARS");
			return true;
		}
	}
	
	if (settings["MP"])
	{
		// Split when the Missions Passed Counter increases
		if (vars.MemoryWatchers["MissionsPassedCounter"].Current > vars.MemoryWatchers["MissionsPassedCounter"].Old)
			return true;
	}
	// MAIN SPLITS END
	
	// COLLECTIBLES
	if (settings["COLL_PACK"])
	{
		// Split when the Hidden Packages Collected counter increases
		if (vars.MemoryWatchers["HiddenPackagesCollected"].Current > vars.MemoryWatchers["HiddenPackagesCollected"].Old)
		{
			// Check if splitting is disabled for the first two packages
			if (vars.MemoryWatchers["HiddenPackagesCollected"].Current > 2 || !settings["COLL_PACK_NO2"])
				return true;
		}
	}
	
	if (settings["COLL_RAMPS"])
	{
		// Split when a rampage is started but only if the Rampages Completed Counter is increased between two attempts
		if (vars.MemoryWatchers["RampageState"].Current == 1 && vars.MemoryWatchers["RampageState"].Old != 1 && vars.SplitRampageStart)
		{
			// Deactivate splitting for the next attempt
			vars.SplitRampageStart = false;
			////vars.DebugOutputVars("SPLIT - SET VARS");
			return true;
		}
	}
	
	if (settings["COLL_RAMPP"])
	{
		// Split when the Rampages Completed counter increases when a rampage is passed
		if (vars.MemoryWatchers["RampagesCompleted"].Current > vars.MemoryWatchers["RampagesCompleted"].Old && vars.MemoryWatchers["RampageState"].Current == 2)
			return true;
	}
	
	if (settings["COLL_USJ"])
	{
		// Split when the Unique Stunts Completed counter increases
		if (vars.MemoryWatchers["UniqueStuntsCompleted"].Current > vars.MemoryWatchers["UniqueStuntsCompleted"].Old)
			return true;
	}
	// COLLECTIBLES END
	
	// MISCELLANEOUS
	if (settings["MISC_ISLAND"])
	{
		// Split when entering Staunton Island from Portland, or Shoreside Vale from Staunton Island
		if ((vars.MemoryWatchers["CurrentIsland"].Current == 2 && vars.MemoryWatchers["CurrentIsland"].Old == 1) || (vars.MemoryWatchers["CurrentIsland"].Current == 3 && vars.MemoryWatchers["CurrentIsland"].Old == 2))
			return true;
	}
	
	if (settings["MISC_GULL"])
	{
		// Split when the Seagulls Sniped Counter goes above 0 for the first time
		if (vars.MemoryWatchers["SeagullsSnipedCounter"].Current >= 1 && vars.MemoryWatchers["SeagullsSnipedCounter"].Old <= 0)
			return true;
	}
	
	if (settings["MISC_OBS_MA"])
	{
		// Split when the Mission Attempts Counter increases but only if the Missions Passed Counter is increased between two attempts
		if (vars.MemoryWatchers["MissionAttemptsCounter"].Current > vars.MemoryWatchers["MissionAttemptsCounter"].Old && vars.SplitMissionStart)
		{
			// Deactivate splitting for the next attempt
			vars.SplitMissionStart = false;
			////vars.DebugOutputVars("SPLIT - SET VARS");
			return true;
		}
	}
	
	if (settings["MISC_OBS_PERC"])
	{
		// Split when the Completion Points counter increases
		if (vars.MemoryWatchers["CompletionPoints"].Current > vars.MemoryWatchers["CompletionPoints"].Old)
			return true;
	}
	// MISCELLANEOUS END
}

reset
{
	// Reset on the first cinematic cutscene after starting a new game
	if (vars.MemoryWatchers["MissionAttemptsCounter"].Current == 0 && vars.MemoryWatchers["PlayerControlLock"].Current == 160)
	{
		////vars.DebugOutputVars("RESET");
		return true;
	}
}

start
{
	// Start when the player gains control during the first mission
	if ((vars.MemoryWatchers["PlayerControlLock"].Current == 0 && vars.MemoryWatchers["PlayerControlLock"].Old == 32 && vars.MemoryWatchers["MissionAttemptsCounter"].Current == 1 && vars.MemoryWatchers["OnMissionFlag"].Current == 1) || (settings["STARTT"] && vars.MemoryWatchers["CurrentMissionTitle"].Current != String.Empty && vars.MemoryWatchers["CurrentMissionTitle"].Old == String.Empty))
	{
		////vars.DebugOutputVars("START");
		return true;
	}
}
