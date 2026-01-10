/**	REISSUE Project Ares Mod version 1.15
 * 
 * 	Original map & script by ** IW **
 * 	Edits by reissue_
 * 
 * 	********* PLAY HARD, GO PRO **********
*/

main()
{
	precacheFX();
	spawnWorldFX();
}

precacheFX()
{
 	level._effect["chimney"] = loadfx ("fx/smoke/chimneysmoke.efx");

}

spawnWorldFX()
{
	maps\mp\_fx::loopfx("chimney", (1984, -210, 512), 0.2);
}