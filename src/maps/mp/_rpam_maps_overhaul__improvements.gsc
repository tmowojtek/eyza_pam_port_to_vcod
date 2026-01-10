//	Version: v225
//
//	rPAM MAPS OVERHAUL IMPROVEMENTS
//
//	REISSUE Project Ares Mod version 1.15
//	
//	-->> _rpam_maps_overhaul__improvements.gsc
//
//	Last Script Version: v15
//
//	Tools: WinMerge, VSCode, Editor.txt, WinRar
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////		

main()
{
//	thread rpam_map_improvement_cvar();
	thread rpam_map_improvement_level();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////		Check rPAM commands without rPAM
////////
////					
//

rpam_map_improvement_cvar()
{
// get the settings by this gsc
//	maps\mp\_rpam_maps_overhaul__ambient_cvar::main();

// define the cvars
//	maps\mp\_rpam_maps_overhaul_ambient_cvardef::main();
//	level.z_ = cvardef(varname, vardefault, min, max, type);
/*	level.z_rpam_ambientsounds = cvardef("rpam_ambientsounds", 1.0, 0.0, 1.0, "float");
	level.z_rpam_ambientfog = cvardef("rpam_ambientfog", 3, 0, 3, "int");
	level.z_rpam_ambientsmoke = cvardef("rpam_ambientsmoke", 1, 0, 1, "int");

// MSG
	if (getcvar("rpam_overhaul_messagecenter") == "")
		setCvar("rpam_overhaul_messagecenter", "1");
*/
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////
////////////		Cvardef
////////
////			- took out of awe mod, hope this works
//
//
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////		rPAM Improvements
////////

rpam_map_improvement_level()
{
	setCvar("rpam_improvement", "1");		// check

// Get mapname
	level.mapname = getcvar("mapname");

// All maps
	switch(level.mapname)
	{
		case "mp_bocage":
		case "mp_brecourt":
		case "mp_carentan":
		case "mp_chateau":
		case "mp_dawnville":
		case "mp_dawnville_x":
		case "mp_depot":
		case "mp_harbor":
		case "mp_hurtgen":
		case "mp_neuville":
		case "mp_pavlov":
		case "mp_powcamp":
		case "mp_railyard_x":
		case "mp_rocket":
		case "mp_ship":
		case "mp_stalingrad":
		case "mp_tigertown":
			level thread rpam_improvement();
			break;

		case "mp_railyard":
			level thread rpam_improvement();
			level maps\mp\_rpam_maps_overhaul_railyard::main();
			break;

		case "mp_germantown":
			level thread rpam_improvement();
//			level maps\mp\_rpam_maps_overhaul_germantown::main();
			break;

		default:
			break;
	}
	
// display messagecenter
// 	if (getcvar("rpam_improvement_messagecenter") == 1)
// 		maps\mp\_rpam_maps_overhaul__improvement_msgc::main();
}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////		Improvements
////////

rpam_improvement()
{
	level thread rpam_nopronenew();
	setCvar("rpam_improvement", "1");
}

rpam_nopronenew()	// cfox
{
	areas = getentarray("noprone", "targetname");
	if(isdefined(areas))
	{
		for(i=0;i<areas.size;i++)
		{
			areas[i] thread rpam_nopronenew_script();
		}
	}
}

rpam_nopronenew_script()
{
	while(1)
	{
		self waittill("trigger", user);
		
		if(user istouching(self) && user GetStance() == "prone")
		{
			user setClientCvar("cl_stance", 1);
		}
		wait 0.25;
	}
}
