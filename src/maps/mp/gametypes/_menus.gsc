

init()
{
	logprint("_menus::init\n");
	
	maps\mp\gametypes\global\_global::addEventListener("onStartGameType", ::onStartGameType);
	maps\mp\gametypes\global\_global::addEventListener("onConnected",     ::onConnected);
	maps\mp\gametypes\global\_global::addEventListener("onMenuResponse",  ::onMenuResponse);
	maps\mp\gametypes\global\_global::addEventListener("onJoinedTeam",    ::onJoinedTeam);
}

// Called after the <gametype>.gsc::main() and <map>.gsc::main() scripts are called
// At this point game specific variables are defined (like game["allies"], game["axis"], game["american_soldiertype"], ...)
// Called again for every round in round-based gameplay
onStartGameType()
{
	if (!isDefined(game["menuPrecached"]))
	{
		game["menu_moddownload"] = "moddownload";
		game["menu_ingame"] = "ingame";
		game["menu_team"] = "team_" + game["allies"] + game["axis"];	// team_britishgerman
		game["menu_weapon_allies"] = "weapon_" + game["allies"];
		game["menu_weapon_axis"] = "weapon_" + game["axis"];
		//game["menu_weapon_rifles"] = "weapon_rifles";
		game["menu_serverinfo"] = "serverinfo_" + level.gametype;
		game["menu_callvote"] = "callvote";
		game["menu_exec_cmd"] = "exec_cmd";
		game["menu_start_recording"] = "startrecording_sd";
		game["menu_stop_recording"] = "stoprecording_sd";
		game["menu_quickcommands"] = "quickcommands";
		game["menu_quickstatements"] = "quickstatements";
		game["menu_quickresponses"] = "quickresponses";
		game["menu_quicksettings"] = "quicksettings";
		game["menu_mousesettings"] = "mousesettings";
		game["menu_scoreboard"] = "scoreboard_sd";
		//game["menu_streamersystem"] = "streamersystem";
		game["menu_strat_records"] = "strat_records";
		game["menu_viewmap"] = "viewmap";

		precacheMenu(game["menu_moddownload"]);
		precacheMenu(game["menu_ingame"]);
		precacheMenu(game["menu_team"]);
		precacheMenu(game["menu_weapon_allies"]);
		precacheMenu(game["menu_weapon_axis"]);
		//precacheMenu(game["menu_weapon_rifles"]);
		precacheMenu(game["menu_serverinfo"]);
		precacheMenu(game["menu_callvote"]);
		precacheMenu(game["menu_exec_cmd"]);
		precacheMenu(game["menu_start_recording"]);
		precacheMenu(game["menu_stop_recording"]);
		precacheMenu(game["menu_quickcommands"]);
		precacheMenu(game["menu_quickstatements"]);
		precacheMenu(game["menu_quickresponses"]);
		precacheMenu(game["menu_viewmap"]);
		
		//precacheMenu(game["menu_quicksettings"]);
		//precacheMenu(game["menu_mousesettings"]);
		precacheMenu(game["menu_scoreboard"]);
		//precacheMenu(game["menu_streamersystem"]);
		//precacheMenu(game["menu_strat_records"]);

		/*
		// Rifle mode use different menu for allies and axis
		if (level.scr_rifle_mode)
		{
			game["menu_weapon_allies"] = game["menu_weapon_rifles"];
			game["menu_weapon_axis"] = game["menu_weapon_rifles"];
		}
		*/

		/#
		game["menu_debugString"] = "debugString";
		precacheMenu(game["menu_debugString"]);
		#/

		game["menuPrecached"] = true;
	}
}

onConnected()
{
	logprint("_menus::onConnected start\n");
	scriptMainMenu = "";	// If ESC is pressed, open Main menu

	// If pam is not installed correctly
	if (level.pam_installation_error)
	{
		logprint("_menus:: pam installation error\n");
		// dont open any menu
	}

	// Open first menu that inform mod is downloaded
	
	else if (self maps\mp\gametypes\_force_download::waitingForResponse())
	{
		logprint("_menus:: open checkDownload\n");
		self thread maps\mp\gametypes\_force_download::checkDownload();
		// Open menu that invoke cmd scriptmenuresponse
		self openMenu(game["menu_moddownload"]);
		scriptMainMenu = game["menu_moddownload"];
	}

	// Mod is not downloaded for sure
	else if (self maps\mp\gametypes\_force_download::modIsNotDownloadedForSure())
	{
		logprint("_menus:: modIsNotDownloadedForSure\n");
		// dont open any menu
	}
	

	// Server info wasnt skiped yet - player didnt click "continue"
	else if(!isDefined(self.pers["skipserverinfo"]))
	{
		logprint("_menus:: updateServerInfo\n");
		scriptMainMenu = game["menu_serverinfo"];
		self openMenu(game["menu_serverinfo"]);
		self maps\mp\gametypes\_menu_serverinfo::updateServerInfo();
	}

	else if (game["state"] == "intermission")
	{
		logprint("_menus:: intermission\n");
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_allow_weaponchange", 0);
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_allow_changeteam", 0);
		scriptMainMenu = game["menu_ingame"];	// default
		//scriptMainMenu = game["menu_team"];
	}

	// Player did not choose team yet after connect
	else if (!isDefined(self.pers["firstTeamSelected"]))
	{
		logprint("_menus:: player didnt choose team yet after connect\n");
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_allow_changeteam", 1);
		scriptMainMenu = game["menu_team"]; // when esc is pressed, show menu with teams
		self openMenu(game["menu_team"]); // else open team menu
	}

	// If team is selected
	else if (self.pers["team"] == "allies" || self.pers["team"] == "axis")
	{
		logprint("_menus:: team selected\n");
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_allow_weaponchange", 1);

		// If player have team, but not choozen weapon
		if(self.pers["team"] == "allies")
		{
			scriptMainMenu = game["menu_weapon_allies"];
		}
		else if(self.pers["team"] == "axis")
		{
			scriptMainMenu = game["menu_weapon_axis"];
		}
		if(!isDefined(self.pers["weapon"]))
		{
			self openMenu(scriptMainMenu);
		}
		//else // in team and with weapon
		//{
			// logprint("_menus:: in a team and with weapon\n");
			// scriptMainMenu = game["menu_ingame"];
			/*
			if(self.pers["team"] == "allies")
			{
				scriptMainMenu = game["menu_weapon_allies"];
			}
			else if(self.pers["team"] == "axis")
			{
				scriptMainMenu = game["menu_weapon_axis"];
			}
			*/
		// }
	}
	else // spectator
	{
		logprint("_menus:: spectator\n");
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_allow_weaponchange", 0);
		scriptMainMenu = game["menu_ingame"];	// default
		//scriptMainMenu = game["menu_team"];
	}

	logprint("_menus::onConnected: setting g_scriptMainMenu to " + scriptMainMenu + "\n");
	self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", scriptMainMenu);

	if (isDefined(self.pers["firstTeamSelected"])) 
	{
		logprint("_menus:: firstTeamSelected is defined - allowVote\n");
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_allowVote", level.allowvote);
	}
	logprint("_menus::onConnected end\n");
}

onJoinedTeam(team)
{
	logprint("_menus:: onJoinedTeam(" + team + ")\n");
	
	self.pers["firstTeamSelected"] = true;


	if (team == "allies" || team == "axis")
	{
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_allow_weaponchange", "1");
	}
	else
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_allow_weaponchange", "0");



	if(team == "allies")
	{
		logprint("_menus:: openMenu weapon alies\n");
		self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", game["menu_weapon_allies"]);
		self openMenu(game["menu_weapon_allies"]);
	}
	else if (team == "axis")
	{
		logprint("_menus:: openMenu weapon axis\n");
		self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", game["menu_weapon_axis"]);
		self openMenu(game["menu_weapon_axis"]);
	}
	else if (team == "spectator" || team == "streamer")
	{
		logprint("_menus:: openMenu spec/streamer\n");
		self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", game["menu_ingame"]);
		//self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", game["menu_team"]);
	}

	self maps\mp\gametypes\global\_global::setClientCvar2("ui_allowVote", level.allowvote);
}

/*
Called when command scriptmenuresponse is executed on client side
self is player that called scriptmenuresponse
Return true to indicate that menu response was handled in this function
*/
onMenuResponse(menu, response)
{
	logprint("_menus:: onMenuResponse start with menu=" + menu + ", response=" + response + " for player name " + self.name + "\n");
	//logprint("_menus:: g_scriptMainMenu=" + getCvar("g_scriptMainMenu") + "\n");
	
	// Pam is not installed correctly, ignore other responses
	if (level.pam_installation_error)
	{
		logprint("_menus:: pam_installation_error at onMenuResponse\n");
		return true;
	}

	if (menu == "-1" && (response == "autoassign" || response == "allies" || response == "axis" || response == "spectator" || response == "streamer")) {
		menu = game["menu_team"];
	}

	
	// Mod is not downloaded, ignore other responses
	if (maps\mp\gametypes\_force_download::modIsNotDownloadedForSure())
		return true;

	// Not downloaded yet and still listening
	if(menu == game["menu_moddownload"] && response == "moddownloaded" && maps\mp\gametypes\_force_download::waitingForResponse())
	{
		logPrint("mod is downloaded!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
		maps\mp\gametypes\_force_download::modIsDownloaded();
		logPrint("mod is downloaded DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
		// Open server info
		self closeMenu();
		//self closeInGameMenu();
		self openMenu(game["menu_serverinfo"]);
		self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", game["menu_serverinfo"]);
		self maps\mp\gametypes\_menu_serverinfo::updateServerInfo();

		if (game["state"] != "intermission")
			self maps\mp\gametypes\global\_global::setClientCvar2("ui_allow_changeteam", 1);
		
		return true;
	}
	/*
	else if (self.pers["isBot"] && menu == game["menu_moddownload"] && response == "moddownloaded")
	{
		logprint("bot downlaoded the mod obviously...\n");
		return true;
	}
	*/
	

	else if(menu == game["menu_serverinfo"] && response == "close")
	{
		logprint("_menus:: menu_serverinfo and close at onMenuResponse\n");
		self closeMenu();
		//self closeInGameMenu();

		if (!isDefined(self.pers["skipserverinfo"]))	// first time
		{
			logprint("_menus:: skipserverinfo not defined\n");
			// After serverinfo is skipped, show menu with teams
			self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", game["menu_team"]);
			self openMenu(game["menu_team"]);
		}
		else if (!isDefined(self.pers["firstTeamSelected"])) {
			logPrint("_menus:: firstTeamSelected not defined\n");
			self openMenu(game["menu_team"]);
		}
		else {
			logPrint("_menus:: should open menu_ingame\n");
			self openMenu(game["menu_ingame"]); // serverinfo may be opened and closed aditionally via menu
		}
		//self openMenu(game["menu_team"]);

		self.pers["skipserverinfo"] = true;

		return true;
	}

	/*
	if(response == "open" || response == "close")
	{
		logPrint("_menus:: response is open || close: " + response + "\n");
		return true;
	}
	*/

	if(response == "back")
	{
		logprint("_menus:: response back at onMenuResponse\n");
		self closeMenu();
		//self closeInGameMenu();

		
		if(menu == game["menu_team"])
			self openMenu(game["menu_ingame"]);
		else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
			self openMenu(game["menu_team"]);
		
		//if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
			//self openMenu(game["menu_team"]);

		return true;
	}
	
	/*
	if (response == "team")
	{
		logprint("_menus:: response team at onMenuResponse\n");
		self closeMenu();
		self openMenu(game["menu_team"]);
		
		return true;
	}
	*/

	logPrint("_menus_onMenuResponse:: menu==" + menu + "\n");

	if(menu == game["menu_ingame"])
	{
		if (response == "changeweapon" && game["state"] != "intermission")
		{
			//self closeMenu();
			//self closeInGameMenu();
			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else if(self.pers["team"] == "axis")
				self openMenu(game["menu_weapon_axis"]);
			return true;
		}
		if (response == "changeteam" && game["state"] != "intermission")
		{
			//self closeMenu();
			//self closeInGameMenu();
			self openMenu(game["menu_team"]);
			return true;
		}
		if (response == "serverinfo")
		{
			self closeMenu();
			//self closeInGameMenu();
			self openMenu(game["menu_serverinfo"]);
			self maps\mp\gametypes\_menu_serverinfo::updateServerInfo();
			return true;
		}
		if (response == "viewmap")
		{
			logprint("_menus:: at menu_ingame and viewmap\n");
			//self closeMenu();
			self openMenu(game["menu_viewmap"]);
			return true;
		}
		if (response == "callvote")
		{
			self closeMenu();
			//self closeInGameMenu();
			self openMenu(game["menu_callvote"]);
			return true;
		}
	}

	else if(menu == game["menu_team"] && game["state"] != "intermission")
	{
		logprint("_menus:: choosing menu_team and it's not an intermission at onMenuResponse, response=" + response + "\n");
		teamBefore = self.pers["team"];
		switch(response)
		{
		case "allies":
			self closeMenu();
			//self closeInGameMenu();
			self [[level.allies]]();
			if(self.pers["team"] != teamBefore)
				self thread printTeamChanged(&"MPSCRIPT_JOINED_ALLIES", self.name);
			break;

		case "axis":
			self closeMenu();
			//self closeInGameMenu();
			self [[level.axis]]();
			if(self.pers["team"] != teamBefore)
				self thread printTeamChanged(&"MPSCRIPT_JOINED_AXIS", self.name);
			break;

		case "autoassign":
			self closeMenu();
			//self closeInGameMenu();
			self [[level.autoassign]]();
			if(self.pers["team"] != teamBefore) {
				if(self.pers["team"] == "allies")
					self thread printTeamChanged(&"MPSCRIPT_JOINED_ALLIES", self.name);
				else if(self.pers["team"] == "axis")
					self thread printTeamChanged(&"MPSCRIPT_JOINED_AXIS", self.name);
			}
			break;

		case "spectator":
			self closeMenu();
			//self closeInGameMenu();
			self [[level.spectator]]();
			if(self.pers["team"] != teamBefore)
				self thread printTeamChanged(self.name + " Joined Spectators", "");
			break;

		case "streamer":
			if (maps\mp\gametypes\_streamer::isStreamerLimitReached())
			{
				self openMenu(game["menu_team"]);
				self thread printTeamChanged(self.name + " Streamer limit reached", "");
			}
			else
			{
				self closeMenu();
				//self closeInGameMenu();
				self [[level.streamer]]();
				if(self.pers["team"] != teamBefore)
					self thread printTeamChanged(self.name + " Joined as Streamer", "");
			}
			break;
		case "viewmap":
			logprint("_menus:: at menu_team and viewmap\n");
			//self closeMenu();
			self openMenu(game["menu_viewmap"]);
			break;
		/*
		case "options":
			self closeMenu();
			//self closeInGameMenu();
			self openMenu(game["menu_ingame"]);
			break;
		*/
		}

		return true;
	}
	else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
	{
		if (response == "ingame")
		{
			logPrint("_menus:: choosing menu_weapon response=" + response + " - opening ingame menu\n");
			self closeMenu();
			self openMenu(game["menu_ingame"]);
			return true;
		}
		if (response == "open" || response == "close") 
		{
			logPrint("_menus:: choosing menu_weapon response=" + response + " - ignoring\n");
			return true;
		}

		logprint("_menus:: choosing weapon " + response + " at onMenuResponse\n");
		self closeMenu();
		//self closeInGameMenu();
		self [[level.weapon]](response);
		return true;
	}
	else if(menu == game["menu_quickcommands"])
	{
		logprint("_menus:: quickcommands at onMenuResponse\n");
		maps\mp\gametypes\_quickmessages::quickcommands(response);
		return true;
	}
	else if(menu == game["menu_quickstatements"])
	{
		logprint("_menus:: quickstatements at onMenuResponse\n");
		maps\mp\gametypes\_quickmessages::quickstatements(response);
		return true;
	}
	else if(menu == game["menu_quickresponses"])
	{
		logprint("_menus:: quickresponses at onMenuResponse\n");
		maps\mp\gametypes\_quickmessages::quickresponses(response);
		return true;
	}

	if (menu == -1 && response == "viewmap")
	{
		logprint("_menus:: -1 and viewmap at onMenuResponse\n");
		//self closeMenu();
		self openMenu(game["menu_viewmap"]);
		return true;
	}
}

printTeamChanged(text, name) {
	self endon("disconnect");

	wait level.frame;
	iprintln(text, name);
}