// Syndicate player


Class SmithSyndicate : DoomPlayer
{
	default
	{
		// Shared
		
		
		// Garcian
		Player.StartItem "K7_Garcian_PPK";
		
		// Dan
		Player.StartItem "K7_Dan_Taurus";
		//Player.StartItem "K7_Dan_DemonGun";
		
		// Kaede
		Player.StartItem "K7_Kaede_Hardballer";
		
		// Kevin
		Player.StartItem "K7_Kevin_ThrowingKnife";
		
		// Coyote
		Player.StartItem "K7_Coyote_Enfield2";
		
		// Con
		Player.StartItem "K7_Con_Glock";
		
		// Mask
		Player.StartItem "K7_Mask_M79";
		
		// HarmanYoung
		// Given on Deadly difficulty
		
		
	}
	
	override void Tick()
    {
        Super.Tick();
		m_fnSyndicateTick();
    }
	
	int m_iThinBloodLimit;
	
	void m_fnSyndicateTick()
	{
		// Init
		int sk = G_SkillPropertyInt( SKILLP_ACSReturn );
		if ( !m_bInitSyndicateReady )
		{
			m_bInitSyndicateReady = true;
			m_fnPersonaChangeEnd( m_iPersonaCurrent );
			m_fnPersonaChangeReady();
			if ( sk >= 4 )
			{
				A_SetInventory( "K7_HarmanYoung_Tommygun", 1 );
			}
			A_SetInventory( "K7_Ammo", m_iPersonaGunClipSize );
			
			if ( sk >= 4 )
			{
				m_iThinBloodLimit = 5;
			}
			else if ( sk >= 3 )
			{
				m_iThinBloodLimit = 10;
			}
			else
				m_iThinBloodLimit = 20;
			// FIND CODE TO LIMIT K7_ThinBlood to m_iThinBloodLimit
		}
		// Breathing
		if ( true && m_iPersonaCurrent != 3 )
		{
			float breather = ( level.time * 2 );
			//A_SetAngle( angle + cos( breather ) / 20, SPF_INTERPOLATE );
			//A_SetPitch( pitch + sin( breather * 0.5 ) / 16, SPF_INTERPOLATE );
		}
		
		// Persona Tick
		switch ( m_iPersonaCurrent )
		{
			case 2:
				m_fnKaedeTick();
				break;
			case 5:
				m_fnConTick();
				break;
		}
	}
	
	bool m_bInitSyndicateReady;
	
	// Garcian Force Swap
	bool m_bPersonaCamSwap;
	int m_iPersonaCamSwapTo;
	
	// Shared
	//
	
	int m_iSyndicateLVPower;
	int m_iSyndicateLVSpeed;
	int m_iSyndicateLVWaver;
	int m_iSyndicateLVCrits;
	
	int m_iSyndicateThinBlood;
	int m_iSyndicateThickBlood;
	
	// Current Persona
	//
	
	bool m_bPersonaChange;
	int m_iPersonaChangeTime;
	int m_iPersonaFormTime;
	int m_iPersonaExplodeTime;
	int m_iPersonaCurrent;

	
	int m_iPersonaScanRange;
	int m_iPersonaHeight;
	
	// Character Stats
	float m_fPersonaJumpZ;
	float m_fPersonaSpeed;
	float m_fPersonaSpeed_Reloading;
	float m_fPersonaSpeed_Factor;
	float m_fPersonaFriction;
	float m_fPersonaVitality;
	float m_fPersonaSpecialFactor;
	
	float m_iPersonaLVPower;
	float m_iPersonaLVSpeed;
	float m_iPersonaLVWaver;
	float m_IPersonaLVCrits;
	
	// Weapon Stats
	int  	m_iPersonaGunFlags;
	bool  	m_bPersonaGunSilenced;
	int 	m_iPersonaGunCharge;
	int 	m_iPersonaGunCharge_Max;
	int  	m_iPersonaGunClipSize;
	int  	m_iPersonaGunDamage;
	float  	m_fPersonaGunDamage_Factor;
	float  	m_fPersonaGunSpread;
	float  	m_fPersonaGunSpread_Factor ;
	int  	m_iPersonaGunReloadTime;
	int  	m_fPersonaGunReloadTime_Factor;
	float  	m_fPersonaGunRecoil;
	float  	m_fPersonaGunRecoil_Factor;
	
	
	// Speed
	//
	float m_fCurrentSpeed;
	
	void m_fnSetSpeed( float new_speed )
	{
		m_fCurrentSpeed = new_speed * m_fPersonaSpeed_Factor;
		forwardmove1 = m_fCurrentSpeed;
		sidemove1 = forwardmove1 * 0.7;
		forwardmove2 = forwardmove1 * 0.5;
		sidemove2 = sidemove1 * 0.5;
		
		Friction = 1;
		//ViewBob = new_speed * 0.66;
	}
	
	// Scan ( Common Alt Fire )
	// 
	
	void m_fnVisionRingScan()
	{
		A_StartSound( "persona_scan", CHAN_BODY, CHANF_OVERLAP );
		
	}
	
	// Use Special Generic ( Add vials if available )
	//
	
	void m_fnUseSpecial()
	{
		if ( m_iPersonaGunCharge_Max > 0 )
		{
			if ( m_iPersonaGunCharge = m_iPersonaGunCharge_Max )
			{
				m_iPersonaGunCharge = 0;
			}
		}
	}
	
	
	// Switch out of personality (start lowering weapon)
	// 
		
	void m_fnPersonaChangeBegin()
	{
		if ( Health > 0 )
		{
			if ( m_iPersonaCurrent == 0 )
				A_StartSound( "persona_camswap", CHAN_BODY, CHANF_OVERLAP );
			else {
				A_StartSound( "persona_explode", CHAN_BODY, CHANF_OVERLAP );
				m_bPersonaChange = true;
			}
		}
		m_iPersonaGunCharge_Max = 0;
		m_iPersonaGunCharge = 0;
		m_iPersonaExplodeTime = 9;
		m_iPersonaChangeTime = 18;
		m_iPersonaScanRange = 64;
		
		m_fnSetSpeed( 0 );
		JumpZ = 0;
		Thing_Stop( 0 );
	}
	
	// Start changing of personality (finished lowering weapon)
	// 
	
	void m_fnPersonaChange()
	{
		if ( m_bPersonaChange )
		{
			A_StartSound( "persona_disperse", CHAN_BODY, CHANF_OVERLAP );
		}
	}
	
	// Switch in to personality (raise weapon)
	// Establish persona stats
	// Returns if persona was changed
	
	bool m_fnPersonaChangeEnd( int persona )
	{
		ViewBob = 0.33;
		SoundClass = "k7_dan";
		
		// Character Stats
		m_fPersonaVitality = 100;
		m_fPersonaSpeed = 0.8;
		m_fPersonaSpeed_Reloading = m_fPersonaSpeed * 0.66;
		m_fPersonaSpeed_Factor = 1;
		m_iPersonaHeight = 64;
		m_fPersonaJumpZ = 8;
		m_fPersonaSpecialFactor = 1;
		
		// Weapon Stats
		m_iPersonaGunFlags = FBF_USEAMMO|FBF_NORANDOM|FBF_NORANDOMPUFFZ;
		
		m_iPersonaGunCharge_Max = 0;
		m_bPersonaGunSilenced = false;
		m_iPersonaGunClipSize = 0;
		m_iPersonaGunDamage = 15;
		m_fPersonaGunDamage_Factor = 1;
		m_fPersonaGunSpread = 3.15;
		m_fPersonaGunSpread_Factor = 1;
		m_iPersonaGunReloadTime = 47;
		m_fPersonaGunReloadTime_Factor = 1;
		
		switch( persona )
		{
			case 0: // Garcian
				SoundClass = "k7_gar";
				
				m_iPersonaHeight = 55;
				
				m_iPersonaGunClipSize = 5;
				m_iPersonaGunDamage = 15;
				m_fPersonaGunSpread = 0;
				m_bPersonaGunSilenced = true;
				m_iPersonaGunReloadTime = 30;
				break;
			case 1: // Dan
				SoundClass = "k7_dan";
				
				m_iPersonaGunCharge_Max = 3;
				m_iPersonaGunClipSize = 6;
				m_iPersonaGunDamage = 55;
				m_fPersonaGunSpread = 0.33;
				break;
			case 2: // KAEDE
				SoundClass = "k7_ked";
				
				m_iPersonaHeight = 48;
				m_fPersonaSpeed *= 0.85;
				
				m_iPersonaGunClipSize = 10;
				m_iPersonaGunDamage = 45;
				break;
			case 3: // Kevin
				SoundClass = "";
				
				m_fPersonaSpeed *= 0.975;
				m_iPersonaGunClipSize = 1;
				m_fPersonaSpeed_Reloading = m_fPersonaSpeed;
				
				m_iPersonaGunCharge_Max = 1;
				m_iPersonaGunDamage = 30;
				break;
			case 4: // Coyote
				SoundClass = "k7_cyo";
				
				m_iPersonaHeight = 46;
				m_fPersonaJumpZ = 18;
				
				m_iPersonaGunCharge_Max = 1;
				m_iPersonaGunClipSize = 6;
				m_iPersonaGunDamage = 42;
				break;
			case 5: // Con
				SoundClass = "k7_con";
				
				m_iPersonaHeight = 35;
				m_fPersonaSpeed *= 1.33;
				m_fPersonaSpeed_Reloading = m_fPersonaSpeed * 0.75;
				m_fPersonaSpecialFactor = 2.25;
				
				m_iPersonaGunDamage = 14;
				m_iPersonaGunClipSize = 20;
				m_iPersonaGunReloadTime = 35;
				break;
			case 6: // MASK
				SoundClass = "k7_msk";
				
				m_iPersonaGunDamage = 30;
				m_iPersonaGunClipSize = 2;
				m_iPersonaGunCharge_Max = 3;
				m_iPersonaGunReloadTime = 40;
				break;
			case 7: // HarmanYoung
				SoundClass = "k7_hay";
				
				m_fPersonaSpeed *= 0.92;
				
				m_iPersonaGunClipSize = 50;
				m_iPersonaGunDamage = 30;
				m_iPersonaGunReloadTime = 50;
				break;
		}
		
		m_iPersonaFormTime = 70;
		
		if ( m_bPersonaCamSwap )
		{
			m_bPersonaCamSwap = false;
			return true;
		}
		
		if ( m_iPersonaCurrent == persona )
		{
			return false;
		}
		if ( m_bPersonaChange )
		{
			A_StartSound( "persona_reform", CHAN_BODY, CHANF_OVERLAP );
		}
		else {
			m_iPersonaFormTime = 35;
		}
		m_iPersonaCurrent = persona;
		m_iPersonaGunCharge = 0;
		m_bPersonaChange = false;
		return true;
	}
	
	void m_fnPersonaChangeReady()
	{
		m_fnPersonaApplyStats();
	}
	
	void m_fnPersonaApplyStats()
	{
		m_fnSetSpeed( m_fPersonaSpeed );
		JumpZ = m_fPersonaJumpZ;
	}
	
	// Dan
	//
	
	int iDanLVPower;
	int iDanLVSpeed;
	int iDanLVWaver;
	int iDanLVCrits;
	
	// KAEDE
	// 
	
	int m_iStaticStart;
	
	void m_fnKaedeTick()
	{
		Shader.SetUniform1i( player, "Static", "timer", level.time - m_iStaticStart );
		Shader.SetUniform1i( player, "Static", "resX", Screen.GetWidth() / 1 );
		Shader.SetUniform1i( player, "Static", "resY", Screen.GetHeight() / 1 );
	}
	
	void m_fnSetStatic( bool on )
	{
		if ( IsActorPlayingSound( CHAN_6, "weapon/statichard" ) )
		{
			if ( on == false )
			{
				A_StopSound( CHAN_6 );
			}
		}
		else if ( on == true )
		{
			A_StartSound( "weapon/statichard", CHAN_6, CHANF_LOOPING, 0.5 );
			m_iStaticStart = level.time;
        }
		int time = ( level.time - m_iStaticStart );
		Shader.SetUniform1i( player, "Static", "timer", time - m_iStaticStart );
		Shader.SetUniform1i( player, "Static", "resX", Screen.GetWidth() / 1 );
		Shader.SetUniform1i( player, "Static", "resY", Screen.GetHeight() / 1 );
		Shader.SetEnabled( player, "Static", on );
	}
	
	// Con
	// 
	
	int m_iConSpeedTimer;
	
	void m_fnConTick()
	{
		if ( m_iConSpeedTimer > 0 )
		{
			m_iConSpeedTimer--;
			if ( m_iConSpeedTimer < 1 )
			{
				m_iConSpeedTimer = 0;
				m_fPersonaSpeed_Factor = 1;
				
				if ( m_fCurrentSpeed > m_fPersonaSpeed )
				{
					m_fnSetSpeed( m_fPersonaSpeed );
				}
			}
		}
	}
}
