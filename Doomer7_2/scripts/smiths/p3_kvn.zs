Class K7_Smith_Kvn
{
	
}

Class K7_Smith_Kvn_Wep : K7_Smith_Weapon
{	
	Default
	{
		Weapon.SlotNumber 3;
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "kvn";
		m_fDamage = 42;
		m_fSpread = 0;
		m_fRecoil = 2;
		m_iClipSize = -1;
		m_fRefire = 26;
		m_fViewHeight = 0.95;
		m_fReloadTime = 37;
	}
	
	States
	{
		Spawn:
			KVNA A -1 bright;
			Loop;
		Recoil:
			Stop;
			TNT1 A 0;
			#### A 1 A_SetPitch( pitch - invoker.m_fRecoil );
			#### A 1 A_SetPitch( pitch + invoker.m_fRecoil * 2 );
			#### A 1 A_SetPitch( pitch - invoker.m_fRecoil * 1.5 );
			#### A 1 A_SetPitch( pitch + invoker.m_fRecoil * 0.75 );
			#### A 1 A_SetPitch( pitch - invoker.m_fRecoil * 0.25 );
			Stop;
		Fire:
			TNT1 A 0 A_Overlay( LAYER_ANIM, "Anim_Fire" );
			#### # 7;
			#### # 1 A_Overlay( LAYER_FUNC, "Shoot" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			#### # 0 A_Overlay( LAYER_FLASH, "Flash" );
			#### # 0
			{
				A_SetTics( ceil( invoker.m_fRefire ) - 8 );
			}
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		Flash:
			KVNF A 1 bright;
			Stop;
		Anim_Aim_In:
			KVNB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 50, 42, 0 );
			#### # 1 bright A_WeaponOffset ( 20, 38, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 36, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -15, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Aiming:
			KVNB A 1 bright
			{
				float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 6 ) * 0.5;
				A_WeaponOffset( offx, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		Anim_Fire:
			KVNB A 0 A_WeaponOffset( 0, 32 );
			#### BCS 1 bright;
			TNT1 A 4;
			KVNB # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### DEFGHIJKLM 1 bright;
			TNT1 A 5;
			KVNB NOPQR 1 bright;
			#### A 1 bright;
			Goto Anim_Aiming;
		Anim_Reload_Down:
			KVNB A 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			Stop;
		Anim_Reload_Up:
			KVNB A 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}