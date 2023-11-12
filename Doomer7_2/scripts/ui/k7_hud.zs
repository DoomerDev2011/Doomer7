Class CK7_Hud : BaseStatusBar 
{
	HUDFont k7HudFont;
	Inventory a1, a2;
	Inventory CK7_ThinBlood;
	
	
	override void Init()
	{
		Super.Init();
		SetSize( 0, 1920, 1080 );
		Font fnt = "K7Font";
		k7HudFont = HUDFont.Create( fnt, fnt.GetCharWidth("0"), Mono_CellLeft, 1, 1 );
	}
	
	override void Draw( int state, double TicFrac )
	{
		BeginHUD( 1, true, 1920, 1080);
		
		Super.Draw( state, TicFrac );
		
		CK7_ThinBlood = CPlayer.mo.FindInventory('CK7_ThinBlood');
		//DrawImage( "K7HUD_BG", ( 0, 0 ), DI_ITEM_OFFSETS );
		
		DrawString( k7HudFont, FormatNumber( CPlayer.health, 3 ), ( 70, 150 ) );
		DrawString( k7HudFont, "Health", ( 40, 180 ));
		DrawString( k7HudFont, FormatNumber( CK7_ThinBlood.Amount, 3 ), ( 40, 210 ));
		DrawString( k7HudFont, "Thin blood", ( 40, 240 ));
		
		
		if ( a2 )
		{
			DrawString( k7HudFont, FormatNumber( a2.amount, 3 ), ( 70, 400 ) );
		}
	}
}