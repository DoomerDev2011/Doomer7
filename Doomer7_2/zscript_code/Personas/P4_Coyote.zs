// Enfield2 Weapon
//

Class K7_Coyote_Enfield2: K7_SmithSyndicate_Weapon
{
	default{
		Weapon.SlotNumber 4;
	    Inventory.PickupSound "weapon/getrev";
		Inventory.Pickupmessage "You got Coyote's Modified Enfield No.2."; 
	}
	
	int m_iRefireLevel;
		
	States
	{
		Spawn:
			COYH A -1 bright;
			Loop;
		Select:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_fnPersonaChangeEnd( 4 ) ) 
				{
					A_SetInventory( "K7_Ammo", smith.m_iPersonaGunClipSize );
					A_SetTics( smith.m_iPersonaFormTime );
				}
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnPersonaChangeReady();
			}
			COYO A 1 bright A_WeaponOffset ( 180, 100, 0 );
			COYO A 1 bright A_WeaponOffset ( 150, 70, WOF_INTERPOLATE );
			COYO A 1 bright A_WeaponOffset ( 120, 60, WOF_INTERPOLATE );
			TNT1 A 0 A_StartSound( "weapon/coyoteaim", CHAN_BODY, CHANF_OVERLAP );
			COYO A 1 bright A_WeaponOffset (90,52,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (50,40,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (20,38,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (0,36,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset ( -10, 34, WOF_INTERPOLATE );
			COYO A 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Ready;
			
		Deselect:
			TNT1 A 0 A_Overlay( -1, "ChangePersona" );
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
			Stop;
			
		KeepLowering:
			TNT1 A 0 A_Lower;
			Loop;
			
		Ready:
			COYO A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
			Loop;
			
		Fire:
			TNT1 A 0 A_JumpIfNoAmmo("Reload");
			TNT1 A 0 A_StopSound( CHAN_7 );
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_iPersonaCharge > 0 && invoker.ammo2.amount > 0 )
				{
					A_FireBullets( 5.6, 0, 1, 150, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
					A_StartSound("weapon/coyotespecial",CHAN_AUTO,CHANF_OVERLAP);
					A_TakeInventory( "K7_ThinBlood", 1 );
				}
				else
				{
					A_FireBullets( 5.6, 0, 1, smith.m_iPersonaGunDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
					A_StartSound("weapon/coyoteshoot",CHAN_AUTO,CHANF_OVERLAP);
				}
				smith.m_iPersonaCharge = 0;
			}
			COYO B 1 bright{
				int num = Random(0,2);
				if(num == 0)
				{
					A_Overlay(-1,"Flash1");
				}
				else if (num == 1)
				{
					A_Overlay(-1,"Flash2");
				}
				else 
				{
					A_Overlay(-1,"Flash3");
				}
			}
			TNT1 A 0 A_Overlay( -1, "Recoil" );
			COYO E 1 bright;
			TNT1 A 6;
			COYO FGHI 1 bright;
			COYO JKL 2 bright;
			COYO A 1 bright A_ReFire();
			TNT1 A 0 A_Refire();
			Goto Ready;
			
		AltFire:
			TNT1 A 0 A_Overlay( -1, "ChargeTube" );
			Goto Ready;
			
		SpecialFire:
			TNT1 A 0 bright A_StopSound( CHAN_7 );
			COYO A 0 bright A_StartSound( "weapon/coyotespecial", CHAN_AUTO,CHANF_OVERLAP );
			COYO A 0 bright A_FireBullets( 5.6, 0, 1, 150, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			TNT1 A 0 bright A_TakeInventory( "K7_ThinBlood", 1 );
			COYO B 1 bright
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
			TNT1 A 0 A_Overlay( -1, "Recoil" );
			COYO E 1 bright;
			TNT1 A 30;
			COYO FGHI 1 bright;
			COYO JKL 2 bright;
			COYO A 1 bright A_ReFire;
			Goto Ready;
			
		Recoil:
			TNT1 A 0 bright A_SetPitch( pitch + 2.5, 0 );
			TNT1 A 1 bright A_SetAngle( angle + 3.5, 0 );
			TNT1 A 0 bright A_SetPitch( pitch + 1.25, SPF_INTERPOLATE );
			TNT1 A 1 bright A_SetAngle( angle + 1.75, SPF_INTERPOLATE );
			TNT1 A 0 bright A_SetPitch( pitch + 0.625, SPF_INTERPOLATE );
			TNT1 A 1 bright A_SetAngle( angle + 0.875, SPF_INTERPOLATE );
			TNT1 A 1 bright A_SetPitch( pitch + 0.75, 0 );
			TNT1 A 1 bright A_SetPitch( pitch - 0.75, 0 );
			TNT1 A 2 bright A_SetPitch( pitch + 0.75, 0 );
			TNT1 A 2 bright A_SetPitch( pitch - 0.75, 0 );
			Stop;
		
		Flash1:
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
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnSetSpeed( SmithSyndicate( invoker.owner ).m_fPersonaSpeed_Reloading );
			}
			COYO A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (90,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (150,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (180,32,WOF_INTERPOLATE);
			TNT1 A 0 A_SetInventory( "K7_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaGunClipSize );
			TNT1 A 20;
			COYO A 1 bright A_WeaponOffset (180,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (150,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (90,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (50,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnSetSpeed( SmithSyndicate( invoker.owner ).m_fPersonaSpeed );
			}
			COYO A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
			COYO A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
			TNT1 A 0 A_Refire();
			Goto Ready;
	}
}

Class K7_Coyote_Enfield2_Ammo: K7_Ammo
{
	Default
	{
		Inventory.MaxAmount 6;
	}
}
