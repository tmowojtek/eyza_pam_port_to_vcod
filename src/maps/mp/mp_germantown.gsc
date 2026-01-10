/*
	v1.15 rPAM & Origin of Honor Mod

	original map & script by Steiner
	edits by reissue_


 	********* PLAY HARD, GO PRO **********
*/

main()
{
////	setCullFog (0, 16500, 0.7, 0.85, 1.0, 0);	// disabled here for rpam
//	ambientPlay("ambient_mp_brecourt");		// disabled here for rpam

	maps\mp\_rpam_maps_mp::main();		// start this to rpam settings


	maps\mp\_load::main();
//	maps\mp\mp_germantown_fx::main();		// precaches the bomb explosion


	game["allies"] = "american";
	game["axis"] = "german";

	game["american_soldiertype"] = "airborne";
	game["american_soldiervariation"] = "normal";
	game["german_soldiertype"] = "waffen";
	game["german_soldiervariation"] = "normal";

	game["attackers"] = "allies";
	game["defenders"] = "axis";

	game["layoutimage"] = "mp_germantown";
}
