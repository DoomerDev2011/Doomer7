Class K7_Coyote_Enfield2: Weapon
{
	default{
		+Weapon.NOAUTOFIRE;
		+Weapon.Ammo_Optional;
		+Weapon.Alt_Uses_Both;
		+WEAPON.ALT_AMMO_OPTIONAL;
		Weapon.AmmoType1 "K7_Coyote_Enfield2_Ammo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "K7_ThinBlood";
	    Inventory.PickupSound "weapon/getrev";
		Inventory.Pickupmessage "You got Coyote's Modified Enfield No.2."; 
	}
	
	/*
	void BurstFire(){
		for(int counter = 0; counter<= 2; counter++){
			COYO A 0 bright A_JumpIfNoAmmo("Reload");
			COYO A 0 bright A_StartSound("weapon/firerev",CHAN_AUTO,CHANF_OVERLAP);
			COYO A 0 bright A_FireBullets(5.6,0,1,40,"NewBulletPuff");
			COYO B 1 bright{
				int num = Random(0,2);
				if(num == 0){
					A_Overlay(-1,"Flash");
				}else if (num == 1){
					A_Overlay(-1,"Flash2");
				}else{
					A_Overlay(-1,"Flash3");
				}
			}
			COYO B 0 bright A_SetPitch(pitch+1,SPF_INTERPOLATE);
			COYO C 1 bright A_SetPitch(pitch+.75,SPF_INTERPOLATE);
			COYO D 1 bright A_SetPitch(pitch+.25,SPF_INTERPOLATE);
			COYO E 1 bright;
		}
	}
	*/
	int counter;
		
	States
	{
		Spawn:
		COYH A -1 bright;
		Loop;
		
		Select:
		TNT1 A 0 A_Raise;
		COYO A 1 bright A_WeaponOffset ( 180, 140, WOF_INTERPOLATE );
		COYO A 1 bright A_WeaponOffset ( 150, 128, WOF_INTERPOLATE );
		COYO A 1 bright A_WeaponOffset ( 120, 92, WOF_INTERPOLATE );
		TNT1 A 0 A_StartSound( "weapon/coyoteaim", CHAN_BODY, 0 );
		COYO A 1 bright A_WeaponOffset (90,52,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (50,40,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		Goto Ready;
		
		Deselect: 
		COYO A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (50,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (90,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (150,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (180,32,WOF_INTERPOLATE);
		
		KeepLowering:
		TNT1 A 0 A_Lower;
		Loop;
		
		
		Ready:
		COYO A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
		
		Fire:
		COYO A 0 bright A_JumpIfNoAmmo("Reload");
		COYO A 0 bright A_StartSound("weapon/coyoteshoot",CHAN_AUTO,CHANF_OVERLAP);
		COYO A 0 bright A_FireBullets( 5.6, 0, 1, 20, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
		COYO B 1 bright{
			int num = Random(0,2);
			if(num == 0){
				A_Overlay(-1,"Flash");
			}else if (num == 1){
				A_Overlay(-1,"Flash2");
			}else{
				A_Overlay(-1,"Flash3");
			}
		}
		COYO B 0 bright A_SetPitch( pitch + 5, SPF_INTERPOLATE );
		COYO B 1 bright A_SetAngle( angle + 3, SPF_INTERPOLATE );
		COYO B 0 bright A_SetPitch( pitch + 3, SPF_INTERPOLATE );
		COYO C 1 bright A_SetAngle( angle + 1.5, SPF_INTERPOLATE );
		COYO C 0 bright A_SetPitch( pitch + 1.5, SPF_INTERPOLATE );
		COYO D 1 bright A_SetAngle( angle + 0.75, SPF_INTERPOLATE );
		COYO E 1 bright;
		TNT1 A 6;
		COYO FGHI 1 bright;
		COYO JKL 2 bright;
		COYO A 1 bright A_ReFire;
		Goto Ready;

		AltFire:
		TNT1 A 0
		{
			if ( invoker.ammo2.amount < 1 || invoker.ammo1.amount < 1 )
			{
				return ResolveState( "Ready" );
			}
			return ResolveState( null );
		}
		
		ChargeTubes:
		COYO A 0 A_StartSound( "weapon/tubea", CHAN_AUTO, CHANF_OVERLAP  );
		COYO A 8 A_StartSound( "weapon/coyotecharge", CHAN_7, CHANF_OVERLAP  );
		
		SpecialFire:
		TNT1 A 0 bright A_StopSound( CHAN_7 );
		COYO A 0 bright A_StartSound( "weapon/coyotespecial", CHAN_AUTO,CHANF_OVERLAP );
		COYO A 0 bright A_FireBullets( 5.6, 0, 1, 150, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
		TNT1 A 0 bright A_TakeInventory( "K7_ThinBlood", 1 );
		COYO B 1 bright{
			int num = Random(0,2);
			if(num == 0){
				A_Overlay(-1,"Flash");
			}else if (num == 1){
				A_Overlay(-1,"Flash2");
			}else{
				A_Overlay(-1,"Flash3");
			}
		}
		COYO B 0 bright A_SetPitch( pitch + 5, SPF_INTERPOLATE );
		COYO B 1 bright A_SetAngle( angle + 3, SPF_INTERPOLATE );
		COYO B 0 bright A_SetPitch( pitch + 3, SPF_INTERPOLATE );
		COYO C 1 bright A_SetAngle( angle + 1.5, SPF_INTERPOLATE );
		COYO C 0 bright A_SetPitch( pitch + 1.5, SPF_INTERPOLATE );
		COYO D 1 bright A_SetAngle( angle + 0.75, SPF_INTERPOLATE );
		COYO E 1 bright;
		TNT1 A 30;
		COYO FGHI 1 bright;
		COYO JKL 2 bright;
		COYO A 1 bright A_ReFire;
        Goto Ready;
			
		Flash:
		COYF A 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		COYF B 1 bright A_Light(4); 
		COYF C 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash2:
		COYF D 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		COYF E 1 bright A_Light(4); 
		COYF F 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		Flash3:
		COYF G 1 bright A_Light(7);
		TNT1 A 0 A_SetBlend("E6F63F",.25,10);
		COYF H 1 bright A_Light(4); 
		COYF I 1 bright A_Light(2);
		TNT1 A 1 A_Light(1);
		TNT1 A 1 A_Light(0);
		Stop;
		
		
		Reload:
		COYO A 0 bright A_StartSound("weapon/coyotereload");
		COYO A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (50,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (90,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (150,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (180,32,WOF_INTERPOLATE);
		TNT1 A 0 A_SetInventory( "K7_Coyote_Enfield2_Ammo", 6 ) ;
		TNT1 A 20;
		COYO A 1 bright A_WeaponOffset (180,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (150,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (90,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (50,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
		COYO A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
		Goto Ready;
	}
}

Class K7_Coyote_Enfield2_Ammo: Ammo{
	default{
		Inventory.MaxAmount 6;
		+INVENTORY.IGNORESKILL;
	}
}
