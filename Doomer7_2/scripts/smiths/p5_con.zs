Class CK7_Smith_Con
{
	
}

Class CK7_Smith_Con_Wep : CK7_Smith_Weapon
{	

	float m_iConSpeedTimer;
	
	Default
	{
		Weapon.SlotNumber 5;
		Inventory.PickupMessage "You got the automatic pistols!";
		Inventory.PickupSound "weapon/getglk";
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
		m_fViewHeight = 0.4;
		m_fReloadTime = 42;
		m_fHeight = 40;
		m_bAutoFire = true;
		m_iConSpeedTimer = 30;
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
			#### # 1 A_Overlay( LAYER_FUNC, "Fire_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			#### # 4
			{
				
			}
			#### # 1 A_Overlay( LAYER_FUNC, "Fire_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			Stop;
			
		Altfire:
			#### # 0
			{
				if ( invoker.m_iConSpeedTimer > 0)
				{
					return ResolveState("Ready");
				}
				//A_TakeInventory( "K7_ThinBlood", 1 );
				invoker.m_iConSpeedTimer = 35 * 5;
				return ResolveState( "Anim_Altfire" );
			}
			
		Anim_Altfire:
			#### A 0 A_ZoomFactor( 0.7 );
			CONS # 1 bright
			{
				let smith = CK7_Smith( invoker.owner );
				smith.SetSpeed( 0 );
				A_StartSound( "persona_powera", CHAN_BODY, CHANF_OVERLAP );
			}
			#### # 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE);
			TNT1 A 30;
			#### # 25
			{
				A_StartSound( "con_special_vo", CHAN_VOICE, 0 );
			}
			#### # 20
			{
				A_StartSound ( "con_special_pose", CHAN_BODY, CHANF_OVERLAP );
			}
			#### # 0
			{
				let smith = CK7_Smith( invoker.owner );
				smith.m_fSpeedFactor = smith.m_fPersonaSpecialFactor;
				smith.SetSpeed( smith.m_fSpeed );
				invoker.m_iConSpeedTimer = 35 * 20;
			}
			#### A 0 A_ZoomFactor( 1 );
			CONS A 1 bright A_WeaponOffset ( 64, 32 + 128, 0);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE);
			Goto Ready;
			
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
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### BCDE 1 bright;
			#### # 0 bright A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashB" );
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