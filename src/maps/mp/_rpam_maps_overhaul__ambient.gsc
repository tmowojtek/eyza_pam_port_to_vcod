//	Version: v225
//
//	rPAM MAPS OVERHAUL AMBIENT
//
//	REISSUE Project Ares Mod version 1.15
//	
//	_rpam_maps_overhaul__ambient.gsc
//
//	Adds: all classic maps, mp_germantown, mp_dawnville_x, mp_railyard_x,
//	                        mp_carentan_x, mp_neuville_x, mp_tigertown_x
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 
/**	
 *	Updating a 2003 classic game requires preserving its original charme while
 *	introducing modern customization options and play styles. The current
 *	adjustments focus on map fog and ambient sounds to maintain the games
 *	atmosphere and playability.
 *	
 *	The game is from 2003, and in 2015, we came up with the idea of removing
 *	environment sounds from the maps and add up a countdown timer in S&D.
 *	Now we wanted to remove the fog.
 *	
 *	Fog, originally used for atmosphere and rendering optimization, remains
 *	to ensure its visual and gameplay benefits. It enhances map readability, 
 *	such as highlighting dark textures in "Dawnville" or masking distant walls
 *	in maps like "Harbor" and "Railyard." Removing it entirely could harm the
 *	aesthetic and clarity of these environments.
 *	
 *	Ambient sounds have been minimized to give players more control over the
 *	audio environment while retaining key elements for immersion.
 *	
 *	Goals overall:
 *	- Preserve the original atmosphere and style.
 *	- Keep fog as a visual tool for clarity and immersion.
 *	- Streamline ambient sounds while maintaining map identity.
 *	
 *	The new commands are set by default, so that S&D still
 *	uses no ambient sound, while DM/TDM and the others use it.
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////// 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
////////
//////		MAIN
////
// 

main()
{
	thread rpam_mapambient_cvar();
	thread rpam_mapambient_level();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////// 	
///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////
///////		Check rPAM commands without rPAM
////		- get the settings by .gsc
//					

rpam_mapambient_cvar()
{
	maps\mp\_rpam_maps_overhaul__ambient_cvar::main();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////// 	
///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////
///////		rPAM Ambient
////		- get the settings by .gsc
//	

rpam_mapambient_level()
{
// Get mapname
	level.mapname = getcvar("mapname");

// All maps
	switch(level.mapname)
	{
		case "mp_bocage":
			thread rpam_mp_bocage();
			break;

		case "mp_brecourt":
			thread rpam_mp_brecourt();
			break;

		case "mp_carentan":
		case "mp_carentan_x":						// mp_carentan_x added
			thread rpam_mp_carentan();
			break;

		case "mp_chateau":
			thread rpam_mp_chateau();
			break;

		case "mp_dawnville":
		case "mp_dawnville_x":						// mp_dawnville_x added
			thread rpam_mp_dawnville();
			break;

		case "mp_depot":
			thread rpam_mp_depot();
			break;

		case "mp_harbor":
			thread rpam_mp_harbor();
			break;

		case "mp_hurtgen":
			thread rpam_mp_hurtgen();
			break;

		case "mp_neuville":
		case "mp_neuville_x":
			thread rpam_mp_neuville();
			break;

		case "mp_pavlov":
			thread rpam_mp_pavlov();
			break;

		case "mp_powcamp":
			thread rpam_mp_powcamp();
			break;

		case "mp_railyard":
		case "mp_railyard_x":						// mp_railyard_x added
			thread rpam_mp_railyard();
			break;

		case "mp_rocket":
			thread rpam_mp_rocket();
			break;

		case "mp_ship":
			thread rpam_mp_ship();
			break;

		case "mp_stalingrad":
			thread rpam_mp_stalingrad();
			break;

		case "mp_tigertown":
		case "mp_tigertown_x":
			thread rpam_mp_tigertown();
			break;

		case "mp_germantown":						// mp_germantown added
			thread rpam_mp_germantown();
			break;

		default:
			break;
	}
	
// Display Messagecenter
//	if (getcvar("rpam_ambient_messagecenter") == 1)
//		maps\mp\_rpam_maps_overhaul__ambient_msgc::main();		// ambient msgc
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////// 	
///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////
///////		COD1 V1.5 MAPS
////		+ mp_germantown
//	
//
//	Fog color: (distant) bluish grey
//
//	- ambientfog forks as follows: setCullFog(near, far, red, green, blue, duration);
//												// 9/17

rpam_mp_brecourt()										// brecourt
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_brecourt");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 13500, .32, .36, .40, 0); 			// orig brec
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 13500, .32, .36, 0.40, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 16500, .32, .36, .40, 0);			// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 16500, .32, .36, .40, 0);
}

rpam_mp_dawnville()										// dawnville
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_dawnville");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 8000, .32, .36, .40, 0);				// orig dw
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 12400, .32, .36, .40, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 14500, .32, .36, .40, 0);			// auto 3 is okay
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 16500, .32, .36, .40, 0);
}

rpam_mp_depot()											// depot
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_depot");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 7500, .32, .36, .40, 0);				// orig depot
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 12400, .32, .36, .40, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 14500, .32, .36, .40, 0);			// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 16500, .32, .36, .40, 0);
}

rpam_mp_neuville()										// neuville
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_dawnville");


	if (level.z_rpam_ambientfog == 1)					// orig neuville
		setExpFog(0.00025, .32, .36, .40, 0);
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 12400, .32, .36, .40, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 14400, .32, .36, .40, 0);			// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 16500, .32, .36, .40, 0);

	if (level.z_rpam_ambientsmoke == 1)
		maps\mp\mp_neuville_fx::main();
}

rpam_mp_tigertown()										// tigertown
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_dawnville");

	if (level.z_rpam_ambientfog == 1)
	{
//		setExpFog(0.00025, .32, .36, .40, 0); 				// orig deactivated
	}
	else if (level.z_rpam_ambientfog == 2)
	{
		setCullFog (1250, 12400, .32, .36, .40, 0);
	}
	else if (level.z_rpam_ambientfog == 3)					// auto 3
	{
		setCullFog (2500, 14400, .32, .36, .40, 0);
	}
	else if (level.z_rpam_ambientfog == 4)
	{
		setCullFog (3750, 16500, .32, .36, .40, 0);
	}

	if (level.z_rpam_ambientsmoke == 1)					// load ambient smoke
		maps\mp\mp_tigertown_fx::main();
}

rpam_mp_hurtgen()										// hurtgen
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_hurtgen");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 5000, .32, .36, .40, 0 );			// orig hurtgen
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 6000, .32, .36, .40, 0 );
	else if (level.z_rpam_ambientfog == 3)					// auto 3
		setCullFog (2500, 7000, .32, .36, .40, 0 );
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 8000, .32, .36, .40, 0);
}

rpam_mp_rocket()										// rocket
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_rocket");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 4500, .32, .36, .40, 0);				// orig
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 5500, .32, .36, .40, 0);
	else if (level.z_rpam_ambientfog == 3)					// auto 3
		setCullFog (2500, 6500, .32, .36, .40, 0);
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 7500, .32, .36, .40, 0);
}

rpam_mp_powcamp()										// powcamp
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_powcamp");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 8000, .32, .36, .40, 0);				// orig
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 10000, .32, .36, .40, 0);
	else if (level.z_rpam_ambientfog == 3)					// auto 3
		setCullFog (2500, 12000, .32, .36, .40, 0);
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 12000, .32, .36, .40, 0);	// lim
}

rpam_mp_ship()											// ship
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_ship");

	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 7500, .32, .36, .40, 0);				// orig
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 10000, .32, .36, .40, 0);
	else if (level.z_rpam_ambientfog == 3)					// auto 3
		setCullFog (2500, 12000, .32, .36, .40, 0 );
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (3750, 12000, .32, .36, .40, 0 );	// lim				// 9/17
}

//
//	Fog color: (distant) sky blue
//

rpam_mp_carentan()										// carentan
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_carentan");

	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 16500, 0.7, 0.85, 1.0, 0);			// orig carentan
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 16500, 0.7, 0.85, 1.0, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 16500, 0.7, 0.85, 1.0, 0);			// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 16500, 0.7, 0.85, 1.0, 0);
}

rpam_mp_germantown()										// germantown
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_brecourt");

	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 16500, 0.7, 0.85, 1.0, 0);			// orig german_town
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 16500, 0.7, 0.85, 1.0, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 16500, 0.7, 0.85, 1.0, 0);			// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 16500, 0.7, 0.85, 1.0, 0);					// 11/17
}

//
//	Fog color: (distant) warm brownish grey
//

rpam_mp_bocage()										// bocage
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_brecourt");

	if (level.z_rpam_ambientfog == 1)		// 1
	{
	r = 135;								// orig
	g = 130;
	b = 111;

	setExpFog(0.0001, (float)r/(float)255,(float)g/(float)255,(float)b/(float)255, 0);
	}
	else if (level.z_rpam_ambientfog == 2)		// 2
	{
//		setExpFog(0.0001, 0.529, 0.5098, 0.4353, 0);			// default fog values as ExpFog
		setCullFog(1250, 13500, 0.529, 0.5098, 0.4353, 0);		// default fog values as CullFog testing
	}
	else if (level.z_rpam_ambientfog == 3)		// 3
	{
		setCullFog(2500, 16500,  0.135, 0.130, 0.111, 0);		// auto 3
	}
	else if (level.z_rpam_ambientfog == 4)		// 4
	{

		setCullFog(3750, 16500, 0.529, 0.5098, 0.4353, 0);
	}

//	if (level.z_rpam_ambientsmoke == 1)					// bocage has no smoke plumes
//		setCvar("rpam_ambientsmoke", "0");						// 12/17
}

//
//	Fog color: (distant) night black
//

rpam_mp_chateau()										// chateau
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_chateau");

	if (level.z_rpam_ambientfog == 1)
		setExpFog(0.00001, 0, 0, 0, 0);					// orig
	else if (level.z_rpam_ambientfog == 2)
		setExpFog(0.00001, 0, 0, 0, 0);					// lim, because distant objects
	else if (level.z_rpam_ambientfog == 3)					// going black with CullFog
		setExpFog(0.00001, 0, 0, 0, 0);					// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setExpFog(0.00001, 0, 0, 0, 0);							// 13/17
}


//
//	Fog color: (distant) snow white
//

rpam_mp_harbor()										// harbor
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_harbor");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 6500, 0.8, 0.8, 0.8, 0);				//pavlovtest sky color / orig
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 8000, .8, .8, .8, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 9500, .8, .8, .8, 0);				// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 11000, .8, .8, .8, 0); 
}

rpam_mp_pavlov()										// pavlov
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_pavlov");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 6000, 0.8, 0.8, 0.8, 0);	// orig
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 8000, .8, .8, .8, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 9500, .8, .8, .8, 0);				// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 11000, .8, .8, .8, 0);
}

rpam_mp_railyard()										// railyard
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_railyard");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 8000, 0.8, 0.8, 0.8, 0);	// orig
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 9250, .8, .8, .8, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 10500, .8, .8, .8, 0);			// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 11750, .8, .8, .8, 0);
}

rpam_mp_stalingrad()										// stalingrad
{
	if (level.z_rpam_ambientsounds == 1)
		ambientPlay("amb_mp_pavlov");


	if (level.z_rpam_ambientfog == 1)
		setCullFog (0, 8000, 0.8, 0.8, 0.8, 0);	// orig
	else if (level.z_rpam_ambientfog == 2)
		setCullFog (1250, 8500, .8, .8, .8, 0);
	else if (level.z_rpam_ambientfog == 3)
		setCullFog (2500, 9000, .8, .8, .8, 0);				// auto 3
	else if (level.z_rpam_ambientfog == 4)
		setCullFog (3750, 9500, .8, .8, .8, 0);
												// 17/17

//	if (level.z_rpam_ambientsmoke == 1)
//		setCvar("rpam_ambientsmoke", "0");
}

// END