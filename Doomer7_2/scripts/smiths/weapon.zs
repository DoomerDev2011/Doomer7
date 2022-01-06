Class K7_Smith_Weapon : Weapon
{
	const READY_FLAGS = ( WRF_ALLOWRELOAD | WRF_NOPRIMARY | WRF_NOSECONDARY | WRF_NOBOB );
	const AIMING_FLAGS = ( WRF_ALLOWRELOAD | WRF_DISABLESWITCH );
	const BULLET_FLAGS = ( FBF_USEAMMO | FBF_NORANDOM | FBF_NORANDOMPUFFZ );
	
	const LAYER_BARS = 50;
	const LAYER_ANIM = 2;
	const LAYER_FUNC = -1;
	const LAYER_RECOIL = -2;
	const LAYER_FLASH = -5;
	
	int 	m_iPersona;
	string 	m_sPersona;
	int 	m_fDamage;
	float 	m_fSpread;
	float 	m_fRecoil;
	int 	m_iClipSize;
	int 	m_iAmmo;
	float 	m_fRefire;
	float  	m_fHeight;
	float 	m_fReloadTime;
	float 	m_fReloadTimeStanding;
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_iPersona = slotnumber;
		m_sPersona = "none";
		
		m_fDamage = 40;
		m_fSpread = 1;
		m_fRecoil = 2.5;
		m_iClipSize = 6;
		m_fRefire = 15;
		m_fHeight = 50;
		m_fReloadTime = 50;
		m_fReloadTimeStanding = 70;
	}
	
	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		m_iAmmo = m_iClipSize;
	}
	
	Default
	{
		+WEAPON.NOAUTOFIRE
		+WEAPON.NOALERT
		+WEAPON.NO_AUTO_SWITCH
		+WEAPON.NOAUTOAIM
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		
		Weapon.AmmoType1 "K7_Ammo";
		Weapon.AmmoUse1 0;
		Weapon.AmmoType2 "K7_ThinBlood";
		Weapon.AmmoUse2 0;
		Weapon.KickBack 0;
		Weapon.SlotNumber 0;
	}
	
	
	
	States
	{
		Select:
			TNT1 A 1 A_WeaponOffset( 0, 32, 0 );
			#### # 0
			{
				if ( CVar.FindCVar('k7_mode').GetBool() )
				{
					invoker.m_iAmmo = invoker.m_iClipSize;
				}
				return ResolveState( "Ready" );
			}
		Ready:
			TNT1 A 0;
			#### # 0 A_SetCrosshair( CVar.FindCVar('k7_mode').GetBool() ? 1 : 2 );
			#### # 0 A_JumpIf( (K7_Smith( invoker.owner ).m_bAimHeld) , "Aim_In" );
			#### # 1 A_WeaponReady( READY_FLAGS );
			Goto Ready + 2;
		Deselect:
			#### # 0 A_Lower( 512 );
			Stop;
		Aim_In:
			#### # 0 
			{
				if ( CVar.FindCVar('k7_mode').GetBool() )
				{
					Thing_Stop( 0 );
					K7_Smith( invoker.owner ).m_fnSetSpeed( 0 );
				}
			}
			#### # 5;
			#### # 0
			{
				if ( CVar.FindCVar('k7_mode').GetBool() )
				{
					invoker.LookScale = 0.5;
					A_ZoomFactor( 2.75, ZOOM_INSTANT );
					A_SetCrosshair( 2 );
				}
			}
			#### # 15 A_Overlay( LAYER_ANIM, "Anim_Aim_In" );
			#### # 0
			{
				K7_Smith( invoker.owner ).m_bAiming = true;
				return ResolveState( "Aiming" );
			}
		Aiming:
			#### # 0 A_JumpIf( !(K7_Smith( invoker.owner ).m_bAimHeld), "Aim_Out" );
			#### # 1 A_WeaponReady( ( CVar.FindCVar('k7_mode').GetBool() ) ? AIMING_FLAGS : AIMING_FLAGS &~ WRF_DISABLESWITCH );
			Loop;
		Fire:
			#### # 0 A_JumpIf ( ( invoker.m_iAmmo < 1 ), "Reload" );
			#### # 0 A_Overlay( LAYER_ANIM, "Anim_Fire" );
			#### # 0 A_Overlay( LAYER_FUNC, "Shoot" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			#### # 0
			{
				invoker.m_iAmmo--;
				A_Overlay( LAYER_FLASH, "FlashR" );
			}
			#### # 0
			{
				A_SetTics( ceil( invoker.m_fRefire ) );
			}
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		FlashR:
			#### # 0
			{
				switch( Random( 0, 2 ) )
				{
					case 0:
						return ResolveState( "Flash1" );
						break;
					case 1:
						return ResolveState( "Flash2" );
						break;
					case 2:
						return ResolveState( "Flash3" );
						break;
				}
				return ResolveState( null );
			}
		Flash:
			#### # 0 A_Light( 6 );
			#### # 0 A_SetBlend( "E6F63F", 0.25, 10 );
			#### # 0 A_OverlayFlags( LAYER_FLASH, PSPF_RENDERSTYLE, true );
			#### # 0 A_OverlayFlags( LAYER_FLASH, PSPF_ALPHA, true );
			#### # 0 A_OverlayRenderStyle( LAYER_FLASH, STYLE_Translucent );
			#### # 2 bright;
			#### # 0 A_Light( 4 );
			#### # 2 bright A_OverlayAlpha( LAYER_FLASH, 0.66 );
			#### # 0 A_Light( 2 );
			#### # 2 A_OverlayAlpha( LAYER_FLASH, 0.33 );
			#### # 0 A_Light( 0 );
			Stop;
		Reload:
			#### # 0 A_JumpIf( K7_Smith( invoker.owner ).m_bAiming, "Aiming_Reload" );
			#### # 0
			{
				return ResolveState( "Standing_Reload" );
			}
		Aiming_Reload:
			#### # 0
			{
				A_Overlay( LAYER_ANIM, "Anim_Aiming_Reload" );
				A_SetTics( ceil( invoker.m_fReloadTime ) );
			}
			#### # 0
			{
				A_SetInventory( "K7_Ammo", invoker.m_iClipSize );
				invoker.m_iAmmo = invoker.m_iClipSize;
				return ResolveState( "Aiming" );
			}
		Standing_Reload:
			#### # 0
			{
				A_Overlay( LAYER_ANIM, "Anim_Standing_Reload" );
				A_SetTics( invoker.m_fReloadTimeStanding );
			}
			#### # 0
			{
				A_SetInventory( "K7_Ammo", invoker.m_iClipSize );
				invoker.m_iAmmo = invoker.m_iClipSize;
				return ResolveState( "Ready" );
			}
		Shoot:
			#### # 0
			{
				float 	spread = invoker.m_fSpread;
				float 	damage = invoker.m_fDamage;
				A_FireBullets( spread, spread, -1, damage, "BulletPuff", BULLET_FLAGS );
			}
			Stop;
		Aim_Out:
			#### # 0 A_Overlay( LAYER_ANIM, null );
			#### # 0 A_ZoomFactor( 1, ZOOM_INSTANT );
			#### # 0 A_SetCrosshair( 1 );
			#### # 10
			{
				invoker.LookScale = 1;
				let smith = K7_Smith( invoker.owner );
				smith.m_bAiming = false;
			}
			#### # 0
			{
				let smith = K7_Smith( invoker.owner );
				smith.m_fnApplyStats();
				return ResolveState( "Ready" );
			}
	}
}

Class K7_Ammo : Ammo
{
	Default
	{
		+INVENTORY.IGNORESKILL;
		Inventory.Amount 1;
		Inventory.MaxAmount 255;
	}
}
