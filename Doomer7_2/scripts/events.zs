class CK7_GameplayHandler : EventHandler
{
	K7_LookTargetController lookControllers[MAXPLAYERS];

	override void WorldThingDied(worldEvent e)
	{
		if (e.thing && e.thing.bISMONSTER)
		{
			// Initial value: 1-10 mapped to monster's health (between 20 and 1000):
			int dropcount = round(CK7_Utils.LinearMap(e.thing.GetMaxHealth(), 20, 1000, 1, 10, true));
			// Double amount for bosses:
			if (e.thing.bBoss)
			{
				dropcount *= 2;
			}
			let killer = e.thing.target;
			if (killer)
			{
				// Factor in player's health, from x4.0 (starting with 0 hp) to x1.0 (at 100 HP and beyond):
				double healthFactor = CK7_Utils.LinearMap(killer.health, 0, 100, 4, 1, true);
				dropcount = round(dropcount * healthFactor);
				// Factor in the amount of  thin blood in player's inventory, from x1.0 (10 vials or fewer)
				// to x0.0 (20 vials):
				double invfactor = CK7_Utils.LinearMap(killer.CountInv('CK7_ThinBlood'), 10, 20, 1.0, 0.0, true);
				dropcount = round(dropcount * invfactor);
			}
			for (dropcount; dropcount > 0; dropcount--)
			{
				e.thing.A_DropItem('CK7_ThinBlood', 1);
			}
		}
	}

	/*array <DeathParticleData> vpThings;
	
	override void RenderOverlay(renderEvent e)
	{
		if (vpThings.Size() <= 0)
			return;
		let pmo = players[consoleplayer].mo;
		if (!pmo)
			return;
		let vp = CK7_StatusBarScreen.GetRenderEventViewProj(e);
		bool front;
		Vector2 vpPos;
		for (int i = 0; i < vpThings.Size(); i++)
		{
			let d = vpThings[i];
			if (!d)
				continue;
			[front, vpPos] = CK7_StatusBarScreen.ProjectToHUD(vp, d.pos);
			Screen.DrawTexture(d.tex, false, vpPos.x, vpPos.y);
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
		if (e.Replacee is 'Shotgun' || e.Replacee is 'Chainsaw')
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