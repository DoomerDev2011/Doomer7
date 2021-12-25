Class K7_Garcian_PPK: K7_SmithSyndicate_Weapon
{
	default
	{
		+WEAPON.NOALERT
		Weapon.SlotNumber 0;
		Weapon.SelectionOrder 0;
		Weapon.AmmoType1 "K7_Garcian_PPK_Ammo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoType2 "K7_ThinBlood";
	    Inventory.PickupSound "weapon/getppk";
		Inventory.Pickupmessage "You got Garcian's Walther PPK.";
	}					
	States
	{
		Spawn:
			GARP A -1 bright;
			Stop;
		
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
			FRAM A 1 bright A_WeaponOffset(0,105,0);
			#### A 1 bright A_WeaponOffset(0,92,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,82,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,72,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,62,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,52,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,44,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready;
		
		Deselect:
			TNT1 A 0 A_Overlay( -1, "ChangePersona" );
			FRAM A 1 bright A_WeaponOffset(0,32,0); 
			#### A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,44,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,52,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,72,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,82,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,92,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
			Stop;
			
		KeepLowering:
			TNT1 A 0 bright A_Lower;
			Loop;
		
		
		Ready:
			FRAM A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
			Loop;
		
		Fire:
			FRAM A 1 bright A_JumpIfNoAmmo("Reload");
			FRAM B 0 bright A_StartSound("weapon/fireppk",CHAN_AUTO,CHANF_OVERLAP);
			FRAM B 0 bright A_FireBullets( 0, 0, 1, SmithSyndicate( invoker.owner ).m_iPersonaGunDamage, "NewBulletPuff" );
			FRAM B 0 bright A_SetPitch(pitch-.6);
			FRAM B 1 bright A_SetPitch(pitch-.3);
			FRAM B 1 bright A_SetPitch(pitch-.15);
			FRAM C 0 bright A_GunFlash;
			FRAM CDE 1 bright;
			FRAM FH 2 bright;
			FRAM A 2 bright;
			FRAM A 1 bright A_ReFire;
			Goto Ready;
		
		Reload:
			FRAM A 0 bright A_StartSound("weapon/reppk");
			FRAM A 1 bright A_WeaponOffset(0,32,0); 
			#### A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,44,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,52,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,72,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,82,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,92,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
			TNT1 A 0 A_SetInventory( "K7_Garcian_PPK_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaGunClipSize );
			TNT1 A 10; 
			FRAM A 1 bright A_WeaponOffset(0,105,0);
			#### A 1 bright A_WeaponOffset(0,92,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,82,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,72,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,62,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,52,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,44,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			#### A 1 bright A_ReFire;
			Goto Ready;
		
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

