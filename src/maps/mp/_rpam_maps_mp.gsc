//	Version: v225
//
//	rPAM MAPS OVERHAUL AMBIENT
//
//	REISSUE Project Ares Mod version 1.15
//	
//	_rpam_maps_mp.gsc STARTER SCRIPT
//
//	Adds: all classic maps, mp_germantown, mp_dawnville_x, mp_railyard_x,
//	                        mp_carentan_x, mp_neuville_x, mp_tigertown_x
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 

main()
{
	maps\mp\_rpam__reset::main();                            // clear some cvars

	if (getcvar("rpam_msg") == "" || getcvar("rpam_msg") == "1")
	{
		level thread maps\mp\_rpam__msgc::rpam_msg();
	}

	if (getcvar("rpam_msg") == "0" && getcvar("g_Gametype") != "sd")
	{
		level thread maps\mp\_rpam__msgc::rpam_msg();
	}

	maps\mp\_rpam_maps_precache::main();               	// precache bombspot effects for all maps
	
	maps\mp\_rpam_maps_overhaul__ambient::main();		// rPAM ambient module

	maps\mp\_rpam_maps_overhaul__improvements::main(); 	// rPAM improvement module

//	maps\mp\_rpam_maps_promotion::rpam_promotion();    	// rPAM promotion module

	if (getcvar("rpam_debug") == "1")
	{
		level thread maps\mp\_rpam__debug::rpam_debug();
	}
}

// END