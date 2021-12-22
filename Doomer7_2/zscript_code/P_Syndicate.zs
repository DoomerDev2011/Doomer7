class SmithSyndicate: DoomPlayer
{
	default
	{
		// Shared
		Player.ForwardMove 1, 0.5;
		Player.SideMove 0.66, 0.33;
		Player.StartItem "K7_ThinBlood", 5;
		Player.JumpZ 6.5;
		
		// Garcian
		
		// Dan
		Player.StartItem "K7_Dan_Taurus";
		Player.StartItem "K7_Dan_Taurus_Ammo", 6;
		Player.WeaponSlot 1, "K7_Dan_Taurus";
		
		// Kaede
		
		// Kevin
		
		// Coyote
		Player.StartItem "K7_Coyote_Enfield2";
		Player.StartItem "K7_Coyote_Enfield2_Ammo", 6;
		Player.WeaponSlot 4, "K7_Coyote_Enfield2";
		
		// Con
		Player.StartItem "K7_Con_Glock";
		Player.StartItem "K7_Con_Glock_Ammo", 10;
		Player.WeaponSlot 5, "K7_Con_Glock";
		
		// Mask
		
		// Not yet cleaned up
		Player.StartItem "K7_PPK";
		Player.StartItem "K7_Hardballer";
		Player.StartItem "K7_M79";
		Player.StartItem "K7_ThrowingKnife";
		Player.StartItem "K7_TommyGun";
		
		Player.StartItem "Clip", 100;
		Player.StartItem "NewClip", 100;
		Player.StartItem "PPKLoaded", 5;
		Player.StartItem "NewShell", 100;
		Player.StartItem "TommyGunLoaded", 50;
		Player.StartItem "HardballerLoaded", 10;
		Player.StartItem "M79Loaded", 2;
		Player.StartItem "NewRocket", 50;
		
        Player.WeaponSlot 2, "K7_Hardballer";
        Player.WeaponSlot 3, "K7_ThrowingKnife";
		Player.WeaponSlot 6, "K7_M79";
		
		Player.WeaponSlot 7, "K7_TommyGun";
	}
	// Shared
	int m_iSyndicateLVPower;
	int m_iSyndicateLVSpeed;
	int m_iSyndicateLVWaver;
	int m_iSyndicateLVCrits;
	
	float m_fPersonaSpeed;
	
	// Tics after changing weapons before they are raised
	int m_iPersonaChangeTime;
	// Tics between the fade in sound and deploying the weapon
	int m_iPersonaFormTime;
	
	bool m_bPersonaChange;
	int m_iPersonaCurrent;
	int m_iPersonaChargeMax;
	int m_iPersonaCharge;
	int m_iPersonaScanRange;
	
	// 
	//
	void InitSyndicate()
	{
		m_iPersonaCurrent = 0;
	}
	
	
	// Scan 
	//
	void VisionRingScan()
	{
		A_StartSound( "persona_scan", CHAN_BODY, CHANF_OVERLAP );
		
	}
	
	// Switch out of personality
	// (start lowering weapon)
	void PersonaChangeBegin()
	{
		A_StartSound( "persona_explode", CHAN_BODY, CHANF_OVERLAP );
		m_iPersonaChargeMax = 0;
		m_iPersonaCharge = 0;
		m_bPersonaChange = true;
		m_iPersonaChangeTime = 25;
		m_iPersonaFormTime = 65;
		m_iPersonaScanRange = 64;
		
		forwardmove1 = 0;
		sidemove1 = 0;
		forwardmove2 = forwardmove1;
		sidemove2 = sidemove1;
	}
	
	// Start changing of personality
	// (done lowering weapon)
	void PersonaChange()
	{
		if ( m_bPersonaChange )
		{
			A_StartSound( "persona_disperse", CHAN_BODY, CHANF_OVERLAP );
			m_bPersonaChange = false;
		}
	}
	
	// Switch in to personality
	// (raise weapon)
	// returns if change neccessary
	bool PersonaChangeEnd( int persona )
	{
		m_iPersonaChargeMax = 0;
		m_fPersonaSpeed = 0.975;
		switch( persona )
		{
			case 1: // DAN
				m_iPersonaChargeMax = 3;
				break;
			case 4: // COYOTE
				m_iPersonaChargeMax = 1;
				break;
			case 5: // CON
				m_fPersonaSpeed = 1.33;
				break;
		}
		
		if ( m_iPersonaCurrent == persona )
		{
			return false;
		}
		if (m_iPersonaCurrent != 0)
		{
			A_StartSound( "persona_reform", CHAN_BODY, CHANF_OVERLAP );
		}
		m_iPersonaCurrent = persona;
		m_iPersonaCharge = 0;
		return true;
	}
	
	void PersonaChangeReady()
	{
		forwardmove1 = m_fPersonaSpeed;
		sidemove1 = m_fPersonaSpeed * 0.7;
		forwardmove2 = forwardmove1 * 0.5;
		sidemove2 = sidemove1 * 0.5;
	}
	
	override void Tick()
    {
        Super.Tick();
        Shader.SetUniform1i(player, "Static", "timer", level.time);
    }
	
	// Dan
	//
	int iDanLVPower;
	int iDanLVSpeed;
	int iDanLVWaver;
	int iDanLVCrits;
	
	// KAEDE
	// 
	
	void SetStatic( bool on )
	{
		if( IsActorPlayingSound( CHAN_5, "weapon/statichard" ) == false ){
			A_StartSound( "weapon/statichard", CHAN_5, CHANF_LOOPING, 0.5 );
        }
		Shader.SetUniform1i(player, "Static", "timer", level.time);
		Shader.SetUniform1i(player, "Static", "resX", Screen.GetWidth() / 8);
		Shader.SetUniform1i(player, "Static", "resY", Screen.GetHeight() / 8);
		Shader.SetEnabled(player,"Static",on);
	}
	
	// Con
	//
	
	int iConSpeedBoost;
	
}

Class K7_ThinBlood : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 20;
	}
}

Class NewBulletPuff: BulletPuff
{
	default
	{
		+NOEXTREMEDEATH
	}
}

Class NewClip : Ammo replaces Clip{
	default{
		Inventory.Amount 10; 
		Inventory.MaxAmount 200;
		Ammo.BackpackAmount 30; 
		Ammo.BackpackMaxAmount 300; 
		Inventory.Icon "CLIPA0";
		Inventory.PickupMessage "Picked up some 9mm ammo.";
	}
	States{
		Spawn:
		CLIP A -1;
		Stop;
	}
}

Class NewShell: Ammo
{
	default
	{
		Inventory.Amount 7;
		Inventory.MaxAmount 200;
		Ammo.BackpackAmount 7;
		Ammo.BackPackMaxAmount 100;
		Inventory.Icon "SHELA0";
		Inventory.PickupMessage "Picked up revolver ammo."; 
	}
	States{
		Spawn:
		SHEL A -1;
		Stop;
	}
}

Class NewRocket: Ammo{
	default{
		Inventory.PickupMessage "$GOTROCKET";
		Inventory.Amount 1;
		Inventory.MaxAmount 50;
		Ammo.BackpackAmount 1;
		Ammo.BackpackMaxAmount 100;
		Inventory.Icon "ROCKA0";
	}
	States{
		Spawn:
		ROCK A -1;
		Stop;
	}
}

Class MaskMissile: Rocket{
	default{
		Speed 200;
	}
}