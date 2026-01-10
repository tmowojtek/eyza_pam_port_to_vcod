/*
  rPAMext Version: v19 (kvcodPAM v2.10)     

  Changes:

  - rFIX_HLSW-CVAR-PLAYER-ERROR : Executing this code when joining a server causes an error (Global server cvars visible via HLSW).
  - v23 old: player UpdatePlayerCvars();
  - v24 new code
  - v210 added line: if (isDefined(game["readyup_first_run_ending_for_matchinfo"]) && game["readyup_first_run_ending_for_matchinfo"])


*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
First we need to determine wich team will be first
 - do this by saving information who connect to this server first - his team will be first
 - we will save time when player connect to the server

Procces is splited to 2 parts
 - 1. Readyup - in this period team names are not fixed and info may be refrshed according to connecting players
 - 2. Match start - in this part team names will be saved and will not refresh

Player names cannot be changed too much during match, othervise match info will reset

*/
init()
{
// Log
	logprint("_matchinfo::init\n");

// Register	
	maps\mp\gametypes\global\_global::addEventListener("onCvarChanged", ::onCvarChanged);

	maps\mp\gametypes\global\_global::registerCvar("scr_matchinfo", "INT", 0, 0, 2);					// level.scr_matchinfo
	maps\mp\gametypes\global\_global::registerCvarEx("I", "scr_matchinfo_reset", "BOOL", 0);

	maps\mp\gametypes\global\_global::addEventListener("onConnected",     ::onConnected);

	// Save value of scr_matchinfo for entire map (if cvar scr_matchinfo is changed during match, it makes no effect until map change)
//cod2
//	firstMapRestart = false;
	if (!isDefined(game["scr_matchinfo"]))
//	{
		game["scr_matchinfo"] = level.scr_matchinfo;
//		firstMapRestart = true;
//	}
//	if (!isDefined(game["scr_matchinfo"]))
//v26	game["scr_matchinfo"] = level.scr_matchinfo;

// Matchinfo cannot working without readyup...
	if (!level.scr_readyup)
		game["scr_matchinfo"] = 0;


	if (!isDefined(game["match_teams_set"]))
	{
		game["match_exists"] = false;
		game["match_teams_set"] = false;

		game["match_team1_name"] = "";
		game["match_team1_score"] = "";
		game["match_team1_side"] = "";
		game["match_team2_name"] = "";
		game["match_team2_score"] = "";
		game["match_team2_side"] = "";

		game["match_totaltime_text"] = "";

		game["match_round"] = "";
//2		game["match_state"] = "";
	}

//2	level.match_description = "";
//2	level.match_description_players1 = "";
//2	level.match_description_players2 = "";
//2	level.match_description_playersUnknown = "";
//2	level.match_missingPlayers = 0;
//2	level.match_mixedPlayers = 0;
//2	level.match_unjoinedPlayers = 0;

// Matchinfo not possible, exit here
	if (game["scr_matchinfo"] == 0)
		return;

// Once match start, save teams
	if (!level.in_readyup)
	{
		game["match_exists"] = true;
		game["match_teams_set"] = true;
	}
//2	
//2	addEventListener("onConnecting",   ::onConnecting);
//2	addEventListener("onDisconnect",   ::onDisconnect);
//2	addEventListener("onStopGameType", ::onStopGameType);
//2	addEventListener("onJoinedTeam",   ::onJoinedTeam);
//2	addEventListener("onSpawned",      ::onSpawned);
//2	thread onReadyupOver();

//2	level thread refresh(firstMapRestart);

//addEventListener cod1
	maps\mp\gametypes\global\_global::addEventListener("onJoinedTeam",        ::onJoinedTeam);

	level thread refresh();
}

//ADDED_ZPAM400T3_prepareMap()
/*
prepareMap()
{
// Save data from previous map
	team1_winnedMaps = int(matchGetData("team1_winnedMaps")); // number of maps winned by team 1
	team2_winnedMaps = int(matchGetData("team2_winnedMaps")); // number of maps winned by team 2
	finishedMapsCount = int(matchGetData("finishedMapsCount")); // number of played maps
	finishedMap1 = matchGetData("finishedMap1");
	finishedMap2 = matchGetData("finishedMap2");
	finishedMap3 = matchGetData("finishedMap3");
	finishedMap4 = matchGetData("finishedMap4");
	finishedMap5 = matchGetData("finishedMap5");

// Clear data from previous map
	matchClearData();

// Restore data from previous map
	matchSetData("team1_winnedMaps", team1_winnedMaps);
	matchSetData("team2_winnedMaps", team2_winnedMaps);
	matchSetData("finishedMapsCount", finishedMapsCount);
	if (finishedMap1 != "") matchSetData("finishedMap1", finishedMap1);
	if (finishedMap2 != "") matchSetData("finishedMap2", finishedMap2);
	if (finishedMap3 != "") matchSetData("finishedMap3", finishedMap3);
	if (finishedMap4 != "") matchSetData("finishedMap4", finishedMap4);
	if (finishedMap5 != "") matchSetData("finishedMap5", finishedMap5);

// Dont upload data on new map until RUP
//uploadMatchData(false, true);
}
*/
//ADDED_ZPAM400T3_finishMap()
/*
finishMap()
{
	// Load data from previous map
	team1_winnedMaps = int(matchGetData("team1_winnedMaps")); // 0 if not defined
	team2_winnedMaps = int(matchGetData("team2_winnedMaps")); // 0 if not defined
	finishedMapsCount = int(matchGetData("finishedMapsCount")); // 0 if not defined
	finishedMap1 = matchGetData("finishedMap1");
	finishedMap2 = matchGetData("finishedMap2");
	finishedMap3 = matchGetData("finishedMap3");
	finishedMap4 = matchGetData("finishedMap4");
	finishedMap5 = matchGetData("finishedMap5");

	// Update data
	finishedMapsCount++;
	team1_score = int(game["match_team1_score"]);
	team2_score = int(game["match_team2_score"]);
	if (team1_score > team2_score) {
		team1_winnedMaps++;
	} else if (team2_score > team1_score) {
		team2_winnedMaps++;
	}

	// Save data
	matchSetData("team1_winnedMaps", team1_winnedMaps);
	matchSetData("team2_winnedMaps", team2_winnedMaps);
	matchSetData("finishedMapsCount", finishedMapsCount);
	switch(finishedMapsCount) {
		case 1: matchSetData("finishedMap1", level.mapname); break;
		case 2: matchSetData("finishedMap2", level.mapname); break;
		case 3: matchSetData("finishedMap3", level.mapname); break;
		case 4: matchSetData("finishedMap4", level.mapname); break;
		case 5: matchSetData("finishedMap5", level.mapname); break;
	}

	// Upload match data to master server
	uploadMatchData("finishMap", false, false);
}
*/
//ADDED_ZPAM400T3_endMap()
/*
endMap()
{
	team1_winnedMaps = int(matchGetData("team1_winnedMaps")); // 0 if not defined
	team2_winnedMaps = int(matchGetData("team2_winnedMaps")); // 0 if not defined
	format = matchGetData("format"); // BO1, BO3, BO5 (defined by CoD2x)
	
	matchFinished = false;
	switch (format) {
		default:
		case "BO1":
			matchFinished = true;
			break;
		case "BO3":
			if (team1_winnedMaps >= 2 || team2_winnedMaps >= 2)
				matchFinished = true;
			break;
		case "BO5":
			if (team1_winnedMaps >= 3 || team2_winnedMaps >= 3)
				matchFinished = true;
			break;
	}

	if (matchFinished) {
		matchFinish(); // kick all players, cancel match, fast_restart

	} else {
		maps = matchGetData("maps"); // might be empty

		// Maps are defined
		if (maps.size > 0) {
			// Collect finished maps into an array
			finishedMaps = [];
			finishedMap1 = matchGetData("finishedMap1");  if (finishedMap1 != "") finishedMaps[finishedMaps.size] = finishedMap1;
			finishedMap2 = matchGetData("finishedMap2");  if (finishedMap2 != "") finishedMaps[finishedMaps.size] = finishedMap2;
			finishedMap3 = matchGetData("finishedMap3");  if (finishedMap3 != "") finishedMaps[finishedMaps.size] = finishedMap3;
			finishedMap4 = matchGetData("finishedMap4");  if (finishedMap4 != "") finishedMaps[finishedMaps.size] = finishedMap4;
			finishedMap5 = matchGetData("finishedMap5");  if (finishedMap5 != "") finishedMaps[finishedMaps.size] = finishedMap5;

			// Find the first unplayed map in the maps array
			nextMap = "";
			for (i = 0; i < maps.size; i++) {
				isPlayed = false;
				for (j = 0; j < finishedMaps.size; j++) {
					if (maps[i] == finishedMaps[j]) {
						isPlayed = true;
						break;
					}
				}
				if (!isPlayed) {
					nextMap = maps[i];
					break;
				}
			}

			// If all maps are played, fallback to first map
			if (nextMap == "" && maps.size > 0) {
				nextMap = maps[0];
			}

			map(nextMap, false);
		
		// Maps not defined, let players decide
		} else {		
			map_restart(false); // fast_restart
		}
	}
}
*/
//ADDED_ZPAM400T3_canMapBeChanged()
/*
canMapBeChanged()
{
	if (matchIsActivated()) {

		maps = matchGetData("maps"); // might be empty

		allow = true;

		// Maps are defined, cod2x set them into map_rotation, so disable map change / restart
		if (maps.size > 0) {
			allow = false;

		// Maps are not defined, allow match change before first round ends
		} else {	
			switch(level.gametype) {
				case "sd":				
					if (game["state"] == "playing" && // will be false on interrmission when we want to allow map change
						!game["readyup_first_run"] && // allow change in first readyup
						(game["allies_score"] > 0 || game["axis_score"] > 0) // allow change if score is 0:0 (so in first round its still possible to change))
					) {
						allow = false;
					}
					break;
				case "dm":
					if (game["state"] == "playing" && // will be false on interrmission when we want to allow map change
						!game["readyup_first_run"] // allow change in first readyup
					) {
						allow = false;
					}
					break;
			}
		}

		if (!allow) {
			iprint_to_team_players("^1Map change / restart is disabled during match!");
			return false; // prevent map change / restart
		}
	}
	return true;
}
*/
//ADDED_ZPAM400T3_onStopGameType()
/*
// Called by code before map change, map restart, or server shutdown.
//  fromScript: true if map change was triggered from a script, false if from a command.
//  bComplete: true if map change or restart is complete, false if it's a round restart so persistent variables are kept.
//  shutdown: true if the server is shutting down, false otherwise.
//  source: "map", "fast_restart", "map_restart", "map_rotate", "shutdown"
onStopGameType(fromScript, bComplete, shutdown, source) {

	// Disable map change (if called via command, rcon for example)
	if (fromScript == false && shutdown == false)
	{
		if (!canMapBeChanged())
			return false; // prevent map change / restart
	}
}
*/
//ADDED_ZPAM400T3_uploadMatchData()
/*
uploadMatchData(debug, printSuccess, printError)
{
	if (!matchIsActivated()) {
		return;
	}

	team1_score = "0";
	team2_score = "0";
	if (isDigitalNumber(game["match_team1_score"]))
		team1_score = game["match_team1_score"];
	if (isDigitalNumber(game["match_team2_score"]))
		team2_score = game["match_team2_score"];

	state = "playing";
	if (game["state"] == "intermission") {
		state = "finished";
	}

	// Set global data
	matchSetData(
		"team1_score", team1_score,
		"team2_score", team2_score,
		"map", level.mapname,
		"round", game["match_round"],
		"state", state,
		"debug", debug
	);

	// Set player data
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		stats = player maps\mp\gametypes\_player_stat::getStats();
		if (!isDefined(stats)) continue;
		
		if (level.gametype == "sd") {

			player matchPlayerSetData(
				"score", 	format_fractional(stats["score"], 1, 1),
				"kills", 	stats["kills"],
				"assists", 	stats["assists"],
				"damage", 	format_fractional(stats["damage"] / 100, 1, 1),
				"deaths", 	stats["deaths"],
				"grenades", stats["grenades"],
				"plants", 	stats["plants"],
				"defuses", 	stats["defuses"]
			);
		} else if (level.gametype == "dm") {
			player matchPlayerSetData(
				"score", 	format_fractional(stats["score"], 1, 1),
				"kills", 	stats["kills"],
				"deaths", 	stats["deaths"]
			);
		} else {
			player matchPlayerSetData(
				"score", 	player.score,
				"deaths", 	player.deaths
			);
		}
	}

	// Start upload
	if (printSuccess && printError)
		matchUploadData(::matchUploadDone, ::matchUploadError);
	else if (printSuccess)
		matchUploadData(::matchUploadDone, ::matchUploadErrorVoid);
	else if (printError)
		matchUploadData(::matchUploadDoneVoid, ::matchUploadError);
	else
		matchUploadData();

}
*/
//ADDED_ZPAM400T3_uploadMatchData()
/*
matchUploadDoneVoid()
{
	iprint_to_team_players("^5MatchV data uploaded successfully.);
}

matchUploadDone()
{
	iprint_to_team_players("^2Match data uploaded successfully.");
}

matchUploadErrorVoid()
{
	iprint_to_team_players("^6ErrorV uploading match data: " + error");
}

matchUploadError(error)
{
	iprint_to_team_players("^1Error uploading match data: " + error);
}
*/


// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	switch(cvar)
	{
		case "scr_matchinfo": level.scr_matchinfo = value; return true;
		case "scr_matchinfo_reset":
		{
			if (value == 1)
			{
// LOG
				logprint("_matchinfo::onCvarChanged before clear\n");
				clear();
// LOG
				logprint("_matchinfo::onCvarChanged after clear\n");
				iprintln("Info about teams was cleared via rcon.");

				maps\mp\gametypes\global\_global::changeCvarQuiet(cvar, 0);
			}
			return true;
		}
		//
	}
	return false;
}

//ADDED_ZPAM400T3_onConnecting(firstTime)
/*
onConnecting(firstTime)
{
	self endon("disconnect");

	// Redownload match data when player is connecting to allow connect host that was added to team while match was already in progress
	if (matchIsActivated() && firstTime)
	{

		// Make sure redownload is called only once in short period of time
		level notify("matchinfo_data_redownload");
		level endon("matchinfo_data_redownload");

		wait level.fps_multiplier * 1;
		
		matchRedownloadData();
	}
}
*/
//ADDED_ZPAM400T3_iprint_to_team_players(text)
/*
iprint_to_team_players(text)
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if (isDefined(player.pers["team"]) && player.pers["team"] != "streamer")
		{
			player iPrintLn(text);
		}
	}
}
*/

onConnected()
{
// LOG
	logprint("_matchinfo::onConnected start\n");
	
// Endon
	self endon("disconnect");

// Ingame match info bar
	if (!isDefined(self.pers["matchinfo_ingame"]))
	{
		// By default show match info ingame
		self.pers["matchinfo_ingame"] = false;
		self.pers["matchinfo_ingame_visible"] = false;
//2		self.pers["matchinfo_matchDataWarningShowed"] = false;
//2		self.pers["matchinfo_nickWarningLastTime"] = 0;
//2		self.pers["matchinfo_error"] = "";
//2		self.pers["matchinfo_color"] = "";
//2
//2		// Show warning about unknown player
//2		if (matchIsActivated())
//2		{
//2			if (self matchPlayerIsAllowed() == false) {
//2				if (self matchPlayerGetData("uuid") == "")
//2					iprint_to_team_players(self.name + "^1 is not logged into the match!");
//2				else
//2					iprint_to_team_players(self.name + "^1 is not assigned to any team!");
//2			} else {
//2				//iprint_to_team_players(self.name + "^7's name: " + self matchPlayerGetData("name"));
//2				//iprint_to_team_players(self.name + "^7's team: " + self matchPlayerGetData("team_name"));
//2			}
//2		}
	}

//2	level thread generateMatchDescriptionDebounced();

	if (game["scr_matchinfo"] > 0)
	{
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_matchinfo_show", "1");

		if (!isDefined(self.pers["timeConnected"]))
		{
			self.pers["timeConnected"] = getTime();
		}

		if (game["scr_matchinfo"] == 2)
		{
			//waittillframeend;
			wait 0.05;
			// Update team names in scoreboard
//2			self updateScoreboardTeamNames();
			self updateTeamNames();
		}
	}
	else
	{
		wait level.fps_multiplier * 0.2;
		self maps\mp\gametypes\global\_global::setClientCvar2("ui_matchinfo_show", "0");
	}
// LOG
	logprint("_matchinfo::onConnected end\n");
}

////////////end cod2 transfer
onJoinedTeam(teamName)
{
	// Always hide ingame menu for streamer as they have own menu
	if (teamName == "streamer")
	{
		self ingame_hide();
	}
	else
	{
		if (ingame_isEnabled())
			ingame_show();
	}
}





// Settings
ingame_isEnabled()
{
  return isDefined(self.pers["matchinfo_ingame"]) && self.pers["matchinfo_ingame"];
}

ingame_enable()
{
	self.pers["matchinfo_ingame"] = true;
	ingame_show();
}

ingame_disable()
{
	self.pers["matchinfo_ingame"] = false;
	ingame_hide();
}

ingame_toggle()
{
	// Toggle settings
	if (ingame_isEnabled() || self.pers["matchinfo_ingame_visible"]) // If is visible for spectator and "Hide in game" is clicked
		ingame_disable();
	else
		ingame_enable();
}

// Show match info ingame menu elements in hud menu
ingame_show()
{
	logPrint("ingame_show\n");
	if (!self.pers["matchinfo_ingame_visible"] && self.pers["team"] != "streamer") // Always hide ingame menu for streamer as they have own menu
	{
		self.pers["matchinfo_ingame_visible"] = true;
		if (game["scr_matchinfo"] > 0)
		{
			self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_ingame_show", "1");
			self thread UpdatePlayerCvars();
		}
	}
}

// Hide match info ingame menu elements in hud menu
ingame_hide()
{
	logPrint("ingame_hide\n");
	//if (self.pers["matchinfo_ingame_visible"])
	{
		self.pers["matchinfo_ingame_visible"] = false;
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_ingame_show", "0");
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_ingame_team1_team", 	""); // bg elements cannot be dependend on _show cvar, needs to be set separately
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_ingame_team2_team", 	"");
		if (game["scr_matchinfo"] > 0)
			self thread UpdatePlayerCvars();
	}
}



updateTeamNames()
{
	//logprint("_matchinfo::updateTeamNames start\n");
	//println("##updateTeamNames:"+game["match_team1_name"]);

	teamname_allies = game["match_team1_name"];
	teamname_axis = game["match_team2_name"];
	if (game["match_team1_side"] == "axis")
	{
		teamname_allies = game["match_team2_name"];
		teamname_axis = game["match_team1_name"];
	}


	if (teamname_allies != "")
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("g_TeamName_Allies", teamname_allies);
	else
	{
		alliesDef = "";
		switch(game["allies"])
		{
			case "american": alliesDef = "MPSCRIPT_AMERICAN"; break;
			case "british":  alliesDef = "MPSCRIPT_BRITISH"; break;
			case "russian":  alliesDef = "MPSCRIPT_RUSSIAN"; break;
		}
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("g_TeamName_Allies", alliesDef);
	}

	if (teamname_axis != "")
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("g_TeamName_Axis", teamname_axis);
	else
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("g_TeamName_Axis", "MPSCRIPT_GERMAN");

	//logprint("_matchinfo::updateTeamNames end\n");
}



processPreviousMapToHistory()
{
	prevMap_map = getCvar("sv_map_name");

	// If prev map is defined, it means match started and this score needs to be saved
	if (prevMap_map != "")
	{
		// Move 2. saved map to 3. (removing the third)
		setCvar("sv_map3_name", 	getCvar("sv_map2_name"));
		setCvar("sv_map3_team1", 	getCvar("sv_map2_team1"));
		setCvar("sv_map3_team2", 	getCvar("sv_map2_team2"));
		setCvar("sv_map3_score1", 	getCvar("sv_map2_score1"));
		setCvar("sv_map3_score2", 	getCvar("sv_map2_score2"));

		// Move 1. saved map to 2. (removing the second)
		setCvar("sv_map2_name", 	getCvar("sv_map1_name"));
		setCvar("sv_map2_team1", 	getCvar("sv_map1_team1"));
		setCvar("sv_map2_team2", 	getCvar("sv_map1_team2"));
		setCvar("sv_map2_score1", 	getCvar("sv_map1_score1"));
		setCvar("sv_map2_score2", 	getCvar("sv_map1_score2"));

		// Save previous map to history at first location
		setCvar("sv_map1_name", prevMap_map);
		setCvar("sv_map1_team1", getCvar("sv_map_team1"));
		setCvar("sv_map1_team2", getCvar("sv_map_team2"));
		setCvar("sv_map1_score1", getCvar("sv_map_score1"));
		setCvar("sv_map1_score2", getCvar("sv_map_score2"));

		// remove prev map info
		setCvar("sv_map_name", "");
		setCvar("sv_map_team1", "");
		setCvar("sv_map_team2", "");
		setCvar("sv_map_score1", "");
		setCvar("sv_map_score2", "");
	}
}


refreshTeamNames()
{
	// Generate allies and axis team names
	// Generate team names according to player names
	wait level.fps_multiplier * 0.2;
	maps\mp\gametypes\_teamname::refreshTeamName("allies"); // will update level.teamname_allies
	wait level.fps_multiplier * 0.2;
	maps\mp\gametypes\_teamname::refreshTeamName("axis"); // will update level.teamname_axis
	wait level.frame;
}


determineTeamByHistoryCvars()
{
	refreshTeamNames();

	// Fill team names
	game["match_team1_name"] = getCvar("sv_match_team1");
	game["match_team2_name"] = getCvar("sv_match_team2");

	// Find that side that team is now
	// Atleast one team must stay unrenamed or this will not work
	if (game["match_team1_name"] == level.teamname_allies || game["match_team2_name"] == level.teamname_axis)
	{
		game["match_team1_side"] = "allies";
		game["match_team2_side"] = "axis";
	}
	else if (game["match_team2_name"] == level.teamname_allies || game["match_team1_name"] == level.teamname_axis)
	{
		game["match_team1_side"] = "axis";
		game["match_team2_side"] = "allies";
	}
	else
	{
		game["match_team1_side"] = "";
		game["match_team2_side"] = "";
	}
}

determineTeamByFirstConnected()
{
	refreshTeamNames();

	// Find first team by looking wich player connect
	players = getentarray("player", "classname");
	firstPlayer = undefined;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if (isDefined(player.pers["team"]) && (player.pers["team"] == "allies" || player.pers["team"] == "axis") &&
			(!isDefined(firstPlayer) || player.pers["timeConnected"] < firstPlayer.pers["timeConnected"]))
			firstPlayer = player;
	}

	// Fill team 1
	teamname1 = "";
	team1 = "allies";
	if (isDefined(firstPlayer))
	{
		teamname1 = level.teamname[firstPlayer.pers["team"]];
		team1 = firstPlayer.pers["team"];
	}
	// Fill team 2
	team2 = "axis";
	if (team1 == "axis")
		team2 = "allies";
	teamname2 = level.teamname[team2];


	game["match_team1_name"] = teamname1;
	game["match_team1_side"] = team1;
	game["match_team2_name"] = teamname2;
	game["match_team2_side"] = team2;
}

resetAll()
{
	setCvar("sv_map_name", "");
	setCvar("sv_map_team1", "");
	setCvar("sv_map_team2", "");
	setCvar("sv_map_score1", "");
	setCvar("sv_map_score2", "");

	setCvar("sv_match_totaltime", "");
	setCvar("sv_match_players", "");
	setCvar("sv_match_team1", "");
	setCvar("sv_match_team2", "");


	game["match_exists"] = false;
	game["match_starttime"] = undefined;
	game["match_totaltime_prev"] = 0;

	// Reset cvars
	for (i = 1; i <= 3; i++)
	{
		setCvar("sv_map" + i + "_name", 	"");
		setCvar("sv_map" + i + "_team1", 	"");
		setCvar("sv_map" + i + "_team2", 	"");
		setCvar("sv_map" + i + "_score1", 	"");
		setCvar("sv_map" + i + "_score2", 	"");
	}

	game["match_team1_name"] = "";
	game["match_team1_score"] = "";
	game["match_team2_name"] = "";
	game["match_team2_score"] = "";

	// Generate team names again
	determineTeamByFirstConnected();
}

waitForPlayerOrClear(playersLast)
{
	wait level.fps_multiplier * 15;

	resetCount = 0;

	for(;;)
	{
		// Exit loop if teams are set
		if (game["match_teams_set"])
			return;

		// reset matchinfo if 30% of players disconnect or there are no players or there was no players last map
		players = getentarray("player", "classname");
		if (((players.size * 1.0) < (playersLast * 0.7)) || ((players.size * 1.0) > (playersLast * 1.2)) || players.size <= 1 || playersLast <= 1)
			resetCount++;
		else
			resetCount = 0;

		// We are sure to reset the match info
		if (resetCount >= 4)
		{
			logprint("waitForPlayerOrClear and resetCount>=4\n");
			clear();
			logprint("waitForPlayerOrClear and resetCount>=4 after\n");
			iprintln("Info about teams was cleared.");
			return;
		}

		wait level.fps_multiplier * 5;
	}
}

clear()
{
	logprint("clear\n");
	resetAll();
	logprint("clear after resetAll\n");

	if (level.in_readyup)
	{
		logprint("clear inside level.in_readyup\n");
		// Stop demo recording if enabled
		maps\mp\gametypes\_record::stopRecordingForAll();

		//Reset Remaing Time in readyup to Clock
		maps\mp\gametypes\_readyup::HUD_ReadyUp_ResumingIn_Delete();
	}
	logprint("clear end of function\n");
}


// Well, COD2 dont have this function, so create it manually
ToUpper(char)
{
	switch (char)
	{
		case "a": char = "A"; break;
		case "b": char = "B"; break;
		case "c": char = "C"; break;
		case "d": char = "D"; break;
		case "e": char = "E"; break;
		case "f": char = "F"; break;
		case "g": char = "G"; break;
		case "h": char = "H"; break;
		case "i": char = "I"; break;
		case "j": char = "J"; break;
		case "k": char = "K"; break;
		case "l": char = "L"; break;
		case "m": char = "M"; break;
		case "n": char = "N"; break;
		case "o": char = "O"; break;
		case "p": char = "P"; break;
		case "q": char = "Q"; break;
		case "r": char = "R"; break;
		case "s": char = "S"; break;
		case "t": char = "T"; break;
		case "u": char = "U"; break;
		case "v": char = "V"; break;
		case "w": char = "W"; break;
		case "x": char = "X"; break;
		case "y": char = "Y"; break;
		case "z": char = "Z"; break;
	}
	return char;
}

GetMapName(mapname)
{
	/*
	if (mapname == "mp_toujane" || mapname == "mp_toujane_fix")		return "Toujane";
	if (mapname == "mp_burgundy" || mapname == "mp_burgundy_fix")		return "Burgundy";
	if (mapname == "mp_dawnville" || mapname == "mp_dawnville_fix")		return "Dawnville";
	if (mapname == "mp_matmata" || mapname == "mp_matmata_fix")		return "Matmata";
	if (mapname == "mp_carentan" || mapname == "mp_carentan_fix")		return "Carentan";
	if (mapname == "mp_breakout_tls")					return "Breakout TLS";
	if (mapname == "mp_chelm_fix")						return "Chelm";
	*/

	if (mapname == "" || mapname.size < 3)
		return mapname;

	if (maps\mp\gametypes\global\_global::toLower(mapname[0]) == "m" && maps\mp\gametypes\global\_global::toLower(mapname[1]) == "p" && maps\mp\gametypes\global\_global::toLower(mapname[2]) == "_")
		mapname = ToUpper(mapname[3]) + maps\mp\gametypes\global\_global::getsubstr(mapname, 4, mapname.size);

	return mapname;
}


UpdatePlayerCvars()
{
	if (game["scr_matchinfo"] > 0)
	{
		teamNum_left  = "team1";
		teamNum_right = "team2";

		// Set player's team always on left
		if (isDefined(self.pers["team"]) && self.pers["team"] == game["match_team2_side"])
		{
			teamNum_left  = "team2";
			teamNum_right = "team1";
		}

		name_left = game["match_"+teamNum_left+"_name"];
		name_right = game["match_"+teamNum_right+"_name"];
		// Rename teams when matchinfo is without team names
		if (game["scr_matchinfo"] == 1 && isDefined(self.pers["team"]) && (self.pers["team"] == "allies" || self.pers["team"] == "axis"))
		{
			name_left  = "My Team";
			name_right = "Enemy";
		}
		// Handle empty teams
		if (name_left == "")  name_left = "?";
		if (name_right == "") name_right = "?";


		ui_name_left = game["match_"+teamNum_left+"_score"] + "    " + name_left;
		ui_name_right = game["match_"+teamNum_right+"_score"] + "    " + name_right;




		side_left = game["match_"+teamNum_left+"_side"];
		side_right = game["match_"+teamNum_right+"_side"];

		side_left_team = "";
		side_right_team = "";
		if (side_left == "axis" || side_right == "allies")
		{
			side_left_team = game["axis"]; 	  // german
			side_right_team = game["allies"]; // american british russian
		}
		else // also if sides not set
		{
			side_left_team = game["allies"]; // american british russian
			side_right_team = game["axis"];	 // german
		}



		// Team names
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_team1_name", ui_name_left);
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_team2_name", ui_name_right);

		// Team
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_team1_team", 	side_left_team);
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_team2_team", 	side_right_team);

		if (self.pers["matchinfo_ingame_visible"])
		{
			self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_ingame_team1_team", 	side_left_team);
			self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_ingame_team2_team", 	side_right_team);
		}







		matchtimetext = "";
		halfInfo = "";
		if (game["match_totaltime_text"] != "")
		{
			matchtimetext = "Match time:   " + game["match_totaltime_text"];

			if (!game["readyup_first_run"] && !level.in_bash)
			{
				if (level.gametype == "sd")
				{
					if (!game["is_halftime"])
						halfInfo = "Rounds to half:   " + (level.halfround - game["round"]);
					else
						halfInfo = "First half score:   " + game["half_1_"+side_right+"_score"] + " : " + game["half_1_"+side_left+"_score"];
				}
				else
					if (!game["is_halftime"])
						halfInfo = "First half";
					else
						halfInfo = "Second half";
			}
		}

		// Round
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_round", game["match_round"]);
		// Half
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_halfInfo", halfInfo);
		// Play time
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_matchtime", matchtimetext);

		// Map history
		for (j = 1; j <= 3; j++)
		{
			map = GetMapName(getCvar("sv_map" + j + "_name"));
			score1 = getCvar("sv_map" + j + "_score1");
			score2 = getCvar("sv_map" + j + "_score2");
			if (teamNum_left == "team2")
			{
				temp = score1;
				score1 = score2;
				score2 = temp;
			}
			score = "";
			if (score1 != "" && score2 != "")
				score = score1 + ":" + score2;

			self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_map" + j, map + "  " + score);
			//self setClientCvarIfChanged("ui_matchinfo_map" + j, "Toujane  13:7");
		}
	}
	else
	{
		// Team names
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_team1_name", "");
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_team2_name", "");

		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_team1_team", "");
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_team2_team", "");
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_ingame_team1_team", "");
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_ingame_team2_team", "");

		// Round
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_round", "");
		// Half
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_halfInfo", "");
		// Map history
		for (j = 1; j <= 2; j++)
		{
			self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_map" + j, "");
		}
		// Play time
		self maps\mp\gametypes\global\_global::setClientCvarIfChanged("ui_matchinfo_matchtime", "");
	}
}


UpdateCvarsForPlayers()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		wait level.frame;	// spread commands send to player to multiple frames
		player = players[i];
		if (!isDefined(player)) // Because we wait a frame, next frame player may be disconnected
			continue;

//v23 disabled
//		player UpdatePlayerCvars();
//v24 new added
		if (isDefined(player.pers["team"]) && player.pers["team"] == "streamer")
		{
			logprint("_matchinfo::UpdateCvarsForPlayers for streamer\n");
			player UpdatePlayerCvars();
		}
//--
	}
}



refresh()
{
	// Save previous map score to map history
	if (!isDefined(game["match_previous_map_processed"]))
	{
		// Process cvars from previous map - load it into history cvars
		processPreviousMapToHistory();

		// Run timer - untill 1min the same number of player must connect
		// Othervise considere this as team left and we need to reset match info
		playersLast = getCvar("sv_match_players");
		if (playersLast != "")
		{
			level thread waitForPlayerOrClear((int)(playersLast));
			//setcvar("sv_match_players", "");
		}

		// Save previous time left
		if (getCvar("sv_match_totaltime") != "")
		{
			game["match_totaltime_prev"] = getCvarInt("sv_match_totaltime");

			// Via this cvar we determinate if match is set from previous map
			game["match_exists"] = true;
		}
		else
			game["match_totaltime_prev"] = 0;

		game["match_previous_map_processed"] = true;
	}


	// On first run, offset thread from ther thread and this also make sure game["allies_score"] is defined
	wait level.frame * 8; // offset thread from other threads

//v210
	for (;;)
	{
		/***********************************************************************************************************************************
		*** Determinate team names, side, score
		/***********************************************************************************************************************************/
		// Full team info
		if (game["scr_matchinfo"] == 2)
		{
			// Keep updating data about team names, played maps,.. untill match start
			// Called in every first readyup on every map
			if (!game["match_teams_set"])
			{
				// If match exists, load teams from cvars. Othervise load team by first connected player
				if (game["match_exists"])
					determineTeamByHistoryCvars();
				else
					if (isDefined(game["readyup_first_run_ending_for_matchinfo"]) && game["readyup_first_run_ending_for_matchinfo"])
					determineTeamByFirstConnected();

				// for all players change team name in scoreboard
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					players[i] updateTeamNames();
				}
			}

			// If game started and teams was not recognised, reset team info and do it it from scratch
			// This may happend if player in both teams gets renamed
			else
			{
				if (game["match_team1_side"] == "" || game["match_team2_side"] == "")
				{
					resetAll(); // reset map history and select team again
				}
			}

			// Main score update
			if (game["match_team1_side"] == "") 	game["match_team1_score"] = "?";
			else 					game["match_team1_score"] = game[game["match_team1_side"] + "_score"];
			if (game["match_team2_side"] == "") 	game["match_team2_score"] = "?";
			else 					game["match_team2_score"] = game[game["match_team2_side"] + "_score"];
		}

		else if (game["scr_matchinfo"] == 1) // basic info (no team names)
		{
			if (!game["match_teams_set"])
			{
				game["match_team1_name"] = "Team 1";
				game["match_team2_name"] = "Team 2";

				game["match_team1_side"] = "allies";
				game["match_team2_side"] = "axis";
			}

			game["match_team1_score"] = game[game["match_team1_side"] + "_score"];
			game["match_team2_score"] = game[game["match_team2_side"] + "_score"];
		}



		/***********************************************************************************************************************************
		*** Determinate match time, status, ...
		/***********************************************************************************************************************************/

		// Total time measuring
		if (game["match_totaltime_prev"] == 0 && !game["match_teams_set"])
			game["match_totaltime"] = 0;
		else
		{
			if (!isDefined(game["match_starttime"]))
				game["match_starttime"] = getTime()/60000; // minutes

			game["match_totaltime"] = game["match_totaltime_prev"] + ((getTime()/60000) - game["match_starttime"]);
		}

		if (game["match_exists"])
			maps\mp\gametypes\global\_global::setCvarIfChanged("sv_match_totaltime", game["match_totaltime"]);


		elapsedTime = 0; // in seconds
		if (isDefined(game["match_starttime"]))
			elapsedTime = (int)(((getTime()/1000) - (game["match_starttime"]*60)));
			//elapsedTime = (int)((getTime() - game["match_starttime"]) / 1000);


		// Readyup is over, teams are set
		if (game["match_teams_set"])
		{
			// Save team name that will be used to load on next map
			maps\mp\gametypes\global\_global::setCvarIfChanged("sv_match_team1", game["match_team1_name"]);
			maps\mp\gametypes\global\_global::setCvarIfChanged("sv_match_team2", game["match_team2_name"]);


			// Update number of players in second minute (due to missing player)
			// If number of players change, matchinfo is reseted next map due to different number of players
			savedPlayers = GetCvarInt("sv_match_players"); // GetCvarInt return 0 if cvar is empty string
			players = getentarray("player", "classname");

			if (savedPlayers == 0 || ((elapsedTime >= 120 && elapsedTime <= 130) && players.size > savedPlayers))
				maps\mp\gametypes\global\_global::setCvarIfChanged("sv_match_players", players.size);
		}



		/***********************************************************************************************************************************
		*** Update history cvars to be able load info in next map
		/***********************************************************************************************************************************/

		// Save data from this map for next map
		if ((game["match_teams_set"] || game["scr_matchinfo"] == 1) && elapsedTime > (3*60) && (game["allies_score"] + game["axis_score"]) > 1) // save map into hostory after 3 mins
		{
			maps\mp\gametypes\global\_global::setCvarIfChanged("sv_map_name", level.mapname);
			maps\mp\gametypes\global\_global::setCvarIfChanged("sv_map_score1", game["match_team1_score"]);
			maps\mp\gametypes\global\_global::setCvarIfChanged("sv_map_score2", game["match_team2_score"]);
		}




		// Total time
		if (game["match_totaltime"] > 0)
		{
			//logprint("_matchinfo:: match_totaltime " + game["match_totaltime"] + "\n");
			game["match_totaltime_text"] = maps\mp\gametypes\global\_global::formatTime((int)(game["match_totaltime"] * 60), ":", false);
			//game["match_totaltime_text"] = maps\mp\gametypes\global\_global::formatTime((int)(game["match_totaltime"] / 1000));
		}
		else
		{
			//logprint("_matchinfo:: 2222 match_totaltime " + game["match_totaltime"] + "\n");
			game["match_totaltime_text"] = "";
		}


		// Round
		if (level.in_timeout)
			game["match_round"] = "Timeout";
		else if (level.in_readyup)
			game["match_round"] = "Ready-up";
		else if (level.in_bash)
			game["match_round"] = "Bash";
		else
		{
			if (level.gametype == "sd")
			{
				game["match_round"] = "Round " + game["round"];

				if (level.matchround > 0)
					game["match_round"] += " / " + level.matchround;
			}
			else
				game["match_round"] = "";
		}

		if (game["overtime_active"])
			game["match_round"] += " (OT)"; // overtime


//rFIX_HLSW-CVAR-PLAYER-ERROR
// Executing this code when joining a server causes an error (Global server cvars visible via HLSW).
/*
		// Global server cvars visible via HLSW
		if (game["match_team1_name"] != "") 	maps\mp\gametypes\global\_global::setCvarIfChanged("_match_team1", game["match_team1_name"]);
		else					maps\mp\gametypes\global\_global::setCvarIfChanged("_match_team1", "-");
		if (game["match_team2_name"] != "") 	maps\mp\gametypes\global\_global::setCvarIfChanged("_match_team2", game["match_team2_name"]);
		else					maps\mp\gametypes\global\_global::setCvarIfChanged("_match_team2", "-");

		if (getcvar("sv_map_score1") != "") 	maps\mp\gametypes\global\_global::setCvarIfChanged("_match_score", getcvar("sv_map_score1") + ":" + getcvar("sv_map_score2"));
		else					maps\mp\gametypes\global\_global::setCvarIfChanged("_match_score", "-");

		if (game["match_round"] != "") 		maps\mp\gametypes\global\_global::setCvarIfChanged("_match_round", game["match_round"]);
		else					maps\mp\gametypes\global\_global::setCvarIfChanged("_match_round", "-");
*/
//--
		thread UpdateCvarsForPlayers();



		wait level.fps_multiplier * 1;
	}


}