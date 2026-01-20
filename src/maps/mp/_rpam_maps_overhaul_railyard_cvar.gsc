//	rPAM MAP MP_RAILYARD OVERHAUL
//
//	REISSUE Project Ares Mod version 1.15
//	
//	_rpam_maps_overhaul_railyard_cvar.gsc
//
//	Version: v131
//
//	Tools: WinMerge, VSCode, Editor.txt, WinRar
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////		
/**
 *	rPAM mp_railyard Mapfixes and Commands:
 *
 *		These fixes fill certain locations with collidable models or blocks.
 *
 *		Note: The map may crash a server due to an increasing number of blocks or players, or
 *		due gametype change. Needs to be investigated further
 *
 *	Commands rPAM mp_railyard overhaul:
 *
 *		All commands are set automatically and do not need to be included in the server.cfg file
 *		unless you want to change any of them permanently.
 *
 *		seta rpam_overhaul "1" 						// activates/deactivates the fixes
 *
 *			seta xvar_rpam_overhaul_railyard "0"	// forced off
 *
 *		seta railyard_decoration1 "1" 				// default on (adds trucks and trees at Russian spawn)
 *		seta railyard_decoration2 "1" 				// default on (adds a position, trees and more)
 *
 *		seta railyard_fix_bombspots "1"				// default on (if seta g_gametype "sd", fixing holes of tank A and B)
 *
 *		seta railyard_fix_woodstation_ruins "1"		// default on (adds complete wood collision at axis spawn)	
 *		seta railyard_fix_woodstation_spawn "1"		// default on (adds complete wood collision at axis spawn) 	
 *		seta railyard_fix_woodstation_roof "0" 		// default off (blocks complete south roof from access)
 *
 *		seta railyard_fix_ruins_roof "1"			// default on (fixes broken textures and unfair gaps)
 *					// railyard_fix_ruins_roof 1 MEDIUM ACCESS			// moved2 [22222]
 *					// railyard_fix_ruins_roof 2 HALF BLOCKED			// fall down
 *					// railyard_fix_ruins_roof 3 SMALL ACCESS			// little access
 *					// railyard_fix_ruins_roof 4 FULL ACCESS ROOF			// overload SERVER
 *					// railyard_fix_ruins_roof 5 BLOCK THE ROOF			// no access to the roof at all
 *		seta railyard_fix_ruins_stairs "1"			// default on (adds stance to the stairs at A site ruins)
 *		seta railyard_fix_ruins_stone "1"			// default on (adds collision to a stone in axis ruins )
 *
 *		seta railyard_block_southstation_roof "0"	// default off (blocks roof ledge at Axis spawn)
 *
 *		seta railyard_block_updown "0"				// testing only
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////
////////////		SET OVERHAUL COMMANDS
////////

overhaul_railyard_cvars()
{
//	if (getcvar("rpam_overhaul") == "")		// Deactivate everything by starting the mapo
//		setCvar("rpam_overhaul", "0");

// Display Informations about this mod
	if (getcvar("rpam_overhaul_messagecenter") == "")
		setCvar("rpam_overhaul_messagecenter", "1");

//
// Hint: Server could overload if you enable all!!!
// 
// bombspots // set this AUTO ON (fixing holes in tanks, if g_gametype "sd" is set)
// 
	if (getcvar("railyard_fix_bombspots") == "" || getcvar("railyard_fix_bombspots") == "1")
		setCvar("railyard_fix_bombspots", "1");										

// 
// axis Woodstation // set this AUTO ON (collsion for the axis woodstation)
// 
	if (getcvar("railyard_fix_woodstation_spawn") == "" || getcvar("railyard_fix_woodstation_spawn") == "1")
		setCvar("railyard_fix_woodstation_spawn", "1");
	if (getcvar("railyard_fix_woodstation_ruins") == "" || getcvar("railyard_fix_woodstation_ruins") == "1")
		setCvar("railyard_fix_woodstation_ruins", "1");

// 
// axis woodstation roof // set this AUTO ON (roof ledge blocked at axis spawn)
// 
	if (getcvar("railyard_fix_woodstation_roof") == "" || getcvar("railyard_fix_woodstation_roof") == "0")
		setCvar("railyard_fix_woodstation_roof", "0");

// 
// ruins roof // set this AUTO ON (fixing broken spots and decreasing the accessible space)
// 					
	if (getcvar("railyard_fix_ruins_roof") == "" || getcvar("railyard_fix_ruins_roof") == "1")
		setCvar("railyard_fix_ruins_roof", "1");
//
// 		railyard_fix_ruins_roof 1 MEDIUM ACCESS			// moved 2
// 		railyard_fix_ruins_roof 2 HALF BLOCKED			// fall down
// 		railyard_fix_ruins_roof 3 SMALL ACCESS			// little access
// 		railyard_fix_ruins_roof 4 FULL ACCESS ROOF		// overload SERVER
// 		railyard_fix_ruins_roof 5 BLOCK THE ROOF		// no access to the roof at all
//

//
// ruins stairs // set this AUTO ON (collsion for one stone in axis ruins)
//
	if (getcvar("railyard_fix_ruins_stairs") == "" || getcvar("railyard_fix_ruins_stairs") == "1")
		setCvar("railyard_fix_ruins_stairs", "1");

//
// ruins stonecorner // set this AUTO ON (collsion for one stone in axis ruins)
//
	if (getcvar("railyard_fix_ruins_stone") == "" || getcvar("railyard_fix_ruins_stone") == "1")
		setCvar("railyard_fix_ruins_stone", "1");			

//
// southstation roof // default AUTO OFF (complete south roof blocked)	
//								
	if (getcvar("railyard_block_southstation_roof") == "" || getcvar("railyard_fix_ruinsstairs") == "0")
		setCvar("railyard_block_southstation_roof", "0");

//
// add decoration 1 // set this AUTO ON (trucks and trees)
//	
	if (getcvar("railyard_add_decoration1") == "" || getcvar("railyard_add_decoration1") == "1")
		setCvar("railyard_add_decoration1", "1");

//
// add decoration 2 // set this AUTO ON (trucks and trees)
//
	if (getcvar("railyard_add_decoration2") == "" || getcvar("railyard_add_decoration2") == "1")
		setCvar("railyard_add_decoration2", "1");

// 
// WAS NOT FINISHED! // block up&down
//
	if (getcvar("railyard_block_updown") == "" || getcvar("railyard_block_updown") == "0")
		setCvar("railyard_block_updown", "0");
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////
////////////		DEBUGING COMMANDS
////////

overhaul_railyard_debug()
{
	if (getcvar("xvar_rpam_overhaul_railyard") == "" || getcvar("xvar_rpam_overhaul_railyard") == "0")
	{
		setCvar("xvar_rpam_overhaul_railyard", "0");
	}
	else if (getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		setCvar("rpam_overhaul_messagecenter", "1");
	}

// testing/debugging -- change this cvar for debugging
//	setCvar("xvar_rpam_overhaul_railyard", "1");			// enforce xvar //
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////				Cvardef (took out of awe, hope this works)
////////
////

cvardef(varname, vardefault, min, max, type)
{
	mapname = getcvar("mapname");				// "mp_dawnville", "mp_rocket", etc.

	if(isdefined(level.z_rpam_gametype))
		gametype = level.z_rpam_gametype;		// "tdm", "bel", etc.
	else
		gametype = getcvar("g_gametype");		// "tdm", "bel", etc.

	tempvar = varname + "_" + gametype;			// i.e., scr_teambalance becomes scr_teambalance_tdm
	if(getcvar(tempvar) != "") 					// if the gametype override is being used
		varname = tempvar; 						// use the gametype override instead of the standard variable

	tempvar = varname + "_" + mapname;			// i.e., scr_teambalance becomes scr_teambalance_mp_dawnville
	if(getcvar(tempvar) != "")					// if the map override is being used
		varname = tempvar;						// use the map override instead of the standard variable
	
	switch(type)								// get the variable's definition
	{
		case "int":
			if(getcvar(varname) == "")			// if the cvar is blank
				definition = vardefault;		// set the default
			else
				definition = getcvarint(varname);
			break;

		case "float":
			if(getcvar(varname) == "")			// if the cvar is blank
				definition = vardefault;		// set the default
			else
				definition = getcvarfloat(varname);
			break;

		case "string":
		default:
			if(getcvar(varname) == "")			// if the cvar is blank
				definition = vardefault;		// set the default
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