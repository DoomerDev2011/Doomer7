Class EmptyPickup : Actor {}


Class ClipReplacer: EmptyPickup replaces Clip {
}

Class ClipBoxReplacer: EmptyPickup replaces ClipBox {
}

Class ShellReplacer: EmptyPickup replaces Shell {
}

Class ShellBoxReplacer: EmptyPickup replaces ShellBox {
}

Class CellReplacer: EmptyPickup replaces Cell {
}

Class CellPackReplacer: EmptyPickup replaces Cellpack {
}

Class RocketAmmoReplacer: EmptyPickup replaces RocketAmmo {
}

Class RocketBoxReplacer: EmptyPickup replaces RocketBox {
}

Class BackpackReplacer: Megasphere replaces Backpack {
}

Class ChainsawReplacer: Medikit replaces Chainsaw {
}

Class PistolReplacer: HealthBonus replaces Pistol {
}

Class ShotgunReplacer: HealthBonus replaces Shotgun {
}

Class SuperShotgunReplacer: Medikit replaces SuperShotgun {
}

Class ChaingunReplacer: HealthBonus replaces Chaingun {
}

Class RocketLauncherReplacer: Medikit replaces RocketLauncher {
}

Class PlasmaRifleReplacer: Medikit replaces PlasmaRifle {
}

Class BFGReplacer: SoulSphere replaces BFG9000 {
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