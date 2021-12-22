Class K7_Taurus: Weapon
{
	default
	{
		+Weapon.Ammo_Optional
		Weapon.AmmoType1 "K7_TaurusAmmo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 6;
		Weapon.AmmoType2 "";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
	    Inventory.PickupSound "weapon/gettaurus";
		Inventory.Pickupmessage "You got Dan's Taurus.";
	}
	
	
	
	States{
		Spawn:
		DHED A -1 bright;
		Stop;
		
		Select:
		TNT1 A 0 A_Raise;
		DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		Goto Ready;
		
		Deselect:
		DANF A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
		
		KeepLowering:
		TNT1 A 0 bright A_Lower;
		Loop;
		
		Ready:
		DANF A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
		
		//Function that is executed when the player fires off Dan's Weapon
		Fire:
		//TNT1 A 0 bright A_JumpIfNoAmmo( "Reload" );
		TNT1 A 0 bright
		{
			if (invoker.ammo1.amount < 1){
				return ResolveState( "Reload" );
			}
			return ResolveState( null );
		}
		TNT1 A 0 bright A_FireBullets( 5.6, 0, 1, 50, "NewBulletPuff");
		TNT1 A 0 bright A_StartSound( "weapon/firetaurus", CHAN_AUTO,CHANF_OVERLAP );
		TNT1 A 0 bright A_SetPitch(pitch-1.5,SPF_INTERPOLATE);
		DANF B 1 bright;
		DANF C 1 bright
		{
			int num = Random( 0, 2 );
			if(num == 0){
				A_Overlay( -1, "Flash1" );
			}
			else if (num == 1){
				A_Overlay( -1, "Flash2" );
			}
			else {
				A_Overlay( -1, "Flash3" );
			}
		}
		DANF C 0 bright A_SetPitch( pitch - 1.25, SPF_INTERPOLATE );
		DANF D 1 bright A_SetPitch( pitch - 0.75, SPF_INTERPOLATE );
		DANF EF 1 bright;
		DANF GIMOQSUWZ 2 bright; 
		Goto Ready;
		
		// COlAORAL SHOT
		//
		
		AltFire:
		TNT1 A 0
		{
			if ( invoker.ammo1.amount < 4 ){
				return ResolveState( "Ready" );
			}
			return ResolveState( null );
		}
		TNT1 A 0 bright A_TakeInventory( "K7_TaurusAmmo", 4 );
		TNT1 A 0 A_StartSound( "grunt/danspecial", CHAN_VOICE, 0 );
SNDI		TNT1 A 0 bright A_FireProjectile( "K7_CollateralShot", 0, 1, 0, 0 );
		TNT1 A 0 bright A_SetPitch( pitch - 1.5, SPF_INTERPOLATE );
		TNT1 A 0
		{
			int num = Random( 0, 2 );
			if(num == 0){
				A_Overlay( -1, "Flash1" );
			}
			else if (num == 1){
				A_Overlay( -1, "Flash2" );
			}
			else {
				A_Overlay( -1, "Flash3" );
			}
		}
		DANF B 1 bright;
		DANF C 1 bright;
		DANF CDEF 2 bright;
		DANF GHIJ 2 bright;
		DANF KLMN 2 bright;
		DANF QSUW 2 bright;
		DANF Z 1 bright; 
		Goto Ready;
		
		//Function that, once called, will play the first flash animation
		Flash1:
		DFLA A 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		DFLA B 1 bright A_Light(4); 
		DFLA C 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash2:
		DFLA D 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		DFLA E 1 bright A_Light(4);
		DFLA F 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash3:
		DFLA G 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		DFLA H 1 bright A_Light(4); 
		DFLA I 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		// Always reload a full clip when R is pressed
		// regardless of current ammo and ammo pool
		
		Reload:
		DANF A 0 bright A_StartSound("weapon/retaurus");
		DANF A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
		TNT1 A 0 A_SetInventory( "K7_TaurusAmmo", 6 );
		Goto ReloadFinish;
		
		//Function that is called when the reload process is complete
		ReloadFinish:
		TNT1 A 39;
		DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
		DANF A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
		Goto Ready;
	}
}

Class K7_TaurusAmmo: Ammo
{
	default
	{
		Inventory.MaxAmount 6;
		+INVENTORY.IGNORESKILL;
	}
}

Class K7_CollateralShot: PlasmaBall
{
	Default
	{
		Radius 16;
		Height 8;
		Speed 14;
		Damage 200;
		Projectile;
		-RANDOMIZE
		-DEHEXPLOSION
		-ROCKETTRAIL
		RenderStyle "Add";
		SeeSound "weapon/danspecial";
	}
	
	States {
		Spawn:
		P1CS A -1 bright;
		Loop;
		
		Death:
		Stop;
	}
}
