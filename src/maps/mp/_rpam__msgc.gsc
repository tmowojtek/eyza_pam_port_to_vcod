//	Version: v225
//
//	rPAM MAPS OVERHAUL
//
//	REISSUE Project Ares Mod version 1.15
//	
//	_rpam__msg.gsc
//
//	This script displays messages at start of the map.
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 

rpam_msg()
{
// if xvar for debugging is 1, turn on the old msg center
	if (getcvar("xvar_rpam_overhaul_railyard") == "1")
	{
		setCvar("rpam_overhaul_messagecenter", "1");
	}
//	setCvar("rpam_msg", "1");

	wait 4.5;

	iprintln(" ");
	iprintln(" ");
	iprintln("^3[^7rPAM^3] ^7MAPS ^5MESSAGE^7-^5CENTER");
	iprintln("^7--------------------------------------------------------");

// GAME
	iprintln("^3CURRENT MAP: ^7map " + getcvar("mapname"));
	iprintln("^3GAMETYPE: ^7g_gametype "+ getcvar("g_gametype"));
	iprintln(" ");
	iprintln("^3MESSAGECENTER: ^5rpam_msg ^71"); // + getcvar("rpam_msg"));
	iprintln(" ");

	wait 0.05;

// V 2.2.5
	iprintln("^3[^9VERSION^3]: ^7v225");
	iprintln("^3PK3-FILES: ^7zzzzz_rPAM_n01_client_v8.pk3");
	iprintln("^7           zzzzz_rPAM_p01_classics_v3.pk3");
	iprintln("^7           zzzzz_rPAM_p02_curiousfox_v4.pk3");
	iprintln("^7           zzzzz_rPAM_p03_custom_v6.pk3");
	iprintln("^7           zzzzz_rPAM_p04_hanoi_v2.pk3");

// AMBIENT
	iprintln(" ");
	iprintln(" ");
	iprintln("^3AMBIENT Sound:        ^5rpam_ambientsounds ^7" + getcvar("rpam_ambientsounds"));
	iprintln("^3AMBIENT Fog:          ^5rpam_ambientfog    ^7" + getcvar("rpam_ambientfog"));
	iprintln("^3AMBIENT Smoke Plumes: ^5rpam_ambientsmoke  ^7" + getcvar("rpam_ambientsmoke"));
  	iprintln(" ");
  	iprintln(" ");
  
	wait 0.05;

// railyard overhaul

	if (getcvar("mapname") == "mp_railyard" &&  getcvar("rpam_overhaul") == "1")
	{
		iprintln("^7mp_railyard^7: ^5rpam_overhaul ^9is ^7" + getcvar("rpam_overhaul"));
		iprintln("^5railyard_add_decoration1 ^7" + getcvar("railyard_add_decoration1"));
		iprintln("^5railyard_add_decoration2 ^7" + getcvar("railyard_add_decoration2"));
		iprintln("^5railyard_fix_bombspots ^7" + getcvar("railyard_fix_bombspots"));	
		iprintln("^5railyard_fix_woodstation_ruins ^7" + getcvar("railyard_fix_woodstation_ruins"));	
		iprintln("^5railyard_fix_woodstation_spawn ^7" + getcvar("railyard_fix_woodstation_spawn"));	
	
	wait 0.05;

		iprintln("^5railyard_fix_woodstation_roof ^7" + getcvar("railyard_fix_woodstation_roof"));
		iprintln("^5railyard_fix_ruins_roof ^3(^90^3-^95^3)^5 ^9is ^2" + getcvar("railyard_fix_ruins_roof"));
		iprintln("^5railyard_fix_ruins_stairs ^9is ^2" + getcvar("railyard_fix_ruins_stairs"));
		iprintln("^5railyard_fix_ruins_stone ^9is ^2" + getcvar("railyard_fix_ruins_stone"));
		iprintln("^5railyard_block_southstation_roof ^9is ^2" + getcvar("railyard_block_southstation_roof"));
		iprintln("^5railyard_block_updown ^9is ^2" + getcvar("railyard_block_updown"));

		iprintln(" ");
	}

	if (getcvar("mapname") == "mp_dawnville_x")
	{
		iprintln("^7mp_dawnville_x^7: ");
		iprintln("^9- Axis spawn wall no longer affects player movement");
		iprintln("^9- Certain windows blocked to prevent prone-bug abuse");
		iprintln("^9- Graveyard bush wall is no longer see-through ^3v2");
		iprintln("^9- Bombsite tanks remodeled for accurate hitboxes");
		iprintln(" ");
	}

	if (getcvar("mapname") == "mp_railyard_x")
	{
		iprintln("^7mp_railyard_x^7: ");
		iprintln("^9- Axis spawn wooden panels are now solid");
//		iprintln("^9- Raised the sky to prevent grenade disappearance");
		iprintln("^9- S&D Tiger tanks remodeled to fix gaps");
		iprintln("^9- Ruins faulty rock patched");
		iprintln("^9- Ruins stairs blocked when prone");
		iprintln("^9- Ruins roof no longer see-through ^3v4");
		iprintln(" ");
	}

// beauville v4
	if (getcvar("mapname") == "mp_beauville")
	{
		iprintln("^7mp_beauville^7: ");
		iprintln("^9- Completed S&D with adding the B-site (Tiger Tank)");
		iprintln("^9- A- & B-site do now show their models in other gametypes too");
		iprintln("^9- Various corrections to the spawns & intermission coordinates");
		iprintln(" ");
	}

	if (getcvar("mapname") == "mp_pegasusnight"  ||  getcvar("mapname") == "mp_pegasusday")
	{
		iprintln("^7mp_pegasusnight and mp_pegasusday^7: ");
		iprintln("^9- Various corrections to the spawns & intermission coordinates");
		iprintln(" ");
	}

// hanoi
	if (getcvar("mapname") == "mp_hanoi")
	{
		iprintln("^7mp_hanoi^7: ");
		iprintln("^9- Command ^3hanoi_effect_searchlight 0 ^9or ^3hanoi_effect_cinema 0");
		iprintln("^9  can turn off the searchlight and projector after a map restart");
		iprintln(" ");
	}

	wait 0.05;

// s&d
	if (getcvar("g_gametype") == "sd")
	{
		iprintln(" ");
		iprintln("^3[INFO]^7 Gametype detected: ^3Search and Destroy (S&D)");
		iprintln("^3[INFO]^7 Command ^5rpam_msg ^7has been set to 0.");
		iprintln(" ");

		setCvar("rpam_msg", "0");
	}	

// end^
	iprintln("^7--------------------------------------------------------");
	iprintln("^3[^7rPAM^3] ^7All systems initialized successfully.");
	iprintln(" ");
  	iprintln(" ");
}
// END