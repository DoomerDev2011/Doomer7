Class K7_Smith_Msk
{
	
}

Class CK7_Smith_Msk_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Weapon.SlotNumber 6;
		Weapon.BobRangeX 0;
		Inventory.PickupMessage "You got the M79 Grenade Launchers!";
		Inventory.PickupSound "weapon/getm79";
		CK7_Smith_Weapon.PersonaSoundClass "k7_msk";
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "msk";
		m_fDamage = 48;
		m_fRecoil = 6;
		m_iClipSize = 1;
		m_fRefire = 28;
		m_fViewHeight = 0.985;
		m_fHeight = 80;
		m_fReloadTime = 39;
		m_iSpecialChargeCount = 2;
	}
	
	States
	{
		Spawn:
			MASP A -1 bright;
			Loop;
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
				A_SetTics( ceil( invoker.m_fFireDelay ) );
			}
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			#### # 0 A_FireProjectile("K7_Mask_M79_Grenade",0,1,-10,0);
			#### # 0 A_FireProjectile("K7_Mask_M79_Grenade",0,1,10,0);
			Stop;
			
		Shoot_Special2:
			TNT1 A 0
			{
				if ( invoker.m_iAmmo > 0 )
				{
					invoker.m_iAmmo--;
				}
				A_SetTics( ceil( invoker.m_fFireDelay ) );
				invoker.m_iSpecialCharges = 0;
				invoker.A_TakeInventory( "CK7_ThinBlood", 2 );
			}
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			#### # 0 A_FireProjectile("K7_Mask_M79_Charge_Grenade",0,1,-10,0);
			#### # 0 A_FireProjectile("K7_Mask_M79_Charge_Grenade",0,1,10,0);
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
			MASK A 0 bright A_WeaponOffset ( 0, 82, 0 );
			#### # 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright;
			#### # 1 bright A_WeaponOffset ( 0, 68, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 54, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 45, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 38, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 33, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Aiming:
			MASK A 1 bright
			{
				//float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 3 ) * 0.5;
				A_WeaponOffset( 0, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		Anim_Fire_Special1:
		Anim_Fire:
			MASK A 0 bright A_WeaponOffset( 0, 32 );
			#### # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### CDEFGHIJKLM 1 bright;
			#### NPRTUVXZ 2 bright;
			MASB BD 2 bright;
			Goto Anim_Aiming;
			
		Anim_Fire_Special2:
			MASK A 0 bright A_WeaponOffset( 0, 32 );
			#### # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### A 0 A_StartSound( "msk_special_vo", CHAN_VOICE );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### CDEFGHIJKLM 1 bright;
			#### NPRTUVXZ 2 bright;
			MASB BD 2 bright;
			Goto Anim_Aiming;
			
		Anim_Reload_Down:
			MASK A 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 0, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 0, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 0, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 0, 32 + 256, WOF_INTERPOLATE);
			Stop;
		Anim_Reload_Up:
			MASK A 1 bright A_WeaponOffset ( 0, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}

class K7_Mask_M79_Grenade : Actor
{
	default{
		PROJECTILE;
		+HEXENBOUNCE
		-NOGRAVITY
		+EXPLODEONWATER
		Radius 11;
		Height 8;
		Speed 130;
		Damage 15;
		BounceCount 1;
		ReactionTime 139;
		Deathsound "weapon/MaskExplosion";
	}

	States {
		Spawn:
		MGRE A 0 A_CountDown();
		MGRE A 1 A_SpawnProjectile("GrenadePuff", 3, 0, 0, CMF_AIMOFFSET);
		Loop;
		
		Death:
		MISL B 0 Bright A_NoGravity();
		MISL B 0 Bright A_SetTranslucent(0.5, 1);
		MISL B 8 Bright A_Explode;
		MISL C 6 Bright;
		MISL D 4 BRIGHT;
		Stop;
	}
}

class K7_Mask_M79_Charge_Grenade : Actor
{
	default{
		PROJECTILE;
		+HEXENBOUNCE
		-NOGRAVITY
		+EXPLODEONWATER
		Radius 11;
		Height 8;
		Speed 130;
		Damage 30;
		BounceCount 1;
		ReactionTime 139;
		Deathsound "weapon/MaskExplosion";
	}

	States {
		Spawn:
		MGRE A 0 A_CountDown();
		MGRE A 1 A_SpawnProjectile("GrenadePuff", 3, 0, 0, CMF_AIMOFFSET);
		Loop;
		
		Death:
		MISL B 0 Bright A_NoGravity();
		MISL B 0 Bright A_SetTranslucent(0.5, 1);
		MISL B 8 Bright A_Explode;
		MISL C 6 Bright;
		MISL D 4 BRIGHT;
		Stop;
	}
}

Class GrenadePuff : BulletPuff{
	default{
		+ClientSideOnly
	}

	States{
		Spawn:
		PUFF ABCD 4;
		Stop;
	}
}