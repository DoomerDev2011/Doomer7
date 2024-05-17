class CK7_GameplayHandler : EventHandler
{
	K7_LookTargetController lookControllers[MAXPLAYERS];

	override void WorldThingDamaged(worldEvent e)
	{
		if (e.thing && e.thing.health<=0 && e.thing.bISMONSTER)
		{
			actor killer = e.Damagesource;
			Bool crit;
			if(!e.thing.bNOBLOOD)
			{
				If(e.Damagesource is "PlayerPawn" && e.DamageType == "Critical" )// || (e.inflictor is "CK7_BulletPuff" && !e.inflictor.bNOEXTREMEDEATH)
				{
					crit = true;
					int blamount = e.thing.height+e.thing.radius+e.thing.radius;
					For(int p; p < blamount*blamount*0.01; p++)
					{
						Double pang = Random(0,360);
						Double ppic = Random(-20,70);
						k7_bloodparticle blp = k7_bloodparticle( Actor.Spawn("k7_bloodparticle",e.thing.pos.PlusZ(Random(0,e.thing.height) ) +(frandom(-0.7,0.7),frandom(-0.7,0.7) )*e.thing.radius )   );
						blp.Bvel = (cos(pang)*cos(ppic), sin(pang)*cos(ppic), sin(ppic))*Random(10,blamount);
						blp.even = self;
						blp.Roll = Random(0,360);
						blp.target = killer;
						blp.Translation = e.thing.bloodtranslation;
					}
					EventHandler.SendInterfaceEvent(killer.PlayerNumber(), "K7ShowHudPanel");
					EventHandler.SendInterfaceEvent(killer.PlayerNumber(), "K7BloodSpots");
				}
				else if (k7_bloodtrails && !(e.DamageFlags & DMG_EXPLOSION) ) {
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
			if( (skill == 3 || skill == 4) && !Crit) Return;
			// Initial value: 1-10 mapped to monster's health (between 20 and 1000):
			double dropcount = CK7_Utils.LinearMap(e.thing.GetMaxHealth(), 20, 1000, 1, 10, true);
			// Double amount for bosses:
			if (e.thing.bBoss)
			{
				dropcount *= 2;
			}
			if (killer)
			{
				// Factor in player's health, from x4.0 (starting with 0 hp) to x1.0 (at 100 HP and beyond):
				double healthFactor = CK7_Utils.LinearMap(killer.health, 0, 100, 4, 1, true);
				dropcount *= healthFactor;
				// Factor in the amount of  thin blood in player's inventory, from x1.0 (10 vials or fewer)
				// to x0.0 (20 vials):
				double invfactor = CK7_Utils.LinearMap(killer.CountInv('CK7_ThinBlood'), 10, 20, 1.0, 0.0, true);
				dropcount *= invfactor;
				//half amount if on Hurt me plenty or Ultraviolence
				If(skill == 2 || skill == 3) dropcount *= 0.5;
			}
			int count = round(dropcount);
			for (count; count > 0; count--)
			{
				e.thing.A_DropItem('CK7_ThinBlood', 1);
			}
		}
		Return;
	}
	
	override void WorldThingSpawned (WorldEvent e)
	{
		if (e.thing && e.thing.bISMONSTER)
		{
			Actor Crit = actor.Spawn("CK7_HS_CritSpot",e.thing.pos);
			Crit.master = e.thing;
			Crit.Speed = FRandom(0,e.thing.radius-6);
			Crit.SpriteAngle = Frandom(-90,90);
			Crit.ReactionTime = Random(0,e.thing.height-Crit.Height);
			CK7_HS_CritSpot(Crit).part = TexMan.CheckForTexture("glstuff/glpart.png");
		}
	}
	
	ui double Lerp (double v0, double v1, double frac)
    {
		return v0 + frac * (v1 - v0);
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
		if (e.name ~== "K7bloodspots") blodmag = 140;
		if (e.name == "K7NewBloodParticle")
		{
			k7_bloodUI bld = New("k7_bloodUI");
			bld.set = true;
			bld.vel = bloodprt.vel;
			bld.pos = bloodprt.pos;
			bld.roll = bloodprt.roll;
			string sprt = "BLUD";
			sprt.AppendCharacter(65+bloodprt.frame); sprt.AppendCharacter(48);
			bld.tex = TexMan.CheckForTexture(sprt);
			bld.col = bloodprt.Translation;
			bloodi.Push(bld);
		}
	}
	
	ui sightline sightline;
	ui actor mo;
	ui double oldfov;
	ui int screenOfsX, screenOfsY, screenSizeX, screenSizeY, trueSizeY;
	ui vector2 ADir;
	ui double Apitch;
	ui Vector3 Dir;
	ui Vector3 YDir;
	ui Vector3 XDir;
	ui Double Tanfov;
	ui int blodmag;
	ui vector3 goal0, goal1, goal2, goal3, goal4;
	k7_bloodparticle bloodprt;
	ui array <k7_bloodUI> bloodi;
	ui TextureId gllight;
	 
	override void UiTick ()
	{
		mo = players[consoleplayer].mo;
		[screenOfsX,screenOfsY,screenSizeX,screenSizeY] = screen.GetViewWindow();
		trueSizeY = Screen.GetHeight();
		if(!gllight) gllight = TexMan.CheckForTexture("glstuff/gllight.png");
		
		oldfov = mo.player.fov*0.5;
		bool nomt; int mtam;
		double bloz = 0.003* float(trueSizeY)/1080;
		double Sideofs = CK7_Hud(statusbar).GetSideOffset();
		goal0 = ( (Sideofs+89)/1080 ,0.6954,bloz);
		goal1 = ( (Sideofs+153)/1080 ,0.7612,bloz);
		goal2 = ( (Sideofs+83)/1080 ,0.8398,bloz);
		goal3 = ( (Sideofs+168)/1080 ,0.8537,bloz);
		goal4 = ( (Sideofs+88)/1080 ,0.925,bloz);
		if(blodmag) blodmag --;
		
		ForEach(b:bloodi)
		{
			if(b) 
			{
				blodmag = 60;
				CK7_Hud(statusbar).ShowSidePanel();
				nomt = true;
				b.opos = b.pos;
				vector3 goalb;
				switch(b.goal) {
					case 0: goalb = goal0; break;
					case 1: goalb = goal1; break;
					case 2: goalb = goal2; break;
					case 3: goalb = goal3; break;
					default: goalb = goal4; break;
				}
				if(b.tics>100) b.pos = goalb;
				b.tics++;
				vector3 move = (goalb - b.pos);
				double dist = move.length();
				if(dist < 0.2) b.fric = 1;
				b.vel *= 1-b.fric;
				b.vel += move.unit()*Min(0.2,dist)*b.fric;
				if(b.fric<1) {b.fric*= 1.3;}
				else b.fric = 1;
				if(b.die>2) {b.Destroy(); continue;}
				if( dist < 0.01 || b.die)  {b.die++; b.vel = (0,0,0); b.pos = goalb;}
				b.pos += b.vel;
			}
			else if(!nomt) mtam++;
		}
		if(mtam) bloodi.Delete(0,mtam);
		if(!nomt) bloodi.clear();
	}
	
	ui vector3 ProjectToScreen(Vector3 pos, Vector3 ViewPos, Double roll, Double TanFov, Vector3 Dir, Vector3 XDir, Vector3 YDir)
	{
		Vector3 ScrPos;
		vector3 numtan = Level.Vec3Diff(ViewPos,Pos);
		numtan.z *= level.pixelstretch;
		Double Dist = Max(numtan Dot Dir,0.001);
		Vector3 Perp = (numtan - Dir*Dist)/Dist;
		numtan.z /= level.pixelstretch;
		
		ScrPos.x = (XDir Dot Perp);
		ScrPos.y = -(YDir Dot Perp); 
		ScrPos.z = (0.5/TanFov)/Max( numtan.Length(),0.4);
		ScrPos.xy *= 0.5/TanFov;
		ScrPos.x = Clamp(ScrPos.x,-1,1);
		ScrPos.y = Clamp(ScrPos.y,-1,1);
		ScrPos.xy = actor.rotateVector(ScrPos.xy,- Roll);
		Return ScrPos;
	}
	
	override void RenderUnderlay(renderEvent e)
	{
		//thanks Gutawer for the pixel stretch ajustment
		ADir = (cos(e.Viewpitch), sin(e.ViewPitch)*level.pixelstretch);
		Apitch = asin(Adir.y / ADir.Length() );
		Dir = (cos(e.Viewangle)*cos(Apitch), sin(e.Viewangle)*cos(Apitch), sin(-Apitch));
		YDir = (cos(e.Viewangle)*cos(Apitch-90), sin(e.Viewangle)*cos(Apitch-90), sin(-Apitch+90));
		XDir = Dir cross YDir;
		Tanfov = Tan( lerp(oldfov, mo.player.fov*0.5, e.fractic) ) * max(4.0 / 3, Screen.GetAspectRatio()) / (4.0 / 3);
		
		Vector3 BlockPos = e.ViewPos + Dir*1500;
		BlockThingsIterator it = BlockThingsIterator.CreateFromPos(BlockPos.x,BlockPos.y,BlockPos.z, 50, 1500, 1);
		while (it.Next())
		{
			If (it.thing is "CK7_HS_CritSpot" && it.thing.health)
			{
				
				Vector3 CrPos = ProjectToScreen(it.thing.Pos.PlusZ(it.thing.Height*0.5), e.ViewPos, e.ViewRoll, TanFov, Dir, XDir, YDir);
				If(CrPos.xy.LengthSquared() < 0.002)
				{
					If(!SightLine) SightLine = New("SightLine");
					SightLine.Obj = it.thing;
					SightLine.Trace(e.ViewPos, it.thing.cursector, Level.Vec3Diff(e.ViewPos,it.thing.Pos.PlusZ(it.thing.Height*0.5) ), 3000, TRACE_ReportPortals);
					If(SightLine.Results.HitActor == it.thing)
					{
						CrPos.xy *= screenSizeX;
						CrPos.xy += (screenOfsX + screenSizeX*0.5, screenOfsY+ screenSizeY*0.5);
						
						color crcol = color(255,255,255,0);
						double crscl = 0.02*CrPos.z*screenSizeX;
						Screen.DrawTexture(gllight, true, CrPos.x, CrPos.Y, DTA_ScaleX, crscl, DTA_ScaleY, crscl* (1+0.2*Cos(Apitch) ),
						DTA_Color, crcol, DTA_LegacyRenderStyle, STYLE_ADD, DTA_CenterOffset, true);
					}
				}
			}
			
		}
		
	}
	override void RenderOverlay(renderEvent e)
	{
		if(blodmag)
		{
			double bmscl = goal0.z*96;
			color bmcol = color(int(200*Min(1,blodmag*0.05)),255,80,80);
			Screen.DrawTexture(gllight, true, goal0.x*trueSizeY, goal0.y*trueSizeY, DTA_CenterOffset, true,
			DTA_Color, bmcol, DTA_LegacyRenderStyle, STYLE_ADD, DTA_ScaleX, bmscl, DTA_ScaleY, bmscl );
			Screen.DrawTexture(gllight, true, goal1.x*trueSizeY, goal1.y*trueSizeY, DTA_CenterOffset, true,
			DTA_Color, bmcol, DTA_LegacyRenderStyle, STYLE_ADD, DTA_ScaleX, bmscl, DTA_ScaleY, bmscl );
			Screen.DrawTexture(gllight, true, goal2.x*trueSizeY, goal2.y*trueSizeY, DTA_CenterOffset, true,
			DTA_Color, bmcol, DTA_LegacyRenderStyle, STYLE_ADD, DTA_ScaleX, bmscl, DTA_ScaleY, bmscl );
			Screen.DrawTexture(gllight, true, goal3.x*trueSizeY, goal3.y*trueSizeY, DTA_CenterOffset, true,
			DTA_Color, bmcol, DTA_LegacyRenderStyle, STYLE_ADD, DTA_ScaleX, bmscl, DTA_ScaleY, bmscl );
			Screen.DrawTexture(gllight, true, goal4.x*trueSizeY, goal4.y*trueSizeY, DTA_CenterOffset, true,
			DTA_Color, bmcol, DTA_LegacyRenderStyle, STYLE_ADD, DTA_ScaleX, bmscl, DTA_ScaleY, bmscl );
		}
	
		if (bloodi.Size() == 0 || !mo) return;
		
		forEach(b : bloodi)
		{
			if(!b) continue;
			If(b.set)
			{
				b.set = false;
				b.oPos = ProjectToScreen(b.Pos-b.Vel, e.ViewPos, e.ViewRoll, TanFov, Dir, XDir, YDir);
				b.oPos.xy *= screenSizeX;
				b.oPos.xy += (screenOfsX + screenSizeX*0.5, screenOfsY+ screenSizeY*0.5);
				b.oPos.xy /= trueSizeY;
				
				b.Pos = ProjectToScreen(b.Pos, e.ViewPos, e.ViewRoll, TanFov, Dir, XDir, YDir);
				b.Pos.xy *= screenSizeX;
				b.Pos.xy += (screenOfsX + screenSizeX*0.5, screenOfsY+ screenSizeY*0.5);
				b.Pos.xy /= trueSizeY;
				
				b.fric = 0.001;
				b.vel = b.Pos - b.opos;
				b.goal = random(0,4);
				b.Roll -= e.ViewRoll;
			}
			double bscl = lerp(b.oPos.z,b.pos.z,e.fractic)*screenSizeX;
			Screen.DrawTexture(b.tex, true, lerp(b.oPos.x,b.pos.x,e.fractic)*trueSizeY, lerp(b.oPos.y,b.pos.y,e.fractic)*trueSizeY,
			DTA_TranslationIndex, b.col, DTA_Rotate, b.roll, DTA_ScaleX, bscl, DTA_ScaleY, bscl* (1+0.2*Cos(Apitch) ) );
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
	TextureID part;
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
					health = 1;
					NewPos = Master.pos + (0,0,reactiontime) + AngleToVector(Spriteangle+master.angle,Speed);
					SetOrigin( NewPos, true);
					Vel = Master.Vel;
					//Vector3 Pvel = Vel + (NewPos - Pos);// this is to try to smooth out its position
					Vector3 ppos;
					Float rad = radius - 1;
					For(int p; p < 9 && alpha; p++)
					{
						ppos = (Frandom(-rad,rad),Frandom(-rad,rad),Frandom(-height+2,height-2)*0.5) ;
						A_SpawnParticleEx("FFDD00",part, STYLE_None, SPF_FULLBRIGHT,
							3,4,0,ppos.x,ppos.y,ppos.z+5, vel.x,vel.y,vel.z,
							-ppos.x*0.5,-ppos.y*0.5,-ppos.z*0.5,1,0.1);
					}
					Alpha = 0;
				}
				else health = 0;
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
		TNT1 A 1 Nodelay 
		{
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

class k7_bloodparticle : actor
{
	Vector3 Bvel;
	CK7_GameplayHandler Even;
	Default
	{
		+ROLLSPRITE
		+BRIGHT
		+FORCEXYBILLBOARD;
		+NOINTERACTION;
	}
	States
	{
		Spawn:
			BLUD A 0 Nodelay { frame = Random(0,2); }
			BLUD # 20;
			BLUD # 1 {Vel = Bvel;}
			BLUD ### 1 {Vel*=0.3;}
			BLUD # 9 {Bvel = (Frandom(-2,2),Frandom(-2,2),Frandom(0,0.2)); }
			BLUD ###### 1 {Vel += Bvel;}
			TNT1 # 1
			{
				If(Target && Even)
				{
					Even.bloodprt = self;
					EventHandler.SendInterfaceEvent(Target.PlayerNumber(), "K7NewBloodParticle");
				}
			}
			Stop;
	}
}

class k7_bloodUI Ui
{
	int tics;
	int goal;
	int die;
	bool set;
	int col;
	Vector3 pos, opos, vel;
	Double roll, fric;
	TextureID tex;
}