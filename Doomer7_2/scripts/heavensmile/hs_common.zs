Class K7_HeavenSmile : Actor
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
		+JUMPDOWN
		+FLOORCLIP
		+DROPOFF
		+DONTGIB
		+FIXMAPTHINGPOS
		+NOBLOCKMONST
		+TELESTOMP
		+NOTELESTOMP
		MeleeRange 60;
		
		
		DropItem "K7_ThinBlood";
	}
	
	States
	{
		Spawn:
			HSC1 A 40;
			#### # 30 A_LoopActiveSound();
		Idle:
			#### # 1 A_LookEx( 0, 0, 500, 450, 360 );
			Loop;
		See:
			#### # 0 A_FaceTarget();
			#### # 0
			{
				A_StartSound( "hs_step", CHAN_BODY, CHANF_OVERLAP );
			}
			#### AAAAAAAAAAAAAAAAAAAAAAA 1 A_Chase( "Explode", null ); //2 A_Chase( "_a_chase_default", "_a_chase_default" );
			#### # 0 A_FaceTarget();
			#### # 0
			{
				A_StartSound( "hs_step", CHAN_BODY, CHANF_OVERLAP );
			}
			#### AAAAAAAAAAAAAAAAAAAAAAA 1 A_Chase(); //2 A_Chase( "_a_chase_default", "_a_chase_default" );
			Loop;
		Melee:
			#### # 0 A_FaceTarget();
			#### # 0
			{
				return ResolveState( "Explode" );
			}
		Pain:
			#### # 0 A_FaceTarget();
			#### # 0 A_Pain();
			#### # 15;
			#### # 0
			{
				Return ResolveState( "See" );
			}
		Death:
			#### # 8 A_Scream();
			#### # 8 A_StartSound( "hs_blood", CHAN_BODY, CHANF_OVERLAP );
			#### # 6;
			#### # 6 A_NoBlocking();
			#### # 70;
			#### # 28 A_StartSound( "hs_down", CHAN_BODY, CHANF_OVERLAP );
			#### # 0 A_StartSound( "hs_death", CHAN_BODY, CHANF_OVERLAP );
			TNT1 A 5 A_StartSound( "hs_laugh", CHAN_BODY, CHANF_OVERLAP );
			#### # 0 A_StartSound( "hs_disperse", CHAN_BODY, CHANF_OVERLAP );
			#### # -1 A_Remove( 0 );
			Stop;
		Explode:
			#### # 0 A_FaceTarget();
			#### # 8 bright A_StartSound( "hs_laugh", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 1 bright A_FaceTarget();
			#### # 1 A_Recoil( -1 );
			#### # 1 A_Recoil( -2 );
			#### # 6 A_Recoil( -3 );
			#### # 1 A_Recoil( -1 );
			#### # 0
			{
				invoker.Health = 0;
			}
			#### # 1 bright A_StartSound( "hs_trigger", CHAN_WEAPON, CHANF_OVERLAP );
			#### ###### 1 bright;
			#### # 0 A_Explode( 32, 300, XF_NOTMISSILE, false, 150 );
			#### # 0 A_StartSound( "hs_explode", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_StartSound( "hs_explosion", CHAN_WEAPON, CHANF_OVERLAP );
			TNT1 A -1 A_Remove( 0 );
			Stop;
	}
}

Class K7_SmileInvis : PowerupGiver
{
	Default
	{
		
	}
	
	
}