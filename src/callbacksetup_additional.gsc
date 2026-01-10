/* 
custom lib features:
- getPlayerAngles();
- aimbuttonpressed();
*/

CodeCallback_PlayerCommand(command_object)
{
     for(i = 0; i < command_object.size; i++)
    {
        logprint("command_object[" + i + "]=" + command_object[i] + "\n");
    }
    
    if((command_object[0] == "say" || command_object[0] == "say_team")
        && (isDefined(command_object[1]) && command_object[1][0] == "!"))
    {
        // Remove say/say_team
        for(i = 1; i < command_object.size; i++)
        {
            command_object[i-1] = command_object[i];
        }
        command_object[command_object.size - 1] = undefined;

        // Remove !
        index0 = "";
        for(i = 0; i < command_object[0].size; i++)
        {
            if(i == 0 && command_object[0][i] == "!")
                continue;
            index0 += command_object[0][i];
        }
        command_object[0] = index0;

        if(command_object.size == 1 && command_object[0] == "")
            return;

        if (command_object[0] == "test")
        {
            self spawnBots();
            return;
        }
		
		if (command_object[0] == "rup")
		{
			self rupBots();
			return;
		}

        if (command_object[0] == "distanceFromBomb")
        {
            self checkDistanceFromBomb();
            return;
        }

        if (command_object[0] == "server16")
        {
            self parseSavedSettings();
            return;
        }
    } else if (command_object[0] == "openscriptmenu" && (isDefined(command_object[1]) && command_object[1] == "quicksettings"))
    {
        logprint("callbacksetup_additional::CodeCallback_PlayerCommand parsing 'exec vstr server16'\n");
        self notify("menuresponse", game["menu_quicksettings"], command_object[2]);
        return;
    }
    self processClientCommand();
}

spawnBots()
{
    self.bots = [];
    allies = 5;
    axis = 5;

    for(i = 0; i < (allies + axis); i++)
    {
        self.bots[i] = addTestClient();
        wait .05;

        if (self.bots.size - 1 < allies) // First spawn the allies
        {
            clanName = "^1AlliesClan";
            team = "allies";
            weapon = "mosin_nagant_mp";
        }
        else
        {
            clanName = "^2AxisClan";
            team = "axis";
            weapon = "kar98k_mp";
        }

        botName = clanName + "^7" + getRandomPlayerName() + "(" + (i+1) + ")";
        self.bots[i] renameClient(botName);
        
        self.bots[i].pers["team"] = team;
        self.bots[i].pers["firstTeamSelected"] = team;
        self.bots[i].pers["weapon"] = weapon;

        self.bots[i] thread [[level.spawnPlayer]]();
    }
    for(i = 0; i < bots.size; i++)
        self.bots[i] thread botPressUse();
}
getRandomPlayerName()
{
    letters = [];
    letters[letters.size] = "a";
    letters[letters.size] = "b";
    letters[letters.size] = "c";
    letters[letters.size] = "D";
    letters[letters.size] = "E";

    nameLength = randomIntRange(4, 9);
    name = "";
    for(i = 0; i < nameLength; i++)
        name += letters[randomIntRange(0, letters.size)];
    return name;
}
botPressUse()
{
    self setUse(1); // hold
    wait .25;
    self setUse(0); // release
}

rupBots()
{
	for(i = 0; i < self.bots.size; i++)
        self.bots[i] thread botPressUse();
}

checkDistanceFromBomb()
{
    bombzone_A = getent("bombzone_A", "targetname");
	bombzone_B = getent("bombzone_B", "targetname");

    distFromA = distance(self.origin, bombzone_A.origin);
    distFromB = distance(self.origin, bombzone_B.origin);

    logprint("distFromA=" + distFromA + "\n");
    logprint("distFromB=" + distFromB + "\n");
}

parseSavedSettings()
{
    logprint("parseSavedSettings handled\n");
}