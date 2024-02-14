Class CK7_Hud : BaseStatusBar 
{
	const HUDRESX = 1920;
	const HUDRESY = 1080;
	const C_FRAMERATE = 60.0;
	const CHARGETIME = C_FRAMERATE * 4.0;
	const CHARGETIME_HOLD = C_FRAMERATE * 1.5;
	const CHARGETIME_FWD = 8.0;
	const CHARGETIME_BACK = -2.0;

	transient CVar c_xhair;
	transient CVar c_xhair_alpha;
	HUDFont k7HudFont;
	TextureID thinBloodTex;
	TextureID backgroundTex;
	Vector2 backgroundTexSize;

	double sideSlideTimer;
	double sideSlideDir;
	double prevMSTime;
	double deltaTime;
	double fracTic;
	
	override void Init()
	{
		Super.Init();
		SetSize( 0, HUDRESX, HUDRESY );
		Font fnt = "K7Font";
		k7HudFont = HUDFont.Create( fnt, fnt.GetCharWidth("0"), Mono_CellLeft, -8, -8 );
		backgroundTex = TexMan.CheckForTexture("KHUDA0");
		backgroundTexSize = TexMan.GetScaledSize(backgroundTex);
	}
	
	override void Draw( int state, double TicFrac )
	{
		Super.Draw( state, TicFrac );
		UpdateDeltaTime();
		if (state == HUD_None)
		{
			return;
		}
		BeginHUD( 1, true, HUDRESX, HUDRESY);
		
		UpdateSideSlideTimer();
		DrawSidePanel();
		DrawK7Crosshair();
		DrawCharge();
		DrawThinBlood();
		
		//DrawDamageWipe();
		double hudHealth = GetHealthFraction();
		if (hudHealth >= .75){
			DrawImage( "KEYESA0", (57,90), DI_ITEM_OFFSETS, 1.0, (-1,-1), (.115,.115));
		}else if( hudHealth >= 0.5){
			DrawImage( "KEYESB0", (57,90), DI_ITEM_OFFSETS, 1.0, (-1,-1), (.115,.115));
		}else if( hudHealth >= 0.25){
			DrawImage( "KEYESC0", (57,90), DI_ITEM_OFFSETS, 1.0, (-1,-1), (.115,.115));
		}else if( hudHealth >= 0){
			DrawImage( "KEYESD0", (57,90), DI_ITEM_OFFSETS, 1.0, (-1,-1), (.115,.115));
		}
		DrawString( k7HudFont, FormatNumber( CPlayer.health, 3 ), (113, 50), DI_TEXT_ALIGN_CENTER );
		DrawString( k7HudFont, FormatNumber( GetArmorAmount(), 3 ), (113, 220), DI_TEXT_ALIGN_CENTER );
	}

	void UpdateDeltaTime()
	{
		if (!prevMSTime)
			prevMSTime = MSTimeF();

		double ftime = MSTimeF() - prevMSTime;
		prevMSTime = MSTimeF();
		double dtime = 1000.0 / C_FRAMERATE;
		deltaTime = (ftime / dtime);
	}

	double GetHealthFraction()
	{
		double frac = double(CPlayer.mo.health) / CPlayer.mo.GetMaxHealth(true);
		return frac;
	}

	void UpdateSideSlideTimer()
	{
		if (sideSlideTimer >= CHARGETIME)
		{
			sideSlideDir = CHARGETIME_BACK;
		}
		let weap = CK7_Smith_Weapon(CPlayer.readyweapon);
		if (weap && weap.m_iSpecialCharges > 0 && sideSlideDir < 0)
		{
			sideSlideTimer = CHARGETIME;
		}
		else
		{
			sideSlideTimer = Clamp(sideSlideTimer + sideSlideDir * deltaTime, 0, CHARGETIME);
		}
	}

	void DrawSidePanel()
	{
		DrawTexture( backgroundTex, ( GetSideOffset(), 0 ), DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
	}

	double GetSideOffset()
	{
		if (sideSlideTimer <= 0)
		{
			return -backgroundTexSize.x;
		}
		return CK7_Utils.LinearMap(sideSlideTimer, 0, CHARGETIME_HOLD, -backgroundTexSize.x, 0, true);
	}

	void ShowSidePanel()
	{
		sideSlideDir = CHARGETIME_FWD;
	}

	// Draw the "Charge Lv. #" string:
	void DrawCharge()
	{
		let weap = CK7_Smith_Weapon(CPlayer.readyweapon);
		if (!weap || weap.m_iSpecialChargeCount <= 0)
		{
			return;
		}
		Vector2 sc = (0.85, 0.85);
		Vector2 pos = (118, 310);
		pos.x += GetSideOffset();
		// Note, this is a wrong font. The charge string is supposed to
		// use a different font, which is more curly. The other problem
		// is that this font is missing the full stop character, so
		// it prints "Lv  #" instead of "Lv. #"
		DrawString( k7HudFont, "Charge", pos, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER, scale: sc);
		pos.y += 40;
		DrawString( k7HudFont, String.Format("Lv. %d", weap.m_iSpecialCharges), pos, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER, scale: sc);
	}

	// Draw the thin blood icon and counter:
	void DrawThinBlood()
	{
		let thinblood = CK7_ThinBlood(CPlayer.mo.FindInventory('CK7_ThinBlood'));
		if (!thinblood || thinblood.amount <= 0)
		{
			return;
		}
		if (!thinBloodTex || !thinBloodTex.IsValid())
		{
			thinBloodTex = TexMan.CheckForTexture('DTHNBLD');
		}
		Vector2 pos = (112, 0);
		pos.x += GetSideOffset();
		DrawTexture(thinBloodTex, pos, DI_SCREEN_LEFT_CENTER|DI_ITEM_CENTER);
		DrawString (k7HudFont, ""..thinblood.amount, pos + (10, 80), DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT);
	}

	void DrawK7Crosshair()
	{
		if (!c_xhair)
		{
			c_xhair = CVar.GetCVar('k7_crosshairEnabled', CPlayer);
		}
		if (!c_xhair_alpha)
		{
			c_xhair_alpha = CVar.GetCVar('k7_crosshairOpacity', CPlayer);
		}
		double alpha = Clamp(c_xhair_alpha.GetFloat(), 0.0, 1.0);
		if (!c_xhair.GetBool() || alpha <= 0.0)
		{
			return;
		}
		DrawImage("K7XHAIR", (0,0), DI_SCREEN_CENTER|DI_ITEM_CENTER, alpha: alpha);
	}
}