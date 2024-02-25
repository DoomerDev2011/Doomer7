class CK7_GameplayHandler : EventHandler
{
	K7_LookTargetController lookControllers[MAXPLAYERS];

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

	override void PlayerSpawned(playerEvent e)
	{
		int i = e.PlayerNumber;
		if (!PlayerInGame[i])
			return;
		PlayerInfo player = players[i];
		PlayerPawn pmo = player.mo;
		if (pmo && !CK7_Utils.IsVoodooDoll(pmo))
		{
			let ltc = K7_LookTargetController.Create(pmo);
			if (ltc)
			{
				lookControllers[i] = ltc;
			}
		}
	}
}