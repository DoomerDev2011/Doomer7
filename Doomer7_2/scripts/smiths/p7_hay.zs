Class CK7_Smith_Hay
{
	
}

Class CK7_Smith_Hay_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Inventory.PickupMessage "You got the Tommygun!";
		Inventory.PickupSound "weapon/gettmg";
		CK7_Smith_Weapon.PersonaSoundClass "k7_hay";
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "hay";
		m_fDamage = 19;
		m_fRecoil = 2.5;
		m_fSpread = 1.66;
		m_iClipSize = 50;
		m_fRefire = 6;
		m_fViewHeight = 0.8;
		m_fHeight = 60;
		m_fReloadTime = 65;
		m_bAutoFire = true;
	}
	
	States
	{
		Spawn:
			M000 A -1 bright;
			stop;
		Recoil:
			TNT1 A 0;
			#### # 1 A_SetPitch( pitch + frandom( - 1, 0.25 ) * invoker.m_fRecoil, 0 );
			#### # 1 A_SetAngle( angle + frandom( -0.25, 0.25 ) * invoker.m_fRecoil, 0 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil * 0.2 );
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil *  0.1 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil *  0.2 );
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil *  0.15 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil *  0.05 );
			Stop;
		Flash1:
			HAYF A 0
			{
				return ResolveState( "Flash" );
			}
		Flash2:
			HAYF B 0
			{
				return ResolveState( "Flash" );
			}
		Flash3:
			HAYF C 0
			{
				return ResolveState( "Flash" );
			}
		Anim_Aim_In:
			HAYB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0 - 5, 32 + 10, 0 );
			#### # 1 bright A_WeaponOffset ( 0 - 2.5, 32 + 5, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0 - 1.25, 32 + 2.5, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0 - 0.75, 32 + 1.25, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0 - 0.375, 32 + 0.75 , WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0 - 0.1875, 32 + 0.375, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Aiming:
			HAYB A 1 bright
			{
				float anim_time = ( level.time * 3 );
				float offx = sin( anim_time ) * 2.3 ;
				float offy = 1 + sin( anim_time * 2 ) * 0.5;
				A_WeaponOffset( offx, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		Anim_Fire:
			HAYB B 0 A_WeaponOffset( 0, 32 );
			#### # 0 bright A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### BCDEF 1 bright;
			Goto Anim_Aiming;
		Anim_Reload_Down:
			HAYB A 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( -2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( -8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( -32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( -128, 32 + 256, WOF_INTERPOLATE);
			Stop;
		Anim_Reload_Up:
			HAYB A 1 bright A_WeaponOffset ( -32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}