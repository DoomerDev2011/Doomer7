Class CK7_Hud : BaseStatusBar 
{
	const HUDRESX = 1920;
	const HUDRESY = 1080;
	const C_FRAMERATE = 60.0;
	const CHARGETIME = C_FRAMERATE * 4.0;
	const CHARGETIME_HOLD = C_FRAMERATE * 1.5;
	const CHARGETIME_FWD = 8.0;
	const CHARGETIME_BACK = -2.0;

	CK7_GameplayHandler handler;
	K7_LookTargetController lookController;
	double targetTimer;
	const CROSSHAIRTIME = C_FRAMERATE * 1.5;

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
		if (!autoMapActive)
		{
			DrawSidePanel();
			DrawK7Crosshair();
			DrawCharge();
			DrawThinBlood();
		}
		
		DrawHealth();
	}

	double SinePulse(double frequency = TICRATE, double startVal = 0.0, double endVal = 1.0)
	{
		//return 0.5 + 0.5 * sin(360.0 * deltatime / (frequency*1000.0));
		double time = Level.mapTime;
		double pulseVal = 0.5 + 0.5 * sin(360.0 * (time + fracTic) / frequency);
		return CK7_Utils.LinearMap(pulseVal, 0.0, 1.0, startVal, endVal);
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

	void DrawHealth()
	{
		double hudHealth = GetHealthFraction();
		String img;
		if (hudHealth >= .75){
			img = "KEYESA0";
		}else if( hudHealth >= 0.5){
			img = "KEYESB0";
		}else if( hudHealth >= 0.25){
			img = "KEYESC0";
		}else {
			img = "KEYESD0";
		}
		DrawImage( img, (57,90), DI_ITEM_OFFSETS, 1.0, (-1,-1), (.115,.115));
		DrawString( k7HudFont, FormatNumber( CPlayer.health, 3 ), (113, 50), DI_TEXT_ALIGN_CENTER );
		DrawString( k7HudFont, FormatNumber( GetArmorAmount(), 3 ), (113, 220), DI_TEXT_ALIGN_CENTER );
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
		int chargecount, charges;
		[chargecount, charges] = GetWeaponCharge();
		if (!chargecount)
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
		DrawString( k7HudFont, String.Format("Lv. %d", charges), pos, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER, scale: sc);
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

	int, int GetWeaponCharge()
	{
		let weap = CK7_Smith_Weapon(CPlayer.readyweapon);
		if (!weap)
		{
			return 0, 0;
		}
		return weap.m_iSpecialChargeCount, weap.m_iSpecialCharges;
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
		// Color levels: yellow, pink, magenta, blue
		Color col = 0xffc47933;
		int style = STYLE_Add;
		int chargecount, charges;
		[chargecount, charges] = GetWeaponCharge();
		if (chargecount)
		{
			int pulsefreq;
			switch (charges)
			{
			case 1:
				col = 0xfff80040;
				pulsefreq = 5;
				break;
			case 2:
				col = 0xffaa03ac;
				pulsefreq = 4;
				break;
			case 3:
				col = 0xff398cfd;
				pulsefreq = 3;
				break;
			}
			if (charges)
			{
				//style = Style_Add;
				alpha = SinePulse(pulsefreq, alpha*0.8, alpha);
			}
		}

		if (chargecount && charges)
		{
			DrawImage("K7RETCB2", (0,0), DI_SCREEN_CENTER|DI_ITEM_CENTER, alpha: alpha*0.5, style:style);
		}
		DrawImage("K7RETCB1", (0,0), DI_SCREEN_CENTER|DI_ITEM_CENTER, alpha: alpha, style:style, col:col);
		if (!lookController)
		{
			let handler = CK7_GameplayHandler(EventHandler.Find('CK7_GameplayHandler'));
			if (handler)
			{
				lookController = handler.lookControllers[consoleplayer];
			}
		}
		else
		{
			if (lookController.looktarget)
			{
				targetTimer = Clamp(targetTimer + 6*deltatime, 0, CROSSHAIRTIME);
			}
			else
			{
				targetTimer = Clamp(targetTimer - 3*deltatime, 0, CROSSHAIRTIME);
			}
			double ang = CK7_Utils.LinearMap(targetTimer, 0, CROSSHAIRTIME*0.8, 0, -60, true);
			double sc = CK7_Utils.LinearMap(targetTimer, 0, CROSSHAIRTIME*0.8, 1.0, 1.48, true);
			if (chargecount && charges)
			{
				DrawImageRotated("K7RETCR2", (0,0), DI_SCREEN_CENTER, ang, alpha*0.5, (sc, sc), style:style);
			}
			DrawImageRotated("K7RETCR1", (0,0), DI_SCREEN_CENTER, ang, alpha, (sc, sc), style:style, col:col);
		}
	}
}