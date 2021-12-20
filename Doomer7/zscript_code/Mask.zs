Class M79: Weapon {
	default{
		+Weapon.NOAUTOFIRE;
		+Weapon.Ammo_Optional;
		+Weapon.Alt_Uses_Both;
		+WEAPON.ALT_AMMO_OPTIONAL;
		Weapon.SelectionOrder 100; 
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 0; 
		Weapon.AmmoType1 "M79Loaded"; 
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 50;
		Weapon.AmmoType2 "NewRocket";
	    Inventory.PickupSound "weapon/getm79";
		Inventory.Pickupmessage "You got a Mask's M79";
	}
	
	bool singleFire;
	
	States{
		Spawn:
		MPIC A -1 bright;
		Stop;
		
		Select:
		MASK A 1 bright A_WeaponOffset (0,127,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,107,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,87,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,76,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,65,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,53,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,48,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,43,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,38,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		Goto Ready;
		
		Deselect:
		MASK A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,38,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,43,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,48,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,53,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,65,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,76,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,87,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,107,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,127,WOF_INTERPOLATE);
		
		KeepLowering:
		TNT1 A 0 bright A_Lower;
		Loop;
		
		Ready:
		MASK A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
		Loop; 

		
		Fire:
		TNT1 A 0{
			if (invoker.ammo1.amount == 1){
				if (invoker.singleFire == false){
					invoker.singleFire = true;
					return ResolveState("LeftFire");
				}
				else{
					invoker.singleFire = false;
					return ResolveState("RightFire");
				}
				return ResolveState(null);
			}
			return ResolveState(null);
		}
		MASK A 0 bright A_JumpIfNoAmmo("Reload");
		TNT1 A 0 bright A_SetBlend("E6F63F",.25,7);
		MASK A 0 bright A_StartSound("weapon/firem79",CHAN_AUTO,CHANF_OVERLAP);
		MASK A 1 bright {
			A_Overlay(-1,"Flash");
			A_FireProjectile("MaskGrenade",0,1,-10,0);
			A_FireProjectile("MaskGrenade",0,1,10,0);
		}
		MASK C 1 bright A_SetPitch(pitch-3.5,SPF_INTERPOLATE);
		MASK E 1 bright A_SetPitch(pitch-2.75,SPF_INTERPOLATE);
		MASK F 1 bright A_SetPitch(pitch-1.25,SPF_INTERPOLATE);
		MASK GHJKL 1 bright;
		MASK OSTUA 2 bright;
		Goto Ready;
		
		Altfire:
		TNT1 A 0{
			if (invoker.singleFire == false){
				invoker.singleFire = true;
				return ResolveState("LeftFire");
			}
			else{
				invoker.singleFire = false;
				return ResolveState("RightFire");
				
			}
			return ResolveState(null);
		}
		Goto Ready;
		
		LeftFire:
		MASL A 0 bright A_JumpIfNoAmmo("Reload");
		TNT1 A 0 bright A_SetBlend("E6F63F",.25,7);
		MASL A 0 bright A_StartSound("weapon/firem79",CHAN_AUTO,CHANF_OVERLAP);
		MASL A 1 bright{
			A_Overlay(-1,"Flash");
			A_FireProjectile("MaskGrenade",0,1,-10,0);
		}
		MASL C 1 bright A_SetPitch(pitch-3,SPF_INTERPOLATE);
		MASL E 1 bright A_SetPitch(pitch-2.25,SPF_INTERPOLATE);
		MASL F 1 bright A_SetPitch(pitch-.75,SPF_INTERPOLATE);
		MASL GHJKL 1 bright;
		MASL OSTU 2 bright;
		MASK A 2 bright;
		Goto Ready;
		
		RightFire:
		MASR A 0 bright A_JumpIfNoAmmo("Reload");
		TNT1 A 0 bright A_SetBlend("E6F63F",.25,7);
		MASR A 0 bright A_StartSound("weapon/firem79",CHAN_AUTO,CHANF_OVERLAP);
		MASR A 1 bright{
			A_Overlay(-1,"Flash");
			A_FireProjectile("MaskGrenade",0,1,10,0);
		}
		MASR C 1 bright A_SetPitch(pitch-3,SPF_INTERPOLATE);
		MASR E 1 bright A_SetPitch(pitch-2.25,SPF_INTERPOLATE);
		MASR F 1 bright A_SetPitch(pitch-.75,SPF_INTERPOLATE);
		MASR GHJKL 1 bright;
		MASR OSTU 2 bright;
		MASK A 2 bright;
		TNT1 A 0 {invoker.singleFire = true;}
		Goto Ready;
		
		Flash:
		TNT1 A 1 A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		TNT1 A 1 A_Light(4); 
		TNT1 A 1 A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Reload:
		MASK A 0 A_JumpIfInventory("M79Loaded",2,2);
		MASK A 0 A_JumpIfInventory("NewRocket",1,"ReloadWork");
		MASK A 0;
		Goto Ready;
		
		ReloadWork:
		MASK A 0 bright A_StartSound ("weapon/rem79");
		MASK A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,38,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,43,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,48,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,53,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,65,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,76,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,87,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,107,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,127,WOF_INTERPOLATE);
		
		ReloadLoop:
		TNT1 A 0 A_TakeInventory("NewRocket",1);
		TNT1 A 0 A_GiveInventory("M79Loaded",1);
		TNT1 A 0 A_JumpIfInventory("M79Loaded",2,"ReloadFinish");
		TNT1 A 0 A_JumpIfInventory("NewRocket",1,"ReloadLoop");
		Goto ReloadFinish;
		
		ReloadFinish:
		TNT1 A 30;
		MASK A 1 bright A_WeaponOffset (0,127,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,107,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,87,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,76,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,65,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,53,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,48,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,43,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,38,WOF_INTERPOLATE);
		MASK A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		TNT1 A 0 {invoker.singleFire = false;}
		Goto Ready;
		
		
	}
}

Class M79Loaded: Ammo{
	default{
		Inventory.MaxAmount 2;
		+INVENTORY.IGNORESKILL;
	}
}

Class MaskGrenade: Actor{
	default{
		PROJECTILE;
		+HEXENBOUNCE
		-NOGRAVITY
		+EXPLODEONWATER
		Radius 11;
		Height 8;
		Speed 130;
		Damage 15;
		BounceCount 1;
		ReactionTime 139;
		Deathsound "weapon/MaskExplosion";
	}

	States {
		Spawn:
		MGRE A 0 A_CountDown();
		MGRE A 1 A_SpawnProjectile("GrenadePuff", 3, 0, 0, CMF_AIMOFFSET);
		Loop;
		
		Death:
		MISL B 0 Bright A_NoGravity();
		MISL B 0 Bright A_SetTranslucent(0.5, 1);
		MISL B 8 Bright A_Explode;
		MISL C 6 Bright;
		MISL D 4 BRIGHT;
		Stop;
	}
}

Class GrenadePuff : BulletPuff{
	default{
		+ClientSideOnly
	}

	States{
		Spawn:
		PUFF ABCD 4;
		Stop;
	}
}


