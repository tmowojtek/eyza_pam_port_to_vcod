

init()
{
	logprint("pam::init\n");
	
	// At the start of the server reset cvar pam_mode_custom to make sure default values are used for first time
    if (getTime() == 0)
	{
		setCvar("pam_mode_custom", "0");
	}

	maps\mp\gametypes\global\_global::addEventListener("onCvarChanged", ::onCvarChanged);

	maps\mp\gametypes\global\_global::registerCvarEx("I", "pam_mode", "STRING", "comp", maps\mp\gametypes\global\rules::IsValidPAMMode);
	//maps\mp\gametypes\global\_global::registerCvarEx("I", "pam_mode", "STRING", "comp_mr1", maps\mp\gametypes\global\rules::IsValidPAMMode);
	maps\mp\gametypes\global\_global::registerCvarEx("I", "pam_mode_custom", "BOOL", false);


	if(game["firstInit"])
	{
		// empty for now
	}


	level.pam_folder = "main/zpam333"; // ZPAM_RENAME
	level.pam_map_iwd = "zpam_maps_v3";

	level.pam_mode_change = false;

	level.pam_installation_error = false;


	maps\mp\gametypes\global\_global::addEventListener("onStartGameType", ::onStartGameType);
}

// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	switch(cvar)
	{
		case "pam_mode":
			if (isRegisterTime)
			{
				// Load pam mode cvars imidietly
				level.pam_mode = value;
				// Determine if public mode is set
				game["is_public_mode"] = level.pam_mode == "pub"; // Is public
			}
			else
				thread ChangeTo(value);
		return true;

		case "pam_mode_custom":
			level.pam_mode_custom = value;
			if (!isRegisterTime && value == false) // changed to 0
			{
				maps\mp\gametypes\global\cvar_system::SetDefaults();
			}
			//iprintln("pam_mode_custom changed to " + value);
		return true;

	}
	return false;
}


// Called after the <gametype>.gsc::main() and <map>.gsc::main() scripts are called
// At this point game specific variables are defined (like game["allies"], game["axis"], game["american_soldiertype"], ...)
// Called again for every round in round-based gameplay
onStartGameType()
{
	level thread CheckInstallation();
}


CheckInstallation()
{
	// If we are in listening mode, dont show installating error
	//if (level.dedicated == 0)
	//	return;

	// Wait untill sv_referencedIwds is set
	// Dont know why, but sv_referencedIwds cvars is defined after 4 frames
	wait level.fps_multiplier * 0.3; // just to be sure - on some servers cvars are set twice with different value every time
	
	logprint("PAM installation error=" + level.pam_installation_error + "\n");
}

ChangeTo(mode)
{
	// Will disable all comming map-restrat (so pam_mode can be changed correctly)
	level.pam_mode_change = true;

	iprintlnbold("^3zPAM mode changing to ^2" + mode);
	iprintlnbold("^3Please wait...");
	logprint("zPAM mode changing to " + mode + "\n");

	wait level.fps_multiplier * 3;

	// Reset custom cvars
	setCvar("pam_mode_custom", 0);

	map_restart(false); // fast_restart
}