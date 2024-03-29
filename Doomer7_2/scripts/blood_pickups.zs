// Special Ammo
class K7_AmmoBase : Ammo
{
	Default
	{
		gravity 0.5;
		YScale 0.834;
		+BRIGHT
	}

	override bool HandlePickup (Inventory item)
	{
		let ammoitem = Ammo(item);
		if (ammoitem != null && ammoitem.GetParentAmmo() == GetClass())
		{
			if (Amount < MaxAmount || sv_unlimited_pickup)
			{
				EventHandler.SendInterfaceEvent(owner.PlayerNumber(), "K7ShowHudPanel");
			}
		}
		return super.HandlePickup(item);
	}

	override Class<Ammo> GetParentAmmo ()
	{
		class<Object> type = GetClass();

		while (type.GetParentClass() && type.GetParentClass() != "Ammo" && type.GetParentClass() != "K7_AmmoBase")
		{
			type = type.GetParentClass();
		}
		return (class<Ammo>)(type);
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		if (bTossed)
		{
			vel.xy *= 1.5;
			//vel.z *= 1.2;
		}
	}

	override void Tick()
	{
		super.Tick();
		if (!bTOSSED || owner || pos.z <= floorz)
		{
			return;
		}
		FSpawnParticleParams p;
		p.pos = pos + ( frandom[bpart](-4, 4), frandom[bpart](-4, 4), frandom[bpart](-4, 4) );
		p.color1 = color(200,0,0);
		p.flags = SPF_FULLBRIGHT;
		p.startalpha = 1.0;
		p.size = 5;
		p.lifetime = 25;
		p.sizestep = -(p.size / p.lifetime);
		p.vel.z = 0.3;
		Level.SpawnParticle(p);
	}
}

Class CK7_ThinBlood : K7_AmmoBase
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
			BLDV A -1;
			stop;
	}
	
	override bool Use(bool pickup)
		{
			if (owner && owner.GiveBody(10))
			{
				owner.A_StartSound("persona_heal", CHAN_AUTO);
				return true;
			}
			return false;
		}
}


// Upgrade Currency
Class CK7_ThickBlood : K7_AmmoBase
{
	Default
	{
		+INVENTORY.IGNORESKILL
		Inventory.Amount 1;
		Inventory.MaxAmount 1000;
		Inventory.PickupMessage "Picked up some thick blood";
	}
}

