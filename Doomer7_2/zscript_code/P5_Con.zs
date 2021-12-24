// Glock weapon
//

Class K7_Con_Glock: K7_SmithSyndicate_Weapon
{
	default
	{
		Weapon.SlotNumber 5;
		Weapon.AmmoType1 "K7_Con_Glock_Ammo";
	    Inventory.PickupSound "weapon/getglk";
		Inventory.Pickupmessage "You got Con's Glocks."; 
	}
	
	States{
		Spawn:
		CHED A -1 bright;
		Loop;
		
		Select:
			TNT1 A 0
			{
				A_SetTics( SmithSyndicate( invoker.owner).m_iPersonaChangeTime );
			}
			TNT1 A 0
			{
				if ( SmithSyndicate( invoker.owner).PersonaChangeEnd( 5 ) ) 
				{
					A_SetInventory( "K7_Con_Glock_Ammo", SmithSyndicate( invoker.owner).m_iPersonaClipSize );
					A_SetTics( SmithSyndicate( invoker.owner ).m_iPersonaFormTime );
				}
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).PersonaChangeReady();
			}
			CONS A 1 bright A_WeaponOffset ( 64, 32 + 128, 0);
			CONS A 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			TNT1 A 0 A_StartSound( "con_aim", CHAN_BODY, CHANF_OVERLAP );
			CONS A 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE);
			Goto Ready;
		
		Deselect:
			TNT1 A 0 A_Overlay( -1, "ChangePersona" );
			CONS A 1 bright A_WeaponOffset ( 0, 32, 0);
			CONS A 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE);
			Stop;
		
		Ready:
			CONS A 1 bright A_WeaponReady( WRF_ALLOWRELOAD );
			Loop;
		
		Fire:
			TNT1 A 0 bright
			{
				if ( invoker.ammo1.amount < 1 ){
					return ResolveState( "Reload" );
				}
				return ResolveState( null );
			}
			TNT1 A 0 bright A_WeaponOffset ( 0, 32, 0);
			CONS A 0 bright A_FireBullets( 3, 0, 1, SmithSyndicate( invoker.owner).m_iPersonaPrimaryDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			CONS A 0 bright A_StartSound( "con_shoot", CHAN_AUTO, CHANF_OVERLAP );
			TNT1 A 0 A_SetPitch( pitch - 2, 0 );
			CONS B 1 bright{
				int num = Random(0,2);
				if(num == 0){
					A_Overlay(-1,"Flash");
				}else if (num == 1){
					A_Overlay(-1,"Flash2");
				}else{
					A_Overlay(-1,"Flash3");
				}
			}
			CONS C 1 bright;
			CONS DE 1 bright;
			CONS F 0 bright A_FireBullets( 3, 0, 1, SmithSyndicate( invoker.owner).m_iPersonaPrimaryDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			CONS F 0 bright A_StartSound( "con_shoot", CHAN_AUTO, CHANF_OVERLAP );
			TNT1 A 0 A_SetPitch( pitch + 4, SPF_INTERPOLATE );
			CONS F 2 bright
			{
				int num = Random(0,2);
				if(num == 0)
				{
					A_Overlay(-1,"BottomFlash");
					A_SetPitch( pitch - 4, 0 );
				}
				else if (num == 1)
				{
					A_SetPitch( pitch - 2, 0 );
					A_Overlay(-1,"BottomFlash2");
				}
				else
				{
					A_Overlay(-1,"BottomFlash3");
				}
			}
			CONS GH 1 bright;
			CONS I 1 bright A_SetPitch( pitch + 1, 0 );
			CONS K 1 bright A_SetPitch( pitch - 1, SPF_INTERPOLATE );
			CONS L 1 bright;
			CONS O 1 bright;
			CONS R 1 bright;
			CONS ST 1 bright A_Refire();
			TNT1 A 0 A_Refire();
			Goto Ready;
		
		Altfire:
			TNT1 A 0
			{
				if ( SmithSyndicate( invoker.owner ).m_iConSpeedTimer > 0 || invoker.ammo2.amount < 1 ){
					return ResolveState("Ready");
				}
				A_TakeInventory( "K7_ThinBlood", 1 );
				return ResolveState( "Special" );
			}
		Special:
			CONS A 1 bright
			{
				SmithSyndicate( invoker.owner ).SetSpeed( 0 );
				A_StartSound( "persona_powera", CHAN_BODY, CHANF_OVERLAP );
			}
			CONS A 1 bright A_WeaponOffset ( 0, 32, 0);
			CONS A 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE);
			TNT1 A 30;
			TNT1 A 30
			{
				A_StartSound( "con_special_vo", CHAN_VOICE, 0 );
			}
			TNT1 A 30
			{
				A_StartSound ( "con_special_pose", CHAN_BODY, CHANF_OVERLAP );
			}
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fPersonaSpeed_Factor = 2;
				smith.SetSpeed( smith.m_fPersonaSpeed );
				smith.m_iConSpeedTimer = 35 * 20;
			}
			CONS A 1 bright A_WeaponOffset ( 64, 32 + 128, 0);
			CONS A 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE);
			Goto Ready;
			
		Flash:
			CONF A 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,7);
			CONF B 1 bright A_Light(4);
			CONF C 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		Flash2:
			CONF D 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,7);
			CONF E 1 bright A_Light(4);
			CONF F 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		Flash3:
			CONF G 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,7);
			CONF H 1 bright A_Light(4);
			CONF I 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		BottomFlash:
			CONF J 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,7);
			CONF K 1 bright A_Light(4);
			CONF L 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		BottomFlash2:
			CONF M 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,7);
			CONF N 1 bright A_Light(4);
			CONF O 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		BottomFlash3:
			CONF P 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,7);
			CONF Q 1 bright A_Light(4);
			CONF R 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		Reload:
			TNT1 A 0 A_Overlay( -1, "Reload2" );
			CONS A 0 bright A_StartSound( "con_reload" );
			CONS A 1 bright A_WeaponOffset ( 0, 32, 0);
			CONS A 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE);
			TNT1 A 30;
			CONS A 1 bright A_WeaponOffset ( 64, 32 + 128, 0);
			CONS A 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE);
			Goto Ready;
			
		Reload2:
			TNT1 A 20
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.SetSpeed( smith.m_fPersonaSpeed_Reloading );
			}
			TNT1 A 10
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.SetSpeed( 0 );
				smith.friction = 0.95;
			}
			TNT1 A 10 A_SetInventory( "K7_Con_Glock_Ammo", SmithSyndicate( invoker.owner).m_iPersonaClipSize );
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.SetSpeed( smith.m_fPersonaSpeed );
				smith.friction = 1;
			}
			TNT1 A 10;
			TNT1 A 0 A_ReFire;
			Stop;
	}
}

Class K7_Con_Glock_Ammo : Ammo
{
	default
	{
		Inventory.MaxAmount 20;
		+INVENTORY.IGNORESKILL;
	}
}
