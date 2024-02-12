Class CK7_EmptyPickup : Actor 
{
	Default
	{
		+NOBLOCKMAP
		+NOINTERACTION
	}

	override void PostBeginPlay()
	{
		Destroy();
	}
}

Class CK7_HealthBonus : HealthBonus
{
	override bool TryPickup (in out Actor toucher)
	{
		bool result = Super.TryPickup(toucher);
		if (result)
		{
			EventHandler.SendInterfaceEvent(toucher.PlayerNumber(), String.Format("PlayedPickedUpItem:%s", self.GetClassName()));
		}
		return result;
	}
}