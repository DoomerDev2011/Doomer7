// Hardballer weapon
//

Class K7_Kaede_Hardballer: K7_SmithSyndicate_Weapon
{
	default
	{
		Weapon.SlotNumber 2;
	    Inventory.PickupSound "weapon/gethar";
		Inventory.Pickupmessage "You got Kaede's Hardballer.";
	}
	
	bool m_bZoom;
	bool m_bZoomedIn;
	PlayerInfo playerPointer;
		
	States
	{
		Spawn:
		KPIC A -1 bright;
		Loop;
		
		Select:
			TNT1 A 0
			{
				invoker.m_bZoom = false;
				invoker.m_bZoomedIn = false;
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_fnPersonaChangeEnd( 2 ) ) 
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
			KAED A 1 bright A_WeaponOffset(0,165,0);
			KAED A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
			TNT1 A 0 A_StartSound( "ked_aim", CHAN_WEAPON, CHANF_OVERLAP );
			KAED A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready;
		
		Deselect:
			TNT1 A 0
			{
				invoker.m_bZoom = false;
				invoker.m_bZoomedIn = false;
				SmithSyndicate( invoker.owner ).m_fnSetStatic( false );
			}
			TNT1 A 0 A_ZoomFactor (1);
			TNT1 A 0 A_Overlay( -1, "ChangePersona" );
			KAED A 1 bright A_WeaponOffset(0,32,0); 
			KAED A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,165,WOF_INTERPOLATE);
			Stop;
		
		Ready:
			TNT1 A 0 A_JumpIf( invoker.m_bZoomedIn, "ReadyZoomed" );
			TNT1 A 0 A_JumpIf( invoker.m_bZoomedIn && !invoker.m_bZoom, "ZoomOut" );
			TNT1 A 0 A_JumpIf( !invoker.m_bZoomedIn && invoker.m_bZoom, "ZoomIn" );
			KAED A 1 bright A_WeaponReady( WRF_ALLOWRELOAD );
			Loop;
		
		ReadyZoomed:
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnSetStatic( true );
			}
			TNT1 A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			Goto Ready;
		
		Fire:
			TNT1 A 0 bright A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			TNT1 A 0 A_JumpIf( invoker.m_bZoomedIn, "FireZoomed" );
			TNT1 A 0 bright A_JumpIfNoAmmo("Reload");
			TNT1 A 0 bright A_StartSound( "ked_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			TNT1 A 0 bright A_FireBullets( 5.6, 0, 1, SmithSyndicate( invoker.owner ).m_iPersonaGunDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			KAED B 1 bright;
			TNT1 A 0 bright A_SetPitch( pitch - 2, SPF_INTERPOLATE );
			KAED C 2 bright A_SetPitch( pitch - 1, SPF_INTERPOLATE );
			KAED D 2 bright A_SetPitch( pitch - 0.5, SPF_INTERPOLATE );
			KAED E 2 bright;
			KAED F 2 bright;
			KAED HJK 2 bright;
			KAED A 2 bright;
			KAED A 1 bright A_ReFire();
			TNT1 A 0 A_Refire();
			Goto Ready;
			
		FireZoomed:
			TNT1 A 0 A_JumpIfNoAmmo( "Reload" );
			TNT1 A 0 A_StartSound( "ked_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			TNT1 A 0 A_FireBullets( 0, 0, 1, SmithSyndicate( invoker.owner ).m_iPersonaGunDamage, "NewBulletPuff", FBF_USEAMMO|FBF_NORANDOM );
			TNT1 A 2
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
			TNT1 A 0 A_SetPitch(pitch-1,SPF_INTERPOLATE);
			TNT1 A 2 A_SetPitch(pitch-.75,SPF_INTERPOLATE);
			TNT1 A 2 A_SetPitch(pitch-.25,SPF_INTERPOLATE);
			TNT1 A 2;
			TNT1 A 1;
			TNT1 A 10;
			TNT1 A 1 A_ReFire;
			Goto Ready;

		Altfire:
			TNT1 A 0 A_JumpIf( invoker.m_bZoomedIn, "ZoomOut" );
			Goto ZoomIn;
			
		ZoomIn:
			TNT1 A 0 A_ZoomFactor( 4 );
			KAED A 0
			{
				invoker.m_bZoom = true;
				invoker.m_bZoomedIn = true;
			}
			KAED A 1 bright A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			
			Goto Ready;
			
		ZoomOut:
			TNT1 A 0 A_StartSound( "weapon/zoomhard", CHAN_WEAPON, CHANF_OVERLAP );
			TNT1 A 0 bright A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			KAED A 0
			{
				invoker.m_bZoom = false;
				invoker.m_bZoomedIn = false;
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnSetStatic( false );
			}
			TNT1 A 0 A_ZoomFactor( 1 );
			Goto Ready;
			
		Reload:
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).m_fnSetStatic( false );
			}
			TNT1 A 0 {
				invoker.m_bZoomedIn = false;
			}
			TNT1 A 0 A_ZoomFactor (1);
			KAED A 0 bright A_StartSound( "ked_reload", CHAN_WEAPON, CHANF_OVERLAP );
			KAED A 1 bright A_WeaponOffset(0,32,0); 
			KAED A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,165,WOF_INTERPOLATE);
			TNT1 A 0 A_SetInventory( "K7_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaGunClipSize );
			TNT1 A 104;
			KAED A 1 bright A_WeaponOffset(0,165,0);
			KAED A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			KAED A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			KAED A 1 bright A_ReFire;
			Goto Ready;
		
		Flash1:
			KAEF A 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			KAEF B 1 bright A_Light(4); 
			KAEF C 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		Flash2:
			KAEF D 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			KAEF E 1 bright A_Light(4); 
			KAEF F 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
			
		Flash3:
			KAEF G 1 bright A_Light(7);
			TNT1 A 0 A_SetBlend("E6F63F",.25,10);
			KAEF H 1 bright A_Light(4); 
			KAEF I 1 bright A_Light(2);
			TNT1 A 1 A_Light(1);
			TNT1 A 1 A_Light(0);
			Stop;
	}
}

Class K7_Kaede_Hardballer_Ammo: K7_Ammo
{
	default
	{
		Inventory.MaxAmount 10;
	}
}