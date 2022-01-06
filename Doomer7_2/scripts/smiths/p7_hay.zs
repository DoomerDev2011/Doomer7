Class K7_Smith_Hay
{
	
}

Class K7_Smith_Hay_Wep : K7_Smith_Weapon
{	
	Default
	{
		Weapon.SlotNumber 7;
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "hay";
		m_fDamage = 47;
		m_fRecoil = 3;
		m_iClipSize = 50;
		m_fRefire = 10;
		m_fHeight = 0.75;
		m_fReloadTime = 35 * 1.5;
		m_bAutoFire = true;
	}
	
	States
	{
		Spawn:
			HAYA A -1 bright;
			Loop;
		Recoil:
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil );
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
			#### # 1 bright A_WeaponOffset ( 50, 42, 0 );
			#### # 1 bright A_WeaponOffset ( 20, 38, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 36, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -15, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Aiming:
			HAYB A 1 bright
			{
				float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 6 ) * 0.5;
				A_WeaponOffset( offx, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		Anim_Fire:
			#### # 0 A_WeaponOffset( 0, 32 );
			#### # 1 bright A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			HAYB BCDEFGHI 1 bright;
			Goto Anim_Aiming;
		Anim_Aiming_Reload:
			HAYB A 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			//#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			//#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			//#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			#### # 50 bright;
			//#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			//#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			//#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}