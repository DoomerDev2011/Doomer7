Class CK7_Smith_Kvn
{
	
}

Class CK7_Smith_Kvn_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Inventory.PickupMessage "You got the throwing knives!";
		Inventory.PickupSound "weapon/getknife";
		CK7_Smith_Weapon.PersonaSoundClass "k7_kvn";
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "kvn";
		m_fDamage = 30;
		m_fSpread = 0;
		m_fRecoil = 2;
		m_iClipSize = -1;
		m_fRefire = 30;
		m_fViewHeight = 0.6;
		m_fHeight = 50;
		m_fReloadTime = 0;
		m_fFireDelay = 10;
		m_iSpecialChargeCount = 1;
	}
	
	States
	{
		Spawn:
			KEVP A -1 bright;
			Loop;
		Recoil:
			TNT1 A 0;
			Goto Recoil_Generic;
		FlashA:
			KVNF A 1 bright;
			Stop;
			
		Fire_Special_Bullet:
			#### # 0
			{
				A_FireBullets(
					invoker.m_fSpread,
					invoker.m_fSpread,
					-1,
					invoker.m_fDamage * 3,
					"CK7_BulletPuff",
					BULLET_FLAGS
				);
			}
			Stop;		
			
		Shoot_Special1:
			#### # 0
			{
				invoker.m_iSpecialCharges = 0;
				invoker.A_TakeInventory( "CK7_ThinBlood", 1 );
			}
			TNT1 A 0 A_Overlay(LAYER_ANIM, "Anim_Altfire");
			#### # 19;
			#### # 1 A_Overlay( LAYER_FUNC, "Fire_Special_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			#### # 84;
			#### # 0
			{
				return ResolveState( "Aiming" );
			} 	
			
		Anim_Aim_In:
			KVNB A 0 A_StartSound( invoker.m_sPersona .. "_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 50, 42, 0 );
			#### # 1 bright A_WeaponOffset ( 34, 38, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 22, 36, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 13, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 6, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 2, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
			
		// TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, true); have this to start bobbing again	
		Anim_Aiming:
			TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, true);
			KVNB A 1 bright 
			{
				//float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 6 ) * 0.5;
				A_WeaponOffset( 0, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
		Anim_Fire:
			KVNB A 0 bright A_WeaponOffset ( 0, 32 );
			#### BCS 1 bright;
			TNT1 A 7;
			KVNB # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### E 4 bright;
			#### FGHIJKL 1 bright;
			TNT1 A 5;
			KVNB MNOPQ 1 bright;
			#### A 1 bright;
			Goto Anim_Aiming;
			
		
		//  A_WeaponOffset( 0, 32, WOF_INTERPOLATE );	have this to recenter frame
		// TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, false); have this to stop bobbing during animation
		Anim_Altfire:
			TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, false);
			#### # 0 A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			KVNA ABC 1 bright;
			TNT1 A 17;
			KVNA D 1 {
				A_StartSound( invoker.m_sPersona .. "_special_shot", CHAN_WEAPON, CHANF_OVERLAP );
				A_SetBlend( "E6F63F", 0.25, 10 );
			}
			KVNA EFGHIJKLMNOPQRSTUVWXYZ 1 bright;
			KVNC ABDEFGHIJKLMNOPQRSTUVWXYZ 1 bright;
			KVND ABCEFGHIJKLMNOPQRSTUVWXYZ 1 bright; 
			KVNE ABCDEF 1 bright;
			KVNB A 1 bright;
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