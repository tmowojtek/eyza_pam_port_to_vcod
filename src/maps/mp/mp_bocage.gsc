/**	REISSUE Project Ares Mod version 1.15
 * 
 * 	Original map & script by ** IW **
 * 	Edits by reissue_
 * 
 * 	********* PLAY HARD, GO PRO **********
*/

main()
{
//	r = 150;
//	g = 159;
//	b = 169;
//	r = 162;
//	g = 159;
//	b = 145;
/*	r = 135;
	g = 130;
	b = 111;

	setExpFog(0.0001, (float)r/(float)255,(float)g/(float)255,(float)b/(float)255, 0);
//	ambientPlay("ambient_mp_brecourt");
*/
	maps\mp\_rpam_maps_mp::main();		// start this for ambient sound / fog / improvements


	maps\mp\_load::main();
//	maps\mp\mp_bocage_fx::main();		// bocage smoke plume


	game["allies"] = "american";
	game["axis"] = "german";

	game["american_soldiertype"] = "airborne";
	game["american_soldiervariation"] = "normal";
	game["german_soldiertype"] = "waffen";
	game["german_soldiervariation"] = "normal";

	game["attackers"] = "allies";
	game["defenders"] = "axis";
	
	game["layoutimage"] = "mp_bocage";


	//retrival settings
	level.obj["beacon"] = (&"PATCH_1_3_BEACON");
	precacheString(&"PATCH_1_3_BEACON");
	game["re_attackers"] = "axis";
	game["re_defenders"] = "allies";
	game["re_attackers_obj_text"] = (&"PATCH_1_3_BOCAGE_OBJ_ATTACKER");
	game["re_defenders_obj_text"] = (&"PATCH_1_3_BOCAGE_OBJ_DEFENDER");
	game["re_spectator_obj_text"] = (&"PATCH_1_3_BOCAGE_OBJ_SPECTATOR");


	//hq settings
	if (getcvar("g_gametype") != "hq")
	{
		radios = getentarray ("hqradio","targetname");
		for (i=0;i<radios.size;i++)
			radios[i] hide();
	}
}
