Class K7_ThinBlood : Ammo
{
	Default
	{
		+INVENTORY.IGNORESKILL
		Inventory.Amount 1;
		Inventory.MaxAmount 20;
		Inventory.PickupMessage "Picked up some thin blood";
		//Inventory.PickupSound "";
	}
	States
	{
		Spawn:
			BLDV A 1;
			Loop;
	}
}

Class K7_ThickBlood : Ammo
{
	Default
	{
		+INVENTORY.IGNORESKILL
		Inventory.Amount 1;
		Inventory.MaxAmount 1000;
		Inventory.PickupMessage "Picked up some thick blood";
		//Inventory.PickupSound "";
	}
}