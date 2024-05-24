Class CK7_Smith_Dan_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Tag "Dan";
		Weapon.AmmoType2 "CK7_ThinBlood";
		Inventory.PickupMessage "You got the Colt .357 revolver!";
		Inventory.PickupSound "dan_crit";
		CK7_Smith_Weapon.PersonaSoundClass 'k7_dan';
 		CK7_Smith_Weapon.Persona "dan";
 		CK7_Smith_Weapon.PersonaDamage 33;
		CK7_Smith_Weapon.PersonaCritical 9.1;
 		CK7_Smith_Weapon.PersonaRecoil 3;
 		CK7_Smith_Weapon.PersonaClipSize 6;
 		CK7_Smith_Weapon.PersonaRefireTime 18;
 		CK7_Smith_Weapon.PersonaViewHeight 0.85;
 		CK7_Smith_Weapon.PersonaHeight 45;
 		CK7_Smith_Weapon.PersonaReloadTime 60;
 		CK7_Smith_Weapon.PersonaCharges 3;
	}
	
	States
	{
		Spawn:
			M000 A -1 bright;
			stop;
			
		Recoil:
			TNT1 A 0;
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil );
			Goto Recoil_Generic;
		
		Shoot_Special3_Old:
			TNT1 A 0
			{
				invoker.m_iSpecialCharges = 0;
			}
			#### # 0 A_FireProjectile( "K7_Dan_CollateralShot", 0, false, 0, 0 );
			#### # 0 A_AlertMonsters();
			#### # 0 A_Overlay( LAYER_ANIM, "Anim_Altfire");
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			#### # 23;
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		
		Shoot_Special3:
			#### # 0
			{
				A_SetTics( ceil( invoker.m_fFireDelay ) );
				invoker.m_iSpecialCharges = 0;
				invoker.A_TakeInventory( "CK7_ThinBlood", 3 );
			}
			#### # 1 A_Overlay( LAYER_FUNC, "Fire_Special_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			Stop;
			
		Fire_Special_Bullet:
			#### # 0 A_FireProjectile( "K7_Dan_CollateralShot", 0, false, 0, 0 );
			#### # 0 A_AlertMonsters();
			Stop;	
		
		Flash1:
			DANF A 0
			{
				return ResolveState( "Flash" );
			}
			
		Flash2:
			DANF B 0
			{
				return ResolveState( "Flash" );
			}
			
		Flash3:
			DANF C 0
			{
				return ResolveState( "Flash" );
			}
			
		Anim_Aim_In:
			DANB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright K7_WeaponOffset ( 50, 42, 0 );
			#### # 1 bright K7_WeaponOffset ( 20, 38, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 0, 36, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( -15, 34, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
			
		Anim_Aiming:
			DANB A 0 A_OverlayFlags( LAYER_ANIM, PSPF_ADDBOB, true );
			DANB A 1 bright
			{
				float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 6 ) * 0.5;
				K7_WeaponOffset( offx, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		
		Anim_Fire_Special1:
		Anim_Fire_Special2:
		Anim_Fire:
			DANB A 0 bright K7_WeaponOffset( 0, 32 );
			#### # 0 bright A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### ABC 1 bright;
			#### DEFGHIJKLMA 2 bright;
			Goto Anim_Aiming;
		
		Anim_Fire_Special3:
			DANB A 0 bright K7_WeaponOffset ( 0, 32 );
			#### # 0 A_OverlayFlags( LAYER_ANIM, PSPF_ADDBOB, false );
			#### A 0 bright A_StopSound( CHAN_5 );
			#### A 0 A_StartSound( "dan_special", CHAN_WEAPON, CHANF_OVERLAP );
			#### A 0 A_StartSound( "dan_special_vo", CHAN_VOICE );
			#### A 0 A_Overlay( LAYER_FLASH, "Flash" );
			#### B 1 bright;
			#### C 1 bright;
			#### CDEF 1 bright;
			#### GHIJ 2 bright;
			#### KLM 3 bright;
			Goto Anim_Aiming;
		
		Anim_Reload_Down:
			DANB A 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright K7_WeaponOffset ( 0, 32, 0);
			#### # 1 bright K7_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright K7_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright K7_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright K7_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			Stop;
			
		Anim_Reload_Up:
			DANB A 1 bright K7_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
			
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}

Class K7_Dan_CollateralShot : Actor
{
	Default
	{
		Projectile;
		+NODAMAGETHRUST
		+FORCEPAIN
		+BRIGHT
		Radius 11;
		Height 8;
		Speed 20;
		DamageFunction (450);
		RenderStyle "Add";
		SeeSound "";
		DeathSound "dan_special_explode";
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		A_FaceMovementDirection();
	}
	
	//return -1 is normal collision, 0 is collide with no damage, 1 is pass through
	override int SpecialMissileHit(Actor victim)
	{
		If(victim == target) return 1;
		If(victim.bSHOOTABLE)
		{
			BlockThingsIterator itr = BlockThingsIterator.Create(self, radius+victim.radius*2);
			Actor Obj;
			while (itr.next())
			{
				If(itr.thing is "CK7_HS_CritSpot" && itr.thing.master == victim)
				{
					Obj = itr.thing; Break;
				}
			}
			If(Obj) 
			{
				//function to detect if its in a cylinder
				Vector3 Dir = Vel.Unit();
				Vector3 ObjPos = Obj.Pos.PlusZ(Obj.Height*0.5);
				Vector3 ObjOfs = ObjPos - Pos.PlusZ(Height*0.5);
				Double Dist = ObjOfs Dot Dir;
				Vector3 Push = ObjOfs - Dir*Dist; 
				If(Push.Length() < 19) //check if its not too far away from the cylinder's axis
				{
					victim.damagemobj(self,target,1300,'COLLATERALSHOT',0,angle);
					Return 0;
				}
				//&& Dist+Obj.Radius > 0 && Dist-Obj.Radius <= Length ) // to detect if its in length limits
			}
			return -1;
		}
		return -1;
	}
	
	States {
	Spawn:
		DANC A 1 
		{
			FSpawnParticleParams pp;
			pp.color1 = color(255, 128, 0);
			pp.lifetime = 8;
			pp.flags = SPF_FULLBRIGHT|SPF_REPLACE;
			pp.style = Style_Translucent;
			pp.startalpha = 1.0;
			pp.size = 10;
			pp.vel = vel;

			bool doTrail = target && Distance3D(target) >= speed * 4;

			for (int i = 8; i > 0; i--)
			{
				FLineTraceData lt;
				LineTrace(frandom(0,360), 38, frandom(-90, 90), data:lt);
				pp.pos = lt.HitLocation;
				Level.SpawnParticle(pp);

				if (doTrail)
				{
					LineTrace(angle + 180 + frandom(-60,60), 64, frandom(-60, 60), data:lt);
					pp.pos = lt.HitLocation;
					Vector3 dir = Level.Vec3Diff(pos, lt.HitLocation).Unit();
					pp.vel = dir * 4;
					//pp.accel = pp.vel * -0.015;
					pp.lifetime = TICRATE*3;
					pp.startalpha = 0.4;
					pp.fadestep = -1;
					pp.size = 8;
					Level.SpawnParticle(pp);
				}
			}
		}
		Loop;
		
	Death:
		TNT1 A 1
		{
			Vector3 exPos;
			for (int i = -2; i <= 2; i++)
			{
				exPos.xy = pos.xy + Actor.RotateVector((0, 72*i), angle);
				exPos.z = pos.z;
				exPos += (frandom(-12,12), frandom(-12,12), frandom(-16,16));
				let ex = Spawn('K7_CollateralShotExplosion', exPos);
				if (ex)
				{
					ex.scale.x = 1.0 - 0.3 * abs(i);
					ex.scale.y = ex.scale.x;
				}
			}

			FSpawnParticleParams pp;
			pp.color1 = color(255, 200, 0);
			pp.lifetime = 60;
			pp.lifetime = TICRATE;
			pp.flags = SPF_FULLBRIGHT|SPF_REPLACE;
			pp.style = Style_Add;
			pp.startalpha = 1.0;
			pp.size = 18;
			pp.sizestep = -(pp.size / pp.lifetime);

			FLineTraceData lt;
			for (int i = 80; i > 0; i--)
			{
				LineTrace(frandom(0,360), 48, frandom(-90, 90), data:lt);
				Vector3 dir = Level.Vec3Diff(pos, lt.HitLocation).Unit();
				pp.pos = lt.HitLocation;
				pp.vel = dir * 8;
				Level.SpawnParticle(pp);
			}
		}
		Stop;
	}
}

class K7_CollateralShotExplosion : Actor
{
	Default
	{
		+NOINTERACTION
		+NOBLOCKMAP
		+ROLLSPRITE
		+BRIGHT
		+FORCEXYBILLBOARD
		RenderStyle "Add";
	}

	States {
	Spawn:	
		COLE ABCDEFGHIJ 1;
		COLE KLMNOPQRSTUVWX 2;
		Stop;
	}
}