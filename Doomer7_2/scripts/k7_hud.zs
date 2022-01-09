Class K7Hud : BaseStatusBar 
{
	HUDFont k7HudFont;
	Inventory a1,a2;
	
	override void Init()
	{
		Super.Init();
		SetSize(0, 1920, 1080);
		Font fnt = "K7Font";
		k7HudFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellLeft, 1, 1);
	}
	
	override void Draw(int state, double TicFrac)
	{
		a2 = GetCurrentAmmo();
		BeginHUD(1, true, 1920, 1080);
		Super.Draw(state,TicFrac);
		DrawImage("HUD", (0, 0), DI_ITEM_OFFSETS);
		DrawString(k7HudFont, FormatNumber(CPlayer.health, 3), (70,150));
		DrawString(k7HudFont, "Health", (40,180));
		DrawString(k7HudFont, FormatNumber(a2, 3),(70,400));
	}
}