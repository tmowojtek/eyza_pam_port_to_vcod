/*

  rPAMext Version: v14 (kvcodPAM v2.9)      
  
  Changes: 

  - Used zPAM eyza-cod2 version as reference 400test3
  - rSVDL: Sets server cvar sv_allowDownload to 1
  - rSVDLdis: Deactivated sv_wwwDlDisconnected 0 due to http download, thy Prawy
  - rNOTDOWNLOADEDmenu: Error display need to get black with text
  - rSETALLOWDOWNLOAD: Sets Client cvar cl_allowdownload = 1 & cl_wwwDownload = 1
  - rFIXdownloaderSPAWN: If not working properly, player will spawn in empty space with
    weired optics
    - added some more logprint's to investigate further  
  
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	#include maps\mp\gametypes\global\_global;
//
init()
{
//LOG
	logprint("_force_download::init\n");

//Precache errors
	if (game["firstInit"])
	{
		maps\mp\gametypes\global\_global::precacheString2("STRING_FORCEDOWNLOAD_ERROR_1", &"You must download rPAM to play on this server.");
		maps\mp\gametypes\global\_global::precacheString2("STRING_FORCEDOWNLOAD_ERROR_2", &"Downloading was enabled (Console: /cl_allowDownload 1).");
		maps\mp\gametypes\global\_global::precacheString2("STRING_FORCEDOWNLOAD_ERROR_3", &"Please reconnect to the server (Console: /reconnect");

//Icon disconnected.dds precacheStatusIcon("disconnected");
		//precacheStatusIcon("icon_mod");
	}

//rSVDL
	setCvar("sv_allowDownload", "1");
//rSVDLdis
//	setCvar("sv_wwwDlDisconnected", "0"); // disconnect player while downloading?

// addEventListener
	maps\mp\gametypes\global\_global::addEventListener("onConnected",     ::onConnected);
}

onConnected()
{
//LOG
	logprint("_force_download::onConnected start\n");

	// Define flags
	if (!isDefined(self.pers["modDownloaded"]))
	{
		self.pers["modDownloaded"] = false;
		self.pers["downloadDisableResponse"] = false;
	}

	// Define bots
	if (self.pers["isBot"])
		self.pers["modDownloaded"] = true;

	// Ignore if pam is not installed correctly
	if (level.pam_installation_error)
		return;
	
	// Temporary menu fix, which occurs rFIXdownloaderSPAWN, if screen is not black
	//modIsDownloaded();

	// Show while match is readyUp/changeTeam
	if (!self.pers["modDownloaded"] && game["state"] != "intermission")
	{
		// Show error message even if we dont know yet if mod is downloaded
		// Message is not visible if menu is open and is removed when response comes
		self showErrorMessage();
	}
//LOG
	logprint("_force_download::onConnected end\n");
}

// Called from _menus::OnConnected() when we are waiting for response
checkDownload()
{
//LOG
	logprint("_force_download::DL START\n");

	self endon("disconnect");

	// After a few second of not getting response from client disable all
	wait level.fps_multiplier * 3;

//LOG
	logprint("_force_download::DL WAIT\n");

	// Ignore if pam is not installed correctly
	if (level.pam_installation_error || game["state"] == "intermission")
	{
//LOG
		logprint("_force_download::DL IGNORE\n");
		return;
	}

	if (!self.pers["modDownloaded"])
	{
//LOG
		logprint("_force_download::DL downloadDisableResponse true\n");
		
		self.pers["downloadDisableResponse"] = true;

//rNOTDOWNLOADEDmenu
		self closeMenu();									//cod2
//		self closeInGameMenu();						//cod2
//		self setClientCvar("g_scriptMainMenu", "");			//cod2

		self maps\mp\gametypes\global\_global::setClientCvar2("g_scriptMainMenu", "");

		spawnModNotDownloaded();
	}
	
//LOG
	logprint("_force_download::DL end\n");
}

spawnModNotDownloaded()
{
  	self endon("disconnect");

//cod2
//	self setClientCvar2("cl_allowdownload", "1"); // enable downloading on client side (just for sure)
//	self setClientCvar2("cl_wwwdownload", "1");
//	[[level.spawnSpectator]]((999999, 999999, -999999), (90, 0, 0));	
	
//LOG
	logprint("_force_download::NDL start\n");

	self setClientCvar("cl_allowDownload", "1");
	self setClientCvar("cl_wwwDownload", "1");

//LOG
	logprint("_force_download::NDL client cvars set\n");
		
// rSPAWN_OldAllowDownload1
//	self maps\mp\gametypes\global\_global::setClientCvar2("cl_allowdownload", "1"); // enable downloading on client side (just for sure)
//	self maps\mp\gametypes\global\_global::setClientCvar2("cl_wwwdownload", "1");
// rFIX_DOWNLOADERSPAWN
	[[level.spawnSpectator]]((999999, 999999, -999999), (90, 0, 0));

// LOG
	logprint("_force_download::NDL spawned and wait\n");
	
// Wait to correctly replace statusicon (is set in readyup)
	wait level.frame;

// Special icon for player with not downloaded mod
// Icon disconnected.dds
	//self.statusicon = "disconnected";
	//self.statusicon = "icon_mod";
}

modIsDownloaded()
{
// LOG
	logprint("_force_download::modIsDownloaded TRUE\n");
	self.pers["modDownloaded"] = true;

	removeErrorMessage();
}


waitingForResponse()
{
	return !self.pers["modDownloaded"] && !self.pers["downloadDisableResponse"];
}

modIsNotDownloadedForSure()
{
	return !self.pers["modDownloaded"] && self.pers["downloadDisableResponse"];
}


showErrorMessage()
{
	// Background
//cod2
//	self.forcedownload = addHUDClient(self, 0, 0, undefined, (1,1,1), "left", "top", "fullscreen", "fullscreen");
	self.forcedownload = maps\mp\gametypes\global\_global::addHUDClient(self, 0, 0, undefined, (1,1,1), "left", "top", "fullscreen", "fullscreen");
	self.forcedownload.sort = 1000;
	self.forcedownload.foreground = true;
	self.forcedownload.archived = false;
	self.forcedownload setShader("black", 640, 480);
//cod2
//	self.forcedownloadm1 = addHUDClient(self, 0, 150, 1.8, (1, .86, .4), "center", "top", "center");
	self.forcedownloadm1 = maps\mp\gametypes\global\_global::addHUDClient(self, 320, 150, 1.8, (1, .86, .4), "center", "top", "center");
	self.forcedownloadm1.sort = 1001;
	self.forcedownloadm1.foreground = true;
	self.forcedownloadm1.archived = false;
	self.forcedownloadm1 SetText(game["STRING_FORCEDOWNLOAD_ERROR_1"]);
//cod2
//	self.forcedownloadm2 = addHUDClient(self, 0, 174, 1.4, (1, .86, .4), "center", "top", "center");
	self.forcedownloadm2 = maps\mp\gametypes\global\_global::addHUDClient(self, 320, 174, 1.4, (1, .86, .4), "center", "top", "center");
	self.forcedownloadm2.sort = 1002;
	self.forcedownloadm2.foreground = true;
	self.forcedownloadm2.archived = false;
	self.forcedownloadm2 SetText(game["STRING_FORCEDOWNLOAD_ERROR_2"]);
//cod2
//	self.forcedownloadm3 = addHUDClient(self, 0, 210, 1.6, (1, .86, .4), "center", "top", "center");
	self.forcedownloadm3 = maps\mp\gametypes\global\_global::addHUDClient(self, 320, 210, 1.6, (1, .86, .4), "center", "top", "center");
	self.forcedownloadm3.sort = 1003;
	self.forcedownloadm3.foreground = true;
	self.forcedownloadm3.archived = false;
	self.forcedownloadm3 SetText(game["STRING_FORCEDOWNLOAD_ERROR_3"]);
}

removeErrorMessage()
{
// LOG
	logprint("_force_download::removeErrorMessages TRUE\n");
//cod2 uses destroy2()
	if (isdefined(self.forcedownload))
		self.forcedownload destroy();
	if (isdefined(self.forcedownloadm1))
		self.forcedownloadm1 destroy();
	if (isdefined(self.forcedownloadm2))
		self.forcedownloadm2 destroy();
	if (isdefined(self.forcedownloadm3))
		self.forcedownloadm3 destroy();
}