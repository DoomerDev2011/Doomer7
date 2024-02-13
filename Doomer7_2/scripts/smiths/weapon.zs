Class CK7_Smith_Weapon : Weapon
{
	const READY_FLAGS = ( WRF_ALLOWRELOAD | WRF_NOPRIMARY | WRF_NOSECONDARY | WRF_NOBOB );
	const AIMING_FLAGS = ( WRF_ALLOWRELOAD | WRF_DISABLESWITCH );
	const BULLET_FLAGS = ( FBF_USEAMMO | FBF_NORANDOMPUFFZ );
	
	const LAYER_BARS 	= 54;
	const LAYER_ANIM 	= 2;
	const LAYER_FUNC 	= -1;
	const LAYER_RECOIL 	= -2;
	const LAYER_SHOOT 	= -3;
	const LAYER_FLASH 	= -5;
	const LAYER_SPECIAL = -6;
	
	/*	Variable Notes
		m_iPersona is the id of the smith;
		m_sPersona is the short name of the smith ( gar, dan, ked, kvn, cyo, con, msk, hay );
		m_fViewHeight is a scale relative to the current smith height;
		
	*/
	
	int 	m_iPersona;
	string 	m_sPersona;
	float	m_fSpeed;
	int 	m_fDamage;
	float 	m_fSpread;
	float 	m_fRecoil;
	int 	m_iClipSize;
	int 	m_iAmmo;
	float 	m_fRefire;
	float 	m_fHeight;
	float  	m_fViewHeight;
	float 	m_fReloadTime;
	float 	m_fReloadTimeStanding;
	bool 	m_bAutoFire;
	float 	m_fFireDelay;
	float 	m_fSpecialFactor;
	float	m_fSpecialDuration;
	int 	m_iSpecialCharges;
	int		m_iSpecialChargeCount;
	transient bool crossHairMode;
	Name 	pSoundClass;
	property PersonaSoundClass : pSoundClass;
	
	void AimingBreathe()
	{
		
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		
		m_iPersona = slotnumber;
		m_sPersona = "none";
		
		m_fSpeed = 1.0;
		
		m_fDamage = 40;
		m_fSpread = 0.2;
		m_fRecoil = 2.5;
		m_iClipSize = 6;
		m_fRefire = 15;
		m_fHeight = 52;
		m_fViewHeight = 0.8;
		m_fReloadTime = 42;
		m_fReloadTimeStanding = 70;
		m_fSpecialFactor = 1;
		m_fSpecialDuration = 1;
	}
	
	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		
		m_iAmmo = m_iClipSize;
	}
	
	Default
	{
		+WEAPON.NOAUTOFIRE
		+WEAPON.NOALERT
		+WEAPON.NO_AUTO_SWITCH
		+WEAPON.NOAUTOAIM
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		
		Weapon.AmmoType1 "CK7_Ammo";
		Weapon.AmmoUse1 0;
		Weapon.AmmoType2 "CK7_ThinBlood";
		Weapon.AmmoUse2 0;
		Weapon.KickBack 0;
		Weapon.SlotNumber 0;
		Weapon.BobSpeed -2;
		Weapon.BobRangeX 0.1;
		Weapon.BobRangeY 1;
		CK7_Smith_Weapon.PersonaSoundClass "player";
	}

	void UpdateSoundClass()
	{
		let plr = PlayerPawn(owner);
		if (!plr || plr.SoundClass == pSoundClass)
		{
			return;
		}
		plr.SoundClass = pSoundClass ? pSoundClass : 'player';
	}

	void UpdateCrosshair(Weapon weap)
	{
		if (CVar.GetCVar('k7_crosshairEnabled', owner.player).GetBool())
		{
			weap.crosshair = 99;
		}
		else
		{
			weap.crosshair = 0;
		}
	}
	
	override void DoEffect()
	{
		Super.DoEffect();
		if (!owner || !owner.player)
		{
			return;
		}
		let weap = owner.player.readyweapon;
		if (!weap || weap != self)
		{
			return;
		}

		UpdateSoundClass();
		UpdateCrosshair(weap);
	}
	
	States
	{
		Select:
			TNT1 A 1 A_WeaponOffset( 0, 32, 0 );
			#### # 0
			{
				if ( CVar.FindCVar( 'k7_mode' ).GetBool() )
				{
					invoker.m_iAmmo = invoker.m_iClipSize;
				}
				let smith = CK7_Smith( invoker.owner );
				smith.ApplyStats();
				smith.SetSpeed( invoker.m_fSpeed );
				smith.SetViewHeight( invoker.m_fHeight - 2.5 );
				invoker.m_iSpecialCharges = 0;
				return ResolveState( "Ready" );
			}
		Ready:
			TNT1 A 0 A_JumpIf( ( CK7_Smith( invoker.owner ).m_bAimHeld ) , "Aim_In" );
			#### # 1 A_WeaponReady( READY_FLAGS );
			Goto Ready + 2;
			
		Deselect:
			#### # 0 A_Lower( 512 );
			#### # 0
			{
				CK7_Smith( invoker.owner ).m_bZoomedIn = false;
			}
			
		Recoil_Generic:
			#### A 1 A_SetPitch( pitch - 1 );
			#### A 1 A_SetPitch( pitch + 1 * 2 );
			#### A 1 A_SetPitch( pitch - 1 * 1.5 );
			#### A 1 A_SetPitch( pitch + 1 * 0.75 );
			#### A 1 A_SetPitch( pitch - 1 * 0.25 );
			Stop;
			
		Aim_In:
			#### # 0
			{
				if ( CVar.FindCVar( 'k7_mode' ).GetBool() )
				{
					Thing_Stop( 0 );
					CK7_Smith( invoker.owner ).SetSpeed( 0 );
				}
			}
			#### # 5;
			#### # 0
			{
				if ( CVar.FindCVar( 'k7_mode' ).GetBool() )
				{
					invoker.LookScale = 0.5;
					A_ZoomFactor( 2.75, ZOOM_INSTANT );
					A_SetCrosshair( 2 );
					A_SetPitch( 0 );
					CK7_Smith( invoker.owner ).SetViewHeight( invoker.m_fHeight * invoker.m_fViewHeight );
				}
			}
			#### # 15 A_Overlay( LAYER_ANIM, "Anim_Aim_In" );
			#### # 0
			{
				CK7_Smith( invoker.owner ).m_bAiming = true;
				return ResolveState( "Aiming" );
			}
		
		Aiming:
			#### # 0 A_JumpIf( ( CK7_Smith( invoker.owner ).m_bZoomedIn ), "Aiming_Zoomed" );
			#### # 0 A_JumpIf( !( CK7_Smith( invoker.owner ).m_bAimHeld ), "Aim_Out" );
			#### # 1 A_WeaponReady( ( CVar.FindCVar( 'k7_mode' ).GetBool() ) ? AIMING_FLAGS : AIMING_FLAGS &~ WRF_DISABLESWITCH );
			Loop;
		
		Aiming_Zoomed: // leave zoom state if this character shouldnt be in it
			TNT1 A 0
			{
				CK7_Smith( invoker.owner ).m_bZoomedIn = false;
				return ResolveState( "Aiming" );
			}
			Loop;
		
		Fire:
			TNT1 A 0;
			//#### # 0 A_JumpIf( ( CK7_Smith( invoker.owner ).m_bZoomedIn ), "Fire_Zoomed" );
			#### # 0 A_JumpIf ( ( invoker.m_iAmmo == 0 ), "Reload" );
			#### # 0
			{
				if ( CK7_Smith( invoker.owner ).m_bZoomedIn )
					A_Overlay( LAYER_ANIM, "Anim_Fire_Zoomed" );
				else
				{
					if ( invoker.m_iSpecialChargeCount > 0 )
					{
						if ( invoker.m_iSpecialCharges > 0 )
						{
							switch ( invoker.m_iSpecialCharges )
							{
								case 2:
									A_Overlay( LAYER_ANIM, "Anim_Fire_Special2" );
									break;
								case 3:
									A_Overlay( LAYER_ANIM, "Anim_Fire_Special3" );
									break;
								case 4:
									A_Overlay( LAYER_ANIM, "Anim_Fire_Special4" );
									break;
								case 5:
									A_Overlay( LAYER_ANIM, "Anim_Fire_Special5" );
									break;
								default:
									A_Overlay( LAYER_ANIM, "Anim_Fire_Special1" );
									break;
							}
						}
						else
							A_Overlay( LAYER_ANIM, "Anim_Fire" );
					}
					else
						A_Overlay( LAYER_ANIM, "Anim_Fire" );
				}
			}
			#### # 0
			{
				if ( invoker.m_iSpecialChargeCount > 0 )
				{
					if ( invoker.m_iSpecialCharges > 0 )
					{
						switch ( invoker.m_iSpecialCharges )
						{
							case 2:
								A_Overlay( LAYER_SHOOT, "Shoot_Special2" );
								break;
							case 3:
								A_Overlay( LAYER_SHOOT, "Shoot_Special3" );
								break;
							case 4:
								A_Overlay( LAYER_SHOOT, "Shoot_Special4" );
								break;
							case 5:
								A_Overlay( LAYER_SHOOT, "Shoot_Special5" );
								break;
							default:
								A_Overlay( LAYER_SHOOT, "Shoot_Special1" );
								break;
						}
					}
					else
						A_Overlay( LAYER_SHOOT, "Shoot" );
				}
				else
				{
					A_Overlay( LAYER_SHOOT, "Shoot" );
				}
			}
			#### # 0
			{
				A_SetTics( ceil( invoker.m_fRefire ) - 1 );
			}
			#### # 0 A_JumpIf( !invoker.m_bAutoFire, "Aiming" );
			#### # 0 A_Refire();
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		
		Fire_Zoomed: // leave zoom state if this character shouldnt be in it
			TNT1 A 0
			{
				CK7_Smith( invoker.owner ).m_bZoomedIn = false;
				return ResolveState( "Fire" );
			}
		
		Altfire:
			#### # 0
			{
				let thinblood = invoker.FindInventory( "CK7_ThinBlood" );
				int iCount = min( invoker.m_iSpecialChargeCount, ( thinblood ? thinblood.Amount : 0 ) );
				if ( iCount > 0 )
				{
					invoker.m_iSpecialCharges++;
					if ( invoker.m_iSpecialCharges > iCount )
					{
						invoker.m_iSpecialCharges = 0;
					}
					EventHandler.SendInterfaceEvent(self.PlayerNumber(), "K7ChargeChanged");
					A_StartSound( "charge_tube" .. invoker.m_iSpecialCharges, CHAN_WEAPON, CHANF_OVERLAP );
				}
				return ResolveState( "Aiming" );
			}
		
		FlashA:
			#### # 0
			{
				switch( Random( 0, 2 ) )
				{
					case 0:
						return ResolveState( "Flash1" );
						break;
					case 1:
						return ResolveState( "Flash2" );
						break;
					case 2:
						return ResolveState( "Flash3" );
						break;
				}
				return ResolveState( null );
			}
		
		FlashB:
			#### # 0
			{
				switch( Random( 0, 2 ) )
				{
					case 0:
						return ResolveState( "Flash4" );
						break;
					case 1:
						return ResolveState( "Flash5" );
						break;
					case 2:
						return ResolveState( "Flash6" );
						break;
				}
				return ResolveState( null );
			}
		Flash1:
		Flash2:
		Flash3:
			Stop;
		
		Flash:
			#### # 2 bright
			{
				A_Light( 6 );
				A_SetBlend( "E6F63F", 0.25, 10 );
				A_OverlayFlags( OverlayID(), PSPF_RENDERSTYLE, true );
				A_OverlayFlags( OverlayID(), PSPF_FORCEALPHA, true );
				A_OverlayRenderStyle( OverlayID(), STYLE_Add );
				A_OverlayPivot ( OverlayID(), 0.5, 0.5 );
				double sc = frandom[sfx](0.8, 1.1);
				A_OverlayScale ( OverlayID(), sc, sc );
				double ang = frandom[sfx](-10, 10);
				A_OverlayRotate( OverlayID(), ang );
			}
			#### # 2 bright 
			{
				A_Light( 4 );
				A_OverlayAlpha( OverlayID(), 0.66 );
			}
			#### # 2 
			{
				A_OverlayAlpha( OverlayID(), 0.33 );
				A_Light( 2 );
			}
			#### # 0 A_Light( 0 );
			Stop;
		
		Reload:
			#### # 0 A_JumpIf( CK7_Smith( invoker.owner ).m_bAiming, "Aiming_Reload" );
			#### # 0
			{
				return ResolveState( "Standing_Reload" );
			}
		
		Aiming_Reload:
			#### # 5
			{
				A_Overlay( LAYER_ANIM, "Anim_Reload_Down" );
				A_SetTics( ceil( invoker.m_fReloadTime ) );
			}
			#### # 5
			{
				A_Overlay( LAYER_ANIM, "Anim_Reload_Up" );
			}
			#### # 0
			{
				invoker.m_iAmmo = invoker.m_iClipSize;
			}
			#### # 0 A_JumpIf( !invoker.m_bAutoFire, "Aiming" );
			#### # 0 A_Refire();
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		
		Standing_Reload:
			#### # 0
			{
				A_Overlay( LAYER_ANIM, "Anim_Standing_Reload" );
				A_SetTics( invoker.m_fReloadTimeStanding );
			}
			#### # 0
			{
				invoker.m_iAmmo = invoker.m_iClipSize;
				return ResolveState( "Ready" );
			}
		
		Shoot_Special1:
		Shoot_Special2:
		Shoot_Special3:
		Shoot_Special4:
		Shoot_Special5:
		Shoot:
			#### # 0
			{
				if ( invoker.m_iAmmo > 0 )
					invoker.m_iAmmo--;
				A_SetTics( ceil( invoker.m_fFireDelay ) );
			}
			#### # 1 
			{
				A_Overlay( LAYER_FUNC, "Fire_Bullet" );
				A_Overlay( LAYER_RECOIL, "Recoil" );
				A_AlertMonsters();
			}
			Stop;
		
		Fire_Bullet:
			#### # 0
			{
				A_FireBullets
				(
					invoker.m_fSpread,
					invoker.m_fSpread,
					-1,
					invoker.m_fDamage,
					"CK7_BulletPuff",
					BULLET_FLAGS
				);
			}
			Stop;
			
		
		Aim_Out:
			#### # 10
			{
				A_Overlay( LAYER_ANIM, null );
				A_ZoomFactor( 1, ZOOM_INSTANT );
				A_SetCrosshair( 1 );
				invoker.LookScale = 1;
				let smith = CK7_Smith( invoker.owner );
				smith.m_bAiming = false;
				smith.SetViewHeight( invoker.m_fHeight - 2.5 );
			}
			#### # 0
			{
				let smith = CK7_Smith( invoker.owner );
				smith.ApplyStats();
				return ResolveState( "Ready" );
			}
	}
}

Class CK7_Ammo : Ammo
{
	Default
	{
		+INVENTORY.IGNORESKILL;
		Inventory.Amount 1;
		Inventory.MaxAmount 255;
	}
}

class CK7_BulletPuff : BulletPuff
{
	Line hitLine;
	enum EHitTypes
	{
		HT_NONE,
		HT_WALL,
		HT_FLOOR,
		HT_CEILING,
	}
	static const Color puffColors[] = 
	{
		"956d00",
		"e0b94c",
		"d7812e",
		"8e4c0c",
		"693405"
	};

	Default
	{
		+PUFFGETSOWNER
		vspeed 0;
		height 4;
	}

	static CK7_BulletPuff SpawnPuff(vector3 p, Line hitLine = null)
	{
		let p = CK7_BulletPuff(Spawn('CK7_BulletPuff', p));
		if (p)
		{
			p.hitLine = hitLine;
		}
		return p;
	}

	void SpawnPuffEffects()
	{
		if (!target)
		{
			return;
		}
		FLineTraceData lt;
		Vector3 dir; bool success;
		[dir, success] = CK7_Utils.GetNormalFromPos(self, 128, target.angle, target.pitch, lt);
		if (!success)
		{
			return;
		}

		FSpawnParticleParams p;
		p.flags = SPF_FULLBRIGHT;
		p.startalpha = 1.0;
		p.pos = pos;
		p.vel = dir;
		for (int i = random[puffvis](20, 30); i > 0; i--)
		{
			p.color1 = puffcolors[random[puffvis](0, puffcolors.Size()-1)];
			p.lifetime = random[puffvis](20, 30);
			p.size = frandom[puffvis](8, 14);
			p.sizestep = -(p.size / p.lifetime);
			double v = 1.4;
			p.vel = (dir + (frandom[puffvis](-v, v), frandom[puffvis](-v, v), frandom[puffvis](-v, v))) * frandom[puffvis](2.5, 4);
			p.accel.xy = (p.vel.xy / -p.lifetime) * 0.5;
			p.accel.z = gravity * -0.5;
			Level.SpawnParticle(p);
		}
	}

	States
	{
	Spawn:
		AMRK A 1 bright NoDelay
		{
			if (!hitLine && blockingline)
			{
				hitline = blockingline;
			}
			SpawnPuffEffects();
		}
		stop;
	}
}