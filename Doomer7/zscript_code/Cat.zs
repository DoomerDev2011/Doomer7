Class Glock: Weapon{
	default{
		+Weapon.NOAUTOFIRE;
		+Weapon.Ammo_Optional
		Weapon.AmmoType1 "GlockLoaded";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "NewClip";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 200;
	    Inventory.PickupSound "weapon/getglk";
		Inventory.Pickupmessage "You got Con's Glocks."; 
	}
	
	bool isRunning;
	int cooldown;
	
	override void DoEffect()
    {
      super.DoEffect();
      if (cooldown > 0 && level.time % 35 == 0) 
          cooldown--;
    }
	
	States{
		Spawn:
		CHED A -1 bright;
		Loop;
		
		Select:
		CONS A 1 bright A_WeaponOffset (140,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (100,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (85,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (55,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (40,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (5,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		Goto Ready;
		
		Deselect: 
		CONS A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (5,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (40,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (55,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (85,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (100,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (140,32,WOF_INTERPOLATE);
		CONS A 0 A_WeaponOffset (0,-50);
		
		KeepLowering:
		TNT1 A 0 A_Lower;
		Loop;
		
		Ready:
		CONS A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
		
		Fire:
		CONS A 0 bright A_JumpIfNoAmmo("Reload");
		CONS A 0 bright A_FireBullets(5.6,0,1,10,"NewBulletPuff");
		CONS A 0 bright A_StartSound("weapon/fireglk",CHAN_AUTO,CHANF_OVERLAP);
		CONS B 1 bright{
			int num = Random(0,2);
			if(num == 0){
				A_Overlay(-1,"Flash");
			}else if (num == 1){
				A_Overlay(-1,"Flash2");
			}else{
				A_Overlay(-1,"Flash3");
			}
			int randomPitch = random(1,2);
			A_SetPitch(pitch+randomPitch,SPF_INTERPOLATE);
		}
		CONS C 1 bright;
		CONS F 0 bright A_CheckReload;
		CONS F 2 bright{
			int num = Random(0,2);
			if(num == 0){
				A_Overlay(-1,"BottomFlash");
			}else if (num == 1){
				A_Overlay(-1,"BottomFlash2");
			}else{
				A_Overlay(-1,"BottomFlash3");
			}
			int randomPitch = random(1,2);
			A_SetPitch(pitch-randomPitch,SPF_INTERPOLATE);
		}
		CONS F 0 bright A_FireBullets(5.6,0,1,10,"NewBulletPuff");
		CONS F 0 bright A_StartSound("weapon/fireglk",CHAN_AUTO,CHANF_OVERLAP);
		CONS GHI 1 bright;
		CONS KLMO 1 bright;
		CONS RST 1 bright;
		CONS A 1 bright A_ReFire;
		Goto Ready;
		
		Altfire:
		TNT1 A 0{
			if(invoker.cooldown > 0){
				return ResolveState("Ready");
			}
			invoker.isRunning = true;
			invoker.cooldown = 30;
			return ResolveState(null);
		}
		CONS A 0 A_GiveInventory("ConSpeed",1);
		Goto Ready;
		
		Flash:
		CONF A 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,7);
		CONF B 1 bright A_Light(4);
		CONF C 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash2:
		CONF D 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,7);
		CONF E 1 bright A_Light(4);
		CONF F 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash3:
		CONF G 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,7);
		CONF H 1 bright A_Light(4);
		CONF I 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		BottomFlash:
		CONF J 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,7);
		CONF K 1 bright A_Light(4);
		CONF L 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		BottomFlash2:
		CONF M 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,7);
		CONF N 1 bright A_Light(4);
		CONF O 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		BottomFlash3:
		CONF P 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,7);
		CONF Q 1 bright A_Light(4);
		CONF R 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		
		Reload:
		CONS A 0 A_JumpIfInventory("GlockLoaded", 10, 2);
		CONS A 0 A_JumpIfInventory("NewClip", 1, "ReloadWork"); 
		CONS A 0;
		Goto Ready;
		
		ReloadWork:
		CONS A 0 bright A_StartSound("weapon/reglk");
		CONS A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (5,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (40,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (55,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (85,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (100,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (140,32,WOF_INTERPOLATE);
		
		ReloadLoop:
		TNT1 A 0 A_TakeInventory("NewClip", 1);
		TNT1 A 0 A_GiveInventory("GlockLoaded", 1) ;
		TNT1 A 0 A_JumpIfInventory("GlockLoaded", 10, "ReloadFinish");
		TNT1 A 0 A_JumpIfInventory("NewClip", 1, "ReloadLoop");
		Goto ReloadFinish;
		
		ReloadFinish:
		TNT1 A 18;
		CONS A 1 bright A_WeaponOffset (140,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (100,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (85,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (55,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (40,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (5,32,WOF_INTERPOLATE);
		CONS A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		Goto Ready;
	}
}

Class GlockLoaded: Ammo{
	default{
		Inventory.MaxAmount 10;
		+INVENTORY.IGNORESKILL;
	}
}

Class ConSpeed: PowerSpeed{
	default{
		Speed 2.5;
		Powerup.Duration -10;
		inventory.maxamount 1;
	}
}