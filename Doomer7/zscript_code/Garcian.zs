Class PPK: Weapon {
	//double test; 
	default{
		+Weapon.Ammo_Optional
		Weapon.AmmoType1 "PPKLoaded";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "NewClip";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 200;
	    Inventory.PickupSound "weapon/getppk";
		Inventory.Pickupmessage "You got Garcian's Walther PPK.";
	}					
	States{
		Spawn:
		GARP A -1 bright;
		Stop;
		
		Select:
		TNT1 A 0 A_Raise;
		FRAM A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
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
		FRAM A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE); 
		#### A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,44,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,52,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,72,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,82,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,92,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
		
		KeepLowering:
		TNT1 A 0 bright A_Lower;
		Loop;
		
		
		Ready:
		FRAM A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
		
		Fire:
		FRAM A 1 bright A_JumpIfNoAmmo("Reload");
		FRAM B 0 bright A_StartSound("weapon/fireppk",CHAN_AUTO,CHANF_OVERLAP);
		FRAM B 0 bright A_FireBullets(5.6, 0, 1, 10, "NewBulletPuff");
		FRAM B 0 bright A_SetPitch(pitch-.5);
		FRAM B 1 bright A_SetPitch(pitch-.38);
		FRAM B 1 bright A_SetPitch(pitch-.13);
		FRAM C 0 bright A_GunFlash;
		FRAM CDE 1 bright;
		FRAM FH 2 bright;
		Goto Ready;
		
		Reload:
		FRAM A 0 A_JumpIfInventory("PPKLoaded", 5, 2);
		FRAM A 0 A_JumpIfInventory("NewClip", 1, "ReloadWork"); 
		FRAM A 0;
		Goto Ready;
		
		ReloadWork:
		/*
		TNT1 A 0{ 
			Vector2 wBob = player.mo.BobWeapon(1);
			invoker.test = wBob.x;
			console.printf("%.2f", invoker.test);
		}
		*/
		FRAM A 0 bright A_StartSound("weapon/reppk");
		FRAM A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE); 
		#### A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,44,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,52,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,72,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,82,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,92,WOF_INTERPOLATE);
		#### A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
		
		ReloadLoop:
		TNT1 A 0 A_TakeInventory("NewClip", 1);
		TNT1 A 0 A_GiveInventory("PPKLoaded", 1) ;
		TNT1 A 0 A_JumpIfInventory("PPKLoaded", 5, "ReloadFinish");
		TNT1 A 0 A_JumpIfInventory("NewClip", 1, "ReloadLoop");
		Goto ReloadFinish; 
		
		ReloadFinish:
		TNT1 A 11; 
		FRAM A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
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

Class PPKLoaded : Ammo{
	default{
		Inventory.MaxAmount 5;
		+INVENTORY.IGNORESKILL
	}
}

