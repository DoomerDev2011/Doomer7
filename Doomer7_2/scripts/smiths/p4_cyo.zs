Class CK7_Smith_Cyo
{
	
}

Class CK7_Smith_Cyo_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Weapon.SlotNumber 4;
		Inventory.PickupMessage "You got the Enfield revolver!";
		Inventory.PickupSound "weapon/getrev";
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "cyo";
		m_fDamage = 40;
		m_fRecoil = 2.5;
		m_iClipSize = 6;
		m_fRefire = 18;
		m_fViewHeight = 0.8;
		m_fHeight = 60;
		m_fReloadTime = 42;
	}
	
	States
	{
		Spawn:
			COYP A -1 bright;
			Loop;
			
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
			CYOB A 1 bright
			{
				float offx = sin( level.time * 6 ) * 0.5 ;
				//float offy = sin( level.time * 6 ) * 0.5;
				A_WeaponOffset( offx, 32 + 0, WOF_INTERPOLATE );
			}
			Loop;
			
		Anim_Fire:
			CYOB A 0;
			#### # 0 A_WeaponOffset( 0, 32 );
			#### # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### BC 1 bright;
			TNT1 A 28;
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