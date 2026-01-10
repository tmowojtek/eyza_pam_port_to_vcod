

init()
{
	logprint("_log::init\n");
	
    maps\mp\gametypes\global\_global::addEventListener("onConnected",     ::onConnected);
    maps\mp\gametypes\global\_global::addEventListener("onDisconnect",    ::onDisconnect);

    // level thread onReadyUpOver();
    //level thread onDamage();
    //level thread onPlayerKilled();

    level thread onRoundEnd();

    // level thread onServerRestart();
}

onConnected()
{
    logprint("_log::onConnected start\n");
    logPrint("Connected;"+self getGuid()+";"+self getEntityNumber()+";"+self.name+"\n");
    logprint("_log::onConnected end\n");
}

onDisconnect()
{
    logPrint("Disconnected;"+self getGuid()+";"+self getEntityNumber()+";"+self.name+"\n");
}

onReadyUpOver()
{
    level waittill("rupover");

    logPrint("ReadyupDone;\n");
}

logOnReadyUpOver()
{
    logPrint("ReadyupDone;\n");
}

onServerRestart()
{
    level waittill("log_server_restart");

    logPrint("ServerRestart;EmptyServer\n");
}

onDamage()
{
    for (;;)
    {
        level waittill("log_damage", player, eAttacker, sWeapon, iDamage, sMeansOfDeath, sHitLoc, isFriendlyFire);

        self_num = player getEntityNumber();
		self_guid = player getGuid();
		self_name = player.name;
		self_team = player.pers["team"];

        attack_num = -1;
        attack_guid = "";
        attack_name = "";
        attack_team = "world";

		if(isPlayer(eAttacker))
		{
			attack_num = eAttacker getEntityNumber();
			attack_guid = eAttacker getGuid();
			attack_name = eAttacker.name;
			attack_team = eAttacker.pers["team"];
		}

        // This means that scr_friendlyfire is "reflected" or "shared" - it means attacker get hitted instead of self
		if(isFriendlyFire)
		{
			attack_num = self_num;
            attack_guid = self_guid;
			attack_name = self_name;
			attack_team = self_team;
		}

        logPrint("Damage;"+self_guid+";"+self_num+";"+self_name+";"+self_team+";"+attack_guid+";"+attack_num+";"+attack_name+";"+attack_team+";"+sWeapon+";"+iDamage+";"+sMeansOfDeath+";"+sHitLoc+"\n");
    }
}

logDamage(player, eAttacker, sWeapon, iDamage, sMeansOfDeath, sHitLoc, isFriendlyFire, normalizedDamage)
{
    self_num = player getEntityNumber();
	self_guid = player getGuid();
	self_name = player.name;
	self_team = player.pers["team"];

    attack_num = -1;
    attack_guid = "";
    attack_name = "";
    attack_team = "world";

	if(isPlayer(eAttacker))
	{
		attack_num = eAttacker getEntityNumber();
		attack_guid = eAttacker getGuid();
		attack_name = eAttacker.name;
		attack_team = eAttacker.pers["team"];
	}

    // This means that scr_friendlyfire is "reflected" or "shared" - it means attacker get hitted instead of self
	if(isFriendlyFire)
	{
		attack_num = self_num;
        attack_guid = self_guid;
		attack_name = self_name;
		attack_team = self_team;
	}

    if(!isDefined(normalizedDamage))
    {
        normalizedDamage = "";
    }

    logPrint("Damage;"+self_guid+";"+self_num+";"+self_name+";"+self_team+";"+attack_guid+";"+attack_num+";"+attack_name+";"+attack_team+";"+sWeapon+";"+iDamage+";"+sMeansOfDeath+";"+sHitLoc+";"+normalizedDamage+"\n");
}

onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
    for (;;)
    {
        level waittill("log_kill", player, attacker, sWeapon, iDamage, sMeansOfDeath, sHitLoc);


        self_num = player getEntityNumber();
    	self_guid = player getGuid();
    	self_name = player.name;
    	self_team = player.pers["team"];

        attack_num = -1;
        attack_guid = "";
        attack_name = "";
        attack_team = "world";

    	if(isPlayer(attacker))
    	{
    		attack_num = attacker getEntityNumber();
    		attack_guid = attacker getGuid();
    		attack_name = attacker.name;
    		attack_team = attacker.pers["team"];
    	}


        logPrint("Kill;"+self_guid+";"+self_num+";"+self_name+";"+self_team+";"+attack_guid+";"+attack_num+";"+attack_name+";"+attack_team+";"+sWeapon+";"+iDamage+";"+sMeansOfDeath+";"+sHitLoc+"\n");
    }
}

logKill(player, attacker, sWeapon, iDamage, sMeansOfDeath, sHitLoc)
{
    self_num = player getEntityNumber();
    self_guid = player getGuid();
    self_name = player.name;
    self_team = player.pers["team"];

    attack_num = -1;
    attack_guid = "";
    attack_name = "";
    attack_team = "world";

    if(isPlayer(attacker))
    {
    	attack_num = attacker getEntityNumber();
    	attack_guid = attacker getGuid();
    	attack_name = attacker.name;
    	attack_team = attacker.pers["team"];
    }

    logPrint("Kill;"+self_guid+";"+self_num+";"+self_name+";"+self_team+";"+attack_guid+";"+attack_num+";"+attack_name+";"+attack_team+";"+sWeapon+";"+iDamage+";"+sMeansOfDeath+";"+sHitLoc+"\n");
}

onRoundEnd()
{
    for (;;)
    {
        level waittill("log_round_end", roundwinner);

        wait 0.05; // wait to complete kill log

        logPrint("RoundEnd;\n");

        roundlooser = "axis";
        if (roundwinner == "axis")
            roundlooser = "allies";

    	winners = "";
    	losers = "";

        players = getentarray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            lpGuid = players[i] getGuid();
            if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == roundwinner))
                winners = (winners + ";" + lpGuid + ";" + players[i].name);
            else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == roundlooser))
                losers = (losers + ";" + lpGuid + ";" + players[i].name);
        }
        logPrint("Winners;"+roundwinner + winners + "\n");
        logPrint("Losers;"+roundlooser + losers + "\n");

    	logPrint("Score;allies;" + getTeamScore("allies") + ";axis;" + getTeamScore("axis") + "\n");
    }
}