// Taurus weapon
//

Class K7_Dan_Taurus : K7_SmithSyndicate_Weapon
{
	default
	{
		Weapon.SlotNumber 1;
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
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnPersonaChangeReady();
			}
			TNT1 A 0 A_StartSound( "dan_aim", CHAN_WEAPON, CHANF_OVERLAP );
			DANF A 1 bright A_WeaponOffset( 100, 0, 0 );
			DANF A 1 bright A_WeaponOffset( 66, 16, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 33, 22, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 0, 28, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( -8, 32 + 8, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 0, 32, WOF_INTERPOLATE);
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
				if ( SmithSyndicate( invoker.owner ).m_iPersonaCharge > 2 )
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
			#### # 0 A_Overlay( -1, "Fire_Bullet" );
			#### # 0 A_Overlay( -2, "Recoil_Generic" );
			#### # 0 bright A_StartSound( "dan_shoot", CHAN_WEAPON, CHANF_OVERLAP );
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
			#### B 1 bright A_SetPitch( pitch - 3, SPF_INTERPOLATE ); 
			#### C 1 bright A_SetPitch( pitch - 1.5, SPF_INTERPOLATE );
			#### D 1 bright A_SetPitch( pitch - 0.75, SPF_INTERPOLATE );
			#### E 1 bright A_SetPitch( pitch - 0.25, SPF_INTERPOLATE );
			#### F 1 bright;
			#### GIMOQSUWZ 2 bright; 
			#### A 0 bright;
			#### # 0 bright A_JumpIfNoAmmo( "Ready" );
			#### # 0 A_Refire();
			Goto Ready;
		
		// COlAORAL SHOT
		//
		
		AltFire:
		UseSpecial:
			TNT1 A 0 A_Overlay( -1, "ChargeTube" );
			Goto Ready;
			
			TNT1 A 0
			{
				if ( invoker.ammo2.amount < 3 )
				{
					return ResolveState( "Ready" );
				}
				return ResolveState( null );
			}
			
		SpecialFire:
			TNT1 A 0 A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			TNT1 A 0 bright A_StopSound( CHAN_5 );
			TNT1 A 0 bright A_TakeInventory( "K7_ThinBlood", 3 );
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_iPersonaCharge = 0;
			}
			TNT1 A 0 A_StartSound( "dan_special", CHAN_WEAPON, CHANF_OVERLAP );
			TNT1 A 0 A_StartSound( "dan_special_vo", CHAN_VOICE );
			TNT1 A 0 bright A_FireProjectile( "K7_Dan_CollateralShot", 0, 1, 0, 0 );
			TNT1 A 0 A_Overlay( -1, "Flash" );
			DANF B 1 bright;
			DANF C 1 bright;
			DANF CDEF 1 bright;
			DANF GHIJ 2 bright;
			DANF KLMN 3 bright;
			DANF QSUW 4 bright;
			DANF Z 3 bright;
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
			TNT1 A 0;
			#### # 0 A_StartSound( "dan_reload", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
		
		Reload_Down:
			DANF A 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE);
			Stop;
		
		Reload_Up:
			//#### # 0 A_StartSound( "dan_aim", CHAN_WEAPON, CHANF_OVERLAP );
			DANF A 1 bright A_WeaponOffset( 33 * 1.5 * 1.5 * 1.5, 32 + 32, 0 );
			#### A 1 bright A_WeaponOffset( 33 * 1.5 * 1.5, 32 + 16, WOF_INTERPOLATE );
			#### A 1 bright A_WeaponOffset( 33 * 1.5, 32 + 8, WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset( 33, 32 + 4, WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset( 0, 32 + 2, WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset( 0, 32, 0);
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
		Radius 10;
		Height 810;
		Speed 20;
		DamageFunction (400);
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
