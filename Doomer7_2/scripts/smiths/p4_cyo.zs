Class CK7_Smith_Cyo
{
	
}

Class CK7_Smith_Cyo_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Inventory.PickupMessage "You got the Enfield revolver!";
		Inventory.PickupSound "weapon/getrev";
		CK7_Smith_Weapon.PersonaSoundClass "k7_cyo";
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "cyo";
		m_fDamage = 35;
		m_fRecoil = 2.5;
		m_iClipSize = 6;
		m_fRefire = 18;
		m_fViewHeight = 0.8;
		m_fHeight = 60;
		m_fReloadTime = 42;
		m_iSpecialChargeCount = 1;
	}
	
	States
	{
		Spawn:
			M000 A -1 bright;
			stop;
			
		Recoil:
			TNT1 A 0;
			#### # 1 A_SetAngle( angle + invoker.m_fRecoil );
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil * 0.33 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil );
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil *  0.1 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil *  0.2 );
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil *  0.15 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil *  0.05 );
			Stop;
			
		Flash1:
			CYOF A 0
			{
				return ResolveState( "Flash" );
			}
			
		Flash2:
			CYOF B 0
			{
				return ResolveState( "Flash" );
			}
			
		Flash3:
			CYOF C 0
			{
				return ResolveState( "Flash" );
			}
			
		Shoot_Special1:
			#### # 0
			{
				A_SetTics( ceil( invoker.m_fFireDelay ) );
				invoker.A_TakeInventory( "CK7_ThinBlood", 1 );
				invoker.m_iSpecialCharges = 0;
			}
			#### # 1 A_Overlay( LAYER_FUNC, "Fire_Special_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			Stop;
			
		Fire_Special_Bullet:
			#### # 0
			{
				A_FireBullets
				(
					invoker.m_fSpread,
					invoker.m_fSpread,
					-1,
					invoker.m_fDamage * 3,
					"CK7_BulletPuff",
					BULLET_FLAGS
				);
			}
			Stop;		
			
		Altfire_Old:
			TNT1 A 0;
			#### # 0 A_JumpIf ( ( invoker.m_iAmmo == 0 ), "Reload" );
			#### # 0 A_Overlay( LAYER_ANIM, "Anim_Altfire" );
			#### # 0 A_Overlay( LAYER_SHOOT, "Shoot_Special" );
			#### # 0
			{
				if ( invoker.m_iAmmo > 0 )
					invoker.m_iAmmo--;
			}
			#### # 52;
			#### # 0 A_JumpIf( !invoker.m_bAutoFire, "Aiming" );
			#### # 0 A_Refire();
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
			
			
		Anim_Aim_In:
			CYOB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 240, -64, 0 );
			#### # 1 bright A_WeaponOffset ( 171, -35, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 108, -11, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 60, 8, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 27, 21, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 6, 29, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
			
		Anim_Aiming:
			TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, true);
			CYOB A 1 bright
			{
				float offx = sin( level.time * 6 ) * 0.5 ;
				//float offy = sin( level.time * 6 ) * 0.5;
				A_WeaponOffset( offx, 32 + 0, WOF_INTERPOLATE );
			}
			Loop;
			
		Anim_Fire:
			TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, false);
			CYOB A 0;
			#### # 0 A_WeaponOffset( 0, 32 );
			#### # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### BC 1 bright;
			TNT1 A 28;
			CYOB CDE 1 bright;
			#### FGHIJ 2 bright;
			Goto Anim_Aiming;
		
		Anim_Fire_Special1:
		Anim_Altfire:
			TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, false);
			CYOB A 0;
			#### # 0 A_WeaponOffset( 0, 32 );
			#### # 0 A_StartSound( invoker.m_sPersona .. "_special", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### BC 1 bright;
			TNT1 A 52; 
			CYOB CDE 1 bright;
			#### FGHIJ 2 bright;
			Goto Anim_Aiming;
			
		Anim_Reload_Down:
			CYOB A 0;
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 - 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 - 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 - 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 128, 32 - 256, WOF_INTERPOLATE);
			Stop;
			
		Anim_Reload_Up:
			CYOB A 0;
			#### # 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 32, 32 - 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 - 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 2, 32 - 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
			
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}