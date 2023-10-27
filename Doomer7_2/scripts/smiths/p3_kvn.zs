Class CK7_Smith_Kvn
{
	
}

Class CK7_Smith_Kvn_Wep : CK7_Smith_Weapon
{	
	Default
	{
		Weapon.SlotNumber 3;
		Inventory.PickupMessage "You got the throwing knives!";
		Inventory.PickupSound "weapon/getknife";
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "kvn";
		m_fDamage = 42;
		m_fSpread = 0;
		m_fRecoil = 2;
		m_iClipSize = -1;
		m_fRefire = 30;
		m_fViewHeight = 0.6;
		m_fHeight = 50;
		m_fReloadTime = 0;
		m_fFireDelay = 10;
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
			
		Altfire:
			TNT1 A 0 A_Overlay(LAYER_ANIM, "Anim_Altfire");
			TNT1 A 50; 
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
			
		
		//  A_WeaponOffset( 0, 32, WOF_INTERPOLATE );	
		Anim_Altfire:
			TNT1 A 0 A_OverlayFlags(LAYER_ANIM, PSPF_ADDBOB, false);
			#### # 0 A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			KVNA ABCDEFGHIJKLMNOPQRSTUVWXYZ 1;
			KVNC ABCDEFGHIJKLMNOPQRSTUVWXYZ 1;
			KVND ABCDEFG 1;
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