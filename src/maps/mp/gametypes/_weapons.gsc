

init()
{
	logprint("_weapons::init\n");
	maps\mp\gametypes\global\_global::addEventListener("onCvarChanged", ::onCvarChanged);

	registerCvars();

	maps\mp\gametypes\global\_global::addEventListener("onStartGameType", ::onStartGameType);

	level.scr_smoke_fix = false;
}

// Called from start_gametype when registring cvars
registerCvars()
{
	var = maps\mp\gametypes\global\_global::registerCvar;

	[[var]]("scr_rifle_mode", "BOOL", 0);       // level.scr_rifle_mode

	// Nade spawn counts for each class
	[[var]]("scr_boltaction_nades", "INT", 3, 0, 99);
	[[var]]("scr_semiautomatic_nades", "INT", 2, 0, 99);
	[[var]]("scr_smg_nades", "INT", 1, 0, 99);
	[[var]]("scr_sniper_nades", "INT", 3, 0, 99);
	[[var]]("scr_mg_nades", "INT", 2, 0, 99);
	[[var]]("scr_shotgun_nades", "INT", 1, 0, 99);
	[[var]]("scr_dmg_nades", "INT", 1, 0, 99);

	// Smoke spawn counts for each class
	[[var]]("scr_boltaction_smokes", "INT", 0, 0, 99);
	[[var]]("scr_semiautomatic_smokes", "INT", 0, 0, 99);
	[[var]]("scr_smg_smokes", "INT", 1, 0, 99);
	[[var]]("scr_sniper_smokes", "INT", 0, 0, 99);
	[[var]]("scr_mg_smokes", "INT", 0, 0, 99);
	[[var]]("scr_shotgun_smokes", "INT", 1, 0, 99);
	[[var]]("scr_dmg_smokes", "INT", 1, 0, 99);

	// Weapon Limits by class per team
	[[var]]("scr_boltaction_limit", "INT", 99, 0, 99);
	[[var]]("scr_sniper_limit", "INT", 99, 0, 99);
	[[var]]("scr_semiautomatic_limit", "INT", 99, 0, 99);
	[[var]]("scr_smg_limit", "INT", 99, 0, 99);
	[[var]]("scr_mg_limit", "INT", 99, 0, 99);
	[[var]]("scr_shotgun_limit", "INT", 99, 0, 99);
	[[var]]("scr_dmg_limit", "INT", 99, 0, 99);

	// Allow weapon drop when player die
	[[var]]("scr_boltaction_allow_drop", "BOOL", 1);
	[[var]]("scr_sniper_allow_drop", "BOOL", 1);
	[[var]]("scr_semiautomatic_allow_drop", "BOOL", 1);
	[[var]]("scr_smg_allow_drop", "BOOL", 1);
	[[var]]("scr_mg_allow_drop", "BOOL", 1);
	[[var]]("scr_shotgun_allow_drop", "BOOL", 1);
	[[var]]("scr_pistol_allow_drop", "BOOL", 1);
	[[var]]("scr_dmg_allow_drop", "BOOL", 1);
	

	// Allow/Disallow Weapons
	[[var]]("scr_allow_greasegun", "BOOL", 1);
	[[var]]("scr_allow_m1carbine", "BOOL", 1);
	[[var]]("scr_allow_m1garand", "BOOL", 1);
	[[var]]("scr_allow_springfield", "BOOL", 1);
	[[var]]("scr_allow_thompson", "BOOL", 1);
	[[var]]("scr_allow_bar", "BOOL", 1);
	[[var]]("scr_allow_sten", "BOOL", 1);
	[[var]]("scr_allow_enfield", "BOOL", 1);
	[[var]]("scr_allow_enfieldsniper", "BOOL", 1);
	[[var]]("scr_allow_bren", "BOOL", 1);
	[[var]]("scr_allow_pps42", "BOOL", 1);
	[[var]]("scr_allow_nagant", "BOOL", 1);
	[[var]]("scr_allow_svt40", "BOOL", 1);
	[[var]]("scr_allow_nagantsniper", "BOOL", 1);
	[[var]]("scr_allow_ppsh", "BOOL", 1);
	[[var]]("scr_allow_mp40", "BOOL", 1);
	[[var]]("scr_allow_kar98k", "BOOL", 1);
	[[var]]("scr_allow_gewehr43", "BOOL", 1);
	[[var]]("scr_allow_kar98ksniper", "BOOL", 1);
	[[var]]("scr_allow_mp44", "BOOL", 1);
	[[var]]("scr_allow_mg34", "BOOL", 1);
	[[var]]("scr_allow_mg30cal", "BOOL", 1);	
	[[var]]("scr_allow_dp28", "BOOL", 1);
	[[var]]("scr_allow_shotgun", "BOOL", 1);



	// Allow grenade / smoke drop when player die
	[[var]]("scr_allow_grenade_drop", "BOOL", 1); 	// level.allow_nadedrops
	[[var]]("scr_allow_smoke_drop", "BOOL", 1); 	// level.allow_smokedrops



	[[var]]("scr_allow_pistols", "BOOL", 1); 	// level.allow_pistols // NOTE: in sd next round
	[[var]]("scr_allow_turrets", "BOOL", 1); 	// level.allow_turrets // NOTE: after map/round reset

	[[var]]("scr_allow_panzerfaust", "BOOL", 1); // level.allow_panzerfaust
	[[var]]("scr_allow_fg42", "BOOL", 1); // level.allow_fg42
	[[var]]("scr_allow_satchel", "BOOL", 1); // level.allow_fg42
	[[var]]("scr_allow_flamethrower", "BOOL", 1); // level.allow_flamethrower
	[[var]]("scr_allow_panzershreck", "BOOL", 1); // level.allow_panzershreck
	[[var]]("scr_allow_bazooka", "BOOL", 1); // level.allow_bazooka
	
	[[var]]("scr_allow_tanks", "BOOL", 1); // level.allow_tanks	
	[[var]]("scr_allow_jeeps", "BOOL", 1); // level.allow_jeeps	
	[[var]]("scr_allow_flak88", "BOOL", 1); // level.allow_flak88	
	
	[[var]]("scr_allow_binoculars", "BOOL", 1); // level.allow_binoculars	


	[[var]]("scr_no_oneshot_pistol_kills", "BOOL", 0); 	//level.prevent_single_shot_pistol // Single Shot Kills
	[[var]]("scr_no_oneshot_ppsh_kills", "BOOL", 0); 	//level.prevent_single_shot_ppsh // Single Shot Kills
	[[var]]("scr_balance_ppsh_distance", "BOOL", 0); 	//level.balance_ppsh //ppsh -> tommy balance


	[[var]]("scr_shotgun_consistent", "BOOL", 0);	// level.scr_shotgun_consistent
	[[var]]("scr_hitbox_hand_fix", "BOOL", 0);	// level.scr_hitbox_hand_fix
	[[var]]("scr_hitbox_torso_fix", "BOOL", 0);		// level.scr_hitbox_torso_fix
	
	[[var]]("scr_drophealth", "BOOL", 1);
}


// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	switch(cvar)
	{
		case "scr_rifle_mode":
		{
			// Change value only while registrating (changing value requires map restart)
			if (isRegisterTime)
				level.scr_rifle_mode = value;
			return true;
		}

		// Nothing get updated because we are getting value directly from getCvar()
		case "scr_boltaction_nades":
		case "scr_boltaction_smokes":
		case "scr_semiautomatic_nades":
		case "scr_semiautomatic_smokes":
		case "scr_smg_nades":
		case "scr_smg_smokes":
		case "scr_sniper_nades":
		case "scr_sniper_smokes":
		case "scr_mg_nades":
		case "scr_mg_smokes":
		case "scr_shotgun_nades":
		case "scr_shotgun_smokes":
		case "scr_dmg_nades":
		case "scr_dmg_smokes":
		return true;

		// If class limit changed, update all weapons
		case "scr_boltaction_limit":
		case "scr_sniper_limit":
		case "scr_semiautomatic_limit":
		case "scr_smg_limit":
		case "scr_mg_limit":
		case "scr_shotgun_limit":
		case "scr_dmg_limit":
			if (!isRegisterTime)
			{
				thread updateLimit(cvar, value);
				thread maps\mp\gametypes\_weapon_limiter::Update_All_Weapon_Limits();
			}
		return true;


		// Allow weapon drop if player dead
		case "scr_boltaction_allow_drop":
		case "scr_sniper_allow_drop":
		case "scr_semiautomatic_allow_drop":
		case "scr_smg_allow_drop":
		case "scr_mg_allow_drop":
		case "scr_shotgun_allow_drop":
		case "scr_dmg_allow_drop":		
            		if (!isRegisterTime) thread updateDrop(cvar, value);
			return true;

		case "scr_pistol_allow_drop":
			return true;



		// If some wepaons was enabled/disabled
		case "scr_allow_greasegun":
		case "scr_allow_m1carbine":
		case "scr_allow_m1garand":
		case "scr_allow_springfield":
		case "scr_allow_thompson":
		case "scr_allow_bar":
		case "scr_allow_sten":
		case "scr_allow_enfield":
		case "scr_allow_enfieldsniper":
		case "scr_allow_bren":
		case "scr_allow_pps42":
		case "scr_allow_nagant":
		case "scr_allow_svt40":
		case "scr_allow_nagantsniper":
		case "scr_allow_ppsh":
		case "scr_allow_mp40":
		case "scr_allow_kar98k":
		case "scr_allow_gewehr43":
		case "scr_allow_kar98ksniper":
		case "scr_allow_mp44":
		case "scr_allow_shotgun":
		case "scr_allow_mg34":
		case "scr_allow_dp28":
		case "scr_allow_mg30cal":
			if (!isRegisterTime) thread updateAllowed(cvar, value);
		return true;



		case "scr_allow_grenade_drop": 		level.allow_nadedrops = value; return true;
        case "scr_allow_smoke_drop": 		level.allow_smokedrops = value; return true;





		case "scr_allow_pistols": 		level.allow_pistols = value; return true;
		case "scr_allow_turrets": 		level.allow_turrets = value; return true;

		case "scr_allow_panzerfaust":	level.allow_panzerfaust = value; return true;
		case "scr_allow_fg42":			level.allow_fg42 = value; return true;
		case "scr_allow_satchel":		level.allow_satchel = value; return true;
		case "scr_allow_flamethrower":	level.allow_flamethrower = value; return true;
		case "scr_allow_panzershreck":	level.allow_panzershreck = value; return true;
		case "scr_allow_bazooka":		level.allow_bazooka = value; return true;
		
		case "scr_allow_jeeps":			level.allow_jeeps = value; return true;
		case "scr_allow_tanks":			level.allow_tanks = value; return true;
		case "scr_allow_flak88":		level.allow_flak88 = value; return true;		

		case "scr_allow_binoculars":	level.allow_binoculars = value; return true;

		case "scr_no_oneshot_pistol_kills": 		level.prevent_single_shot_pistol = value; return true;
		case "scr_no_oneshot_ppsh_kills": 		level.prevent_single_shot_ppsh = value; return true;
		case "scr_balance_ppsh_distance": 		level.balance_ppsh = value; return true;


		case "scr_shotgun_consistent":
			level.scr_shotgun_consistent = value;
			return true;

		case "scr_hitbox_hand_fix":
			level.scr_hitbox_hand_fix = value;
			return true;

		case "scr_hitbox_torso_fix":
			level.scr_hitbox_torso_fix = value;
			return true;

	}


	return false;
}


// Called after the <gametype>.gsc::main() and <map>.gsc::main() scripts are called
// At this point game specific variables are defined (like game["allies"], game["axis"], game["american_soldiertype"], ...)
// Called again for every round in round-based gameplay
onStartGameType()
{
	if(game["firstInit"])
	{
		if(level.scr_rifle_mode)
			precacheWeaponsRifle();
		else
			precacheWeapons();
	}

	// Weapons & Limits
	if(level.scr_rifle_mode)
		defineWeaponsRifle();
	else
		defineWeapons();

	// Disable MG
	if (!level.allow_turrets)
	{
		//deletePlacedEntity("misc_turret");
		deletePlacedEntity("misc_mg42");
	}

	if (!level.allow_panzerfaust)
	{
		deletePlacedEntity("mpweapon_panzerfaust");
	}
	if (!level.allow_fg42)
	{
		deletePlacedEntity("mpweapon_fg42");
	}
	if (!level.allow_satchel)
	{
		deletePlacedEntity("mpweapon_satchelcharge");
	}
	if (!level.allow_panzershreck)
	{
		deletePlacedEntity("mpweapon_panzershreck");
	}
	if (!level.allow_bazooka)
	{
		deletePlacedEntity("mpweapon_bazooka");
	}
	if (!level.allow_flamethrower)
	{
		deletePlacedEntity("mpweapon_flamethrower");
	}
	if(!level.allow_tanks)
	{
		deletePlacedEntity("t34_mp");
		deletePlacedEntity("shermantank_mp");
		deletePlacedEntity("panzeriv_mp");
		deletePlacedEntity("elefant_mp");
		deletePlacedEntity("su152_mp");
		return;
	}
	if(!level.allow_jeeps)
	{
		deletePlacedEntity("willyjeep_mp");
		deletePlacedEntity("gaz67b_mp");
		deletePlacedEntity("horch_mp");
		return;
	}
	if(!level.allow_flak88)
	{
		deletePlacedEntity("Flak88_MP");
		deletePlacedEntity("flak88_mp");
	}
}


precacheWeaponsRifle()
{
	switch(game["allies"])
	{
	case "american":

		precacheItem("fraggrenade_mp");
		//precacheItem("smoke_grenade_american_mp");
		precacheItem("colt_mp");
		break;

	case "british":

		precacheItem("mk1britishfrag_mp");
		//precacheItem("smoke_grenade_british_mp");
		precacheItem("webley_mp");
		//precacheItem("colt_mp");
		break;

	case "russian":

		precacheItem("rgd-33russianfrag_mp");
		//precacheItem("smoke_grenade_russian_mp");
		precacheItem("tt33_mp");
		//precacheItem("luger_mp");
		break;
	}

	precacheItem("smokegrenade_mp");

	precacheItem("kar98k_mp");
	precacheItem("enfield_mp");
	precacheItem("mosin_nagant_mp");
	precacheItem("kar98k_sniper_mp");
	precacheItem("enfield_scope_mp");
	precacheItem("mosin_nagant_sniper_mp");
	precacheItem("springfield_mp");

	precacheItem("stielhandgranate_mp");
	//precacheItem("smoke_grenade_german_mp");

	precacheItem("luger_mp");


	// Weapons for all
	precacheItem("binoculars_mp");
	precacheItem("binoculars_artillery_mp");
	precacheItem("satchelcharge_mp");
}

precacheWeapons()
{
	// There is a weird bug with smoke
	// If precacheItem() with smoke is called as first before any other weapons, the smoke renders in old way with siluets
	// If precacheItem() with smoke is called after weapons, the smoke renders in new way with thick textures

	switch(game["allies"])
	{
	case "american":

		if (level.scr_smoke_fix == false) // old way
		{
			precacheItem("fraggrenade_mp");
			//precacheItem("smoke_grenade_american_mp");
		}

		//precacheItem("greasegun_mp");
		precacheItem("m1carbine_mp");
		precacheItem("m1garand_mp");
		precacheItem("springfield_mp");
		//precacheItem("shotgun_mp");
		precacheItem("thompson_mp");
		precacheItem("bar_mp");
		precacheItem("mg30cal_mp");

		if (level.scr_smoke_fix) // new way
		{
			precacheItem("fraggrenade_mp");
			//precacheItem("smoke_grenade_american_mp");
		}

		precacheItem("colt_mp");

		break;

	case "british":

		if (level.scr_smoke_fix == false) // old way
		{
			precacheItem("mk1britishfrag_mp");
			//precacheItem("smoke_grenade_british_mp");
		}

		precacheItem("sten_mp");
		precacheItem("enfield_mp");
		//precacheItem("m1garand_mp");
		//precacheItem("enfield_scope_mp");
		precacheItem("springfield_mp");
		//precacheItem("shotgun_mp");
		precacheItem("thompson_mp");
		precacheItem("bren_mp");
		precacheItem("mg30cal_mp");

		if (level.scr_smoke_fix) // new way
		{
			precacheItem("mk1britishfrag_mp");
			//precacheItem("smoke_grenade_british_mp");
		}

		precacheItem("webley_mp");
		//precacheItem("colt_mp");

		break;

	case "russian":

		if (level.scr_smoke_fix == false) // old way
		{
			precacheItem("rgd-33russianfrag_mp");
			//precacheItem("smoke_grenade_russian_mp");
		}

		//precacheItem("PPS42_mp");
		precacheItem("mosin_nagant_mp");
		precacheItem("svt40_mp");
		precacheItem("mosin_nagant_sniper_mp");
		//precacheItem("shotgun_mp");
		precacheItem("ppsh_mp"); //PPSH_CHANGE
		//precacheItem("vpo135_mp");
		precacheItem("dp28_mp");

		if (level.scr_smoke_fix) // new way
		{
			precacheItem("rgd-33russianfrag_mp");
			//precacheItem("smoke_grenade_russian_mp");
		}

		precacheItem("tt33_mp");
		//precacheItem("luger_mp");

		break;
	}

	// German weapons
	if (level.scr_smoke_fix == false) // old way
	{
		precacheItem("stielhandgranate_mp");
		//precacheItem("smoke_grenade_german_mp");
	}

	precacheItem("mp40_mp");
	precacheItem("kar98k_mp");
	precacheItem("gewehr43_mp");
	precacheItem("kar98k_sniper_mp");
	//precacheItem("shotgun_mp");
	precacheItem("mp44_mp");
	precacheItem("mg34_mp");

	if (level.scr_smoke_fix) // new way
	{
		precacheItem("stielhandgranate_mp");
		//precacheItem("smoke_grenade_german_mp");
	}

	precacheItem("luger_mp");



	// Weapons for all
	precacheItem("smokegrenade_mp");
	//precacheItem("shotgun_mp");
	precacheItem("binoculars_mp");
	precacheItem("binoculars_artillery_mp");
	precacheItem("satchelcharge_mp");
}



defineWeaponsRifle()
{
	// List of all weapons that can be enabled or disabled by server cvars
	// If you want to add new weapons, you have to create new cvars in cvars.gsc

	// Rifle-only mode

	addWeapon("kar98k_mp", 			"boltaction", 			"both", 			"scr_allow_kar98k", 		"ui_allow_kar98k");
	addWeapon("enfield_mp", 		"boltaction", 			"both", 			"scr_allow_enfield", 		"ui_allow_enfield");
	addWeapon("mosin_nagant_mp", 		"boltaction", 			"both", 			"scr_allow_nagant", 		"ui_allow_nagant");
	addWeapon("kar98k_sniper_mp", 		"sniper", 			"both", 			"scr_allow_kar98ksniper", 	"ui_allow_kar98ksniper");
	addWeapon("enfield_scope_mp", 		"sniper",			"both", 			"scr_allow_enfieldsniper", 	"ui_allow_enfieldsniper");
	addWeapon("mosin_nagant_sniper_mp", 	"sniper", 			"both", 			"scr_allow_nagantsniper", 	"ui_allow_nagantsniper");
	addWeapon("springfield_mp", 		"sniper", 			"both", 			"scr_allow_springfield", 	"ui_allow_springfield");

	addClass("boltaction", 			"scr_boltaction_limit",		"scr_boltaction_nades", 	"scr_boltaction_smokes",	"scr_boltaction_allow_drop");
	addClass("sniper", 			"scr_sniper_limit",		"scr_sniper_nades", 		"scr_sniper_smokes", 		"scr_sniper_allow_drop");

}


defineWeapons()
{
	// List of all weapons that can be enabled or disabled by server cvars
	// If you want to add new weapons, you have to create new cvars in cvars.gsc
	// Conventional weapons

	switch(game["allies"])
	{
	case "american":
		//addWeapon("greasegun_mp", 	"smg", 				"allies", 	"scr_allow_greasegun", 		"ui_allow_greasegun");
		addWeapon("m1carbine_mp", 		"semiautomatic",	"allies", 	"scr_allow_m1carbine",		"ui_allow_m1carbine");
		addWeapon("m1garand_mp", 		"semiautomatic", 	"allies", 	"scr_allow_m1garand", 		"ui_allow_m1garand");
		addWeapon("springfield_mp", 	"sniper", 			"allies", 	"scr_allow_springfield", 	"ui_allow_springfield");
		addWeapon("thompson_mp", 		"smg", 				"allies", 	"scr_allow_thompson", 		"ui_allow_thompson");
		addWeapon("bar_mp", 			"mg", 				"allies", 	"scr_allow_bar", 			"ui_allow_bar");
		addWeapon("mg30cal_mp", 		"dmg", 				"allies", 	"scr_allow_mg30cal", 		"ui_allow_mg30cal");		
		break;

	case "british":
		addWeapon("sten_mp", 				"smg", 				"allies", 	"scr_allow_sten", 			"ui_allow_sten");
		addWeapon("enfield_mp", 			"boltaction", 		"allies", 	"scr_allow_enfield", 		"ui_allow_enfield");
		//addWeapon("m1garand_mp", 			"semiautomatic", 	"allies", 	"scr_allow_m1garand", 		"ui_allow_m1garand");
		//addWeapon("enfield_scope_mp", 	"sniper",			"allies", 	"scr_allow_enfieldsniper", 	"ui_allow_enfieldsniper");
		addWeapon("springfield_mp", 		"sniper",			"allies", 	"scr_allow_springfield", 	"ui_allow_springfield");
		//addWeapon("thompson_mp", 			"smg", 				"allies", 	"scr_allow_thompson", 		"ui_allow_thompson");
		addWeapon("bren_mp", 				"mg", 				"allies", 	"scr_allow_bren", 			"ui_allow_bren");
		addWeapon("mg30cal_mp", 			"dmg", 			 	"allies",  	"scr_allow_mg30cal", 	 	"ui_allow_mg30cal");		
		break;

	case "russian":
		//addWeapon("PPS42_mp", 			"smg", 				"allies", 	"scr_allow_pps42", 			"ui_allow_pps42");
		addWeapon("mosin_nagant_mp", 		"boltaction", 		"allies", 	"scr_allow_nagant", 		"ui_allow_nagant");
		addWeapon("svt40_mp", 				"semiautomatic", 	"allies", 	"scr_allow_svt40", 			"ui_allow_svt40");
		addWeapon("mosin_nagant_sniper_mp", "sniper", 			"allies", 	"scr_allow_nagantsniper", 	"ui_allow_nagantsniper");
		addWeapon("ppsh_mp", 				"smg", 				"allies", 	"scr_allow_ppsh", 			"ui_allow_ppsh"); //PPSH_CHANGE
		//addWeapon("vpo135_mp", 			"smg", 				"allies", 	"scr_allow_ppsh", 			"ui_allow_ppsh");
		addWeapon("dp28_mp", 				"dmg", 				"allies", 	"scr_allow_dp28", 			"ui_allow_dp28");
		break;
	}

	// Germans
	addWeapon("mp40_mp", 			"smg", 				"axis", 	"scr_allow_mp40", 			"ui_allow_mp40");
	addWeapon("kar98k_mp", 			"boltaction", 		"axis", 	"scr_allow_kar98k", 		"ui_allow_kar98k");
	addWeapon("gewehr43_mp", 			"semiautomatic", 	"axis", 	"scr_allow_gewehr43", 			"ui_allow_gewehr43");
	addWeapon("kar98k_sniper_mp", 	"sniper", 			"axis", 	"scr_allow_kar98ksniper", 	"ui_allow_kar98ksniper");
	addWeapon("mp44_mp", 			"mg", 				"axis", 	"scr_allow_mp44", 			"ui_allow_mp44");
	addWeapon("mg34_mp", 			"dmg", 				"axis", 	"scr_allow_mg34", 			"ui_allow_mg34");

	// All teams
	//addWeapon("shotgun_mp", 		"shotgun", 		"both", 	"scr_allow_shotgun", 		"ui_allow_shotgun");


	// Array of Available Weapon Classes
	// If you want to add new classes, you have to create new cvars in start_gametype.gsc
	//		(className, 		cvarLimit, 					cvarNades, 						cvarSmokes,				cvarAllowDrop)
	addClass("boltaction", 		"scr_boltaction_limit",		"scr_boltaction_nades", 	"scr_boltaction_smokes",	"scr_boltaction_allow_drop");
	addClass("sniper", 			"scr_sniper_limit",			"scr_sniper_nades", 		"scr_sniper_smokes", "scr_sniper_allow_drop");
	addClass("semiautomatic", 	"scr_semiautomatic_limit",	"scr_semiautomatic_nades", 	"scr_semiautomatic_smokes",			"scr_semiautomatic_allow_drop");
	addClass("smg", 			"scr_smg_limit",			"scr_smg_nades", 			"scr_smg_smokes",		"scr_smg_allow_drop");
	addClass("mg", 				"scr_mg_limit",				"scr_mg_nades", 			"scr_mg_smokes",			"scr_mg_allow_drop");
	//addClass("shotgun", 		"scr_shotgun_limit",		"scr_shotgun_nades", 		"scr_shotgun_smokes",		"scr_shotgun_allow_drop");
	addclass("dmg", 			"scr_dmg_limit",			"scr_dmg_nades", 		"scr_dmg_smokes",		"scr_dmg_allow_drop");

}



addWeapon(weaponName, className, teamName, serverCvar, clientCvar)
{
	if (!isDefined(level.weaponnames))
		level.weaponnames = [];
	if (!isDefined(level.weapons))
		level.weapons = [];

	level.weaponnames[level.weaponnames.size] = weaponName;

	if (isDefined(level.weapons[weaponName]))
	{
		logprint("Duplicate weapon name");
	}

	level.weapons[weaponName] = spawnstruct();
	level.weapons[weaponName].server_allowcvar = serverCvar;
	level.weapons[weaponName].client_allowcvar = clientCvar;
	level.weapons[weaponName].classname = className;
	level.weapons[weaponName].team = teamName;

	level.weapons[weaponName].allies_usedby = "";
	level.weapons[weaponName].axis_usedby = "";

	level.weapons[weaponName].allow = getCvarInt(serverCvar);
}

addClass(className, cvarLimit, cvarNades, cvarSmokes, cvarAllowDrop)
{
	if (!isDefined(level.weaponclasses))
		level.weaponclasses = [];
	if (!isDefined(level.weaponclass))
		level.weaponclass = [];

	//iprintln("------adding weapon class: "+className);

	level.weaponclasses[level.weaponclasses.size] = className;

	level.weaponclass[className] = spawnstruct();

	level.weaponclass[className].cvar = cvarLimit;
	level.weaponclass[className].cvarNades = cvarNades;
	level.weaponclass[className].cvarSmokes = cvarSmokes;
	level.weaponclass[className].cvarAllowDrop = cvarAllowDrop;

	level.weaponclass[className].limit = getCvarInt(cvarLimit);
	level.weaponclass[className].allow_drop = getCvarInt(cvarAllowDrop);

	level.weaponclass[className].axis_limited = 0;
	level.weaponclass[className].allies_limited = 0;



	// All weapons in this class are disabled
	if (level.weaponclass[className].limit == 0)
	{
		level.weaponclass[className].allies_limited = 1;
		level.weaponclass[className].axis_limited = 1;
	}
}



deletePlacedEntity(entity)
{
	entities = getentarray(entity, "classname");
	for(i = 0; i < entities.size; i++)
	{
		//println("DELETED: ", entities[i].classname);
		entities[i] delete();
	}
}



// Adds pistol to pistol slot only if empty
givePistol()
{
	self takeWeapon("colt_mp");
	self takeWeapon("luger_mp");
	self takeWeapon("webley_mp");
	self takeWeapon("tt33_mp");
	
	if ( !level.allow_pistols )
		return;
		
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
			pistoltype = "colt_mp";
			break;

		case "british":
			pistoltype = "webley_mp";
			break;

		case "russian":
			pistoltype = "tt33_mp";			
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			pistoltype = "luger_mp";			
			break;
		}			
	}

	self takeWeapon("colt_mp");
	self takeWeapon("webley_mp");
	self takeWeapon("tt33_mp");
	self takeWeapon("luger_mp");


	// clear out all ammo
	self setWeaponSlotAmmo("pistol", 0 );
	self setWeaponSlotClipAmmo("pistol", 0 );
	
	clip_size = getfullclipammo(pistoltype);
	ammount = maps\mp\gametypes\_pam_loadout_gmi::GetPistolAmmo(pistoltype);
	
	self giveWeapon(pistoltype);

	if ( ammount > clip_size )
	{
		self setWeaponSlotClipAmmo("pistol", clip_size );
		self setWeaponSlotAmmo("pistol", ammount - clip_size );
	}
	else
	{
		self setWeaponSlotClipAmmo("pistol", ammount );
	}
}

GetGrenadeTypeName()
{
	grenadetype = "none";
	/*
	if(self.pers["team"] == "allies")
		grenadetype = "frag_grenade_" + game["allies"] + "_mp";
	else if (self.pers["team"] == "axis")
		grenadetype = "frag_grenade_" + game["axis"] + "_mp";
	*/
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
			grenadetype = "fraggrenade_mp";
			break;

		case "british":
			grenadetype = "mk1britishfrag_mp";
			break;

		case "russian":
			grenadetype = "rgd-33russianfrag_mp";
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			grenadetype = "stielhandgranate_mp";
			break;
		}			
	}

	if (grenadetype == "none")
	{
		logprint("_weapons::GetGrenadeTypeName() - Unknown grenadetype.\n");
	}

	return grenadetype;
}

GetSmokeTypeName()
{
	grenadetype = "none";
	if(self.pers["team"] == "allies")
		grenadetype = "smokegrenade_mp";
	else if (self.pers["team"] == "axis")
		grenadetype = "smokegrenade_mp";

	return grenadetype;
}


giveGrenadesFor(weapon, count)
{
	// remove all grenades
	/*
	self takeWeapon("frag_grenade_american_mp");
	self takeWeapon("frag_grenade_british_mp");
	self takeWeapon("frag_grenade_russian_mp");
	self takeWeapon("frag_grenade_german_mp");
	*/
	self takeWeapon("fraggrenade_mp");
	self takeWeapon("mk1britishfrag_mp");
	self takeWeapon("rgd-33russianfrag_mp");
	self takeWeapon("stielhandgranate_mp");

	grenadetype = self GetGrenadeTypeName();
	fraggrenadecount = getWeaponBasedGrenadeCount(weapon);

	if (grenadetype == "none")
	{
		logprint("_weapons::giveGrenadesFor - Uknown grenadetype\n");
		return 0;
	}

	if(fraggrenadecount)
	{
		if (isDefined(count)) // replace count with own number
			fraggrenadecount = count;

		if (fraggrenadecount > 0)
		{
			//self giveWeapon(grenadetype);
			//self setWeaponClipAmmo(grenadetype, fraggrenadecount);
			//self switchtooffhand(grenadetype);
			self setWeaponSlotWeapon("grenade", grenadetype);
			self setWeaponSlotAmmo("grenade", fraggrenadecount);
			//self switchToWeapon(grenadetype);

			return fraggrenadecount;
		}
	}
	return 0;
}

giveSmokesFor(weapon, count)
{
	// remove all smokes
	// self takeWeapon("smoke_grenade_american_mp");
	// self takeWeapon("smoke_grenade_british_mp");
	// self takeWeapon("smoke_grenade_russian_mp");
	// self takeWeapon("smoke_grenade_german_mp");
	self takeWeapon("smokegrenade_mp");

	smokegrenadetype = self GetSmokeTypeName();
	smokegrenadecount = getWeaponBasedSmokeGrenadeCount(weapon);

	if (smokegrenadetype == "none")
	{
		logprint("_weapons::giveSmokesFor - Uknown smoketype\n");
		return 0;
	}

	if (smokegrenadecount) 
	{
		if (isDefined(count)) // replace count with own number
			smokegrenadecount = count;
		
		if(smokegrenadecount > 0)
		{

			self setWeaponSlotWeapon("smokegrenade", smokegrenadetype);
			self setWeaponSlotAmmo("smokegrenade", smokegrenadecount);

			return smokegrenadecount;
		}
	}
	return 0;
}

giveBinoculars()
{
	// if battle rank is on then call the battle rank function
	if ( isDefined(level.battlerank) && level.battlerank)
	{
		return maps\mp\gametypes\_rank_gmi::giveBinoculars(weapon);
	}

	if ( !level.allow_binoculars )
		return;
	
	binoctype = "binoculars_mp";
	
	self takeWeapon("binoculars_mp");
	self takeWeapon("binoculars_artillery_mp");
	
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
			binoctype = "binoculars_mp";
			break;

		case "british":
			binoctype = "binoculars_mp";
			break;

		case "russian":
			binoctype = "binoculars_mp";
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			binoctype = "binoculars_mp";
			break;
		}			
	}
	
	self setWeaponSlotWeapon("binocular", binoctype);
}

dropWeapons()
{
	self thread dropWeapon();
	self thread dropNade();
	self thread dropSmoke();
	self thread dropHealth();
}

dropWeapon()
{
	current = self getcurrentweapon();

	//iprintln(current);

	//if (current == "sprint_weap_mp")
		//return;

	if(current == "none")
		return;

	if (level.gametype == "re" && self.obj_carrier)
		return;

	// weapon1 = self getweaponslotweapon("primary");
	// weapon2 = self getweaponslotweapon("primaryb");

	// if(current == weapon1)
	// 	currentslot = "primary";
	// else if(current == weapon2)
	// {
	// 	currentslot = "primaryb";
	// }

	//clipsize = self getweaponslotclipammo(currentslot);
	//reservesize = self getweaponslotammo(currentslot);

	// Pistols are not defined in level.weapons - so check if this weapon exists
	if (isDefined(level.weapons[current]))
	{
		weapon_class = level.weapons[current].classname;

		if (getCvarInt(level.weaponclass[weapon_class].cvarAllowDrop) == 0)
			return;
	}
	else if (isPistol(current))
	{
		if (getCvarInt("scr_pistol_allow_drop") == 0)
			return;
	}

	self dropItem(current);
	level maps\mp\gametypes\_weapon_drop::handleWeaponDrop(current, self);
}

dropNade()
{
	if (!level.allow_nadedrops)
		return;


	grenades = self getFragGrenadeCount();

	if(grenades > 0)
	{
		/*
		- Droped grenade bug -
		If player has cooked grenade and is killed, that grenade will be throwed to ground.
		And because that grenade is not removed from players slot, extra grenade is dropped to ground for pickup

		To fix this bug, we will look for grenade entities in map close to player
		To detect it correctly, these rules must apply:
			- throwed grenade is always spawned with 40 offset from player origin in Z axis
			- that greande will blow in exacly 3.8 seconds

		Avoid greande drop if these rules applies!
		*/

		// Loop grenades in map
		grenades = getentarray("grenade","classname");
		for(i=0;i<grenades.size;i++)
		{
			if(isDefined(grenades[i].origin))
			{
				distanceZ = grenades[i].origin[2] - self.origin[2];
				// This grenade is close to player
				if (distanceZ > 39 && distanceZ < 41) // cooked grenade is always spawned with 40 offset in Z coordinate
				{
					//self iprintln("^1This was cooked grenade! " + distanceZ);

					// Remove this type of grenade from slot so this grenade is not dropped
					//currentGrenadeType = self getcurrentoffhand();
					currentGrenadeType = self getWeaponSlotWeapon("grenade");

					if (isDefined(currentGrenadeType) && currentGrenadeType != "")
					{
						//count = self getammocount(currentGrenadeType);
						count = self getWeaponSlotAmmo("grenade");

						if (count > 0)
						{
							//self setWeaponClipAmmo(currentGrenadeType, count - 1); // remove 1 grenade of this type
							self setWeaponSlotAmmo("grenade", count - 1);

							//countAfter = self getammocount(currentGrenadeType);

							//self iprintln("^3 Removed 1 grenade of type " + currentGrenadeType + " (before:" + count + " after:" + countAfter + ")");
						}
					}


					break;
				}
			}
		}

		if (self getWeaponSlotAmmo("grenade") > 0)
		{
			grenadeType = self getWeaponSlotWeapon("grenade");
			self dropItem(grenadeType);
			level maps\mp\gametypes\_weapon_drop::handleWeaponDrop(grenadeType, self);
		}
		
		/*
		// Drop every possible grenade
		if (self getammocount("frag_grenade_american_mp"))
		{
			self dropItem("frag_grenade_american_mp");
			wait 0.05; // wait before next "weapon_dropped" can be called
			level notify("weapon_dropped", "frag_grenade_american_mp", self);
		}
		if (self getammocount("frag_grenade_british_mp"))
		{
			self dropItem("frag_grenade_british_mp");
			wait 0.05; // wait before next "weapon_dropped" can be called
			level notify("weapon_dropped", "frag_grenade_british_mp", self);
		}
		if (self getammocount("frag_grenade_russian_mp"))
		{
			self dropItem("frag_grenade_russian_mp");
			wait 0.05; // wait before next "weapon_dropped" can be called
			level notify("weapon_dropped", "frag_grenade_russian_mp", self);
		}
		if (self getammocount("frag_grenade_german_mp"))
		{
			self dropItem("frag_grenade_german_mp");
			wait 0.05; // wait before next "weapon_dropped" can be called
			level notify("weapon_dropped", "frag_grenade_german_mp", self);
		}
		*/
	}
}

dropSmoke()
{
	if (!level.allow_smokedrops)
		return;

	grenadetype = self GetSmokeTypeName();

	if(grenadetype != "none")
	{
		if (self getWeaponSlotAmmo("smokegrenade") > 0)
		{
			grenadeType = self getWeaponSlotWeapon("smokegrenade");
			self dropItem(grenadeType);
			level maps\mp\gametypes\_weapon_drop::handleWeaponDrop(grenadeType, self);
		}
	}
}

dropHealth()
{
	if ( !getcvarint("scr_drophealth") )
		return;
		
	if(isDefined(level.healthqueue[level.healthqueuecurrent]))
		level.healthqueue[level.healthqueuecurrent] delete();
	
	level.healthqueue[level.healthqueuecurrent] = spawn("item_health", self.origin + (0, 0, 1));
	level.healthqueue[level.healthqueuecurrent].angles = (0, randomint(360), 0);

	level.healthqueuecurrent++;
	
	if(level.healthqueuecurrent >= 16)
		level.healthqueuecurrent = 0;
}

// Get number of greandes based on selected weapon
getWeaponBasedGrenadeCount(weapon)
{
	// if battle rank is on then call the battle rank function
	if ( isDefined(level.battlerank) && level.battlerank)
	{
		return maps\mp\gametypes\_rank_gmi::getWeaponBasedGrenadeCount(weapon);
	}

	className = level.weapons[weapon].classname;
	cvarNades = level.weaponclass[className].cvarNades;

	return getCvarInt(cvarNades);
}

getWeaponBasedSmokeGrenadeCount(weapon)
{
	// if battle rank is on then call the battle rank function
	if ( isDefined(level.battlerank) && level.battlerank)
	{
		return maps\mp\gametypes\_rank_gmi::getWeaponBasedSmokeGrenadeCount(weapon);
	}

	className = level.weapons[weapon].classname;
	cvarSmokes = level.weaponclass[className].cvarSmokes;

	return getCvarInt(cvarSmokes);
}

getFragGrenadeCount()
{
	// Because player can pickup nades also from enemy team, all grenade types are counted
	count = 0;
	count += self getWeaponSlotAmmo("grenade");
	/*
	count += self getammocount("frag_grenade_american_mp");
	count += self getammocount("frag_grenade_british_mp");
	count += self getammocount("frag_grenade_russian_mp");
	count += self getammocount("frag_grenade_german_mp");
	*/
	return count;
}


getSmokeGrenadeCount()
{
	// Because player can pickup nades also from enemy team, all grenade types are counted
	count = 0;
	count += self getWeaponSlotAmmo("smokegrenade");
	/*
	count += self getammocount("smoke_grenade_american_mp");
	count += self getammocount("smoke_grenade_british_mp");
	count += self getammocount("smoke_grenade_russian_mp");
	count += self getammocount("smoke_grenade_german_mp");
	*/
	return count;
}


isPistol(weapon)
{
	switch(weapon)
	{
	case "colt_mp":
	case "webley_mp":
	case "luger_mp":
	case "tt33_mp":
		return true;
	default:
		return false;
	}
}

isMainWeapon(weapon)
{
	// Include any main weapons that can be saved at the end of the round

	return isDefined(level.weapons[weapon]);
}

isSniper(weaponname)
{
	if (isMainWeapon(weaponname))
		return level.weapons[weaponname].classname == "sniper";
	return false;
}

/*
isShotgun(weaponname)
{
	if (isMainWeapon(weaponname))
		return level.weapons[weaponname].classname == "shotgun";
	return false;
}
*/

getRandomWeapon()
{
	for (;;)
	{
		weaponname = level.weaponnames[randomInt(level.weaponnames.size)];
		weapon = level.weapons[weaponname];

		if (weapon.allow == false)
			continue;

		if(!level.scr_rifle_mode && weapon.team != self.pers["team"])
			continue;

		// Check if random selected weapon is free and allowed
		if(!self maps\mp\gametypes\_weapon_limiter::isWeaponAvailable(weaponname))
			continue;

		return weaponname;
	}
}



getWeaponName(weapon)
{
	switch(weapon)
	{
	// American
	case "m1carbine_mp":
		weaponname = &"WEAPON_M1A1CARBINE";
		break;

	case "m1garand_mp":
		weaponname = &"WEAPON_M1GARAND";
		break;

	case "thompson_mp":
		weaponname = &"WEAPON_THOMPSON";
		break;

	case "bar_mp":
		weaponname = &"WEAPON_BAR";
		break;

	case "springfield_mp":
		weaponname = &"WEAPON_SPRINGFIELD";
		break;

	case "greasegun_mp":
		weaponname = &"WEAPON_GREASEGUN";
		break;

	case "shotgun_mp":
		weaponname = &"WEAPON_SHOTGUN";
		break;
		
	case "mg30cal_mp":
		weaponname = &"GMI_WEAPON_30CAL";
		break;

	// British
	case "enfield_mp":
		weaponname = &"WEAPON_LEEENFIELD";
		break;

	case "sten_mp":
		weaponname = &"WEAPON_STEN";
		break;

	case "bren_mp":
		weaponname = &"WEAPON_BREN";
		break;

	case "enfield_scope_mp":
		weaponname = &"WEAPON_SCOPEDLEEENFIELD";
		break;

	// Russian
	case "mosin_nagant_mp":
		weaponname = &"WEAPON_MOSINNAGANT";
		break;

	case "svt40_mp":
		weaponname = &"GMI_WEAPON_SVT40";
		break;

	case "PPS42_mp":
		weaponname = &"WEAPON_PPS42";
		break;

	case "ppsh_mp":
		weaponname = &"WEAPON_PPSH";
		break;

	// PPSH_CHANGE
	case "vpo135_mp":
		weaponname = "VPO-135";
		break;

	case "mosin_nagant_sniper_mp":
		weaponname = &"WEAPON_SCOPEDMOSINNAGANT";
		break;
		
	case "dp28_mp":
		weaponname = &"GMI_WEAPON_DP28";
		break;	

	//German
	case "kar98k_mp":
		weaponname = &"WEAPON_KAR98K";
		break;

	case "gewehr43_mp":
		weaponname = &"GMI_WEAPON_GEWEHR43";
		break;

	case "mp40_mp":
		weaponname = &"WEAPON_MP40";
		break;

	case "mp44_mp":
		weaponname = &"WEAPON_MP44";
		break;

	case "kar98k_sniper_mp":
		weaponname = &"WEAPON_SCOPEDKAR98K";
		break;
		
	case "mg34_mp":
		weaponname = &"GMI_WEAPON_MG34";
		break;	


	default:
		weaponname = &"WEAPON_UNKNOWNWEAPON";
		break;
	}

	return weaponname;
}


getWeaponName2(weapon)
{
	switch(weapon)
	{
	// American
	case "m1carbine_mp":
		weaponname = "M1A1 Carbine";
		break;

	case "m1garand_mp":
		weaponname = "M1 Garand";
		break;

	case "thompson_mp":
		weaponname = "Thompson";
		break;

	case "bar_mp":
		weaponname = "BAR";
		break;

	case "springfield_mp":
		weaponname = "Scope";
		break;

	case "greasegun_mp":
		weaponname = "Grease Gun";
		break;

	case "shotgun_mp":
		weaponname = "Shotgun";
		break;
		
	case "mg30cal_mp":
		weaponname = "M1919A6 .30 cal";
		break;	

	// British
	case "enfield_mp":
		weaponname = "Lee-Enfield";
		break;

	case "sten_mp":
		weaponname = "Sten";
		break;

	case "bren_mp":
		weaponname = "Bren LMG";
		break;

	case "enfield_scope_mp":
		weaponname = "Scope";
		break;

	// Russian
	case "mosin_nagant_mp":
		weaponname = "Mosin-Nagant";
		break;

	case "svt40_mp":
		weaponname = "SVT40";
		break;

	case "PPS42_mp":
		weaponname = "PPS42";
		break;

	case "ppsh_mp":
		weaponname = "PPSh";
		break;

	// PPSH_CHANGE
	case "vpo135_mp":
		weaponname = "VPO-135";
		break;

	case "mosin_nagant_sniper_mp":
		weaponname = "Scope";
		break;
		
	case "dp28_mp":
		weaponname = "DP28";
		break;			

	//German
	case "kar98k_mp":
		weaponname = "Kar98k";
		break;

	case "gewehr43_mp":
		weaponname = "Gewehr 43";
		break;

	case "mp40_mp":
		weaponname = "MP40";
		break;

	case "mp44_mp":
		weaponname = "MP44";
		break;

	case "kar98k_sniper_mp":
		weaponname = "Scope";
		break;
		
	case "mg34_mp":
		weaponname = "MG34";
		break;	

	// Pistols
	case "colt_mp":
	case "webley_mp":
	case "luger_mp":
	case "TT30_mp":
		weaponname = "Pistol";
		break;

	default:
		weaponname = weapon;
		break;
	}

	return weaponname;
}

useAn(weapon)
{
	switch(weapon)
	{
	case "m1carbine_mp":
	case "m1garand_mp":
	case "mp40_mp":
	case "mp44_mp":
	case "shotgun_mp":
		result = true;
		break;

	default:
		result = false;
		break;
	}

	return result;
}

// Get called from cvars.gsc if some cvar of scr_allow_<weaponname> changed
updateAllowed(cvarName, cvarValue)
{
	for(i = 0; i < level.weaponnames.size; i++)
	{
		weaponname = level.weaponnames[i];

		// Find weapon struct by server cvar name
		if (cvarName == level.weapons[weaponname].server_allowcvar)
		{
			team = level.weapons[weaponname].team;
			classname = level.weapons[weaponname].classname;

			level.weapons[weaponname].allow = cvarValue;

			// Disable or enable weapon to all clients
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				players[i] maps\mp\gametypes\global\_global::setClientCvar2(level.weapons[weaponname].client_allowcvar, cvarvalue);
			}

			break;
		}
	}
}

updateLimit(cvarName, cvarValue)
{
	for(i = 0; i < level.weaponclasses.size; i++)
	{
		weaponclass = level.weaponclasses[i];

		// Find weapon struct by server cvar name
		if (cvarName == level.weaponclass[weaponclass].cvar)
		{
			level.weaponclass[weaponclass].limit = cvarValue;

			break;
		}
	}
}

updateDrop(cvarName, cvarValue)
{
	for(i = 0; i < level.weaponclasses.size; i++)
	{
		weaponclass = level.weaponclasses[i];

		// Find weapon struct by server cvar name
		if (cvarName == level.weaponclass[weaponclass].cvarAllowDrop)
		{
			level.weaponclass[weaponclass].allow_drop = cvarValue;

			break;
		}
	}
}


keepMaxAmmo()
{
	self endon("disconnect");
	self endon("keepMaxAmmo_end");

	last_weapon1 = "";
	last_weapon2 = "";

	last_weapon1_clipAmmo = 0;
	last_weapon2_clipAmmo = 0;

	weapon1_maxClipAmmo = 1;
	weapon2_maxClipAmmo = 1;

	weapon1_pauseGivingMaxAmmo = 0;
	weapon2_pauseGivingMaxAmmo = 0;

	for (;;)
	{
		wait level.frame;


		if (weapon1_pauseGivingMaxAmmo > 0) weapon1_pauseGivingMaxAmmo--;
		if (weapon2_pauseGivingMaxAmmo > 0) weapon2_pauseGivingMaxAmmo--;


		if((self.pers["team"] != "allies" && self.pers["team"] != "axis") || self.sessionstate != "playing")
		{
			last_weapon1 = "";
			last_weapon2 = "";
			weapon1_maxClipAmmo = 1;
			weapon2_maxClipAmmo = 1;
			continue;
		}

		weapon1 = self getweaponslotweapon("primary");
		weapon2 = self getweaponslotweapon("primaryb");

		weapon1_clipAmmo = self getweaponslotclipammo("primary");
		weapon2_clipAmmo = self getweaponslotclipammo("primaryb");


		// If weapons changed in slots, save the maximum ammo in slot
		if (weapon1 != last_weapon1)
		{
			weapon1_maxClipAmmo = weapon1_clipAmmo;
			//self iprintln("Primary changed " + weapon1_maxClipAmmo);

			last_weapon1_clipAmmo = weapon1_clipAmmo;
		}
		if (weapon2 != last_weapon2)
		{
			weapon2_maxClipAmmo = weapon2_clipAmmo;
			//self iprintln("Secondary changed " + weapon2_maxClipAmmo);

			last_weapon2_clipAmmo = weapon2_clipAmmo;
		}

		last_weapon1 = weapon1;
		last_weapon2 = weapon2;

		// Weapon fired - for 1 seconds give -1 less ammo to allow reload
		if (weapon1_clipAmmo < last_weapon1_clipAmmo)
			weapon1_pauseGivingMaxAmmo = (int)(level.sv_fps / 1); // how many frames to wait
		if (weapon2_clipAmmo < last_weapon2_clipAmmo)
			weapon2_pauseGivingMaxAmmo = (int)(level.sv_fps / 1); // how many frames to wait

		last_weapon1_clipAmmo = weapon1_clipAmmo;
		last_weapon2_clipAmmo = weapon2_clipAmmo;


		current = self getcurrentweapon();

		// For example player is on ladder
		if(current == "none")
			continue;

		// Imidietly after firing give player -1 less ammo to allow reloading animation
		new_weapon1_clipAmmo = weapon1_maxClipAmmo;
		if (weapon1_pauseGivingMaxAmmo != 0 && new_weapon1_clipAmmo > 0)
			new_weapon1_clipAmmo--;
		new_weapon2_clipAmmo = weapon2_maxClipAmmo;
		if (weapon2_pauseGivingMaxAmmo != 0 && new_weapon2_clipAmmo > 0)
			new_weapon2_clipAmmo--;

		// Give ammo
		// Primary
		if(current == weapon1)
			self setweaponslotclipammo("primary", new_weapon1_clipAmmo);
			//self setweaponclipammo(current, new_weapon1_clipAmmo);
		// Secondary
		else if (current == weapon2)
			self setweaponslotclipammo("primaryb", new_weapon1_clipAmmo);
			//self setweaponclipammo(current, new_weapon2_clipAmmo);
	}
}

keepMaxAmmoStop()
{
	self notify("keepMaxAmmo_end");
}

// ----------------------------------------------------------------------------------
//	GetGunAmmo
//
// 		returns the ammo count that the player will get for the weapon
// ----------------------------------------------------------------------------------
GetGunAmmo(weapon)
{	
	switch(weapon)
	{
		//American Weapons
		case "m1carbine_mp":
			return 60;
		case "m1garand_mp":
			return 56;
		case "springfield_mp": 
			return 25;
		case "thompson_mp": 
		case "thompson_semi_mp": 
			return 120;
		case "bar_mp": 
		case "bar_slow_mp": 
			return 80;
		case "mg30cal_mp":
			return 225;
		//British Weapons
		case "enfield_mp":
			return 60;
		case "sten_mp": 
		case "sten_silenced_mp":
			return 128;
		case "bren_mp": 
			return 90;
		//Russian Weapons
		case "mosin_nagant_mp":
			return 60;
		case "svt40_mp":
			return 60;
		case "mosin_nagant_sniper_mp":
			return 25;
		case "ppsh_mp":
		case "ppsh_semi_mp":
			return 142;
		case "dp28_mp":
			return 225;
		//German Weapons
		case "kar98k_mp": 
			return 60;
		case "gewehr43_mp":
			return 60;
		case "kar98k_sniper_mp":
			return 25;
		case "mp40_mp":
			return 128;
		case "mp44_mp":
		case "mp44_semi_mp":
			return 90;
		case "mg34_mp":
			return 225;
			return 90;
		// unrecognized weapon
		default:
		   	return 0;
		}
		
	return 0;
}

// ----------------------------------------------------------------------------------
//	GetPistolAmmo
//
// 		returns the ammo count that the player will get for the weapon
// ----------------------------------------------------------------------------------
GetPistolAmmo(weapon)
{
	switch(weapon)
	{
		case "luger_mp":
			return 32;
		case "colt_mp":
			return 28;
		case "webley_mp":
			return 24;
		case "tt33_mp":
			return 28;
		default:
			return 0;
	}
}