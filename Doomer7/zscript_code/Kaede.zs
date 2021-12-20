Class Hardballer: Weapon{
	default{
		+Weapon.NOAUTOFIRE;
		+Weapon.Ammo_Optional;
		Weapon.AmmoType1 "HardballerLoaded";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "NewClip";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 200;
	    Inventory.PickupSound "weapon/gethar";
		Inventory.Pickupmessage "You got Kaede's Hardballer.";
	}
	
	bool zoomedIn;
	PlayerInfo playerPointer;
	bool staticSound;
		
	States{
	
		Spawn:
		KPIC A -1 bright;
		Loop;
		
		Select:
		TNT1 A 0 bright A_Raise;
		KAED A 1 bright A_WeaponOffset(0,165,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		Goto Ready;
		
		Deselect:
		TNT1 A 0 { invoker.zoomedIn = false; }
        TNT1 A 0 A_ZoomFactor (1);
		KAED A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE); 
		KAED A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,165,WOF_INTERPOLATE);
		
		KeepLowering:
		TNT1 A 0 bright A_Lower;
		Loop;
		
		Ready:
		KAED A 0 A_JumpIf(invoker.zoomedIn, "ReadyZoomed");
		KAED A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
		
		ReadyZoomed:
		TNT1 A 0 {SmithSyndicate(invoker.owner).SetStatic(true);}
		TNT1 A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Goto Ready;
		
		Fire:
		KAED A 0 A_JumpIf (invoker.zoomedIn, "FireZoomed");
		KAED A 0 bright A_JumpIfNoAmmo("Reload");
		KAED A 0 bright A_StartSound("weapon/firehard",CHAN_AUTO,CHANF_OVERLAP);
		KAED A 0 bright A_FireBullets(5.6,0,1,45,"NewBulletPuff");
		KAED B 2 bright{
			int num = Random(0,2);
			if(num == 0){
				A_Overlay(-1,"Flash");
			}else if (num == 1){
				A_Overlay(-1,"Flash2");
			}else{
				A_Overlay(-1,"Flash3");
			}
		}
		KAED B 0 bright A_SetPitch(pitch-1,SPF_INTERPOLATE);
		KAED C 2 bright A_SetPitch(pitch-.75,SPF_INTERPOLATE);
		KAED D 2 bright A_SetPitch(pitch-.25,SPF_INTERPOLATE);
		KAED E 2 bright;
		KAED F 1 bright;
		KAED HJK 2 bright;
		KAED A 1 bright A_ReFire;
		Goto Ready;
			
		FireZoomed:
		TNT1 A 0 A_JumpIfNoAmmo("Reload");
		TNT1 A 0 A_StartSound("weapon/firehard",CHAN_AUTO,CHANF_OVERLAP);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		TNT1 A 0 A_FireBullets(5.6,0,1,45,"NewBulletPuff");
		TNT1 A 2;
		TNT1 A 0 A_SetPitch(pitch-1,SPF_INTERPOLATE);
		TNT1 A 2 A_SetPitch(pitch-.75,SPF_INTERPOLATE);
		TNT1 A 2 A_SetPitch(pitch-.25,SPF_INTERPOLATE);
		TNT1 A 2;
		TNT1 A 1;
		TNT1 A 6;
		TNT1 A 1 A_ReFire;
		Goto Ready;

		Altfire:
		KAED A 0 A_JumpIf(invoker.zoomedIn,"UnZoom");
		TNT1 A 0 A_StartSound("weapon/zoomhard");
		KAED A 0 { invoker.zoomedIn = true; }
		KAED A 0 A_ZoomFactor(3);
		Goto Ready;
		
		UnZoom:
		KAED A 0 { invoker.zoomedIn = false; }
		TNT1 A 0 {SmithSyndicate(invoker.owner).SetStatic(false);}
		TNT1 A 0 A_StopSound(CHAN_5);
		TNT1 A 0 A_ZoomFactor(1);
		Goto Ready;
			
		Reload:
		TNT1 A 0 {SmithSyndicate(invoker.owner).SetStatic(false);}
		TNT1 A 0 A_StopSound(CHAN_5);
		TNT1 A 0 { invoker.zoomedIn = false; }
        TNT1 A 0 A_ZoomFactor (1);
		KAED A 0 A_JumpIfInventory("HardballerLoaded", 10, 2);
		KAED A 0 A_JumpIfInventory("NewClip", 1, "ReloadWork"); 
		KAED A 0;
		Goto Ready;
		
		ReloadWork:
		KAED A 0 bright A_StartSound("weapon/rehard");
		KAED A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE); 
		KAED A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,165,WOF_INTERPOLATE);
		
		ReloadLoop:
		TNT1 A 0 A_TakeInventory("NewClip", 1);
		TNT1 A 0 A_GiveInventory("HardballerLoaded", 1) ;
		TNT1 A 0 A_JumpIfInventory("HardballerLoaded", 10, "ReloadFinish");
		TNT1 A 0 A_JumpIfInventory("NewClip", 1, "ReloadLoop");
		Goto ReloadFinish;
		
		ReloadFinish:
		TNT1 A 104;
		KAED A 1 bright A_WeaponOffset(0,165,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
		KAED A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		Goto Ready;
		
		Flash:
		KAEF A 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		KAEF B 1 bright A_Light(4); 
		KAEF C 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash2:
		KAEF D 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		KAEF E 1 bright A_Light(4); 
		KAEF F 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash3:
		KAEF G 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		KAEF H 1 bright A_Light(4); 
		KAEF I 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
	}
}

Class HardballerLoaded: Ammo{
	default{
		Inventory.MaxAmount 10;
		+INVENTORY.IGNORESKILL;
	}
}