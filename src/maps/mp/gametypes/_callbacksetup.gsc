// changed # to *
//
//	Callback Setup
//	This script provides the hooks from code into script for the gametype callback functions.

/*
	Order of loading scripts:

		1. Init game cvars:
			\fs_game\PAM2016\g_antilag\1\g_gametype\sd\gamename\Call of Duty 2\mapname\mp_toujane\protocol\118\shortversion\1.3\sv_allowAnonymous\0\sv_floodProtect\1\sv_hostname\CoD2Host\sv_maxclients\20\sv_maxPing\0\sv_maxRate\0\sv_minPing\0\sv_privateClients\0\sv_punkbuster\0\sv_pure\1\sv_voice\0

		2. Call gametype:
			maps/mp/gametypes/<gametype>.gsc :: main()

		3. Call map:
			maps/mp/<map>.gsc :: main()

		4. Call callbacks: (called by game engine)
			CodeCallback_StartGameType,
			CodeCallback_PlayerConnect,
			CodeCallback_PlayerDisconnect,
			CodeCallback_PlayerDamage,
			CodeCallback_PlayerKilled

		...

	Order of loading scripts when map_restart is called:

		1. Init game cvars:
			\fs_game\PAM2016\g_antilag\1\g_gametype\sd\gamename\Call of Duty 2\mapname\mp_toujane\protocol\118\shortversion\1.3\sv_allowAnonymous\0\sv_floodProtect\1\sv_hostname\CoD2Host\sv_maxclients\20\sv_maxPing\0\sv_maxRate\0\sv_minPing\0\sv_privateClients\0\sv_punkbuster\0\sv_pure\1\sv_voice\0

		2. Call gametype:
			maps/mp/gametypes/<gametype>.gsc :: main()

		3. Call map:
			maps/mp/<map>.gsc :: main()

		4. (frame 0) CodeCallback_StartGameType
		5. (frame 2) CodeCallback_PlayerConnect

		6. CodeCallback_PlayerDamage
		7. CodeCallback_PlayerKilled
		8. CodeCallback_PlayerDisconnect


	Example of loading:
		------- Game Initialization -------
		gamename: Call of Duty 2
		gamedate: May  1 2006
		-----------------------------------
		Call: sd.gsc::main()
		Call: mp_toujane.gsc::main()
		Call: sd.gsc::StartGametype
		-----------------------------------
		Call: sd.gsc::PlayerConnect


	Menu loading order:
		1. ui_mp/menus.txt	- loads classic menus for Join Game, Start New Server, Options, ..
		2. ui_mp/ingame.txt   	- menus in this file are loaded when map is loaded
		3. ui_mp/hud.txt	- loads hud.menu if map is loaded
		4. ui_mp/scriptmenus  	- thease menus are loaded individually by script

*/


Init()
{
	logprint("_callbacksetup::init\n");
	// /*
	// thread frame_counter();
	// println("##### " + gettime() + " " + level.frame_num + " ##### Call: maps/mp/gametypes/" + getcvar("g_gametype") + ".gsc::main()");
	// */

	SetupCallbacks();
}

frame_counter()
{
	level.frame_num = 0;
	for(;;)
	{
		wait 0.000000001;
		wait 0.05;wait 0.05;wait 0.05;wait 0.05;wait 0.05;wait 0.05;wait 0.05;wait 0.05;
		wait 0.05;wait 0.05;wait 0.05;wait 0.05;wait 0.05;wait 0.05;wait 0.05;wait 0.05;
		level.frame_num++;
	}
}

//=============================================================================
// Code Callback functions

/*================
Called by code after the level's main script function has run.
================*/
CodeCallback_StartGameType()
{
	/*
	println("##### " + gettime() + " " + level.frame_num + " ##### Call: maps/mp/gametypes/_callback.gsc::CodeCallback_StartGameType()");
	*/

	logprint("##### " + gettime() + " ##### Call: maps/mp/gametypes/_callback.gsc::CodeCallback_StartGameType()\n");

	// If the gametype has not beed started, run the startup
	if(!isDefined(level.gametypestarted) || !level.gametypestarted)
	{
		// Process onStartGameType events
		for (i = 0; i < level.events.onStartGameType.size; i++)
		{
			self thread [[level.events.onStartGameType[i]]]();
		}

		level.gametypestarted = true; // so we know that the gametype has been started up
	}
}



/*================
Called when a player begins connecting to the server.
Called again for every map change or tournement restart.

Return undefined if the client should be allowed, otherwise return
a string with the reason for denial.

Otherwise, the client will be sent the current gamestate
and will eventually get to ClientBegin.

firstTime will be qtrue the very first time a client connects
to the server machine, but qfalse on map changes and tournement
restarts.

Default values of self (defined in game engine)
self.psoffsettime 		= 0
self.archivetime 		= 0
self.spectatorclient 	= -1
self.headiconteam 		= none
self.headicon 			= ""
self.statusicon 		= ""; // examp: hud_status_connecting
self.score				= 0; // score kills
self.deaths 			= 0; // score deaths
self.maxhealth 			= 0;
self.sessionstate 		= "spectator"; // [playing, dead, spectator, intermission]
self.sessionteam 		= "spectator"; // [allies, axis, spectator, none] (real team assigment)
================*/
CodeCallback_PlayerConnect()
{
	self endon("disconnect");

	// /*
	//if (isDefined(self.alreadyConnected))
	//	assertMsg("Duplicated connection for " + self.name);
	//self.alreadyConnected = true;
	// println("##### " + gettime() + " " + level.frame_num + " ##### Connecting: " + self.name);
	// */

	self.sessionteam = "none"; // show player in "none" team in scoreboard while connecting

	self thread maps\mp\gametypes\global\events::notifyConnecting();

	// Wait here until player is fully connected
	self waittill("begin");

	/*
	println("##### " + gettime() + " " + level.frame_num + " ##### Connected: " + self.name);
	*/

	//self thread emptyName();

	self thread maps\mp\gametypes\global\events::notifyConnected();

	// If pam is not installed correctly, spawn outside
	if (level.pam_installation_error)
		[[level.spawnSpectator]]((999999, 999999, -999999), (90, 0, 0)); // Spawn spectator outside map
	// Mod is not downloaded
	else if (self maps\mp\gametypes\_force_download::modIsNotDownloadedForSure())
		self maps\mp\gametypes\_force_download::spawnModNotDownloaded();
	else
	{
		[[level.onAfterConnected]]();
	}

}


// emptyName()
// {
// 	self endon("disconnect");

// 	self.name_old = "";
// 	id = self getEntityNumber();

// 	wait level.frame * id;

// 	for(;;)
// 	{
// 		wait level.fps_multiplier * 1;

// 		// Wait untill the name is changed
// 		if (self.name == self.name_old)
// 			continue;

// 		// Empty name detection
// 		name = maps\mp\gametypes\global\string::removeColorsFromString(self.name);
// 		while (name.size > 0 && name[0] == " ") // Remove leading spaces
// 			name = maps\mp\gametypes\global\_global::getsubstr(name, 1); // start from second character
// 		if (name == "")
// 		{
// 			if (isDefined(self.pers["name_empty_warned"]))
// 			{
// 				iprintln("Player ID " + id + " kicked due to using empty name!");
// 				iprintln("HA HA HA, not happening for player ID " + id + " because vCoD builtin functions are poor!!");
// 				//kick(id);
// 			}
// 			else
// 			{
// 				self.pers["name_empty_warned"] = true;
// 				self iprintlnbold("^1Using empty name would lead to kick!");
// 			}
// 			self setClientCvar("name", "Unnamed player_id_" + id);
// 			wait level.fps_multiplier * 3; // wait untill the name is trully renamed
// 		}

// 		self.name_old = self.name;
// 	}
// }


/*================
Called when a player drops from the server.
Will not be called between levels.
self is the player that is disconnecting.
================*/
CodeCallback_PlayerDisconnect()
{
	self notify("disconnect");

	/*
	println("##### " + gettime() + " " + level.frame_num + " ##### Disconnected: " + self.name);
	*/
	
	self thread maps\mp\gametypes\global\events::notifyDisconnect();
}



/*================
Called when a player has taken damage.
self is the player that took damage.
Return undefined to prevent damage

sMeansOfDeath
	MOD_PISTOL_BULLET = pistol / shotgun / thompson
	MOD_RIFLE_BULLET
	MOD_MELEE = bash
	MOD_GRENADE_SPLASH = grenade
	MOD_SUICIDE = killed by script (used only in PlayerKilled callback, not damage)

sHitLoc
	head
	neck
	torso_upper
	torso_lower
	left_arm_upper
	left_arm_lower
	left_hand
	right_arm_upper
	right_arm_lower
	right_hand
	left_leg_upper
	left_leg_lower
	left_foot
	right_leg_upper
	right_leg_lower
	right_foot

client:client_2  health:100 damage:90 hitLoc:torso_lower iDFlags:32 sMeansOfDeath: MOD_RIFLE_BULLET sWeapon: m1garand_mp vPoint: (-61.1327, 1090.97, 25.2369) vDir: (0.651344, -0.728131, -0.213485) timeOffset: 0
client:client_2  health:55 damage:45 hitLoc:torso_lower iDFlags:0 sMeansOfDeath: MOD_PISTOL_BULLET sWeapon: webley_mp vPoint: (-189.78, 1102.76, 39.3595) vDir: (0.140321, -0.958474, -0.248269) timeOffset: 0

================*/
CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	self endon("disconnect");

	// Resets the infinite loop check timer, to prevent an incorrect infinite loop error when a lot of script must be run
	resettimeout();

	// Do debug print if it's enabled
	if(level.g_debugDamage)
	{
		if (isDefined(eAttacker) && isPlayer(eAttacker))
		{
			dist = (int)(distance(self getOrigin(), eAttacker getOrigin()));
			eAttacker iprintln("You inflicted " + iDamage + " damage to " + self.name + " (" + sHitLoc + ", "+ sMeansOfDeath +", distance "+dist+")");
			self iprintln("You recieved " + iDamage + " damage from " + eAttacker.name + " (" + sHitLoc + ", "+ sMeansOfDeath +", distance "+dist+")");
		}
		else
			self iprintln("You recieved " + iDamage + " damage (" + sHitLoc + ", "+ sMeansOfDeath +")");
	}

	// /*
	// dist = -1; if (isDefined(eAttacker) && isPlayer(eAttacker)) dist = (int)(distance(self getOrigin(), eAttacker getOrigin()));
	// strAttacker = "undefined"; if (isDefined(eAttacker)) if (isPlayer(eAttacker)) strAttacker = "#" + (eAttacker getEntityNumber()) + " " + eAttacker.name; else strAttacker = "-entity-";
	// sPoint = "undefined";	if (isDefined(vPoint)) sPoint = vPoint;

	// println("##### " + gettime() + " " + level.frame_num + " ##### PlayerDamage: " + strAttacker + " -> #" + self getEntityNumber() + " " + self.name + " health:" + self.health + " damage:" + iDamage + " hitLoc:" + sHitLoc + " iDFlags:" + iDFlags +
	// " sMeansOfDeath:" + sMeansOfDeath + " sWeapon:" + sWeapon + " vPoint:" + sPoint + " distance:" + dist);
	// */


	// Protection - players in spectator inflict damage
	if(isDefined(eAttacker) && isPlayer(eAttacker) && eAttacker.sessionteam == "spectator")
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isdefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
	
	// Ignore grenade hit to dead player (happends when player is hitted by multiple players)
	if (sMeansOfDeath == "MOD_GRENADE_SPLASH" && !isAlive(self))
		return;

	damageFeedback = 1;


	// Save info about hits
	self_num = self getEntityNumber();
	if (isDefined(eAttacker) && isPlayer(eAttacker))
	{
		// Id of shot in this frame for attacker (to count double kills for example)
		if (!isDefined(eAttacker.hitId))
			eAttacker.hitId = 0;			// inited to 0, but will be incremented. 1 then means first bullet
		eAttacker.hitId++;

		// Create variable to hold hit data
		if (!isDefined(eAttacker.hitData))
			eAttacker.hitData = [];
		// Because we can hit multiple players in same time (multikill), we need to save it according to players
		if (!isDefined(eAttacker.hitData[self_num]))
		{
			eAttacker.hitData[self_num] = spawnstruct();
			eAttacker.hitData[self_num].id = 0;			// inited to 0, but will be incremented. 1 then means first bullet to specific player
			eAttacker.hitData[self_num].adjustedBy = "";		// string telling if hit was adjusted by FIXes
			eAttacker.hitData[self_num].damage = 0;
			eAttacker.hitData[self_num].damage_comulated = 0;
			eAttacker.hitData[self_num].shotgun_distance = 0;
		}
		eAttacker.hitData[self_num].id++;

		self thread hitDataAutoRestart(eAttacker, self_num);
		eAttacker thread hitIdAutoRestart();
	}



	// 1 = print debug messages to player with name eyza
	eyza_debug = 0;


	// Save affected damage value
	if (isDefined(eAttacker) && isPlayer(eAttacker))
		eAttacker.hitData[self_num].damage = iDamage;


	//println("##################### " + "notifyDamaging");
	// Call onDamage event and return if damage was prevented
	ret = maps\mp\gametypes\global\events::notifyDamaging(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
	if (ret) return;


	// Save affected damage value
	if (isDefined(eAttacker) && isPlayer(eAttacker) && isDefined(eAttacker.hitData) && isDefined(eAttacker.hitData[self_num]) && isDefined(eAttacker.hitData[self_num].damage_comulated))
		eAttacker.hitData[self_num].damage_comulated += iDamage;


	//println("##################### " + "notifyDamage");
	// Call onPlayerDamaged event
	maps\mp\gametypes\global\events::notifyDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);

	// Call gametype specific event that is called as last
	[[level.onAfterPlayerDamaged]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);

	// Damage feedback
	//if (damageFeedback >= 1)
	//{
		//eAttacker iprintln("^6DMG feedback" + i);
		//if(isPlayer(eAttacker) && eAttacker != self && !(iDFlags & level.iDFLAGS_NO_PROTECTION))
			//eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback(self, damageFeedback);
	//}
}

hitDataAutoRestart(eAttacker, self_num)
{
	//self endon("disconnect");
	eAttacker endon("disconnect");

	self notify("hitDataAutoRestart_end");
	self endon("hitDataAutoRestart_end");

	// Reset data related to a single frame only
	wait 0.05;
	wait 0.05;
	wait 0.05;
	wait 0.05;

	eAttacker.hitData[self_num].id = 0;
	eAttacker.hitData[self_num].damage = 0;
	eAttacker.hitData[self_num].adjustedBy = "";
	eAttacker.hitData[self_num].shotgun_distance = 0;

	// Wait 5 sec if player is still alive
	for(i = 0; i < 5; i++)
	{
		if (!isDefined(self) || !isAlive(self))
			break;

		wait level.fps_multiplier * 1;
	}

	// Remove the rest of the data
	eAttacker.hitData[self_num] = undefined;
}

hitIdAutoRestart()
{
	wait 0.05;
	self.hitId = undefined;
}

damageScale(dist, distStart, distEnd, hpStart, hpEnd)
{
	return (int)(hpStart - ((dist - distStart) / (distEnd - distStart)) * (hpStart - hpEnd));
}


printToEyza(text)
{
	println(text);

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if (players[i].name == "eyza")
		{
			players[i] iprintln(text);
		}
	}
}




/*================
Called when a player has been killed.
self is the player that was killed.


This function is called if:
	finishPlayerDamage is called and that damage applied leads to <= 0 health
	RadiusDamage is called and that damage applied leads to <= 0 health
	suicide is called
	player kills himself via /kill

After this function is executed, weapons are removed (getcurrentweapon will return none when the current frame ends)


/kill
#Kill 880548 #0 client_1  -> #0 client_1  health:0 damage:100000 hitLoc:none sMeansOfDeath:MOD_SUICIDE sWeapon:none sessionstate:playing timeOffset:0

suicide()
#Kill 911898 #0 client_1  -> #0 client_1  health:0 damage:100000 hitLoc:none sMeansOfDeath:MOD_SUICIDE sWeapon:none sessionstate:playing timeOffset:0


================*/
CodeCallback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("disconnect");

	// Resets the infinite loop check timer, to prevent an incorrect infinite loop error when a lot of script must be run
	resettimeout();

	/*
	strAttacker = "undefined"; if (isDefined(eAttacker)) if (isPlayer(eAttacker)) strAttacker = "#" + (eAttacker getEntityNumber()) + " " + eAttacker.name; else strAttacker = "-entity-";
	println("##### " + gettime() + " " + level.frame_num + " ##### PlayerKilled: " + strAttacker + " -> #" + self getEntityNumber() + " " + self.name + " health:" + self.health + " damage:" + iDamage + " hitLoc:" + sHitLoc +
	" sMeansOfDeath:" + sMeansOfDeath + " sWeapon:" + sWeapon + " sessionstate:" + self.sessionstate + " timeOffset:" + timeOffset);
	*/

	// Player in spectator cannot be killed
	if(self.sessionteam == "spectator")
		return;

	// Fix bug when player kills somebody with grenade while is using MG - MG icon instead of grenade is shown
	// If sWeapon is MG and sMeansOfDeath is MOD_GRENADE_SPLASH, replace MG icon to grenade
	if ((sWeapon == "mg42_bipod_stand_mp" || sWeapon == "30cal_stand_mp") && sMeansOfDeath == "MOD_GRENADE_SPLASH")
	{
		if(self.pers["team"] == "allies")
		{
			switch(game["allies"])
			{
			case "american":
				sWeapon = "fraggrenade_mp";
				break;

			case "british":
				sWeapon = "mk1britishfrag_mp";
				break;

			case "russian":
				sWeapon = "rgd-33russianfrag_mp";
				break;
			}
		}
		else if (self.pers["team"] == "axis")
			sWeapon = "stielhandgranate_mp";
	}

	// If the player was killed by a head shot, let players know it was a head shot kill (except shotgun)
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE" && sWeapon != "shotgun_mp")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// Call onKilling event and return if kill was prevented
	ret = maps\mp\gametypes\global\events::notifyKilling(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);
	if (ret) return;

	// If kill is not prevented, do onPlayerKilled event
	maps\mp\gametypes\global\events::notifyKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);

	// Call gametype specific event that is called as last
	[[level.onAfterPlayerKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);

	/*
	// Warning about high ping
	if (isPlayer(eAttacker) && eAttacker != self && timeOffset > 100)
	{
		self iprintln("^3You were killed by player with high ping " + timeOffset + "ms!");
	}
	*/
}



//=============================================================================


/*================
Setup any misc callbacks stuff like defines and default callbacks
================*/
SetupCallbacks()
{
	SetDefaultCallbacks();

	// Set defined for damage flags used in the playerDamage callback
	level.iDFLAGS_RADIUS			= 1;
	level.iDFLAGS_NO_ARMOR			= 2;
	level.iDFLAGS_NO_KNOCKBACK		= 4;
	level.iDFLAGS_NO_TEAM_PROTECTION	= 8;
	level.iDFLAGS_NO_PROTECTION		= 16;
	level.iDFLAGS_PASSTHRU			= 32;
}

/*================
Called from the gametype script to store off the default callback functions.
This allows the callbacks to be overridden by level script, but not lost.
================*/
SetDefaultCallbacks()
{
	level.default_CallbackStartGameType = level.callbackStartGameType;
	level.default_CallbackPlayerConnect = level.callbackPlayerConnect;
	level.default_CallbackPlayerDisconnect = level.callbackPlayerDisconnect;
	level.default_CallbackPlayerDamage = level.callbackPlayerDamage;
	level.default_CallbackPlayerKilled = level.callbackPlayerKilled;
}

/*================
Called when a gametype is not supported.
================*/
AbortLevel()
{
	println("Aborting level - gametype '" + getCvar("g_Gametype") + "' is not supported");
	logprint("Aborting level - gametype '" + getCvar("g_Gametype") + "' is not supported\n");

	level.callbackStartGameType = ::callbackVoid;
	level.callbackPlayerConnect = ::callbackVoid;
	level.callbackPlayerDisconnect = ::callbackVoid;
	level.callbackPlayerDamage = ::callbackVoid;
	level.callbackPlayerKilled = ::callbackVoid;

	setcvar("g_gametype", "dm");

	//wait level.fps_multiplier * 1;

	println("Restarting to DM gametype...");
	logprint("Restarting to DM gametype...\n");
	
	logprint("_callbacksetup:: Invoked exitLevel(false)\n");
	exitLevel(false);
	//map(level.mapname);
}

/*================
================*/
callbackVoid()
{
}