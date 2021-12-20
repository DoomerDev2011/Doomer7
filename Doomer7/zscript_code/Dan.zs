Class Taurus: Weapon{
	default{
		+Weapon.Ammo_Optional
		Weapon.AmmoType1 "TaurusLoaded";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "NewShell";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 200;
	    Inventory.PickupSound "weapon/gettaurus";
		Inventory.Pickupmessage "You got Dan's Taurus."; 
	}											  											  
	States{
		Spawn:
		DHED A -1 bright;
		Stop;
		
		
		Select:
		TNT1 A 0 A_Raise;
		DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		Goto Ready;
		
		
		Deselect:
		DANF A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
		
		KeepLowering:
		TNT1 A 0 bright A_Lower;
		Loop;
		
		
		Ready:
		DANF A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
		
		//Function that is executed when the player fires off Dan's Weapon
		Fire:
		DANF A 0 bright A_JumpIfNoAmmo("Reload");
		DANF B 0 bright A_FireBullets(5.6,0,1,50,"NewBulletPuff");
		DANF B 0 bright A_StartSound("weapon/firetaurus",CHAN_AUTO,CHANF_OVERLAP);
		DANF B 0 bright A_SetPitch(pitch-1.5,SPF_INTERPOLATE);
		DANF B 1 bright;
		DANF C 1 bright{
			int num = Random(0,2);
			if(num == 0){
				A_Overlay(-1,"Flash2");
			}else if (num == 1){
				A_Overlay(-1,"Flash2");
			}else{
				A_Overlay(-1,"Flash2");
			}
		}
		DANF C 0 bright A_SetPitch(pitch-1.25,SPF_INTERPOLATE);
		DANF D 1 bright A_SetPitch(pitch-.75,SPF_INTERPOLATE);
		DANF EF 1 bright;
		DANF GIMOQSUWZ 2 bright; 
		Goto Ready;
		
		//Function that, once called, will play the first flash animation
		Flash:
		DFLA A 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		DFLA B 1 bright A_Light(4); 
		DFLA C 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash2:
		DFLA D 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		DFLA E 1 bright A_Light(4);
		DFLA F 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash3:
		DFLA G 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		DFLA H 1 bright A_Light(4); 
		DFLA I 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Reload:
		DANF A 0 A_JumpIfInventory("TaurusLoaded", 7, 2);
		DANF A 0 A_JumpIfInventory("NewShell", 1, "ReloadWork"); 
		DANF A 0;
		Goto Ready;
		
		//Function that is called when the reload button is pressed
		//or the player runs out of ammo in their current clip
		ReloadWork:
		DANF A 0 bright A_StartSound("weapon/retaurus");
		DANF A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
		
		//Function that reloads the Taurus with ammo for their
		//new clip that is taken from the NewShell ammo pool
		ReloadLoop:
		TNT1 A 0 A_TakeInventory("NewShell", 1);
		TNT1 A 0 A_GiveInventory("TaurusLoaded", 1) ;
		TNT1 A 0 A_JumpIfInventory("TaurusLoaded", 7, "ReloadFinish");
		TNT1 A 0 A_JumpIfInventory("NewShell", 1, "ReloadLoop");
		Goto ReloadFinish;
		
		//Function that is called when the reload process is complete
		ReloadFinish:
		TNT1 A 39;
		DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		Goto Ready;
	}
}

Class TaurusLoaded: Ammo{
	default{
		Inventory.MaxAmount 7;
		+INVENTORY.IGNORESKILL;
	}
}