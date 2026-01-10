

init()
{
	if (level.gametype == "dm" || level.gametype == "strat" || level.gametype == "test")
		return;
	
	logprint("_hud_teamscore::init\n");

	maps\mp\gametypes\global\_global::addEventListener("onCvarChanged", ::onCvarChanged);

	maps\mp\gametypes\global\_global::registerCvar("scr_show_scoreboard", "BOOL", 1); 	// level.scr_show_scoreboard // NOTE: after reset
	maps\mp\gametypes\global\_global::registerCvar("scr_show_scoreboard_limit", "BOOL", 0);    // level.scr_show_scoreboard_limit // NOTE: after reset

	if (level.scr_show_scoreboard == 0)
	{
		logprint("_hud_teamscore:: turned off level.scr_show_scoreboard=" + level.scr_show_scoreboard + "\n");
		return;
	}

	// Create hud elements to all players taht connect
	maps\mp\gametypes\global\_global::addEventListener("onStartGameType", ::onStartGameType);
	maps\mp\gametypes\global\_global::addEventListener("onConnected",     	::onConnected);
	maps\mp\gametypes\global\_global::addEventListener("onSpawned",   ::onSpawned);

}


// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	switch(cvar)
	{
		case "scr_show_scoreboard": 		level.scr_show_scoreboard = value; return true;
		case "scr_show_scoreboard_limit":	level.scr_show_scoreboard_limit = value; return true;
	}
	return false;
}


// Called after the <gametype>.gsc::main() and <map>.gsc::main() scripts are called
// At this point game specific variables are defined (like game["allies"], game["axis"], game["american_soldiertype"], ...)
// Called again for every round in round-based gameplay
onStartGameType()
{
	if (!isDefined(game["hudicon_allies"]))
	{
		switch(game["allies"])
		{
			case "american":
				game["hudicon_allies"] = "gfx/hud/headicon@american.tga";
				break;

			case "british":
				game["hudicon_allies"] = "gfx/hud/headicon@british.tga";
				break;

			case "russian":
				game["hudicon_allies"] = "gfx/hud/headicon@russian.tga";
				break;
		}
	}

	if (!isDefined(game["hudicon_axis"]))
	{
		game["hudicon_axis"] = "gfx/hud/headicon@german.tga";
	}

	if(game["firstInit"])
	{
		precacheShader(game["hudicon_allies"]);
		precacheShader(game["hudicon_axis"]);
		precacheString(&"/");
		//precacheString(&"MP_SLASH");
		//maps\mp\gametypes\global\_global::precacheString2("MP_SLASH", &"/");
	}
}




// Create HUD elements for player
onConnected()
{
	logprint("_hud_teamscore::onConnected start\n");
	// Create hud elemtns (keep invisible)
	self createPlayerScoreHUD();

	// Set score into hud elemtns
	self thread updatePlayerHUD();

	// Show score by default
	//self showScore();
	logprint("_hud_teamscore::onConnected end\n");
}

onSpawned()
{
	// Show score
	//if (self isEnabled())
		//self showScore();
}





isEnabled()
{
	return isDefined(self.pers["hud_teamscore_visible"]) && self.pers["hud_teamscore_visible"];
}

enable()
{
	self.pers["hud_teamscore_visible"] = true;
}

disable()
{
	self.pers["hud_teamscore_visible"] = false;
}

toggle()
{
	if (isEnabled())
		self disable();
	else
		self enable();
}





// Is called: Player Killed, Map/Round End
showScore(time)
{
	// Continue only if score is enabled by cvar
	if (level.scr_show_scoreboard == 0)
		return;

	if (!isDefined(time))
		time = 0;

	if (isPlayer(self))
		self thread fadeInPlayerHUD(time);
	else
		level thread fadeInAllHUD(time);
}

// Is called: Round-start after strattime, Player spawn in grace-period
hideScore(time)
{
	if (level.scr_show_scoreboard == 0)
		return;

	if (!isDefined(time))
		time = 0;

	if (isPlayer(self))
		self thread fadeOutPlayerHUD(time);
	else
		level thread fadeOutAllHUD(time);
}

updateScore()
{
	// Continue only if score is enabled by cvar
	if (level.scr_show_scoreboard == 0)
		return;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] thread updatePlayerHUD();
}




createPlayerScoreHUD() {

	// Icons
	self.hud_alliedicon = maps\mp\gametypes\global\_global::addHUDClient(self, 6, 28, undefined, undefined, "left", "top", "left", "top");
	self.hud_axisicon = maps\mp\gametypes\global\_global::addHUDClient(self, 6, 50, undefined, undefined, "left", "top", "left", "top");
	self.hud_alliedicon setShader(game["hudicon_allies"], 24, 24);
	self.hud_axisicon setShader(game["hudicon_axis"], 24, 24);

	// Score
	self.hud_alliedscore = maps\mp\gametypes\global\_global::addHUDClient(self, 36, 26, 2, (1,1,1), "left", "top", "left", "top");
	self.hud_axisscore = maps\mp\gametypes\global\_global::addHUDClient(self, 36, 48, 2, (1,1,1), "left", "top", "left", "top");

	// Splash /
	self.hud_alliedscorelimit = maps\mp\gametypes\global\_global::addHUDClient(self, 49, 26, 2, (1,1,1), "left", "top", "left", "top");
	self.hud_axisscorelimit = maps\mp\gametypes\global\_global::addHUDClient(self, 49, 48, 2, (1,1,1), "left", "top", "left", "top");


	// Hide for spectating players (each player has own hud element)
	self.hud_alliedicon.archived = false;
	self.hud_axisicon.archived = false;
	self.hud_alliedscore.archived = false;
	self.hud_axisscore.archived = false;
	self.hud_alliedscorelimit.archived = false;
	self.hud_axisscorelimit.archived = false;

	//self.hud_alliedscorelimit.label = (&"MP_SLASH");
	self.hud_alliedscorelimit.label = (&"/");
	//self.hud_axisscorelimit.label = (&"MP_SLASH");
	self.hud_axisscorelimit.label = (&"/");



	// Keep hidden until showScore is called
	self.hud_alliedicon.alpha = 0;
	self.hud_axisicon.alpha = 0;
	self.hud_alliedscore.alpha = 0;
	self.hud_axisscore.alpha = 0;
	self.hud_alliedscorelimit.alpha = 0;
	self.hud_axisscorelimit.alpha = 0;
}


fadeInAllHUD(animation)
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i] fadeInPlayerHUD(animation);
	}
}
fadeInPlayerHUD(animation)
{
	// Score is visible yet
	if (self.hud_alliedicon.alpha == 1)
		return;

	self.hud_alliedicon maps\mp\gametypes\global\_global::showHUDSmooth(animation);
	self.hud_axisicon maps\mp\gametypes\global\_global::showHUDSmooth(animation);
	self.hud_alliedscore maps\mp\gametypes\global\_global::showHUDSmooth(animation);
	self.hud_axisscore maps\mp\gametypes\global\_global::showHUDSmooth(animation);
	if (self.hud_alliedscorelimit.visible)
		self.hud_alliedscorelimit maps\mp\gametypes\global\_global::showHUDSmooth(animation);
	if (self.hud_axisscorelimit.visible)
		self.hud_axisscorelimit maps\mp\gametypes\global\_global::showHUDSmooth(animation);
}



fadeOutAllHUD(animation)
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i] fadeOutPlayerHUD(animation);
	}
}
fadeOutPlayerHUD(animation)
{
	// Hide only if score is disabled by players settings
	if(isEnabled())
		return;

	if (self.pers["team"] == "spectator" || self.pers["team"] == "streamer")
		return;

	// Score is hided yet
	if (self.hud_alliedicon.alpha == 0)
		return;

	self.hud_alliedicon maps\mp\gametypes\global\_global::hideHUDSmooth(animation);
	self.hud_axisicon maps\mp\gametypes\global\_global::hideHUDSmooth(animation);
	self.hud_alliedscore maps\mp\gametypes\global\_global::hideHUDSmooth(animation);
	self.hud_axisscore maps\mp\gametypes\global\_global::hideHUDSmooth(animation);
	if (self.hud_alliedscorelimit.visible)
		self.hud_alliedscorelimit maps\mp\gametypes\global\_global::hideHUDSmooth(animation);
	if (self.hud_axisscorelimit.visible)
		self.hud_axisscorelimit maps\mp\gametypes\global\_global::hideHUDSmooth(animation);
}




updatePlayerHUD()
{
	alliedscore = game["allies_score"];
	axisscore = game["axis_score"];

	if(alliedscore > axisscore)
		winningteam = "allies";
	else if(axisscore > alliedscore)
		winningteam = "axis";
	else
		winningteam = "tied";

	if(winningteam == "allies")
	{
		if(self.hud_alliedicon.y != 28)
			self.hud_alliedicon.y = 28;
		if(self.hud_alliedscore.y != 26)
			self.hud_alliedscore.y = 26;
	    if(self.hud_alliedscorelimit.y != 26)
	    	self.hud_alliedscorelimit.y = 26;
		if(self.hud_axisicon.y != 50)
			self.hud_axisicon.y = 50;
		if(self.hud_axisscore.y != 48)
			self.hud_axisscore.y = 48;
	    if(self.hud_axisscorelimit.y != 48)
	    	self.hud_axisscorelimit.y = 48;
	}
	else if(winningteam == "axis")
	{
		if(self.hud_axisicon.y != 28)
			self.hud_axisicon.y = 28;
		if(self.hud_axisscore.y != 26)
			self.hud_axisscore.y = 26;
	    if(self.hud_axisscorelimit.y != 26)
	    	self.hud_axisscorelimit.y = 26;
		if(self.hud_alliedicon.y != 50)
			self.hud_alliedicon.y = 50;
		if(self.hud_alliedscore.y != 48)
			self.hud_alliedscore.y = 48;
	    if(self.hud_alliedscorelimit.y != 48)
	    	self.hud_alliedscorelimit.y = 48;
	}

	self.hud_alliedscore setValue(alliedscore);
	self.hud_axisscore setValue(axisscore);

	//
	if(level.scorelimit > 0 && level.scr_show_scoreboard_limit)
	{
		self.hud_alliedscorelimit.x = getScoreLimitPosition(alliedscore);
		self.hud_axisscorelimit.x = getScoreLimitPosition(axisscore);
		self.hud_alliedscorelimit setValue(level.scorelimit);
		self.hud_axisscorelimit setValue(level.scorelimit);
		self.hud_alliedscorelimit.visible = true;
		self.hud_axisscorelimit.visible = true;
	}
	else
	{
		self.hud_alliedscorelimit.visible = false;
		self.hud_axisscorelimit.visible = false;
	}
}



getScoreLimitPosition(score)
{
	offset = 0;

	if(score < 0)
	{
		score = score * -1;
		offset = 7;
	}

	if(score >= 10000)
		offset += 40;
	else if(score >= 1000)
		offset += 28;
	else if(score >= 100)
		offset += 16;
	else if(score >= 10)
		offset += 10;

	return 49 + offset;
}