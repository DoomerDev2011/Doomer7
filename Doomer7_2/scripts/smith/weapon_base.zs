const LAYER_RELOAD = -1;
const LAYER_FLASH = -5;
const LAYER_RECOIL = -10;
const LAYER_RECOIL2 = -11;
const LAYER_RELOAD_FUNC = -20;
const LAYER_FUNC = -32;

const CHAN_CHARGE = CHAN_6;
const USE_HOLD_AIM = 0;

CONST WEAPON_FLAGS = ( WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 );
CONST WEAPON_FLAGS_REFIRE1 = ( WEAPON_FLAGS | WRF_NOPRIMARY );
CONST WEAPON_FLAGS_REFIRE2 = ( WEAPON_FLAGS | WRF_NOSECONDARY );

Class K7_SmithSyndicate_Weapon : Weapon
{
	Default
	{
		// Flags
		+WEAPON.NOALERT
		+WEAPON.NO_AUTO_SWITCH
		+WEAPON.NOAUTOAIM
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
		+WEAPON.NOAUTOFIRE
		// Stats
		Weapon.AmmoType1 "K7_Ammo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoType2 "K7_ThinBlood";
		Weapon.AmmoUse2 0;
		Weapon.KickBack 0;
		Weapon.BobSpeed 1.5;
		Weapon.BobRangeX 1;
		Weapon.BobRangeY 0.25;
		Weapon.BobStyle "Smooth";
	}
	
	bool m_bAiming;
	bool m_bPressedSpecial;
	
	States
	{
		Select:
			TNT1 A 0
			{
				return ResolveState( "Ready" );
			}
		
		Ready:
			TNT1 A 0;
			Goto Ready_Generic;
		
		Ready_Generic:
			#### A 0 A_JumpIf( ( USE_HOLD_AIM ), "Ready_HoldAim" );
			#### # 0 A_WeaponReady( WEAPON_FLAGS );
			#### # 1 bright;
			#### # 0
			{
				invoker.m_bPressedSpecial = false;
			}
			Loop;
			
		Ready_HoldAim:
			#### A 0 A_JumpIf( ( invoker.m_bAiming ), "Aiming" );
			#### # 0 A_JumpIf( (GetPlayerInput( INPUT_BUTTONS, 0 ) & BT_USER1), "Aim_In_Clapper" );
			#### # 0 A_WeaponReady( WEAPON_FLAGS | WRF_NOFIRE );
			#### # 0
			{
				invoker.m_bPressedSpecial = false;
			}
			#### # 1 Offset( 400, 400 );
			Loop;
			
		Aiming:
			#### A 0 A_JumpIf( !(GetPlayerInput( INPUT_BUTTONS, 0 ) & BT_USER1), "Aim_Out" );
			#### # 1 A_WeaponReady( WRF_ALLOWRELOAD | WRF_NOSWITCH | WRF_DISABLESWITCH );
			Loop;
		
		
		Aim_In_Clapper: // Black Bars that come down when aiming
			#### # 0
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fnSetSpeed( smith.m_fPersonaSpeed_Aiming );
				smith.JumpZ = 0;
				invoker.m_bAiming = true;
			}
			#### # 7;
			#### # 0 A_ZoomFactor( 1.75, ZOOM_INSTANT );
			#### # 0;
			#### # 0
			{
				invoker.LookScale = 0.5;
				return ResolveState( "Aim_In" );
			}
			

		Aim_Out:
			TNT1 A 0
			{
				A_ZoomFactor( 1, ZOOM_INSTANT );
				invoker.LookScale = 1;
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fnPersonaApplyStats();
				smith.m_iPersonaGunCharge = 0;
				A_StopSound( CHAN_CHARGE );
				invoker.m_bAiming = false;
			}
			#### # 0 ResolveState( "Ready_HoldAim" );
		
		Deselect:
			#### A 0 A_Overlay( LAYER_FUNC, "DisableProperties" );
			#### A 0 A_Overlay( LAYER_FUNC, "ChangePersona" );
			#### # 0
			{
				A_ZoomFactor( 1, ZOOM_INSTANT );
				invoker.LookScale = 1;
				invoker.m_bAiming = false;
			}
			#### A 1 bright A_WeaponOffset( 0, 32, 0);
			#### A 1 bright A_WeaponOffset( 1, 32 + ( 33 * 1 ), WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset( 2, 32 + ( 33 * 2 ), WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset( 3, 32 + ( 33 * 3 ), WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset( 4, 32 + ( 33 * 4 ), WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset( 5, 32 + ( 33 * 5 ), WOF_INTERPOLATE);
			Stop;
			
		Fire:
			#### # 0
			{
				A_Overlay( LAYER_FUNC, "Fire_Bullet");
				return ResolveState( "Ready" );
			}
			
		Fire_Bullet:
			#### # 0
			{
				let smith = SmithSyndicate( invoker.owner );
				float 	spread = smith.m_fPersonaGunSpread * smith.m_fPersonaGunSpread_Factor;
				int 	damage = smith.m_iPersonaGunDamage;
				int 	flags = smith.m_iPersonaGunFlags;
				A_FireBullets( spread, spread, 1, damage, "K7_BulletPuff", flags );
				
				if ( !smith.m_bPersonaGunSilenced )
					A_AlertMonsters();
			}
			Stop;
		
		Recoil_Generic:
			#### # 1 A_SetPitch( pitch + 2.75, 0 );
			#### # 1 A_SetPitch( pitch - 2.75 - 2.5, 0 );
			#### # 1 A_SetPitch( pitch + 2.5 + 2, 0 );
			#### # 1 A_SetPitch( pitch - 2 - 1.5, 0 );
			#### # 1 A_SetPitch( pitch + 1.5 + 1, 0 );
			#### # 0 A_SetPitch( pitch - 1, 0 );
			Stop;
		
		Reload:
			#### # 0 bright
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fnSetSpeed( min( smith.m_fPersonaSpeed_Reloading, smith.m_fCurrentSpeed ) );
				smith.JumpZ = 0;
				A_Overlay( LAYER_FUNC , "Reload_Start" );
				A_Overlay( LAYER_RELOAD , "Reload_Down" );
				A_SetTics( floor( smith.m_iPersonaGunReloadTime * smith.m_fPersonaGunReloadTime_Factor ) );
				A_ZoomFactor ( 1 ); //, ZOOM_INSTANT );
				invoker.LookScale = 1;
			}
			#### # 0 bright
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fnPersonaApplyStats();
				A_SetInventory( "K7_Ammo", smith.m_iPersonaGunClipSize );
				
				if ( invoker.m_bAiming )
					return ResolveState( "Aim_In_Clapper" );
				else
					return ResolveState( "Reload_Up" );
			}
			
		FormPersona:
			Stop;
		
		ChangePersona:
			#### # 0
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fnPersonaChangeBegin();
				A_SetTics( smith.m_iPersonaExplodeTime );
				A_ZoomFactor ( 1, ZOOM_INSTANT );
			}
			#### # 0
			{
				SmithSyndicate( invoker.owner).m_fnPersonaChange();
			}
			#### # 0
			{
				A_SetTics( SmithSyndicate( invoker.owner).m_iPersonaChangeTime );
			}
			#### # 0 A_Lower( 512 );
			Stop;
		
		User2:
			#### # 0
			{
				if ( invoker.m_bPressedSpecial )
				{
					return ResolveState( "Ready" );
				}
				invoker.m_bPressedSpecial = true;
				Return ResolveState( "UseSpecial" );
			}
			
		UseSpecial:
			#### # 0 A_Overlay( LAYER_FUNC, "ChargeTube" );
			#### # 0
			{
				return ResolveState( "Ready" );
			}
		
		ChargeTube:
			#### # 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_iPersonaGunCharge_Max > 0 && invoker.ammo2.amount > 0 )
				{
					smith.m_iPersonaGunCharge++;
					if ( smith.m_iPersonaGunCharge > invoker.ammo2.amount || smith.m_iPersonaGunCharge > smith.m_iPersonaGunCharge_Max )
					{
						smith.m_iPersonaGunCharge = 0;
					}
					switch( smith.m_iPersonaGunCharge )
					{
						case 0:
							A_StartSound( "charge_tube_cancel", CHAN_7, CHANF_OVERLAP  );
							break;
						case 1:
							A_StartSound( "charge_tubea", CHAN_7, CHANF_OVERLAP  );
							break;
						case 2:
							A_StartSound( "charge_tubeb", CHAN_7, CHANF_OVERLAP  );
							break;
						case 3:
							A_StartSound( "charge_tubec", CHAN_7, CHANF_OVERLAP  );
							break;
						case 4:
							A_StartSound( "charge_tubed", CHAN_7, CHANF_OVERLAP  );
							break;
						case 5:
							A_StartSound( "charge_tubee", CHAN_7, CHANF_OVERLAP  );
							break;
						default:
							A_StartSound( "charge_tubea", CHAN_7, CHANF_OVERLAP  );
					}
				}
			}
			stop;
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

Class K7_BulletPuff : BulletPuff
{
	default
	{
		+NOEXTREMEDEATH
	}
}
