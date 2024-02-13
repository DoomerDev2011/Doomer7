// Special Ammo
class K7_AmmoBase : Ammo
{
	Default
	{
		gravity 0.5;
		YScale 0.834;
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
			vel.xy *= 1.2;
			//vel.z *= 1.2;
		}
	}

	override void Tick()
	{
		super.Tick();
		if (owner || pos.z <= floorz)
		{
			return;
		}
		FSpawnParticleParams p;
		p.pos = pos + ( frandom[bpart](-4, 4), frandom[bpart](-4, 4), frandom[bpart](-4, 4) );
		p.color1 = color(200,0,0);
		p.flags = SPF_FULLBRIGHT;
		p.size = 3;
		p.lifetime = 20;
		p.startalpha = 1.0;
		p.fadestep = -1;
		p.vel = ( frandom[bpart](-2, 2), frandom[bpart](-2, 2), frandom[bpart](-2, 2) );
		p.accel = p.vel * -0.05;
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
			BLDV A 1;
			Loop;
		
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