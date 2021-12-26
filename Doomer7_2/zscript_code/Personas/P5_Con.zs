// Glock weapon
//

Class K7_Con_Glock: K7_SmithSyndicate_Weapon
{
	default
	{
		Weapon.SlotNumber 5;
		Weapon.AmmoType1 "K7_Ammo";
		Inventory.Pickupmessage "You got Con's Glocks.";
		Weapon.BobSpeed -2;
		Weapon.BobRangeX 0.1;
		Weapon.BobRangeY 1;
		Weapon.BobStyle "Smooth";
	}
	
	States{
		Spawn:
			CHED A -1 bright;
			Loop;
		
		Select:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_fnPersonaChangeEnd( 5 ) ) 
				{
					A_SetInventory( "K7_Ammo", smith.m_iPersonaGunClipSize );
					A_SetTics( smith.m_iPersonaFormTime );
					smith.m_iConSpeedTimer = 0;
				}
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnPersonaChangeReady();
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
			TNT1 A 0 A_WeaponOffset ( 0, 32, 0);
			TNT1 A 0 A_Overlay( -1, "Fire_Bullet" );
			TNT1 A 0 A_SetPitch( pitch + frandom( -2, 2 ) );
			TNT1 A 0 A_Overlay( LAYER_RECOIL, "Recoil_Generic" );
			CONS A 0 bright A_StartSound( "con_shoot", CHAN_WEAPON, CHANF_OVERLAP );
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
			TNT1 A 0 A_Overlay( -1, "Fire_Bullet" );
			TNT1 A 0 A_SetPitch( pitch + frandom( -2, 2 ) );
			TNT1 A 0 A_Overlay( LAYER_RECOIL, "Recoil_Generic" );
			CONS F 0 bright A_StartSound( "con_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			CONS F 2 bright
			{
				int num = Random(0,2);
				if(num == 0)
				{
					A_Overlay(-1,"BottomFlash");
				}
				else if (num == 1)
				{
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
			Goto UseSpecial;
			#### # 0
			{
				SmithSyndicate( invoker.owner ).m_fnVisionRingScan();
			}
			Goto Ready;
			
		UseSpecial:
			#### # 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_iConSpeedTimer > 0 || invoker.ammo2.amount < 1 )
				{
					return ResolveState("Ready");
				}
				A_TakeInventory( "K7_ThinBlood", 1 );
				smith.m_iConSpeedTimer = 35 * 5;
				return ResolveState( "Special" );
			}
		Special:
			CONS A 1 bright
			{
				SmithSyndicate( invoker.owner ).m_fnSetSpeed( 0 );
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
			TNT1 A 25
			{
				A_StartSound( "con_special_vo", CHAN_VOICE, 0 );
			}
			TNT1 A 20
			{
				A_StartSound ( "con_special_pose", CHAN_BODY, CHANF_OVERLAP );
			}
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fPersonaSpeed_Factor = smith.m_fPersonaSpecialFactor;
				smith.m_fnSetSpeed( smith.m_fPersonaSpeed );
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
		
		Reload_Start:
			#### # 0 bright A_StartSound( "con_reload" );
			#### # 0
			{
				let smith = SmithSyndicate( invoker.owner );
				A_SetTics( smith.m_iPersonaGunReloadTime * 0.35 );
			}
			#### # 0
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fnSetSpeed( 0 );
				smith.friction = 0.95;
			}
			Stop;
		
		Reload_Down:
			CONS A 1 bright A_WeaponOffset ( 0, 32, 0);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 64, 32 + 128, WOF_INTERPOLATE);
			Stop;
			
		Reload_Up:
			CONS A 1 bright A_WeaponOffset ( 64, 32 + 128, 0);
			#### # 1 bright A_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 16, 32 + 32, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 4, 32 + 8, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE);
			#### # 1 bright A_WeaponOffset ( 0, 32, WOF_INTERPOLATE);
			#### # 0 A_Overlay( LAYER_FUNC, "Reload_Done" );
			#### # 0 A_ReFire;
			Goto Ready;
	}
}

Class K7_Con_Glock_Ammo : K7_Ammo
{
	Default
	{
		Inventory.MaxAmount 20;
		+INVENTORY.IGNORESKILL;
	}
}
