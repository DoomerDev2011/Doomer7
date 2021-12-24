// Tick while currently dan
//


// Taurus weapon
//

Class K7_Dan_Taurus : K7_SmithSyndicate_Weapon
{
	default
	{
		Weapon.SlotNumber 1;
		Weapon.AmmoType1 "K7_Dan_Taurus_Ammo";
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
				A_SetTics( SmithSyndicate( invoker.owner).m_iPersonaChangeTime );
			}
			TNT1 A 0
			{
				if ( SmithSyndicate( invoker.owner).PersonaChangeEnd( 1 ) ) 
				{
					A_SetInventory( "K7_Dan_Taurus_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaClipSize );
					A_SetTics( SmithSyndicate( invoker.owner ).m_iPersonaFormTime );
				}
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).PersonaChangeReady();
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
		Deselect:
			TNT1 A 0 A_Overlay( -1, "ChangePersona" );
			DANF A 1 bright A_WeaponOffset(0,32,0);
			DANF A 1 bright A_WeaponOffset( 0, 28, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 33, 22, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 66, 16, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 100, 0, WOF_INTERPOLATE );
			Stop;
		
		Ready:
			DANF A 1 bright A_WeaponReady( WRF_ALLOWRELOAD );
			Loop;
		
		// Primary Fire
		// Shoot the gun
		Fire:
			TNT1 A 0
			{
				if ( SmithSyndicate( invoker.owner ).m_iPersonaCharge > 2 )
				{
					return ResolveState( "SpecialFire" );
				}
				return ResolveState( null );
			}
			TNT1 A 0
			{
				if ( invoker.ammo1.amount < 1 ){
					return ResolveState( "Reload" );
				}
				return ResolveState( null );
			}
			TNT1 A 0 A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_iPersonaCharge = 0;
			}
			TNT1 A 0 bright A_FireBullets( 5.6, 0, 1, SmithSyndicate( invoker.owner ).m_iPersonaPrimaryDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			TNT1 A 0 bright A_StartSound( "dan_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			TNT1 A 0
			{
				int num = Random( 0,2 );
				if ( num == 0 )
				{
					A_Overlay( -1, "Flash1" );
				} else if ( num == 1 )
				{
					A_Overlay( -1, "Flash2" );
				} else
				{
					A_Overlay( -1, "Flash3" );
				}
			}
			DANF B 1 bright A_SetPitch( pitch - 3, SPF_INTERPOLATE ); 
			DANF C 1 bright A_SetPitch( pitch - 1.5, SPF_INTERPOLATE );
			DANF D 1 bright A_SetPitch( pitch - 0.75, SPF_INTERPOLATE );
			DANF E 1 bright A_SetPitch( pitch - 0.25, SPF_INTERPOLATE );
			DANF F 1 bright;
			DANF GIMOQSUWZ 2 bright; 
			DANF A 0 bright A_ReFire();
			TNT1 A 0 A_Refire();
			Goto Ready;
		
		// COlAORAL SHOT
		//
		
		AltFire:
			TNT1 A 0 A_Overlay( -1, "ChargeTube" );
			Goto Ready;
			
			TNT1 A 0
			{
				if ( invoker.ammo2.amount < 3 ){
					return ResolveState( "Ready" );
				}
				return ResolveState( null );
			}
			
		ChargeTubes:
			DANF A 5 A_StartSound( "weapon/tubea", CHAN_7, CHANF_OVERLAP  );
			DANF A 5 A_StartSound( "weapon/tubeb", CHAN_7, CHANF_OVERLAP  );
			DANF A 0 A_StartSound( "weapon/tubec", CHAN_7, CHANF_OVERLAP  );
			TNT1 A 0 A_StartSound( "weapon/dancharge", CHAN_5, CHANF_OVERLAP );
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_iPersonaCharge = 3;
			}
			DANF A 25;
			Goto Fire;
			
		SpecialFire:
			TNT1 A 0 A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			TNT1 A 0 bright A_StopSound( CHAN_5 );
			TNT1 A 0 bright A_TakeInventory( "K7_ThinBlood", 3 );
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_iPersonaCharge = 0;
			}
			TNT1 A 0 A_StartSound( "dan_special_vo", CHAN_VOICE, 0 );
			TNT1 A 0 bright A_FireProjectile( "K7_CollateralShot", 0, 1, 0, 0 );
			//TNT1 A 0 bright A_SetPitch( pitch - 1.5, SPF_INTERPOLATE );
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
		// Reload the weapon
		// Always reload, regardless of clip/ammo
		Reload:
			TNT1 A 0 A_Overlay( -1, "Reload2" );
			DANF A 0 bright A_StartSound("dan_reload");
			DANF A 1 bright A_WeaponOffset(0,32,0);
			DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
			TNT1 A 39;
			DANF A 1 bright A_WeaponOffset( 100, 0, 0 );
			DANF A 1 bright A_WeaponOffset( 66, 16, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 33, 22, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 0, 28, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( -8, 32 + 8, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 0, 32, WOF_INTERPOLATE);
			Goto Ready;
			
		Reload2:
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_iPersonaCharge = 0;
				SmithSyndicate( invoker.owner ).SetSpeed( SmithSyndicate( invoker.owner ).m_fPersonaSpeed_Reloading );
			}
			TNT1 A 30;
			TNT1 A 0 A_SetInventory( "K7_Dan_Taurus_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaClipSize );
			TNT1 A 15;
			TNT1 A 10
			{
				SmithSyndicate( invoker.owner ).SetSpeed( SmithSyndicate( invoker.owner ).m_fPersonaSpeed );
			}
			TNT1 A 0 A_Refire();
			Stop;
	}
}

// Taurus Ammo
//

Class K7_Dan_Taurus_Ammo : Ammo
{
	default
	{
		Inventory.MaxAmount 6;
		+INVENTORY.IGNORESKILL;
	}
}

// Collateral Shot Projectile
// 

Class K7_CollateralShot : PlasmaBall
{
	Default
	{
		Radius 16;
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
		SeeSound "dan_special";
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
