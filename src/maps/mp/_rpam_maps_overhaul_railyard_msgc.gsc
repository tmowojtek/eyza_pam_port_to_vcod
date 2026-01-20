//	rPAM MAP MP_RAILYARD OVERHAUL
//
//	REISSUE Project Ares Mod version 1.15
//	
//	_rpam_maps_overhaul_railyard_msgc.gsc
//
//	Version: v131
//
//	Tools: WinMerge, VSCode, Editor.txt, WinRar
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////		

main()
{
	thread rpam_overhaul_railyard_messagecenter_bylevel();
}

rpam_overhaul_railyard_messagecenter_bylevel()
{
	wait 4.5;

	iprintln(" ");
	iprintln(" ");
	iprintln("              ^3rPAM ^7MP_RAILYARD ^5OVERHAUL^3");
	iprintln("^7-----------------------------------------------------");

// decoration
	if (level.z_railyard_add_decoration1 == 1)
		iprintln("^5railyard_add_decoration1 ^91/1 ^2loaded");
	else
		iprintln("^5railyard_add_decoration1 ^90/1 ^2not loaded");

	if (level.z_railyard_add_decoration2 == 1)
		iprintln("^5railyard_add_decoration2 ^91/1 ^2loaded");
	else
		iprintln("^5railyard_add_decoration2 ^90/1 ^2not loaded");

// bombspots
	if (level.z_railyard_fix_bombspots == "1")
	{
		if (getcvar("g_gametype") == "sd")
		{
			iprintln("^5railyard_fix_bombspots ^91/1 ^2loaded");
		}
		else
		{
			iprintln("^5railyard_fix_bombspots ^90/1 ^7not loaded (g_gametype != sd)");
		}
	}
	else if (level.z_railyard_fix_bombspots == "0")
	{
		iprintln("^5railyard_fix_bombspots ^90/1 ^1not loaded");	
	}

// woodstation both
	if (level.z_railyard_fix_woodstation_ruins == 1)
		iprintln("^5railyard_fix_woodstation_ruins ^91/1 ^2loaded");
	else
		iprintln("^5railyard_fix_woodstation_ruins ^90/1 ^1not loaded");

	if (level.z_railyard_fix_woodstation_spawn == 1)
		iprintln("^5railyard_fix_woodstation_spawn ^91/1 ^2loaded");
	else
		iprintln("^5railyard_fix_woodstation_spawn ^90/1 ^1not loaded");

// woodstation roof
	if (level.z_railyard_fix_woodstation_roof == 1)
		iprintln("^5railyard_fix_woodstation_roof ^91/1 ^2loaded");
	else
		iprintln("^5railyard_fix_woodstation_roof ^90/1 ^2not loaded");

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
		iprintln("^5railyard_fix_ruins_roof ^90/1 ^1not loaded");

// ruins stone
	if (level.z_railyard_fix_ruins_stone == 1)
		iprintln("^5railyard_fix_ruins_stone ^91/1 ^2loaded");
	else
		iprintln("^5railyard_fix_ruins_stone ^90/1 ^1not loaded");

// ruins stairs
	if (level.z_railyard_fix_ruins_stairs == 1)
		iprintln("^5railyard_fix_ruins_stairs ^91/1 ^2loaded");
	else
		iprintln("^5railyard_fix_ruins_stairs ^90/1 ^1not loaded");

// southstation
	if (level.z_railyard_block_southstation_roof == 1)
		iprintln("^5railyard_block_southstation_roof ^91/1 ^1loaded");
	else
		iprintln("^5railyard_block_southstation_roof ^90/1 ^2not loaded");

 // updown
	if (level.z_railyard_block_updown == 1)
		iprintln("^5railyard_block_updown ^91/1 ^1loaded ^1(test only)");
	else
		iprintln("^5railyard_block_updown ^90/1 ^2not loaded");

// debug info
	if (level.z_rpam_overhaul_debug == 1)
	{
		iprintln(" ");
		iprintln("^1railyard_debug loaded^7!");
		iprintln("^1railyard_debug loaded^7!");
		iprintln("^1railyard_debug loaded^7!");
		iprintln(" ");
		iprintln("^1xvar_rpam_overhaul_railyard ^7is set ^11^9/1^7!");
		iprintln(" ");
	}

	iprintln("^7-----------------------------------------------------");

	if (getcvar("g_gametype") == "sd")
	{
		setCvar("rpam_overhaul_messagecenter", "0");
		iprintln("^7rpam_overhaul_messagecenter was set to 0");
	}
	iprintln(" ");
	iprintln(" ");
}

rpam_exploit_cvar_off_msg()
{
	wait 4.5;

	iprintln(" ");
	iprintln(" ");
	iprintln("              ^3rPAM ^7MP_RAILYARD ^5OVERHAUL^3");
	iprintln("^7-----------------------------------------------------");
	iprintln("^7not loaded ");
//	iprintln("^7rpam_overhaul is " + ("" + getcvar("rpam_overhaul"))/1");
	iprintln("^7rpam_overhaul is ^70/1");
	iprintln("^7-----------------------------------------------------");

	if (getcvar("g_gametype") == "sd")
	{
		setCvar("rpam_overhaul_messagecenter", "0");
		iprintln("^7rpam_overhaul_messagecenter was set to 0");
	}
	iprintln(" ");
	iprintln(" ");
}

// END