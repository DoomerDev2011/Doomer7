Class SmithSyndicate : DoomPlayer
{
	default
	{
		// Shared
		
		
		// Garcian
		Player.StartItem "K7_Garcian_PPK";
		Player.StartItem "K7_Garcian_PPK_Ammo", 5;
		
		// Dan
		Player.StartItem "K7_Dan_Taurus";
		
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
		Player.StartItem "K7_HarmanYoung_Tommygun";
		
		
	}
	bool m_bInitSyndicate;
	
	// Garcian Force Swap
	//
	
	bool m_bPersonaSwap;
	int m_iPersonaSwapTo;
	
	// Shared
	//
	
	int m_iSyndicateLVPower;
	int m_iSyndicateLVSpeed;
	int m_iSyndicateLVWaver;
	int m_iSyndicateLVCrits;
	
	int m_iSyndicateThinBlood;
	int m_iSyndicateThickBlood;
	
	void SyndicateTick()
	{
		if ( m_bInitSyndicate == false )
		{
			m_bInitSyndicate = true;
			m_bPersonaSwap = true;
		}
		
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
	
	// Current Persona
	//
	
	bool m_bPersonaChange;
	// Tics after changing weapons before they are raised
	int m_iPersonaChangeTime;
	// Tics between the fade in sound and deploying the weapon
	int m_iPersonaFormTime;
	int m_iPersonaExplodeTime;
	int m_iPersonaCurrent;
	int m_iPersonaChargeMax;
	int m_iPersonaCharge;
	
	int m_iPersonaScanRange;
	int m_iPersonaHeight;
	// Character Stats
	float m_fPersonaJumpZ;
	float m_fPersonaSpeed;
	float m_fPersonaSpeed_Reloading;
	float m_fPersonaSpeed_Factor;
	float m_fPersonaFriction;
	float m_fPersonaVitality;
	// Weapon Stats
	int m_iPersonaClipSize;
	int m_iPersonaPrimaryDamage;
	float m_iPersonaSpread;
	
	float m_iPersonaLVPower;
	float m_iPersonaLVSpeed;
	float m_iPersonaLVWaver;
	float m_IPersonaLVCrits;
	
	
	// Speed
	//
	float m_fCurrentSpeed;
	void SetSpeed( float new_speed )
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
	
	void VisionRingScan()
	{
		A_StartSound( "persona_scan", CHAN_BODY, CHANF_OVERLAP );
		
	}
	
	// Use Special Generic ( Add vials if available )
	//
	
	void UseSpecial()
	{
		if ( m_iPersonaChargeMax > 0 )
		{
			if ( m_iPersonaCharge = m_iPersonaChargeMax )
			{
				m_iPersonaCharge = 0;
			}
		}
	}
	
	// Called before all reloads
	//
	
	void ReloadGenericPre()
	{
		m_iPersonaCharge = 0;
	}
	
	// Switch out of personality (start lowering weapon)
	// 
		
	void PersonaChangeBegin()
	{
		if ( Health > 0 )
		{
			A_StartSound( "persona_explode", CHAN_BODY, CHANF_OVERLAP );
			m_bPersonaChange = true;
		}
		m_iPersonaChargeMax = 0;
		m_iPersonaCharge = 0;
		m_iPersonaExplodeTime = 9;
		m_iPersonaChangeTime = 18;
		m_iPersonaFormTime = 70;
		m_iPersonaScanRange = 64;
		
		SetSpeed( 0 );
		JumpZ = 0;
		Friction = 0.9;
	}
	
	// Start changing of personality (finished lowering weapon)
	// 
	
	void PersonaChange()
	{
		if ( m_bPersonaChange )
		{
			A_StartSound( "persona_disperse", CHAN_BODY, CHANF_OVERLAP );
			m_bPersonaChange = false;
		}
	}
	
	// Switch in to personality (raise weapon)
	// Establish persona stats
	// Returns if persona was changed
	
	bool PersonaChangeEnd( int persona )
	{
		ViewBob = 0.66;
		SoundClass = "player";
		//
		//
		m_fPersonaVitality = 100;
		m_iPersonaChargeMax = 0;
		m_fPersonaSpeed = 0.975;
		m_fPersonaSpeed_Reloading = 0.45;
		m_fPersonaSpeed_Factor = 1;
		m_iPersonaHeight = 52;
		m_iPersonaClipSize = 0;
		m_iPersonaPrimaryDamage = 15;
		m_iPersonaSpread = 3.15;
		m_fPersonaJumpZ = 0;
		
		switch( persona )
		{
			case 0: // Garcian
				m_iPersonaHeight = 55;
				m_iPersonaClipSize = 5;
				m_iPersonaPrimaryDamage = 8;
				break;
			case 1: // Dan
				m_iPersonaClipSize = 6;
				m_iPersonaChargeMax = 3;
				m_iPersonaPrimaryDamage = 40;
				break;
			case 2: // KAEDE
				m_iPersonaHeight = 48;
				m_fPersonaSpeed = 0.9;
				m_iPersonaClipSize = 10;
				m_iPersonaPrimaryDamage = 35;
				break;
			case 3: // Kevin
				m_fPersonaSpeed = 1.25;
				m_iPersonaClipSize = 1;
				m_iPersonaPrimaryDamage = 25;
				break;
			case 4: // Coyote
				m_iPersonaHeight = 46;
				m_iPersonaClipSize = 6;
				m_iPersonaChargeMax = 1;
				m_iPersonaPrimaryDamage = 30;
				m_fPersonaJumpZ = 18;
				break;
			case 5: // Con
				SoundClass = "k7_con";
				m_iPersonaHeight = 35;
				m_fPersonaSpeed = 1.33;
				m_fPersonaSpeed_Reloading = 0.66;
				m_iPersonaClipSize = 20;
				m_iPersonaPrimaryDamage = 9;
				break;
			case 6: // MASK
				m_fPersonaSpeed = 1.1;
				m_iPersonaClipSize = 2;
				break;
			case 7: // HarmanYoung
				m_fPersonaSpeed = 1;
				m_iPersonaClipSize = 50;
				break;
		}
		
		if ( m_iPersonaCurrent == persona )
		{
			return false;
		}
		A_StartSound( "persona_reform", CHAN_BODY, CHANF_OVERLAP );
		m_iPersonaCurrent = persona;
		m_iPersonaCharge = 0;
		return true;
	}
	
	void PersonaChangeReady()
	{
		SetSpeed( m_fPersonaSpeed );
		JumpZ = m_fPersonaJumpZ;
	}
	
	override void Tick()
    {
        Super.Tick();
		SyndicateTick();
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
		Shader.SetUniform1i( player, "Static", "timer", level.time );
	}
	
	void SetStatic( bool on )
	{
		if ( IsActorPlayingSound( CHAN_6, "weapon/statichard" ) )
		{
			if ( on == false )
			{
				A_StopSound( CHAN_6 );
			}
		}
		else
		{
			A_StartSound( "weapon/statichard", CHAN_6, CHANF_LOOPING, 0.5 );
        }
		Shader.SetUniform1i( player, "Static", "timer", level.time - m_iStaticStart );
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
					SetSpeed( m_fPersonaSpeed );
				}
			}
		}
	}
}

Class K7_SmithSyndicate_Weapon : Weapon
{
	Default
	{
		// Flags
		+WEAPON.NOAUTOAIM
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.NOAUTOFIRE
		// Stats
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "K7_ThinBlood";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
	}
	States
	{
		FormPersona:
			
			Stop;
		ChangePersona:
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner ).PersonaChangeBegin();
				A_SetTics( SmithSyndicate( invoker.owner ).m_iPersonaExplodeTime );
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner).PersonaChange();
			}
			TNT1 A 0 A_Lower( 512 );
			Stop;
		
		ChargeTube:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				if ( smith.m_iPersonaChargeMax > 0 && invoker.ammo2.amount > 0 )
				{
					smith.m_iPersonaCharge++;
					if ( smith.m_iPersonaCharge > invoker.ammo2.amount || smith.m_iPersonaCharge > smith.m_iPersonaChargeMax )
					{
						smith.m_iPersonaCharge = 0;
					}
					switch( smith.m_iPersonaCharge )
					{
						case 0:
							A_StartSound( "charge_tube", CHAN_7, CHANF_OVERLAP  );
							break;
						case 1:
							A_StartSound( "charge_tubea", CHAN_7, CHANF_OVERLAP  );
							break;
						case 2:
							A_StartSound( "charge_tubeb", CHAN_7, CHANF_OVERLAP  );
							break;
						case 3:
							A_StartSound( "charge_tubec", CHAN_7, CHANF_OVERLAP  );
							break;
						default:
							A_StartSound( "charge_tubec", CHAN_7, CHANF_OVERLAP  );
					}
				}
			}
			stop;
	}
}

Class K7_ThinBlood : Ammo
{
	Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 20;
		Inventory.PickupMessage "Picked up a tube of thin blood";
		//Inventory.PickupSound "";
	}
	States
	{
		Spawn:
			BLDV A 1;
			Loop;
	}
}

Class K7_ThickBlood : Ammo
{
	Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 1000;
		//Inventory.PickupSound "";
	}
}

Class NewBulletPuff: BulletPuff
{
	default
	{
		+NOEXTREMEDEATH
	}
}