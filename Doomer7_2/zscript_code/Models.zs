

Class GarcianGun: CustomInventory{
	default{
		+SOLID
		+BRIGHT
		+INVENTORY.AUTOACTIVATE;
		Inventory.PickupSound "";
		Inventory.Pickupmessage "You got Garcian's Walther PPK.";
	}
	States{
		Spawn:
		GARP A -1;
		Stop;
		
		Use:
		TNT1 A 0 A_StartSound("weapon/getppk",CHAN_VOICE,CHANF_NOSTOP);
		Stop;
		
		Pickup:
		TNT1 A 0 {
			if (CountInv("K7_PPK") <= 0) {
				GiveInventory("K7_PPK", 1);
				A_SelectWeapon("K7_PPK");
			}
			else{
				GiveInventory("K7_PPK", 1);
			}
		}
		Stop;
	}
}

Class DanGun: CustomInventory{
	default{
		+SOLID
		+BRIGHT
		+INVENTORY.AUTOACTIVATE;
		Inventory.PickupSound "";
		Inventory.Pickupmessage "You got Dan's Taurus.";
	}
	States{
		Spawn:
		DANP A -1;
		Stop;
		
		Use:
		TNT1 A 0 A_StartSound("weapon/gettaurus",CHAN_VOICE,CHANF_NOSTOP);
		Stop;
		
		Pickup:
		TNT1 A 0 {
			if (CountInv("K7_Taurus") <= 0) {
				GiveInventory("K7_Taurus", 1);
				A_SelectWeapon("K7_Taurus");
			}
			else{
				GiveInventory("K7_Taurus", 1);
			}
		}
		Stop;
	}
}

Class CoyoteGun: CustomInventory{
	default{
		+SOLID
		+BRIGHT
		+INVENTORY.AUTOACTIVATE;
		Inventory.PickupSound "";
		Inventory.Pickupmessage "You got Coyote's Revolver.";
	}
	States{
		Spawn:
		COYP A -1;
		Stop;
		
		Use:
		TNT1 A 0 A_StartSound("weapon/getrev",CHAN_VOICE,CHANF_NOSTOP);
		Stop;
		
		Pickup:
		TNT1 A 0 {
			if (CountInv("K7_Enfield2") <= 0) {
				GiveInventory("K7_Enfield2", 1);
				A_SelectWeapon("K7_Enfield2");
			}
			else{
				GiveInventory("K7_Enfield2", 1);
			}
		}
		Stop;
	}
}

Class YoungHarmanGun: CustomInventory{
	default{
		+SOLID
		+BRIGHT
		+INVENTORY.AUTOACTIVATE;
		Inventory.PickupSound "";
		Inventory.Pickupmessage "You got Young Harman's Thompson.";
	}
	States{
		Spawn:
		YHAP A -1;
		Stop;
		
		Use:
		TNT1 A 0 A_StartSound("weapon/gettmg",CHAN_VOICE,CHANF_NOSTOP);
		Stop;
		
		Pickup:
		TNT1 A 0 {
			if (CountInv("K7_TommyGun") <= 0) {
				GiveInventory("K7_TommyGun", 1);
				A_SelectWeapon("K7_TommyGun");
			}
			else{
				GiveInventory("K7_TommyGun", 1);
			}
		}
		Stop;
	}
}

Class KaedeGun: CustomInventory{
	default{
		+SOLID
		+BRIGHT
		+INVENTORY.AUTOACTIVATE;
		Inventory.PickupSound "";
		Inventory.Pickupmessage "You got Kaede's Hardballer.";
	}
	States{
		Spawn:
		KAEP A -1;
		Stop;
		
		Use:
		TNT1 A 0 A_StartSound("weapon/gethar",CHAN_VOICE,CHANF_NOSTOP);
		Stop;
		
		Pickup:
		TNT1 A 0 {
			if (CountInv("K7_Hardballer") <= 0) {
				GiveInventory("K7_Hardballer", 1);
				A_SelectWeapon("K7_Hardballer");
			}
			else{
				GiveInventory("K7_Hardballer", 1);
			}
		}
		Stop;
	}
}

Class MaskGun: CustomInventory{
	default{
		+SOLID
		+BRIGHT
		+INVENTORY.AUTOACTIVATE;
		Inventory.PickupSound "";
		Inventory.Pickupmessage "You got Mask's M79.";
	}
	States{
		Spawn:
		MASP A -1;
		Stop;
		
		Use:
		TNT1 A 0 A_StartSound("weapon/getm79",CHAN_VOICE,CHANF_NOSTOP);
		Stop;
		
		Pickup:
		TNT1 A 0 {
			if (CountInv("K7_M79") <= 0) {
				GiveInventory("K7_M79", 1);
				A_SelectWeapon("K7_M79");
			}
			else{
				GiveInventory("K7_M79", 1);
			}
		}
		Stop;
	}
}

Class ConGun: CustomInventory{
	default{
		+SOLID
		+BRIGHT
		+INVENTORY.AUTOACTIVATE;
		Inventory.PickupSound "";
		Inventory.Pickupmessage "You got Con's Glocks.";
	}
	States{
		Spawn:
		CONP A -1;
		Stop;
		
		Use:
		TNT1 A 0 A_StartSound("weapon/gethar",CHAN_VOICE,CHANF_NOSTOP);
		Stop;
		
		Pickup:
		TNT1 A 0 {
			if (CountInv("K7_Glock") <= 0) {
				GiveInventory("K7_Glock", 1);
				A_SelectWeapon("K7_Glock");
			}
			else{
				GiveInventory("K7_Glock", 1);
			}
		}
		Stop;
	}
}

Class KevinKnife: CustomInventory{
	default{
		+SOLID
		+BRIGHT
		+INVENTORY.AUTOACTIVATE;
		Inventory.PickupSound "";
		Inventory.Pickupmessage "You got Kevin's Throwing Knives.";
	}
	States{
		Spawn:
		KEVP A -1;
		Stop;
		
		Use:
		TNT1 A 0 A_StartSound("weapon/gethar",CHAN_VOICE,CHANF_NOSTOP);
		Stop;
		
		Pickup:
		TNT1 A 0 {
			if (CountInv("K7_ThrowingKnife") <= 0) {
				GiveInventory("K7_ThrowingKnife", 1);
				A_SelectWeapon("K7_ThrowingKnife");
			}
			else{
				GiveInventory("K7_ThrowingKnife", 1);
			}
		}
		Stop;
	}
}
		
	
	