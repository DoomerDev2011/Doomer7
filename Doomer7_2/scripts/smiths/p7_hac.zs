Class CK7_Smith_Hac : CK7_Smith_Weapon
{	
	
	Default
	{
		Tag "GLIDER";
		Inventory.PickupMessage "You got the GLIDER!";
		Inventory.PickupSound "hac_pickup";
		CK7_Smith_Weapon.PersonaSoundClass 'k7_hay';
 		CK7_Smith_Weapon.Persona "hac";
 		CK7_Smith_Weapon.PersonaDamage 1000000;
		CK7_Smith_Weapon.PersonaCritical 10;
 		CK7_Smith_Weapon.PersonaRecoil 8;
 		CK7_Smith_Weapon.PersonaClipSize 1;
 		CK7_Smith_Weapon.PersonaRefireTime 70;
 		CK7_Smith_Weapon.PersonaViewHeight 0.4;
 		CK7_Smith_Weapon.PersonaHeight 32;
 		//CK7_Smith_Weapon.PersonaReloadTime 122.5;
	}
	
	override void DoEffect()
	{
		Super.DoEffect();
		if(owner)
		{
			if(owner.player.readyweapon == self)
			{
				CK7_Smith(owner).SetSpeed( 0 );
				
				Vector2 chairDir = AngleToVector(angle,1);
				if(owner.player.onground) 
					owner.vel.xy = owner.vel.xy*0.8 + chairDir * ( chairDir dot owner.vel.xy*0.2 ); //extra side friction
				
				Vector2 movedir = (owner.player.cmd.forwardmove, -owner.player.cmd.sidemove);
				if(movedir.x != 0 || movedir.y != 0)
				{
					movedir = rotateVector(movedir*0.00007, owner.angle);
					Double moveAngle = Vectorangle(movedir.x,movedir.y);
					if(chairDir dot movedir < -0.5) moveAngle += 180;
					
					Double TurnAng = DeltaAngle( Angle, moveAngle );
					TurnAng = clamp(TurnAng*0.9, -5, 5); //MaxTurn
					Angle += TurnAng;
					
					chairDir = AngleToVector(angle,1);
					
					if(owner.player.onground) 
						owner.vel.xy += chairDir * max(-0.4, chairDir dot movedir);
				}
			}
			else {
				angle = owner.angle;
			}
		}
	}
	
	States
	{
		Spawn:
			M000 A -1;
			stop;
			
		Shoot:
			#### # 0
			{
				A_SetTics(ceil(invoker.m_fFireDelay));
			}

			#### # 1
			{
				A_Overlay(
					LAYER_FUNC,
					"Fire_Bullet"
				);

				A_Overlay(
					LAYER_RECOIL,
					"Recoil"
				);

				A_AlertMonsters();
			}
			Stop;
		
		Recoil:
			TNT1 A 0;
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil * 0.2 );
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil *  0.1 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil *  0.2 );
			#### # 1 A_SetPitch( pitch - invoker.m_fRecoil *  0.15 );
			#### # 1 A_SetPitch( pitch + invoker.m_fRecoil *  0.05 );
			Stop;
		
		Flash1:
			HAFF A 0
			{
				return ResolveState( "Flash" );
			}
		
		Flash2:
			HAFF A 0
			{
				return ResolveState( "Flash" );
			}
		
		Flash3:
			HAFF A 0
			{
				return ResolveState( "Flash" );
			}
			
		Deselect:
			#### # 0
			{
				if (CK7_Smith( invoker.owner ).m_bZoomedIn){
					A_ZoomFactor( 1 );
					CK7_Smith( invoker.owner ).SetStatic( false );
					CK7_Smith( invoker.owner ).m_bZoomedIn = false;
					A_StartSound( invoker.m_sPersona .. "_zoomout", CHAN_WEAPON, CHANF_OVERLAP );
				}
			}
			goto super::Deselect;
			
			
		Reload:
			TNT1 A 0
			{
				if (CK7_Smith(invoker.owner).m_bZoomedIn)
				{
					return ResolveState("Aiming_Zoomed");
				}

				if (CK7_Smith(invoker.owner).m_bAiming)
				{
					return ResolveState("Aiming");
				}

			return ResolveState("Ready");
			}
		
		AltFire:
			TNT1 A 0;
			#### # 0 A_JumpIf( CK7_Smith( invoker.owner ).m_bZoomedIn, "Zoom_Out" );
			Goto Zoom_In;
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		
		Zoom_In:
			TNT1 A 0;
			#### # 0 A_ZoomFactor( 6 );
			#### # 0 A_Overlay( LAYER_ANIM, "Anim_Zoom_In" );
			#### # 0
			{
				CK7_Smith( invoker.owner ).SetStatic( true );
			}
			#### # 15;
			#### # 0
			{
				CK7_Smith( invoker.owner ).m_bZoomedIn = true;
			}
			Goto Aiming_Zoomed;
		
		Aiming_Zoomed:
			TNT1 A 0;
			#### # 0 A_JumpIf( !( CK7_Smith( invoker.owner ).m_bAimHeld ), "Aim_Out" );
			#### # 1 A_WeaponReady( ( k7_mode ) ? AIMING_FLAGS : AIMING_FLAGS &~ WRF_DISABLESWITCH );
			Loop;
		
		Zoom_Out:
			TNT1 A 0;
			#### # 0 A_ZoomFactor( 1 );
			#### # 0
			{
				CK7_Smith( invoker.owner ).SetStatic( false );
			}
			#### # 0
			{
				CK7_Smith( invoker.owner ).m_bZoomedIn = false;
			}
			#### # 0 A_Overlay( LAYER_ANIM, "Anim_Zoom_Out" );
			#### # 15;
			#### # 0
			{
				return ResolveState( "Aiming" );
			}
		
		Anim_Aim_In:
	TNT1 A 70 A_StartSound("hac_equip", CHAN_WEAPON, CHANF_OVERLAP);
	HACF A 2 bright K7_WeaponOffset(0, 36);
	HACF B 2 bright K7_WeaponOffset(0, 35.75, WOF_INTERPOLATE);
	HACF C 2 bright K7_WeaponOffset(0, 35.5, WOF_INTERPOLATE);
	HACF D 2 bright K7_WeaponOffset(0, 35.25, WOF_INTERPOLATE);
	HACF E 2 bright K7_WeaponOffset(0, 35, WOF_INTERPOLATE);
	HACF F 2 bright K7_WeaponOffset(0, 34.75, WOF_INTERPOLATE);
	HACF G 2 bright K7_WeaponOffset(0, 34.5, WOF_INTERPOLATE);
	HACF H 2 bright K7_WeaponOffset(0, 34.25, WOF_INTERPOLATE);
	HACF I 2 bright K7_WeaponOffset(0, 34, WOF_INTERPOLATE);
	HACF J 2 bright K7_WeaponOffset(0, 33.75, WOF_INTERPOLATE);
	HACF K 2 bright K7_WeaponOffset(0, 33.5, WOF_INTERPOLATE);
	HACF L 2 bright K7_WeaponOffset(0, 33.25, WOF_INTERPOLATE);
	HACF M 2 bright K7_WeaponOffset(0, 33, WOF_INTERPOLATE);
	HACF N 2 bright K7_WeaponOffset(0, 32.75, WOF_INTERPOLATE);
	HACF O 2 bright K7_WeaponOffset(0, 32.5, WOF_INTERPOLATE);
	HACF P 2 bright K7_WeaponOffset(0, 32.25, WOF_INTERPOLATE);
	HACF Q 2 bright K7_WeaponOffset(0, 32.1, WOF_INTERPOLATE);
	HACF R 2 bright K7_WeaponOffset(0, 32, WOF_INTERPOLATE);

	Goto Anim_Aiming;
		
		Anim_Aiming:
			HACF R 1 bright
			{
				float offx = sin( level.time * 3 ) * 2.3 ;
				float offy = 1 + sin( level.time * 6 ) * 0.5;
				K7_WeaponOffset( offx, 32 + offy, WOF_INTERPOLATE );
			}
			Loop;
			
		Anim_Zoom_In:
			HACF R 0;
			#### # 0 A_StartSound( "hac_zoomin", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright K7_WeaponOffset ( 0, 32, 0 );
			#### # 1 bright K7_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 128, 32 + 256, WOF_INTERPOLATE );
			Goto Anim_Zoomed;
			
		Anim_Zoomed:
			TNT1 A 1 bright;
			
			Loop;
		
		Anim_Fire_Zoomed:
			TNT1 A 0;
			#### # 0 A_StartSound("hac_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_SetBlend( "E6F63F", 0.25, 10 );
			#### # 2 A_Light( 6 );
			#### # 2 A_Light( 4 );
			#### # 2 A_Light( 2 );
			#### # 2 A_Light( 0 );
			Goto Anim_Zoomed;
		
		Anim_Zoom_Out:
			HACF R 0;
			#### # 0 A_StartSound( invoker.m_sPersona .. "_zoomout", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright K7_WeaponOffset ( 128, 32 + 256, 0 );
			#### # 1 bright K7_WeaponOffset ( 32, 32 + 64, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 8, 32 + 16, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 2, 32 + 4, WOF_INTERPOLATE );
			#### # 1 bright K7_WeaponOffset ( 0, 32, WOF_INTERPOLATE );
			Goto Anim_Aiming;
		
		
		Anim_Fire:
			HACF R 0;
			#### # 0 K7_WeaponOffset( 0, 32 );
			#### # 0 A_StartSound( invoker.m_sPersona .. "_shoot", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Overlay( LAYER_FLASH, "FlashA" );
			Goto Anim_Aiming;
		
	}
}