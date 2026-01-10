

// Source from maps/mp/pam/quickmessages.gsc
// content moved here

init()
{
	logprint("_quickmessages::init\n");
	
	if(game["firstInit"])
	{
		precacheHeadIcon("gfx/hud/headicon@quickmessage");
	}
}

quickcommands(response)
{
	if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis") || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;

	// soundalias = "none";
	// saytext = "none";

	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])
		{
		case "american":
			switch(response)
			{
			case "1":
				soundalias = "american_follow_me";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				//saytext = "Follow Me!";
				break;

			case "2":
				soundalias = "american_move_in";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				//saytext = "Move in!";
				break;

			case "3":
				soundalias = "american_fall_back";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				//saytext = "Fall back!";
				break;

			case "4":
				soundalias = "american_suppressing_fire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				//saytext = "Suppressing fire!";
				break;

			case "5":
				soundalias = "american_attack_left_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
				//saytext = "Attack left flank!";
				break;

			case "6":
				soundalias = "american_attack_right_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
				//saytext = "Attack right flank!";
				break;

			case "7":
				soundalias = "american_hold_position";
				saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
				//saytext = "Hold this position!";
				break;
			case "8":
				soundalias = "american_regroup";
				saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
				//saytext = "SQUAD_REGROUP!";
				break;
			default:
				logprint("_quickmessages::quickcommands unknown response=" + response + "\n");
				break;
			}
			break;

		case "british":
			switch(response)
			{
			case "1":
				soundalias = "british_follow_me";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				//saytext = "Follow Me!";
				break;

			case "2":
				soundalias = "british_move_in";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				//saytext = "Move in!";
				break;

			case "3":
				soundalias = "british_fall_back";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				//saytext = "Fall back!";
				break;

			case "4":
				soundalias = "british_suppressing_fire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				//saytext = "Suppressing fire!";
				break;

			case "5":
				soundalias = "british_attack_left_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
				//saytext = "Attack left flank!";
				break;

			case "6":
				soundalias = "british_attack_right_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
				//saytext = "Attack right flank!";
				break;

			case "7":
				soundalias = "british_hold_position";
				saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
				//saytext = "Hold this position!";
				break;
			case "8":
				soundalias = "british_regroup";
				saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
				//saytext = "SQUAD_REGROUP!";
				break;
			default:
				logprint("_quickmessages::quickcommands unknown response=" + response + "\n");
				break;
			}
			break;
		case "russian":
			switch(response)
			{
			case "1":
				soundalias = "russian_follow_me";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				//saytext = "Follow Me!";
				break;

			case "2":
				soundalias = "russian_move_in";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				//saytext = "Move in!";
				break;

			case "3":
				soundalias = "russian_fall_back";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				//saytext = "Fall back!";
				break;

			case "4":
				soundalias = "russian_suppressing_fire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				//saytext = "Suppressing fire!";
				break;

			case "5":
				soundalias = "russian_attack_left_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
				//saytext = "Attack left flank!";
				break;

			case "6":
				soundalias = "russian_attack_right_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
				//saytext = "Attack right flank!";
				break;

			case "7":
				soundalias = "russian_hold_position";
				saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
				//saytext = "Hold this position!";
				break;
			case "8":
				soundalias = "russian_regroup";
				saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
				//saytext = "SQUAD_REGROUP!";
				break;
			default:
				logprint("_quickmessages::quickcommands unknown response=" + response + "\n");
				break;
			}
			break;
		default:
			logprint("_quickmessages::quickcommands unknown game[allies]=" + game["allies"] + "\n");
			break;
		}
	}
	else if (self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			switch(response)
			{
			case "1":
				soundalias = "german_follow_me";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				//saytext = "Follow Me!";
				break;

			case "2":
				soundalias = "german_move_in";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				//saytext = "Move in!";
				break;

			case "3":
				soundalias = "german_fall_back";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				//saytext = "Fall back!";
				break;

			case "4":
				soundalias = "german_suppressing_fire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				//saytext = "Suppressing fire!";
				break;

			case "5":
				soundalias = "german_attack_left_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
				//saytext = "Attack left flank!";
				break;

			case "6":
				soundalias = "german_attack_right_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
				//saytext = "Attack right flank!";
				break;

			case "7":
				soundalias = "german_hold_position";
				saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
				//saytext = "Hold this position!";
				break;
			case "8":
				soundalias = "german_regroup";
				saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
				//saytext = "SQUAD_REGROUP!";
				break;
			default:
				logprint("_quickmessages::quickcommands unknown response=" + response + "\n");
				break;
			}
			break;
		default:
			logprint("_quickmessages::quickcommands unknown game[axis]=" + game["axis"] + "\n");
			break;
		}
	} else {
		logprint("_quickmessages::quickcommands unknown game[team]=" + game["team"] + "\n");
	}

	// if (soundalias == "none" || saytext == "none")
	// {
	// 	logprint("_quickmessages::quickcommands soundalias or saytext is none\n");
	// 	return;
	// }

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait level.fps_multiplier * 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

quickstatements(response)
{
	if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis") || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;
	// soundalias = "none";
	// saytext = "none";

	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])
		{
		case "american":
			switch(response)
			{
			case "1":
				soundalias = "american_enemy_spotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				//saytext = "Enemy spotted!";
				break;

			case "2":
				soundalias = "american_enemy_down";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				//saytext = "Enemy down!";
				break;

			case "3":
				soundalias = "american_in_position";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				//saytext = "I'm in position.";
				break;

			case "4":
				soundalias = "american_area_secure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				//saytext = "Area secure!";
				break;

			case "5":
				soundalias = "american_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				//saytext = "Grenade!";
				break;

			case "6":
				soundalias = "american_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				//saytext = "Sniper!";
				break;

			case "7":
				soundalias = "american_need_reinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				//saytext = "Need reinforcements!";
				break;
			case "8":
				soundalias = "american_hold_fire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				//saytext = "Hold your fire!";
				break;
			default:
				logprint("_quickmessages::quickstatements unknown response=" + response + "\n");
				break;
			}
			break;

		case "british":
			switch(response)
			{
			case "1":
				soundalias = "british_enemy_spotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				//saytext = "Enemy spotted!";
				break;

			case "2":
				soundalias = "british_enemy_down";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				//saytext = "Enemy down!";
				break;

			case "3":
				soundalias = "british_in_position";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				//saytext = "I'm in position.";
				break;

			case "4":
				soundalias = "british_area_secure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				//saytext = "Area secure!";
				break;

			case "5":
				soundalias = "british_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				//saytext = "Grenade!";
				break;

			case "6":
				soundalias = "british_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				//saytext = "Sniper!";
				break;

			case "7":
				soundalias = "british_need_reinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				//saytext = "Need reinforcements!";
				break;
			case "8":
				soundalias = "british_hold_fire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				//saytext = "Hold your fire!";
				break;
			default:
				logprint("_quickmessages::quickstatements unknown response=" + response + "\n");
				break;
			}
			break;

		case "russian":
			switch(response)
			{
			case "1":
				soundalias = "russian_enemy_spotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				//saytext = "Enemy spotted!";
				break;

			case "2":
				soundalias = "russian_enemy_down";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				//saytext = "Enemy down!";
				break;

			case "3":
				soundalias = "russian_in_position";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				//saytext = "I'm in position.";
				break;

			case "4":
				soundalias = "russian_area_secure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				//saytext = "Area secure!";
				break;

			case "5":
				soundalias = "russian_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				//saytext = "Grenade!";
				break;

			case "6":
				soundalias = "russian_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				//saytext = "Sniper!";
				break;

			case "7":
				soundalias = "russian_need_reinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				//saytext = "Need reinforcements!";
				break;
			case "8":
				soundalias = "russian_hold_fire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				//saytext = "Hold your fire!";
				break;
			default:
				logprint("_quickmessages::quickstatements unknown response=" + response + "\n");
				break;
			}
			break;
		default:
			logprint("_quickmessages::quickstatements unknown game[allies]=" + game["allies"] + "\n");
			break;
		}
	}
	else if (self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			switch(response)
			{
			case "1":
				soundalias = "german_enemy_spotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				//saytext = "Enemy spotted!";
				break;

			case "2":
				soundalias = "german_enemy_down";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				//saytext = "Enemy down!";
				break;

			case "3":
				soundalias = "german_in_position";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				//saytext = "I'm in position.";
				break;

			case "4":
				soundalias = "german_area_secure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				//saytext = "Area secure!";
				break;

			case "5":
				soundalias = "german_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				//saytext = "Grenade!";
				break;

			case "6":
				soundalias = "german_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				//saytext = "Sniper!";
				break;

			case "7":
				soundalias = "german_need_reinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				//saytext = "Need reinforcements!";
				break;
			case "8":
				soundalias = "german_hold_fire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				//saytext = "Hold your fire!";
				break;
			default:
				logprint("_quickmessages::quickstatements unknown response=" + response + "\n");
				break;
			}
			break;
		default:
			logprint("_quickmessages::quickstatements unknown game[axis]=" + game["axis"] + "\n");
			break;
		}
	} else {
		logprint("_quickmessages::statements unknown game[team]=" + game["team"] + "\n");
	}

	// if (soundalias == "none" || saytext == "none")
	// {
	// 	logprint("_quickmessages::quickstatements soundalias or saytext is none\n");
	// 	return;
	// }

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait level.fps_multiplier * 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

quickresponses(response)
{
	if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis") || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;
	// soundalias = "none";
	// saytext = "none";

	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])
		{
		case "american":
			switch(response)
			{
			case "1":
				soundalias = "american_yes_sir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				//saytext = "Yes Sir!";
				break;

			case "2":
				soundalias = "american_no_sir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				//saytext = "No Sir!";
				break;

			case "3":
				soundalias = "american_on_my_way";
				saytext = &"QUICKMESSAGE_ON_MY_WAY";
				//saytext = "On my way.";
				break;

			case "4":
				soundalias = "american_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				//saytext = "Sorry.";
				break;

			case "5":
				soundalias = "american_great_shot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				//saytext = "Great shot!";
				break;

			case "6":
				soundalias = "american_took_long_enough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				//saytext = "Took long enough!";
				break;
			case "7":
				// soundalias = "american_youre_crazy";
				// saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
				// //saytext = "Are you crazy?";
				// break;
				temp = randomInt(3);

				if(temp == 0)
				{
					soundalias = "american_youre_crazy";
					saytext = &"QUICKMESSAGE_YOURE_CRAZY";
					//saytext = "You're crazy!";
				}
				else if(temp == 1)
				{
					soundalias = "american_you_outta_your_mind";
					saytext = &"QUICKMESSAGE_YOU_OUTTA_YOUR_MIND";
					//saytext = "You outta your mind?";
				}
				else
				{
					soundalias = "american_youre_nuts";
					saytext = &"QUICKMESSAGE_YOURE_NUTS";
					//saytext = "You're nuts!";
				}
				break;
			default:
				logprint("_quickmessages::quickresponses unknown response=" + response + "\n");
				break;
			}
			break;

		case "british":
			switch(response)
			{
			case "1":
				soundalias = "british_yes_sir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				//saytext = "Yes Sir!";
				break;

			case "2":
				soundalias = "british_no_sir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				//saytext = "No Sir!";
				break;

			case "3":
				soundalias = "british_on_my_way";
				saytext = &"QUICKMESSAGE_ON_MY_WAY";
				//saytext = "On my way.";
				break;

			case "4":
				soundalias = "british_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				//saytext = "Sorry.";
				break;

			case "5":
				soundalias = "british_great_shot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				//saytext = "Great shot!";
				break;

			case "6":
				soundalias = "british_took_long_enough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				//saytext = "Took long enough!";
				break;

			case "7":
				soundalias = "british_youre_crazy";
				saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
				//saytext = "Are you crazy?";
				break;
			default:
				logprint("_quickmessages::quickresponses unknown response=" + response + "\n");
				break;
			}
			break;

		case "russian":
			switch(response)
			{
			case "1":
				soundalias = "russian_yes_sir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				//saytext = "Yes Sir!";
				break;

			case "2":
				soundalias = "russian_no_sir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				//saytext = "No Sir!";
				break;

			case "3":
				soundalias = "russian_no_sir";
				saytext = &"QUICKMESSAGE_ON_MY_WAY";
				//saytext = "On my way.";
				break;

			case "4":
				soundalias = "russian_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				//saytext = "Sorry.";
				break;

			case "5":
				soundalias = "russian_great_shot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				//saytext = "Great shot!";
				break;

			case "6":
				soundalias = "russian_took_long_enough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				//saytext = "Took long enough!";
				break;

			case "7":
				soundalias = "russian_youre_crazy";
				saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
				//saytext = "Are you crazy?";
				break;
			default:
				logprint("_quickmessages::quickresponses unknown response=" + response + "\n");
				break;
			}
			break;
		default:
			logprint("_quickmessages::quickresponses unknown game[allies]=" + game["allies"] + "\n");
			break;
		}
	}
	else if (self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			switch(response)
			{
			case "1":
				soundalias = "german_yes_sir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				//saytext = "Yes Sir!";
				break;

			case "2":
				soundalias = "german_no_sir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				//saytext = "No Sir!";
				break;

			case "3":
				soundalias = "german_on_my_way";
				saytext = &"QUICKMESSAGE_ON_MY_WAY";
				//saytext = "On my way.";
				break;

			case "4":
				soundalias = "german_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				//saytext = "Sorry.";
				break;

			case "5":
				soundalias = "german_great_shot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				//saytext = "Great shot!";
				break;

			case "6":
				soundalias = "german_took_long_enough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				//saytext = "Took long enough!";
				break;
			case "7":
				soundalias = "german_are_you_crazy";
				saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
				//saytext = "Are you crazy?";
				break;
			default:
				logprint("_quickmessages::quickresponses unknown response=" + response + "\n");
				break;
			}
			break;
		default:
			logprint("_quickmessages::quickresponses unknown game[axis]=" + game["axis"] + "\n");
			break;
		}
	} else {
		logprint("_quickmessages::responses unknown game[team]=" + game["team"] + "\n");
	}

	// if (soundalias == "none" || saytext == "none")
	// {
	// 	logprint("_quickmessages::quickresponses soundalias or saytext is none\n");
	// 	return;
	// }

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait level.fps_multiplier * 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

doQuickMessage(soundalias, saytext)
{
	if(self.sessionstate != "playing")
		return;

	if(isdefined(level.QuickMessageToAll) && level.QuickMessageToAll)
	{
		if ( !isDefined(level.in_strattime) || (isDefined(level.in_strattime) && !level.in_strattime) )
		{
			self.headiconteam = "none";
			self.headicon = "gfx/hud/headicon@quickmessage";
		}

		self playSound(soundalias);
		self sayAll(saytext);
	}
	else
	{
		if(self.sessionteam == "allies")
			self.headiconteam = "allies";
		else if(self.sessionteam == "axis")
			self.headiconteam = "axis";

		if ( !isDefined(level.in_strattime) || (isDefined(level.in_strattime) && !level.in_strattime) )
			self.headicon = "gfx/hud/headicon@quickmessage";

		self playSound(soundalias);
		self sayTeam(saytext);
		self pingPlayer();
	}
}

saveHeadIcon()
{
	if(isdefined(self.headicon))
		self.oldheadicon = self.headicon;

	if(isdefined(self.headiconteam))
		self.oldheadiconteam = self.headiconteam;
}

restoreHeadIcon()
{
	if(isdefined(self.oldheadicon))
		self.headicon = self.oldheadicon;

	if(isdefined(self.oldheadiconteam))
		self.headiconteam = self.oldheadiconteam;
}