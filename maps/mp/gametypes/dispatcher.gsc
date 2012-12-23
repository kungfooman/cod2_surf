/*
thread maps\mp\gametypes\dispatcher::onStartGameType(); // 123123231
*/


onPlayerConnect()
{
	player = self;
	
	// this approuch depends on getGuid(),
	// cracked servers would need an account-system

	if (std\persistence::isActive())
	{
		guid = player getGuid();
		if (!player std\persistence::loginUser(guid, "secretLulz")) // try to login
		{
			std\persistence::createUser(guid, "secretLulz"); // hmk, than create the user first
			player std\persistence::loginUser(guid, "secretLulz"); // and then login
		}
		
		player std\hud_money::onPlayerConnect();
		player std\hud_rank::onPlayerConnect();
		
		// hide money (not used)
		player.huds["money_element"].alpha = 0;
		player.huds["money_value"].alpha = 0;
		
		//player thread std\stats::giveDebugStats(); // behind the init-huds

		std\stats::add("xp", 0); // update hud for first time
		std\stats::add("money", 0); // update hud for first time
	}

}

waittillPlayerConnect()
{
	while (1)
	{
		level waittill("connected", player);
		player thread onPlayerConnect();
	}
}

precache()
{
	std\mapvote::addMap("surf_utopia",        "white",        &"Utopia",        "Utopia");
	std\mapvote::addMap("surf_ag",          "white",          &"AG",          "AG");
	std\mapvote::addMap("surf_crazyfrog",    "white",    &"Crazy Frog",    "Crazy Frog");
	std\mapvote::addMap("surf_lasci", "white", &"Lasci", "Lasci");
	std\mapvote::addMap("surf_legends",        "white",        &"Legends",        "Legends");
	std\mapvote::addMap("surf_reload",        "white",        &"Reload",        "Reload");
	std\mapvote::addMap("surf_snowarena",         "white",         &"Snow Arena",         "Snow Arena");
	std\mapvote::addMap("surf_toast",   "white",   &"Toast",   "Toast");
	std\mapvote::precache();

	//std\ad::addAd(&"Many Thanks To: IzNoGod, Brutzel", 1.2, (0.8,0.8,0.8));
	std\ad::addAd(&"Visit killtube.org!", 2, (1,0,0));
	std\ad::precache();

	//precacheItem("tt30_mp");
	//precacheModel("xmodel/portal_orange_");
	//precacheModel("xmodel/portal_blue_");
	
	precacheItem("knife_mp");
	
	std\hud_money::precache();
	std\hud_rank::precache();
	
	std\item::precache();
}

onStartGameType()
{
	precache();
	
	host = getcvar("mysql_host");
	user = getcvar("mysql_user");
	pass = getcvar("mysql_pass");
	db = getcvar("mysql_db");
	port = getcvarint("mysql_port");
	
	if (host!="" && user!="" && pass!="" && db!="" && port!="")
	{
		std\mysql::make_global_mysql(host, user, pass, db, port);
		
		// order is important
		std\stats::statsEventAdd("money", std\persistence::eventAddGetMoney);
		std\stats::statsEventAddEver("money", std\hud_money::eventUpdate);
		std\stats::statsEventAdd("xp", std\persistence::eventAddGetXP);
		std\stats::statsEventAddEver("xp", std\hud_rank::eventUpdate);
	}
	
	thread std\ad::ad(); 
	thread waittillPlayerConnect();
	thread std\debugging::watchCloserCvar();
	thread std\debugging::watchScriptCvar();
	
	//thread std\test::test();
	

	
	//thread b3\_b3_main::init(); // B3 POWERADMIN
}

onEndMap()
{
	std\mysql::delete_global_mysql();
}