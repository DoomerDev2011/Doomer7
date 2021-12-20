class SmithSyndicate: DoomPlayer{
	default{
		Player.StartItem "PPK";
		Player.StartItem "SniperPistol";
		Player.StartItem "Taurus";
		Player.StartItem "Revolver";
		Player.StartItem "Glock";
		Player.StartItem "Hardballer";
		Player.StartItem "M79";
		Player.StartItem "ThrowingKnife";
		Player.StartItem "TommyGun";
		Player.StartItem "Clip", 100;
		Player.StartItem "NewClip", 100;
		Player.StartItem "PPKLoaded", 5;
		Player.StartItem "NewShell", 100;
		Player.StartItem "TaurusLoaded", 7;
		Player.StartItem "GlockLoaded", 10;
		Player.StartItem "TommyGunLoaded", 50;
		Player.StartItem "RevolverLoaded", 6;
		Player.StartItem "HardballerLoaded", 10;
		Player.StartItem "M79Loaded", 2;
		Player.StartItem "NewRocket", 50;
		Player.WeaponSlot 1, "PPK","SniperPistol";
        Player.WeaponSlot 2, "Taurus";
        Player.WeaponSlot 3, "Hardballer";
        Player.WeaponSlot 4, "ThrowingKnife";
        Player.WeaponSlot 5, "Revolver";
        Player.WeaponSlot 6, "Glock";
		Player.WeaponSlot 7, "M79";
		Player.WeaponSlot 8, "TommyGun";
	}
	
	override void Tick()
    {
        Super.Tick();
        Shader.SetUniform1i(player, "Static", "timer", level.time);//use player directly
    }
	
	void SetStatic(bool on)
	{
		if(IsActorPlayingSound(CHAN_5, "weapon/statichard") == false){
			A_StartSound("weapon/statichard",CHAN_5,CHANF_LOOPING,0.5);//start loopin sound, but only if it is not already playing
        }
		Shader.SetUniform1i(player, "Static", "timer", level.time);
		Shader.SetUniform1i(player, "Static", "resX", Screen.GetWidth() / 8);
		Shader.SetUniform1i(player, "Static", "resY", Screen.GetHeight() / 8);
		Shader.SetEnabled(player,"Static",on);
	}
}

Class NewBulletPuff: BulletPuff{
	default{
		+NOEXTREMEDEATH
	}
}

Class NewClip : Ammo replaces Clip{
	default{
		Inventory.Amount 10; 
		Inventory.MaxAmount 200;
		Ammo.BackpackAmount 30; 
		Ammo.BackpackMaxAmount 300; 
		Inventory.Icon "CLIPA0";
		Inventory.PickupMessage "Picked up some 9mm ammo.";
	}
	States{
		Spawn:
		CLIP A -1;
		Stop;
	}
}

Class NewShell: Ammo{
	default{
		Inventory.Amount 7;
		Inventory.MaxAmount 200;
		Ammo.BackpackAmount 7;
		Ammo.BackPackMaxAmount 100;
		Inventory.Icon "SHELA0";
		Inventory.PickupMessage "Picked up revolver ammo."; 
	}
	States{
		Spawn:
		SHEL A -1;
		Stop;
	}
}

Class NewRocket: Ammo{
	default{
		Inventory.PickupMessage "$GOTROCKET";
		Inventory.Amount 1;
		Inventory.MaxAmount 50;
		Ammo.BackpackAmount 1;
		Ammo.BackpackMaxAmount 100;
		Inventory.Icon "ROCKA0";
	}
	States{
		Spawn:
		ROCK A -1;
		Stop;
	}
}

Class MaskMissile: Rocket{
	default{
		Speed 200;
	}
}