Class CK7_Smith_Con
{
	
}

Class CK7_Smith_Con_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Weapon.SlotNumber 5;
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "con";
		m_fDamage = 40;
		m_fRecoil = 2.5;
		m_fSpread = 2;
		m_iClipSize = 6;
		m_fRefire = 16;
		m_fViewHeight = 0.9;
		m_fReloadTime = 42;
		m_fHeight = 40;
		m_bAutoFire = true;
	}
	
	States
	{
		Spawn:
			CONP A -1 bright;
			Loop;
		Recoil:
			TNT1 A 0;
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil * frandom( -1, 1 ) );
			Goto Recoil_Generic;
		Flash1:
			CONF A 0
			{
				return ResolveState( "Flash" );
			}
		Flash2:
			CONF B 0
			{
				return ResolveState( "Flash" );
			}
		Flash3:
			CONF C 0
			{
				return ResolveState( "Flash" );
			}
		Flash4:
			CONF D 0
			{
				return ResolveState( "Flash" );
			}
		Flash5:
			CONF E 0
			{
				return ResolveState( "Flash" );
			}
		Flash6:
			CONF F 0
			{
				return ResolveState( "Flash" );
			}
		Shoot:
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### # 1 A_Overlay( LAYER_FUNC, "Fire_Bullet" );
			#### # 4 A_Overlay( LAYER_RECOIL, "Recoil" );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashB" );
			#### # 1 A_Overlay( LAYER_FUNC, "Fire_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			Stop;
		Anim_Aim_In:
			CONB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 50, 64, 0 );
			#### # 1 bright A_WeaponOffset ( 20, 38, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 36, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -15, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Aiming:
			CONB A 1 bright
			{
				float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = sin( level.time * 6 ) * 0.5;
				A_WeaponOffset( offx, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		Anim_Fire:
			CONB A 0 A_WeaponOffset( 0, 32 );
			#### # 0 bright A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### BCDE 1 bright;
			#### # 0 bright A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### FGHIKLORST 2 bright;
			Goto Anim_Aiming;
		Anim_Reload_Down:
			CONB A 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### B 1 bright A_WeaponOffset ( 0, 32, 0);
			#### D 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### G 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### H 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### I 1 bright A_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			Stop;
		Anim_Reload_Up:
			CONB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}