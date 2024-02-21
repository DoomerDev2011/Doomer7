class CK7_GameplayHandler : EventHandler
{
	override void WorldThingDied(worldEvent e)
	{
		if (e.thing && e.thing.bISMONSTER && !e.thing.bBOSS)
		{
			int count = Clamp(e.thing.GetMaxHealth() / 30, 1, 20);
			for (int i = count; i > 0; i--)
			{
				e.thing.A_DropItem('CK7_ThinBlood');
			}
		}
	}

	/*override void WorldThingDamaged(WorldEvent e)
	{
		if (e.thing.player && e.Damage > 0)
		{
			EventHandler.SendInterfaceEvent(e.thing.PlayerNumber(), "PlayerWasDamaged");
		}
	}*/
	
	override void InterfaceProcess(consoleEvent e)
	{
		if (e.name ~== "K7ShowHudPanel")
		{
			let hud = CK7_Hud(statusbar);
			if (hud)
			{
				hud.ShowSidePanel();
			}
		}

		/*if (e.name ~== "PlayerWasDamaged")
		{
			let hud = CK7_Hud(statusbar);
			if (hud)
			{
				hud.StartDamageWipe(60);
			}
		}*/
	}

	override void CheckReplacement(replaceEvent e)
	{
		if (e.Replacee is 'Clip' ||
			e.Replacee is 'Shell' ||
			e.Replacee is 'RocketAmmo' ||
			e.Replacee is 'Cell'
		)
		{
			e.Replacement = 'CK7_EmptyPickup';
		}
		if (e.Replacee is 'Shotgun')
		{
			e.Replacement = 'CK7_Smith_Dan_Wep';
		}
		else if (e.Replacee is 'Chaingun')
		{
			e.Replacement = 'CK7_Smith_Ked_Wep';
		}
		else if (e.Replacee is 'SuperShotgun')
		{
			e.Replacement = random[wsp](0,1) == 1? 'CK7_Smith_Kvn_Wep' : 'CK7_Smith_Cyo_Wep';
		}
		else if (e.Replacee is 'RocketLauncher')
		{
			e.Replacement = random[wsp](0,1) == 1? 'CK7_Smith_Cyo_Wep' : 'CK7_Smith_Con_Wep';
		}
		else if (e.Replacee is 'PlasmaRifle')
		{
			e.Replacement = random[wsp](0,1) == 1? 'CK7_Smith_Con_Wep' : 'CK7_Smith_Msk_Wep';
		}
		else if (e.Replacee is 'BFG9000')
		{
			e.Replacement = 'CK7_Smith_Hay_Wep';
		}
			
		//if (e.Replacee == 'HealthBonus')
		//{
		//	e.Replacement = 'CK7_HealthBonus';
		//}
	}
}