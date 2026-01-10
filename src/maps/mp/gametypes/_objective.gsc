
init()
{
	logprint("_objective::init\n");
	
    maps\mp\gametypes\global\_global::addEventListener("onConnected",     ::onConnected);
    maps\mp\gametypes\global\_global::addEventListener("onJoinedAlliesAxis",  ::onJoinedAlliesAxis);
    maps\mp\gametypes\global\_global::addEventListener("onSpawnedIntermission",  ::onSpawnedIntermission);

    level thread onTimeoutCalled();
    level thread onTimeoutCancel();
}

onConnected()
{
	logprint("_objective::onConnected start\n");
	self setPlayerObjective();
	logprint("_objective::onConnected end\n");
}

onJoinedAlliesAxis()
{
    self setPlayerObjective();
}

onSpawnedIntermission()
{
    self setPlayerObjective();
}

onTimeoutCalled()
{
    // Timeout can be called durring stratTime (SD) or in middle of the game (other gametypes) - so set correct objective text
    level waittill("running_timeout");
    level thread maps\mp\gametypes\_objective::setAllPlayersObjective();
}

onTimeoutCancel()
{
    // Timeout an be called in middle of the game - so after timeout we need to restore original objective text
    level waittill("timeoutover");
    level thread maps\mp\gametypes\_objective::setAllPlayersObjective();
}



setAllPlayersObjective() {
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i] setPlayerObjective();
	}
}

setPlayerObjective()
{
	wait 0.05;

	logprint("_objective::setPlayerObjective start\n");

	if (self.sessionstate == "intermission")
	{
		if (level.gametype != "dm")
		{
		        if(game["allies_score"] == game["axis_score"]) {
		    		text1 = &"MPSCRIPT_THE_GAME_IS_A_TIE";
					text2 = "@MPSCRIPT_THE_GAME_IS_A_TIE";
				} else if(game["allies_score"] > game["axis_score"]) {
		    		text1 = &"MPSCRIPT_ALLIES_WIN";
					text2 = "@MPSCRIPT_ALLIES_WIN";
				} else {
		    		text1 = &"MPSCRIPT_AXIS_WIN";
					text2 = "@MPSCRIPT_AXIS_WIN";
				}

			self setClientCvar("cg_objectiveText", text1);
			self setClientCvar("cg_objective", text2);
		}
		else
		{
			// In DM find player with highest score
			players = getentarray("player", "classname");
			winner = undefined;
			tied = false;
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				if(player.pers["team"] != "allies" && player.pers["team"] != "axis")
					continue;

				if(!isdefined(winner))
				{
					winner = players[i];
					continue;
				}

				if(player.score > winner.score)
				{
					tied = false;
					winner = players[i];
				}
				else if(player.score == winner.score)
					tied = true;
			}

			if(tied == true) {
				self setClientCvar("cg_objectiveText", &"MPSCRIPT_THE_GAME_IS_A_TIE");
				self setClientCvar("cg_objective", "@MPSCRIPT_THE_GAME_IS_A_TIE");
			} else if(isdefined(winner)) {
				self setClientCvar("cg_objectiveText", &"MPSCRIPT_WINS", winner);
				self setClientCvar("cg_objective", "@MPSCRIPT_WINS", winner);
			}
		}
		return;
	}

	if (level.in_timeout)
	{
		self setClientCvar("cg_objectiveText", game["STRING_READYUP_KEY_ACTIVATE_PRESS"]);
		self setClientCvar("cg_objective", "@" + game["STRING_READYUP_KEY_ACTIVATE_PRESS"]);
		return;
	}

	if (level.in_readyup)
	{
		logprint("3\n");
		if (level.aimTargets.size == 0)	{
			self setClientCvar("cg_objectiveText", game["STRING_READYUP_KEY_ACTIVATE_PRESS"] + "\n" + game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS"]);
			self setClientCvar("cg_objective", "@" + game["STRING_READYUP_KEY_ACTIVATE_PRESS"] + "\n" + game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS"]);
		} else {				
			self setClientCvar("cg_objectiveText", game["STRING_READYUP_KEY_ACTIVATE_PRESS"] + "\n" + game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS_TRAINER"] + "\n" + game["STRING_READYUP_KEY_MELEE_HOLD"]);
			self setClientCvar("cg_objective", "@" + game["STRING_READYUP_KEY_ACTIVATE_PRESS"] + "\n" + "@" + game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS_TRAINER"] + "\n" + game["STRING_READYUP_KEY_MELEE_HOLD"]);
		}
		return;
	}

	switch (level.gametype)
	{
		// case "ctf":
		// 	if(level.scorelimit > 0)
		// 		self setClientCvar("cg_objectiveText", &"MP_CTF_OBJ_TEXT", level.scorelimit);
		// 	else
		// 		self setClientCvar("cg_objectiveText", &"MP_CTF_OBJ_TEXT_NOSCORE");
		// 	break;
		case "dm":
			self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");
			self setClientCvar("cg_objective", "@DM_KILL_OTHER_PLAYERS");

			break;
		case "hq":
			self setClientCvar("cg_objectiveText", &"HQ_OBJ_TEXT", level.scorelimit);
			self setClientCvar("cg_objective", "@HQ_OBJ_TEXT", level.scorelimit);

			break;
		case "tdm":
			if(self.pers["team"] == "allies") {
				self setClientCvar("cg_objectiveText", &"TDM_KILL_AXIS_PLAYERS");
				self setClientCvar("cg_objective", "@TDM_KILL_AXIS_PLAYERS");
			} else if(self.pers["team"] == "axis") {
				self setClientCvar("cg_objectiveText", &"TDM_KILL_ALLIED_PLAYERS");
				self setClientCvar("cg_objective", "@TDM_KILL_ALLIED_PLAYERS");
			} else {
				self setClientCvar("cg_objectiveText", &"TDM_ALLIES_KILL_AXIS_PLAYERS");
				self setClientCvar("cg_objective", "@TDM_ALLIES_KILL_AXIS_PLAYERS");
			}

			break;
		case "sd":
			logprint("5\n");
			if (level.in_bash)
			{
				self setClientCvar("cg_objectiveText", "Eliminate your enemy, then choose side/map.");
				self setClientCvar("cg_objective", "Eliminate your enemy, then choose side/map.");
			}
			else
			{
				if(self.pers["team"] == game["attackers"]) {
					self setClientCvar("cg_objectiveText", &"SD_OBJ_ATTACKERS");
					self setClientCvar("cg_objective", "@SD_OBJ_ATTACKERS");
				} else if(self.pers["team"] == game["defenders"]) {
					self setClientCvar("cg_objectiveText", &"SD_OBJ_DEFENDERS");
					self setClientCvar("cg_objective", "@SD_OBJ_DEFENDERS");
				} else if(game["attackers"] == "allies") {
					self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_ALLIESATTACKING");
					self setClientCvar("cg_objective", "@SD_OBJ_SPECTATOR_ALLIESATTACKING");
				} else if(game["attackers"] == "axis") {
					self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_AXISATTACKING");
					self setClientCvar("cg_objective", "@SD_OBJ_SPECTATOR_AXISATTACKING");
				} else {
					self setClientCvar("cg_objectiveText", "Unknown SD objective");
					self setClientCvar("cg_objective", "Unknown SD objective");
				}
			}
			break;
		case "start":
			self setClientCvar("cg_objectiveText", "Special mode used for practicing grenades or smoke, strategic plan making, jump learning and overall game testing.");
			self setClientCvar("cg_objective", "Special mode used for practicing grenades or smoke, strategic plan making, jump learning and overall game testing.");
			break;
		default:
			// Empty
			self setClientCvar("cg_objectiveText", "Unknown objective description for " + level.gametype);
			self setClientCvar("cg_objective", "Unknown objective description for " + level.gametype);
			break;
	}

	logprint("_objective::setPlayerObjective end\n");
	return;
}