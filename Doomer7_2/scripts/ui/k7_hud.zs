Class K7_Hud : BaseStatusBar 
{
	HUDFont k7HudFont;
	Inventory a1, a2;
	
	override void Init()
	{
		Super.Init();
		SetSize( 0, 1920, 1080 );
		Font fnt = "K7Font";
		k7HudFont = HUDFont.Create( fnt, fnt.GetCharWidth("0"), Mono_CellLeft, 1, 1 );
	}
	
	override void Draw( int state, double TicFrac )
	{
		Super.Draw( state, TicFrac );
		
		BeginHUD( 1, true, -1, -1 );
		
		DrawImage( "K7HUD_BG", ( 0, 0 ), DI_ITEM_OFFSETS );
		
		DrawString( k7HudFont, FormatNumber( CPlayer.health, 3 ), ( 70, 150 ) );
		DrawString( k7HudFont, "Health", ( 40, 180 ));
		
		Inventory a1 = GetCurrentAmmo();
		if ( a2 )
		{
			DrawString( k7HudFont, FormatNumber( a2.amount, 3 ), ( 70, 400 ) );
		}
	}
}