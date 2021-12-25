Class K7_SmithSyndicate_Weapon : Weapon
{
	Default
	{
		// Flags
		+WEAPON.NOALERT
		+WEAPON.NO_AUTO_SWITCH
		+WEAPON.NOAUTOAIM
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
		+WEAPON.NOAUTOFIRE
		// Stats
		Weapon.AmmoType1 "K7_Ammo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "K7_ThinBlood";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
	}
	
	// A_Overlay states for common usage
	States
	{
		Fire_Bullet:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				float spread = smith.m_fPersonaGunSpread;
				int damage = smith.m_iPersonaGunDamage;
				int flags = smith.m_iPersonaGunFlags;
				A_FireBullets( spread, spread, 1, damage, "NewBulletPuff", flags );
			}
			Stop;
		
		Reload_Start:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fnSetSpeed( smith.m_fPersonaSpeed_Reloading );
			}
			Stop;
		
		Reload_End:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fnSetSpeed( smith.m_fPersonaSpeed );
			}
			Stop;
		
		FormPersona:
			Stop;
		
		UseSpecial:
			Goto ChargeTube;
		
		ChangePersona:
			TNT1 A 0
			{
				let smith = SmithSyndicate( invoker.owner );
				smith.m_fnPersonaChangeBegin();
				A_SetTics( smith.m_iPersonaExplodeTime );
			}
			TNT1 A 0
			{
				SmithSyndicate( invoker.owner).m_fnPersonaChange();
			}
			TNT1 A 0
			{
				A_SetTics( SmithSyndicate( invoker.owner).m_iPersonaChangeTime );
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
							A_StartSound( "charge_tube_cancel", CHAN_7, CHANF_OVERLAP  );
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

Class K7_Ammo : Ammo
{
	Default
	{
		+INVENTORY.IGNORESKILL;
		Inventory.Amount 1;
		Inventory.MaxAmount 255;
	}
}