class CK7_GameplayHandler : EventHandler
{
	override void WorldThingDied(worldEvent e)
	{
		if (e.thing && e.thing.bISMONSTER && !e.thing.bBOSS)
		{
			e.thing.A_DropItem('CK7_ThinBlood');
		}
	}

	override void WorldThingDamaged(WorldEvent e)
	{
		if (e.thing.player && e.Damage > 0)
		{
			EventHandler.SendInterfaceEvent(e.thing.PlayerNumber(), "PlayerWasDamaged");
		}
	}
	
	override void InterfaceProcess(consoleEvent e)
	{
		if (e.name ~== "PlayerWasDamaged")
		{
			let hud = CK7_Hud(statusbar);
			if (hud)
			{
				hud.StartDamageWipe(60);
			}
		}
		
		// returns true if the event name CONTAINS "PlayedPickedUpItem" in it:
		if (e.name.IndexOf("PlayedPickedUpItem") >= 0)
		{
			array<String> cmd;
			e.name.Split(cmd, ":"); //splits the name of the event in two parts at ":"
			if (cmd.Size() == 2) // it should be exactly 2
			{
				class<Inventory> item = cmd[1]; //the second element of the array is your class name
				// check it's an existing item:
				if (!item)
					return;
				// get pointer to the HUD:
				let hud = CK7_HUD(statusbar);
				if (!hud)
					return;
				hud.PrintItemNotif(item);
			}
		}
	}

}