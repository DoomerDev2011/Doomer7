class CK7_GameplayHandler : EventHandler
{
	K7_LookTargetController lookControllers[MAXPLAYERS];

	override void WorldThingDied(worldEvent e)
	{
		if (e.thing && e.thing.bISMONSTER)
		{
			// Initial value: 1-10 mapped to monster's health (between 20 and 1000):
			double dropcount = CK7_Utils.LinearMap(e.thing.GetMaxHealth(), 20, 1000, 1, 10, true);
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
				dropcount *= healthFactor;
				// Factor in the amount of  thin blood in player's inventory, from x1.0 (10 vials or fewer)
				// to x0.0 (20 vials):
				double invfactor = CK7_Utils.LinearMap(killer.CountInv('CK7_ThinBlood'), 10, 20, 1.0, 0.0, true);
				dropcount *= invfactor;
			}
			int count = round(dropcount);
			for (count; count > 0; count--)
			{
				e.thing.A_DropItem('CK7_ThinBlood', 1);
			}
		}
	}
	
	override void WorldThingSpawned (WorldEvent e)
	{
		if (e.thing && e.thing.bISMONSTER)
		{
			//here set any other condition you'll like
			//If(Random(0,1)>0)
			//{
				Actor Crit = actor.Spawn("CK7_HS_CritSpot",e.thing.pos);
				Crit.master = e.thing;
				Crit.Speed = e.thing.radius - FRandom(2,30);
				Crit.SpriteAngle = Frandom(0,360);
				Crit.ReactionTime = Random(0,e.thing.height);
			//}
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
		if (e.Replacee is 'Chainsaw')
		{
			e.Replacement = 'CK7_Smith_Kvn_Wep';
		}
		else if (e.Replacee is 'Shotgun')
		{
			e.Replacement = random[wsp](0,1) == 1? 'CK7_Smith_Dan_Wep' : 'CK7_Smith_Cyo_Wep';
		}
		else if (e.Replacee is 'Chaingun')
		{
			e.Replacement = 'CK7_Smith_Con_Wep';
		}
		else if (e.Replacee is 'SuperShotgun')
		{
			e.Replacement = random[wsp](0,1) == 1? 'CK7_Smith_Dan_Wep' : 'CK7_Smith_Cyo_Wep';
		}
		else if (e.Replacee is 'RocketLauncher')
		{
			e.Replacement = 'CK7_Smith_Ked_Wep';
		}
		else if (e.Replacee is 'PlasmaRifle')
		{
			e.Replacement = 'CK7_Smith_Hay_Wep';
		}
		else if (e.Replacee is 'BFG9000')
		{
			e.Replacement = 'CK7_Smith_Msk_Wep';
		}
		else if (e.Replacee is 'HealthBonus' || e.Replacee is 'Medikit' || e.Replacee is 'Stimpack')
		{
			e.Replacement = 'CK7_ThinBlood';
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

Class CK7_HS_CritSpot : Actor
{
	//This actor uses SpriteAngle for the relative angle its at, 
	//Speed for how far away it is and Reactiontime for its height
	//you could make other variables with better names, i just didnt wanna
	Vector3 Newpos;
	Default
	{
		alpha 0;
		Radius 5;
		Height 10;
		+NOGRAVITY;
	}
	states
	{
		Spawn:
			TNT1 A 1 {
				if(!Master) Destroy();
				else if(master.bSHOOTABLE) 
				{
					NewPos = Master.pos + (0,0,reactiontime) + AngleToVector(Spriteangle+master.angle,Speed);
					SetOrigin( NewPos, true);
					Vel = Master.Vel;
					//Vector3 Pvel = Vel + (NewPos - Pos);// this is to try to smooth out its position
					Vector3 ppos;
					Float rad = radius - 1;
					For(int p; p < 11 && alpha; p++)
					{
						ppos = (Frandom(-rad,rad),Frandom(-rad,rad),Frandom(-height+2,height-2)*0.5) ;
						A_SpawnParticle("FFDD00",SPF_FULLBRIGHT,3,4,0,ppos.x,ppos.y,ppos.z+5,
							vel.x,vel.y,vel.z,
							-ppos.x*0.5,-ppos.y*0.5,-ppos.z*0.5,1,0.1);
							//Frandom(-1,1),Frandom(-1,1),Frandom(-1,1),1,0.1);
					}
					Alpha = 0;
				}
			}
			Loop;
	}
}

/*
class DeathParticleData : Thinker
{
	Vector3 pos;
	TextureID tex;
	PlayerInfo player;

	static DeathParticleData Create(Actor thing, PlayerInfo player)
	{
		if (!thing)
			return null;

		let p = New('DeathParticleData');
		if (p)
		{
			p.player = player;
			p.pos = thing.pos;
			p.tex = thing.curstate.GetSpriteTexture(0);
			let handler = CK7_GameplayHandler(EventHandler.Find('CK7_GameplayHandler'));
			if (handler)
			{
				handler.vpThings.Push(p);
			}
		}
		return p;
	}

	override void Tick()
	{
		if (player && player.mo)
		{
			let diff = Level.Vec3Diff(pos, player.mo.pos);
			if (diff.length () < player.mo.radius)
			{
				Destroy();
			}
			else
			{
				pos += diff.Unit() * 15;
			}
		}
	}
}

class DeathParticle : Actor
{
	Default
	{
		+NOINTERACTION
		+NOBLOCKMAP
		+BRIGHT
	}

	States 
	{
	Spawn:
		BAL1 A 1
		{
			vel *= 0.85;
			if (vel.length() <= 0.1)
			{
				A_Stop();
				return ResolveState("Death");
			}
			return ResolveState(null);
		}
		loop;
	Death:
		BAL1 A 1
		{
			if (target && target.player)
			{
				DeathParticleData.Create(self, target.player);
			}
		}
		stop;
	}
}

class Zombieman_ : Zombieman
{
	override void Die(Actor source, Actor inflictor, int dmgflags, Name MeansOfDeath)
	{
		for (int i = 0; i < 40; i++)
		{
			bool b; Actor p;
			[b, p] = A_SpawnItemEx('DeathParticle',
				zofs: height*0.5,
				xvel: 12,
				zvel: frandom(-5, 12),
				angle: frandom(0, 360)
			);
			if (b && p)
			{
				p.target = source;
			}
		}
		super.Die(source, inflictor, dmgflags, MeansOfDeath);
	}
}