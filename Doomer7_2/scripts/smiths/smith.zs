#include "scripts/smiths/weapon.zs"
#include "scripts/smiths/p0_gar.zs"
#include "scripts/smiths/p1_dan.zs"
#include "scripts/smiths/p2_ked.zs"
#include "scripts/smiths/p3_kvn.zs"
#include "scripts/smiths/p4_cyo.zs"
#include "scripts/smiths/p5_con.zs"
#include "scripts/smiths/p6_msk.zs"
#include "scripts/smiths/p7_hay.zs"

const CHAN_WEAPON_CHARGE = CHAN_6;

Class CK7_Smith : DoomPlayer
{
	CK7_Hitscan Hitscan; //The LineTracer class
	bool 	m_bAimHeld;
	bool 	m_bSpecialPressed;
	bool 	m_bHealPressed;
	
	bool 	m_bAiming;
	bool	m_bZoomedIn;
	
	float 	m_fSpeed;
	float 	m_fSpeedFactor;
	float 	m_fCurrentSpeed;
	
	int 	m_iThinBlood;
	int 	m_iThickBlood;
	int		m_iThinBloodPart;
	
	float 	m_fHeight;
	
	int 	m_iStaticStartTime;
	
	Default
	{
		Player.WeaponSlot 1, "CK7_Smith_Gar_Wep";
		Player.WeaponSlot 2, "CK7_Smith_Dan_Wep";
		Player.WeaponSlot 3, "CK7_Smith_Ked_Wep";
		Player.WeaponSlot 4, "CK7_Smith_Kvn_Wep";
		Player.WeaponSlot 5, "CK7_Smith_Cyo_Wep";
		Player.WeaponSlot 6, "CK7_Smith_Con_Wep";
		Player.WeaponSlot 7, "CK7_Smith_Msk_Wep";
		Player.WeaponSlot 8, "CK7_Smith_Hay_Wep";
		Player.StartItem "CK7_Smith_Gar_Wep";
		/*Player.StartItem "CK7_Smith_Dan_Wep";
		Player.StartItem "CK7_Smith_Ked_Wep";
		Player.StartItem "CK7_Smith_Kvn_Wep";
		Player.StartItem "CK7_Smith_Cyo_Wep";
		Player.StartItem "CK7_Smith_Con_Wep";
		Player.StartItem "CK7_Smith_Msk_Wep";*/
		//Player.StartItem "CK7_Smith_Hay_Wep";
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_fHeight = 52;
		
		m_iStaticStartTime = 0;
		
		hitscan = new("CK7_Hitscan"); //create the class
		/*int sk = G_SkillPropertyInt( SKILLP_ACSReturn );
		if ( sk >= 4 )
		{
			A_SetInventory( "CK7_Smith_Hay_Wep", 1 );
		}*/
		
		ApplyStats();
	}
	
	override void PlayerThink()
	{
		Super.PlayerThink();
		
		int input = GetPlayerInput( MODINPUT_BUTTONS, AAPTR_DEFAULT );
		int input_old = GetPlayerInput( MODINPUT_OLDBUTTONS, AAPTR_DEFAULT );
		
		// Aim Button
		m_bAimHeld = ( input & BT_USER1 ) || ( !CVar.FindCVar( "k7_mode" ).GetBool() );
		
		// Special Button
		m_bSpecialPressed = ( input & BT_USER2 ) &~ ( input_old & BT_USER2 );
		
		// Heal Button
		m_bHealPressed = ( input & BT_USER3 ) &~ ( input_old & BT_USER3 );
		
		
		PPShader.SetUniform1i( "k7post", "static_timer", level.time - m_iStaticStartTime );
	}
	
	void ApplyStats()
	{
		ViewBob = 0.4;
		Height = m_fHeight;
		
		m_fSpeed = 1.5;
		m_fSpeedFactor = 1;
		SetSpeed( m_fSpeed );
	}
	
	void SetViewHeight( float new_height )
	{
		player.ViewHeight = new_height;
		ViewHeight = new_height;
		
		AttackZOffset = new_height - Height*0.5 - 2;
	}

	void SetSpeed( float new_speed )
	{
		m_fCurrentSpeed = ( new_speed * m_fSpeedFactor );
		forwardmove1 = m_fCurrentSpeed;
		sidemove1 = forwardmove1 * 0.975;
		forwardmove2 = forwardmove1 * 0.75;
		sidemove2 = sidemove1 * 0.75;
	}
	
	void SetStatic( bool on )
	{
		A_StopSound( CHAN_5 );
		if ( on )
		{
			A_StartSound( "weapon/statichard", CHAN_5, CHANF_LOOPING, 0.5 );
			m_iStaticStartTime = level.time;
		}
		PPShader.SetEnabled( "k7post", on );
		PPShader.SetUniform1i( "k7post", "resX", Screen.GetWidth() / 8 );
		PPShader.SetUniform1i( "k7post", "resY", Screen.GetHeight() / 8 );
	}

	/*States
	{
		Spawn:
			PLAY A -1;
			Loop;
		See:
			#### ABCD 4;
			Loop;
		Pain:
			#### # 4 A_Pain();
			goto See;
	}*/
}