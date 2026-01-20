//	Version: v225
//
//	rPAM MAPS OVERHAUL
//
//	REISSUE Project Ares Mod version 1.15
//	
//	_rpam__reset.gsc
//
//	This script resets some cvars if not "seta rpam_reset 0".
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 

main()
{
	if (getcvar("rpam_reset") == "" || getcvar("rpam_reset") == "1")
	{
		thread rpam_reset();                            		// clear other mods commands
	}
}

rpam_reset()
{
	setCvar("scr_allow_fg42", "0");
	setCvar("scr_allow_panzerfaust", "0");
	setCvar("r_fastsky", "0");
	setCvar("r_fog", "1");
}

// END