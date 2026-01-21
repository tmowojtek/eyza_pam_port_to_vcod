Init()
{
	logprint("precache::init\n");
	// Common stuffs for all gametypes
	precacheShader("black");
	precacheShader("white");
	//precacheShader("$levelBriefing"); // map image
	//precacheShader(game["layoutimage"]); // map image

	// Stopwatch
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");

	//precacheStatusIcon("hud_status_dead");
	precacheStatusIcon("gfx/hud/hud@status_dead.tga");
	//precacheStatusIcon("hud_status_connecting");
	precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
	precacheStatusIcon("gfx/hud/headicon@re_objcarrier.tga");
	
	precacheItem("item_health"); //Health pack

	precacheString2("STRING_EMPTY", &" ");
}


// Use this function to safe precached string into game variable
precacheString2(gameName, string)
{
	game[gameName] = string;
	precacheString(game[gameName]);
}