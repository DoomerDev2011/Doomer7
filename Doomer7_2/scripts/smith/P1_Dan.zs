// Taurus weapon
//

Class K7_Dan_Taurus : K7_SmithSyndicate_Weapon
{
	default
	{
		Weapon.SlotNumber 1;
		Weapon.BobSpeed -1.5;
		Weapon.BobStyle "InverseAlpha";
		Weapon.BobRangeX 0.33;
		Weapon.BobRangeY 1.5;
		
	    Inventory.PickupSound "weapon/getdan";
		Inventory.Pickupmessage "You got Dan's Taurus.";
	}
	
	bool ChargeSoundStart;
	
	States{
		Spawn:
			DHED A -1 bright;
			Stop;
		
		// Raise weapon
		// Bring the weapon up
		
		Select:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_fnPersonaChangeEnd( 1 ) ) 
				{
					A_SetInventory( "K7_Ammo", smith.m_iPersonaGunClipSize );
					A_SetTics( smith.m_iPersonaFormTime );
				}
			}
			DANF # 0
			{
				SmithSyndicate( invoker.owner ).m_fnPersonaChangeReady();
			}
			#### # 0 A_StartSound( "dan_aim", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_WeaponOffset( 100, 0, 0 );
			#### # 1 bright A_WeaponOffset( 66, 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset( 33, 22, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset( 0, 28, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset( -8, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset( 0, 32, WOF_INTERPOLATE);
			Goto Ready;
		
		// Lower weapon
		// Put the weapon down
		
		Ready:
			DANF A 1 bright A_WeaponReady( WRF_ALLOWRELOAD );
			Loop;
		
		// Primary Fire
		// Shoot the gun
		Fire:
			DANF A 0
			{
				if ( SmithSyndicate( invoker.owner ).m_iPersonaGunCharge > 2 )
				{
					return ResolveState( "SpecialFire" );
				}
				return ResolveState( null );
			}
			#### # 0
			{
				if ( invoker.ammo1.amount < 1 )
				{
					return ResolveState( "Reload" );
				}
				return ResolveState( null );
			}
			#### # 0 A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			#### # 0 A_Overlay( LAYER_FUNC, "Fire_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil_Generic" );
			#### # 0 A_StartSound( "dan_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0
			{
				int num = Random( 0,2 );
				if ( num == 0 )
				{
					A_Overlay( -1, "Flash1" );
				}
				else if ( num == 1 )
				{
					A_Overlay( -1, "Flash2" );
				}
				else
				{
					A_Overlay( -1, "Flash3" );
				}
			}
			#### B 1 bright A_SetPitch( pitch - 3, 0 ); 
			#### F 1 bright A_SetPitch( pitch - 1.5, 0 ); 
			#### GIMOQSUWZ 2 bright; 
			#### A 0 bright;
			#### # 0 bright A_JumpIfNoAmmo( "Ready" );
			#### # 0 A_Refire();
			Goto Ready;

		AltFire:
		UseSpecial:
			#### # 0 A_Overlay( LAYER_FUNC, "ChargeTube" );
			Goto Ready;

		// COlAORAL SHOT
		//
		
		SpecialFire:
			DANF A 0 A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			#### A 0 bright A_StopSound( CHAN_5 );
			#### A 0 bright A_TakeInventory( "K7_ThinBlood", 3 );
			#### A 0
			{
				SmithSyndicate( invoker.owner ).m_iPersonaGunCharge = 0;
			}
			#### A 0 A_StartSound( "dan_special", CHAN_WEAPON, CHANF_OVERLAP );
			#### A 0 A_StartSound( "dan_special_vo", CHAN_VOICE );
			#### A 0 bright A_FireProjectile( "K7_Dan_CollateralShot", 0, false, 0, 0 );
			#### # 0 A_AlertMonsters();
			#### A 0 A_Overlay( -1, "Flash" );
			#### B 1 bright;
			#### C 1 bright;
			#### CDEF 1 bright;
			#### GHIJ 2 bright;
			#### KLMN 3 bright;
			#### QSUW 4 bright;
			#### Z 3 bright;
			Goto Ready;
		
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
		
		
		Reload_Start:
			#### # 0;
			#### # 0 A_StartSound( "dan_reload", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
		
		Reload_Down:
			DANF A 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( -2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( -4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( -8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( -16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( -32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( -64, 32 + 128, WOF_INTERPOLATE);
			Stop;
		
		Reload_Up:
			DANF # 1 bright A_WeaponOffset ( -64, 32 + 128, 0);
			#### # 1 bright A_WeaponOffset ( -32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE);
			
			#### # 0 bright A_Refire();
			Goto Ready;
	}
}

Class K7_Dan_Taurus_Ammo : K7_Ammo
{
	Default
	{
		Inventory.MaxAmount 6;
		+INVENTORY.IGNORESKILL;
	}
}

// DemonGun
//

Class K7_Dan_DemonGun : K7_Dan_Taurus
{
	Default
	{
		Weapon.SlotNumber 1;
		Weapon.AmmoType1 "K7_Dan_DemonGun_Ammo";
	    Inventory.PickupSound "weapon/getdan";
		Inventory.Pickupmessage "You got Dan's Taurus.";
	}
}

Class K7_Dan_DemonGun_Ammo : K7_Dan_Taurus_Ammo
{
	Default
	{
		Inventory.MaxAmount 12;
	}
}

// Collateral Shot Projectile
// 

Class K7_Dan_CollateralShot : PlasmaBall
{
	Default
	{
		Radius 11;
		Height 8;
		Speed 20;
		DamageFunction (450);
		Projectile;
		-RANDOMIZE
		-DEHEXPLOSION
		-ROCKETTRAIL
		+NODAMAGETHRUST
		+FORCEPAIN
		RenderStyle "Add";
		Alpha 1;
		SeeSound "";
		DeathSound "dan_special_explode";
	}
	
	States {
		Spawn:
		P1CS A -1 bright;
		Loop;
		
		Death:
		Stop;
	}
}
