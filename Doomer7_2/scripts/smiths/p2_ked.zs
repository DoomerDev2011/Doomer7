Class CK7_Smith_Ked
{
	
}

Class CK7_Smith_Ked_Wep : CK7_Smith_Weapon
{	
	
	Default
	{
		Weapon.SlotNumber 2;
		Inventory.PickupMessage "You got the AMT Hardballer!";
		Inventory.PickupSound "weapon/gethar";
		
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_sPersona = "ked";
		m_fDamage = 45;
		m_fRecoil = 3;
		m_iClipSize = 10;
		m_fRefire = 15;
		m_fViewHeight = 0.4;
		m_fHeight = 55;
		m_fReloadTime = 35 * 3.5;
		
	}
	
	bool m_bZoomedReload;
	
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
			
		Reload:
			#### # 0 A_JumpIf( CK7_Smith( invoker.owner ).m_bAiming, "Aiming_Reload" );
			#### # 0
			{
				return ResolveState( "Standing_Reload" );
			}
		
		AltFire:
			TNT1 A 0;
			#### # 0 A_JumpIf( CK7_Smith( invoker.owner ).m_bZoomedIn, "Zoom_Out" );
			Goto Zoom_In;
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		
		Zoom_In:
			TNT1 A 0;
			#### # 0 A_ZoomFactor( 6 );
			#### # 0 A_Overlay( LAYER_ANIM, "Anim_Zoom_In" );
			#### # 0
			{
				CK7_Smith( invoker.owner ).SetStatic( true );
			}
			#### # 15;
			#### # 0
			{
				CK7_Smith( invoker.owner ).m_bZoomedIn = true;
			}
			Goto Aiming_Zoomed;
		
		Aiming_Zoomed:
			TNT1 A 0;
			#### # 0 A_JumpIf( !( CK7_Smith( invoker.owner ).m_bAimHeld ), "Aim_Out" );
			#### # 1 A_WeaponReady( ( CVar.FindCVar( 'k7_mode' ).GetBool() ) ? AIMING_FLAGS : AIMING_FLAGS &~ WRF_DISABLESWITCH );
			Loop;
		
		Zoom_Out:
			TNT1 A 0;
			#### # 0 A_ZoomFactor( 1 );
			#### # 0
			{
				CK7_Smith( invoker.owner ).SetStatic( false );
			}
			#### # 0
			{
				CK7_Smith( invoker.owner ).m_bZoomedIn = false;
			}
			#### # 0 A_Overlay( LAYER_ANIM, "Anim_Zoom_Out" );
			#### # 15;
			#### # 0
			{
				return ResolveState( "Aiming" );
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
			
		Anim_Zoom_In:
			KEDB A 0;
			#### # 0 A_StartSound( invoker.m_sPersona .. "_zoomin", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0, 32, 0 );
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE );
			Goto Anim_Zoomed;
			
		Anim_Zoomed:
			TNT1 A 1 bright;
			
			Loop;
		
		Anim_Fire_Zoomed:
			TNT1 A 0;
			#### # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_SetBlend( "E6F63F", 0.25, 10 );
			#### # 2 A_Light( 6 );
			#### # 2 A_Light( 4 );
			#### # 2 A_Light( 2 );
			#### # 2 A_Light( 0 );
			Goto Anim_Zoomed;
		
		Anim_Zoom_Out:
			KEDB A 0;
			#### # 0 A_StartSound( invoker.m_sPersona .. "_zoomout", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 128, 32 + 256, 0 );
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
			
		Anim_Fire:
			KEDB A 0;
			#### # 0 A_WeaponOffset( 0, 32 );
			#### # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			#### BCDEFGHIJ 2 bright;
			Goto Anim_Aiming;
		
		Anim_Reload_Down:
			KEDB A 0 {
				if (CK7_Smith( invoker.owner ).m_bZoomedIn){
					A_ZoomFactor( 1 );
					CK7_Smith( invoker.owner ).SetStatic( false );
					CK7_Smith( invoker.owner ).m_bZoomedIn = false;
					A_StartSound( invoker.m_sPersona .. "_zoomout", CHAN_WEAPON, CHANF_OVERLAP );
				}
			}	
			#### # 0 A_StartSound( invoker.m_sPersona .. "_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE );
			Stop;
		
		Anim_Reload_Up:
			KEDB A 0;
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