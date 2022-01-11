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

Class K7_Smith : DoomPlayer
{
	Default
	{
		Player.StartItem "K7_Smith_Gar_Wep";
		Player.StartItem "K7_Smith_Dan_Wep";
		Player.StartItem "K7_Smith_Ked_Wep";
		Player.StartItem "K7_Smith_Kvn_Wep";
		Player.StartItem "K7_Smith_Cyo_Wep";
		Player.StartItem "K7_Smith_Con_Wep";
		Player.StartItem "K7_Smith_Msk_Wep";
	}
	
	override void BeginPlay()
	{
		Super.BeginPlay();
		m_fHeight = 52;
		
		int sk = G_SkillPropertyInt( SKILLP_ACSReturn );
		if ( sk >= 4 )
		{
			A_SetInventory( "K7_Smith_Hay_Wep", 1 );
		}
		
		m_fnApplyStats();
	}
	
	override void Tick()
	{
		Super.Tick();
		
		int input = GetPlayerInput( MODINPUT_BUTTONS, AAPTR_DEFAULT );
		int input_old = GetPlayerInput( MODINPUT_OLDBUTTONS, AAPTR_DEFAULT );
		
		// Aim Button
		m_bAimHeld = (  input & BT_USER1 ) || ( !CVar.FindCVar( "k7_mode" ).GetBool() );
		
		// Special Button
		m_bSpecialPressed = ( input & BT_USER2 ) &~ ( input_old & BT_USER2 );
		
		// Heal Button
		m_bHealPressed = ( input & BT_USER3 ) &~ ( input_old & BT_USER3 );
		
	}

	bool 	m_bAimHeld;
	bool 	m_bSpecialPressed;
	bool 	m_bHealPressed;
	
	bool 	m_bAiming;
	
	float 	m_fSpeed;
	float 	m_fSpeedFactor;
	float 	m_fCurrentSpeed;
	
	int 	m_iThinBlood;
	int 	m_iThickBlood;
	
	float 	m_fHeight;
	
	void m_fnApplyStats()
	{
		ViewBob = 0.4;
		Height = m_fHeight;
		
		m_fSpeed = 1;
		m_fSpeedFactor = 1;
		m_fnSetSpeed( m_fSpeed );
		
	}
	
	void m_fnSetViewHeight( float new_height )
	{
		player.ViewHeight = new_height;
		ViewHeight = new_height;
		
		float mid = ( Height / 2 );
		AttackZOffset = ViewHeight - mid;
		
	}

	void m_fnSetSpeed( float new_speed )
	{
		m_fCurrentSpeed = new_speed;
		forwardmove1 = m_fCurrentSpeed;
		sidemove1 = forwardmove1 * 0.65;
		forwardmove2 = forwardmove1 * 0.5;
		sidemove2 = sidemove1 * 0.5;
	}

	States
	{
		Spawn:
			PLAY A -1;
			Loop;
		See:
			#### ABCD 4;
			Loop;
		Pain:
			#### # 4 A_Pain();
			
		
	}
}