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
}

precacheFX()
{
	level._effect["v2rocketexplosion"]	= loadfx("fx/explosions/explosion1_nolight.efx");
	level._effect["fueltank"]		= loadfx("fx/explosions/fueltank_ned.efx");
}
