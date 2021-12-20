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
			if (CountInv("PPK") <= 0) {
				GiveInventory("PPK", 1);
				A_SelectWeapon("PPK");
			}
			else{
				GiveInventory("PPK", 1);
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
			if (CountInv("Taurus") <= 0) {
				GiveInventory("Taurus", 1);
				A_SelectWeapon("Taurus");
			}
			else{
				GiveInventory("Taurus", 1);
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
			if (CountInv("Revolver") <= 0) {
				GiveInventory("Revolver", 1);
				A_SelectWeapon("Revolver");
			}
			else{
				GiveInventory("Revolver", 1);
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
			if (CountInv("TommyGun") <= 0) {
				GiveInventory("TommyGun", 1);
				A_SelectWeapon("TommyGun");
			}
			else{
				GiveInventory("TommyGun", 1);
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
			if (CountInv("Hardballer") <= 0) {
				GiveInventory("Hardballer", 1);
				A_SelectWeapon("Hardballer");
			}
			else{
				GiveInventory("Hardballer", 1);
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
			if (CountInv("M79") <= 0) {
				GiveInventory("M79", 1);
				A_SelectWeapon("M79");
			}
			else{
				GiveInventory("M79", 1);
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
			if (CountInv("Glock") <= 0) {
				GiveInventory("Glock", 1);
				A_SelectWeapon("Glock");
			}
			else{
				GiveInventory("Glock", 1);
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
			if (CountInv("ThrowingKnife") <= 0) {
				GiveInventory("ThrowingKnife", 1);
				A_SelectWeapon("ThrowingKnife");
			}
			else{
				GiveInventory("ThrowingKnife", 1);
			}
		}
		Stop;
	}
}
		
	
	