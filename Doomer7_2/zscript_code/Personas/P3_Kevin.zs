Class K7_Kevin_ThrowingKnife: K7_SmithSyndicate_Weapon
{
	default
	{
		Weapon.SlotNumber 3;
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
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_fnPersonaChangeEnd( 3 ) ) 
				{
					A_SetInventory( "K7_Ammo", smith.m_iPersonaGunClipSize );
					A_SetTics( smith.m_iPersonaFormTime );
				}
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnPersonaChangeReady();
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
			KEVI A 0
			{
				if (invoker.isInvisible == true){
					invoker.isInvisible = false;
					invoker.cooldown = 15;
					A_TakeInventory("KevinInvisibility",1);
				}
			}
			#### BCS 1 bright;
			#### A 4;
			#### DEFG 1 bright;
			#### H 0 bright 
			{
				
				let smith = SmithSyndicate( invoker.owner );
				A_Overlay( LAYER_FUNC, "Fire_Bullet" );
				smith.m_iPersonaGunCharge = 0;
				
			}
			#### A 0 bright A_SetBlend("E6F63F",.25,7);
			#### H 0 bright A_StartSound("weapon/fireknife",CHAN_AUTO,CHANF_OVERLAP);
			#### H 1 bright A_Overlay(-1,"Flash");
			#### IJ 1 bright;
			#### KLM 1 bright;
			TNT1 A 5;
			KEVI NOPQR 1 bright;
			#### A 1 bright A_ReFire();
			#### A 0 A_Refire();
			Goto Ready;
		
		AltFire:
		UseSpecial:
			#### # 0 A_Overlay( LAYER_FUNC, "ChargeTube" );
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
	Default
	{
		Powerup.Duration -15;
		inventory.maxamount 1; 
	}
}