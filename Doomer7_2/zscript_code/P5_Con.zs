// Glock weapon
//

Class K7_Con_Glock: Weapon
{
	default
	{
		+WEAPON.NOAUTOAIM
		+WEAPON.AMMO_OPTIONAL
		Weapon.AmmoType1 "K7_Con_Glock_Ammo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoType2 "K7_ThinBlood";
	    Inventory.PickupSound "weapon/getglk";
		Inventory.Pickupmessage "You got Con's Glocks."; 
	}
	
	bool isRunning;
	int cooldown;
	
	override void DoEffect()
    {
      super.DoEffect();
      if (cooldown > 0 && level.time % 35 == 0) 
          cooldown--;
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
			TNT1 A 0 A_StartSound( "weapon/conaim", CHAN_BODY, CHANF_OVERLAP );
			CONS A 1 bright A_WeaponOffset (140,32,0);
			CONS A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (100,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (85,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (55,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (40,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (5,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
			Goto Ready;
		
		Deselect:
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).PersonaChangeBegin();
			}
			CONS A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (5,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (40,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (55,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (85,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (100,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (140,32,WOF_INTERPOLATE);
			CONS A 0 A_WeaponOffset (0,-50);
			TNT1 A 4;
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner).PersonaChange();
			}
			
		KeepLowering:
			TNT1 A 0 A_Lower;
			Loop;
		
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
			CONS A 0 bright A_FireBullets( 5.6, 0, 1, SmithSyndicate( invoker.owner).m_iPersonaPrimaryDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			CONS A 0 bright A_StartSound("weapon/fireglk",CHAN_AUTO,CHANF_OVERLAP);
			TNT1 A 0 A_Overlay( -1, "Recoil" );
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
			CONS F 0 bright A_FireBullets( 5.6, 0, 1, SmithSyndicate( invoker.owner).m_iPersonaPrimaryDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			CONS F 0 bright A_StartSound("weapon/fireglk",CHAN_AUTO,CHANF_OVERLAP);
			TNT1 A 0 A_Overlay( -1, "Recoil" );
			CONS F 2 bright
			{
				int num = Random(0,2);
				if(num == 0){
					A_Overlay(-1,"BottomFlash");
				}else if (num == 1){
					A_Overlay(-1,"BottomFlash2");
				}else{
					A_Overlay(-1,"BottomFlash3");
				}
			}
			CONS GHI 1 bright;
			CONS KLO 1 bright;
			CONS RS 1 bright;
			CONS T 1 bright A_Refire();
			Goto Ready;
			
		Recoil:
			TNT1 A 0;
			Stop;
			
		Altfire:
			TNT1 A 0{
				if(invoker.cooldown > 0){
					return ResolveState("Ready");
				}
				invoker.isRunning = true;
				invoker.cooldown = 30;
				return ResolveState(null);
			}
			CONS A 16 bright;
			CONS A 4 A_GiveInventory( "K7_Con_Speed", 1 );
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
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).SetSpeed( SmithSyndicate( invoker.owner ).m_fPersonaSpeed_Reloading );
			}
			CONS A 0 bright A_StartSound("weapon/reglk");
			CONS A 1 bright A_WeaponOffset (0,32,0);
			CONS A 1 bright A_WeaponOffset (5,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (40,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (55,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (85,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (100,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (140,32,WOF_INTERPOLATE);
			TNT1 A 0 bright A_SetInventory( "K7_Con_Glock_Ammo", SmithSyndicate( invoker.owner).m_iPersonaClipSize );
			TNT1 A 18
			{
				SmithSyndicate( invoker.owner ).SetSpeed( 0 );
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).SetSpeed( SmithSyndicate( invoker.owner ).m_fPersonaSpeed );
			}
			CONS A 1 bright A_WeaponOffset (140,32,0);
			CONS A 1 bright A_WeaponOffset (120,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (100,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (85,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (70,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (55,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (40,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (30,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (20,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (10,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (5,32,WOF_INTERPOLATE);
			CONS A 1 bright A_WeaponOffset (0,32,WOF_INTERPOLATE);
			Goto Ready;
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

Class K7_Con_Speed : PowerSpeed
{
	default
	{
		-POWERSPEED.NOTRAIL
		Speed 2.5;
		Powerup.Duration -10;
		inventory.maxamount 1;
	}
}