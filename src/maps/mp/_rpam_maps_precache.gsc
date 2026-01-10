//	Version: v225
//
//	rPAM MAPS OVERHAUL AMBIENT
//
//	REISSUE Project Ares Mod version 1.15
//	
//	_rpam_maps_precache.gsc
//
//	Add all precache stuff to every map
//
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 

main()
{
	precacheFX();   
}

precacheFX()
{
// classic 1.5 maps
	level._effect["antitankgunexplosion"]	= loadfx("fx/explosions/explosion1_nolight.efx");

	level._effect["flakpanzerexplosion"]	= loadfx("fx/explosions/explosion1_nolight.efx");
	level._effect["tigertankexplosion"]	= loadfx("fx/explosions/explosion1_nolight.efx");

	level._effect["v2rocketexplosion"]	= loadfx("fx/explosions/explosion1_nolight.efx");	// rocket
	level._effect["fueltank"]		= loadfx("fx/explosions/fueltank_ned.efx");		// railyard, rocket

	level._effect["fueltank"]		= loadfx("fx/explosions/fueltank_ned.efx");			// powcamp
	level._effect["wood_close"]		= loadfx ("fx/cannon/wood_close.efx");				// powcamp
    	level._effect["wood"]			= loadfx ("fx/cannon/wood.efx");				// powcamp
    	level._effect["dust"]			= loadfx ("fx/cannon/dust.efx");				// powcamp
    	level._effect["dirt"]			= loadfx ("fx/cannon/dirt.efx");				// powcamp
}
