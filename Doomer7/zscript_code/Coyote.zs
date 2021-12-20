Class Revolver: Weapon{
	default{
		+Weapon.NOAUTOFIRE;
		+Weapon.Ammo_Optional;
		+Weapon.Alt_Uses_Both;
		+WEAPON.ALT_AMMO_OPTIONAL;
		Weapon.AmmoType1 "RevolverLoaded";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "NewShell";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 200;
	    Inventory.PickupSound "weapon/getrev";
		Inventory.Pickupmessage "You got Coyote's Revolver."; 
	}
	
	/*
	void BurstFire(){
		for(int counter = 0; counter<= 2; counter++){
			COYO A 0 bright A_JumpIfNoAmmo("Reload");
			COYO A 0 bright A_StartSound("weapon/firerev",CHAN_AUTO,CHANF_OVERLAP);
			COYO A 0 bright A_FireBullets(5.6,0,1,40,"NewBulletPuff");
			COYO B 1 bright{
				int num = Random(0,2);
				if(num == 0){
					A_Overlay(-1,"Flash");
				}else if (num == 1){
					A_Overlay(-1,"Flash2");
				}else{
					A_Overlay(-1,"Flash3");
				}
			}
			COYO B 0 bright A_SetPitch(pitch+1,SPF_INTERPOLATE);
			COYO C 1 bright A_SetPitch(pitch+.75,SPF_INTERPOLATE);
			COYO D 1 bright A_SetPitch(pitch+.25,SPF_INTERPOLATE);
			COYO E 1 bright;
		}
	}
	*/
	int counter;
		
	States{
		Spawn:
		COYH A -1 bright;
		Loop;
		
		Select:
		TNT1 A 0 A_Raise;
		COYO A 1 bright A_WeaponOffset (180,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (150,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (90,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (50,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		Goto Ready;
		
		Deselect: 
		COYO A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (50,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (90,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (150,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (180,32,WOF_INTERPOLATE);
		
		KeepLowering:
		TNT1 A 0 A_Lower;
		Loop;
		
		
		Ready:
		COYO A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
		
		Fire:
		COYO A 0 bright A_JumpIfNoAmmo("Reload");
		COYO A 0 bright A_StartSound("weapon/firerev",CHAN_AUTO,CHANF_OVERLAP);
		COYO A 0 bright A_FireBullets(5.6,0,1,40,"NewBulletPuff");
		COYO B 1 bright{
			int num = Random(0,2);
			if(num == 0){
				A_Overlay(-1,"Flash");
			}else if (num == 1){
				A_Overlay(-1,"Flash2");
			}else{
				A_Overlay(-1,"Flash3");
			}
		}
		COYO B 0 bright A_SetPitch(pitch+1,SPF_INTERPOLATE);
		COYO C 1 bright A_SetPitch(pitch+.75,SPF_INTERPOLATE);
		COYO D 1 bright A_SetPitch(pitch+.25,SPF_INTERPOLATE);
		COYO E 1 bright;
		TNT1 A 6;
		COYO FGHI 1 bright;
		COYO JKL 2 bright;
		COYO A 1 bright A_ReFire;
		Goto Ready;

		Altfire:
		TNT1 A 0 {
			if (invoker.ammo1.amount == 0){
				return ResolveState("Reload");
			}else if (invoker.ammo1.amount < 3){
				return ResolveState("Ready");
			}
			return ResolveState(null);
		}
		COYO A 0 bright A_JumpIfNoAmmo("Reload");
		COYO A 0 bright A_StartSound("weapon/firerevcharge",CHAN_AUTO,CHANF_OVERLAP);
		COYO A 0 bright A_FireBullets(5.6,0,1,100,"NewBulletPuff");
		COYO A 0 bright {
			invoker.DepleteAmmo(false, true, invoker.ammouse1);
			invoker.DepleteAmmo(false, true, invoker.ammouse1);
		}
		COYO B 1 bright{
			int num = Random(0,2);
			if(num == 0){
				A_Overlay(-1,"Flash");
			}else if (num == 1){
				A_Overlay(-1,"Flash2");
			}else{
				A_Overlay(-1,"Flash3");
			}
		}
		COYO B 0 bright A_SetPitch(pitch+3,SPF_INTERPOLATE);
		COYO C 1 bright A_SetPitch(pitch+2.25,SPF_INTERPOLATE);
		COYO D 1 bright A_SetPitch(pitch+.75,SPF_INTERPOLATE);
		COYO E 1 bright;
		TNT1 A 30;
		COYO FGHI 1 bright;
		COYO JKL 2 bright;
		COYO A 1 bright A_ReFire;
        Goto Ready;
			
		Flash:
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
		
		
		Reload:
		COYO A 0 A_JumpIfInventory("RevolverLoaded", 6, 2);
		COYO A 0 A_JumpIfInventory("NewShell", 1, "ReloadWork"); 
		COYO A 0;
		Goto Ready;
		
		ReloadWork:
		COYO A 0 bright A_StartSound("weapon/rerev");
		COYO A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (50,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (90,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (150,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (180,32,WOF_INTERPOLATE);
		
		ReloadLoop:
		TNT1 A 0 A_TakeInventory("NewShell", 1);
		TNT1 A 0 A_GiveInventory("RevolverLoaded", 1) ;
		TNT1 A 0 A_JumpIfInventory("RevolverLoaded", 6, "ReloadFinish");
		TNT1 A 0 A_JumpIfInventory("NewShell", 1, "ReloadLoop");
		Goto ReloadFinish;
		
		ReloadFinish:
		TNT1 A 13;
		COYO A 1 bright A_WeaponOffset (180,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (150,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (90,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (50,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		Goto Ready;
		
		
	}
}

Class RevolverLoaded: Ammo{
	default{
		Inventory.MaxAmount 6;
		+INVENTORY.IGNORESKILL;
	}
}
