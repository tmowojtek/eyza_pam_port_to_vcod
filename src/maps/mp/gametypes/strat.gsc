

main()
{
	logprint("strat::init\n");
	
	// Initialize global systems (scripts for events, cvars, hud, player...)
	maps\mp\gametypes\global\_global::InitSystems();

	varAEL = maps\mp\gametypes\global\_global::addEventListener;

	// Register events that should be caught
	[[varAEL]]("onStartGameType", ::onStartGameType);
	[[varAEL]]("onConnecting", ::onConnecting);
	[[varAEL]]("onConnected", ::onConnected);
	[[varAEL]]("onDisconnect", ::onDisconnect);
	[[varAEL]]("onPlayerDamaging", ::onPlayerDamaging);
	[[varAEL]]("onPlayerDamaged", ::onPlayerDamaged);
	[[varAEL]]("onPlayerKilling", ::onPlayerKilling);
	[[varAEL]]("onPlayerKilled", ::onPlayerKilled);
	[[varAEL]]("onMenuResponse",  ::onMenuResponse);

	// Events for this gametype that are called last after all events are processed
	level.onAfterConnected = ::onAfterConnected;
	level.onAfterPlayerDamaged = ::onAfterPlayerDamaged;
	level.onAfterPlayerKilled = ::onAfterPlayerKilled;

	// Same functions across gametypes
	level.autoassign = ::menuAutoAssign;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
	level.spectator = ::menuSpectator;
	level.streamer = ::menuStreamer;
	level.weapon = ::menuWeapon;

	level.spawnPlayer = ::spawnPlayer;
	level.spawnSpectator = ::spawnSpectator;
	level.spawnIntermission = ::spawnIntermission;

	// Precache gametype specific stuff
	if (game["firstInit"])
		precache();

	// Init all shared modules in this pam (scripts with underscore)
	maps\mp\gametypes\global\_global::InitModules();
}

// Precache specific stuff for this gametype
// Is called only once per map
precache()
{
	//precacheStatusIcon("compassping_enemyfiring"); // for streamers

	maps\mp\gametypes\global\_global::precacheString2("STRING_FLY_ENABLED", &"Enabled");
	maps\mp\gametypes\global\_global::precacheString2("STRING_FLY_DISABLED", &"Disabled");
	maps\mp\gametypes\global\_global::precacheString2("STRING_ENABLE_HOLD_SHIFT", &"Enable: Hold ^3Bash");
	maps\mp\gametypes\global\_global::precacheString2("STRING_DISABLE_HOLD_SHIFT", &"Disable: Hold ^3Bash");
	maps\mp\gametypes\global\_global::precacheString2("STRING_GRENADE_EXPLODES_IN", &"Grenade explodes in");
}

// Called after the <gametype>.gsc::main() and <map>.gsc::main() scripts are called
// At this point game specific variables are defined (like game["allies"], game["axis"], game["american_soldiertype"], ...)
// Called again for every round in round-based gameplay
onStartGameType()
{
	if(game["firstInit"])
	{
		// defaults if not defined in level script
		if(!isdefined(game["allies"]))
			game["allies"] = "american";
		if(!isdefined(game["axis"]))
			game["axis"] = "german";
		if(!isdefined(game["attackers"]))
			game["attackers"] = "allies";
		if(!isdefined(game["defenders"]))
			game["defenders"] = "axis";


		// Main scores
		game["allies_score"] = 0;
		setTeamScore("allies", game["allies_score"]);

		game["axis_score"] = 0;
		setTeamScore("axis", game["axis_score"]);


		// Other variables
		game["state"] = "playing";
	}




	logprint("strat::onStartGameType getting spawnpoints\n");
	// Spawn points
	// spawnpointname = "mp_sd_spawn_attacker";
	spawnpointname = "mp_searchanddestroy_spawn_allied";
	spawnpoints = getentarray(spawnpointname, "classname");
	if(!spawnpoints.size)
	{
		maps\mp\gametypes\global\_global::AbortLevel();
		return;
	}

	logprint("strat::onStartGameType placing spawnpoints\n");

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] placeSpawnpoint();

	//spawnpointname = "mp_sd_spawn_defender";
	spawnpointname = "mp_searchanddestroy_spawn_axis";
	spawnpoints = getentarray(spawnpointname, "classname");
	if(!spawnpoints.size)
	{
		maps\mp\gametypes\global\_global::AbortLevel();
		return;
	}

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] PlaceSpawnpoint();

	logprint("strat::onStartGameType allowed gameobjects\n");

	allowed[0] = "sd";
	allowed[1] = "bombzone";
	allowed[2] = "blocker";
	maps\mp\gametypes\_gameobjects::main(allowed);

	thread maps\mp\gametypes\_pam::PAM_Header();
	level Show_HUD_Global();

	setClientNameMode("auto_change");

	logprint("strat::onStartGameType starting serverinfo thread\n");

	thread serverInfo();

	thread sv_cheats();

	logprint("strat::onStartGameType end\n");
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
================*/
onConnecting()
{
	self.statusicon = "gfx/hud/hud@status_connecting.tga";
}

/*
Called when player is fully connected to game
*/
onConnected()
{
	self.statusicon = "";

	// Variables in self.pers[] stay defined after scriped map restart
	// Other like self.ownvariable will be undefined after scriped map restart
	// Except a few special vars, like self.sessionteam, their are defined after map restart, but with default value

	// If is players first connect, his team is undefined (in SD is PlayerConnected called every round)
	if (!isDefined(self.pers["team"]))
	{
		// Show player in spectator team
		self.pers["team"] = "none";
		self.sessionteam = "none";

		// Print "<NAME> Connected" to all
		iprintln(&"MPSCRIPT_CONNECTED", self.name);
	}
	else
	{
		// If is team selected from last round, set the real team variable
		team = self.pers["team"];
		if (team == "streamer")
			team = "spectator";
		self.sessionteam = team;
	}

	// Define default variables specific for this gametype
	wait level.frame; // wait untill all functions are inicializes
	self thread Run_Strat();
}

// This function is called as last after all events are processed
onAfterConnected()
{
	// Spectator team
	if (self.pers["team"] == "none" || self.pers["team"] == "spectator" || self.pers["team"] == "streamer")
		spawnSpectator();

	// If team is selected
	else if (self.pers["team"] == "allies" || self.pers["team"] == "axis")
	{
		// If player have choozen weapon
		if(isDefined(self.pers["weapon"]))
			spawnPlayer();
		// If player have choosen team, but have not choosen weapon (he is selecting from weapons menu)
		else
			spawnSpectator();
	}
	else
	{
		logprint("Unknown team\n");
	}
}

/*================
Called when a player drops from the server.
Will not be called between levels.
self is the player that is disconnecting.
================*/
onDisconnect()
{
	iprintln(&"MPSCRIPT_DISCONNECTED", self.name);

	// Kick all bots spawned by this players
	if (isDefined(self.bots))
	{
		for (i = 0; i < self.bots.size; i++)
		{
			if (isPlayer(self.bots[i]))
			{
				//kick(self.bots[i] getEntityNumber());
				logprint("Bots " + self.name + " should be deleted but vCoD doesn't support bot kick..\n");
			}
		}
	}

	// For bots only
	if (isDefined(self.botLockPosition))
	{
		self.botLockPosition delete();
	}
}

onPlayerDamaging(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	// Print damage
	if(isDefined(eAttacker) && isPlayer(eAttacker) && iDamage > 0)
	{
		if (eAttacker == self)
		{
			// You inflicted 28 damage to yourself
			self iprintln("^7You inflicted ^1" + iDamage + "^7 damage to yourself");
			//self iprintln("^1Hit by-self for ^3" + iDamage + " ^1 damage^7"); // Hit Player damage notice
		}
		else
		{
			// You inflicted 28 damage to BOT1
			eAttacker iprintln("^7You inflicted ^2" + iDamage + "^7 damage to " + self.name + " (hitLoc: " + sHitLoc + ")");
			//eAttacker iprintln("^2Hit ^7" + self.name + "^2 for ^1" + iDamage + " ^2 damage^7"); // Attacker damage notice

			// Bot1 inflicted 12 damage to you
			self iprintln(eAttacker.name + "^7 inflicted ^1" + iDamage + "^7 damage to you (hitLoc: " + sHitLoc + ")");
			//self iprintln("^1Hit by ^7" + eAttacker.name + "^1 for ^3" + iDamage + " ^1 damage^7"); // Hit Player damage notice
		}
	}

	// Prevent damage if flaying is enabled
	if (self.flaying_enabled)
		return true;
}

/*
Called when player has taken damage.
self is the player that took damage.
*/
onPlayerDamaged(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{

}

// Called as last funtction after all onPlayerDamaged events are processed
onAfterPlayerDamaged(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		// Make sure at least one point of damage is done
		if(iDamage < 1)
			iDamage = 1;

		self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
		//self notify("damaged_player", iDamage);

		// Shellshock/Rumble
		//self thread maps\mp\gametypes\_shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
	}

	// LOG stuff
	if(self.sessionstate != "dead")
	{
		// level notify("log_damage", self, eAttacker, sWeapon, iDamage, sMeansOfDeath, sHitLoc, false);
		maps\mp\gametypes\_log::logDamage(self, eAttacker, sWeapon, iDamage, sMeansOfDeath, sHitLoc, false);
	}
}

/*
Called when player is about to be killed.
self is the player that was killed.
Return true to prevent the kill.
*/
onPlayerKilling(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
}

/*
Called when player is killed
self is the player that was killed.
*/
onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{

}

// Called as last funtction after all onPlayerKilled events are processed
onAfterPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("disconnect");
	self endon("spawned");

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	self.sessionstate = "dead";
	self.statusicon = "gfx/hud/hud@status_dead.tga";

	// Used to spawn player in same location he dies
	// Spawn on same location only if was killed by bullet, bash or grenade
	if ((sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" || sMeansOfDeath == "MOD_MELEE" || sMeansOfDeath == "MOD_GRENADE_SPLASH"))
	{
		self.spawnOrigin = self.origin;
		self.spawnAngles = self.angles;
	}
	else
	{
		self.spawnOrigin = undefined;
		self.spawnAngles = undefined;
	}

	// self notify("killed_player");

	// level notify("log_kill", self, attacker,  sWeapon, iDamage, sMeansOfDeath, sHitLoc);
	maps\mp\gametypes\_log::logKill(self, attacker,  sWeapon, iDamage, sMeansOfDeath, sHitLoc);

	// Wait before dead body is spawned to allow double kills (bullets may stop in this dead body)
	// Ignore this for shotgun, because it create a smoke effect on dead body (for good feeling)
	// if (sWeapon != "shotgun_mp")
		// waittillframeend;

	body = undefined;
	if(!isdefined(self.switching_teams))
		body = self cloneplayer();
	self.switching_teams = undefined;

	wait level.fps_multiplier * 1.5;

	if(isDefined(body))
		body delete();

	if(isDefined(self.pers["weapon"]))
		self thread spawnPlayer();
}

/*
Called when command scriptmenuresponse is executed on client side
self is player that called scriptmenuresponse
Return true to indicate that menu response was handled in this function
*/
onMenuResponse(menu, response)
{
	if(menu == game["menu_strat_records"])
	{
		if (maps\mp\gametypes\global\_global::startsWith(response, "select_"))
		{
			substr = maps\mp\gametypes\global\_global::getsubstr(response, 7);
			if (!maps\mp\gametypes\global\_global::isDigitalNumber(substr)) return true;
			line = (int)(substr);
			if (line < 1 || line > 9) return true;

			self closeMenu();
			// self closeInGameMenu();

			//record(line-1);
		}
		else if (maps\mp\gametypes\global\_global::startsWith(response, "delete_"))
		{
			substr = maps\mp\gametypes\global\_global::getsubstr(response, 7);
			if (!maps\mp\gametypes\global\_global::isDigitalNumber(substr)) return true;
			line = (int)(substr);
			if (line < 1 || line > 9) return true;

			self closeMenu();
			// self closeInGameMenu();

			self.recordSlots[line-1].used = false;

			//recordRequest();
		}


		return true;
	}
}

sv_cheats()
{
	wait level.fps_multiplier * 0.2;

	setCvar("sv_cheats", 1);
}

spawnPlayer()
{
	// Resets the infinite loop check timer, to prevent an incorrect infinite loop error when a lot of script must be run
	resettimeout();

	// Stop shellshock and rumble
	//self stopShellshock();
	//self stoprumble("damage_heavy");


	self.sessionteam = self.pers["team"];
	self.sessionstate = "playing";
	self.statusicon = "";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.maxhealth = 100;
	self.health = self.maxhealth;


	// Spawn where player dies
	if (isDefined(self.spawnOrigin))
	{
		self spawn(self.spawnOrigin, self.spawnAngles);

		self.spawnOrigin = undefined;
		self.spawnAngles = undefined;
	}
	else
	{
		// Select correct spawn position according to selected team
		if(self.pers["team"] == "allies")
			spawnpointname = "mp_searchanddestroy_spawn_allied";
		else
			spawnpointname = "mp_searchanddestroy_spawn_axis";

		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isdefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}


	if(!isdefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	// Give weapon
	self setWeaponSlotWeapon("primary", self.pers["weapon"]);
	self setWeaponSlotAmmo("primary", maps\mp\gametypes\_weapons::GetGunAmmo(self.pers["weapon"]));
	self setWeaponSlotClipAmmo("primary", 999);
	//self giveMaxAmmo(self.pers["weapon"]);

	maps\mp\gametypes\_weapons::givePistol();
	// maps\mp\gametypes\_weapons::giveBinoculars();

	maps\mp\gametypes\_weapons::giveGrenadesFor(self.pers["weapon"]);

	self setSpawnWeapon(self.pers["weapon"]);

	if (!self.pers["isBot"])
		self thread Watch_Grenade_Throw(true);

	// Notify "spawned" notifications
	self notify("spawned");
	self notify("spawned_player");
}

spawnSpectator(origin, angles)
{
	// Resets the infinite loop check timer, to prevent an incorrect infinite loop error when a lot of script must be run
	resettimeout();

	// Stop shellshock and rumble
	//self stopShellshock();
	//self stoprumble("damage_heavy");

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";

	if(isdefined(origin) && isdefined(angles))
		self spawn(origin, angles);
	else
	{
 		spawnpointname = "mp_searchanddestroy_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isdefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
		{
			self spawn((0,0,0), (0,0,0));
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
		}
	}

	// Notify "spawned" notifications
	self notify("spawned");
}

spawnIntermission()
{
	// assertMsg("Not needed");
	logprint("Intermission not needed.\n");
}

menuAutoAssign()
{
	// Team is already selected, do nothing and open menu again
	if(self.pers["team"] == "allies" || self.pers["team"] == "axis")
	{
		return;
	}

	numonteam["allies"] = 0;
	numonteam["axis"] = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(player.pers["team"] != "allies" && player.pers["team"] != "axis")
			continue;

		numonteam[player.pers["team"]]++;
	}

	// if teams are equal return the team with the lowest score
	if(numonteam["allies"] == numonteam["axis"])
	{
		teams[0] = "allies";
		teams[1] = "axis";
		assignment = teams[randomInt(2)];
	}
	else if(numonteam["allies"] < numonteam["axis"])
		assignment = "allies";
	else
		assignment = "axis";


	self.joining_team = assignment; // can be allies or axis
	self.leaving_team = self.pers["team"]; // can be "spectator" or "none"

	if(assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
	{
		self.switching_teams = true;
		self suicide();
	}

	self.sessionteam = assignment;
	self.pers["team"] = assignment;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;


	self notify("joined", assignment);
	self notify("joined_allies_axis");

	level notify("joined", assignment, self); // used in first round to check if someone joined team
}

menuAllies()
{
	// If team is already axis or we cannot join axis (to keep team balance), open team menu again
	if(self.pers["team"] == "allies" || !maps\mp\gametypes\_teams::getJoinTeamPermissions("allies"))
	{
		return;
	}

	self.joining_team = "allies";
	self.leaving_team = self.pers["team"];

	if(self.sessionstate == "playing")
	{
		self.switching_teams = true;
		self suicide();
	}

	self.sessionteam = "allies";
	self.pers["team"] = "allies";
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;


	self notify("joined", "allies");
	self notify("joined_allies_axis");

	level notify("joined", "allies", self); // used in first round to check if someone joined team
}

menuAxis()
{
	// If team is already axis or we cannot join axis (to keep team balance), open team menu again
	if(self.pers["team"] == "axis" || !maps\mp\gametypes\_teams::getJoinTeamPermissions("axis"))
	{
		return;
	}

	self.joining_team = "axis";
	self.leaving_team = self.pers["team"];

	if(self.sessionstate == "playing")
	{
		self.switching_teams = true;
		self suicide();
	}

	self.sessionteam = "axis";
	self.pers["team"] = "axis";
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	self notify("joined", "axis");
	self notify("joined_allies_axis");

	level notify("joined", "axis", self); // used in first round to check if someone joined team
}

menuSpectator()
{
	if(self.pers["team"] == "spectator")
		return;

	self.joining_team = "spectator";
	self.leaving_team = self.pers["team"];

	if(isAlive(self))
	{
		self.switching_teams = true;
		self suicide();
	}

	self.sessionteam = "spectator";
	self.pers["team"] = "spectator";
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	spawnSpectator();

	self notify("joined", "spectator");
	self notify("joined_spectators");

	level notify("joined", "spectator", self); // used in first round to check if someone joined team
}

menuStreamer()
{
	if(self.pers["team"] == "streamer")
		return;

	self.joining_team = "streamer";
	self.leaving_team = self.pers["team"];

	if(isAlive(self))
	{
		self.switching_teams = true;
		self suicide();
	}

	self.sessionteam = "spectator";
	self.pers["team"] = "streamer";
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	spawnSpectator();

	self notify("joined", "streamer");
	self notify("joined_streamers");

	level notify("joined", "streamer", self); // used in first round to check if someone joined team
}

menuWeapon(response)
{
	logprint("sd::menuWeapon response=" + response + "\n");

	// You has to be "allies" or "axis" to change a weapon
	if(self.pers["team"] != "allies" && self.pers["team"] != "axis")
		return;

	// Used by bots
	if (response == "random")
		response = self maps\mp\gametypes\_weapons::getRandomWeapon();

	// Weapon is not valid or is in use
	if(!self maps\mp\gametypes\_weapon_limiter::isWeaponAvailable(response))
	{
		// Open menu with weapons again
		if(self.pers["team"] == "allies")
			self openMenu(game["menu_weapon_allies"]);
		else if(self.pers["team"] == "axis")
			self openMenu(game["menu_weapon_axis"]);
		return;
	}

	weapon = response;

	primary = self getWeaponSlotWeapon("primary");
	primaryb = self getWeaponSlotWeapon("primaryb");

	// After selecting a weapon, show "ingame" menu when ESC is pressed
	//self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", game["menu_ingame"]);
	if(self.pers["team"] == "allies")
		self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", game["menu_weapon_allies"]);
	else if(self.pers["team"] == "axis")
		self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", game["menu_weapon_axis"]);


	// If newly selected weapon is same as actualy selected weapon and is in player slot -> do nothing
	if(isdefined(self.pers["weapon"]))
	{
		if (self.pers["weapon"] == weapon && primary == weapon)
		{
			logprint("_menuWeapon:: do nothing, weapon selected is in player slot already\n");
			return;
		}
	}

	// Save weapon before change (used in weapon_limiter)
	leavedWeapon = undefined;
	leavedWeaponFromTeam = undefined;
	if (isDefined(self.pers["weapon"]))
	{
		leavedWeapon = self.pers["weapon"];
		leavedWeaponFromTeam = self.pers["team"];
	}

	if(isDefined(self.pers["weapon"]))
	{
		self.pers["weapon"] = weapon;

		// Remove weapon from slot (can be "none", takeWeapon() will take it)
		self takeWeapon(primary);
		self takeWeapon(primaryb);

		// Give weapon to primary slot
		self setWeaponSlotWeapon("primary", weapon);
		self setWeaponSlotAmmo("primary", maps\mp\gametypes\_weapons::GetGunAmmo(weapon));
		self setWeaponSlotClipAmmo("primary", 999);
		//self giveMaxAmmo(weapon);

		// Give pistol to secondary slot + give grenades and smokes
		maps\mp\gametypes\_weapons::givePistol();
		//maps\mp\gametypes\_weapons::giveSmokesFor(weapon, 0);
		maps\mp\gametypes\_weapons::giveGrenadesFor(weapon);

		// Switch to main weapon
		self switchToWeapon(weapon);
	}
	else
	{
		self.pers["weapon"] = weapon;

		spawnPlayer();
	}


	// Used in wepoan_limiter
	self notify("weapon_changed", weapon, leavedWeapon, leavedWeaponFromTeam);
}

serverInfo()
{
	level.serverinfo_left1 = "No settings";
	level.serverinfo_left2 = "";
}




// * Training Nade Script by Matthias lorenz * (_slightly_ modified by zar & z0d)
Run_Strat()
{
	self.flying = false;
	self.flaying_enabled = true;
	self.bots = [];
	self.recording = false;
	self.recordSlots = [];
	for (i = 0; i <= 8; i++)
	{
		self.recordSlots[i] = spawnStruct();
		self.recordSlots[i].used = false;
		self.recordSlots[i].positions = [];
		self.recordSlots[i].angles = [];
	}


	// Ignore bots
	if (self.pers["isBot"])
		return;

	self thread Show_HUD_Player();

	self thread Key_Toggle_FlyMode();
	self thread Key_SavePosition();
	self thread Key_LoadPosition();

	if (getCvarInt("sv_punkbuster") == 0)
	{
		// self thread Key_AddBot();
		// self thread Key_RecordBot();
		// self thread Key_PlayRecord();
	}
}

// Hold Shift to enable / disable fly mode
Key_Toggle_FlyMode()
{
	self endon("disconnect");

	for(;;)
	{
		waittime = 0;
		//while (self meleebuttonpressed() && !self useButtonPressed() && self playerAds() == 0)
		// while (self meleebuttonpressed() && !self useButtonPressed() && self aimButtonPressed() == 0)
		while (self meleebuttonpressed() && !self useButtonPressed())
		{
			waittime += level.frame;

			if (waittime > 1.0)
			{
				if (!self.flaying_enabled) {
					self iprintln("^3Training nade fly mode turned ^1on");
					self.flaying_enabled = 1;
				} else {
					self iprintln("^3Training nade fly mode turned ^1off");
					self.flaying_enabled = 0;
				}
				break;
			}
			wait level.frame;
		}
		wait level.fps_multiplier * 0.2;
	}
}

// Double press Shift
Key_SavePosition()
{
	self endon("disconnect");

	for(;;)
	{
		if(self meleeButtonPressed())
		{
			catch_next = false;

			for(i=0; i<=0.30; i+=0.01)
			{
				if(catch_next && self meleeButtonPressed())
				{
					self thread savePos();
					wait level.fps_multiplier * 1;
					break;
				}
				else if(!(self meleeButtonPressed()))
					catch_next = true;

				wait level.fps_multiplier * 0.01;
			}
		}
		wait level.frame;
	}
}

// Double press F key
Key_LoadPosition()
{
	self endon("disconnect");

	for(;;)
	{
		if(self useButtonPressed())
		{
			catch_next = false;

			for(i=0; i<=0.30; i+=0.01)
			{
				if(catch_next && self useButtonPressed())
				{
					self thread loadPos();
					wait level.fps_multiplier * 1;
					break;
				}
				else if(!(self useButtonPressed()))
					catch_next = true;

				wait level.fps_multiplier * 0.01;
			}
		}

		wait level.frame;
	}
}

// Hold Shift to enable / disable fly mode
/*
Key_AddBot()
{
	self endon("disconnect");

	for(;;)
	{
		waittime = 0;
		while (self meleebuttonpressed() && self useButtonPressed() && self.sessionstate == "playing")
		{
			waittime += level.frame;

			if (waittime > 1.0)
			{
				if (!isDefined(self.bots[0]))
					self add_bot();
				else
					self.bots[0] thread handle_bot(self); // respawn bot to actual players position

				// Wait untill keys are released
				while (self meleebuttonpressed() && self useButtonPressed())
					wait level.fps_multiplier * 0.2;

				break;
			}
			wait level.frame;
		}
		wait level.fps_multiplier * 0.2;
	}
}
*/

/*
Key_RecordBot()
{
	self endon("disconnect");

	for(;;)
	{
		waittime = 0;
		while (self attackbuttonpressed() && self useButtonPressed() && !self meleebuttonpressed() && self.sessionstate == "playing")
		{
			waittime += level.frame;

			if (waittime > 1.0)
			{
				if (self.recording)
				{
					self.recording = false;
				}
				else
				{
					self thread recordRequest();
				}

				// Wait untill keys are released
				while (self attackbuttonpressed() && self useButtonPressed() && !self meleebuttonpressed())
					wait level.fps_multiplier * 0.2;

				break;
			}
			wait level.frame;
		}
		wait level.fps_multiplier * 0.2;
	}
}
*/

// Hold Shift to enable / disable fly mode
/*
Key_PlayRecord()
{
	self endon("disconnect");
	for(;;)
	{
		waittime = 0;
		while (self useButtonPressed() && !self attackbuttonpressed() && !self meleebuttonpressed() && self.sessionstate == "playing")
		{
			waittime += level.frame;

			if (waittime > 1.0)
			{
				self thread playRecords();
				break;
			}
			wait level.frame;
		}
		wait level.fps_multiplier * 0.2;
	}
}
*/



// This is called when player spawns
Watch_Grenade_Throw(is_strat)
{
	self endon("disconnect");

	// Make sure only 1 thred is running
	self notify("end_Watch_Grenade_Throw");
	self endon("end_Watch_Grenade_Throw");

	// nadename = self maps\mp\gametypes\_weapons::GetGrenadeTypeName();
	//smokename = self maps\mp\gametypes\_weapons::GetSmokeTypeName();

	/*
	if (is_strat)
	{
		//self giveWeapon(nadename);
		//self giveWeapon(smokename);

		//self setWeaponClipAmmo(nadename, 1);
		//self setWeaponSlotWeapon("grenade", grenadetype);
		//self setWeaponSlotAmmo("grenade", 1);
		//self setWeaponClipAmmo(smokename, 1);

		self setWeaponSlotWeapon("grenade", self maps\mp\gametypes\_weapons::GetGrenadeTypeName());
		self setWeaponSlotAmmo("grenade", 999);
	}*/

	//grenade_count_old	 = self maps\mp\gametypes\_weapons::getFragGrenadeCount();
	//smokegrenade_count_old = self maps\mp\gametypes\_weapons::getSmokeGrenadeCount();

	while (self.sessionstate == "playing")
	{
		grenade_count 	= self getWeaponSlotAmmo("grenade");
		// grenade_count 	= self maps\mp\gametypes\_weapons::getFragGrenadeCount();
		//smokegrenade_count 	= self maps\mp\gametypes\_weapons::getSmokeGrenadeCount();

		// if(grenade_count != grenade_count_old /*|| smokegrenade_count != smokegrenade_count_old*/ && self.sessionstate == "playing") 
		// {
		while (grenade_count == self getWeaponSlotAmmo("grenade") && self.sessionstate == "playing") {
			wait 0.05;
        }

		if (self.sessionstate != "playing") 
		{
			logprint(self.name + " nade_count has changed but sessionstate is not playing: " + self.sessionstate + " - nade_training egress\n");
            return;
        }

			/*
			if (is_strat)
			{
				// Refill grenades
				//self setWeaponClipAmmo(self maps\mp\gametypes\_weapons::GetGrenadeTypeName(), 1);
				self setWeaponSlotWeapon("grenade", self maps\mp\gametypes\_weapons::GetGrenadeTypeName());
				self setWeaponSlotAmmo("grenade", 999);
				//self setWeaponClipAmmo(self maps\mp\gametypes\_weapons::GetSmokeTypeName(), 1);

				// Show explode in timer text
				if (grenade_count != grenade_count_old)
					self thread HUD_Grenade_Releases_In();
			}
			*/

		self setWeaponSlotAmmo("grenade", 999);

		// Show explode in timer text
		//if (grenade_count != grenade_count_old)
			// self thread HUD_Grenade_Releases_In();

		// Follow nade if enabled
		if (self.flaying_enabled)
		{
			// Loop grenades in map
			grenades = getentarray("grenade","classname");
			for(i=0;i<grenades.size;i++) {
				if(isDefined(grenades[i].origin) && !isDefined(grenades[i].running)) {
					// Only if it's your own nade (close to the player)
					if(distanceSquared(grenades[i].origin, self.origin) < 100*100) {
						grenades[i].running = true;
						//grenades[i] thread Fly(self);
						self thread Fly(grenades[i]);
					}
				}
			}
		}

		// grenade_count_old	 = grenade_count;
		//smokegrenade_count_old = smokegrenade_count;

		//wait level.fps_multiplier * 0.1;
		// wait 0.05;
	}
	logprint(self.name + " nade_training egress\n");
}

Fly(nade)
{
	self notify("flying_ende");
	self endon("flying_ende");
	self endon("disconnect");

	logprint(self.name + " fly ingress\n");

	self.flying = true;

	// old_player_origin = player.origin;
		
	saved_angles = self.angles;
	saved_origin = self.origin;

	self disableWeapon();

	// Link script_model to grenade from players position offset
	// player.hilfsObjekt = spawn("script_model", player.origin);
	// player.hilfsObjekt.angles = player.angles;
	// player.hilfsObjekt linkto(self);

	m = spawn("script_model", self.origin);
    m.angles = self.angles;
	m linkTo(nade);

	self setOrigin(m.origin);
	self linkTo(m);

	// Wait untill greande is fully throwed to avoid interrupted jump
	//wait level.fps_multiplier * 0.13;

	// Link player to that script_model
	//player setOrigin(player.hilfsObjekt.origin);
	//player linkto(player.hilfsObjekt);



	//old_origin = (0,0,0);

	// attack_button_pressed = false;
	// use_button_pressed = false;

	while(isDefined(nade) && self attackButtonPressed() == false)
	{
		// If grenade stops moving - break loop
		//if(self.origin == old_origin)
			//break;

		//old_origin = self.origin;

		// Stop moving
		// if(player attackButtonPressed()) {
		// 	attack_button_pressed = true;
		// 	break;
		// }

		// Restore position
		// if(player useButtonPressed()) {
		// {
		// 	use_button_pressed = true;
		// 	break;
		// }

		wait 0.05;
	}

	logprint(self.name + " nade not defined or attackButtonPressed\n");

	//player.hilfsObjekt unlink();


	// if(!use_button_pressed)
	// {
	// 	if(attack_button_pressed)
	// 	{
	// 		for(i=0;i<3.5;i+=0.1) {

	// 			wait level.fps_multiplier * 0.1;
	// 			if(player useButtonPressed()) break;
	// 		}
	// 	}
	// 	else
	// 	{
	// 		player.hilfsObjekt moveto(player.origin+(0,0,20),0.1);
	// 		wait level.fps_multiplier * 0.2;

	// 		for(i=0;i<2;i+=0.1)
	// 		{
	// 			wait level.fps_multiplier * 0.1;
	// 			if(player useButtonPressed()) break;
	// 		}
	// 	}
	// }

	// player.hilfsObjekt moveto(old_player_origin,0.1);
	// wait level.fps_multiplier * 0.2;

	// player unlink();
	// if(isDefined(player.hilfsObjekt)) player.hilfsObjekt delete();

	m unlink();
	m moveTo(saved_origin,0.1);
	wait 0.5;
	self unlink();
	self enableWeapon();
	if (isDefined(m)) 
	{
		m delete();
	}

	self.flying = false;

	logprint(self.name + " fly egress\n");
}

loadPos()
{
	if(!isDefined(self.saved_origin))
		{
			self iprintln("^1There is no previous ^3position ^1to load");
			return;
		}
	else
		{
			self setPlayerAngles(self.saved_angles);
			self setOrigin(self.saved_origin);
			self iprintln("^3Position ^1loaded");
		}
}

savePos()
{
	self.saved_origin = self.origin;
	self.saved_angles = self.angles;
	self iprintln("^3Position ^1saved");
}

Show_HUD_Global()
{
	level.granade1 = maps\mp\gametypes\global\_global::addHUD(605, 60, 1.2, (.8,1,1), "right", "top", "right");
	level.granade1 setText(&"Grenade flying");

	// Enabled / Disabled
	// Disable: Hold Shift / Enable: Hold Shift

	level.granade2 = maps\mp\gametypes\global\_global::addHUD(605, 110, .9, (.8,1,1), "right", "top", "right");
	level.granade2 setText(&"Return: Press ^3Left mouse");

	// level.granade3 = maps\mp\gametypes\global\_global::addHUD(605, 120, .9, (.8,1,1), "right", "top", "right");
	// level.granade3 setText(&"Stop: Press ^3Use");



	level.positionlogo = maps\mp\gametypes\global\_global::addHUD(605, 150, 1.2, (.8,1,1), "right", "top", "right");
	level.positionlogo setText(&"Position");

	level.savelogo = maps\mp\gametypes\global\_global::addHUD(605, 170, .9, (.8,1,1), "right", "top", "right");
	level.savelogo setText(&"Save: Press ^3Bash ^7twice");

	level.loadlogo = maps\mp\gametypes\global\_global::addHUD(605, 180, .9, (.8,1,1), "right", "top", "right");
	level.loadlogo setText(&"Load: Press ^3Use ^7twice");




	// level.trainingdummy = maps\mp\gametypes\global\_global::addHUD(605, 210, 1.2, (.8,1,1), "right", "top", "right");
	// level.trainingdummy setText(&"Training Bot");

	// if (getCvarInt("sv_punkbuster") == 0)
	// {
	// 	level.trainingdummykey = maps\mp\gametypes\global\_global::addHUD(605, 230, .9, (.8,1,1), "right", "top", "right");
	// 	level.trainingdummykey setText(&"Spawn: Hold ^3Bash ^7+ ^3Use");

	// 	level.trainingdummyrecord = maps\mp\gametypes\global\_global::addHUD(605, 240, .9, (.8,1,1), "right", "top", "right");
	// 	level.trainingdummyrecord setText(&"Record: Hold ^3Left mouse ^7+ ^3Use");

	// 	level.trainingdummyplay = maps\mp\gametypes\global\_global::addHUD(605, 250, .9, (.8,1,1), "right", "top", "right");
	// 	level.trainingdummyplay setText(&"Play: Hold ^3Use");
	// }
	// else
	// {
	// 	level.trainingdummywarn = maps\mp\gametypes\global\_global::addHUD(605, 230, .9, (1,1,0), "right", "top", "right");
	// 	level.trainingdummywarn setText(&"Disable Punkbuster!");
	// }

	level.clock = maps\mp\gametypes\global\_global::addHUD(605, 280, 1.2, (.8,1,1), "right", "top", "right");
	level.clock setText(&"Clock");
	level.clocktimer = maps\mp\gametypes\global\_global::addHUD(605, 295, 1, (.98, .98, .60), "right", "top", "right");
	level.clocktimer SetTimerUp(0.1);

	level.mainClock = maps\mp\gametypes\global\_global::newHudElem2();
	level.mainClock.x = 320;
	level.mainClock.y = 460;
	level.mainClock.alignX = "center";
	level.mainClock.alignY = "middle";
	level.mainClock.font = "bigfixed";
	level.mainClock setTimer(1);
}

Show_HUD_Player()
{
	self endon("disconnect");

	// Enabled / Disabled
	self.nadelogo = maps\mp\gametypes\global\_global::addHUDClient(self, 605, 80, 1.2, (1,1,1), "right", "top", "right");

	// Disable: Hold Shift
	// Enable: Hold Shift
	self.pressad = maps\mp\gametypes\global\_global::addHUDClient(self, 605, 100, .9, (0.8,1,1), "right", "top", "right");

	for(;;)
	{
		if (self.flaying_enabled)
		{
			self.nadelogo.color = (.73, .99, .73);
			self.nadelogo setText(game["STRING_FLY_ENABLED"]);
			self.pressad setText(game["STRING_DISABLE_HOLD_SHIFT"]);
		}
		else
		{
			self.nadelogo.color = (1, .66, .66);
			self.nadelogo setText(game["STRING_FLY_DISABLED"]);
			self.pressad setText(game["STRING_ENABLE_HOLD_SHIFT"]);
		}
		wait level.frame * 3;
	}
}

HUD_Grenade_Releases_In()
{
	self endon("disconnect");

	// This make sure only 1 thread will run
	self notify("end_hud_grenade_explode");
	self endon("end_hud_grenade_explode");

	if (isdefined(self.c))
		self.c destroy();
	if(isdefined(self.exin))
		self.exin destroy();

	self.exin = maps\mp\gametypes\global\_global::addHUDClient(self, -80, 310, 1.2, (.8,1,1), "right", "top", "right");
	self.exin setText(game["STRING_GRENADE_EXPLODES_IN"]);

	self.c = maps\mp\gametypes\global\_global::addHUDClient(self, -35, 310, 1.2, (.8,1,1), "right", "top", "right");
	self.c settenthsTimer(3.5);

	wait level.fps_multiplier * 3.5;

	self.c destroy();
	self.exin destroy();
}







/*
add_bot()
{
	//iprintln(self.name + " is spawning bot.");

	bot = maps\mp\gametypes\_bots::addBot(true);

	if (!isDefined(bot))
		self iprintln("^1Bot adding failed");
	else
	{
		bot thread handle_bot(self); // spawn bot to actual players position
		self.bots[self.bots.size] = bot;
	}

	return bot;
}
*/

/*
handle_bot(player)
{
	self endon("disconnect");
	player endon("disconnect");

	// Wait untill player move from spawn position
	pos = player.origin;
	angle = player.angles;
	player iprintlnbold("Move away to spawn a bot.");
	while (distance(pos, player.origin) < 50)
		wait level.fps_multiplier * .1;


	// This make sure only one thread is running on bot
	self notify("end_bot_brain");
	self endon("end_bot_brain");

	self.pers["team"] = player.pers["team"];
	self.pers["weapon"] = player.pers["weapon"];
	self.spawnOrigin = pos;
	self.spawnAngles = angle;
	self.flaying_enabled = false;

	self spawnPlayer(); // will be spawned at specified position above

	if (!isDefined(self.botLockPosition))
	{
		self.botLockPosition = spawn("script_model", pos);
		self.botLockPosition.angles = angle;
		self.botLockPosition thread obj();
	}
	else
	{
		self.botLockPosition.origin = pos;
		self.botLockPosition.angles = angle;
	}

	wait level.fps_multiplier * .25;

	for (;;)
	{
		self unlink();
		while(!isAlive(self))	wait level.fps_multiplier * 1;

		self setOrigin(self.botLockPosition.origin); // make sure player is always centered with script_model (for proper playing)
		self linkto(self.botLockPosition);
		self disableWeapon();

		// Remove head icon
		self.headicon = "";
		self.headiconteam = "none";

		while(isAlive(self))	wait level.fps_multiplier * 1;
	}
}
*/

/*
obj()
{
	newobjpoint = newHudElem2();
	newobjpoint.name = "A";
	newobjpoint.x = self.origin[0];
	newobjpoint.y = self.origin[1];
	newobjpoint.z = self.origin[2];
	newobjpoint.alpha = 1;
	newobjpoint.archived = true;
	newobjpoint setShader("objpoint_default", 2, 2);
	newobjpoint setwaypoint(true);

	for(;;)
	{
		wait level.frame;

		if (!isDefined(self)) // obj was deleted
		{
			newobjpoint destroy();
			break;
		}

		newobjpoint.x = self.origin[0];
		newobjpoint.y = self.origin[1];
		newobjpoint.z = self.origin[2];
	}
}
*/


/*
Attack+Use = record
	up to 10 slots are prepared to save a recording
	for the first record its saved automatically to first slot without asking
	for the other records open dialog with slots and saved recording
		player has to choose in what slot to save the record
		he can replace existing record or save it as new record

Hold Use = play all records

*/

//recordRequest()
//{
//	self endon("disconnect");
//
//	if (self.sessionteam != "allies" && self.sessionteam != "axis")
//		return;
//
//
//	empty = true;
//	for (i = 0; i < 9; i++)
//	{
//		if (self.recordSlots[i].used)
//		{
//			empty = false;
//			break;
//		}
//	}
//
//	// No records yet, save to first slot
//	if (empty)
//	{
//		record(0);
//	}
//	else // Open dialog
//	{
//		for (i = 0; i < 9; i++)
//		{
//			value = 0;
//
//			if (self.recordSlots[i].used)
//				value = 1;
//			else
//				value = 2;
//			/*
//				0 = empty
//				1 = replace record
//				2 = new record
//			*/
//			self maps\mp\gametypes\global\_global::setClientCvar2("ui_strat_records_line_" + (i+1), value);
//		}
//
//
//		self closeMenu();
//		self closeInGameMenu();
//		self openMenu(game["menu_strat_records"]);
//	}
//}


/*
record(slot)
{
	self endon("disconnect");

	self.recording = true;

	// Show black bar
	self.kc_topbar = newClientHudElem2(self);
	self.kc_topbar.archived = false;
	self.kc_topbar.x = 0;
	self.kc_topbar.y = 0;
	self.kc_topbar.horzAlign = "fullscreen";
	self.kc_topbar.vertAlign = "fullscreen";
	self.kc_topbar.alpha = 0.5;
	self.kc_topbar.sort = 99;
	self.kc_topbar setShader("black", 640, 80);

	self.kc_bottombar = newClientHudElem2(self);
	self.kc_bottombar.archived = false;
	self.kc_bottombar.x = 0;
	self.kc_bottombar.y = 400;
	self.kc_bottombar.horzAlign = "fullscreen";
	self.kc_bottombar.vertAlign = "fullscreen";
	self.kc_bottombar.alpha = 0.5;
	self.kc_bottombar.sort = 99;
	self.kc_bottombar setShader("black", 640, 80);

	self iprintlnbold("Move to start recording");
	self iprintlnbold("^2Go Go Go!");

	origin_old = self.origin;
	for (;;)
	{
		if (distance(self.origin, origin_old) > 10)
		{
			self iprintlnbold("^2Recording to slot " + (slot+1) + "...");
			break;
		}
		wait level.fps_multiplier * 0.1;
	}


	self iprintlnbold(" ");
	self iprintlnbold(" ");
	self iprintlnbold(" ");
	self iprintlnbold(" ");

	self.recordSlots[slot].used = true;
	self.recordSlots[slot].positions = [];
	self.recordSlots[slot].angles = [];

	origin_start = self.origin;
	time_not_moving = 0;
	while(self.recording)
	{
		self.recordSlots[slot].positions[self.recordSlots[slot].positions.size] = self.origin;
		self.recordSlots[slot].angles[self.recordSlots[slot].angles.size] = self.angles;
		origin_old = self.origin;

		wait level.fps_multiplier * 0.25;

		if (origin_old == self.origin && self.origin != origin_start)
			time_not_moving++;
		else
			time_not_moving = 0;

		if (time_not_moving == 1)
			self iprintlnbold("Dont move to stop recording");

		if (time_not_moving >= 4 || !isAlive(self))
			self.recording = false;
	}

	self iprintlnbold("^2Recording saved");

	self.kc_topbar destroy2();
	self.kc_bottombar destroy2();
}
*/

/*
playRecords()
{
	self endon("disconnect");

	// Make sure only 1 thread is running
	self notify("end_playRecord");
	self endon("end_playRecord");


	records = 0;
	for (i = 0; i < 9; i++)
	{
		if (self.recordSlots[i].used)
			records++;
	}

	if (self.recording)
	{
		self iprintlnbold("^1Cannot play record while recording!");
		return;
	}

	if (records == 0)
	{
		self iprintlnbold("^1No record to play");
		return;
	}

	// Add bots according to number of recordings
	for (i = self.bots.size; i < records; i++)
	{
		bot = add_bot();

		// Bot cannot be spawned, cancel playing record
		if (!isDefined(bot))
			return;

		// Wait untill bot is spawned
		while(!isAlive(bot))
			wait level.fps_multiplier * 0.1;
	}


	self iprintlnbold("Playing records...");
	self iprintlnbold(" ");
	self iprintlnbold(" ");
	self iprintlnbold(" ");
	self iprintlnbold(" ");

	if (isDefined(self.clock))
		self.clock destroy2();

	self.clock = newClientHudElem2(self);
	self.clock.font = "default";
	self.clock.fontscale = 2;
	self.clock.horzAlign = "center_safearea";
	self.clock.vertAlign = "top";
	self.clock.color = (1, 1, 1);
	self.clock.x = -25;
	self.clock.y = 445;
	self.clock setTimer(2 * 60);


	self.replayedRecords = 0;

	botIndex = 0;
	for (i = 0; i < 9; i++)
	{
		if (self.recordSlots[i].used)
		{
			self thread playRecord(i, botIndex);
			botIndex++;
		}
	}

	// Wait untill all records are played
	while (self.replayedRecords != records)
		wait level.fps_multiplier * .1;

	self.clock destroy2();

	self iprintln("Playing finished");
}
*/

/*
playRecord(slotIndex, botIndex)
{
	self endon("disconnect");
	self endon("end_playRecord");

	// Make sure only 1 thread is running
	self notify("end_playRecord_" + slotIndex);
	self endon("end_playRecord_" + slotIndex);

	self iprintln("Playing record " + slotIndex + " for bot " + botIndex + " size: " + self.recordSlots[slotIndex].positions.size);

	bot = self.bots[botIndex];
	for (i = 0; i < self.recordSlots[slotIndex].positions.size; i++)
	{
		// Cancel playing if bot is killed
		if (!isDefined(bot) || !isAlive(bot))
			break;

		// MoveTo( <point>, <time>, <acceleration time>, <deceleration time> )
		bot.botLockPosition moveto(self.recordSlots[slotIndex].positions[i], 0.25);
		bot SetPlayerAngles(self.recordSlots[slotIndex].angles[i]);

		wait level.fps_multiplier * 0.25;
	}

	self.replayedRecords++;
}
*/