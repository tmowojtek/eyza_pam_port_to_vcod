

Load()
{
	game["rules_formatString"] = &"Classic 20 rounds";
	game["ruleCvars"] = GetCvars(game["ruleCvars"]);
}

GetCvars(arr)
{
	// Match Style
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_timelimit", 0);		// Time limit for map. 0=disabled (minutes)
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_half_round", 10);	// Number of rounds when half-time starts. 0=ignored
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_half_score", 0);	// Number of score when half-time starts. 0=ignored
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_end_round", 20);	// Number of rounds when map ends. 0=ignored
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_end_score", 0);	// Number of score when map ends. 0=ignored

	// Are there OT Rules?
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_overtime", 0);

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_show_scoreboard_limit", 0);	// show limit in score with slash

	return arr;
}
