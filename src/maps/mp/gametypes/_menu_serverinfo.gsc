

init()
{
	logprint("_menu_serverinfo::init\n");
	
	maps\mp\gametypes\global\_global::addEventListener("onStartGameType", ::onStartGameType);
	maps\mp\gametypes\global\_global::addEventListener("onCvarChanged",   ::onCvarChanged);

	maps\mp\gametypes\global\_global::registerCvarEx("I", "scr_motd", "STRING", "Welcome. This server is running zPAM 3.34 for vCoD");	// ZPAM_RENAME

	level.motd = "";
	level.serverversion = "";
	level.serverinfo_left1 = "";
	level.serverinfo_left2 = "";
	level.serverinfo_right1 = "";
	level.serverinfo_right2 = "";
}

// Called after the <gametype>.gsc::main() and <map>.gsc::main() scripts are called
// At this point game specific variables are defined (like game["allies"], game["axis"], game["american_soldiertype"], ...)
// Called again for every round in round-based gameplay
onStartGameType()
{
	generateGlobalServerInfo();
}

// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	// Server info update
	// if (!isRegisterTime && !game["firstInit"] && !isDefined(game["cvars"][cvar]["inQuiet"]) && cvar != "pam_mode_custom")
	// {
	// 	thread generateGlobalServerInfo();
	// }

	switch(cvar)
	{
		case "scr_motd": level.scr_motd = value; return true;
	}
	return false;
}


// Called from menu wen serverinfo menu is opened
updateServerInfo()
{
	// logprint("updateServeInfo:: " + level.motd + " " 
	// + level.serverversion + " " 
	// + level.serverinfo_left1 + " " 
	// + level.serverinfo_left2 + " " 
	// + level.serverinfo_right1 + " " 
	// + level.serverinfo_right2 + "\n");

	self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_motd", level.motd);
	self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_serverversion", level.serverversion);

	// These are set from gametype
	self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_serverinfo_left1", level.serverinfo_left1);
	self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_serverinfo_left2", level.serverinfo_left2);

	// These are global
	self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_serverinfo_right1", level.serverinfo_right1);
	self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_serverinfo_right2", level.serverinfo_right2);

	logprint("updateServerInfo:: done\n");
}

generateGlobalServerInfo()
{
	wait 0.05; // wait untill all other server change functions are processed
	logprint("generateGlobalServerInfo:: start\n");

	// Generate motd
	motd = level.scr_motd;
	motd_final = "";
	skipNextChar = false;
	for (i=0; i < motd.size; i++)
	{
		if (skipNextChar)
		{
			skipNextChar = false;
			continue;
		}

		if (motd[i] == "\\" && i < motd.size-1 && motd[i+1] == "n")
		{
			skipNextChar = true;
			motd_final += "\n";
		}
		else
			motd_final += "" + motd[i];
	}
	level.motd = motd_final;




	level.serverversion = getCvar("version") + "    "; // "CoD2 MP 1.3 build pc_1.3_1_1 Mon May 01 2006 05:05:43PM win-x86"

	sys_cpuGHz = getCvarFloat("sys_cpuGHz"); // "2.59199"
	if (sys_cpuGHz != 0)
		level.serverversion += " (CPU " + maps\mp\gametypes\global\_global::format_fractional(sys_cpuGHz, 1, 2) + " GHz)";

	sys_gpu = getcvar("sys_gpu"); // "Intel(R) UHD Graphics"
	if (sys_gpu != "")
		level.serverversion += " (GPU " + sys_gpu + ")";

	level.serverversion += " (" + getcvarint("sv_maxclients") + " slots)"; // (14 slots)

	if (maps\mp\gametypes\global\_global::contains(level.serverversion, "win"))
		level.serverversion += " (Windows server)";
	else if (maps\mp\gametypes\global\_global::contains(level.serverversion, "linux"))
		level.serverversion += " (Linux server)";

	logprint("generateGlobalServerInfo:: end\n");
}