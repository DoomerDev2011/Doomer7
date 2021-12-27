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
			TNT1 # 0
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
			#### # 0
			{
				SmithSyndicate( invoker.owner ).m_fnPersonaChangeReady();
			}
			#### # 0 A_StartSound( "ked_aim", CHAN_WEAPON, CHANF_OVERLAP );
			KAED A 1 bright A_WeaponOffset(0,165,0);
			#### # 1 bright A_WeaponOffset( -128, 32 + 128, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset( -64, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset( -32, 32 + 32, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset( -16, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset( -8, 32 + 8, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset( -4, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset( -2, 32 + 2, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset( -1, 32 + 1, WOF_INTERPOLATE );
			#### # 1 bright A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			Goto Ready;
		
		DisableProperties:
			#### # 0
			{
				invoker.m_bZoom = false;
				invoker.m_bZoomedIn = false;
				SmithSyndicate( invoker.owner ).m_fnSetStatic( false );
			}
			#### # 0 A_ZoomFactor (1);
			Stop;
		
		Ready:
			KAED A 0 A_JumpIf( invoker.m_bZoomedIn, "ReadyZoomed" );
			#### # 0 A_JumpIf( invoker.m_bZoomedIn && !invoker.m_bZoom, "ZoomOut" );
			#### # 0 A_JumpIf( !invoker.m_bZoomedIn && invoker.m_bZoom, "ZoomIn" );
			#### # 1 bright A_WeaponReady( WRF_ALLOWRELOAD );
			Loop;
		
		ReadyZoomed:
			TNT1 A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			Goto Ready;
		
		Fire:
			KAED A 0 A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			#### # 0 A_JumpIf( invoker.m_bZoomedIn, "FireZoomed" );
			#### # 0 A_JumpIfNoAmmo("Reload");
			#### # 0 A_Overlay( LAYER_FUNC, "Fire_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil_Generic" );
			#### # 0 A_StartSound( "ked_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### B 1 bright;
			#### # 0 A_SetPitch( pitch - 2, 0 );
			#### C 2 bright;
			#### D 2 bright;
			#### E 2 bright;
			#### F 2 bright;
			#### HJK 2 bright;
			#### A 2 bright;
			#### # 0 A_JumpIfNoAmmo( "Ready" );
			#### # 0 A_Refire();
			Goto Ready;
			
		FireZoomed:
			TNT1 A 0 A_JumpIfNoAmmo( "Reload" );
			#### # 0 A_StartSound( "ked_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_SetBlend("E6F63F",.25,10);
			#### # 0 bright A_Overlay( LAYER_FUNC, "Fire_Bullet" );
			#### # 0 A_Overlay( LAYER_RECOIL, "Recoil_Generic" );
			#### # 0 A_SetPitch( pitch - 1, 0 );
			#### # 2;
			#### # 2;
			#### # 2;
			#### # 1;
			#### # 10;
			#### # 0 A_JumpIfNoAmmo( "Ready" );
			#### # 0 A_Refire();
			Goto Ready;

		Altfire:
			#### # 0 A_JumpIf( invoker.m_bZoomedIn, "ZoomOut" );
			Goto ZoomIn;
			
		ZoomIn:
			TNT1 # 0 A_ZoomFactor( 4 );
			#### # 0 A_StartSound( "ked_zoomin", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0
			{
				invoker.m_bZoom = true;
				invoker.m_bZoomedIn = true;
				SmithSyndicate( invoker.owner ).m_fnSetStatic( true );
			}
			#### # 0 bright A_WeaponOffset( 128, 64, WOF_INTERPOLATE );
			#### # 1 bright;
			Goto Ready;
			
		ZoomOut:
			TNT1 # 0 A_ZoomFactor( 1 );
			#### # 0 A_StartSound( "ked_zoomout", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 bright A_WeaponOffset( 0, 32, WOF_INTERPOLATE );
			#### # 0
			{
				invoker.m_bZoom = false;
				invoker.m_bZoomedIn = false;
				SmithSyndicate( invoker.owner ).m_fnSetStatic( false );
			}
			#### # 1 bright;
			Goto Ready;
			
		Reload:
			KAED # 0
			{
				if ( invoker.m_bZoomedIn )
				{
					SmithSyndicate( invoker.owner ).m_fnSetStatic( false );
					invoker.m_bZoomedIn = false;
					A_StartSound( "ked_zoomout", CHAN_WEAPON, CHANF_OVERLAP );
				}
			}
			#### A 0 A_ZoomFactor (1);
			#### A 0 bright A_StartSound( "ked_reload", CHAN_WEAPON, CHANF_OVERLAP );
			#### A 1 bright A_WeaponOffset(0,32,0); 
			#### A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,165,WOF_INTERPOLATE);
			#### A 0 A_SetInventory( "K7_Ammo", SmithSyndicate( invoker.owner ).m_iPersonaGunClipSize );
			#### A 104;
			#### A 1 bright A_WeaponOffset(0,165,0);
			#### A 1 bright A_WeaponOffset(0,135,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,105,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,90,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,75,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,60,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,50,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,40,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,35,WOF_INTERPOLATE);
			#### A 1 bright A_WeaponOffset(0,32,WOF_INTERPOLATE);
			#### A 1 bright A_JumpIf( invoker.m_bZoom, "Ready" );
			#### A 0 bright A_ReFire();
			Goto Ready;
		
		Flash1:
			KAEF A 1 bright A_Light(7);
			#### # 0 A_SetBlend("E6F63F",.25,10);
			#### B 1 bright A_Light(4); 
			#### C 1 bright A_Light(2);
			#### A 1 A_Light(1);
			#### # 1 A_Light(0);
			Stop;
			
		Flash2:
			KAEF D 1 bright A_Light(7);
			#### A 0 A_SetBlend("E6F63F",.25,10);
			#### E 1 bright A_Light(4); 
			#### F 1 bright A_Light(2);
			#### A 1 A_Light(1);
			#### # 1 A_Light(0);
			Stop;
			
		Flash3:
			KAEF G 1 bright A_Light(7);
			#### A 0 A_SetBlend("E6F63F",.25,10);
			#### H 1 bright A_Light(4); 
			#### I 1 bright A_Light(2);
			#### A 1 A_Light(1);
			#### # 1 A_Light(0);
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