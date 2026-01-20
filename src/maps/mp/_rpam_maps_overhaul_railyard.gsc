//	rPAM MAP MP_RAILYARD OVERHAUL
//
//	REISSUE Project Ares Mod version 1.15
//	
//	_rpam_maps_overhaul_railyard.gsc
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
/**
 *
 *	Directory:
 *	
 *	(z01) MAIN
 *	(z02) rPAM OVERHAUL ACTIVATED
 *		(zA) THREAD PRECHACHE
 *		(zB) DEBUGING
 *		(zC) SET COMMANDS
 *		(zD) SET CVARDEF & LEVEL IT
 *	(z03) THREAD LOAD ORDER
 *	(z04) PRINT WHATS LOADED
 *	
 *	(c01) RUINS STAIRS COORDINATES (complete)
 *	(c02) RUINS ROOF VIEWBLOCKS TO LEDGE COORDINATES (complete)
 *	(c03) RUINS STONECORNER COORDINATES
 *	(c04) RUINS ROOF BRICKFIX COORDINATES
 *	(c05) RUINS ROOF BLOCKS COORDINATES
 *	(c06) RUINS ROOF BLOCKS MOVED
 *	(c07) OBJECTS COORDINATES
 *	(c08) BOMBSPOTS COORDINATES
 *	(c09) AXIS STATION COORDINATES
 *	(b01) BLOCK THE JUMP TO AXIS ROOF JUMPPOSITION COORDINATES
 *	(c11) AXIS STATION ROOF BLOCKS COORDINATES
 *	(c12) SOUTHSTATION ROOF BLOCK COORDINATES
 *	
 *	(x01) PRECACHE
 *	(x02) BLOCK
 *	(x02) BOMBSPOT MODEL
 *	(x03) DECORATION
 *	(x04) AXIS WOODSTATION MODELS
 *	(x05) RUINS ROOF BRICKFIX MODELS
 *	
 *	(c13) LEDGE UP&DOWN COORDINATES
 *
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(z01) MAIN
////////
////
//

main()
{
	thread mp_railyard_overhaul_precache();		// THREAD (x01) PRECACHE

	thread rpam_exploit_cvar_off();				// deactivate this mod

	thread rpam_exploit_level();				// load what gets overhauled
}

////////////////
////////////				Overhaul on/off
////////
rpam_exploit_cvar_off()
{
	if (getcvar("rpam_overhaul") == "" || getcvar("rpam_overhaul") == "0")
	{
		setCvar("rpam_overhaul", "0");
		if (getcvar("rpam_overhaul_messagecenter") == "" || getcvar("rpam_overhaul") == "1")
			thread maps\mp\_rpam_maps_overhaul_railyard_msgc::rpam_exploit_cvar_off_msg();
	}
	else
	{
		setCvar("rpam_overhaul", "1");
	}

	level.z_rpam_overhaul = cvardef("rpam_overhaul", 0, 0, 1, "int");
}

rpam_exploit_cvar()
{
	if (getcvar("rpam_overhaul") == "" || getcvar("rpam_overhaul") == "1")
	{
		setCvar("rpam_overhaul", "1");
	}
	else
	{
		setCvar("rpam_overhaul", "0");
	}
	println("rpam_overhaul set to: " + getcvar("rpam_overhaul"));

	level.z_rpam_overhaul = cvardef("rpam_overhaul", 1, 0, 1, "int");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////				Cvardef (took out of awe, hope this works)
////////
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(z02) rPAM OVERHAUL ACTIVATED
////////
////
// 
//		Info:
//		With the wait command everything loads it seems.
//		Server crash or load order needs to be investigated still.
//
rpam_exploit_level()
{
	if (level.z_rpam_overhaul == 1)
	{

////////////////
////////////				(zA) THREAD PRECHACHE
////////
//		thread mp_railyard_overhaul_precache();					// THREAD (x01) PRECACHE

////////////////
////////////				(zB) DEBUGING
////////
		maps\mp\_rpam_maps_overhaul_railyard_cvar::overhaul_railyard_debug();
/*
// testing/debugging -- change this cvar for debugging
		if (getcvar("xvar_rpam_overhaul_railyard") == "")
		{
			setCvar("xvar_rpam_overhaul_railyard", "0");
		}

		setCvar("xvar_rpam_overhaul_railyard", "1");			// enforce xvar
*/
////////////////
////////////				(zC) SET COMMANDS
////////
		maps\mp\_rpam_maps_overhaul_railyard_cvar::overhaul_railyard_cvars();
/*
// bombspots
		if (getcvar("railyard_fix_bombspots") == "" || getcvar("railyard_fix_bombspots") == "1")
			setCvar("railyard_fix_bombspots", "1");										// set this AUTO ON (fixing holes in tanks, if g_gametype "sd" is set)

// axis woodstation
		if (getcvar("railyard_fix_woodstation_spawn") == "" || getcvar("railyard_fix_woodstation_spawn") == "1")
			setCvar("railyard_fix_woodstation_spawn", "1");								// set this AUTO ON (collsion for the axis woodstation)
		if (getcvar("railyard_fix_woodstation_ruins") == "" || getcvar("railyard_fix_woodstation_ruins") == "1")
			setCvar("railyard_fix_woodstation_ruins", "1");								// set this AUTO ON (collsion for the axis woodstation)

// axis woodstation roof
		if (getcvar("railyard_block_woodstation_roof") == "")
			setCvar("railyard_block_woodstation_roof", "1");							// set this AUTO ON (roof ledge blocked at axis spawn)

// ruins roof												
		if (getcvar("railyard_fix_ruinsroof") == "" || getcvar("railyard_fix_ruinsroof") == "1")
			setCvar("railyard_fix_ruinsroof", "1");										// set this AUTO ON (fixing broken spots and decreasing the accessible space)

// ruins stonecorner
		if (getcvar("railyard_fix_stonecorner") == "" || getcvar("railyard_fix_stonecorner") == "1")
			setCvar("railyard_fix_stonecorner", "1");									// set this AUTO ON (collsion for one stone in axis ruins)

// runis stairs
		if (getcvar("railyard_fix_noobstairs") == "" || getcvar("railyard_fix_noobstairs") == "1")
			setCvar("railyard_fix_noobstairs", "1");									// set this AUTO ON (collsion for one stone in axis ruins)

// southstation roof										
		if (getcvar("railyard_block_southstation_roof") == "")
			setCvar("railyard_block_southstation_roof", "0");							// default off (complete south roof blocked)

// add decoration 1		
		if (getcvar("railyard_add_decoration1") == "")
			setCvar("railyard_add_decoration1", "0");									// default off (trucks and trees)

// add decoration 2
		if (getcvar("railyard_add_decoration2") == "")
			setCvar("railyard_add_decoration2", "0");									// default off (trucks and trees)

// block up&down
		if (getcvar("railyard_block_updown") == "")
			setCvar("railyard_block_updown", "0");										// testing
*/
////////////////
////////////				(zD) SET CVARDEF & LEVEL IT
////////
// debugging
		level.z_rpam_overhaul_debug = cvardef("xvar_rpam_overhaul_railyard", 0, 0, 1, "int");	// enforce xvar
// bombspots
		level.z_railyard_fix_bombspots = cvardef("railyard_fix_bombspots", 1, 0, 1, "int");
// wood station
		level.z_railyard_fix_woodstation_spawn = cvardef("railyard_fix_woodstation_spawn", 1, 0, 1, "int");
		level.z_railyard_fix_woodstation_ruins = cvardef("railyard_fix_woodstation_ruins", 1, 0, 1, "int");
		level.z_railyard_fix_woodstation_roof = cvardef("railyard_fix_woodstation_roof", 1, 0, 1, "int");
// ruins
		level.z_railyard_fix_ruins_roof = cvardef("railyard_fix_ruins_roof", 1, 0, 5, "int");
		level.z_railyard_fix_ruins_stairs = cvardef("railyard_fix_ruins_stairs", 1, 0, 1, "int");
		level.z_railyard_fix_ruins_stone = cvardef("railyard_fix_ruins_stone", 1, 0, 1, "int");
// southstation
		level.z_railyard_block_southstation_roof = cvardef("railyard_block_southstation_roof", 0, 0, 1, "int");
// decoration
		level.z_railyard_add_decoration1 = cvardef("railyard_add_decoration1", 1, 0, 1, "int");
		level.z_railyard_add_decoration2 = cvardef("railyard_add_decoration2", 1, 0, 1, "int");
// block up&down
		level.z_railyard_block_updown =  cvardef("railyard_block_updown", 0, 0, 1, "int");


///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(z03) THREAD LOAD ORDER
////////
////
// 

// bomb spots
		if (level.z_railyard_fix_bombspots == "1")
		{
			if (getcvar("g_gametype") == "sd")
			{
				wait 0.5;
				thread rpam_overhaul_railyard_bombspots();				// THREAD	BOMBSPOTS
			}
		}

// wood station
		if (level.z_railyard_fix_woodstation_spawn == "1")
		{		
			wait 0.5;
			thread rpam_overhaul_railyard_axis_woodstation_spawn();		// THREAD	WOODSTATION
		}

		if (level.z_railyard_fix_woodstation_ruins == "1")
		{		
			wait 0.5;
			thread rpam_overhaul_railyard_axis_woodstation_ruins();		// THREAD	WOODSTATION
		}

// ruins roof 104
		if (level.z_railyard_fix_ruins_roof == "1")					//			MORE ACCESS LEFT OF THE HOLE
		{
			wait 0.5;
			thread rpam_overhaul_railyard_axis_ruins_roof_fix();			// fix holes and broken texture with wood and bricks
			thread rpam_overhaul_railyard_axis_ruins_roof_moved2();			// moved2
			thread rpam_overhaul_railyard_roof_viewblock_bottom();			// viewblock broken roof bottom
		}
		else if (level.z_railyard_fix_ruins_roof == "2")				//			ACCESS HALF OF THE ROOF
		{
			wait 0.5;
			thread rpam_overhaul_railyard_axis_ruins_roof_fix();			// fix holes and broken texture with wood and bricks
			thread rpam_overhaul_railyard_axis_ruins_roof();			// blocks half of the roof because of engine limitations
			thread rpam_overhaul_railyard_roof_viewblock_bottom();			// viewblock broken roof bottom
		}
		else if (level.z_railyard_fix_ruins_roof == "3")				//			SMALL ACCESS LEFT OF THE HOLE
		{
			wait 0.5;
			thread rpam_overhaul_railyard_axis_ruins_roof_fix();			// fix holes and broken texture with wood and bricks
			thread rpam_overhaul_railyard_axis_ruins_roof_moved();			// moved the blocks to get a bit more access
			thread rpam_overhaul_railyard_roof_viewblock_bottom();			// viewblock broken roof bottom
		}
		else if (level.z_railyard_fix_ruins_roof == "4")				//			FULL ACCESS ROOF
		{
			wait 0.5;
			thread rpam_overhaul_railyard_axis_ruins_roof_fix();			// fix holes and broken texture with wood and bricks
			thread rpam_overhaul_railyard_roof_viewblock_top();			// viewblock broken roof
			thread rpam_overhaul_railyard_roof_viewblock_bottom();			// viewblock broken roof bottom
		}
		else if (level.z_railyard_fix_ruins_roof == "5")				//			BLOCK THE ROOF
		{
			wait 0.5;
			thread rpam_overhaul_railyard_axis_ruins_roof_fix();			// fix holes and broken texture with wood and bricks
			thread rpam_overhaul_railyard_axis_jumpposition();			// blocks the whole access to the roof TESTING
		}

// decoration
		if (level.z_railyard_add_decoration1 == "1")
		{
			wait 0.5;
			thread rpam_overhaul_railyard_models();					// THREAD	OBJECTS 1
		}

		if (level.z_railyard_add_decoration2 == 1)
		{
			wait 0.5;
			thread rpam_overhaul_railyard_models2();				// THREAD	OBJECTS 2
		}

// ruins stairs
		if (level.z_railyard_fix_ruins_stairs == 1)
		{
			wait 0.5;
			thread rpam_overhaul_railyard_axis_ruins_noobstairs();			// THREAD RUINS STAIRS
		}
// ruins stone
		if (level.z_railyard_fix_ruins_stone == 1)
		{
			wait 0.5;
			thread rpam_overhaul_railyard_axis_ruins_stonecorner();			// THREAD STONECORNER
		}

// woodstation roof
		if (level.z_railyard_fix_woodstation_roof == 1)
		{
			wait 0.5;
			thread rpam_overhaul_railyard_axis_woodstation_roof();			// THREAD WOODSTATION ROOF
		}
// soutstation roof
		if (level.z_railyard_block_southstation_roof == 1)
		{
			wait 0.5;
			thread rpam_overhaul_railyard_southstation();				// THREAD SOUTHSTATION
		}
// updown
		if (level.z_railyard_block_updown == 1)
		{	
			wait 0.2;
			thread rpam_overhaul_railyard_updown();					// THREAD UPDOWN
		}

		//										// MESSAGECENTER
		wait 0.2;

		if (getcvar("rpam_overhaul_messagecenter") == 1)
//			thread rpam_overhaul_railyard_messagecenter();
			level thread maps\mp\_rpam_maps_overhaul_railyard_msgc::main();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(z04) PRINT WHATS LOADED
////////
////
// 

rpam_overhaul_railyard_messagecenter()
{
	wait 1.5;

	iprintln(" ");
	iprintln(" ");
	iprintln("^3rPAM ^7MP_RAILYARD OVERHAUL^3:");

// decoration
	if (level.z_railyard_add_decoration1 == 1)
		iprintln("^5railyard_add_decoration1 ^2loaded");
	else
		iprintln("^5railyard_add_decoration1 ^2not loaded");

	if (level.z_railyard_add_decoration2 == 1)
		iprintln("^5railyard_add_decoration2 ^2loaded");
	else
		iprintln("^5railyard_add_decoration2 ^2not loaded");

// bombspots
	if (level.z_railyard_fix_bombspots == "1")
	{
		if (getcvar("g_gametype") == "sd")
		{
			iprintln("^5railyard_fix_bombspots ^2loaded");
		}
		else
		{
			iprintln("^5railyard_fix_bombspots ^7not loaded (current g_gametype isn't sd)");
		}
	}
	else if (level.z_railyard_fix_bombspots == "0")
	{
		iprintln("^5railyard_fix_bombspots ^1not loaded");	
	}

// woodstation both
	if (level.z_railyard_fix_woodstation_ruins == 1)
		iprintln("^5railyard_fix_woodstation_ruins ^2loaded");
	else
		iprintln("^5railyard_fix_woodstation_ruins ^1not loaded");

	if (level.z_railyard_fix_woodstation_spawn == 1)
		iprintln("^5railyard_fix_woodstation_spawn ^2loaded");
	else
		iprintln("^5railyard_fix_woodstation_spawn ^1not loaded");

// woodstation roof
	if (level.z_railyard_fix_woodstation_roof == 1)
		iprintln("^5railyard_fix_woodstation_roof ^2loaded");
	else
		iprintln("^5railyard_fix_woodstation_roof ^2not loaded");

// ruins roof
	if (level.z_railyard_fix_ruins_roof == 1)
		iprintln("^5railyard_fix_ruins_roof ^21/5 (MEDIUM ACCESS) ^2loaded");
	else if (level.z_railyard_fix_ruins_roof == 2)
		iprintln("^5railyard_fix_ruins_roof ^22/5 (HALF BLOCKED) ^2loaded");
	else if (level.z_railyard_fix_ruins_roof == 3)
		iprintln("^5railyard_fix_ruins_roof ^23/5 (SMALL ACCESS) ^2loaded");
	else if (level.z_railyard_fix_ruins_roof == 4)
		iprintln("^5railyard_fix_ruins_roof ^14/5 (FULL ACCESS) ^2loaded");
	else if (level.z_railyard_fix_ruins_roof == 5)
		iprintln("^5railyard_fix_ruins_roof ^15/5 (BLOCK) ^2loaded");
	else
		iprintln("^5railyard_fix_ruins_roof ^1not loaded");

// ruins stone
	if (level.z_railyard_fix_ruins_stone == 1)
		iprintln("^5railyard_fix_ruins_stone ^2loaded");
	else
		iprintln("^5railyard_fix_ruins_stone ^1not loaded");

// ruins stairs
	if (level.z_railyard_fix_ruins_stairs == 1)
		iprintln("^5railyard_fix_ruins_stairs ^2loaded");
	else
		iprintln("^5railyard_fix_ruins_stairs ^1not loaded");

// southstation
	if (level.z_railyard_block_southstation_roof == 1)
		iprintln("^5railyard_block_southstation_roof ^1loaded");
	else
		iprintln("^5railyard_block_southstation_roof ^2not loaded");

 // updown
	if (level.z_railyard_block_updown == 1)
		iprintln("^5railyard_block_updown ^1(test) ^1loaded");
	else
		iprintln("^5railyard_block_updown ^2(test) ^2not loaded");

// debug info
	if (level.z_rpam_overhaul_debug == 1)
	{
		iprintln(" ");
		iprintln(" ");
		iprintln("^1railyard_debug loaded!");
		iprintln("^1railyard_debug loaded!");
		iprintln("^1railyard_debug loaded!");
	}
	iprintln(" ");
	iprintln(" ");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////       COORDINATES       ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c01) RUINS STAIRS COORDINATE (complete)
////////
////
// 

rpam_overhaul_railyard_axis_ruins_noobstairs()
{
	thread monitor_player_position((-355, 962, 72));
//	thread monitor_player_position((-355, 952, 72));
	thread monitor_player_position((-355, 942, 72));
//	thread monitor_player_position((-355, 932, 72));
	thread monitor_player_position((-355, 922, 72));
//	thread monitor_player_position((-355, 912, 72));

//	thread monitor_player_position((-365, 962, 62));
	thread monitor_player_position((-365, 952, 62));
//	thread monitor_player_position((-365, 942, 62));
	thread monitor_player_position((-365, 932, 62));
//	thread monitor_player_position((-365, 922, 62));
	thread monitor_player_position((-365, 912, 62));

	thread monitor_player_position((-376, 962, 53));
//	thread monitor_player_position((-376, 952, 53));
	thread monitor_player_position((-376, 942, 53));
//	thread monitor_player_position((-376, 932, 53));
	thread monitor_player_position((-376, 922, 53));
//	thread monitor_player_position((-376, 912, 53));

//	thread monitor_player_position((-386, 962, 43));
	thread monitor_player_position((-386, 952, 43));
//	thread monitor_player_position((-386, 942, 43));
	thread monitor_player_position((-386, 932, 43));
//	thread monitor_player_position((-386, 922, 43));
	thread monitor_player_position((-386, 912, 43));

	thread monitor_player_position((-396, 962, 34));
//	thread monitor_player_position((-396, 952, 34));
	thread monitor_player_position((-396, 942, 34));
//	thread monitor_player_position((-396, 932, 34));
	thread monitor_player_position((-396, 922, 34));
//	thread monitor_player_position((-396, 912, 34));

//	thread monitor_player_position((-406, 962, 26));
	thread monitor_player_position((-406, 952, 26));
//	thread monitor_player_position((-406, 942, 26));
	thread monitor_player_position((-406, 932, 26));
//	thread monitor_player_position((-406, 922, 26));
	thread monitor_player_position((-406, 912, 26));

	thread monitor_player_position((-411, 962, 18));
//	thread monitor_player_position((-411, 952, 18));
	thread monitor_player_position((-411, 942, 18));
//	thread monitor_player_position((-411, 932, 18));
	thread monitor_player_position((-411, 922, 18));
//	thread monitor_player_position((-411, 912, 18));

//	thread monitor_player_position((-421, 962, 10));
	thread monitor_player_position((-421, 952, 10));
//	thread monitor_player_position((-421, 942, 10));
	thread monitor_player_position((-421, 932, 10));
//	thread monitor_player_position((-421, 922, 10));
	thread monitor_player_position((-421, 912, 10));
}

monitor_player_position(point)
{
	radius = 25; // Radius around the point to check

	if (getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		size = (.5, .5, .5);
		origin = point;

		thread point_monitor_player_position_debug(origin, size);
	}

	while (true)
	{
		players = getentarray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			player = players[i];
			position = player.origin;

			if (point_monitor_player_position_near(position, point, radius))
			{
				if (player getstance() != "stand")
				{
//					player allowedStances ("stand");
//					player getstance() != "crouch";
					player setClientCvar("cl_stance", 1); // Change the stance of the player
				}
			}
		}
		wait 0.2; // Check every 200ms
	}
}

point_monitor_player_position_near(position, point, radius)
{
    dx = position[0] - point[0];
    dy = position[1] - point[1];
    dz = position[2] - point[2];

    distance_squared = dx*dx + dy*dy + dz*dz;
    radius_squared = radius * radius;

    return distance_squared <= radius_squared;
}

point_monitor_player_position_debug(origin, size)
{
		x = size[0];
		y = size[1];
		z = size[2];

		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c02) RUINS ROOF VIEWBLOCKS TO LEDGE COORDINATES (complete)
////////
////
// 

//
//		VIEWBLOCK AXIS ROOF BOTTOM
//
rpam_overhaul_railyard_roof_viewblock_bottom()
{
// topp line
	thread mp_railyard_viewblock1((-548, 104, 290), (.4, .4, .4));
	thread mp_railyard_viewblock1((-558.5, 104, 290), (.4, .4, .4));
	thread mp_railyard_viewblock1((-569, 104, 290), (.4, .4, .4));
	thread mp_railyard_viewblock1((-579.5, 104, 290), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-590, 104, 290), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-600.5, 104, 290), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-611, 104, 290), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-621.5, 104, 290), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-632, 104, 290), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-642.5, 104, 290), (.4, .4, .4));

	thread mp_railyard_viewblock1((-536, 95, 284), (.4, .4, .4));
	thread mp_railyard_viewblock1((-546.5, 95, 284), (.4, .4, .4));
	thread mp_railyard_viewblock1((-557, 95, 284), (.4, .4, .4));
	thread mp_railyard_viewblock1((-567.5, 95, 284), (.4, .4, .4));
	thread mp_railyard_viewblock1((-578, 95, 284), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-588.5, 95, 284), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-599, 95, 284), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-609.5, 95, 284), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-620, 95, 284), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-630.5, 95, 284), (.4, .4, .4));

// extra for the hole
	thread mp_railyard_viewblock1((-529, 90, 281), (.4, .4, .4));
// below the hole
	thread mp_railyard_viewblock1((-523, 86, 278), (.4, .4, .4));
	thread mp_railyard_viewblock1((-533.5, 86, 278), (.4, .4, .4));
	thread mp_railyard_viewblock1((-544, 86, 278), (.4, .4, .4));
	thread mp_railyard_viewblock1((-554.5, 86, 278), (.4, .4, .4));
	thread mp_railyard_viewblock1((-565, 86, 278), (.4, .4, .4));
	thread mp_railyard_viewblock1((-575.5, 86, 278), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-586, 86, 278), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-596.5, 86, 278), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-607, 86, 278), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-617.5, 86, 278), (.4, .4, .4));

	thread mp_railyard_viewblock1((-510.5, 77, 272), (.4, .4, .4));
	thread mp_railyard_viewblock1((-521, 77, 272), (.4, .4, .4));
	thread mp_railyard_viewblock1((-531.5, 77, 272), (.4, .4, .4));
	thread mp_railyard_viewblock1((-542, 77, 272), (.4, .4, .4));
	thread mp_railyard_viewblock1((-552.5, 77, 272), (.4, .4, .4));
	thread mp_railyard_viewblock1((-563, 77, 272), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-573.5, 77, 272), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-584, 77, 272), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-594.5, 77, 272), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-605, 77, 272), (.4, .4, .4));

	thread mp_railyard_viewblock1((-499, 69, 266), (.4, .4, .4));
	thread mp_railyard_viewblock1((-509.5, 69, 266), (.4, .4, .4));
	thread mp_railyard_viewblock1((-520, 69, 266), (.4, .4, .4));
	thread mp_railyard_viewblock1((-530.5, 69, 266), (.4, .4, .4));
	thread mp_railyard_viewblock1((-541, 69, 266), (.4, .4, .4));
	thread mp_railyard_viewblock1((-551.5, 69, 266), (.4, .4, .4));
	thread mp_railyard_viewblock1((-562, 69, 266), (.4, .4, .4));
	thread mp_railyard_viewblock1((-572.5, 69, 266), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-583, 69, 266), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-593.5, 69, 266), (.4, .4, .4));

// bottom schraege
	thread mp_railyard_viewblock1((-487.5, 60, 260), (.4, .4, .4));
	thread mp_railyard_viewblock1((-498, 60, 260), (.4, .4, .4));
	thread mp_railyard_viewblock1((-508.5, 60, 260), (.4, .4, .4));
	thread mp_railyard_viewblock1((-519, 60, 260), (.4, .4, .4));
	thread mp_railyard_viewblock1((-529.5, 60, 260), (.4, .4, .4));
	thread mp_railyard_viewblock1((-540, 60, 260), (.4, .4, .4));
	thread mp_railyard_viewblock1((-550.5, 60, 260), (.4, .4, .4));
	thread mp_railyard_viewblock1((-561, 60, 260), (.4, .4, .4));
	thread mp_railyard_viewblock1((-571.5, 60, 260), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-582, 60, 260), (.4, .4, .4));

// unten
	thread mp_railyard_viewblock1((-477, 52, 254), (.4, .4, .4));
	thread mp_railyard_viewblock1((-487.5, 52, 254), (.4, .4, .4));
	thread mp_railyard_viewblock1((-498, 52, 254), (.4, .4, .4));
	thread mp_railyard_viewblock1((-508.5, 52, 254), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-519, 52, 254), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-529.5, 52, 254), (.4, .4, .4));

	thread mp_railyard_viewblock1((-477, 46, 250), (.4, .4, .4));
	thread mp_railyard_viewblock1((-487.5, 46, 250), (.4, .4, .4));
	thread mp_railyard_viewblock1((-498, 46, 250), (.4, .4, .4));
	thread mp_railyard_viewblock1((-508.5, 46, 250), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-519, 46, 250), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-529.5, 46, 250), (.4, .4, .4));

	thread mp_railyard_viewblock1((-477, 36, 243), (.4, .4, .4));
	thread mp_railyard_viewblock1((-487.5, 36, 243), (.4, .4, .4));
	thread mp_railyard_viewblock1((-498, 36, 243), (.4, .4, .4));
	thread mp_railyard_viewblock1((-508.5, 36, 243), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-519, 36, 243), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-529.5, 36, 243), (.4, .4, .4));

// bottom line
	thread mp_railyard_viewblock1((-477, 26, 236), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-487.5, 26, 236), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-498, 26, 236), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-508.5, 26, 236), (.4, .4, .4));
//	thread mp_railyard_viewblock1((-519, 26, 236), (.4, .4, .4));
}

//
// VIEWBLOCK AXIS ROOF TOP
//
rpam_overhaul_railyard_roof_viewblock_top()
{
// bottom of the roof behind my blocks, if roof is full accessible
	thread mp_railyard_viewblock1((-686, 202, 360), (.4, .4, .4));
	thread mp_railyard_viewblock1((-696.5, 202, 360), (.4, .4, .4));
	thread mp_railyard_viewblock1((-707, 202, 360), (.4, .4, .4));
	thread mp_railyard_viewblock1((-717.5, 202, 360), (.4, .4, .4));
	thread mp_railyard_viewblock1((-728, 202, 360), (.4, .4, .4));
	thread mp_railyard_viewblock1((-738.5, 202, 360), (.4, .4, .4));
// 2nd
	thread mp_railyard_viewblock1((-688, 212, 367), (.4, .4, .4));
	thread mp_railyard_viewblock1((-698.5, 212, 367), (.4, .4, .4));
	thread mp_railyard_viewblock1((-709, 212, 367), (.4, .4, .4));
	thread mp_railyard_viewblock1((-719.5, 212, 367), (.4, .4, .4));
	thread mp_railyard_viewblock1((-730, 212, 367), (.4, .4, .4));
	thread mp_railyard_viewblock1((-740.5, 212, 367), (.4, .4, .4));

// 3nd
	thread mp_railyard_viewblock1((-691, 222, 374), (.4, .4, .4));
	thread mp_railyard_viewblock1((-701.5, 222, 374), (.4, .4, .4));
	thread mp_railyard_viewblock1((-712, 222, 374), (.4, .4, .4));
	thread mp_railyard_viewblock1((-722.5, 222, 374), (.4, .4, .4));
	thread mp_railyard_viewblock1((-733, 222, 374), (.4, .4, .4));
	thread mp_railyard_viewblock1((-743.5, 222, 374), (.4, .4, .4));
// 4nd
	thread mp_railyard_viewblock1((-693, 232, 381), (.4, .4, .4));
	thread mp_railyard_viewblock1((-703.5, 232, 381), (.4, .4, .4));
	thread mp_railyard_viewblock1((-714, 232, 381), (.4, .4, .4));
	thread mp_railyard_viewblock1((-724.5, 232, 381), (.4, .4, .4));
	thread mp_railyard_viewblock1((-735, 232, 381), (.4, .4, .4));
	thread mp_railyard_viewblock1((-745.5, 232, 381), (.4, .4, .4));
// 5nd
	thread mp_railyard_viewblock1((-696, 242, 388), (.4, .4, .4));
	thread mp_railyard_viewblock1((-706.5, 242, 388), (.4, .4, .4));
	thread mp_railyard_viewblock1((-717, 242, 388), (.4, .4, .4));
	thread mp_railyard_viewblock1((-727.5, 242, 388), (.4, .4, .4));
	thread mp_railyard_viewblock1((-738, 242, 388), (.4, .4, .4));
	thread mp_railyard_viewblock1((-748.5, 242, 388), (.4, .4, .4));
// 6nd
	thread mp_railyard_viewblock1((-698, 252, 395), (.4, .4, .4));
	thread mp_railyard_viewblock1((-708.5, 252, 395), (.4, .4, .4));
	thread mp_railyard_viewblock1((-719, 252, 395), (.4, .4, .4));
	thread mp_railyard_viewblock1((-729.5, 252, 395), (.4, .4, .4));
	thread mp_railyard_viewblock1((-740, 252, 395), (.4, .4, .4));
	thread mp_railyard_viewblock1((-750.5, 252, 395), (.4, .4, .4));
// 7nd
	thread mp_railyard_viewblock1((-700, 262, 402), (.4, .4, .4));
	thread mp_railyard_viewblock1((-710.5, 262, 402), (.4, .4, .4));
	thread mp_railyard_viewblock1((-721, 262, 402), (.4, .4, .4));
	thread mp_railyard_viewblock1((-731.5, 262, 402), (.4, .4, .4));
//
	thread mp_railyard_viewblock1((-743, 262, 402), (.4, .4, .4));
	thread mp_railyard_viewblock1((-753.5, 262, 402), (.4, .4, .4));
// 8nd
	thread mp_railyard_viewblock1((-701, 272, 409), (.4, .4, .4));
	thread mp_railyard_viewblock1((-711.5, 272, 409), (.4, .4, .4));
	thread mp_railyard_viewblock1((-722, 272, 409), (.4, .4, .4));
	thread mp_railyard_viewblock1((-732.5, 272, 409), (.4, .4, .4));
//
	thread mp_railyard_viewblock1((-744, 272, 409), (.4, .4, .4));
	thread mp_railyard_viewblock1((-754.5, 272, 409), (.4, .4, .4));
// 9nd
	thread mp_railyard_viewblock1((-704, 282, 416), (.4, .4, .4));
	thread mp_railyard_viewblock1((-714.5, 282, 416), (.4, .4, .4));
	thread mp_railyard_viewblock1((-725, 282, 416), (.4, .4, .4));
	thread mp_railyard_viewblock1((-735.5, 282, 416), (.4, .4, .4));
	thread mp_railyard_viewblock1((-746, 282, 416), (.4, .4, .4));
	thread mp_railyard_viewblock1((-756.5, 282, 416), (.4, .4, .4));
// 10nd
	thread mp_railyard_viewblock1((-706, 292, 423), (.4, .4, .4));
	thread mp_railyard_viewblock1((-716.5, 292, 423), (.4, .4, .4));
	thread mp_railyard_viewblock1((-727, 292, 423), (.4, .4, .4));
	thread mp_railyard_viewblock1((-737.5, 292, 423), (.4, .4, .4));
	thread mp_railyard_viewblock1((-748, 292, 423), (.4, .4, .4));
	thread mp_railyard_viewblock1((-758.5, 292, 423), (.4, .4, .4));
// 11th
	thread mp_railyard_viewblock1((-729, 302, 430), (.4, .4, .4));
	thread mp_railyard_viewblock1((-739.5, 302, 430), (.4, .4, .4));
	thread mp_railyard_viewblock1((-749, 302, 430), (.4, .4, .4));
	thread mp_railyard_viewblock1((-759.5, 302, 430), (.4, .4, .4));
}

//
//		CREATE VIEWBLOCK MODEL
//
mp_railyard_viewblock1(origin,size)
{
//	precacheModel("xmodel/woodgib_medium");		// goto precache (A) THREAD PRECHACHE

	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/woodgib_medium");

	blocker.angles = (180, 0, 55);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(0);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];

		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c03) RUINS STONECORNER COORDINATES
////////
////
// 

rpam_overhaul_railyard_axis_ruins_stonecorner()
{
	thread mp_railyard_block((-652, 751, 129), (.4, .4, .4));
	thread mp_railyard_block((-664, 751, 129), (.4, .4, .4));
	thread mp_railyard_block((-676, 751, 129), (.4, .4, .4));
	thread mp_railyard_block((-688, 751, 129), (.4, .4, .4));
	thread mp_railyard_block((-652, 770, 133), (.4, .4, .4));
//	thread mp_railyard_block((-664, 770, 134), (.4, .4, .4));
//	thread mp_railyard_block((-676, 770, 134), (.4, .4, .4));
	thread mp_railyard_block((-688, 770, 133), (.4, .4, .4));

	thread mp_railyard_block((-652, 751, 134), (.4, .4, .4));
//	thread mp_railyard_block((-664, 751, 139), (.4, .4, .4));
//	thread mp_railyard_block((-676, 751, 139), (.4, .4, .4));
	thread mp_railyard_block((-688, 751, 134), (.4, .4, .4));
	thread mp_railyard_block((-652, 761, 134), (.4, .4, .4));
//	thread mp_railyard_block((-664, 770, 139), (.4, .4, .4));
//	thread mp_railyard_block((-676, 770, 139), (.4, .4, .4));
	thread mp_railyard_block((-688, 761, 134), (.4, .4, .4));

/*	thread mp_railyard_block((-652, 751, 141), (.4, .4, .4));
	thread mp_railyard_block((-664, 751, 141), (.4, .4, .4));
	thread mp_railyard_block((-676, 751, 141), (.4, .4, .4));
	thread mp_railyard_block((-688, 751, 141), (.4, .4, .4));
	thread mp_railyard_block((-652, 761, 141), (.4, .4, .4));
	thread mp_railyard_block((-664, 761, 141), (.4, .4, .4));
	thread mp_railyard_block((-676, 761, 141), (.4, .4, .4));
	thread mp_railyard_block((-688, 761, 141), (.4, .4, .4));
	thread mp_railyard_block((-652, 772, 141), (.4, .4, .4));
	thread mp_railyard_block((-664, 772, 141), (.4, .4, .4));
	thread mp_railyard_block((-676, 772, 141), (.4, .4, .4));
	thread mp_railyard_block((-688, 772, 141), (.4, .4, .4));
	thread mp_railyard_block((-652, 782, 141), (.4, .4, .4));
	thread mp_railyard_block((-664, 782, 141), (.4, .4, .4));
	thread mp_railyard_block((-676, 782, 141), (.4, .4, .4));
//	thread mp_railyard_block((-688, 782, 141), (.4, .4, .4));
*/

// added go up from prone // (05) COORDINATES RUINS STAIRS
	thread monitor_player_position((-652, 751, 141));
//	thread monitor_player_position((-664, 751, 141));
//	thread monitor_player_position((-676, 751, 141));
	thread monitor_player_position((-688, 751, 141));
	
//	thread monitor_player_position((-652, 761, 141));
	thread monitor_player_position((-664, 761, 141));
	thread monitor_player_position((-676, 761, 141));
//	thread monitor_player_position((-688, 761, 141));
	
	thread monitor_player_position((-652, 772, 141));
//	thread monitor_player_position((-664, 772, 141));
//	thread monitor_player_position((-676, 772, 141));
	thread monitor_player_position((-688, 772, 141));
	
	thread monitor_player_position((-652, 782, 141));
//	thread monitor_player_position((-664, 782, 141));
	thread monitor_player_position((-676, 782, 141));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c04) RUINS ROOF BRICKFIX COORDINATES
////////
////
// 

rpam_overhaul_railyard_axis_ruins_roof_fix()
{
// bricks for the little hole
	thread mp_railyard_axis_ruins_roof_brick((-556, 210, 347), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-562, 210, 347), (.4, .4, .4));
// collision for the bricks
	thread mp_railyard_axis_ruins_roof_wood((-566, 210, 325), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_wood((-554, 213, 310), (.4, .4, .4));

// brick from top to bottom
	thread mp_railyard_axis_ruins_roof_brick((-550, 215, 335), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-544, 215, 331), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-550, 215, 331), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-544, 215, 327), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-550, 215, 327), (.4, .4, .4));
// bricks for the broke texture
	thread mp_railyard_axis_ruins_roof_brick((-544, 215, 323), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-550, 215, 323), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-544, 215, 319), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-550, 215, 319), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-544, 215, 315), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-550, 215, 315), (.4, .4, .4));

	thread mp_railyard_axis_ruins_roof_brick((-550, 215, 311), (.4, .4, .4));
	thread mp_railyard_axis_ruins_roof_brick((-550, 215, 307), (.4, .4, .4));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c05) RUINS ROOF BLOCKS COORDINATES
////////
////
// 

rpam_overhaul_railyard_axis_ruins_roof()
{
// Schräge Linien wie das Dach, viel deaktiviert durch das Gitter
// Unterste Linie
	thread mp_railyard_block((-678, -2, 223), (.4, .4, .4));
	thread mp_railyard_block((-678, 12, 233), (.4, .4, .4));
	thread mp_railyard_block((-678, 26, 243), (.4, .4, .4));
	thread mp_railyard_block((-678, 40, 253), (.4, .4, .4));
	thread mp_railyard_block((-678, 54, 263), (.4, .4, .4));
	thread mp_railyard_block((-678, 68, 273), (.4, .4, .4));
	thread mp_railyard_block((-678, 82, 283), (.4, .4, .4));
	thread mp_railyard_block((-678, 96, 293), (.4, .4, .4));
	thread mp_railyard_block((-678, 110, 303), (.4, .4, .4));
	thread mp_railyard_block((-678, 124, 313), (.4, .4, .4));
	thread mp_railyard_block((-678, 138, 323), (.4, .4, .4));
	thread mp_railyard_block((-678, 152, 333), (.4, .4, .4));
	thread mp_railyard_block((-678, 166, 343), (.4, .4, .4));
	thread mp_railyard_block((-678, 180, 353), (.4, .4, .4));
	thread mp_railyard_block((-678, 194, 363), (.4, .4, .4));

// Zweite Linie mittig von 16 Punkten
	thread mp_railyard_block((-678, 5, 237), (.4, .4, .4));
	thread mp_railyard_block((-678, 19, 247), (.4, .4, .4));
	thread mp_railyard_block((-678, 33, 257), (.4, .4, .4));
	thread mp_railyard_block((-678, 47, 267), (.4, .4, .4));
	thread mp_railyard_block((-678, 61, 277), (.4, .4, .4));
	thread mp_railyard_block((-678, 75, 287), (.4, .4, .4));
	thread mp_railyard_block((-678, 89, 297), (.4, .4, .4));
	thread mp_railyard_block((-678, 103, 307), (.4, .4, .4));
	thread mp_railyard_block((-678, 117, 317), (.4, .4, .4));
	thread mp_railyard_block((-678, 131, 327), (.4, .4, .4));
	thread mp_railyard_block((-678, 145, 337), (.4, .4, .4));
	thread mp_railyard_block((-678, 159, 347), (.4, .4, .4));
	thread mp_railyard_block((-678, 173, 357), (.4, .4, .4));
	thread mp_railyard_block((-678, 187, 367), (.4, .4, .4));

// Dritte / Unterste Linie /// +18
	thread mp_railyard_block((-678, -2, 241), (.4, .4, .4));
	thread mp_railyard_block((-678, 12, 251), (.4, .4, .4));
	thread mp_railyard_block((-678, 26, 261), (.4, .4, .4));
//	thread mp_railyard_block((-678, 40, 271), (.4, .4, .4));
/*	thread mp_railyard_block((-678, 54, 281), (.4, .4, .4));
	thread mp_railyard_block((-678, 68, 291), (.4, .4, .4));
	thread mp_railyard_block((-678, 82, 301), (.4, .4, .4));
	thread mp_railyard_block((-678, 96, 311), (.4, .4, .4));
	thread mp_railyard_block((-678, 110, 321), (.4, .4, .4));
	thread mp_railyard_block((-678, 124, 331), (.4, .4, .4));
	thread mp_railyard_block((-678, 138, 341), (.4, .4, .4));
	thread mp_railyard_block((-678, 152, 351), (.4, .4, .4));
	thread mp_railyard_block((-678, 166, 361), (.4, .4, .4));
	thread mp_railyard_block((-678, 180, 371), (.4, .4, .4));
	thread mp_railyard_block((-678, 194, 381), (.4, .4, .4));
*/
// Vierte / Zweite Linie mittig von 16 Punkten /// +18
	thread mp_railyard_block((-678, 5, 255), (.4, .4, .4));
	thread mp_railyard_block((-678, 19, 265), (.4, .4, .4));
//	thread mp_railyard_block((-678, 33, 275), (.4, .4, .4));
/*	thread mp_railyard_block((-678, 47, 285), (.4, .4, .4));
	thread mp_railyard_block((-678, 61, 295), (.4, .4, .4));
	thread mp_railyard_block((-678, 75, 305), (.4, .4, .4));
	thread mp_railyard_block((-678, 89, 315), (.4, .4, .4));
	thread mp_railyard_block((-678, 103, 325), (.4, .4, .4));
	thread mp_railyard_block((-678, 117, 335), (.4, .4, .4));
	thread mp_railyard_block((-678, 131, 345), (.4, .4, .4));
	thread mp_railyard_block((-678, 145, 355), (.4, .4, .4));
	thread mp_railyard_block((-678, 159, 365), (.4, .4, .4));
	thread mp_railyard_block((-678, 173, 375), (.4, .4, .4));
	thread mp_railyard_block((-678, 187, 385), (.4, .4, .4));
*/
// Fünfte / Unterste Linie /// +18 +18
/*	thread mp_railyard_block((-678, -2, 259), (.4, .4, .4));
	thread mp_railyard_block((-678, 12, 269), (.4, .4, .4));
	thread mp_railyard_block((-678, 26, 279), (.4, .4, .4));
	thread mp_railyard_block((-678, 40, 289), (.4, .4, .4));
	thread mp_railyard_block((-678, 54, 299), (.4, .4, .4));
	thread mp_railyard_block((-678, 68, 309), (.4, .4, .4));
	thread mp_railyard_block((-678, 82, 319), (.4, .4, .4));
	thread mp_railyard_block((-678, 96, 329), (.4, .4, .4));
	thread mp_railyard_block((-678, 110, 339), (.4, .4, .4));
	thread mp_railyard_block((-678, 124, 349), (.4, .4, .4));
	thread mp_railyard_block((-678, 138, 359), (.4, .4, .4));
	thread mp_railyard_block((-678, 152, 369), (.4, .4, .4));
	thread mp_railyard_block((-678, 166, 379), (.4, .4, .4));
	thread mp_railyard_block((-678, 180, 389), (.4, .4, .4));
	thread mp_railyard_block((-678, 194, 399), (.4, .4, .4));

// Sechste / Zweite Linie mittig von 16 Punkten /// +18 +18
	thread mp_railyard_block((-678, 5, 273), (.4, .4, .4));
	thread mp_railyard_block((-678, 19, 283), (.4, .4, .4));
	thread mp_railyard_block((-678, 33, 293), (.4, .4, .4));
	thread mp_railyard_block((-678, 47, 303), (.4, .4, .4));
	thread mp_railyard_block((-678, 61, 313), (.4, .4, .4));
	thread mp_railyard_block((-678, 75, 323), (.4, .4, .4));
	thread mp_railyard_block((-678, 89, 333), (.4, .4, .4));
	thread mp_railyard_block((-678, 103, 343), (.4, .4, .4));
	thread mp_railyard_block((-678, 117, 353), (.4, .4, .4));
	thread mp_railyard_block((-678, 131, 363), (.4, .4, .4));
	thread mp_railyard_block((-678, 145, 373), (.4, .4, .4));
	thread mp_railyard_block((-678, 159, 383), (.4, .4, .4));
	thread mp_railyard_block((-678, 173, 393), (.4, .4, .4));
	thread mp_railyard_block((-678, 187, 403), (.4, .4, .4));

// Siebte / Unterste Linie /// +18 +18 +18
	thread mp_railyard_block((-678, -2, 277), (.4, .4, .4));
	thread mp_railyard_block((-678, 12, 287), (.4, .4, .4));
	thread mp_railyard_block((-678, 26, 297), (.4, .4, .4));
	thread mp_railyard_block((-678, 40, 307), (.4, .4, .4));
	thread mp_railyard_block((-678, 54, 317), (.4, .4, .4));
	thread mp_railyard_block((-678, 68, 327), (.4, .4, .4));
	thread mp_railyard_block((-678, 82, 337), (.4, .4, .4));
	thread mp_railyard_block((-678, 96, 347), (.4, .4, .4));
	thread mp_railyard_block((-678, 110, 357), (.4, .4, .4));
	thread mp_railyard_block((-678, 124, 367), (.4, .4, .4));
	thread mp_railyard_block((-678, 138, 377), (.4, .4, .4));
	thread mp_railyard_block((-678, 152, 387), (.4, .4, .4));
	thread mp_railyard_block((-678, 166, 397), (.4, .4, .4));
	thread mp_railyard_block((-678, 180, 407), (.4, .4, .4));
	thread mp_railyard_block((-678, 194, 417), (.4, .4, .4));

// Achte / Zweite Linie mittig von 16 Punkten /// +18 +18 +18
	thread mp_railyard_block((-678, 5, 291), (.4, .4, .4));
	thread mp_railyard_block((-678, 19, 301), (.4, .4, .4));
	thread mp_railyard_block((-678, 33, 311), (.4, .4, .4));
	thread mp_railyard_block((-678, 47, 321), (.4, .4, .4));
	thread mp_railyard_block((-678, 61, 331), (.4, .4, .4));
	thread mp_railyard_block((-678, 75, 341), (.4, .4, .4));
	thread mp_railyard_block((-678, 89, 351), (.4, .4, .4));
	thread mp_railyard_block((-678, 103, 361), (.4, .4, .4));
	thread mp_railyard_block((-678, 117, 371), (.4, .4, .4));
	thread mp_railyard_block((-678, 131, 381), (.4, .4, .4));
	thread mp_railyard_block((-678, 145, 391), (.4, .4, .4));
	thread mp_railyard_block((-678, 159, 401), (.4, .4, .4));
	thread mp_railyard_block((-678, 173, 411), (.4, .4, .4));
	thread mp_railyard_block((-678, 187, 421), (.4, .4, .4));
*/

// Gitter von oben nach unten
//	thread mp_railyard_block((-678, -2, 425), (.8, .8, .8));
//	thread mp_railyard_block((-678, 18, 425), (.8, .8, .8));
//	thread mp_railyard_block((-678, 38, 425), (.8, .8, .8));
	thread mp_railyard_block((-678, 58, 425), (.8, .8, .8));
	thread mp_railyard_block((-678, 78, 425), (.8, .8, .8));
	thread mp_railyard_block((-678, 98, 425), (.8, .8, .8));
	thread mp_railyard_block((-678, 118, 425), (.8, .8, .8));
	thread mp_railyard_block((-678, 138, 425), (.8, .8, .8));
	thread mp_railyard_block((-678, 158, 425), (.8, .8, .8));
	thread mp_railyard_block((-678, 178, 425), (.8, .8, .8));
	thread mp_railyard_block((-678, 198, 425), (.8, .8, .8));

//	thread mp_railyard_block((-678, -2, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 18, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 38, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 58, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 78, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 98, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 118, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 138, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 158, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 178, 405), (.8, .8, .8));
	thread mp_railyard_block((-678, 198, 405), (.8, .8, .8));

	thread mp_railyard_block((-678, -2, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 18, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 38, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 58, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 78, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 98, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 118, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 138, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 158, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 178, 385), (.8, .8, .8));
	thread mp_railyard_block((-678, 198, 385), (.8, .8, .8));

	thread mp_railyard_block((-678, -2, 365), (.8, .8, .8));
	thread mp_railyard_block((-678, 18, 365), (.8, .8, .8));
	thread mp_railyard_block((-678, 38, 365), (.8, .8, .8));
	thread mp_railyard_block((-678, 58, 365), (.8, .8, .8));
	thread mp_railyard_block((-678, 78, 365), (.8, .8, .8));
	thread mp_railyard_block((-678, 98, 365), (.8, .8, .8));
	thread mp_railyard_block((-678, 118, 365), (.8, .8, .8));
	thread mp_railyard_block((-678, 138, 365), (.8, .8, .8));
	thread mp_railyard_block((-678, 158, 365), (.8, .8, .8));
//	thread mp_railyard_block((-678, 178, 365), (.8, .8, .8));
//	thread mp_railyard_block((-678, 198, 365), (.8, .8, .8));

	thread mp_railyard_block((-678, -2, 345), (.8, .8, .8));
	thread mp_railyard_block((-678, 18, 345), (.8, .8, .8));
	thread mp_railyard_block((-678, 38, 345), (.8, .8, .8));
	thread mp_railyard_block((-678, 58, 345), (.8, .8, .8));
	thread mp_railyard_block((-678, 78, 345), (.8, .8, .8));
	thread mp_railyard_block((-678, 98, 345), (.8, .8, .8));
	thread mp_railyard_block((-678, 118, 345), (.8, .8, .8));
	thread mp_railyard_block((-678, 138, 345), (.8, .8, .8));
//	thread mp_railyard_block((-678, 158, 345), (.8, .8, .8));
//	thread mp_railyard_block((-678, 178, 345), (.8, .8, .8));
//	thread mp_railyard_block((-678, 198, 345), (.8, .8, .8));

	thread mp_railyard_block((-678, -2, 325), (.8, .8, .8));
	thread mp_railyard_block((-678, 18, 325), (.8, .8, .8));
	thread mp_railyard_block((-678, 38, 325), (.8, .8, .8));
	thread mp_railyard_block((-678, 58, 325), (.8, .8, .8));
	thread mp_railyard_block((-678, 78, 325), (.8, .8, .8));
	thread mp_railyard_block((-678, 98, 325), (.8, .8, .8));
	thread mp_railyard_block((-678, 118, 325), (.8, .8, .8));
//	thread mp_railyard_block((-678, 138, 325), (.8, .8, .8));
//	thread mp_railyard_block((-678, 158, 325), (.8, .8, .8));
//	thread mp_railyard_block((-678, 178, 325), (.8, .8, .8));
//	thread mp_railyard_block((-678, 198, 325), (.8, .8, .8));

	thread mp_railyard_block((-678, -2, 305), (.8, .8, .8));
	thread mp_railyard_block((-678, 18, 305), (.8, .8, .8));
	thread mp_railyard_block((-678, 38, 305), (.8, .8, .8));
	thread mp_railyard_block((-678, 58, 305), (.8, .8, .8));
	thread mp_railyard_block((-678, 78, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 98, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 118, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 138, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 158, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 178, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 198, 305), (.8, .8, .8));

	thread mp_railyard_block((-678, -2, 285), (.8, .8, .8));
	thread mp_railyard_block((-678, 18, 285), (.8, .8, .8));
	thread mp_railyard_block((-678, 38, 285), (.8, .8, .8));
	thread mp_railyard_block((-678, 58, 285), (.8, .8, .8));
//	thread mp_railyard_block((-678, 78, 285), (.8, .8, .8));
//	thread mp_railyard_block((-678, 98, 285), (.8, .8, .8));
//	thread mp_railyard_block((-678, 118, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 138, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 158, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 178, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 198, 305), (.8, .8, .8));

	thread mp_railyard_block((-678, -2, 265), (.8, .8, .8));
//	thread mp_railyard_block((-678, 18, 265), (.8, .8, .8));
//	thread mp_railyard_block((-678, 38, 265), (.8, .8, .8));
//	thread mp_railyard_block((-678, 58, 265), (.8, .8, .8));
//	thread mp_railyard_block((-678, 78, 285), (.8, .8, .8));
//	thread mp_railyard_block((-678, 98, 285), (.8, .8, .8));
//	thread mp_railyard_block((-678, 118, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 138, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 158, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 178, 305), (.8, .8, .8));
//	thread mp_railyard_block((-678, 198, 305), (.8, .8, .8));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c06) RUINS ROOF BLOCKS MOVED
////////
////
// 

rpam_overhaul_railyard_axis_ruins_roof_moved()
{
// Schräge Linien wie das Dach, viel deaktiviert durch das Gitter
// Unterste Linie
	thread mp_railyard_block((-687, -2, 223), (.4, .4, .4));
	thread mp_railyard_block((-687, 12, 233), (.4, .4, .4));
	thread mp_railyard_block((-687, 26, 243), (.4, .4, .4));
	thread mp_railyard_block((-687, 40, 253), (.4, .4, .4));
	thread mp_railyard_block((-687, 54, 263), (.4, .4, .4));
	thread mp_railyard_block((-687, 68, 273), (.4, .4, .4));
	thread mp_railyard_block((-687, 82, 283), (.4, .4, .4));
	thread mp_railyard_block((-687, 96, 293), (.4, .4, .4));
	thread mp_railyard_block((-687, 110, 303), (.4, .4, .4));
	thread mp_railyard_block((-687, 124, 313), (.4, .4, .4));
	thread mp_railyard_block((-687, 138, 323), (.4, .4, .4));
	thread mp_railyard_block((-687, 152, 333), (.4, .4, .4));
	thread mp_railyard_block((-687, 166, 343), (.4, .4, .4));
	thread mp_railyard_block((-687, 180, 353), (.4, .4, .4));
	thread mp_railyard_block((-687, 194, 363), (.4, .4, .4));

// Zweite Linie mittig von 16 Punkten
	thread mp_railyard_block((-687, 5, 237), (.4, .4, .4));
	thread mp_railyard_block((-687, 19, 247), (.4, .4, .4));
	thread mp_railyard_block((-687, 33, 257), (.4, .4, .4));
	thread mp_railyard_block((-687, 47, 267), (.4, .4, .4));
	thread mp_railyard_block((-687, 61, 277), (.4, .4, .4));
	thread mp_railyard_block((-687, 75, 287), (.4, .4, .4));
	thread mp_railyard_block((-687, 89, 297), (.4, .4, .4));
	thread mp_railyard_block((-687, 103, 307), (.4, .4, .4));
	thread mp_railyard_block((-687, 117, 317), (.4, .4, .4));
	thread mp_railyard_block((-687, 131, 327), (.4, .4, .4));
	thread mp_railyard_block((-687, 145, 337), (.4, .4, .4));
	thread mp_railyard_block((-687, 159, 347), (.4, .4, .4));
	thread mp_railyard_block((-687, 173, 357), (.4, .4, .4));
	thread mp_railyard_block((-687, 187, 367), (.4, .4, .4));

// Dritte / Unterste Linie /// +18
	thread mp_railyard_block((-687, -2, 241), (.4, .4, .4));
	thread mp_railyard_block((-687, 12, 251), (.4, .4, .4));
	thread mp_railyard_block((-687, 26, 261), (.4, .4, .4));

// Vierte / Zweite Linie mittig von 16 Punkten /// +18
	thread mp_railyard_block((-687, 5, 255), (.4, .4, .4));
	thread mp_railyard_block((-687, 19, 265), (.4, .4, .4));

// Gitter von oben nach unten
	thread mp_railyard_block((-687, 58, 425), (.8, .8, .8));
	thread mp_railyard_block((-687, 78, 425), (.8, .8, .8));
	thread mp_railyard_block((-687, 98, 425), (.8, .8, .8));
	thread mp_railyard_block((-687, 118, 425), (.8, .8, .8));
	thread mp_railyard_block((-687, 138, 425), (.8, .8, .8));
	thread mp_railyard_block((-687, 158, 425), (.8, .8, .8));
	thread mp_railyard_block((-687, 178, 425), (.8, .8, .8));
	thread mp_railyard_block((-687, 198, 425), (.8, .8, .8));

	thread mp_railyard_block((-687, 18, 405), (.8, .8, .8));
	thread mp_railyard_block((-687, 38, 405), (.8, .8, .8));
	thread mp_railyard_block((-687, 58, 405), (.8, .8, .8));
	thread mp_railyard_block((-687, 78, 405), (.8, .8, .8));
	thread mp_railyard_block((-687, 98, 405), (.8, .8, .8));
	thread mp_railyard_block((-687, 118, 405), (.8, .8, .8));
	thread mp_railyard_block((-687, 138, 405), (.8, .8, .8));
	thread mp_railyard_block((-687, 158, 405), (.8, .8, .8));
	thread mp_railyard_block((-687, 178, 405), (.8, .8, .8));
	thread mp_railyard_block((-687, 198, 405), (.8, .8, .8));

	thread mp_railyard_block((-687, -2, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 18, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 38, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 58, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 78, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 98, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 118, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 138, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 158, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 178, 385), (.8, .8, .8));
	thread mp_railyard_block((-687, 198, 385), (.8, .8, .8));

	thread mp_railyard_block((-687, -2, 365), (.8, .8, .8));
	thread mp_railyard_block((-687, 18, 365), (.8, .8, .8));
	thread mp_railyard_block((-687, 38, 365), (.8, .8, .8));
	thread mp_railyard_block((-687, 58, 365), (.8, .8, .8));
	thread mp_railyard_block((-687, 78, 365), (.8, .8, .8));
	thread mp_railyard_block((-687, 98, 365), (.8, .8, .8));
	thread mp_railyard_block((-687, 118, 365), (.8, .8, .8));
	thread mp_railyard_block((-687, 138, 365), (.8, .8, .8));
	thread mp_railyard_block((-687, 158, 365), (.8, .8, .8));

	thread mp_railyard_block((-687, -2, 345), (.8, .8, .8));
	thread mp_railyard_block((-687, 18, 345), (.8, .8, .8));
	thread mp_railyard_block((-687, 38, 345), (.8, .8, .8));
	thread mp_railyard_block((-687, 58, 345), (.8, .8, .8));
	thread mp_railyard_block((-687, 78, 345), (.8, .8, .8));
	thread mp_railyard_block((-687, 98, 345), (.8, .8, .8));
	thread mp_railyard_block((-687, 118, 345), (.8, .8, .8));
	thread mp_railyard_block((-687, 138, 345), (.8, .8, .8));

	thread mp_railyard_block((-687, -2, 325), (.8, .8, .8));
	thread mp_railyard_block((-687, 18, 325), (.8, .8, .8));
	thread mp_railyard_block((-687, 38, 325), (.8, .8, .8));
	thread mp_railyard_block((-687, 58, 325), (.8, .8, .8));
	thread mp_railyard_block((-687, 78, 325), (.8, .8, .8));
	thread mp_railyard_block((-687, 98, 325), (.8, .8, .8));
	thread mp_railyard_block((-687, 118, 325), (.8, .8, .8));

	thread mp_railyard_block((-687, -2, 305), (.8, .8, .8));
	thread mp_railyard_block((-687, 18, 305), (.8, .8, .8));
	thread mp_railyard_block((-687, 38, 305), (.8, .8, .8));
	thread mp_railyard_block((-687, 58, 305), (.8, .8, .8));
	thread mp_railyard_block((-687, 78, 305), (.8, .8, .8));

	thread mp_railyard_block((-687, -2, 285), (.8, .8, .8));
	thread mp_railyard_block((-687, 18, 285), (.8, .8, .8));
	thread mp_railyard_block((-687, 38, 285), (.8, .8, .8));
	thread mp_railyard_block((-687, 58, 285), (.8, .8, .8));

	thread mp_railyard_block((-687, -2, 265), (.8, .8, .8));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c06) RUINS ROOF BLOCKS MOVED 22222
////////
////
// 

rpam_overhaul_railyard_axis_ruins_roof_moved2()
{
// Schräge Linien wie das Dach, viel deaktiviert durch das Gitter
// Unterste Linie
	thread mp_railyard_block((-705, -2, 223), (.4, .4, .4));
	thread mp_railyard_block((-705, 12, 233), (.4, .4, .4));
	thread mp_railyard_block((-705, 26, 243), (.4, .4, .4));
	thread mp_railyard_block((-705, 40, 253), (.4, .4, .4));
	thread mp_railyard_block((-705, 54, 263), (.4, .4, .4));
	thread mp_railyard_block((-705, 68, 273), (.4, .4, .4));
	thread mp_railyard_block((-705, 82, 283), (.4, .4, .4));
	thread mp_railyard_block((-705, 96, 293), (.4, .4, .4));
	thread mp_railyard_block((-705, 110, 303), (.4, .4, .4));
	thread mp_railyard_block((-705, 124, 313), (.4, .4, .4));
	thread mp_railyard_block((-705, 138, 323), (.4, .4, .4));
	thread mp_railyard_block((-705, 152, 333), (.4, .4, .4));
	thread mp_railyard_block((-705, 166, 343), (.4, .4, .4));
	thread mp_railyard_block((-705, 180, 353), (.4, .4, .4));
	thread mp_railyard_block((-705, 194, 363), (.4, .4, .4));

// Zweite Linie mittig von 16 Punkten
	thread mp_railyard_block((-705, 5, 237), (.4, .4, .4));
	thread mp_railyard_block((-705, 19, 247), (.4, .4, .4));
	thread mp_railyard_block((-705, 33, 257), (.4, .4, .4));
	thread mp_railyard_block((-705, 47, 267), (.4, .4, .4));
	thread mp_railyard_block((-705, 61, 277), (.4, .4, .4));
	thread mp_railyard_block((-705, 75, 287), (.4, .4, .4));
	thread mp_railyard_block((-705, 89, 297), (.4, .4, .4));
	thread mp_railyard_block((-705, 103, 307), (.4, .4, .4));
	thread mp_railyard_block((-705, 117, 317), (.4, .4, .4));
	thread mp_railyard_block((-705, 131, 327), (.4, .4, .4));
	thread mp_railyard_block((-705, 145, 337), (.4, .4, .4));
	thread mp_railyard_block((-705, 159, 347), (.4, .4, .4));
	thread mp_railyard_block((-705, 173, 357), (.4, .4, .4));
	thread mp_railyard_block((-705, 187, 367), (.4, .4, .4));

// Dritte / Unterste Linie /// +18
	thread mp_railyard_block((-705, -2, 241), (.4, .4, .4));
	thread mp_railyard_block((-705, 12, 251), (.4, .4, .4));
	thread mp_railyard_block((-705, 26, 261), (.4, .4, .4));

// Vierte / Zweite Linie mittig von 16 Punkten /// +18
	thread mp_railyard_block((-705, 5, 255), (.4, .4, .4));
	thread mp_railyard_block((-705, 19, 265), (.4, .4, .4));

// Gitter von oben nach unten
	thread mp_railyard_block((-705, 58, 425), (.8, .8, .8));
	thread mp_railyard_block((-705, 78, 425), (.8, .8, .8));
	thread mp_railyard_block((-705, 98, 425), (.8, .8, .8));
	thread mp_railyard_block((-705, 118, 425), (.8, .8, .8));
	thread mp_railyard_block((-705, 138, 425), (.8, .8, .8));
	thread mp_railyard_block((-705, 158, 425), (.8, .8, .8));
	thread mp_railyard_block((-705, 178, 425), (.8, .8, .8));
	thread mp_railyard_block((-705, 198, 425), (.8, .8, .8));

	thread mp_railyard_block((-705, 18, 405), (.8, .8, .8));
	thread mp_railyard_block((-705, 38, 405), (.8, .8, .8));
	thread mp_railyard_block((-705, 58, 405), (.8, .8, .8));
	thread mp_railyard_block((-705, 78, 405), (.8, .8, .8));
	thread mp_railyard_block((-705, 98, 405), (.8, .8, .8));
	thread mp_railyard_block((-705, 118, 405), (.8, .8, .8));
	thread mp_railyard_block((-705, 138, 405), (.8, .8, .8));
	thread mp_railyard_block((-705, 158, 405), (.8, .8, .8));
	thread mp_railyard_block((-705, 178, 405), (.8, .8, .8));
	thread mp_railyard_block((-705, 198, 405), (.8, .8, .8));

	thread mp_railyard_block((-705, -2, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 18, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 38, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 58, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 78, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 98, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 118, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 138, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 158, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 178, 385), (.8, .8, .8));
	thread mp_railyard_block((-705, 198, 385), (.8, .8, .8));

	thread mp_railyard_block((-705, -2, 365), (.8, .8, .8));
	thread mp_railyard_block((-705, 18, 365), (.8, .8, .8));
	thread mp_railyard_block((-705, 38, 365), (.8, .8, .8));
	thread mp_railyard_block((-705, 58, 365), (.8, .8, .8));
	thread mp_railyard_block((-705, 78, 365), (.8, .8, .8));
	thread mp_railyard_block((-705, 98, 365), (.8, .8, .8));
	thread mp_railyard_block((-705, 118, 365), (.8, .8, .8));
	thread mp_railyard_block((-705, 138, 365), (.8, .8, .8));
	thread mp_railyard_block((-705, 158, 365), (.8, .8, .8));

	thread mp_railyard_block((-705, -2, 345), (.8, .8, .8));
	thread mp_railyard_block((-705, 18, 345), (.8, .8, .8));
	thread mp_railyard_block((-705, 38, 345), (.8, .8, .8));
	thread mp_railyard_block((-705, 58, 345), (.8, .8, .8));
	thread mp_railyard_block((-705, 78, 345), (.8, .8, .8));
	thread mp_railyard_block((-705, 98, 345), (.8, .8, .8));
	thread mp_railyard_block((-705, 118, 345), (.8, .8, .8));
	thread mp_railyard_block((-705, 138, 345), (.8, .8, .8));

	thread mp_railyard_block((-705, -2, 325), (.8, .8, .8));
	thread mp_railyard_block((-705, 18, 325), (.8, .8, .8));
	thread mp_railyard_block((-705, 38, 325), (.8, .8, .8));
	thread mp_railyard_block((-705, 58, 325), (.8, .8, .8));
	thread mp_railyard_block((-705, 78, 325), (.8, .8, .8));
	thread mp_railyard_block((-705, 98, 325), (.8, .8, .8));
	thread mp_railyard_block((-705, 118, 325), (.8, .8, .8));

	thread mp_railyard_block((-705, -2, 305), (.8, .8, .8));
	thread mp_railyard_block((-705, 18, 305), (.8, .8, .8));
	thread mp_railyard_block((-705, 38, 305), (.8, .8, .8));
	thread mp_railyard_block((-705, 58, 305), (.8, .8, .8));
	thread mp_railyard_block((-705, 78, 305), (.8, .8, .8));

	thread mp_railyard_block((-705, -2, 285), (.8, .8, .8));
	thread mp_railyard_block((-705, 18, 285), (.8, .8, .8));
	thread mp_railyard_block((-705, 38, 285), (.8, .8, .8));
	thread mp_railyard_block((-705, 58, 285), (.8, .8, .8));

	thread mp_railyard_block((-705, -2, 265), (.8, .8, .8));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c07) OBJECTS COORDINATES
////////
////
// 

rpam_overhaul_railyard_models()
{
	thread mp_railyard_tree((-3887,4699,35), (.4,.4,.4));
	thread mp_railyard_tree((-4116,4183,-71), (.4,.4,.4));
	thread mp_railyard_smalltree((-3114,4310,34), (.4,.4,.4));
	thread mp_railyard_truck1((-2379,3713,-60), (.4,.4,.4));
	thread mp_railyard_truck2((-2626,3984,-59), (.4,.4,.4));
	thread mp_railyard_truck2box((-2624,3982,9), (.4,.4,.4));
	thread mp_railyard_truck2box((-2640,3989,9), (.4,.4,.4));
}

rpam_overhaul_railyard_models2()
{
// A GATE POSITION
	thread mp_railyard_sandbags_short_winter((722,1689,2), (.5,.5,.5));
	thread mp_railyard_sandbags_long_winter((1264,1422,4), (.5,.5,.5));
//	thread mp_railyard_crate_misc1_stalingrad((1293,1364,4), (1,1,1));

//	if (getcvar("g_gametype") == "sd")
		thread mp_railyard_german_truck((1101,1706,0), (.5,.5,.5));
//	else if (getcvar("g_gametype") == "dm")
//		thread mp_railyard_mg42_bipod((1155,1445,2), (1,1,1));
//	else
//		thread mp_railyard_german_truck((1101,1706,0), (.5,.5,.5));

// Added tree at axis spawn
	thread mp_railyard_tree((-348,-2170,187), (1,1,1));

// Added tree russian spawn left of it
	thread mp_railyard_tree((-1243,4305,-13), (1,1,1));
	thread mp_railyard_tree((286,4665,-57), (1,1,1));

// Added barrels russian spawn left of it
//	thread mp_railyard_barrel_black2snowy((214,3236,-63), (1,1,1));
//	thread mp_railyard_barrel_black2snowy2((214,3236,-63), (1,1,1));
	thread mp_railyard_barrel_black2snowy1((214,3236,-63), (1,1,1));
	thread mp_railyard_barrel_green2snowy((243,3235,-63), (1,1,1));
	thread mp_railyard_barrel_black2snowy3((277,3236,-63), (1,1,1));
	if (getcvar("g_gametype") == "sd")
		thread mp_railyard_barrel_black2snowy4((237,3267,-63), (1,1,1));

	if (getcvar("g_gametype") == "dm")
		thread mp_railyard_vehicle_german_kubelwagen((282,3767,-65), (1,1,1));
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c08) BOMBSPOTS COORDINATES
////////
////
// 

rpam_overhaul_railyard_bombspots()
{
// Tank A holes
	thread mp_railyard_tank_a_left((-258,1372,43), (.5,.5,.5));
	thread mp_railyard_tank_a_right((-258,1291,43), (.5,.5,.5));

// Tank A barrels
	thread mp_railyard_tank_a_left((-258,1348,48), (.5,.5,.5));
	thread mp_railyard_tank_a_right((-258,1315,48), (.5,.5,.5));

	thread mp_railyard_tank_a_left((-258,1348,60), (.5,.5,.5));
	thread mp_railyard_tank_a_right((-258,1315,60), (.5,.5,.5));

	thread mp_railyard_tank_a_left((-258,1348,72), (.5,.5,.5));
	thread mp_railyard_tank_a_right((-258,1315,72), (.5,.5,.5));

// Tank B
	thread mp_railyard_tank_b_left((-2116,-418,104), (.5,.5,.5));
	thread mp_railyard_tank_b_right((-2117,-542,104), (.5,.5,.5));
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c09) AXIS STATION COORDINATES
////////
////
// 

//
//		WOODSTATION RUINS SIDE
//
rpam_overhaul_railyard_axis_woodstation_ruins()
{
// Looking Position: starts from  Axis ruins and, or right to left by ineyes
// first fence
// unten
	thread mp_railyard_wood1up((-520, -357, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-496, -357, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-472, -357, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-448, -357, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-422, -357, 26), (.4, .4, .4));

	thread mp_railyard_wood1up((-400, -357, 26), (.4, .4, .4));
//	thread mp_railyard_wood1up((-376, -357, 26), (.4, .4, .4));
//	thread mp_railyard_wood1up((-352, -357, 26), (.4, .4, .4));
//	thread mp_railyard_wood1up((-328, -357, 26), (.4, .4, .4));
//	thread mp_railyard_wood1up((-304, -357, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-280, -357, 26), (.4, .4, .4));

	thread mp_railyard_wood1up((-256, -357, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-232, -357, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-208, -357, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-184, -357, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-160, -357, 26), (.4, .4, .4));
// 2nd
	thread mp_railyard_wood1down((-520, -357, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-496, -357, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-472, -357, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-448, -357, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-424, -357, -2), (.4, .4, .4));

	thread mp_railyard_wood1down((-400, -357, -2), (.4, .4, .4));
//	thread mp_railyard_wood1down((-376, -357, -2), (.4, .4, .4));
//	thread mp_railyard_wood1down((-352, -357, -2), (.4, .4, .4));
//	thread mp_railyard_wood1down((-328, -357, -2), (.4, .4, .4));
//	thread mp_railyard_wood1down((-304, -357, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-280, -357, -2), (.4, .4, .4));

	thread mp_railyard_wood1down((-256, -357, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-232, -357, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-208, -357, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-184, -357, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-160, -357, -2), (.4, .4, .4));
// 1st
	thread mp_railyard_wood1up((-520, -357, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-496, -357, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-472, -357, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-448, -357, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-424, -357, 50), (.4, .4, .4));

	thread mp_railyard_wood1up((-400, -357, 50), (.4, .4, .4));
//	thread mp_railyard_wood1up((-376, -357, 50), (.4, .4, .4));
//	thread mp_railyard_wood1up((-352, -357, 50), (.4, .4, .4));
//	thread mp_railyard_wood1up((-328, -357, 50), (.4, .4, .4));
//	thread mp_railyard_wood1up((-304, -357, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-280, -357, 50), (.4, .4, .4));

	thread mp_railyard_wood1up((-256, -357, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-232, -357, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-208, -357, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-184, -357, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-160, -357, 50), (.4, .4, .4));
// oben
	thread mp_railyard_wood1down((-520, -357, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-496, -357, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-472, -357, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-448, -357, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-424, -357, 22), (.4, .4, .4));

	thread mp_railyard_wood1down((-400, -357, 22), (.4, .4, .4));
//	thread mp_railyard_wood1down((-376, -357, 22), (.4, .4, .4));
//	thread mp_railyard_wood1down((-352, -357, 22), (.4, .4, .4));
//	thread mp_railyard_wood1down((-328, -357, 22), (.4, .4, .4));
//	thread mp_railyard_wood1down((-304, -357, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-280, -357, 22), (.4, .4, .4));

	thread mp_railyard_wood1down((-256, -357, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-232, -357, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-208, -357, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-184, -357, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-160, -357, 22), (.4, .4, .4));

// mid fence 1
	thread mp_railyard_wood1up((-400, -605, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-376, -605, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-352, -605, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-328, -605, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-304, -605, 26), (.4, .4, .4));
	thread mp_railyard_wood1up((-280, -605, 26), (.4, .4, .4));
//
	thread mp_railyard_wood1down((-400, -605, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-376, -605, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-352, -605, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-328, -605, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-304, -605, -2), (.4, .4, .4));
	thread mp_railyard_wood1down((-280, -605, -2), (.4, .4, .4));
//
	thread mp_railyard_wood1up((-400, -605, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-376, -605, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-352, -605, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-328, -605, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-304, -605, 50), (.4, .4, .4));
	thread mp_railyard_wood1up((-280, -605, 50), (.4, .4, .4));
// oben
	thread mp_railyard_wood1down((-400, -605, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-376, -605, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-352, -605, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-328, -605, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-304, -605, 22), (.4, .4, .4));
	thread mp_railyard_wood1down((-280, -605, 22), (.4, .4, .4));
}

//
//		WOODSTATION SPAWN SIDE
//
rpam_overhaul_railyard_axis_woodstation_spawn()
{
// Looking Position: starts from  Axis ruins and, or right to left by ineyes
// 3rd fence
// unten
	thread mp_railyard_wood1up2((-520, -739, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-496, -739, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-472, -739, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-448, -739, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-424, -739, 26), (.4, .4, .4));

	thread mp_railyard_wood1up2((-400, -739, 26), (.4, .4, .4));
//	thread mp_railyard_wood1up2((-376, -739, 26), (.4, .4, .4));
//	thread mp_railyard_wood1up2((-352, -739, 26), (.4, .4, .4));
//	thread mp_railyard_wood1up2((-328, -739, 26), (.4, .4, .4));
//	thread mp_railyard_wood1up2((-304, -739, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-280, -739, 26), (.4, .4, .4));

	thread mp_railyard_wood1up2((-256, -739, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-232, -739, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-208, -739, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-184, -739, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-160, -739, 26), (.4, .4, .4));
//
	thread mp_railyard_wood1down2((-520, -739, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-496, -739, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-472, -739, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-448, -739, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-424, -739, -2), (.4, .4, .4));

	thread mp_railyard_wood1down2((-400, -739, -2), (.4, .4, .4));
//	thread mp_railyard_wood1down2((-376, -739, -2), (.4, .4, .4));
//	thread mp_railyard_wood1down2((-352, -739, -2), (.4, .4, .4));
//	thread mp_railyard_wood1down2((-328, -739, -2), (.4, .4, .4));
//	thread mp_railyard_wood1down2((-304, -739, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-280, -739, -2), (.4, .4, .4));

	thread mp_railyard_wood1down2((-256, -739, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-232, -739, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-208, -739, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-184, -739, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-160, -739, -2), (.4, .4, .4));
//
	thread mp_railyard_wood1up2((-520, -739, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-496, -739, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-472, -739, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-448, -739, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-424, -739, 50), (.4, .4, .4));

	thread mp_railyard_wood1up2((-400, -739, 50), (.4, .4, .4));
//	thread mp_railyard_wood1up2((-376, -739, 52), (.4, .4, .4));
//	thread mp_railyard_wood1up2((-352, -739, 52), (.4, .4, .4));
//	thread mp_railyard_wood1up2((-328, -739, 52), (.4, .4, .4));
//	thread mp_railyard_wood1up2((-304, -739, 52), (.4, .4, .4));
	thread mp_railyard_wood1up2((-280, -739, 50), (.4, .4, .4));

	thread mp_railyard_wood1up2((-256, -739, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-232, -739, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-208, -739, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-184, -739, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-160, -739, 50), (.4, .4, .4));
// oben
	thread mp_railyard_wood1down2((-520, -739, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-496, -739, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-472, -739, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-448, -739, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-424, -739, 22), (.4, .4, .4));

	thread mp_railyard_wood1down2((-400, -739, 22), (.4, .4, .4));
//	thread mp_railyard_wood1down2((-376, -739, 22), (.4, .4, .4));
//	thread mp_railyard_wood1down2((-352, -739, 22), (.4, .4, .4));
//	thread mp_railyard_wood1down2((-328, -739, 22), (.4, .4, .4));
//	thread mp_railyard_wood1down2((-304, -739, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-280, -739, 22), (.4, .4, .4));

	thread mp_railyard_wood1down2((-256, -739, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-232, -739, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-208, -739, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-184, -739, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-160, -739, 22), (.4, .4, .4));

/* deactivated to prevent overload
// 4th fence at axis spawn
	thread mp_railyard_wood1up2((-400, -987, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-376, -987, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-352, -987, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-328, -987, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-304, -987, 26), (.4, .4, .4));
	thread mp_railyard_wood1up2((-280, -987, 26), (.4, .4, .4));
//
	thread mp_railyard_wood1down2((-400, -987, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-376, -987, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-352, -987, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-328, -987, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-304, -987, -2), (.4, .4, .4));
	thread mp_railyard_wood1down2((-280, -987, -2), (.4, .4, .4));
//
	thread mp_railyard_wood1up2((-400, -987, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-376, -987, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-352, -987, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-328, -987, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-304, -987, 50), (.4, .4, .4));
	thread mp_railyard_wood1up2((-280, -987, 50), (.4, .4, .4));
// oben
	thread mp_railyard_wood1down2((-400, -987, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-376, -987, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-352, -987, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-328, -987, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-304, -987, 22), (.4, .4, .4));
	thread mp_railyard_wood1down2((-280, -987, 22), (.4, .4, .4));
*/
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(b01) BLOCK THE JUMP TO AXIS ROOF JUMPPOSITION COORDINATES
////////
////
// 

rpam_overhaul_railyard_axis_jumpposition()
{
// blocking access to get up to the axis roofjump, still can jump to the rail
		thread mp_railyard_block((-456,208,260), (.4,.4,.4));
		thread mp_railyard_block((-456,216,260), (.4,.4,.4));
		thread mp_railyard_block((-456,224,260), (.4,.4,.4));

		thread mp_railyard_block((-455,208,270), (.4,.4,.4));
		thread mp_railyard_block((-455,216,270), (.4,.4,.4));
		thread mp_railyard_block((-455,224,270), (.4,.4,.4));

		thread mp_railyard_block((-455,208,280), (.4,.4,.4));
		thread mp_railyard_block((-455,216,280), (.4,.4,.4));
		thread mp_railyard_block((-455,224,280), (.4,.4,.4));

// blocking axis roof landing zone
		thread mp_railyard_block((-545,130,305), (.4,.4,.4));
		thread mp_railyard_block((-545,130,315), (.4,.4,.4));
		thread mp_railyard_block((-545,130,325), (.4,.4,.4));
		thread mp_railyard_block((-545,130,335), (.4,.4,.4));
		thread mp_railyard_block((-545,130,345), (.4,.4,.4));

		thread mp_railyard_block((-545,120,300), (.4,.4,.4));
		thread mp_railyard_block((-545,120,310), (.4,.4,.4));
		thread mp_railyard_block((-545,120,320), (.4,.4,.4));
		thread mp_railyard_block((-545,120,330), (.4,.4,.4));
		thread mp_railyard_block((-545,120,340), (.4,.4,.4));

		thread mp_railyard_block((-535,112,297), (.4,.4,.4));
		thread mp_railyard_block((-535,112,307), (.4,.4,.4));
		thread mp_railyard_block((-535,112,317), (.4,.4,.4));
		thread mp_railyard_block((-535,112,327), (.4,.4,.4));
		thread mp_railyard_block((-535,112,337), (.4,.4,.4));
		thread mp_railyard_block((-535,112,347), (.4,.4,.4));

		thread mp_railyard_block((-525,106,294), (.4,.4,.4));
		thread mp_railyard_block((-525,106,304), (.4,.4,.4));
		thread mp_railyard_block((-525,106,314), (.4,.4,.4));
		thread mp_railyard_block((-525,106,324), (.4,.4,.4));
		thread mp_railyard_block((-525,106,334), (.4,.4,.4));
		thread mp_railyard_block((-525,106,344), (.4,.4,.4));

		thread mp_railyard_block((-515,98,289), (.4,.4,.4));
		thread mp_railyard_block((-515,98,299), (.4,.4,.4));
		thread mp_railyard_block((-515,98,309), (.4,.4,.4));
		thread mp_railyard_block((-515,98,319), (.4,.4,.4));
		thread mp_railyard_block((-515,98,329), (.4,.4,.4));
		thread mp_railyard_block((-515,98,339), (.4,.4,.4));
		thread mp_railyard_block((-515,98,349), (.4,.4,.4));

		thread mp_railyard_block((-505,92,281), (.4,.4,.4));
		thread mp_railyard_block((-505,92,291), (.4,.4,.4));
		thread mp_railyard_block((-505,92,301), (.4,.4,.4));
		thread mp_railyard_block((-505,92,311), (.4,.4,.4));
		thread mp_railyard_block((-505,92,321), (.4,.4,.4));
		thread mp_railyard_block((-505,92,331), (.4,.4,.4));
		thread mp_railyard_block((-505,92,341), (.4,.4,.4));

		thread mp_railyard_block((-495,85,275), (.4,.4,.4));
		thread mp_railyard_block((-495,85,285), (.4,.4,.4));
		thread mp_railyard_block((-495,85,295), (.4,.4,.4));
		thread mp_railyard_block((-495,85,305), (.4,.4,.4));
		thread mp_railyard_block((-495,85,315), (.4,.4,.4));
		thread mp_railyard_block((-495,85,325), (.4,.4,.4));
		thread mp_railyard_block((-495,85,335), (.4,.4,.4));
		thread mp_railyard_block((-495,85,345), (.4,.4,.4));

		thread mp_railyard_block((-485,77,272), (.4,.4,.4));
		thread mp_railyard_block((-485,77,282), (.4,.4,.4));
		thread mp_railyard_block((-485,77,292), (.4,.4,.4));
		thread mp_railyard_block((-485,77,302), (.4,.4,.4));
		thread mp_railyard_block((-485,77,312), (.4,.4,.4));
		thread mp_railyard_block((-485,77,322), (.4,.4,.4));
		thread mp_railyard_block((-485,77,332), (.4,.4,.4));
		thread mp_railyard_block((-485,77,342), (.4,.4,.4));

		thread mp_railyard_block((-477,70,268), (.4,.4,.4));
		thread mp_railyard_block((-477,70,278), (.4,.4,.4));
		thread mp_railyard_block((-477,70,288), (.4,.4,.4));
		thread mp_railyard_block((-477,70,298), (.4,.4,.4));
		thread mp_railyard_block((-477,70,308), (.4,.4,.4));
		thread mp_railyard_block((-477,70,318), (.4,.4,.4));
		thread mp_railyard_block((-477,70,328), (.4,.4,.4));
		thread mp_railyard_block((-477,70,338), (.4,.4,.4));
		thread mp_railyard_block((-477,70,348), (.4,.4,.4));

		thread mp_railyard_block((-470,62,265), (.4,.4,.4));
		thread mp_railyard_block((-470,62,275), (.4,.4,.4));
		thread mp_railyard_block((-470,62,285), (.4,.4,.4));
		thread mp_railyard_block((-470,62,295), (.4,.4,.4));
		thread mp_railyard_block((-470,62,305), (.4,.4,.4));
		thread mp_railyard_block((-470,62,315), (.4,.4,.4));
		thread mp_railyard_block((-470,62,325), (.4,.4,.4));
		thread mp_railyard_block((-470,62,335), (.4,.4,.4));
		thread mp_railyard_block((-470,62,345), (.4,.4,.4));

		thread mp_railyard_block((-470,53,260), (.4,.4,.4));
		thread mp_railyard_block((-470,53,270), (.4,.4,.4));
		thread mp_railyard_block((-470,53,280), (.4,.4,.4));
		thread mp_railyard_block((-470,53,290), (.4,.4,.4));
		thread mp_railyard_block((-470,53,300), (.4,.4,.4));
		thread mp_railyard_block((-470,53,310), (.4,.4,.4));
		thread mp_railyard_block((-470,53,320), (.4,.4,.4));
		thread mp_railyard_block((-470,53,330), (.4,.4,.4));
		thread mp_railyard_block((-470,53,340), (.4,.4,.4));
//		thread mp_railyard_block((-470,53,350), (.4,.4,.4));

// blocking axis roof rail landing zone (2nd)
		thread mp_railyard_block((-455,48,242), (.4,.4,.4));
		thread mp_railyard_block((-440,48,242), (.4,.4,.4));
		thread mp_railyard_block((-425,48,242), (.4,.4,.4));
		thread mp_railyard_block((-410,48,242), (.4,.4,.4));
		thread mp_railyard_block((-395,48,242), (.4,.4,.4));
		thread mp_railyard_block((-380,48,242), (.4,.4,.4));
		thread mp_railyard_block((-365,48,242), (.4,.4,.4));
		thread mp_railyard_block((-350,48,242), (.4,.4,.4));
		thread mp_railyard_block((-335,48,242), (.4,.4,.4));
		thread mp_railyard_block((-320,48,242), (.4,.4,.4));

		thread mp_railyard_block((-455,48,257), (.4,.4,.4));
		thread mp_railyard_block((-440,48,257), (.4,.4,.4));
		thread mp_railyard_block((-425,48,257), (.4,.4,.4));
		thread mp_railyard_block((-410,48,257), (.4,.4,.4));
		thread mp_railyard_block((-395,48,257), (.4,.4,.4));
		thread mp_railyard_block((-380,48,257), (.4,.4,.4));
		thread mp_railyard_block((-365,48,257), (.4,.4,.4));
		thread mp_railyard_block((-350,48,257), (.4,.4,.4));
		thread mp_railyard_block((-335,48,257), (.4,.4,.4));
		thread mp_railyard_block((-320,48,257), (.4,.4,.4));

		thread mp_railyard_block((-455,48,272), (.4,.4,.4));
		thread mp_railyard_block((-440,48,272), (.4,.4,.4));
		thread mp_railyard_block((-425,48,272), (.4,.4,.4));
		thread mp_railyard_block((-410,48,272), (.4,.4,.4));
		thread mp_railyard_block((-395,48,272), (.4,.4,.4));
		thread mp_railyard_block((-380,48,272), (.4,.4,.4));
		thread mp_railyard_block((-365,48,272), (.4,.4,.4));
		thread mp_railyard_block((-350,48,272), (.4,.4,.4));
		thread mp_railyard_block((-335,48,272), (.4,.4,.4));
		thread mp_railyard_block((-320,48,272), (.4,.4,.4));

		thread mp_railyard_block((-455,48,287), (.4,.4,.4));
		thread mp_railyard_block((-440,48,287), (.4,.4,.4));
		thread mp_railyard_block((-425,48,287), (.4,.4,.4));
		thread mp_railyard_block((-410,48,287), (.4,.4,.4));
		thread mp_railyard_block((-395,48,287), (.4,.4,.4));
		thread mp_railyard_block((-380,48,287), (.4,.4,.4));
		thread mp_railyard_block((-365,48,287), (.4,.4,.4));
		thread mp_railyard_block((-350,48,287), (.4,.4,.4));
		thread mp_railyard_block((-335,48,287), (.4,.4,.4));
		thread mp_railyard_block((-320,48,287), (.4,.4,.4));

		thread mp_railyard_block((-455,48,302), (.4,.4,.4));
		thread mp_railyard_block((-440,48,302), (.4,.4,.4));
		thread mp_railyard_block((-425,48,302), (.4,.4,.4));
		thread mp_railyard_block((-410,48,302), (.4,.4,.4));
		thread mp_railyard_block((-395,48,302), (.4,.4,.4));
		thread mp_railyard_block((-380,48,302), (.4,.4,.4));
		thread mp_railyard_block((-365,48,302), (.4,.4,.4));
		thread mp_railyard_block((-350,48,302), (.4,.4,.4));
		thread mp_railyard_block((-335,48,302), (.4,.4,.4));
		thread mp_railyard_block((-320,48,302), (.4,.4,.4));

		thread mp_railyard_block((-455,48,317), (.4,.4,.4));
		thread mp_railyard_block((-440,48,317), (.4,.4,.4));
		thread mp_railyard_block((-425,48,317), (.4,.4,.4));
		thread mp_railyard_block((-410,48,317), (.4,.4,.4));
		thread mp_railyard_block((-395,48,317), (.4,.4,.4));
		thread mp_railyard_block((-380,48,317), (.4,.4,.4));
		thread mp_railyard_block((-365,48,317), (.4,.4,.4));
		thread mp_railyard_block((-350,48,317), (.4,.4,.4));
		thread mp_railyard_block((-335,48,317), (.4,.4,.4));
		thread mp_railyard_block((-320,48,317), (.4,.4,.4));

		thread mp_railyard_block((-455,48,332), (.4,.4,.4));
		thread mp_railyard_block((-440,48,332), (.4,.4,.4));
		thread mp_railyard_block((-425,48,332), (.4,.4,.4));
		thread mp_railyard_block((-410,48,332), (.4,.4,.4));
		thread mp_railyard_block((-395,48,332), (.4,.4,.4));
		thread mp_railyard_block((-380,48,332), (.4,.4,.4));
		thread mp_railyard_block((-365,48,332), (.4,.4,.4));
		thread mp_railyard_block((-350,48,332), (.4,.4,.4));
		thread mp_railyard_block((-335,48,332), (.4,.4,.4));
		thread mp_railyard_block((-320,48,332), (.4,.4,.4));

// blocking axis roof rail2 landing zone
// right
//		thread mp_railyard_block((-365,117,242), (.4,.4,.4));
//		thread mp_railyard_block((-365,102,242), (.4,.4,.4));
//		thread mp_railyard_block((-365,87,242), (.4,.4,.4));
//		thread mp_railyard_block((-365,72,242), (.4,.4,.4));
		thread mp_railyard_block((-365,57,242), (.4,.4,.4));

//		thread mp_railyard_block((-365,117,257), (.4,.4,.4));
//		thread mp_railyard_block((-365,102,257), (.4,.4,.4));
//		thread mp_railyard_block((-365,87,257), (.4,.4,.4));
		thread mp_railyard_block((-365,72,257), (.4,.4,.4));
		thread mp_railyard_block((-365,57,257), (.4,.4,.4));

//		thread mp_railyard_block((-365,117,272), (.4,.4,.4));
//		thread mp_railyard_block((-365,102,272), (.4,.4,.4));
		thread mp_railyard_block((-365,87,272), (.4,.4,.4));
		thread mp_railyard_block((-365,72,272), (.4,.4,.4));
		thread mp_railyard_block((-365,57,272), (.4,.4,.4));

		thread mp_railyard_block((-365,117,287), (.4,.4,.4));
		thread mp_railyard_block((-365,102,287), (.4,.4,.4));
		thread mp_railyard_block((-365,87,287), (.4,.4,.4));
		thread mp_railyard_block((-365,72,287), (.4,.4,.4));
		thread mp_railyard_block((-365,57,287), (.4,.4,.4));

		thread mp_railyard_block((-365,117,302), (.4,.4,.4));
		thread mp_railyard_block((-365,102,302), (.4,.4,.4));
		thread mp_railyard_block((-365,87,302), (.4,.4,.4));
		thread mp_railyard_block((-365,72,302), (.4,.4,.4));
		thread mp_railyard_block((-365,57,302), (.4,.4,.4));

		thread mp_railyard_block((-365,117,317), (.4,.4,.4));
		thread mp_railyard_block((-365,102,317), (.4,.4,.4));
		thread mp_railyard_block((-365,87,317), (.4,.4,.4));
		thread mp_railyard_block((-365,72,317), (.4,.4,.4));
		thread mp_railyard_block((-365,57,317), (.4,.4,.4));

		thread mp_railyard_block((-365,117,332), (.4,.4,.4));
		thread mp_railyard_block((-365,108,332), (.4,.4,.4));
		thread mp_railyard_block((-365,87,332), (.4,.4,.4));
		thread mp_railyard_block((-365,72,332), (.4,.4,.4));
		thread mp_railyard_block((-365,57,332), (.4,.4,.4));

// left
//		thread mp_railyard_block((-354,117,242), (.4,.4,.4));
//		thread mp_railyard_block((-354,102,242), (.4,.4,.4));
//		thread mp_railyard_block((-354,87,242), (.4,.4,.4));
//		thread mp_railyard_block((-354,72,242), (.4,.4,.4));
		thread mp_railyard_block((-354,57,242), (.4,.4,.4));

//		thread mp_railyard_block((-354,117,257), (.4,.4,.4));
//		thread mp_railyard_block((-354,102,257), (.4,.4,.4));
//		thread mp_railyard_block((-354,87,257), (.4,.4,.4));
		thread mp_railyard_block((-354,72,257), (.4,.4,.4));
		thread mp_railyard_block((-354,57,257), (.4,.4,.4));

//		thread mp_railyard_block((-354,117,272), (.4,.4,.4));
//		thread mp_railyard_block((-354,102,272), (.4,.4,.4));
		thread mp_railyard_block((-354,87,272), (.4,.4,.4));
		thread mp_railyard_block((-354,72,272), (.4,.4,.4));
		thread mp_railyard_block((-354,57,272), (.4,.4,.4));

		thread mp_railyard_block((-354,117,287), (.4,.4,.4));
		thread mp_railyard_block((-354,102,287), (.4,.4,.4));
		thread mp_railyard_block((-354,87,287), (.4,.4,.4));
		thread mp_railyard_block((-354,72,287), (.4,.4,.4));
		thread mp_railyard_block((-354,57,287), (.4,.4,.4));

		thread mp_railyard_block((-354,117,302), (.4,.4,.4));
		thread mp_railyard_block((-354,102,302), (.4,.4,.4));
		thread mp_railyard_block((-354,87,302), (.4,.4,.4));
		thread mp_railyard_block((-354,72,302), (.4,.4,.4));
		thread mp_railyard_block((-354,57,302), (.4,.4,.4));

		thread mp_railyard_block((-354,117,317), (.4,.4,.4));
		thread mp_railyard_block((-354,102,317), (.4,.4,.4));
		thread mp_railyard_block((-354,87,317), (.4,.4,.4));
		thread mp_railyard_block((-354,72,317), (.4,.4,.4));
		thread mp_railyard_block((-354,57,317), (.4,.4,.4));

		thread mp_railyard_block((-354,117,332), (.4,.4,.4));
		thread mp_railyard_block((-354,108,332), (.4,.4,.4));
		thread mp_railyard_block((-354,87,332), (.4,.4,.4));
		thread mp_railyard_block((-354,72,332), (.4,.4,.4));
		thread mp_railyard_block((-354,57,332), (.4,.4,.4));

// blocking axis roof rail3 top jump position
		thread mp_railyard_block((-480,200,340), (.4,.4,.4));
		thread mp_railyard_block((-480,207,340), (.4,.4,.4));

		thread mp_railyard_block((-490,200,355), (.4,.4,.4));
		thread mp_railyard_block((-490,207,355), (.4,.4,.4));

		thread mp_railyard_block((-480,200,355), (.4,.4,.4));
		thread mp_railyard_block((-480,207,355), (.4,.4,.4));

		thread mp_railyard_block((-490,200,370), (.4,.4,.4));
		thread mp_railyard_block((-490,207,370), (.4,.4,.4));

		thread mp_railyard_block((-480,200,370), (.4,.4,.4));
		thread mp_railyard_block((-480,207,370), (.4,.4,.4));

		thread mp_railyard_block((-470,200,355), (.4,.4,.4));
		thread mp_railyard_block((-470,207,370), (.4,.4,.4));

		thread mp_railyard_block((-470,200,355), (.4,.4,.4));
		thread mp_railyard_block((-470,207,370), (.4,.4,.4));
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c11) AXIS STATION ROOF BLOCKS COORDINATES
////////
////
// 

rpam_overhaul_railyard_axis_woodstation_roof()
{
// blocking the roof axis spawn right
	thread mp_railyard_block((-225,-996,190), (.4,.4,.4));
	thread mp_railyard_block((-225,-996,210), (.4,.4,.4));
	thread mp_railyard_block((-225,-996,230), (.4,.4,.4));
	thread mp_railyard_block((-225,-996,250), (.4,.4,.4));

	thread mp_railyard_block((-240,-996,190), (.4,.4,.4));
	thread mp_railyard_block((-240,-996,210), (.4,.4,.4));
	thread mp_railyard_block((-240,-996,230), (.4,.4,.4));
	thread mp_railyard_block((-240,-996,250), (.4,.4,.4));

	thread mp_railyard_block((-255,-996,190), (.4,.4,.4));
	thread mp_railyard_block((-255,-996,210), (.4,.4,.4));
	thread mp_railyard_block((-255,-996,230), (.4,.4,.4));
	thread mp_railyard_block((-255,-996,250), (.4,.4,.4));

	thread mp_railyard_block((-270,-996,190), (.4,.4,.4));
	thread mp_railyard_block((-270,-996,210), (.4,.4,.4));
	thread mp_railyard_block((-270,-996,230), (.4,.4,.4));
	thread mp_railyard_block((-270,-996,250), (.4,.4,.4));

	thread mp_railyard_block((-285,-996,190), (.4,.4,.4));
	thread mp_railyard_block((-285,-996,210), (.4,.4,.4));
	thread mp_railyard_block((-285,-996,230), (.4,.4,.4));
	thread mp_railyard_block((-285,-996,250), (.4,.4,.4));

	thread mp_railyard_block((-285,-984,210), (.4,.4,.4));
	thread mp_railyard_block((-285,-984,230), (.4,.4,.4));
	thread mp_railyard_block((-285,-984,250), (.4,.4,.4));

	thread mp_railyard_block((-285,-972,230), (.4,.4,.4));
	thread mp_railyard_block((-285,-972,250), (.4,.4,.4));

	thread mp_railyard_block((-285,-960,250), (.4,.4,.4));

// blocking the roof axis spawn left
	thread mp_railyard_block((-400,-996,190), (.4,.4,.4));
	thread mp_railyard_block((-400,-996,210), (.4,.4,.4));
	thread mp_railyard_block((-400,-996,230), (.4,.4,.4));
	thread mp_railyard_block((-400,-996,250), (.4,.4,.4));

	thread mp_railyard_block((-400,-984,210), (.4,.4,.4));
	thread mp_railyard_block((-400,-984,230), (.4,.4,.4));
	thread mp_railyard_block((-400,-984,250), (.4,.4,.4));

	thread mp_railyard_block((-400,-972,230), (.4,.4,.4));
	thread mp_railyard_block((-400,-972,250), (.4,.4,.4));

	thread mp_railyard_block((-400,-960,250), (.4,.4,.4));
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c12) SOUTHSTATION ROOF BLOCK COORDINATES
////////
////
// 

rpam_overhaul_railyard_southstation()
{
// blocking b south station roof from ladderhouse | 11*11
/*	thread mp_railyard_block((-2785,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2785,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2765,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2765,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2745,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2745,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2725,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2725,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2705,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2705,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2685,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2685,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2665,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2665,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2645,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2645,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2625,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2625,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2605,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2605,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2585,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2585,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2565,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2565,-240,396), (.4,.4,.4));

	thread mp_railyard_block((-2545,-240,196), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,216), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,236), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,256), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,276), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,296), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,316), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,336), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,356), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,376), (.4,.4,.4));
	thread mp_railyard_block((-2545,-240,396), (.4,.4,.4));
*/

// blocking b south station roof from ladderhouse by 9*9
//	thread mp_railyard_block((-2785, -240, 196), (.4,.4,.4));
	thread mp_railyard_block((-2785, -240, 221), (.4,.4,.4));
	thread mp_railyard_block((-2785, -240, 246), (.4,.4,.4));
	thread mp_railyard_block((-2785, -240, 271), (.4,.4,.4));
	thread mp_railyard_block((-2785, -240, 296), (.4,.4,.4));
	thread mp_railyard_block((-2785, -240, 321), (.4,.4,.4));
	thread mp_railyard_block((-2785, -240, 346), (.4,.4,.4));
	thread mp_railyard_block((-2785, -240, 371), (.4,.4,.4));
	thread mp_railyard_block((-2785, -240, 396), (.4,.4,.4));

//	thread mp_railyard_block((-2755, -240, 196), (.4,.4,.4));
	thread mp_railyard_block((-2755, -240, 221), (.4,.4,.4));
	thread mp_railyard_block((-2755, -240, 246), (.4,.4,.4));
	thread mp_railyard_block((-2755, -240, 271), (.4,.4,.4));
	thread mp_railyard_block((-2755, -240, 296), (.4,.4,.4));
	thread mp_railyard_block((-2755, -240, 321), (.4,.4,.4));
	thread mp_railyard_block((-2755, -240, 346), (.4,.4,.4));
	thread mp_railyard_block((-2755, -240, 371), (.4,.4,.4));
	thread mp_railyard_block((-2755, -240, 396), (.4,.4,.4));

//	thread mp_railyard_block((-2725, -240, 196), (.4,.4,.4));
	thread mp_railyard_block((-2725, -240, 221), (.4,.4,.4));
	thread mp_railyard_block((-2725, -240, 246), (.4,.4,.4));
	thread mp_railyard_block((-2725, -240, 271), (.4,.4,.4));
	thread mp_railyard_block((-2725, -240, 296), (.4,.4,.4));
	thread mp_railyard_block((-2725, -240, 321), (.4,.4,.4));
	thread mp_railyard_block((-2725, -240, 346), (.4,.4,.4));
	thread mp_railyard_block((-2725, -240, 371), (.4,.4,.4));
	thread mp_railyard_block((-2725, -240, 396), (.4,.4,.4));

//	thread mp_railyard_block((-2695, -240, 196), (.4,.4,.4));
	thread mp_railyard_block((-2695, -240, 221), (.4,.4,.4));
	thread mp_railyard_block((-2695, -240, 246), (.4,.4,.4));
	thread mp_railyard_block((-2695, -240, 271), (.4,.4,.4));
	thread mp_railyard_block((-2695, -240, 296), (.4,.4,.4));
	thread mp_railyard_block((-2695, -240, 321), (.4,.4,.4));
	thread mp_railyard_block((-2695, -240, 346), (.4,.4,.4));
	thread mp_railyard_block((-2695, -240, 371), (.4,.4,.4));
	thread mp_railyard_block((-2695, -240, 396), (.4,.4,.4));

//	thread mp_railyard_block((-2665, -240, 196), (.4,.4,.4));
	thread mp_railyard_block((-2665, -240, 221), (.4,.4,.4));
	thread mp_railyard_block((-2665, -240, 246), (.4,.4,.4));
	thread mp_railyard_block((-2665, -240, 271), (.4,.4,.4));
	thread mp_railyard_block((-2665, -240, 296), (.4,.4,.4));
	thread mp_railyard_block((-2665, -240, 321), (.4,.4,.4));
	thread mp_railyard_block((-2665, -240, 346), (.4,.4,.4));
	thread mp_railyard_block((-2665, -240, 371), (.4,.4,.4));
	thread mp_railyard_block((-2665, -240, 396), (.4,.4,.4));

//	thread mp_railyard_block((-2635, -240, 196), (.4,.4,.4));
	thread mp_railyard_block((-2635, -240, 221), (.4,.4,.4));
	thread mp_railyard_block((-2635, -240, 246), (.4,.4,.4));
	thread mp_railyard_block((-2635, -240, 271), (.4,.4,.4));
	thread mp_railyard_block((-2635, -240, 296), (.4,.4,.4));
	thread mp_railyard_block((-2635, -240, 321), (.4,.4,.4));
	thread mp_railyard_block((-2635, -240, 346), (.4,.4,.4));
	thread mp_railyard_block((-2635, -240, 371), (.4,.4,.4));
	thread mp_railyard_block((-2635, -240, 396), (.4,.4,.4));

//	thread mp_railyard_block((-2605, -240, 196), (.4,.4,.4));
	thread mp_railyard_block((-2605, -240, 221), (.4,.4,.4));
	thread mp_railyard_block((-2605, -240, 246), (.4,.4,.4));
	thread mp_railyard_block((-2605, -240, 271), (.4,.4,.4));
	thread mp_railyard_block((-2605, -240, 296), (.4,.4,.4));
	thread mp_railyard_block((-2605, -240, 321), (.4,.4,.4));
	thread mp_railyard_block((-2605, -240, 346), (.4,.4,.4));
	thread mp_railyard_block((-2605, -240, 371), (.4,.4,.4));
	thread mp_railyard_block((-2605, -240, 396), (.4,.4,.4));

//	thread mp_railyard_block((-2575, -240, 196), (.4,.4,.4));
	thread mp_railyard_block((-2575, -240, 221), (.4,.4,.4));
	thread mp_railyard_block((-2575, -240, 246), (.4,.4,.4));
	thread mp_railyard_block((-2575, -240, 271), (.4,.4,.4));
	thread mp_railyard_block((-2575, -240, 296), (.4,.4,.4));
	thread mp_railyard_block((-2575, -240, 321), (.4,.4,.4));
	thread mp_railyard_block((-2575, -240, 346), (.4,.4,.4));
	thread mp_railyard_block((-2575, -240, 371), (.4,.4,.4));
	thread mp_railyard_block((-2575, -240, 396), (.4,.4,.4));

//	thread mp_railyard_block((-2545, -240, 196), (.4,.4,.4));
	thread mp_railyard_block((-2545, -240, 221), (.4,.4,.4));
	thread mp_railyard_block((-2545, -240, 246), (.4,.4,.4));
	thread mp_railyard_block((-2545, -240, 271), (.4,.4,.4));
	thread mp_railyard_block((-2545, -240, 296), (.4,.4,.4));
	thread mp_railyard_block((-2545, -240, 321), (.4,.4,.4));
	thread mp_railyard_block((-2545, -240, 346), (.4,.4,.4));
	thread mp_railyard_block((-2545, -240, 371), (.4,.4,.4));
	thread mp_railyard_block((-2545, -240, 396), (.4,.4,.4));

// blocking south station roof front
//	thread mp_railyard_block((-2538,-255,196), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,216), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,236), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,256), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,276), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,296), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,316), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,336), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,356), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,376), (.4,.4,.4));
	thread mp_railyard_block((-2538,-255,396), (.4,.4,.4));

// south south station inside
	thread mp_railyard_block((-3111,-603,230), (.4,.4,.4));	// left
	thread mp_railyard_block((-3111,-603,260), (.4,.4,.4));	// left
	thread mp_railyard_block((-3111,-347,230), (.4,.4,.4));	// right
	thread mp_railyard_block((-3111,-347,260), (.4,.4,.4));	// right
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////         COORDINATES END        //////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(x01) PRECACHE
////////
////
// 

mp_railyard_overhaul_precache()
{
// main
	precacheModel("xmodel/vehicle_halftrack_shield");
	precacheModel("xmodel/gib_brick");	
	precacheModel("xmodel/minenclear");	
	precacheModel("xmodel/minen4_snow");
	precacheModel("xmodel/woodgib_medium");

// cosmetics
	precacheModel("xmodel/crate_russianrifle");
	precacheModel("xmodel/tree_shortspruce_winter");
	precacheModel("xmodel/tree_winter_pine");	
	precacheModel("xmodel/vehicle_truck_soviet_static");

// cosmetcis2
	precacheModel("xmodel/static_vehicle_german_truck");
	precacheModel("xmodel/sandbags_long_winter");
	precacheModel("xmodel/sandbags_short_winter");

//	precacheModel("xmodel/mg42_bipod");
	precacheModel("xmodel/crate_misc1_stalingrad");
	precacheModel("xmodel/barrel_black2snowy");
	precacheModel("xmodel/barrel_green2snowy");
	precacheModel("xmodel/vehicle_german_kubelwagen");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(x02) BLOCK
////////
////
// 

mp_railyard_block(origin,size)
{
	blocker = spawn("script_origin", origin);

	blocker.angles = (0, 0, 0);
//	blocker.scale = (1, 1, 1);

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(x02) BOMBSPOT MODEL
////////
////
// 

mp_railyard_tank_a_left(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/vehicle_halftrack_shield");

	blocker.angles = (0, -90, 0);
//	blocker.scale = (1, 1, 1);

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_tank_a_right(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/vehicle_halftrack_shield");

	blocker.angles = (0, 90, 0);
//	blocker.scale = (1, 1, 1);

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_tank_b_left(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/vehicle_halftrack_shield");

	blocker.angles = (0, 0, 0);
//	blocker.scale = (1, 1, 1);

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_tank_b_right(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/vehicle_halftrack_shield");

	blocker.angles = (0, 0, 0);
//	blocker.scale = (1, 1, 1);

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(x03) DECORATION
////////
////
// 

//
//	TREES
//
mp_railyard_smalltree(origin,size)
{
	blocker = spawn("script_model", origin);
			
	blocker setModel("xmodel/tree_shortspruce_winter");			

	blocker.angles = (0, 0, 0);
//	blocker.scale = (1, 1, 1);

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_tree(origin,size)
{
	blocker = spawn("script_model", origin);
		
	blocker setModel("xmodel/tree_winter_pine");			

	blocker.angles = (0, 0, 0);
//	blocker.scale = (1, 1, 1);

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

//
//	RU GATE TRUCKS
//
mp_railyard_truck1(origin,size)
{

	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/vehicle_truck_soviet_static");
	blocker.angles = (1, -82, 0);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_truck2(origin,size)
{
	blocker = spawn("script_model", origin);	

	blocker setModel("xmodel/vehicle_truck_soviet_static");
	
	blocker.angles = (1, -24, 0);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_truck2box(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/crate_russianrifle");	
		
	blocker.angles = (1, -24, 0);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

//
//	A SPOT GATE DECO
//
mp_railyard_german_truck(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/static_vehicle_german_truck");	

	blocker.angles = (1, 283, 0);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_sandbags_long_winter(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/sandbags_long_winter");

	blocker.angles = (0, 66, 0);
			
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_sandbags_short_winter(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/sandbags_short_winter");

	blocker.angles = (0, 1, 0);
		
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_crate_misc1_stalingrad(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/crate_misc1_stalingrad");

	blocker.angles = (0, 171, 0);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

//
//	MG42 MODEL
//
mp_railyard_mg42_bipod(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/mg42_bipod");

	blocker.angles = (-11, 86, 0);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

//
//			BARRELS
//
mp_railyard_barrel_black2snowy1(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/barrel_black2snowy");

	blocker.angles = (0, 20, 0);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_barrel_black2snowy2(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/barrel_black2snowy");

	blocker.angles = (0, 256, 0);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_barrel_black2snowy3(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/barrel_black2snowy");

	blocker.angles = (0, 123, 0);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_barrel_black2snowy4(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/barrel_black2snowy");

	blocker.angles = (0, 80, 0);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_barrel_black2snowy(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/barrel_black2snowy");

	blocker.angles = (0, 86, 0);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_barrel_green2snowy(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/barrel_green2snowy");

	blocker.angles = (0, 0, 0);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

//
// KUBELWAGEN
//
mp_railyard_vehicle_german_kubelwagen(origin,size)
{
	blocker = spawn("script_model", origin);
	blocker setModel("xmodel/vehicle_german_kubelwagen");

	blocker.angles = (0, 290, 0);			

	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(x04) AXIS WOODSTATION MODELS
////////
////
// 

mp_railyard_wood1down(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/minen4_snow");	
		
	blocker.angles = (0, 90, 0);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_wood1up(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/minen4_snow");	
		
	blocker.angles = (0, 90, 180);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_wood1down2(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/minen4_snow");	
		
	blocker.angles = (0, 270, 0);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_wood1up2(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/minen4_snow");	
		
	blocker.angles = (0, 270, 180);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(x05) RUINS ROOF BRICKFIX MODELS
////////
////
// 

mp_railyard_axis_ruins_roof_wood(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/minenclear");	
		
	blocker.angles = (0, 270, 0);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

mp_railyard_axis_ruins_roof_brick(origin,size)
{
	blocker = spawn("script_model", origin);

	blocker setModel("xmodel/gib_brick");

	blocker.angles = (0, 90, 0);			
//	blocker.angles = (270, 90, 180);
//	blocker.angles = (230, 180, 191);
//	blocker.angles = (230, 0, 200);
//	blocker.scale = (1, 1, 1);
	blocker.bounds_min = origin - size;
	blocker.bounds_max = origin + size;
	blocker setcontents(1);
//	blocker solid(1);

	if(getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		x = size[0];
		y = size[1];
		z = size[2];
		for(;;)
		{
			line(origin + (0-x,  y,  z), origin + (  x,  y,  z), (1,0,0));
			line(origin + (0-x,  y,0-z), origin + (  x,  y,0-z), (1,0,0));
			line(origin + (0-x,  y,  z), origin + (0-x,  y,0-z), (1,0,0));
			line(origin + (  x,  y,  z), origin + (  x,  y,0-z), (1,0,0));

			line(origin + (0-x,0-y,  z), origin + (  x,0-y,  z), (0,1,0));
			line(origin + (0-x,0-y,0-z), origin + (  x,0-y,0-z), (0,1,0));
			line(origin + (0-x,0-y,  z), origin + (0-x,0-y,0-z), (0,1,0));
			line(origin + (  x,0-y,  z), origin + (  x,0-y,0-z), (0,1,0));

			line(origin + (0-x,  y,  z), origin + (0-x,0-y,  z), (0,0,1));
			line(origin + (  x,  y,  z), origin + (  x,0-y,  z), (0,0,1));
			line(origin + (0-x,  y,0-z), origin + (0-x,0-y,0-z), (0,0,1));
			line(origin + (  x,  y,0-z), origin + (  x,0-y,0-z), (0,0,1));

			line(origin + (0-x,0-y,  z), origin + (  x,  y,0-z), (1,0,1));
			line(origin + (0-x,  y,  z), origin + (  x,0-y,0-z), (1,0,1));
			line(origin + (  x,0-y,  z), origin + (0-x,  y,0-z), (1,0,1));
			line(origin + (  x,  y,  z), origin + (0-x,0-y,0-z), (1,0,1));

			wait .05;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////
////////////			(c03) LEDGE UP&DOWN COORDINATES
////////
////
// 

rpam_overhaul_railyard_updown()
{
// this is not finished
// 4th
	thread mp_railyard_block((-391, 2099, 298), (.4, .4, .4));
	thread mp_railyard_block((-384, 2099, 298), (.4, .4, .4));
	thread mp_railyard_block((-377, 2099, 298), (.4, .4, .4));
	thread mp_railyard_block((-370, 2099, 298), (.4, .4, .4));
	thread mp_railyard_block((-364, 2099, 298), (.4, .4, .4));
	thread mp_railyard_block((-357, 2099, 298), (.4, .4, .4));
	thread mp_railyard_block((-350, 2099, 298), (.4, .4, .4));

	thread mp_railyard_block((-346, 2099, 298), (.2, .2, .2));
	thread mp_railyard_block((-342, 2099, 298), (.2, .2, .2));
//	thread mp_railyard_block((-336, 2099, 298), (.2, .2, .2));

//3
	thread mp_railyard_block((-391, 2105, 291), (.4, .4, .4));
	thread mp_railyard_block((-384, 2105, 291), (.4, .4, .4));
	thread mp_railyard_block((-377, 2105, 291), (.4, .4, .4));
	thread mp_railyard_block((-370, 2105, 291), (.4, .4, .4));
	thread mp_railyard_block((-364, 2105, 291), (.4, .4, .4));
	thread mp_railyard_block((-357, 2105, 291), (.4, .4, .4));
	thread mp_railyard_block((-350, 2105, 291), (.4, .4, .4));

	thread mp_railyard_block((-346, 2105, 291), (.2, .2, .2));
	thread mp_railyard_block((-343, 2105, 291), (.2, .2, .2));
	thread mp_railyard_block((-338, 2105, 291), (.2, .2, .2));

//3
	thread mp_railyard_block((-391, 2112, 288), (.4, .4, .4));
	thread mp_railyard_block((-384, 2112, 288), (.4, .4, .4));
	thread mp_railyard_block((-377, 2112, 288), (.4, .4, .4));
	thread mp_railyard_block((-370, 2112, 288), (.4, .4, .4));
	thread mp_railyard_block((-364, 2112, 288), (.4, .4, .4));
	thread mp_railyard_block((-357, 2112, 288), (.4, .4, .4));
	thread mp_railyard_block((-350, 2112, 288), (.4, .4, .4));

	thread mp_railyard_block((-346, 2112, 288), (.2, .2, .2));
	thread mp_railyard_block((-341, 2112, 288), (.2, .2, .2));

//2
	thread mp_railyard_block((-391, 2117, 283), (.4, .4, .4));
	thread mp_railyard_block((-384, 2117, 283), (.4, .4, .4));
	thread mp_railyard_block((-377, 2117, 283), (.4, .4, .4));
	thread mp_railyard_block((-370, 2117, 283), (.4, .4, .4));
	thread mp_railyard_block((-364, 2117, 283), (.4, .4, .4));
	thread mp_railyard_block((-357, 2117, 283), (.4, .4, .4));
	thread mp_railyard_block((-350, 2117, 283), (.4, .4, .4));

	thread mp_railyard_block((-343, 2117, 283), (.2, .2, .2));

//1
	thread mp_railyard_block((-391, 2124, 279), (.4, .4, .4));
	thread mp_railyard_block((-384, 2124, 279), (.4, .4, .4));
	thread mp_railyard_block((-377, 2124, 279), (.4, .4, .4));
	thread mp_railyard_block((-370, 2124, 279), (.4, .4, .4));
	thread mp_railyard_block((-364, 2124, 279), (.4, .4, .4));
	thread mp_railyard_block((-357, 2124, 279), (.4, .4, .4));
	thread mp_railyard_block((-350, 2124, 279), (.4, .4, .4));

	thread mp_railyard_block((-346, 2124, 279), (.2, .2, .2));

//0a
	thread mp_railyard_block((-391, 2133, 276), (.4, .4, .4));
	thread mp_railyard_block((-384, 2133, 276), (.4, .4, .4));
	thread mp_railyard_block((-377, 2133, 276), (.4, .4, .4));
	thread mp_railyard_block((-370, 2133, 276), (.4, .4, .4));
	thread mp_railyard_block((-364, 2133, 276), (.4, .4, .4));
	thread mp_railyard_block((-357, 2133, 276), (.4, .4, .4));

	thread mp_railyard_block((-350, 2133, 276), (.2, .2, .2));

//bottom
	thread mp_railyard_block((-391, 2137, 272), (.4, .4, .4));
	thread mp_railyard_block((-384, 2137, 272), (.4, .4, .4));
	thread mp_railyard_block((-377, 2137, 272), (.4, .4, .4));
	thread mp_railyard_block((-370, 2137, 272), (.4, .4, .4));
	thread mp_railyard_block((-364, 2137, 272), (.4, .4, .4));
	thread mp_railyard_block((-357, 2137, 272), (.4, .4, .4));

	thread mp_railyard_block((-351, 2137, 272), (.2, .2, .2));

/* // on the rail height
// 4th
	thread mp_railyard_block((-391, 2099, 230), (.4, .4, .4));
	thread mp_railyard_block((-384, 2099, 230), (.4, .4, .4));
	thread mp_railyard_block((-377, 2099, 230), (.4, .4, .4));
	thread mp_railyard_block((-370, 2099, 230), (.4, .4, .4));
	thread mp_railyard_block((-364, 2099, 230), (.4, .4, .4));
	thread mp_railyard_block((-357, 2099, 230), (.4, .4, .4));
	thread mp_railyard_block((-350, 2099, 230), (.4, .4, .4));

	thread mp_railyard_block((-346, 2099, 230), (.2, .2, .2));
	thread mp_railyard_block((-342, 2099, 230), (.2, .2, .2));
	thread mp_railyard_block((-336, 2099, 230), (.2, .2, .2));

//3
	thread mp_railyard_block((-391, 2105, 228), (.4, .4, .4));
	thread mp_railyard_block((-384, 2105, 228), (.4, .4, .4));
	thread mp_railyard_block((-377, 2105, 228), (.4, .4, .4));
	thread mp_railyard_block((-370, 2105, 228), (.4, .4, .4));
	thread mp_railyard_block((-364, 2105, 228), (.4, .4, .4));
	thread mp_railyard_block((-357, 2105, 228), (.4, .4, .4));
	thread mp_railyard_block((-350, 2105, 228), (.4, .4, .4));

	thread mp_railyard_block((-346, 2105, 228), (.2, .2, .2));
	thread mp_railyard_block((-343, 2105, 228), (.2, .2, .2));
	thread mp_railyard_block((-338, 2105, 228), (.2, .2, .2));

//3
	thread mp_railyard_block((-391, 2112, 223), (.4, .4, .4));
	thread mp_railyard_block((-384, 2112, 223), (.4, .4, .4));
	thread mp_railyard_block((-377, 2112, 223), (.4, .4, .4));
	thread mp_railyard_block((-370, 2112, 223), (.4, .4, .4));
	thread mp_railyard_block((-364, 2112, 223), (.4, .4, .4));
	thread mp_railyard_block((-357, 2112, 223), (.4, .4, .4));
	thread mp_railyard_block((-350, 2112, 223), (.4, .4, .4));

	thread mp_railyard_block((-346, 2112, 223), (.2, .2, .2));
	thread mp_railyard_block((-341, 2112, 223), (.2, .2, .2));

//2
	thread mp_railyard_block((-391, 2117, 219), (.4, .4, .4));
	thread mp_railyard_block((-384, 2117, 219), (.4, .4, .4));
	thread mp_railyard_block((-377, 2117, 219), (.4, .4, .4));
	thread mp_railyard_block((-370, 2117, 219), (.4, .4, .4));
	thread mp_railyard_block((-364, 2117, 219), (.4, .4, .4));
	thread mp_railyard_block((-357, 2117, 219), (.4, .4, .4));
	thread mp_railyard_block((-350, 2117, 219), (.4, .4, .4));

	thread mp_railyard_block((-343, 2117, 219), (.2, .2, .2));

//1
	thread mp_railyard_block((-391, 2124, 215), (.4, .4, .4));
	thread mp_railyard_block((-384, 2124, 215), (.4, .4, .4));
	thread mp_railyard_block((-377, 2124, 215), (.4, .4, .4));
	thread mp_railyard_block((-370, 2124, 215), (.4, .4, .4));
	thread mp_railyard_block((-364, 2124, 215), (.4, .4, .4));
	thread mp_railyard_block((-357, 2124, 215), (.4, .4, .4));
	thread mp_railyard_block((-350, 2124, 215), (.4, .4, .4));

	thread mp_railyard_block((-346, 2124, 215), (.2, .2, .2));

//0a
	thread mp_railyard_block((-391, 2133, 211), (.4, .4, .4));
	thread mp_railyard_block((-384, 2133, 211), (.4, .4, .4));
	thread mp_railyard_block((-377, 2133, 211), (.4, .4, .4));
	thread mp_railyard_block((-370, 2133, 211), (.4, .4, .4));
	thread mp_railyard_block((-364, 2133, 211), (.4, .4, .4));
	thread mp_railyard_block((-357, 2133, 211), (.4, .4, .4));

	thread mp_railyard_block((-350, 2133, 211), (.2, .2, .2));

//bottom
	thread mp_railyard_block((-391, 2137, 208), (.4, .4, .4));
	thread mp_railyard_block((-384, 2137, 208), (.4, .4, .4));
	thread mp_railyard_block((-377, 2137, 208), (.4, .4, .4));
	thread mp_railyard_block((-370, 2137, 208), (.4, .4, .4));
	thread mp_railyard_block((-364, 2137, 208), (.4, .4, .4));
	thread mp_railyard_block((-357, 2137, 208), (.4, .4, .4));

	thread mp_railyard_block((-351, 2137, 208), (.2, .2, .2));
*/
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////////////////////////////////////////////////////////////////////////////////////////	
////////////////////////////////////////////////////////////////////////////////////////////////////