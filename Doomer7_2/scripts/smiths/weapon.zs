Class CK7_Smith_Weapon : Weapon abstract
{
	const READY_FLAGS = ( WRF_ALLOWRELOAD | WRF_NOPRIMARY | WRF_NOSECONDARY | WRF_NOBOB );
	const AIMING_FLAGS = ( WRF_ALLOWRELOAD | WRF_DISABLESWITCH );
	const BULLET_FLAGS = ( FBF_USEAMMO | FBF_NORANDOMPUFFZ );
	
	enum ELayerNumbers
	{
		LAYER_BARS 		= 54,
		LAYER_ANIM 		= 2,
		LAYER_FUNC 		= -1,
		LAYER_RECOIL 	= -2,
		LAYER_SHOOT 	= -3,
		LAYER_FLASH 	= -5,
		LAYER_SPECIAL 	= -6,
		LAYER_LEFTGUN	= -10,
		LAYER_RIGHTGUN	= -11,
	}
	
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
	int 	m_WideSpriteOffset;
	property UltrawideOffset : m_WideSpriteOffset;
	
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
		if (bTossed)
		{
			Destroy();
			return;
		}
		
		m_iAmmo = m_iClipSize;
	}
	
	Default
	{
		+WEAPON.NOAUTOFIRE
		+WEAPON.NOALERT
		//+WEAPON.NO_AUTO_SWITCH
		+WEAPON.NOAUTOAIM
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.RESTRICTABSOLUTELY
		
		/*Weapon.AmmoType1 "CK7_Ammo";
		Weapon.AmmoUse1 0;
		Weapon.AmmoType2 "CK7_ThinBlood";
		Weapon.AmmoUse2 0;*/
		Weapon.KickBack 0;
		Weapon.BobSpeed -2;
		Weapon.BobRangeX 0.1;
		Weapon.BobRangeY 1;
		CK7_Smith_Weapon.PersonaSoundClass "player";
		CK7_Smith_Weapon.UltrawideOffset 74;
	}
	
	virtual Vector2 K7_AdjustLayerOffsets(double x, double y, int layer = 0)
	{
		if (m_WideSpriteOffset != 0)
		{
			double aspect = Screen.GetAspectRatio();
			double of = m_WideSpriteOffset;
			double xofs = CK7_Utils.LinearMap(aspect, 1.777, 2.37, 0, of, true);
			x += xofs;
		}
		return (x,y);
	}
	
	action void K7_WeaponOffset(double x, double y, int flags = 0)
	{
		K7_OverlayOffset(PSP_WEAPON, x, y, flags);
	}
	
	action void K7_OverlayOffset(int layer, double x, double y, int flags = 0)
	{
		let ofs = (x,y);
		if (!(flags & WOF_ADD))
		{
			ofs = invoker.K7_AdjustLayerOffsets(x, y, layer);
		}
		A_OverlayOffset(layer, ofs.x, ofs.y, flags);
	}

	action void K7_WeaponReady(int flags = 0)
	{
		//Console.Printf("Calling \cDK7_WeaponReady()\c- from \cY%s\c-, layer \cY%d\c-", invoker.GetClassName(), OverlayID());
		if (!player) 
			return;
		
		if ((player.cmd.buttons & BT_ALTATTACK) && !(player.oldbuttons & BT_ALTATTACK))
		{
			int iCount = min( invoker.m_iSpecialChargeCount, CountInv('CK7_ThinBlood') );
			if ( iCount > 0 )
			{
				invoker.m_iSpecialCharges++;
				if ( invoker.m_iSpecialCharges > iCount )
				{
					invoker.m_iSpecialCharges = 0;
				}
				EventHandler.SendInterfaceEvent(self.PlayerNumber(), "K7ShowHudPanel");
				A_StartSound( "charge_tube" .. invoker.m_iSpecialCharges, CHAN_WEAPON, CHANF_OVERLAP );
				return;
			}
		}

		DoReadyWeaponToSwitch(player, !(flags & WRF_NoSwitch));
		
		if ((flags & WRF_NoFire) != WRF_NoFire)
		{
			DoReadyWeaponToFire(player.mo, !(flags & WRF_NoPrimary), !(flags & WRF_NoSecondary));
		}
		
		// Don't modify offsets:
		if (player.ReadyWeapon && !(flags & WRF_NoBob))
		{
			// Prepare for bobbing action.
			player.WeaponState |= WF_WEAPONBOBBING;
		}

		player.WeaponState |= GetButtonStateFlags(flags);
		DoReadyWeaponDisableSwitch(player, flags & WRF_DisableSwitch);
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

	override bool CanPickup(Actor toucher)
	{
		if (!toucher || !(toucher is 'CK7_Smith'))
		{
			return false;
		}
		return Super.CanPickup(toucher);
	}

	override void PlayPickupSound (Actor toucher)
	{
		int flags = CHANF_MAYBE_LOCAL|CHANF_OVERLAP;
		if (toucher && toucher.CheckLocalView())
		{
			flags |= CHANF_NOPAUSE;
		}
		toucher.A_StartSound(PickupSound, CHAN_AUTO, flags, 1, ATTN_NORM);
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
		
		/*let p = owner.player.FindPSprite(PSP_WEAPON);
		if (p)
		{
			Console.Printf("PSP_WEAPON ofs: %.1f,%.1f", p.x, p.y);
		}*/

		UpdateSoundClass();
		UpdateCrosshair(weap);
	}
	
	States
	{
		Select:
			TNT1 A 1 K7_WeaponOffset( 0, 32 );
			#### # 0
			{
				if ( k7_mode )
				{
					invoker.m_iAmmo = invoker.m_iClipSize;
				}
				let smith = CK7_Smith( invoker.owner );
				smith.ApplyStats();
				//smith.SetSpeed( invoker.m_fSpeed );
				smith.SetViewHeight( invoker.m_fHeight - 2.5 );
				invoker.m_iSpecialCharges = 0;
				return ResolveState( "Ready" );
			}
		Ready:
			TNT1 A 1 A_JumpIf( ( CK7_Smith( invoker.owner ).m_bAimHeld ) , "Aim_In" );
			loop;
			
		Deselect:
			TNT1 # 0
			{
				CK7_Smith( invoker.owner ).m_bZoomedIn = false;
				A_ClearOverlays(2, 1000);
				A_ClearOverlays(-1000, -2);
			}
			#### # 0 A_Lower;
			wait;
			
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
				if ( k7_mode )
				{
					Thing_Stop( 0 );
					CK7_Smith( invoker.owner ).SetSpeed( 0 );
				}
			}
			#### # 5;
			#### # 0
			{
				if ( k7_mode )
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
			#### # 1 K7_WeaponReady( ( k7_mode ) ? AIMING_FLAGS : AIMING_FLAGS &~ WRF_DISABLESWITCH );
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
			#### # 1 bright
			{
				A_Light( 3 );
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
			#### # 1 bright 
			{
				A_Light( 1 );
				A_OverlayAlpha( OverlayID(), 0.6 );
				let psp = player.FindPSprite(OverlayID());
				if (psp)
				{
					psp.scale *= 1.1;
				}
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
		Decal 'BulletChip';
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
		TNT1 A 1 bright NoDelay SpawnPuffEffects();
		stop;
	}
}