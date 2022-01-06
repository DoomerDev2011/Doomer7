Class K7_Garcian_PPK : K7_SmithSyndicate_Weapon
{
	default
	{
		Weapon.SlotNumber 0;
		Weapon.SelectionOrder 0;
		Weapon.BobSpeed 1.66;
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 0.5;
		
	    Inventory.PickupSound "weapon/getppk";
		Inventory.Pickupmessage "You got Garcian's Walther PPK.";
	}					
	States
	{
		Spawn:
			GARP A -1 bright;
			Stop;
		
		Ready:
			FRAM A 1 bright A_WeaponReady( WRF_ALLOWRELOAD );
			Loop;
		
		Select:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_fnPersonaChangeEnd( 0 ) ) 
				{
					A_SetInventory( "K7_Ammo", smith.m_iPersonaGunClipSize );
					A_SetTics( smith.m_iPersonaFormTime );
				}
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnPersonaChangeReady();
			}
			FRAM A 1 bright A_WeaponOffset ( 128, 32 + 256, 0);
			#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE );
			#### # 0 A_StartSound( "gar_aim", CHAN_BODY, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE);
			Goto Ready;
		
		Fire:
			FRAM A 1 bright A_JumpIfNoAmmo( "Reload" );
			#### B 0 bright A_StartSound( "weapon/fireppk", CHAN_AUTO, CHANF_OVERLAP );
			TNT1 A 0 A_Overlay( -1, "Fire_Bullet" );
			#### A 0 A_Overlay( LAYER_RECOIL, "Recoil_Generic" );
			#### A 0 A_GunFlash();
			FRAM BCDE 1 bright;
			#### FH 2 bright;
			#### A 2 bright;
			#### # 1 bright A_JumpIfNoAmmo( "Ready" );
			TNT1 A 0 A_Refire();
			Goto Ready;

		Reload_Up:
			FRAM A 1 bright A_WeaponOffset ( 128, 32 + 256, 0);
			#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE);
			#### # 0 A_Overlay( LAYER_FUNC, "Reload_Done" );
			#### # 0 A_Refire();
			Goto Ready;

		Reload_Down:
			#### # 0 bright A_StartSound("gar_reload");
			FRAM A 1 bright A_WeaponOffset(0,32,0); 
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE);
			Stop;
		
		Flash: 
			TNT1 A 1 A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			TNT1 A 1 A_Light(4);
			TNT1 A 1 A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
		
	}
}

Class K7_Garcian_PPK_Ammo : K7_Ammo
{
	default
	{
		Inventory.MaxAmount 5;
		+INVENTORY.IGNORESKILL
	}
}

