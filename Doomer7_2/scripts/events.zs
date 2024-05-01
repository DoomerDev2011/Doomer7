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
			
			if(!e.thing.bNOBLOOD)
			{
				If(e.inflictor is "CK7_BulletPuff" && !e.inflictor.bNOEXTREMEDEATH)
				{
					For(int p; p < 100; p++)
					{
						Double pang = Random(0,360);
						Double ppic = Random(-90,90);
						Vector3 pvel = (cos(pang)*cos(ppic), sin(pang)*cos(ppic), sin(ppic))*Random(1,24);
						e.thing.A_SpawnParticle("FF0000",SPF_FULLBRIGHT,10,8,0,0,0,e.thing.height*0.5,
						pvel.x,pvel.y,pvel.z,
						-0.12*pvel.x,-0.12*pvel.y,-0.12*pvel.z,1,0);
					}
				}
				else if (k7_bloodtrails) {
					int t = 0.05*(e.thing.height+e.thing.radius);
					for(int b = t; b>0; b--)
					{
						Actor Blud = actor.Spawn("K7_BloodSpew",e.thing.pos);
						Blud.master = e.thing;
						Blud.Health = e.thing.default.Health*0.1 + Random(30,40);
						Blud.Speed = e.thing.radius - FRandom(0,e.thing.radius*0.2);
						Blud.SpriteAngle = Frandom(-180,180);
						Blud.FloatSpeed  = FRandom(0.3,0.9);
						Blud.Pitch = Random(-50,0);
					}
				}
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
				Crit.Speed = FRandom(0,e.thing.radius-6);
				Crit.SpriteAngle = Frandom(-90,90);
				Crit.ReactionTime = Random(0,e.thing.height-Crit.Height);
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

class K7_BloodSpew : Actor
{
	Vector2 SpAng;
	Default 
	{
		Health 30;
		Height 4;
		radius 4;
	}
	States
	{
		Spawn:
		TNT1 A 1 Nodelay {
			If(Master && Health) 
			{
					Angle = Spriteangle+master.angle;
					SetOrigin(  Master.pos + (0,0,Master.height*FloatSpeed) + AngleToVector(angle,Speed), true);
					Vel = Master.vel;
					
					Spang *= 0.94;
					Spang += (FRandom(-3,3) , FRandom(-3,3) );
					Vector3 Bel = 13*(cos(angle+Spang.x)*cos(pitch+Spang.y), sin(angle+Spang.x)*cos(pitch+Spang.y), -sin(pitch+Spang.y));
					Actor Blud = Spawn("K7_BloodTrail",pos );
					Blud.Vel = Vel + Bel;
					Blud.Translation = master.bloodtranslation;
					Blud.CopyBloodColor(Master);
					If(tracer) {
						Blud.tracer = tracer;
						Vector3 Difr = Tracer.Pos - Blud.Pos;
						Blud.Scale.y = Difr.Length();
						Blud.Angle = VectorAngle(Difr.x,Difr.y);
						Blud.Pitch = VectorAngle(Difr.xy.Length(),-Difr.z);
					}
					Tracer = Blud;
					
					Health--;
			}
			else Destroy();
		}
		Loop;
	}
}

class K7_BloodTrail : Actor
{
	Vector3 Norm;
	Default 
	{
		Reactiontime 300;
		RenderStyle "Translucent";
		Alpha 20;
		Height 4;
		radius 4;
		YScale 0;
		Speed 13;
		+INTERPOLATEANGLES
		+BRIGHT
		+NOINTERACTION
		+NOTELEPORT
		+FLATSPRITE
		+THRUACTORS
	}
	States
	{
		Spawn:
		BLTR R 1
		{
			Vel.z -= GetGravity();
			If(tracer) 
			{
				Vector2 VelAng = ( VectorAngle(Vel.x,Vel.y) , VectorAngle(Vel.xy.Length(),-Vel.z) );
				If(pos.z <= floorz) VelAng.y - 90;
				FLineTraceData TB;
				bool Hit = LineTrace(VelAng.X, Vel.Length(), VelAng.Y, TRF_THRUACTORS|TRF_ABSOFFSET,-vel.z,-vel.x,-vel.y,TB);//
				If(Hit)
				{
					bNOGRAVITY = true;
					Vel = (0,0,0);
					SetOrigin(TB.HitLocation,true);
					If (TB.HitType == TRACE_Hitwall && TB.HitLine) 
					{
						TB.HitLine.Activate(Master, 0, SPAC_Impact);
						Norm = (0,0,0)+RotateVector(TB.HitLine.Delta,-90).Unit();
						//A_SprayDecal("BloodSplat",30,(0,0,-1),TB.HitDir,1);
					}
					else if (TB.HitType == TRACE_HitFloor || TB.HitType == TRACE_HitCeiling) 
					{
						If(TB.Hit3DFloor) {
							Norm = TB.Hit3DFloor.Bottom.Normal;
							if (TB.HitType == TRACE_HitCeiling ) Norm *= -1;
							
						}
						else {
							if(TB.HitType == TRACE_HitFloor ) Norm = TB.HitSector.FloorPlane.Normal;
							else if (TB.HitType == TRACE_HitCeiling ) Norm = TB.HitSector.CeilingPlane.Normal;
						}
					}
					SetStateLabel("Death");
				}
				else {
					Vector3 Difr = Tracer.Pos - Pos;
					Scale.y = Difr.Length();
					//if(!tracer.health && Scale.y > 100) tracer = null;
					Angle = VectorAngle(Difr.x,Difr.y);
					Pitch = VectorAngle(Difr.xy.Length(),-Difr.z);
				}
				Reactiontime--;
				if(!Reactiontime) Destroy();
			}
		}
		Loop;
		
		Death:
		BLTR R 0 
		{
			If(tracer) 
			{
				FLineTraceData TB;
				Vector3 Difr = Tracer.Pos - Pos;
				Difr -= Norm* (Norm dot Difr);
				
				Angle = 180+VectorAngle(Norm.x,Norm.y);
				Pitch = VectorAngle(Norm.xy.Length(),Norm.z)-90;
				Vector3 Rely = (cos(angle)*cos(pitch), sin(angle)*cos(pitch), sin(-Pitch));
				Vector3 Relx = Rely cross Norm;
				Vector2 Spread = ( Relx dot Difr , Rely dot Difr );
				Roll = VectorAngle( Spread.x , Spread.y ) - 90;
				Scale.y = Spread.Length();
				
				Spread = ( VectorAngle(Difr.x,Difr.y) , VectorAngle(Difr.xy.Length(),-Difr.z) );
				Bool hit = LineTrace(180+Spread.X, Scale.y, -Spread.Y, TRF_THRUACTORS|TRF_ABSOFFSET,Difr.z-Norm.z,Difr.x-Norm.x,Difr.y-Norm.y,TB);
				If(hit) Scale.y -= TB.Distance;
				hit = LineTrace(Spread.X, Scale.y, Spread.Y, TRF_THRUACTORS|TRF_ABSOFFSET,0,0,0,TB);
				Scale.y = TB.Distance;
			}
			Health = 0;
			bMOVEWITHSECTOR = true;
			bBRIGHT = 0;
		}
		Fade:
		BLTR R 1 {
			Alpha -= 0.05;
			If(Alpha <= 0) Destroy();
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