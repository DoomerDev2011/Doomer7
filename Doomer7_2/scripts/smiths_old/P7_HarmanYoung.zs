Class K7_HarmanYoung_Tommygun: K7_SmithSyndicate_Weapon
{

	default
	{
		Weapon.SlotNumber 7;
		Inventory.Pickupmessage "You got Harman's Tommygun."; 
	}

	States
	{
		Spawn:
			YHAH A -1 bright;
			Loop;
		
		Select:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_fnPersonaChangeEnd( 7 ) ) 
				{
					A_SetInventory( "K7_Ammo", smith.m_iPersonaGunClipSize );
					A_SetTics( smith.m_iPersonaFormTime );
				}
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnPersonaChangeReady();
			}
			TNT1 A 0 A_Raise;
			TNT1 A 0 A_StartSound( "hay_aim", CHAN_BODY, CHANF_OVERLAP );
			YHAR A 1 bright A_WeaponOffset(0,125,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,110,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,95,WOF_INTERPOLATE); 
			#### A 1 bright A_WeaponOffset(0,80,WOF_INTERPOLATE); 
			#### A 1 bright A_WeaponOffset(0,70,WOF_INTERPOLATE); 
			#### A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,45,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready; 
		
		Deselect:
			TNT1 A 0 A_Overlay( -1, "ChangePersona" );
			YHAR A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,45,WOF_INTERPOLATE); 
			#### A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE); 
			#### A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE); 
			#### A 1 bright A_WeaponOffset(0,70,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,80,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,95,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,110,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,125,WOF_INTERPOLATE);
			Stop;
		
		Ready:
			YHAR A 1 bright A_WeaponReady(WRF_ALLOWRELOAD);
			Loop;
		
		Fire: 
			YHAR A 0 A_JumpIfNoAmmo( "Reload" );
			#### # 0 A_StartSound( "hay_shoot", CHAN_AUTO, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FUNC, "Fire_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil" );
			#### B 1 bright
			{
				int num = Random(0,2);
				if(num == 0){
					A_Overlay(-1,"Flash1");
				}else if (num == 1){
					A_Overlay(-1,"Flash2");
				}else{
					A_Overlay(-1,"Flash3");
				}
			}
			#### CEFI 1 bright;
			#### A 0 A_Refire();
			Goto Ready;
		
		Recoil:
			TNT1 A 0 A_SetPitch( pitch + frandom( -4, 1 ), 0 );
			TNT1 A 1 A_SetAngle( angle + frandom( -1.2, 1.2 ), 0 );
			TNT1 A 0 A_Overlay( LAYER_RECOIL, "Recoil_Generic" );
			Stop;
		
		Flash1:
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
			TNT1 A 0 A_Overlay( -1, "Reload_Start" );
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
			TNT1 A 0 A_SetInventory( "K7_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaGunClipSize );
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
			TNT1 A 0 A_Overlay( -1, "Reload_End" );
			YHAR A 1 bright A_ReFire;
			Goto Ready;
	}
}

Class K7_HarmanYoung_Tommygun_Ammo : K7_Ammo
{
	Default
	{
		Inventory.MaxAmount 50;
	}
}