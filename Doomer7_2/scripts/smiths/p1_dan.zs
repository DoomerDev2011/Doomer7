Class CK7_Smith_Dan
{
	
}

Class CK7_Smith_Dan_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Weapon.SlotNumber 1;
		Weapon.AmmoType2 "CK7_ThinBlood";
		Inventory.PickupMessage "You got the Colt .357 revolver!";
		Inventory.PickupSound "weapon/getmag";
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "dan";
		m_fDamage = 45;
		m_fRecoil = 3;
		m_iClipSize = 6;
		m_fRefire = 18;
		m_fViewHeight = 0.85;
		m_fHeight = 60;
		m_fReloadTime = 60;
		m_iSpecialChargeCount = 3;
	}
	
	States
	{
		Spawn:
			DANP A -1 bright;
			Loop;
			
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
			#### # 1 bright A_WeaponOffset ( 50, 42, 0 );
			#### # 1 bright A_WeaponOffset ( 20, 38, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 36, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -15, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
			
		Anim_Aiming:
			DANB A 0 A_OverlayFlags( LAYER_ANIM, PSPF_ADDBOB, true );
			DANB A 1 bright
			{
				float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 6 ) * 0.5;
				A_WeaponOffset( offx, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		
		Anim_Fire_Special1:
		Anim_Fire_Special2:
		Anim_Fire:
			DANB A 0 bright A_WeaponOffset( 0, 32 );
			#### # 0 bright A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### ABC 1 bright;
			#### DEFGHIJKLMA 2 bright;
			Goto Anim_Aiming;
		
		Anim_Fire_Special3:
			DANB A 0 bright A_WeaponOffset ( 0, 32 );
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
			#### # 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			Stop;
			
		Anim_Reload_Up:
			DANB A 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
			
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}

Class K7_Dan_CollateralShot : PlasmaBall
{
	Default
	{
		Radius 11;
		Height 8;
		Speed 20;
		DamageFunction (450);
		Projectile;
		-RANDOMIZE
		-DEHEXPLOSION
		-ROCKETTRAIL
		+NODAMAGETHRUST
		+FORCEPAIN
		RenderStyle "Add";
		Alpha 1;
		SeeSound "";
		DeathSound "dan_special_explode";
	}
	
	States {
		Spawn:
		DANC A -1;
		Loop;
		
		Death:
		//TNT1 A 0 A_RemoveLight ('CollateralShot');
		Stop;
	}
}