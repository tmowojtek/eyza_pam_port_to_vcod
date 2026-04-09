logStats()
{
    s = "[STATS_EVENT]";
    s += "r=" + game["roundsplayed"] + ",";
    s += "as=" + game["allies_score"] + ",";
    s += "xs=" + game["axis_score"] + ",";
    s += "rw=" + level.roundwinner + ",";
    ht = "0";
    if (isDefined(game["is_halftime"]) && game["is_halftime"]) ht = "1";
    s += "ht=" + ht + ",";
    bp = "0";
    if (isDefined(level.bombplanted) && level.bombplanted) bp = "1";
    s += "bp=" + bp + ",";
    s += "ps=";
    first = true;
    for (i = 0; i < game["playerstats"].size; i++) {
        ps = game["playerstats"][i];
        if (!isDefined(ps) || !isDefined(ps["deleted"]) || ps["deleted"]) continue;
        if (!first) s += "|";
        first = false;
        s += ps["name"] + ":" + ps["team"] + ":" + ps["kills"] + ":" + ps["deaths"] + ":" + ps["assists"] + ":" +
        ps["damage"] + ":" + ps["grenades"] + ":" + ps["plants"] + ":" + ps["defuses"] + ":" + ps["score"];
    }
    logPrint(s + "\n");
}