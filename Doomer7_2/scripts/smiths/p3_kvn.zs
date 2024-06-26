Class CK7_Smith_Kvn_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Tag "Kevin";
		Inventory.PickupMessage "You got the throwing knives!";
		Inventory.PickupSound "weapon/getknife";
		CK7_Smith_Weapon.PersonaSoundClass "k7_kvn";
		CK7_Smith_Weapon.UltrawideOffset 0;
 		CK7_Smith_Weapon.Persona "kvn";
 		CK7_Smith_Weapon.PersonaDamage 15;
		CK7_Smith_Weapon.PersonaCritical 20;
 		CK7_Smith_Weapon.PersonaSpread 0;
 		CK7_Smith_Weapon.PersonaRecoil 2;
 		CK7_Smith_Weapon.PersonaClipSize -1;
 		CK7_Smith_Weapon.PersonaRefireTime 30;
 		CK7_Smith_Weapon.PersonaViewHeight 0.6;
 		CK7_Smith_Weapon.PersonaHeight 35;
 		CK7_Smith_Weapon.PersonaReloadTime 0;
 		CK7_Smith_Weapon.PersonaFireDelay 10;
 		CK7_Smith_Weapon.PersonaCharges 1;
	}
	
	States
	{
		Spawn:
			M000 A -1 bright;
			stop;
		Recoil:
			TNT1 A 0;
			Goto Recoil_Generic;
		FlashA:
			KVNF A 1 bright;
			Stop;
			
		Fire:
			#### # 0
			{
				if ( invoker.m_iSpecialCharges > 0 ) 
				{	
					A_Overlay( LAYER_ANIM, "Anim_Altfire" );
					A_Overlay( LAYER_SHOOT, "Shoot_Special1" );
					A_SetTics(85);
				}
				else 
				{
					A_Overlay( LAYER_ANIM, "Anim_Fire" );
					A_Overlay( LAYER_SHOOT, "Shoot" );
					A_SetTics( ceil( invoker.m_fRefire ) - 1 );
				}
				A_StopSound(CHAN_5);
			}
			#### # 0 A_JumpIf( !invoker.m_bAutoFire, "Aiming" );
			#### # 0 A_Refire();
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
			
		Shoot:
			#### # 0
			{
				if ( invoker.m_iAmmo > 0 )
					invoker.m_iAmmo--;
				A_SetTics( ceil( invoker.m_fFireDelay ) );
			}
			#### # 1 
			{
				K7_FireBullet(invoker.m_fDamage,0,20,1);
				A_Overlay( LAYER_RECOIL, "Recoil" );
				A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
				A_Overlay( LAYER_FLASH, "FlashA" );
			}
			Stop;
			
		Shoot_Special1:
			#### # 0
			{
				invoker.m_iSpecialCharges = 0;
				//invoker.m_fRefire = 85;
				A_TakeInventory( "CK7_ThinBlood", 1 );
			}
			#### # 19;
			stop;
			
		Anim_Aim_In:
			KVNB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright K7_WeaponOffset ( 50, 42, 0 );
			#### # 1 bright K7_WeaponOffset ( 34, 38, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 22, 36, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 13, 34, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 6, 34, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 2, 34, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
			
		// TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, true); have this to start bobbing again	
		Anim_Aiming:
			TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, true);
			KVNB A 1 bright 
			{
				//float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 6 ) * 0.5;
				K7_WeaponOffset( 0, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		Anim_Fire:
			KVNB A 0
			{
				K7_WeaponOffset ( 0, 32 );
			}
			#### BCS 1 bright;
			TNT1 A 7;
			KVNB E 4 bright;
			#### FGHIJKL 1 bright;
			TNT1 A 5;
			KVNB MNOPQ 1 bright;
			#### A 1 bright;
			Goto Anim_Aiming;
			
		
		//  K7_WeaponOffset( 0, 32, WOF_INTERPOLATE );	have this to recenter frame
		// TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, false); have this to stop bobbing during animation
		Anim_Altfire:
			TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, false);
			#### # 0 K7_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			KVNA ABC 1 bright;
			TNT1 A 16;
			KVNA D 1 {
				K7_FireBullet(invoker.m_fDamage,0,20,1);
				K7_FireBullet(invoker.m_fDamage,0,20,1);
				K7_FireBullet(invoker.m_fDamage,0,20,1);
				A_StartSound( invoker.m_sPersona .. "_special_shot", CHAN_WEAPON, CHANF_OVERLAP );
				A_SetBlend( "E6F63F", 0.25, 10 );
			}
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			KVNA EFGHIJKLMNOPQRSTUVWXYZ 1 bright;
			KVNC ABDEFGHIJKLMNOPQRSTUVWXYZ 1 bright;
			KVND ABCEFGHIJKLMNOPQRSTUVWXYZ 1 bright; 
			KVNE ABCDEF 1 bright;
			KVNB A 1 bright;
			stop;
			/*
			KVNA DEGHIJK 1 bright; 
			KVNA MOQSUWY 1 bright;
			KVNC ADFHJ 1 bright;
			KVNC KLMNOPQRSTUVWXYZ 1 bright;
			KVND BEGIJLNPR 1 bright;
			KVND TVXZ 1 bright; 
			KVNE ACE 2 bright;
			KVNB A 2 bright;
			*/
			Goto Anim_Aiming;
			
			
		Anim_Reload_Down:
			KVNB A 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright K7_WeaponOffset ( 0, 32, 0);
			#### # 1 bright K7_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright K7_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright K7_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright K7_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			Stop;
		Anim_Reload_Up:
			KVNB A 1 bright K7_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		Anim_Standing_Reload:
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload_standing", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
			
	}
}