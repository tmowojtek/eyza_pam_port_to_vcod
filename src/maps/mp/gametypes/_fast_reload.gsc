

init()
{
	logprint("_fast_reload::init\n");
	
	maps\mp\gametypes\global\_global::addEventListener("onCvarChanged", ::onCvarChanged);

	maps\mp\gametypes\global\_global::registerCvar("scr_fast_reload_fix", "BOOL", 0);


	level.fastReload_startTime = getTime();

	maps\mp\gametypes\global\_global::addEventListener("onConnected",     ::onConnected);
}

// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	switch(cvar)
	{
		case "scr_fast_reload_fix":
			level.scr_fast_reload_fix = value;
			if (!isRegisterTime)
			{
				if (level.scr_fast_reload_fix) // changed to 1
			  	{
			    		players = getentarray("player", "classname");
			    		for(i = 0; i < players.size; i++)
			    		{
			      			player = players[i];
			      			player onConnected();
			    		}
			  	}
			}
			return true;
	}
	return false;
}


onConnected()
{
    logprint("_fast_reload::onConnected start\n");
    if (!level.scr_fast_reload_fix)
      return;

    self thread manageWeaponCycleDelay();
    logprint("_fast_reload::onConnected end\n");
}


getCurrentWeaponSlot()
{
    weapon1 = self getweaponslotweapon("primary");
	weapon2 = self getweaponslotweapon("primaryb");
    pistol = self getweaponslotweapon("pistol");
    grenade = self getweaponslotweapon("grenade");

    current = self getcurrentweapon(); // can be none ()

	if(current == weapon1)
		return "primary";
	else if(current == weapon2)
		return "primaryb";
    else if (current == pistol)
        return "pistol";
    else if (current == grenade)
        return "grenade";
    else
        return "none";
}

getClipAmmo()
{
    currentSlot = getCurrentWeaponSlot();
    //logprint("currentSlot=" + currentSlot + "\n");
    if (currentSlot != "none")
        return self getweaponslotclipammo(currentSlot);
    else
        return 0;
}

manageWeaponCycleDelay()
{
    self endon("disconnect");
    self notify("manageWeaponCycleDelay");
	self endon("manageWeaponCycleDelay");

    lastClipAmmo = 0;
    lastWeapon = "";

    // Start as activated to fix problem when the cvar is set at the end of the round
    cycleDelayActivated = true;
    cycleDelayTime = 0;

    wait level.fps_multiplier * 0.2;

    for (;;)
    {
        wait level.frame;

        // Fast reload fix was turned off by cvar
        if (!level.scr_fast_reload_fix)
        {
          if (!cycleDelayActivated) // wait until cycle dalay is restored to original state
            return;
        }

        // If we have weapon that can be bugged
        if (cycleDelayActivated)
        {
            cycleDelayTime -= level.frame;

            if (cycleDelayTime <= 0)
            {
                if (level.debug_fastreload) self iprintln("^2Fast reload bug ok");
                self maps\mp\gametypes\global\_global::setClientCvar2("cg_weaponCycleDelay", "0");

                cycleDelayActivated = false;
                cycleDelayTime = 0;
            }
        }


        currentWeapon = self getcurrentweapon();

        // Player is planting, or is using ladder
        if (currentWeapon == "none"
            || currentWeapon == "fraggrenade_mp" 
            || currentWeapon == "mk1britishfrag_mp"
            || currentWeapon == "rgd-33russianfrag_mp"
            || currentWeapon == "stielhandgranate_mp"
            )
        {
            cycleDelayTime = 0; // reset cycle delay
            continue;
        }


        if (currentWeapon != lastWeapon)
        {
            //self iprintln("weapon switched");
            lastWeapon = currentWeapon;

            lastClipAmmo = self getClipAmmo();

            cycleDelayTime = 0; // reset cycle delay

            continue; // ignore weapon clip ammo change because weapon is changed
        }


        currentClipAmmo = self getClipAmmo();

        // If weapon fired
        if (currentClipAmmo < lastClipAmmo && currentClipAmmo != 0)
        {
            // Get time how long rechamber will take
            timer = GetRechamberTime(currentWeapon);

            //logprint("currentWeapon=" + currentWeapon + ", timer=" + timer + "\n");

      		if (timer > 0)
      		{
  	            cycleDelayActivated = true;
  	            cycleDelayTime = timer - level.frame*3;

                // Send command after a few frames (this may help fix fps drop when player fire from weapon)
                wait level.frame*3;

  	            if (level.debug_fastreload) self iprintln("^1Preventing fast reload bug");
  	            self maps\mp\gametypes\global\_global::setClientCvar2("cg_weaponCycleDelay", "200");	// time in ms when player can change weapon again
      		}
        }

        //logprint("lastClipAmmo=" + lastClipAmmo + ", currentClipAmmo=" + currentClipAmmo + "\n");
        lastClipAmmo = currentClipAmmo;
    }
}



/*
Hit fire                                      Ready to fire again
   ^                                                  ^
   |                                                  |
   |  Fire time   |           Rechamber time          |
   | ------------ | ----------------------------------|
   |    0.33s     |                 1s                |
   |              |                     |             |
   |              | Rechamber bolt time |             |
   |              | ------------------- |             |
   |              |        0.65s        |             |

      All able      Fire, bash, zoom        All able
                         disabled

Rechamber time - fire disabled
Rechember bolt time - bash disabled

*/
GetRechamberTime(weaponName)
{
    timer = 0;
    switch(weaponName)
    {
        // vcod: fireTime\0.33\rechamberTime\1\rechamberBoltTime\0.4
        case "kar98k_mp":               timer = 1.33; break;
        // vcod: fireTime\0.33\rechamberTime\1\rechamberBoltTime\0.4
        case "kar98k_sniper_mp":        timer = 1.33; break;

        // vcod: fireTime\0.33\rechamberTime\1.1\rechamberBoltTime\0.4
        case "enfield_mp":              timer = 1.41; break;
        //case "enfield_scope_mp":        timer = 1.38; break;

        // vcod: fireTime\0.33\rechamberTime\1\rechamberBoltTime\0.4
        case "mosin_nagant_mp":         timer = 1.33; break;
        // vcod: fireTime\0.5\rechamberTime\1\rechamberBoltTime\0.4
        case "mosin_nagant_sniper_mp":  timer = 1.5; break;

        // vcod: fireTime\0.33\rechamberTime\0.95\rechamberBoltTime\0.4
        case "springfield_mp":          timer = 1.28; break;

        //case "shotgun_mp":              timer = 1.0163; break;
    }

    return timer;
}