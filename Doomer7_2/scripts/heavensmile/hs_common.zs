#include "scripts/heavensmile/hs_fast.zs"
//#include "scripts/heavensmile/replace.zs"

Class CK7_HeavenSmile : Actor
{
	Default
	{
		SeeSound "hs_snicker";
		PainSound "hs_hurt";
		DeathSound "hs_laugh";
		ActiveSound "hs_alert";
		
		Health 175;
		Radius 12;
		Height 52;
		Speed 1.75;
		Mass 175;
		PainChance ( 256 );
		Monster;
		MinMissileChance 0;
		MeleeRange 20;
		MaxTargetRange 30;
		
		+JUMPDOWN
		+FLOORCLIP
		//+NODROPOFF
		//+DROPOFF
		+DONTGIB
		+FIXMAPTHINGPOS
		+NOBLOCKMONST
		+TELESTOMP
		+NOTELESTOMP
		+LOOKALLAROUND
		
		DropItem "CK7_ThinBlood";
	}
	
	float m_fBlood;
	
	States
	{
		Spawn:
			HSC1 A 40;
			#### # 30 A_LoopActiveSound();
		Idle:
			#### # 1 A_LookEx( 0, 0, 750, 0 );
			Loop;
		See:
			#### # 25 A_FaceTarget();
		Pursue:
			#### # 0 A_FaceTarget();
			#### # 0
			{
				A_StartSound( "hs_step", CHAN_BODY, CHANF_OVERLAP );
			}
			#### AAAAAAAAAAAAAAAAAAAAAAA 1 A_Chase();
			#### # 0 A_FaceTarget();
			#### # 0
			{
				A_StartSound( "hs_step", CHAN_BODY, CHANF_OVERLAP );
			}
			#### AAAAAAAAAAAAAAAAAAAAAAA 1 A_Chase();
			Loop;
		Melee:
			#### # 0 A_FaceTarget();
			#### # 8 bright A_StartSound( "hs_laugh", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_FaceTarget();
			#### # 8 A_ChangeVelocity ( 4, 0, 0, CVF_RELATIVE|CVF_REPLACE );
			#### # 0 Thing_Stop( 0 );
			#### # 1 bright A_StartSound( "hs_trigger", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 4 bright;
			#### # 0 A_Explode( 30, 250, XF_NOTMISSILE, false, 250 );
			#### # 0 A_StartSound( "hs_explode", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_StartSound( "hs_explosion", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Remove( AAPTR_DEFAULT  );
			Stop;
		Pain:
			#### # 0 A_FaceTarget();
			#### # 0 A_Pain();
			#### # 6;
			#### # 0
			{
				Return ResolveState( "See" );
			}
		Death:
			#### # 0 Thing_Stop( 0 );
			#### # 8 A_Scream();
			#### # 8 A_StartSound( "hs_blood", CHAN_BODY, CHANF_OVERLAP );
			#### # 6;
			#### # 6 A_NoBlocking();
			#### # 70;
			#### # 0 A_StartSound( "hs_down", CHAN_BODY, CHANF_OVERLAP );
			#### # 0 // Delay before dispersing
			{
				
			}
			#### # 0 A_StartSound( "hs_death", CHAN_BODY, CHANF_OVERLAP );
			TNT1 A 0 A_StartSound( "hs_laugh", CHAN_BODY, CHANF_OVERLAP );
			#### # 0 A_StartSound( "hs_disperse", CHAN_BODY, CHANF_OVERLAP );
			#### # 0
			{
				return ResolveState( "Null" );
			}
			Stop;
	}
}