Class K7_Kevin_ThrowingKnife: K7_SmithSyndicate_Weapon
{
	default
	{
		Weapon.SlotNumber 3;
		Weapon.SelectionOrder 800; 
		Weapon.AmmoUse1 1;
	    Inventory.PickupSound "weapon/getknife";
		Inventory.Pickupmessage "You got a Kevin's Throwing Knives.";
	}
	
	bool isInvisible;
	int cooldown;
	
	override void DoEffect()
    {
      super.DoEffect();
      if (cooldown > 0 && level.time % 35 == 0) 
          cooldown--;
    }
	
	States{
		Spawn:
			KEVP A -1 bright;
			Stop;
		
		Select:
			TNT1 A 0
			{
				A_SetTics( SmithSyndicate( invoker.owner).m_iPersonaChangeTime );
			}
			TNT1 A 0
			{
				if ( SmithSyndicate( invoker.owner).PersonaChangeEnd( 3 ) ) 
				{
					A_SetInventory( "K7_Dan_Taurus_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaClipSize );
					A_SetTics( SmithSyndicate( invoker.owner ).m_iPersonaFormTime );
				}
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).PersonaChangeReady();
			}
			TNT1 A 0 bright A_Raise;
			KEVI A 1 bright A_WeaponOffset(0,145,0);
			KEVI A 1 bright A_WeaponOffset(0,120,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,95,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,80,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,51,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,41,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready; 
		
		Deselect:
			TNT1 A 0 A_Overlay( -1, "ChangePersona" );
			KEVI A 1 bright A_WeaponOffset(0,32,0);
			KEVI A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,38,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,41,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,51,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,80,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,95,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,120,WOF_INTERPOLATE);
			KEVI A 1 bright A_WeaponOffset(0,145,WOF_INTERPOLATE);
			Stop;
			
		KeepLowering:
			TNT1 A 0 A_Lower;
			Loop;
		
		Ready:
			KEVI A 1 bright A_WeaponReady;
			Loop; 
		
		Fire:
			TNT1 A 0
			{
				if (invoker.isInvisible == true){
					invoker.isInvisible = false;
					invoker.cooldown = 15;
					A_TakeInventory("KevinInvisibility",1);
				}
			}
			KEVI BCS 1 bright;
			TNT1 A 4;
			KEVI DEFG 1 bright;
			KEVI H 0 bright A_FireBullets( 3, 0, 1, SmithSyndicate( invoker.owner ).m_iPersonaPrimaryDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			TNT1 A 0 bright A_SetBlend("E6F63F",.25,7);
			KEVI H 0 bright A_StartSound("weapon/fireknife",CHAN_AUTO,CHANF_OVERLAP);
			KEVI H 1 bright A_Overlay(-1,"Flash");
			KEVI IJ 1 bright;
			KEVI KLM 1 bright;
			TNT1 A 5;
			KEVI NOPQR 1 bright;
			KEVI A 1 bright A_ReFire();
			TNT1 A 0 A_Refire();
			Goto Ready;
		
		Altfire:
			TNT1 A 0{
				if(invoker.cooldown > 0){
					return ResolveState("Ready");
				}
				invoker.isInvisible = true;
				invoker.cooldown = 30;
				return ResolveState(null);
			}
			KEVI A 0 A_GiveInventory("KevinInvisibility",1);
			Goto Ready;
		
		Flash: 
			KEVF A 2 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,7);
			TNT1 A 1 A_Light(4); 
			TNT1 A 1 A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
		
	}
}

Class KevinInvisibility: PowerInvisibility{
	default{
		Powerup.Duration -15;
		inventory.maxamount 1; 
	}
}