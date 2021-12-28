Class K7_HeavenSmile_Fast : K7_HeavenSmile
{
	Default
	{
		Speed 4;
	}
	
	States
	{
		See:
			#### # 0 A_StartSound( "hs_run", CHAN_VOICE );
			#### ###### 2 A_Chase( "_a_chase_default", "_a_chase_default" );
			#### # 0 A_StartSound( "hs_run", CHAN_VOICE );
			#### ###### 2 A_Chase( "_a_chase_default", "_a_chase_default" );
			#### # 0;
			Loop;
	}
}