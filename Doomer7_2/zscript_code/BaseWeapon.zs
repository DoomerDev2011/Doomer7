const LAYER_RELOAD = -1;
const LAYER_FLASH = -5;
const LAYER_RECOIL = -10;
const LAYER_RECOIL2 = -11;
const LAYER_RELOAD_FUNC = -20;
const LAYER_FUNC = -32;


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
		Weapon.BobSpeed 1.5;
		Weapon.BobRangeX 1;
		Weapon.BobRangeY 0.25;
		Weapon.BobStyle "Smooth";
	}
	
	States
	{
		Select:
			Goto Ready;
			
		Ready:
			#### # 1 bright A_WeaponReady( WRF_ALLOWRELOAD | WRF_NOBOB );
			Loop;
		
		Deselect:
			#### A 0 A_Overlay( LAYER_FUNC, "DisableProperties" );
			#### A 0 A_Overlay( LAYER_FUNC, "ChangePersona" );
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
				smith.m_fnSetSpeed( smith.m_fPersonaSpeed_Reloading );
				smith.JumpZ = 0;
				A_Overlay( LAYER_FUNC , "Reload_Start" );
				A_Overlay( LAYER_RELOAD , "Reload_Down" );
			}
			#### # 0 bright
			{
				let smith = smithSyndicate( invoker.owner );
				A_SetTics( floor( smith.m_iPersonaGunReloadTime * smith.m_fPersonaGunReloadTime_Factor ) );
			}
			#### # 0 bright
			{
				let smith = SmithSyndicate( invoker.owner );
				A_SetInventory( "K7_Ammo", smith.m_iPersonaGunClipSize );
				smith.m_fnPersonaApplyStats();
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
