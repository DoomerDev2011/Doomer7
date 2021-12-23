// Taurus weapon
//

Class K7_Dan_Taurus : Weapon
{
	default
	{
		+WEAPON.NOAUTOAIM
		+WEAPON.AMMO_OPTIONAL
		Weapon.AmmoType1 "K7_Dan_Taurus_Ammo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 6;
		Weapon.AmmoType2 "K7_ThinBlood";
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
			TNT1 A 0 A_StartSound( "weapon/danaim", CHAN_BODY, CHANF_OVERLAP );
			DANF A 1 bright A_WeaponOffset( 100, 0, 0 );
			DANF A 1 bright A_WeaponOffset( 66, 16, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 33, 28, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( -9, 30, WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset( 0, 32, WOF_INTERPOLATE);
			Goto Ready;
		
		// Lower weapon
		// Put the weapon down
		Deselect:
			TNT1 A 0 A_Overlay( -1, "ChangePersona" );
			DANF A 1 bright A_WeaponOffset(0,32,0);
			DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
			TNT1 A 10;
			
		KeepLowering:
			TNT1 A 0 bright A_Lower;
			Loop;
		
		ChangePersona:
			TNT1 A 11
			{
				SmithSyndicate( invoker.owner ).PersonaChangeBegin();
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner).PersonaChange();
			}
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
			TNT1 A 0 bright
			{
				if ( invoker.ammo1.amount < 1 ){
					return ResolveState( "Reload" );
				}
				return ResolveState( null );
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_iPersonaCharge = 0;
			}
			TNT1 A 0 bright A_FireBullets( 5.6, 0, 1, SmithSyndicate( invoker.owner ).m_iPersonaPrimaryDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			TNT1 A 0 bright A_StartSound( "weapon/danshoot", CHAN_AUTO, CHANF_OVERLAP );
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
			Goto Ready;
		
		// COlAORAL SHOT
		//
		
		AltFire:
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
			TNT1 A 0 bright A_StopSound( CHAN_5 );
			TNT1 A 0 bright A_TakeInventory( "K7_ThinBlood", 3 );
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_iPersonaCharge = 0;
			}
			TNT1 A 0 A_StartSound( "grunt/danspecial", CHAN_VOICE, 0 );
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
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_iPersonaCharge = 0;
				SmithSyndicate( invoker.owner ).SetSpeed( SmithSyndicate( invoker.owner ).m_fPersonaSpeed_Reloading );
			}
			DANF A 0 bright A_StartSound("weapon/danreload");
			DANF A 1 bright A_WeaponOffset(0,32,0);
			DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
			TNT1 A 0 A_SetInventory( "K7_Dan_Taurus_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaClipSize );
			TNT1 A 39;
			DANF A 1 bright A_WeaponOffset(0,158,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,138,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,118,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,103,WOF_INTERPOLATE);
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).SetSpeed( SmithSyndicate( invoker.owner ).m_fPersonaSpeed );
			}
			DANF A 1 bright A_WeaponOffset(0,88,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,73,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,58,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,48,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			DANF A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready;
	}
}

Class K7_Dan_Taurus_Ammo : Ammo
{
	default
	{
		Inventory.MaxAmount 6;
		+INVENTORY.IGNORESKILL;
	}
}


Class K7_CollateralShot : PlasmaBall
{
	Default
	{
		Radius 16;
		Height 8;
		Speed 20;
		DamageFunction (375);
		Projectile;
		-RANDOMIZE
		-DEHEXPLOSION
		-ROCKETTRAIL
		+NODAMAGETHRUST
		+FORCEPAIN
		RenderStyle "Add";
		Alpha 1;
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
