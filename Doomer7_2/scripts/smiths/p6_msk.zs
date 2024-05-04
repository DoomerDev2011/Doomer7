Class K7_Smith_Msk
{
	
}

Class CK7_Smith_Msk_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Weapon.BobRangeX 0;
		Inventory.PickupMessage "You got the M79 Grenade Launchers!";
		Inventory.PickupSound "weapon/getm79";
		CK7_Smith_Weapon.PersonaSoundClass "k7_msk";
 		CK7_Smith_Weapon.Persona "msk";
 		CK7_Smith_Weapon.PersonaDamage 48;
 		CK7_Smith_Weapon.PersonaRecoil 6;
 		CK7_Smith_Weapon.PersonaClipSize 1;
 		CK7_Smith_Weapon.PersonaRefireTime 28;
 		CK7_Smith_Weapon.PersonaViewHeight 0.985;
 		CK7_Smith_Weapon.PersonaHeight 60;
 		CK7_Smith_Weapon.PersonaReloadTime 39;
 		CK7_Smith_Weapon.PersonaCharges 2;
	}
	
	action void K7_SetupGunLayer(name sname = 'MA1K')
	{
		let psp = Player.FindPSprite(OverlayID());
		if (!psp)
		{
			return;
		}
		A_OverlayFlags(OverlayID(), PSPF_ADDWEAPON, false);
		psp.y += WEAPONTOP;
		if (OverlayID() == LAYER_RIGHTGUN)
		{
			psp.sprite = GetSpriteIndex(sname);
		}
		K7_OverlayOffset(OverlayID(), 0, WEAPONTOP);
	}
	
	override Vector2 K7_AdjustLayerOffsets(double x, double y, int layer)
	{
		let ofs = super.K7_AdjustLayerOffsets(x, y, layer);
		if (layer == LAYER_LEFTGUN)
		{
			ofs.x *= -1;
		}
		return ofs;
	}
	
	States
	{
		SpriteCache:
			MA1K A 0;
			MA1B A 0;
			stop;
		Spawn:
			M000 A -1 bright;
			stop;
		Recoil:
			TNT1 A 0;
			#### A 1 A_SetPitch( pitch - invoker.m_fRecoil );
			#### A 1 A_SetPitch( pitch + invoker.m_fRecoil * 2 );
			#### A 1 A_SetPitch( pitch - invoker.m_fRecoil * 1.5 );
			#### A 1 A_SetPitch( pitch + invoker.m_fRecoil * 0.75 );
			#### A 1 A_SetPitch( pitch - invoker.m_fRecoil * 0.25 );
			Stop;
		Flash1:
		Flash2:
		Flash3:
			TNT1 A 0
			{
				return ResolveState( "Flash" );
			}
		/*
		Fire:
			TNT1 A 0 A_JumpIf ( (invoker.m_iAmmo == 0) , "Reload" );
			#### # 0 A_Overlay( LAYER_ANIM, "Anim_Fire" );
			#### # 0 A_Overlay( LAYER_SHOOT, "Shoot" );
			#### # 0 A_FireProjectile("K7_Mask_M79_Grenade",0,1,-10,0);
			#### # 0 A_FireProjectile("K7_Mask_M79_Grenade",0,1,10,0);
			#### # 0
			{
				A_SetTics( ceil( invoker.m_fRefire ) - 1 );
			}
			#### # 0 A_JumpIf( !invoker.m_bAutoFire, "Aiming" );
			#### # 0 A_Refire();
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		*/
		Shoot_Special1:
		Shoot:
			TNT1 A 0
			{
				if ( invoker.m_iAmmo > 0 )
				{
					invoker.m_iAmmo--;
				}
				A_FireProjectile("K7_Mask_M79_Grenade",0,1,-15,-5);
				A_FireProjectile("K7_Mask_M79_Grenade",0,1,15,-5);
				A_SetTics( ceil( invoker.m_fFireDelay ) );
				A_Overlay( LAYER_RECOIL, "Recoil" );
			}
			Stop;
			
		Shoot_Special2:
			TNT1 A 0
			{
				if ( invoker.m_iAmmo > 0 )
				{
					invoker.m_iAmmo--;
				}
				A_FireProjectile("K7_Mask_M79_Charge_Grenade",0,1,-15,-5);
				A_FireProjectile("K7_Mask_M79_Charge_Grenade",0,1,15,-5);
				A_SetTics( ceil( invoker.m_fFireDelay ) );
				invoker.m_iSpecialCharges = 0;
				invoker.A_TakeInventory( "CK7_ThinBlood", 2 );
				A_Overlay( LAYER_RECOIL, "Recoil" );
			}
			Stop;
			
		/*
		Altfire:
			TNT1 A 0 A_JumpIf ( (invoker.m_iAmmo == 0) , "Reload" );
			#### # 0 A_Overlay( LAYER_ANIM, "Anim_Altfire" );
			#### # 0 A_Overlay( LAYER_SHOOT, "Shoot" );
			#### # 0
			{
				if ( invoker.m_iAmmo > 0 ){
					invoker.m_iAmmo--;
				}
			}
			#### # 0 A_FireProjectile("K7_Mask_M79_Charge_Grenade",0,1,-10,0);
			#### # 0 A_FireProjectile("K7_Mask_M79_Charge_Grenade",0,1,10,0);
			#### # 0
			{
				A_SetTics( ceil( invoker.m_fRefire ) - 1 );
			}
			#### # 0 A_JumpIf( !invoker.m_bAutoFire, "Aiming" );
			#### # 0 A_Refire();
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		*/
		
			
		Anim_Aim_In:
			TNT1 A 7
			{
				A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
				A_Overlay(LAYER_LEFTGUN, "Anim_Aim_In_SingleGun");
				A_Overlay(LAYER_RIGHTGUN, "Anim_Aim_In_SingleGun");
			}				
			Goto Anim_Aiming;
		Anim_Aim_In_SingleGun:
			MASK A 0 K7_SetupGunLayer('MA1K');
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 82, 0 );
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 68, WOF_INTERPOLATE );
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 54, WOF_INTERPOLATE );
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 45, WOF_INTERPOLATE );
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 38, WOF_INTERPOLATE );
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 33, WOF_INTERPOLATE );
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming_SingleGun;
		
		Anim_Aiming:
			TNT1 A -1
			{
				A_Overlay(LAYER_LEFTGUN, "Anim_Aiming_SingleGun");
				A_Overlay(LAYER_RIGHTGUN, "Anim_Aiming_SingleGun");
			}
			stop;
		Anim_Aiming_SingleGun:
			MASK A 0 K7_SetupGunLayer('MA1K');
			#### A 1 bright
			{
				float offy = 1 + sin( level.time * 3 ) * 0.5;
				K7_OverlayOffset( OverlayID(), 0, 32 + offy, WOF_INTERPOLATE );
			}
			wait;
			
		Anim_Fire_Special1:
		Anim_Fire:
			TNT1 A 0 bright 
			{
				K7_WeaponOffset( 0, 32 );
				A_Overlay(LAYER_LEFTGUN, "Anim_Fire_SingleGun");
				A_Overlay(LAYER_RIGHTGUN, "Anim_Fire_SingleGun");
				A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
				A_Overlay( LAYER_FLASH, "FlashA" );
			}
			#### CDEFGHIJKLM 1 bright;
			#### NPRTUVXZ 2 bright;
			TNT1 BD 2 bright;
			Goto Anim_Aiming;		
		Anim_Fire_SingleGun:
			MASK A 0 K7_SetupGunLayer('MA1K');
			#### CDEFGHIJKLM 1 bright;
			#### NPRTUVXZ 2 bright;
			MASB A 0 K7_SetupGunLayer('MA1B');
			#### BD 2 bright;
			Goto Anim_Aiming_SingleGun;
			
		Anim_Fire_Special2:
			TNT1 A 0 bright 
			{
				K7_WeaponOffset( 0, 32 );
				A_Overlay(LAYER_LEFTGUN, "Anim_Fire_Special2_SingleGun");
				A_Overlay(LAYER_RIGHTGUN, "Anim_Fire_Special2_SingleGun");
				A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
				A_StartSound( "msk_special_vo", CHAN_VOICE );
				A_Overlay( LAYER_FLASH, "FlashA" );
			}
			#### CDEFGHIJKLM 1;
			#### NPRTUVXZ 2;
			TNT1 BD 2;
			Goto Anim_Aiming;
		Anim_Fire_Special2_SingleGun:
			MASK A 0 K7_SetupGunLayer('MA1K');
			#### CDEFGHIJKLM 1 bright;
			#### NPRTUVXZ 2 bright;
			MASB A 0 K7_SetupGunLayer('MA1B');
			#### BD 2 bright;
			Goto Anim_Aiming_SingleGun;
			
		Anim_Reload_Down:
			TNT1 A 5
			{
				A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
				A_Overlay(LAYER_LEFTGUN, "Anim_Reload_SideGun");
				A_Overlay(LAYER_RIGHTGUN, "Anim_Reload_SideGun");
			}
			Stop;
		Anim_Reload_SideGun:
			MASK A 0 K7_SetupGunLayer('MA1K');
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32, 0);
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32 + 256, WOF_INTERPOLATE);
			Stop;
			
		Anim_Reload_Up:
			TNT1 A 4 
			{
				A_Overlay(LAYER_LEFTGUN, "Anim_Reload_Up_SideGun");
				A_Overlay(LAYER_RIGHTGUN, "Anim_Reload_Up_SideGun");
			}
			Goto Anim_Aiming;
		Anim_Reload_Up_SideGun:
			MASK A 0 K7_SetupGunLayer('MA1K');
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright K7_OverlayOffset(OverlayID(), 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming_SingleGun;
			
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;			
	}
}

class K7_Mask_M79_Grenade : Actor
{
	static const name smokeTexNames[] = { 'masksmkA', 'masksmkB', 'masksmkC', 'masksmkD' };

	Default
	{
		Projectile;
		-NOGRAVITY
		+EXTREMEDEATH
		Radius 11;
		Height 8;
		Speed 130;
		Damage 20;
		ReactionTime 139;
		ExplosionRadius 128;
		Deathsound "weapon/MaskExplosion";
	}

	override void Tick()
	{
		Vector3 oldPos = pos;
		Super.Tick();
		if (isFrozen() || !InstateSequence(curstate, spawnstate) || !(target && Distance3D(target) > speed+radius+target.radius))
		{
			return;
		}

		Vector3 path = Level.Vec3Diff(pos, oldPos);
		Vector3 dir = path.Unit();
		double dist = 8;
		int steps = round(path.Length() / dist);
		FSpawnParticleParams sm;
		sm.color1 = "";
		sm.size = 13;
		sm.startalpha = 0.6;
		sm.fadestep = -1;
		sm.lifetime = 32;
		sm.sizestep = sm.size * 0.02;
		for (int i = 0; i < steps; i++)
		{
			sm.texture = TexMan.CheckForTexture(smokeTexNames[random(0, smokeTexNames.Size()-1)]);
			sm.pos = oldpos + (frandom(-2,2),frandom(-2,2),frandom(-2,2));
			sm.startroll = frandom(0,360);
			sm.rollvel = frandom(3, 6) * randompick(-1,1);
			sm.rollacc = -(sm.rollvel / sm.lifetime);
			Level.SpawnParticle(sm);
			oldPos += dir * dist;
		}
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		A_AttachLight('0', DynamicLight.PointLight, color(255, 128, 0), 80, 0, DYNAMICLIGHT.LF_ATTENUATE);
	}

	States {
	Spawn:
		TNT1 A 1 A_CountDown();
		Loop;
		
	Death:
		TNT1 A 0
		{
			A_Stop();
			bNOGRAVITY = true;
			bBRIGHT = true;
			A_SetRenderstyle(1.0, STYLE_Add);
			A_Explode();
			A_AttachLight('0', DynamicLight.FlickerLight, color(255, 80, 0), 80, 128, DYNAMICLIGHT.LF_ATTENUATE, param: 0.5);
		}
		MAEX ABCDEFGHIJ 1 { scale *= 1.02; }
		TNT1 A 0 A_RemoveLight('0');
		MAEX KLMNOPQRSTUVWX 2;
		Stop;
	}
}

class K7_Mask_M79_Charge_Grenade : K7_Mask_M79_Grenade
{
	Default
	{
		Damage 30;
		ExplosionRadius 180;
	}

	States
	{
	Death:
		TNT1 A 0
		{
			FSpawnParticleParams pp;
			pp.color1 = color(255, 128, 0);
			pp.lifetime = 60;
			pp.flags = SPF_FULLBRIGHT|SPF_REPLACE;
			pp.style = Style_Add;
			pp.startalpha = 1.0;
			pp.size = 20;
			pp.sizestep = -(pp.size / pp.lifetime);
			pp.pos = pos;

			FLineTraceData lt;
			for (int i = 80; i > 0; i--)
			{
				pp.vel.x = frandom(-10, 10);
				pp.vel.y = frandom(-10, 10);
				pp.vel.z = frandom(10, 20);
				pp.accel.z = -gravity;
				Level.SpawnParticle(pp);
			}
		}
		goto super::Death;
	}
}