// Enfield2 Weapon
//

Class K7_Coyote_Enfield2: K7_SmithSyndicate_Weapon
{
	default{
		Weapon.SlotNumber 4;
		Weapon.BobSpeed 1.7;
		Weapon.BobRangeX 0.4;
		Weapon.BobRangeY 2;
		
	    Inventory.PickupSound "weapon/getrev";
		Inventory.Pickupmessage "You got Coyote's Modified Enfield No.2."; 
	}
	
	int m_iRefireLevel;
	
	
	States
	{
		Spawn:
			COYH A -1 bright;
			Loop;
		Select:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_fnPersonaChangeEnd( 4 ) ) 
				{
					A_SetInventory( "K7_Ammo", smith.m_iPersonaGunClipSize );
					A_SetTics( smith.m_iPersonaFormTime );
				}
			}
			#### # 0
			{
				SmithSyndicate( invoker.owner ).m_fnPersonaChangeReady();
			}
			COYO A 1 bright A_WeaponOffset ( 180, 100, 0 );
			#### # 1 bright A_WeaponOffset ( 150, 70, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 120, 60, WOF_INTERPOLATE );
			#### # 0 A_StartSound( "cyo_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset (90,52,WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset (50,40,WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset (20,38,WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset (0,36,WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Ready;
			
		Ready:
			COYO A 1 bright A_WeaponReady( WRF_ALLOWRELOAD );
			Loop;
			
		Fire:
			COYO A 0 A_JumpIfNoAmmo( "Reload" );
			#### # 0 A_StopSound( CHAN_7 );
			#### # 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_iPersonaGunCharge > 0 && invoker.ammo2.amount > 0 )
				{
					float spread = smith.m_fPersonaGunSpread * 0.5;
					A_FireBullets( spread, spread, 1, 180, "K7_BulletPuff", FBF_USEAMMO|FBF_NORANDOM );
					A_Overlay( LAYER_RECOIL, "Recoil" );
					A_StartSound( "cyo_special", CHAN_WEAPON, CHANF_OVERLAP );
					A_TakeInventory( "K7_ThinBlood", 1 );
					A_AlertMonsters();
				}
				else
				{
					A_Overlay( -1, "Fire_Bullet" );
					A_Overlay( LAYER_RECOIL, "Recoil" );
					A_StartSound( "cyo_shoot", CHAN_WEAPON, CHANF_OVERLAP );
				}
				smith.m_iPersonaGunCharge = 0;
			}
			#### # 0 bright{
				int num = Random(0,2);
				if ( num == 0 )
				{
					A_Overlay( -1, "Flash1" );
				}
				else if ( num == 1 )
				{
					A_Overlay(-1,"Flash2");
				}
				else 
				{
					A_Overlay(-1,"Flash3");
				}
			}
			#### B 1 bright;
			#### C 1 bright;
			#### D 1 bright;
			#### E 1 bright;
			TNT1 A 15;
			#### AAAAAAAAAAAAAAAAAAAAAAAAAAA 1
			{
				A_Refire();
				A_WeaponReady( WRF_NOPRIMARY | WRF_ALLOWRELOAD | WRF_NOBOB );
			}
			COYO FGHI 1 bright
			{
				A_Refire();
				A_WeaponReady( WRF_NOPRIMARY | WRF_ALLOWRELOAD | WRF_NOBOB );
			}
			#### JJKKLLA 1 bright
			{
				A_Refire();
				A_WeaponReady( WRF_NOPRIMARY | WRF_ALLOWRELOAD | WRF_NOBOB );
			}
			#### A 0 A_Refire();
			Goto Ready;
			
		Recoil:
			#### # 0 A_SetPitch( pitch + 2.5, 0 );
			#### # 1 A_SetAngle( angle + 3.5, 0 );
			#### # 0 A_SetPitch( pitch + 1.25, 0 );
			#### # 1 A_SetAngle( angle + 1.75, 0 );
			#### # 0 A_SetPitch( pitch + 0.625, SPF_INTERPOLATE );
			#### # 1 A_SetAngle( angle + 0.875, SPF_INTERPOLATE );
			#### # 0 A_Overlay( -2, "Recoil_Generic" );
			Stop;
		
		Flash1:
			COYF A 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			COYF B 1 bright A_Light(4); 
			COYF C 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		Flash2:
			COYF D 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			COYF E 1 bright A_Light(4); 
			COYF F 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		Flash3:
			COYF G 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			COYF H 1 bright A_Light(4); 
			COYF I 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;

		AltFire:
		UseSpecial:
			#### # 0 A_Overlay( LAYER_FUNC, "ChargeTube" );
			Goto Ready;

		Reload_Start:
			TNT1 A 0;
			#### # 5 A_StartSound( "cyo_reload", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
		
		Reload_Down:
			COYO A 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			Stop;
			
		Reload_Up:
			#### # 0 bright A_StartSound( "cyo_aim", CHAN_WEAPON, CHANF_OVERLAP );
			COYO A 1 bright A_WeaponOffset ( 128, 32 + 256, 0 );
			#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			#### # 0 A_Overlay( LAYER_FUNC, "Reload_Done" );
			#### # 0 A_ReFire;
			Goto Ready;
	}
}

Class K7_Coyote_Enfield2_Ammo: K7_Ammo
{
	Default
	{
		Inventory.MaxAmount 6;
	}
}
