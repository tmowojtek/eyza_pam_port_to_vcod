/*

  rPAMext Version: v14 (kvcodPAM v2.9)      
  
  Changes:     

  - Used zPAM eyza-cod2 version as reference 400test3           
    - added #include command deactivated
    - deactivated *pbForcedCvarsLoaded* completely, as cod2 isn't it using anymore and
    it is not working like punkbuster does (v11, COMP starts)
    - *sets Server cvar*: rpam_competitive = 1 

  - rCLIENTSETUP: here the given cvars will apply on round-start or map restart     
    - *sets Client cvar*:    
    snaps = 40; rate = 25000; cl_maxpackets = 100;    
    cl_avidemo = 0; cl_forceavidemo = 0; cl_freelook = 1;    
    r_lodbias = 0; r_lodCurveError = 250; r_lodscale = 0;    
    cg_errordecay = 100; cg_viewsize = 100;      
    cg_crosshairAlpha = 1; cg_crosshairAlphaMin = 0.7; cg_drawCompass = 1;    
    cg_hudStanceHintPrints = 0; cg_weaponCycleDelay = 0;    
    r_drawSun = 0; r_fastsky = 0; *r_fog = 1* *(for rPAM Maps Overhaul)*   
    - *sets Server cvar*:    
    rate = 25000; sv_maxRate25000 = 25000; sv_pure = 1      

*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	#include maps\mp\gametypes\global\_global;
//
init()
{
//log
	logprint("_cvar_forces::init\n");
	
//addEventListener
	maps\mp\gametypes\global\_global::addEventListener("onConnected",         ::onConnected);

	setCvar("rate", "25000");
	setCvar("sv_maxRate", "25000");
	setCvar("sv_pure", "1");

//rPAM competitive settings YES
    setCvar("rpam_competitive", "1");
}

onConnected()
{
	logprint("_cvar_forces::onConnected start\n");

//v11 disabled
//pbForcedCvarsLoaded = false
//    if (!isDefined(self.pers["pbForcedCvarsLoaded"]))
//        self.pers["pbForcedCvarsLoaded"] = false;
//was alread disabled
    // Set cvars that are forced by PunkBuster do correct value to prevent PUNKBUSTER WARNINGS
    //if (!self.pers["pbForcedCvarsLoaded"])
        //self thread setForcedCvarsByPB();
//COMP
    // Set some cvars to value that increase competitive quality
    self thread competitiveQuality();
	logprint("_cvar_forces::onConnected end\n");
}


competitiveQuality()
{
// Endon
	self endon("disconnect");

// Wait till player join team to save sent cvars to client
	while (!isDefined(self.pers["firstTeamSelected"]))
		wait level.frame;
// Wait
	wait level.fps_multiplier * 0.1;

// Wait more if player joined spectator (usefull especially for streamers - lot of cvars is beeing sent)
	if (self.sessionstate == "spectator")
		wait level.fps_multiplier * 8;

// rCLIENTSETUP

	self setClientCvar("snaps", "40");
	self setClientCvar("rate", "25000");
	self setClientCvar("cl_maxpackets", "100");
//	self setClientCvar("cl_packetdup", "1");

	self setClientCvar("cl_avidemo", "0");
	self setClientCvar("cl_forceavidemo", "0");
	self setClientCvar("cl_freelook", "1");

	wait level.fps_multiplier * 0.2;

// Modeldetails, later we need to try to add negative values and forcing them for all 
	self setClientCvar("r_lodbias", "0");
	self setClientCvar("r_lodCurveError", "250");
	self setClientCvar("r_lodscale", "0");

	self setClientCvar("cg_errordecay", "100");
	self setClientCvar("cg_viewsize", "100");
	
	wait level.fps_multiplier * 0.2;
	
// Hud
	self setClientCvar("cg_crosshairAlpha", "1");
	self setClientCvar("cg_crosshairAlphaMin", "0.7");
	self setClientCvar("cg_drawCompass", "1");
	self setClientCvar("cg_hudStanceHintPrints", "0");

// Weapon change with 0 ms delay
	self setClientCvar("cg_weaponCycleDelay", "0");

	wait level.fps_multiplier * 0.2;

// Disable sun
	self setClientCvar("r_drawSun", "0");

// Disable sky
	self setClientCvar("r_fastsky", "0");

// Fog will be set rPAM Maps overhaul v2.25
	self setClientCvar("r_fog", "1");
//	self setClientCvar("r_fog", level.r_fog);

	wait level.fps_multiplier * 0.2;
	
// Log
	logprint("_cvar_forces::competitiveQuality - applied for " + self.name + "\n");
}

setForcedCvarsByPB()
{
	self endon("disconnect");

	// Wait till player join team to save sent cvars to client
	while (!isDefined(self.pers["firstTeamSelected"]))
		wait level.frame;

	wait level.fps_multiplier * 0.2;

	// Wait more if player joined spectator (usefull especially for streamers - lot of cvars is beeing sent)
	if (self.sessionstate == "spectator")
		wait level.fps_multiplier * 8;

	/*
	self setClientCvar2("snaps", 30);
	self setClientCvar2("sc_enable", "0");
	self setClientCvar2("fx_sort", "1");
	self setClientCvar2("rate", "25000");
	self setClientCvar2("cl_maxpackets", "100");
	*/

	wait level.fps_multiplier * 0.2;

	/*
	self setClientCvar2("cg_viewsize", "100");
	self setClientCvar2("cl_avidemo", "0");
	self setClientCvar2("cl_forceavidemo", "0");
	self setClientCvar2("cl_freelook", "1");
	self setClientCvar2("cl_pitchspeed", "140");
	self setClientCvar2("cl_yawspeed", "140");

	wait level.fps_multiplier * 0.2;

	self setClientCvar2("fixedtime", "0");
	self setClientCvar2("friction", "5.5");
	self setClientCvar2("mss_q3fs", "1");
	self setClientCvar2("cg_errordecay", "100");
	self setClientCvar2("cg_hintFadeTime", "100");

	wait level.fps_multiplier * 0.2;

	self setClientCvar2("cg_hudCompassMaxRange", "1500");
	self setClientCvar2("cg_hudCompassMinRadius", "0");
	self setClientCvar2("cg_hudCompassMinRange", "0");
	self setClientCvar2("cg_hudCompassSpringyPointers", "0");
	self setClientCvar2("cg_hudCompassSoundPingFadeTime", "2");

	wait level.fps_multiplier * 0.2;

	self setClientCvar2("cg_hudDamageIconHeight", "64");
	self setClientCvar2("cg_hudDamageIconOffset", "128");
	self setClientCvar2("cg_hudDamageIconTime", "2000");
	self setClientCvar2("cg_hudDamageIconWidth", "128");

	wait level.fps_multiplier * 0.2;

	self setClientCvar2("cg_hudGrenadeIconHeight", "25");
	self setClientCvar2("cg_hudGrenadeIconOffset", "50");
	self setClientCvar2("cg_hudGrenadeIconWidth", "25");
	self setClientCvar2("cg_hudGrenadePointerHeight", "12");

	wait level.fps_multiplier * 0.2;

	self setClientCvar2("cg_hudGrenadePointerPivot", "12 27");
	self setClientCvar2("cg_hudGrenadePointerWidth", "25");
	self setClientCvar2("cg_hudObjectiveMaxRange", "2048");
	self setClientCvar2("cg_hudObjectiveMinAlpha", "1");
	self setClientCvar2("cg_hudObjectiveMinHeight", "-70");
	*/

	self.pers["pbForcedCvarsLoaded"] = true;

}
