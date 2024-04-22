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
	float	m_fCritical;
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
	uint 	m_doChargeDelay;

	property Persona 					: m_sPersona;
	property PersonaSpeed 				: m_fSpeed;
	property PersonaDamage				: m_fDamage;
	property PersonaCritical			: m_fCritical;
	property PersonaSpread 				: m_fSpread;
	property PersonaFireDelay 			: m_fFireDelay;
	property PersonaRecoil 				: m_fRecoil;
	property PersonaClipSize 			: m_iClipSize;
	property PersonaRefireTime 			: m_fRefire;
	property PersonaHeight 				: m_fHeight;
	property PersonaViewHeight 			: m_fViewHeight;
	property PersonaReloadTime 			: m_fReloadTime;
	property PersonaReloadTimeStanding 	: m_fReloadTimeStanding;
	property PersonaSpecialFactor 		: m_fSpecialFactor;
	property PersonaSpecialDuration 	: m_fSpecialDuration;
	property PersonaCharges 			: m_iSpecialChargeCount;
	
	void AimingBreathe()
	{
		
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_iPersona = slotnumber;
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

		CK7_Smith_Weapon.Persona "none";
		CK7_Smith_Weapon.PersonaDamage 40;
		CK7_Smith_Weapon.PersonaCritical 8;
		CK7_Smith_Weapon.PersonaSpeed 1.0;
		CK7_Smith_Weapon.PersonaSpread 0.2;
		CK7_Smith_Weapon.PersonaRecoil 2.5;
		CK7_Smith_Weapon.PersonaClipSize 6;
		CK7_Smith_Weapon.PersonaRefireTime 15;
		CK7_Smith_Weapon.PersonaViewHeight 0.8;
		CK7_Smith_Weapon.PersonaHeight 52;
		CK7_Smith_Weapon.PersonaReloadTime 42;
		CK7_Smith_Weapon.PersonaReloadTimeStanding 70;
		CK7_Smith_Weapon.PersonaSpecialFactor 1;
		CK7_Smith_Weapon.PersonaSpecialDuration 1;
		
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
		if (!player) 
			return;
		
		// the m_doChargeDelay was added mostly to fix an obscure Kevin
		// bug that for some reason triggered this twice despite the
		// oldbuttons check. Maybe K7_WeaponReady was being called again?
		// in any case, this is a useful safeguard.
		if ((player.cmd.buttons & BT_ALTATTACK) && !(player.oldbuttons & BT_ALTATTACK) && invoker.m_doChargeDelay <= 0)
		{
			int iCount = min( invoker.m_iSpecialChargeCount, CountInv('CK7_ThinBlood') );
			if ( iCount > 0 )
			{
				invoker.m_doChargeDelay = 3;
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
		if (!(flags & WRF_NoBob))
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
	
	Action Void K7_FireBullet(int damage, double spread, double crit = 8, bool bleed = false)
	{
		//access the LineTracer class from the player, if there isnt one make it
		If(!CK7_Smith(self).hitscan) CK7_Smith(self).hitscan = new("CK7_Hitscan");
		CK7_Hitscan HitScan = CK7_Smith(self).hitscan;// cast pointer to just type "Hitscan"
		Hitscan.master = self; //the player, so it doesn't hit them
		Hitscan.victim = null; //reset these variables before the shot
		Hitscan.crit = false;
		Hitscan.crosshit.clear();
		
		//this next part is to have circular spread and to fix that bug where horizontal spread gets thinner when you look up or down
		//if you just want it simple use randomize the angles on the else block
		Vector3 dir;
		double pch = BulletSlope(); // Get the autoaimed pitch
		If(spread)
		{
			vector2 Spr = AngleToVector(Frandom(0,360),spread*Frandom(0,1));
			Quat base = Quat.FromAngles(angle, pch, roll);
			Vector3 forward = (1,0,0);
			Quat ofs = Quat.AxisAngle((0,0,1), Spr.x);
			Quat sid = Quat.AxisAngle((0,1,0), Spr.y);
			dir = base * ofs * sid * forward;
		}
		else 
		{
			dir = (cos(angle)*cos(pch), sin(angle)*cos(pch), sin(-pch));
		}
		
		//↓ this start is the default attack height
		//vector3 Start = Pos + (0,0,height * 0.5 + player.mo.AttackZOffset*player.crouchFactor ); 
		//↓ this one makes it fire exactly where your view is, true to the crosshair
		vector3 Start = (pos.x,pos.y,player.viewz); 
		
		Hitscan.Trace(Start, CurSector, Dir, 9000, TRACE_HitSky);
		
		Actor puff = Spawn("CK7_BulletPuff",hitscan.results.hitpos - hitscan.results.hitvector);
		Puff.Angle = atan2(dir.y, dir.x); //VectorAngle( Dir.x, Dir.y );
		Puff.Pitch = -asin(dir.z); //-VectorAngle( ( Dir.xy.length(),Dir.z) );
		puff.target = self;
		If(Hitscan.victim)
		{
			Int damg = damage*Frandom(2,3);
			if(hitscan.crit) 
			{
				damg = damage*crit;
				if(hitscan.victim.default.health <= 150) damg = Max(damg,hitscan.victim.default.health*3);
				puff.bNOEXTREMEDEATH = false;
				If(hitscan.victim.health - damg <= 0) A_StartSound("*taunt",2,CHANF_NOSTOP);
				//CK7_CritVoiceLine(New("CK7_CritVoiceLine")).Player = Self;
				hitscan.victim.A_StartSound("hs_death",12,CHANF_OVERLAP,1,0);
			}
			puff.SetOrigin(Hitscan.landpos,false);
			float vicheight = hitscan.victim.height;
			Int Ouch = Hitscan.victim.DamageMobj(puff,self,damg,"Hitscan",DMG_INFLICTOR_IS_PUFF|DMG_PLAYERATTACK,puff.angle);
			If(Ouch && Hitscan.victim && !Hitscan.victim.bNOBLOOD) 
			{
				Hitscan.victim.SpawnBlood(Hitscan.Landpos,puff.angle,Ouch);
				If(bleed){
					Actor Blud = actor.Spawn("K7_BloodSpew",Hitscan.Landpos);
					Vector3 dist = Blud.Pos - hitscan.victim.pos ;
					Blud.master = hitscan.victim;
					Blud.Health = Min(ouch,120);
					Blud.Speed = dist.xy.length();
					Blud.SpriteAngle = VectorAngle( dist.x, dist.y ) - hitscan.victim.angle;
					Blud.FloatSpeed  = dist.z/vicheight;
					Blud.Pitch = -puff.pitch;
				}
			}
			puff.setstatelabel("null");
		}
		else 
		{
			if (hitscan.results.HitType == TRACE_HasHitSky) puff.setstatelabel("null");
			for(int l; l < Hitscan.crosshit.Size(); l++ )
			{
				Hitscan.crosshit[l].Activate(self, 0, SPAC_Impact);
			}
			puff.A_SprayDecal("BulletChip",30,(0,0,-0.5),hitscan.results.HitVector);
		}
	}

	// debug function
	string GetLayerName(int id)
	{
		String str;
		switch (id)
		{
		case PSP_WEAPON: str = "PSP_WEAPON"; break;
		case LAYER_BARS: str = "LAYER_BARS"; break;
		case LAYER_ANIM: str = "LAYER_ANIM"; break;
		case LAYER_FUNC: str = "LAYER_FUNC"; break;
		case LAYER_RECOIL: str = "LAYER_RECOIL"; break;
		case LAYER_SHOOT: str = "LAYER_SHOOT"; break;
		case LAYER_FLASH: str = "LAYER_FLASH"; break;
		case LAYER_SPECIAL: str = "LAYER_SPECIAL"; break;
		case LAYER_LEFTGUN: str = "LAYER_LEFTGUN"; break;
		case LAYER_RIGHTGUN: str = "LAYER_RIGHTGUN"; break;
		default: str = "#"..id;
		}
		return str;
	}

	override void DoEffect()
	{
		Super.DoEffect();
		if (!owner || !owner.player)
		{
			return;
		}
		if (m_doChargeDelay > 0)
		{
			m_doChargeDelay--;
		}
		let weap = owner.player.readyweapon;
		if (!weap || weap != self)
		{
			return;
		}
		UpdateSoundClass();
		UpdateCrosshair(weap);
		
		if (!k7_pspreport)
			return;
		String info = String.Format("Active \cY%s\c- PSprites:\n", self.GetTag());
		for (let psp = owner.player.psprites; psp; psp = psp.next)
		{
			if (!psp)
				continue;

			String str = String.Format("\cd%s\c-", GetLayerName(psp.id));
			info = String.Format("%s%s\n", info, str);
		}
		Console.MidPrint(smallfont, info);
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
				//if(Invoker.CanCrit)
				//{
					K7_FireBullet(invoker.m_fDamage,invoker.m_fSpread,invoker.m_fCritical);
				/*}
				else
				{
					A_FireBullets
					(
						invoker.m_fSpread,
						invoker.m_fSpread,
						-1,
						invoker.m_fDamage*Frandom(2,3),
						"CK7_BulletPuff",
						BULLET_FLAGS|FBF_NORANDOM
					);
				}*/
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
		+NOEXTREMEDEATH
		vspeed 0;
		height 4;
		Decal 'BulletChip';
		ProjectileKickback 100;
		
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

class CK7_Hitscan : LineTracer
{
	actor Master; //the one who fire it
	actor victim; //who got hit
	Vector3 LandPos; //the first landing position
	bool Crit; //if it hit a crit spot
	array<line> Crosshit; //dynamic array containing lines with attack hit trigger
	
    override ETraceStatus TraceCallback()
    {
		//when it hits an actor that isnt the player
        if (results.HitType == TRACE_HitActor && results.HitActor != Master)
        {
			Crit = false;
			If(results.HitActor is "CK7_HS_CritSpot" && results.HitActor.master.bSHOOTABLE) 
			{
				If(victim && victim != results.HitActor.master) Return TRACE_Stop;
				Crit = true;
				victim = results.HitActor.master;
				LandPos = results.HitPos;
				Return TRACE_Stop;
			}
			If(results.HitActor.bSHOOTABLE) 
			{
				If(victim) Return TRACE_Stop;
				victim = results.HitActor;
				LandPos = results.HitPos;
				return TRACE_Skip; //passes through to try to hit its critspot
			}
			return TRACE_Skip;
        }
		else if (victim) //if it hits anything else after already hitting a victim
		{
			Return TRACE_Stop;
		}
		
		If (results.HitType == Trace_HitFloor || results.HitType == Trace_HitCeiling
			|| results.HitType == TRACE_HasHitSky)
		{	
			Return TRACE_Stop;
		}
		
		If (results.HitLine)
		{
			If (results.HitLine.activation & SPAC_Impact) crosshit.push(results.HitLine);
			If (results.Tier != TIER_Middle || results.HitLine.Sidedef[Line.Back] == Null || BlockingLineInTheWay(results.HitLine,BLITW_HitscansOnly) )
			{
				Return TRACE_Stop;
			}
		}
		
        return TRACE_Skip;
    }
	
	
	//these next functions are from inkoalawetrust on discord
	Enum BLITWFlags
	{
		BLITW_HitscansToo 	= 1 << 0,	//Check for hitscan blocking lines too.
		BLITW_HitscansOnly	= 1 << 1	//Check ONLY for hitscan blocking lines.
	}
	
	//Is the line the trace went through blocking ?
	Bool BlockingLineInTheWay (Line Blocking, Int Flags)
	{
		If (!Blocking) Return False;
		
		//Stop at sight blocking lines (Can't see past them) and everything-blocking lines.
		If (Blocking.Flags & Line.ML_BLOCKEVERYTHING || Blocking.Flags & Line.ML_BLOCKSIGHT)
			Return True;
		
		If (!Flags)
			If (Blocking.Flags & Line.ML_BLOCKPROJECTILE)
				Return True;
		Else If (Flags & BLITW_HitscansToo)
			If (Blocking.Flags & (Line.ML_BLOCKPROJECTILE | Line.ML_BLOCKHITSCAN))
				Return True;
		Else If (Flags & BLITW_HitscansOnly)
			If (Blocking.Flags & Line.ML_BLOCKHITSCAN)
				Return True;
		
		Return False;
	}
	
	//Check if the trace hit any level geometry. This is very useful for all LOF checks, except if the projectile can literally go through level geometry.
	//BUG: This check fails on 3D floors with FF_THINFLOOR. This however seems to be a GZDoom bug. And I'm not knowledgeable enough to PR a fix lol.
	//: Check for collision with non-shoot through 3D middle textures. The only method for doing this is not exposed to ZScript, so I need to PR it at some point.
	Bool HitLevelGeometry (TraceResults Result)
	{
		//Hit a floor or ceiling.
		If (Result.HitType == Trace_HitFloor || Result.HitType == Trace_HitCeiling)
			Return True;
		
		If (Result.HitLine)
		{
			//Hit a linedef with void space behind it.
			If (Result.HitLine.Sidedef[Line.Back] == Null)
				Return True;
			
			//Hit a raised floor or lowered ceiling wall.
			If (Result.Tier != TIER_Middle)
				Return True;
		}
		
		Return False;
	}
}
Class CK7_CritVoiceLine : Thinker
{
	Actor Player;
	Int Count;
	
	Override void Tick()
	{
		If(Player)
		{
			Count++;
			If(count>20) {
				Player.A_StartSound("*taunt",2,CHANF_NOSTOP);
				Destroy();
			}
		}
		else Destroy();
	}
}
