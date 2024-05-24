Class CK7_Smith_Gar_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Tag "Garcian";
		Inventory.PickupMessage "You got the Supressed P230!";
		Inventory.PickupSound "weapon/getppk";
		CK7_Smith_Weapon.PersonaSoundClass "k7_gar";
		CK7_Smith_Weapon.UltrawideOffset 0;
 		CK7_Smith_Weapon.Persona "gar";
 		CK7_Smith_Weapon.PersonaDamage 6;
		CK7_Smith_Weapon.PersonaCritical 33.34;
 		CK7_Smith_Weapon.PersonaRecoil 2;
 		CK7_Smith_Weapon.PersonaClipSize 5;
 		CK7_Smith_Weapon.PersonaRefireTime 10;
 		CK7_Smith_Weapon.PersonaViewHeight 0.985;
 		CK7_Smith_Weapon.PersonaHeight 60;
 		CK7_Smith_Weapon.PersonaReloadTime 28;
	}
	
	States
	{
		Spawn:
			M000 A -1 bright;
			stop;
		Shoot:
			#### # 1 
			{
				if ( invoker.m_iAmmo > 0 ) invoker.m_iAmmo--;
				K7_FireBullet(invoker.m_fDamage,invoker.m_fSpread,invoker.m_fCritical);
				A_Overlay( LAYER_RECOIL, "Recoil" );
				//A_AlertMonsters();
			}
			Stop;
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
		Anim_Aim_In:
			GARB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright K7_WeaponOffset ( 50, 42, 0 );
			#### # 1 bright K7_WeaponOffset ( 20, 38, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 0, 36, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( -15, 34, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Aiming:
			GARB A 1 bright
			{
				float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 6 ) * 0.5;
				K7_WeaponOffset( offx, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		Anim_Fire:
			GARB A 0 K7_WeaponOffset( 0, 32 );
			#### # 0 bright A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### ABCD 1 bright;
			#### EF 2 bright;
			Goto Anim_Aiming;
		Anim_Reload_Down:
			GARB A 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright K7_WeaponOffset ( 0, 32, 0);
			#### # 1 bright K7_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright K7_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright K7_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright K7_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			Stop;
		Anim_Reload_Up:
			GARB A 1 bright K7_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}