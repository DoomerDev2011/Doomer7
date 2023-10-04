// Special Ammo
Class CK7_ThinBlood : Ammo
{
	Default
	{
		+INVENTORY.IGNORESKILL
		Inventory.Amount 1;
		Inventory.MaxAmount 20;
		Inventory.PickupMessage "Picked up some thin blood";
		Inventory.PickupSound "pickup_blood";
	}
	
	
	
	States
	{
		Spawn:
			BLDV A 1;
			Loop;
		
	}
}
// Upgrade Currency
Class CK7_ThickBlood : Ammo
{
	Default
	{
		+INVENTORY.IGNORESKILL
		Inventory.Amount 1;
		Inventory.MaxAmount 1000;
		Inventory.PickupMessage "Picked up some thick blood";
	}
}