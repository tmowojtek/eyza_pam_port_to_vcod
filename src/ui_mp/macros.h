/*
Text items are aligned to left bottom corner of text

ITEM_ALIGN_LEFT:
				Text location
				+
ITEM_ALIGN_CENTER:
	   Text aligned to center
				+
ITEM_ALIGN_RIGHT:
	 Text location
				 +

doubleclick
*/

#define ITEM_TEXT(textstring, x, y, fontsize, txtalign, fontcolor) \
itemDef \
{ \
	rect			x y 0 0 \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		fontcolor \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		fontsize \
	textalign		txtalign \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	decoration \
}

#define ITEM_TEXT_CVAR(textstring, x, y, fontsize, txtalign, fontcolor, cvartotest, cvarshowhide) \
itemDef \
{ \
	rect			x y 0 0 \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		fontcolor \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		fontsize \
	textalign		txtalign \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvartest		cvartotest \
	cvarshowhide \
	decoration \
}

#define ITEM_CVAR(cvarStr, x, y, fontsize, txtalign, fontcolor) \
itemDef \
{ \
	rect			0 0 200 50 \
	origin			x y \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		fontcolor \
	textfont		UI_FONT_NORMAL \
	textscale		fontsize \
	textalign		txtalign \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvar			cvarStr \
	decoration \
}

#define ITEM_CVAR_CVAR(cvarStr, x, y, fontsize, txtalign, fontcolor, cvartotest, cvarshowhide) \
itemDef \
{ \
	rect			0 0 200 50 \
	origin			x y \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		fontcolor \
	textfont		UI_FONT_NORMAL \
	textscale		fontsize \
	textalign		txtalign \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvar			cvarStr \
	cvartest		cvartotest \
	cvarshowhide \
	decoration \
}

#define ITEM_BAR_BOTTOM_BUTTON_CVAR(textstring, x, w, cvartotest, cvarshowhide, actions)  \
itemDef \
{ \
	visible			1 \
	rect			0 0 w 24 \
	origin			x 438 \
	forecolor		1 1 1 0.2 \
	type			ITEM_TYPE_BUTTON \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		0.3 \
	textaligny		18 \
	cvartest		cvartotest \
	cvarshowhide \
	action \
	{ \
		play "mouse_click"; \
		actions ; \
	} \
	onFocus \
	{ \
		play "mouse_over"; \
	} \
}

#define ITEM_BAR_BOTTOM_BUTTON_CVAR_DISABLED(textstring, x, w, cvartotest, cvarshowhide)  \
itemDef \
{ \
	visible			1 \
	rect			0 0 w 24 \
	origin			x 438 \
	forecolor		1.0 1.0 0.0 1.0 /*GLOBAL_DISABLED_COLOR*/ \
	type			ITEM_TYPE_BUTTON \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		0.3 \
	textaligny		18 \
	cvartest		cvartotest \
	cvarshowhide \
}

#define ITEM_BAR_BOTTOM_BUTTON(textstring, x, w, actions)  \
itemDef \
{ \
	visible			1 \
	rect			0 0 w 24 \
	origin			x 438 \
	forecolor		1 1 1 1 \
	type			ITEM_TYPE_BUTTON \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		0.3 \
	textaligny		18 \
	action \
	{ \
		play "mouse_click"; \
		actions ; \
	} \
	onFocus \
	{ \
		play "mouse_over"; \
	} \
}


#define DRAW_MAP_BACKGROUND_IF_BLACKOUT \
itemDef \
{ \
	rect 			0 0 640 480 \
	visible 		1 \
	backcolor 		1 1 1 1 \
	style 			WINDOW_STYLE_FILLED \
	background 		"hud@layout_default.dds" \
	cvartest 		"ui_blackout" \
	showcvar		{ "1" } \
	decoration \
}

//0.149 .227 0.294 .5
#define DRAW_BLUISH_BACKGROUND \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			0 0 640 480 \
	backcolor		0.083 .129 0.168 0 \
	visible			1 \
	decoration \
}

#define DRAW_TRANSPARENT_BACKGROUND \
itemDef \
{ \
			visible			1 \
			rect			-800 -100 2000 800 \
			style			WINDOW_STYLE_SHADER  \
			background		"ui_mp/assets/hud@window_background.tga" \
			decoration \
}

#define	DRAW_GRADIENT_LEFT_TO_RIGHT \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			-128 0 896 480 \
	background		"gradient" \
	visible			1 \
	decoration \
}

#define	DRAW_GRADIENT_FOR_SUBMENU(x, y, w, h, alpha) \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			x y w h \
	backcolor		0 0 0 alpha \
	visible			1 \
	decoration \
} \
itemDef  \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			x y 1 h \
	backcolor		.631 .666 .698 .2 \
	visible			1 \
	decoration \
} \

#define DRAW_BARS \
itemDef  \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			-128 0 896 60 \
	backcolor		0.0045 .005 0.0053 .95 \
	visible			1 \
	decoration \
} \
itemDef  \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			-128 435 896 45 \
	backcolor		0.0045 .005 0.0053 .95 \
	visible			1 \
	decoration \
} \
itemDef  \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			-128 60 896 1 \
	backcolor		.631 .666 .698 .2 \
	visible			1 \
	decoration \
} \
itemDef  \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			-128 435 896 1 \
	backcolor		.631 .666 .698 .2 \
	visible			1 \
	decoration \
}

#define ITEM_TEXT_HEADING(teamname) \
itemDef \
{ \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	origin			40 60 \
	forecolor		1 1 1 1 \
	text			teamname \
	textfont		UI_FONT_NORMAL \
	textscale		0.5 /*GLOBAL_HEADER_SIZE*/ \
	decoration \
}




#define ORIGIN_CHOICE1	60 84
#define ORIGIN_CHOICE2	60 108
#define ORIGIN_CHOICE3	60 132
#define ORIGIN_CHOICE4	60 156
#define ORIGIN_CHOICE5	60 180
#define ORIGIN_CHOICE6	60 204
#define ORIGIN_CHOICE7	60 228
#define ORIGIN_CHOICE8	60 252
#define ORIGIN_CHOICE9	60 276
#define ORIGIN_CHOICE10	60 300
#define ORIGIN_CHOICE11	60 324
#define ORIGIN_CHOICE12	60 348
#define ORIGIN_CHOICE13	60 372

#define ITEM_BUTTON(origin_choice, textstring, dofocus, doaction) \
itemDef  \
{ \
	visible			1 \
	rect			0 0 128 24 \
	origin			origin_choice \
	forecolor		1 1 1 1 \
	type			ITEM_TYPE_BUTTON \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		0.24 /*GLOBAL_TEXT_SIZE*/ \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		20 \
	action \
	{ \
		play "mouse_click"; \
		doaction; \
	} \
	onFocus \
	{ \
		play "mouse_over"; \
		dofocus; \
	} \
}


#define ITEM_BUTTON_ONCVAR(origin_choice, textstring, cvarstring, cvarvisible, dofocus, doaction) \
itemDef  \
{ \
	visible			1 \
	rect			0 0 128 24 \
	origin			origin_choice \
	forecolor		1.0 1.0 1.0 1.0 /*GLOBAL_UNFOCUSED_COLOR*/ \
	type			ITEM_TYPE_BUTTON \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		0.24 /*GLOBAL_TEXT_SIZE*/ \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		20 \
	cvartest		cvarstring \
	cvarvisible \
	action \
	{ \
		play "mouse_click"; \
		doaction; \
	} \
	onFocus \
	{ \
		play "mouse_over"; \
		dofocus; \
	} \
}

#define ITEM_BUTTON_ONCVAR_DISABLED(origin_choice, textstring, cvarstring, cvarvisible, dofocus) \
itemDef  \
{ \
	visible			1 \
	rect			0 0 128 24 \
	origin			origin_choice \
	forecolor		1.0 1.0 1 0.2 /*GLOBAL_DISABLED_COLOR*/ \
	type			ITEM_TYPE_BUTTON \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		0.24 /*GLOBAL_TEXT_SIZE*/ \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		20 \
	cvartest		cvarstring \
	cvarvisible \
	onFocus \
	{ \
		play "mouse_over"; \
		dofocus; \
	} \
	decoration \
}






#define ORIGIN_WEAPONIMAGE			310 110
#define ORIGIN_GRENADESLOT1			310 170
#define ORIGIN_GRENADESLOT2			330 170
#define ORIGIN_USEDBY						310 250
#define ORIGIN_USEDBY2					320 263

#define ITEM_WEAPON_SMOKE(originpos, stringname, weaponname, stringtext, cvartext, weaponimage, focusaction, doaction, grenadeimage, weaponclass) \
ITEM_WEAPON(originpos, stringname, weaponname, stringtext, cvartext, weaponimage, focusaction, doaction, grenadeimage, weaponclass) \
itemDef \
{ \
	name			weaponimage \
	visible 		0 \
	rect			0 0 32 32 \
	origin			ORIGIN_GRENADESLOT2 \
	style			WINDOW_STYLE_SHADER \
	background		"hud_us_smokegrenade_C" \
	decoration \
}

#define ITEM_WEAPON(originpos, stringname, weaponname, stringtext, cvartext, weaponimage, focusaction, doaction, grenadeimage, weaponclass) \
itemDef \
{ \
	name			stringname \
	visible			1 \
	rect			0 0 128 24 \
	origin			originpos \
	forecolor		1 1 1 1 \
	type			ITEM_TYPE_BUTTON \
	text			stringtext \
	textfont		UI_FONT_NORMAL \
	textscale		0.24 /*GLOBAL_TEXT_SIZE*/ \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		20 \
	cvartest		cvartext \
	showcvar		{ "1" } \
	action \
	{ \
		play "mouse_click"; \
		doaction \
	} \
	onFocus \
	{ \
		HIDE_ALL \
		play "mouse_over"; \
		focusaction \
	} \
} \
itemDef  \
{ \
	name			stringname \
	visible			1 \
	rect			0 0 128 24 \
	origin			originpos \
	forecolor		1 1 1 0.2 \
	type			ITEM_TYPE_BUTTON \
	text			"" \
	textfont		UI_FONT_NORMAL \
	textscale		0.24 /*GLOBAL_TEXT_SIZE*/ \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		20 \
	cvartest		cvartext \
	showcvar		{ "2" } \
	onFocus \
	{ \
		HIDE_ALL \
		focusaction \
	} \
} \
itemDef  \
{ \
	name			stringname \
	visible			1 \
	rect			0 0 128 24 \
	origin			originpos \
	forecolor		0.5 0.5 0.5 0.5 /*GLOBAL_DISABLED_COLOR*/ \
	type			ITEM_TYPE_BUTTON \
	text			stringtext \
	textfont		UI_FONT_NORMAL \
	textscale		0.24 /*GLOBAL_TEXT_SIZE*/ \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		20 \
	cvartest		cvartext \
	showcvar		{ "2" } \
	decoration \
} \
 \
itemDef  \
{ \
	name			stringname \
	visible			1 \
	rect			0 0 128 24 \
	origin			originpos \
	forecolor		1 1 1 1  \
	type			ITEM_TYPE_BUTTON \
	text			stringtext \
	textfont		UI_FONT_NORMAL \
	textscale		0.24 /*GLOBAL_TEXT_SIZE*/ \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		20 \
	cvartest		cvartext \
	showcvar		{ "3" } \
	action \
	{ \
		play "mouse_click"; \
		doaction \
	} \
	onFocus \
	{ \
		HIDE_ALL \
		play "mouse_over"; \
		focusaction \
	} \
} \
 \
itemDef \
{ \
	name			weaponimage \
	visible 		0 \
	rect			0 0 224 112 \
	origin			ORIGIN_WEAPONIMAGE \
	style			WINDOW_STYLE_SHADER \
	background		"ui_mp/assets/hud@" weaponimage ".tga" \
	decoration \
} \
itemDef  \
{ \
	name			weaponimage \
	visible			0 \
	origin			ORIGIN_USEDBY \
	forecolor		1 1 1 1 \
	text 			"Used by:" \
	type			ITEM_TYPE_TEXT \
	textfont		UI_FONT_NORMAL \
	textscale		0.3 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		ITEM_ALIGN_LEFT \
	cvartest		"ui_weapons_usedby_" weaponname \
	hideCvar		{ "" } \
	decoration \
} \
itemDef  \
{ \
	name			weaponimage \
	visible			0 \
	origin			ORIGIN_USEDBY2 \
	forecolor		1 1 1 1 \
	type			ITEM_TYPE_TEXT \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		ITEM_ALIGN_LEFT \
	cvar			"ui_weapons_usedby_" weaponname \
	cvartest		"ui_weapons_usedby_" weaponname \
	hideCvar		{ "" } \
	decoration \
}







#define SERVERINFO_DRAW_OBJECTIVE \
itemDef \
{ \
	visible			1 \
	rect			0 0 480 75 \
	origin			60 84 \
	forecolor		1 1 1 1 \
	autowrapped \
	cvar				"cg_objective" \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		16 \
	decoration \
}

#define SERVERINFO_DRAW_PARAMETERS \
itemDef \
{ \
	visible			1 \
	rect			0 0 180 110 \
	origin			170 180 \
	forecolor		1 1 1 1 \
	cvar			"ui_serverinfo_left1" \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		ITEM_ALIGN_RIGHT \
	autowrapped \
	decoration \
} \
itemDef  \
{ \
	visible			1 \
	rect			0 0 128 110 \
	origin			185 180 \
	forecolor		1 1 1 1 \
	cvar			"ui_serverinfo_left2" \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		ITEM_ALIGN_LEFT \
	autowrapped \
	decoration \
} \
itemDef \
{ \
	visible			1 \
	rect			0 0 180 110 \
	origin			390 180 \
	forecolor		1 1 1 1 \
	cvar			"ui_serverinfo_right1" \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		ITEM_ALIGN_RIGHT \
	autowrapped \
	decoration \
} \
itemDef  \
{ \
	visible			1 \
	rect			0 0 128 110 \
	origin			405 180 \
	forecolor		1 1 1 1 \
	cvar			"ui_serverinfo_right2" \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		ITEM_ALIGN_LEFT \
	autowrapped \
	decoration \
}

#define SERVERINFO_DRAW_MOTD \
itemDef \
{ \
	name			"text_motd" \
	visible			1 \
	rect			0 0 480 130 \
	origin			60 250 \
	forecolor		1 1 1 1 \
	autowrapped \
	cvar			"ui_motd" \
	textfont		UI_FONT_NORMAL \
	textscale		0.25 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		16 \
	decoration \
} \
itemDef \
{ \
	name			"text_serverversion" \
	visible			1 \
	rect			0 0 480 130 \
	origin			60 410 \
	forecolor		1 1 1 .4 \
	cvar			"ui_serverversion" \
	textfont		UI_FONT_NORMAL \
	textscale		0.2 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textaligny		16 \
	decoration \
}

#define SERVERINFO_DRAW_QUIT \
itemDef \
{ \
	visible 		1 \
	rect			-128 60 896 375  \
	type 			ITEM_TYPE_BUTTON \
	action \
	{ \
		scriptMenuResponse "close"; \
	} \
}


#define RCON_UPDATE_STATUS execOnDvarStringValue ui_rcon_logged_in 0 "vstr ui_rcon_hash";




#define QUICKMESSAGE_LINE_TEXT(y, textstring, fontcolor)  \
itemDef \
{ \
	name			"window" \
	visible			1 \
	rect			16 y 0 0 \
	origin			ORIGIN_QUICKMESSAGEWINDOW \
	forecolor		fontcolor \
	textfont		UI_FONT_NORMAL \
	textscale		.24 \
	textaligny		8 \
	textstyle ITEM_TEXTSTYLE_SHADOWED \
	text			textstring \
	decoration \
}

#define QUICKMESSAGE_LINE_TEXT_CVAR(y, textstring, fontcolor, cvarstring, dvarvisible)  \
itemDef \
{ \
	name			"window" \
	visible			1 \
	rect			16 y 0 0 \
	origin			ORIGIN_QUICKMESSAGEWINDOW \
	forecolor		fontcolor \
	textfont		UI_FONT_NORMAL \
	textscale		.24 \
	textaligny		8 \
	textstyle ITEM_TEXTSTYLE_SHADOWED \
	text			textstring \
	cvartest		cvarstring \
	cvarvisible \
	decoration \
}


#define CVAR_CHECK(textstring, cvartotest, cvarshowhide) \
itemDef \
{ \
	rect 			-128 0 896 480 \
	visible 		1 \
	backcolor 		1 1 1 1 \
	style 			WINDOW_STYLE_FILLED \
	background 		"$levelBriefing" \
	cvartest		cvartotest \
	cvarshowhide \
	decoration \
} \
itemDef \
{ \
	rect			0 0 200 50 \
	origin			320 100 \
	type			ITEM_TYPE_TEXT \
	text			textstring \
	visible			1 \
	forecolor		1 0 0 1 \
	textfont		UI_FONT_NORMAL \
	textscale		0.6 \
	textalign		ITEM_ALIGN_CENTER \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvartest		cvartotest \
	cvarshowhide \
	decoration \
}






#define MATCHINFO_BGCOLOR(xywh, bc, cvartotest, showhidecvar) \
itemDef \
{ \
  style			WINDOW_STYLE_FILLED \
  rect			xywh \
  backcolor		bc \
  visible		1 \
  cvartest		cvartotest \
  showhidecvar \
  decoration \
}

#define MATCHINFO_ICON(xy, bgimage, cvarteststr, showhidecvar) \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		xy 12 12 \
	backcolor	1 1 1 1 \
	visible		1 \
	background	bgimage \
	cvartest	cvartotest \
    showhidecvar \
	decoration \
}

#define MATCHINFO(cvar_team1_team, cvar_team2_team, cvar_show, color_allies, color_axis) \
\
	MATCHINFO_BGCOLOR(128 137 128 15, color_allies, cvar_team1_team, showcvar { "american"; "british"; "russian"; })  \
	MATCHINFO_BGCOLOR(128 137 128 15, color_axis, cvar_team1_team, showcvar { "german" })  \
\
	MATCHINFO_BGCOLOR(128 151 128 1, .1 .1 .1 .55, cvar_team1_team, showcvar { "american"; "british"; "russian"; "german" }) \
	MATCHINFO_ICON(131 138, "gfx/hud/headicon@allies.dds", cvar_team1_team, showcvar { "american" } ) \
	MATCHINFO_ICON(131 138, "gfx/hud/headicon@allies.dds", cvar_team1_team, showcvar { "british" } ) \
	MATCHINFO_ICON(131 138, "gfx/hud/headicon@russian.tga", cvar_team1_team, showcvar { "russian" } ) \
	MATCHINFO_ICON(131 138, "gfx/hud/headicon@german.tga", cvar_team1_team, showcvar { "german" } ) \
\
\
	MATCHINFO_BGCOLOR(640 137 128 15, color_allies, cvar_team2_team, showcvar { "american"; "british"; "russian"; }) \
	MATCHINFO_BGCOLOR(640 137 128 15, color_axis, cvar_team2_team, showcvar { "german" }) \
\
	MATCHINFO_BGCOLOR(640 151 128 1, .1 .1 .1 .55, cvar_team2_team, showcvar { "american"; "british"; "russian"; "german" }) \
	MATCHINFO_ICON(642 138, "gfx/hud/headicon@allies.dds", cvar_team2_team, showcvar { "american" } ) \
	MATCHINFO_ICON(642 138, "gfx/hud/headicon@allies.dds", cvar_team2_team, showcvar { "british" } ) \
	MATCHINFO_ICON(642 138, "gfx/hud/headicon@russian.tga", cvar_team2_team, showcvar { "russian" } ) \
	MATCHINFO_ICON(642 138, "gfx/hud/headicon@german.tga", cvar_team2_team, showcvar { "german" } ) \
\
	ITEM_CVAR_CVAR("ui_matchinfo_team1_name", 144, 149, .2, ITEM_ALIGN_LEFT, 1 1 1 1, cvar_show, showcvar { "1" }) \
	ITEM_CVAR_CVAR("ui_matchinfo_team2_name", 656, 149, .2, ITEM_ALIGN_LEFT, 1 1 1 1, cvar_show, showcvar { "1" }) \
\
	ITEM_CVAR_CVAR("ui_matchinfo_round", 448, 478, .2, ITEM_ALIGN_CENTER, 1 1 1 1, cvar_show, showcvar { "1" })




#define STREAMERSYSTEM_COLOR_HIGHLIGHT .9 .9 .9 1
#define STREAMERSYSTEM_COLOR_BG_ALIVE_DEAD_BG .0 .0 .0 .6
#define STREAMERSYSTEM_COLOR_BG_ALIVE_DEAD_FG .0 .0 .0 .3

#define ITEM_STREAMERSYSTEM_LINE(cvarprefix, num, x_offset, y_offset, color_allies, color_axis, color_background_allies_alive, color_background_axis_alive) \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 130 25 \
	origin		-1 -1 \
	backcolor	STREAMERSYSTEM_COLOR_HIGHLIGHT \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "0_";  "10_allies_";"10_axis_";  "50_allies_";"50_axis_";  "80_allies_"; "80_axis_";  "100_allies_";"100_axis_" } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 128 23 \
	backcolor	color_background_allies_alive \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "10_allies"; "50_allies"; "80_allies"; "100_allies";    "10_allies_"; "50_allies_"; "80_allies_"; "100_allies_" } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 128 23 \
	backcolor	color_background_axis_alive \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "10_axis"; "50_axis"; "80_axis"; "100_axis";    "10_axis_"; "50_axis_"; "80_axis_"; "100_axis_" } \
	decoration \
} \
\
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 128 12 \
	backcolor	color_allies \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "100_allies"; "100_allies_" } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 128 12 \
	backcolor	color_axis \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "100_axis"; "100_axis_" } \
	decoration \
} \
\
\
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 104 12 \
	backcolor	color_allies \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "80_allies"; "80_allies_" } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 104 12 \
	backcolor	color_axis \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "80_axis"; "80_axis_" } \
	decoration \
} \
\
\
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 65 12 \
	backcolor	color_allies \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "50_allies"; "50_allies_" } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 65 12 \
	backcolor	color_axis \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "50_axis"; "50_axis_" } \
	decoration \
} \
\
\
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 10 12 \
	backcolor	color_allies \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "10_allies"; "10_allies_" } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 10 12 \
	backcolor	color_axis \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "10_axis"; "10_axis_" } \
	decoration \
} \
\
\
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 10 9 \
	backcolor	1 1 1 .5 \
	origin		116 13 \
	visible		1 \
	background	"gfx/icons/hud@us_grenade.tga" \
	cvartest	cvarprefix "_icons" \
	showcvar	{ "grenade"; "grenade_smoke"; "grenade2_smoke"; "grenade2"; } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 10 9 \
	backcolor	1 1 1 .5 \
	origin		107 13 \
	visible		1 \
	background	"gfx/icons/hud@us_grenade.tga" \
	cvartest	cvarprefix "_icons" \
	showcvar	{ "grenade2"; "grenade2_smoke"; } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 10 9 \
	backcolor	1 1 1 .5 \
	origin		107 13 \
	visible		1 \
	background	"hud_us_smokegrenade" \
	cvartest	cvarprefix "_icons" \
	showcvar	{ "smoke"; "grenade_smoke"; "grenade2_smoke";  } \
	decoration \
} \
\
\
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 128 23 \
	backcolor	STREAMERSYSTEM_COLOR_BG_ALIVE_DEAD_BG \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "0"; "0_" } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 15 15 \
	backcolor	1 1 1 .5 \
	origin		112 4 \
	visible		1 \
	background	"gfx/hud/death_suicide.tga" \
	cvartest	cvarprefix "_health" \
	showcvar	{ "0"; "0_";  } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 12 10 \
	origin		132 3 \
	backcolor	1 1 1 .9 \
	visible		1 \
	background	"ui/assets/scrollbar_arrow_left.tga" \
	cvartest	cvarprefix "_health" \
	showcvar	{ "0_";  "10_allies_";"10_axis_";  "50_allies_";"50_axis_";  "80_allies_"; "80_axis_";  "100_allies_";"100_axis_" } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 12 10 \
	origin		-14 3 \
	backcolor	1 1 1 .9 \
	visible		1 \
	background	"ui/assets/scrollbar_arrow_right.tga" \
	cvartest	cvarprefix "_health" \
	showcvar	{ "0_";  "10_allies_";"10_axis_";  "50_allies_";"50_axis_";  "80_allies_"; "80_axis_";  "100_allies_";"100_axis_" } \
	decoration \
} \
itemDef \
{ \
	rect			x_offset y_offset 0 0 \
	origin			123 -1 \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		1 1 1 0.2 \
	textfont		UI_FONT_NORMAL \
	textscale		.15 \
	textalign		ITEM_ALIGN_RIGHT \
	textaligny		11 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	text			num \
	cvartest		cvarprefix "_health" \
	hidecvar		{ ""; "0"; "0_" } \
	decoration \
} \
itemDef \
{ \
	rect			x_offset y_offset 0 0 \
	origin			5 0 \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		1 1 1 1 \
	textfont		UI_FONT_NORMAL \
	textscale		.18 \
	textalign		ITEM_ALIGN_LEFT \
	textaligny		11 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvar			cvarprefix "_name" \
	cvartest		cvarprefix "_health" \
	hidecvar		{ "" } \
	decoration \
} \
itemDef \
{ \
	rect			x_offset y_offset 0 0 \
	origin			5 9 \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		1 1 1 .7 \
	textfont		UI_FONT_NORMAL \
	textscale		.16 \
	textalign		ITEM_ALIGN_LEFT \
	textaligny		12 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvar			cvarprefix "_score" \
	cvartest		cvarprefix "_health" \
	hidecvar		{ "" } \
	decoration \
} \
itemDef \
{ \
	rect			x_offset y_offset 0 0 \
	origin			30 9 \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		1 1 1 .7 \
	textfont		UI_FONT_NORMAL \
	textscale		.15 \
	textalign		ITEM_ALIGN_LEFT \
	textaligny		12 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvar			cvarprefix "_weapon" \
	cvartest		cvarprefix "_health" \
	hidecvar		{ "" } \
	decoration \
} \
itemDef \
{ \
	rect			x_offset y_offset 0 0 \
	origin			96 9 \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		1 1 1 1 \
	textfont		UI_FONT_NORMAL \
	textscale		.18 \
	textalign		ITEM_ALIGN_LEFT \
	textaligny		12 \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvar			cvarprefix "_round_kills" \
	cvartest		cvarprefix "_health" \
	hidecvar		{ "" } \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		x_offset y_offset 128 23 \
	backcolor	STREAMERSYSTEM_COLOR_BG_ALIVE_DEAD_FG \
	visible		1 \
	cvartest	cvarprefix "_health" \
	showcvar	{ "0"; "0_" } \
	decoration \
}






#define ITEM_STREAMERSYSTEM_KEY(textstring, x, y, fontSize, cvarStr) \
itemDef \
{ \
	visible			1 \
	rect			0 0 1 1 \
	origin			x y \
	forecolor		0.75 0.75 0.75 1 \
	type			ITEM_TYPE_TEXT \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		fontSize \
	cvartest		cvarStr \
	showCvar		{ "1"; } \
	decoration \
}


#define ITEM_STREAMERSYSTEM_CVAR(x, y, fontsize, cvarStr, text_align) \
itemDef \
{ \
	visible			1 \
	rect			0 0 0 0 \
	origin			x y \
	forecolor		0.75 0.75 0.75 1 \
	type			ITEM_TYPE_TEXT \
	textfont		UI_FONT_NORMAL \
	textscale		fontsize \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		text_align \
	cvar			cvarStr \
	decoration \
}

#define ITEM_STREAMERSYSTEM_BG(rect2, bgcolor, cvarStr, showhide) \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	visible			1 \
	rect			rect2 \
	backcolor		bgcolor \
	cvartest		cvarStr \
	showhide \
	decoration \
}







#define SCOREBOARD_TEXT_ALIGNY 10
#define SCOREBOARD_HEADING_ALIGNY 25

// Text headings of columns
#define SCOREBOARD_SCORE_TEXT_X 174
#define SCOREBOARD_KILLS_TEXT_X 210
#define SCOREBOARD_DEATHS_TEXT_X 228
#define SCOREBOARD_ASSISTS_TEXT_X 246
#define SCOREBOARD_ADR_TEXT_X 267
//#define SCOREBOARD_DAMAGE_TEXT_X 324
#define SCOREBOARD_GRENADES_TEXT_X 295
#define SCOREBOARD_GRENADE_DAMAGE_TEXT_X 323
//#define SCOREBOARD_GRENADES_TEXT_X_LINE 348	// aligned right
#define SCOREBOARD_PLANTS_TEXT_X 351
#define SCOREBOARD_DEFUSES_TEXT_X 388
#define SCOREBOARD_DEFUSES_TEXT_X_LINE 384	// last one is aligned right

// Columns
#define SCOREBOARD_HEADING_X 15
#define SCOREBOARD_NAME_X 33

#define SCOREBOARD_TEAM_X 15
#define SCOREBOARD_SCORE_X 167
#define SCOREBOARD_KILLS_X 208
#define SCOREBOARD_DEATHS_X 226
#define SCOREBOARD_ASSISTS_X 244
#define SCOREBOARD_ADR_X 260
//#define SCOREBOARD_DAMAGE_X 322
#define SCOREBOARD_GRENADES_X 293
#define SCOREBOARD_GRENADE_DAMAGE_X 316
#define SCOREBOARD_PLANTS_X 349
#define SCOREBOARD_DEFUSES_X 382




#define ITEM_SCOREBOARD_HEADING(x, y, textstring, x_offset, y_offset, fontsize, txtalign, line_x, line_y, line_height) \
itemDef \
{ \
	rect			x_offset y_offset 1 1 \
	origin			x y \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		1 1 1 1 \
	text			textstring \
	textfont		UI_FONT_NORMAL \
	textscale		fontsize \
	textalign		txtalign \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvartest		"ui_scoreboard_visible" \
	showcvar		{ "1"; } \
	decoration \
}  \
itemDef \
{ \
	style			WINDOW_STYLE_FILLED \
	rect			line_x line_y 0.75 line_height \
    origin			x y \
	backcolor		1 1 1 .1 \
	visible			1 \
	cvartest		"ui_scoreboard_visible" \
	showcvar		{ "1"; } \
	decoration \
}


#define ITEM_SCOREBOARD_COLUMN(x, y, cvarStr, x_offset, y_offset, fontsize, txtalign) \
itemDef \
{ \
	rect			x_offset y_offset 200 50 \
	origin			x y \
	type			ITEM_TYPE_TEXT \
	visible			1 \
	forecolor		1 1 1 1 \
	textfont		UI_FONT_NORMAL \
	textscale		fontsize \
	textalign		txtalign \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	cvar			cvarStr \
	decoration \
}


#define ITEM_SCOREBOARD(x, y) \
\
	ITEM_SCOREBOARD_HEADING(x, y, "Score",    SCOREBOARD_SCORE_TEXT_X,   	23, .21, ITEM_ALIGN_CENTER, 	SCOREBOARD_SCORE_TEXT_X, 	25, 	30) \
	ITEM_SCOREBOARD_HEADING(x, y, "Kills",    SCOREBOARD_KILLS_TEXT_X,   	23, .21, ITEM_ALIGN_CENTER, 	SCOREBOARD_KILLS_TEXT_X, 	25, 	30) \
	ITEM_SCOREBOARD_HEADING(x, y, "Deaths",   SCOREBOARD_DEATHS_TEXT_X,  	33, .21, ITEM_ALIGN_CENTER, 	SCOREBOARD_DEATHS_TEXT_X, 	35, 	20) \
	ITEM_SCOREBOARD_HEADING(x, y, "Assists",  SCOREBOARD_ASSISTS_TEXT_X, 	23, .21, ITEM_ALIGN_CENTER, 	SCOREBOARD_ASSISTS_TEXT_X, 	25, 	30) \
	ITEM_SCOREBOARD_HEADING(x, y, "ADR", 	  SCOREBOARD_ADR_TEXT_X, 	33, .21, ITEM_ALIGN_CENTER, 	SCOREBOARD_ADR_TEXT_X, 	35, 	20) \
	ITEM_SCOREBOARD_HEADING(x, y, "Grenades", SCOREBOARD_GRENADES_TEXT_X,	23, .21, ITEM_ALIGN_CENTER, 	SCOREBOARD_GRENADES_TEXT_X, 	25, 	30) \
	ITEM_SCOREBOARD_HEADING(x, y, "Nade dmg", SCOREBOARD_GRENADE_DAMAGE_TEXT_X, 	33, .21, ITEM_ALIGN_CENTER, 	SCOREBOARD_GRENADE_DAMAGE_TEXT_X, 	35, 	20) \
	ITEM_SCOREBOARD_HEADING(x, y, "Plants",   SCOREBOARD_PLANTS_TEXT_X,  	23, .21, ITEM_ALIGN_CENTER, 	SCOREBOARD_PLANTS_TEXT_X, 	25, 	30) \
	ITEM_SCOREBOARD_HEADING(x, y, "Defuses",  SCOREBOARD_DEFUSES_TEXT_X, 	33, .21, ITEM_ALIGN_RIGHT,  	SCOREBOARD_DEFUSES_TEXT_X_LINE, 35, 	20) \
\
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_teams",	   SCOREBOARD_TEAM_X,     55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_names",    SCOREBOARD_NAME_X,     55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_scores",   SCOREBOARD_SCORE_X,    55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_kills",    SCOREBOARD_KILLS_X,    55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_deaths",   SCOREBOARD_DEATHS_X,   55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_assists",  SCOREBOARD_ASSISTS_X,  55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_adr",  SCOREBOARD_ADR_X,   55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_grenades", SCOREBOARD_GRENADES_X, 55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_grenade_damage",  SCOREBOARD_GRENADE_DAMAGE_X,   55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_plants",   SCOREBOARD_PLANTS_X,   55, .21, ITEM_ALIGN_LEFT) \
	ITEM_SCOREBOARD_COLUMN(x, y, "ui_scoreboard_defuses",  SCOREBOARD_DEFUSES_X,  55, .21, ITEM_ALIGN_LEFT)








// All sub-menus that can be possibly opened at the same time
#define CLOSE_SUBMENUS close ingame_keys; close team_britishgerman_keys; close team_americangerman_keys; close team_russiangerman_keys; close ingame_scoreboard_sd; close rcon_map; close rcon_map_maps; close rcon_map_pams; close rcon_map_other; close rcon_map_apply; close rcon_settings; close rcon_settings_shared; close rcon_settings_gametypes; close rcon_settings_focus; close rcon_kick; close aboutpam; close pammodes;
#define CLOSE_ALL CLOSE_SUBMENUS close ingame; close team_britishgerman; close team_americangerman; close team_russiangerman;