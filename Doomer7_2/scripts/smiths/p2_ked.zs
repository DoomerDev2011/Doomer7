Class CK7_Smith_Ked
{
	
}

Class CK7_Smith_Ked_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Weapon.SlotNumber 2;
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "ked";
		m_fDamage = 45;
		m_fRecoil = 3;
		m_iClipSize = 10;
		m_fRefire = 15;
		m_fViewHeight = 0.75;
		m_fReloadTime = 35 * 3.5;
	}
	
	States
	{
		Spawn:
			KAEP A -1 bright;
			Loop;
		Recoil:
			TNT1 A 0;
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil * 0.2 );
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil *  0.1 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil *  0.2 );
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil *  0.15 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil *  0.05 );
			Stop;
		Flash1:
			KEDF A 1
			{
				return ResolveState( "Flash" );
			}
		Flash2:
			KEDF B 1
			{
				return ResolveState( "Flash" );
			}
		Flash3:
			KEDF C 1
			{
				return ResolveState( "Flash" );
			}
		Anim_Aim_In:
			KEDB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Aiming:
			KEDB A 1 bright
			{
				float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 6 ) * 0.5;
				A_WeaponOffset( offx, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		Anim_Fire:
			KEDB # 0 A_WeaponOffset( 0, 32 );
			#### # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### BCDEFGHIJ 2 bright;
			Goto Anim_Aiming;
		Anim_Reload_Down:
			KEDB A 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			Stop;
		Anim_Reload_Up:
			KEDB A 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}