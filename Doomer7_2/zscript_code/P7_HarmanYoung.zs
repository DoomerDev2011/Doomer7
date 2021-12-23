//Class that contains all of the information for the TommyGun weapon
Class K7_HarmanYoung_Tommygun: K7_SmithSyndicate_Weapon
{
	//The TommyGun's global properties
	default
	{
		Weapon.SlotNumber 7;
		Weapon.AmmoType1 "K7_HarmanYoung_Tommygun_Ammo";
	    Inventory.PickupSound "weapon/gettmg";
		Inventory.Pickupmessage "You got Harman's Tommygun."; 
	}
	
	//The TommyGun's various functions
	States
	{
	
		//Function that is called when the gun needs to spawn
		Spawn:
		YHAH A -1 bright;
		Loop;
		
		//Function that is called when the player selects the gun from their 
		//weapon pool
		Select:
			TNT1 A 0
			{
				A_SetTics( SmithSyndicate( invoker.owner).m_iPersonaChangeTime );
			}
			TNT1 A 0
			{
				if ( SmithSyndicate( invoker.owner).PersonaChangeEnd( 7 ) ) 
				{
					A_SetInventory( "K7_HarmanYoung_Tommygun_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaClipSize );
					A_SetTics( SmithSyndicate( invoker.owner ).m_iPersonaFormTime );
				}
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).PersonaChangeReady();
			}
			TNT1 A 0 A_Raise;
			YHAR A 1 bright A_WeaponOffset(0,125,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,110,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,95,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,80,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,70,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,45,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready; 
		
		Deselect:
			TNT1 A 0 A_Overlay( -1, "ChangePersona" );
			YHAR A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,45,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,70,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,80,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,95,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,110,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,125,WOF_INTERPOLATE);
			Stop;
		
		Ready:
			YHAR A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
			Loop;
		
		Fire: 
			YHAR A 0 bright A_JumpIfNoAmmo("Reload");
			YHAR A 0 bright A_StartSound("weapon/firetmg",CHAN_AUTO,CHANF_OVERLAP);
			YHAR A 0 bright A_FireBullets(5.6,0,1,10,"NewBulletPuff");
			YHAR B 1 bright {
				int num = Random(0,2);
				if(num == 0){
					A_Overlay(-1,"Flash");
				}else if (num == 1){
					A_Overlay(-1,"Flash2");
				}else{
					A_Overlay(-1,"Flash3");
				}
				int randomPitch = Random(-1,1);
				int randomAngle = Random(-1,1);
				A_SetPitch(pitch+randomPitch,SPF_INTERPOLATE);
				A_SetAngle(angle+randomAngle,SPF_INTERPOLATE);
			}
			YHAR CEFI 1 bright;
			Goto Ready;
		
		Flash:
			YHAF A 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			YHAF B 1 bright A_Light(4); 
			YHAF C 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
		
		Flash2:
			YHAF D 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			YHAF E 1 bright A_Light(4); 
			YHAF F 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
		
		Flash3:
			YHAF G 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			YHAF H 1 bright A_Light(4); 
			YHAF I 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
		
		Reload:
			YHAR A 0 bright A_StartSound("weapon/retmg");
			YHAR A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,45,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,70,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,80,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,95,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,110,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,125,WOF_INTERPOLATE);
			TNT1 A 0 A_SetInventory( "K7_HarmanYoung_Tommygun_Ammo", 50 ) ;
			TNT1 A 31;
			YHAR A 1 bright A_WeaponOffset(0,125,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,110,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,95,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,80,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,70,WOF_INTERPOLATE); 
			YHAR A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,45,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			YHAR A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			YHAR A 1 bright A_ReFire;
			Goto Ready;
	}
}

Class K7_HarmanYoung_Tommygun_Ammo: Ammo
{
	default
	{
		Inventory.MaxAmount 50;
		+INVENTORY.IGNORESKILL;
	}
}