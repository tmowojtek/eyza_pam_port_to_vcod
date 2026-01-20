//	Version: v228
//
//	rPAM MAPS OVERHAUL AMBIENT
//
//	REISSUE Project Ares Mod version 1.15
//	
//	_rpam_maps_overhaul__ambient_cvar.gsc
//	
//	For all ambient modules.
//	
//	
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 
/**		
 *	rPAM Ambient Commands Section:
 *
 *	All commands are set automatically and do not need to be in 
 *	the server.cfg file unless you want to change any of them permanently.
 *	
 *	Overall background ambient sound on all maps.
 *		seta rpam_ambientsounds "1"		// auto ON, 0 at s&d
 *	
 * 	Normally, the fog starts from the player and extends to X distance. 
 * 	With this command, fog begins Y units away from the player and extends to X distance.
 *		seta rpam_ambientfog "3"		// auto ON FOGMOD
 *		seta rpam_ambientfog "2"		// half
 *		seta rpam_ambientfog "1"		// default	
 *	
 * 	This disables smoke plumes from vehicles and other objects.
 *		seta rpam_ambientsmoke "1"		// auto ON, 0 at s&d
 *	
 *	All gametypes supported.
*/
main()
{
	thread setup_ambient_overhaul();
	thread setup_ambient_cvardef();
}

/* ****************    Here you setup the commands if not set in the server config     **************** */
setup_ambient_overhaul()		
{
// Activate this system
	if (getcvar("xvar_rpam_amb_autosetup_disabled") == "" || getcvar("xvar_rpam_amb_autosetup_disabled") == "0" )
	{
		setCvar("xvar_rpam_amb_autosetup_disabled", "0");

// Turn on message center in each gametype, if no value set, don't on S&D rounds
//	if (getcvar("rpam_ambient_messagecenter") == "" || getcvar("rpam_ambient_messagecenter") == "0")
		setCvar("rpam_ambient_messagecenter", "0");

// Turn on new rpam ambient sound, don't on S&D
if (getcvar("rpam_ambientsounds") == "")
	{
		// If SD oder DM set it to 0
		if (getcvar("g_gametype") == "sd" || getcvar("g_gametype") == "dm")
		{
			setCvar("rpam_ambientsounds", "0");
		}
		// Else to 1
		else
		{
			setCvar("rpam_ambientsounds", "1");
		}
}

// Force FOGMOD 3
		if (getcvar("rpam_ambientfog") == "" || getcvar("rpam_ambientfog") == "0")
			setCvar("rpam_ambientfog", "3");

// Force smoke plumes to be off in S&D
		if (getcvar("rpam_ambientsmoke") == "")
		{
			if (getcvar("g_gametype") != "sd")
				setCvar("rpam_ambientsmoke", "1");
			else
				setCvar("rpam_ambientsmoke", "0");
		}	
	}
}

setup_ambient_cvardef()
{
	if (getcvar("xvar_rpam_amb_autosetup_cvardef_disabled") == "" || getcvar("xvar_rpam_amb_autosetup_cvardef_disabled") == "0" )
	{
	// Activate this system
		setCvar("xvar_rpam_amb_autosetup_cvardef_disabled", "0");

		level.z_rpam_ambientsounds = cvardef("rpam_ambientsounds", 1, 0, 1, "float");
		level.z_rpam_ambientfog = cvardef("rpam_ambientfog", 1, 0, 4, "int");				// 4
		level.z_rpam_ambientsmoke = cvardef("rpam_ambientsmoke", 1, 0, 1, "int");
		level.z_rpam_ambient_messagecenter = cvardef("rpam_ambient_messagecenter", 1, 0, 1, "int");	// disable this, while rpam_msg do exist
		level.z_rpam_msg = cvardef("rpam_msg", 1, 0, 1, "int");						// enable this, while rpam_msg do exist
		level.z_rpam_amb_autosetup_disabled = cvardef("xvar_rpam_amb_autosetup_disabled", 0, 0, 1, "int");
	}
}
/* ****************                                 END                                **************** */

/////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////
////////////		CvarDef
////////
////			- took out of awe mod, hope this works

cvardef(varname, vardefault, min, max, type)
{
	mapname = getcvar("mapname");			// "mp_dawnville", "mp_rocket", etc.

	if(isdefined(level.z_rpam_gametype))
		gametype = level.z_rpam_gametype;	// "tdm", "bel", etc.
	else
		gametype = getcvar("g_gametype");	// "tdm", "bel", etc.

	tempvar = varname + "_" + gametype;		// i.e., scr_teambalance becomes scr_teambalance_tdm
	if(getcvar(tempvar) != "") 			// if the gametype override is being used
		varname = tempvar; 			// use the gametype override instead of the standard variable

	tempvar = varname + "_" + mapname;		// i.e., scr_teambalance becomes scr_teambalance_mp_dawnville
	if(getcvar(tempvar) != "")			// if the map override is being used
		varname = tempvar;			// use the map override instead of the standard variable

	// get the variable's definition
	switch(type)
	{
		case "int":
			if(getcvar(varname) == "")		// if the cvar is blank
				definition = vardefault;	// set the default
			else
				definition = getcvarint(varname);
			break;
		case "float":
			if(getcvar(varname) == "")		// if the cvar is blank
				definition = vardefault;	// set the default
			else
				definition = getcvarfloat(varname);
			break;
		case "string":
		default:
			if(getcvar(varname) == "")		// if the cvar is blank
				definition = vardefault;	// set the default
			else
				definition = getcvar(varname);
			break;
	}

	// if it's a number, with a minimum, that violates the parameter
	if((type == "int" || type == "float") && min != "" && definition < min)
		definition = min;

	// if it's a number, with a maximum, that violates the parameter
	if((type == "int" || type == "float") && max != "" && definition > max)
		definition = max;

	return definition;
}

// END