Class K7_HeavenSmile : Actor
{
	Default
	{
		-NODROPOFF
		SeeSound "hs_snicker";
		PainSound "hs_hurt";
		DeathSound "hs_laugh";
		ActiveSound "";
		
		Health 175;
		Radius 20;
		Height 50;
		Speed 4;
		PainChance ( 100 );
		Monster;
		+FLOORCLIP
		MeleeRange 80;
		
		DropItem "K7_ThinBlood";
	}
	
	States
	{
		Spawn:
			TROO AB 10 A_StartSound( "hs_alert", CHAN_6, CHANF_LOOP );
		Idle:
			#### # 1 A_Look();
			Loop;
		See:
			#### # 0;
			#### AAABBBCCCDDD 2 A_Chase( "_a_chase_default", "_a_chase_default" );
			Loop;
		Melee:
			#### # 17 bright A_StartSound( "hs_laugh", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0
			{
				return ResolveState( "Explode" );
			}
		Pain:
			TROO H 2;
			TROO H 8 A_Pain();
			#### # 0
			{
				Return ResolveState( "See" );
			}
		Death:
			#### # 0 A_StopSound( CHAN_6 );
			TROO I 8;
			TROO J 8 A_Scream();
			TROO K 6;
			TROO L 6 A_NoBlocking();
			TROO M -1;
			Stop;
		Explode:
			#### # 0 A_StopSound( CHAN_6 );
			#### # 6 bright A_StartSound( "hs_trigger", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_Explode( 45, 250, XF_NOTMISSILE, false, 75 );
			#### # 0 A_StartSound( "hs_explode", CHAN_WEAPON, CHANF_OVERLAP );
			#### # 0 A_StartSound( "hs_explosion", CHAN_WEAPON, CHANF_OVERLAP );
			Stop;
	}
}

Class K7_HeavenSmile_Fast : K7_HeavenSmile
{
	Default
	{
		Speed 10;
		PainChance 150;
	}
	
	States
	{
		See:
			#### # 0 A_StartSound( "hs_run", CHAN_VOICE );
			#### AAABBB 2 A_Chase( "_a_chase_default", "_a_chase_default" );
			#### # 0 A_StartSound( "hs_run", CHAN_VOICE );
			#### CCCDDD 2 A_Chase( "_a_chase_default", "_a_chase_default" );
			#### # 0;
			Loop;
	}
}

Class hs_replace_DoomImp : K7_HeavenSmile Replaces DoomImp {}
Class hs_replace_ZombieMan : K7_HeavenSmile Replaces ZombieMan {}
Class hs_replace_ShotgunGuy : K7_HeavenSmile Replaces ShotgunGuy {}
Class hs_replace_Cacodemon : K7_HeavenSmile Replaces Cacodemon {}
Class hs_replace_LostSoul : K7_HeavenSmile Replaces LostSoul {}
Class hs_replace_Demon : K7_HeavenSmile_Fast Replaces Demon {}



