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

	double vialTimer;
	const MAXVIALTIMER = C_FRAMERATE * 1.0;

	K7_LookTargetController lookController;
	double targetTimer;
	const CROSSHAIRTIME = C_FRAMERATE * 1.5;

	transient CVar c_xhair;
	transient CVar c_xhair_alpha;
	HUDFont k7HudFont;
	HUDFont k7italicFont;
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
		k7HudFont = HUDFont.Create( fnt, fnt.GetCharWidth("0"), Mono_CellLeft, -8, -6 );
		fnt = "Hiragino";
		k7italicFont = HUDFont.Create( fnt, 1, false, -6, -6 );
		backgroundTex = TexMan.CheckForTexture("K7HUD_BG");
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
		
		DrawSidePanel();
		UpdateSideSlideTimer();
		if (!autoMapActive)
		{
			DrawK7Crosshair();
		}
		DrawCharge();
		DrawThinBlood();
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
		Vector2 sc = (0.75,0.75);
		DrawString( k7HudFont, ""..CPlayer.health, (backgroundTexSize.x*0.5 - 64, 32), DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER, scale:sc );
		DrawString( k7HudFont, ""..GetArmorAmount(), (backgroundTexSize.x*0.5 + 64, 32), DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER, scale:sc );
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
		Vector2 pos = ( GetSideOffset(), 0 );
		DrawTexture( backgroundTex, pos, DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
		Vector2 cPos = pos + (backgroundTexSize.x*0.5, 156);
		Vector2 sc = (0.85, 0.85);
		DrawImage("k7comp_0", cPos, DI_SCREEN_LEFT_TOP|DI_ITEM_CENTER, scale:sc);
		DrawImageRotated("k7comp_1", cPos, DI_SCREEN_LEFT_TOP|DI_ITEM_CENTER, CPlayer.mo.angle - 90, scale:(1. / sc.x, 1. / sc.y), style: STYLE_Add);
		DrawImage("k7comp_2", cPos, DI_SCREEN_LEFT_TOP|DI_ITEM_CENTER, scale:sc);
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
		vialTimer = MAXVIALTIMER;
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
		Vector2 pos = (118, 290);
		pos.x += GetSideOffset();
		// Note, this is a wrong font. The charge string is supposed to
		// use a different font, which is more curly. The other problem
		// is that this font is missing the full stop character, so
		// it prints "Lv  #" instead of "Lv. #"
		DrawString( k7italicFont, "Charge", pos, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER);
		pos.y += 50;
		DrawString( k7italicFont, String.Format("Lv. %d", charges), pos, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER);
	}

	// Draw the thin blood icon and counter:
	void DrawThinBlood()
	{
		vialTimer = Clamp(vialTimer - 4.0 * deltaTime, 0, MAXVIALTIMER);

		let thinblood = CK7_ThinBlood(CPlayer.mo.FindInventory('CK7_ThinBlood'));
		if (!thinblood || thinblood.amount <= 0)
		{
			return;
		}
		if (!thinBloodTex || !thinBloodTex.IsValid())
		{
			thinBloodTex = TexMan.CheckForTexture('DTHNBLD');
		}
		// Vial position:
		Vector2 pos = (112, 48);
		// Side offset from the panel:
		pos.x += GetSideOffset();
		// Position for the platform:
		Vector2 plPos = pos + (0, 20);
		// Platform:
		DrawImage("tbldpl0", plPos, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM);

		Color col;
		int pulseFreq, charges;
		[col, pulseFreq, charges] = GetChargeVisuals();
		if (charges < 2)
		{
			vialTimer = 0;
		}

		Vector2 vp_c = pos;
		Vector2 vp_l = pos + (-52, -25);
		Vector2 vp_r = pos + (52, -25);
		// Central vial (always drawn if has any):
		if (thinblood.amount > 0)
		{
			Vector2 p = vp_c  - ((vp_c - vp_r) / MAXVIALTIMER) * vialTimer;
			DrawTexture(thinBloodTex, p, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM);
		}
		// Left vial (lv. 2):
		if (charges > 1)
		{
			Vector2 p = vp_l - ((vp_l - vp_c) / MAXVIALTIMER) * vialTimer;
			DrawTexture(thinBloodTex, p, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM);
		}
		// Right vial (lv. 3):
		if (charges > 2)
		{
			Vector2 p = vp_r - ((vp_r - vp_l) / MAXVIALTIMER) * vialTimer;
			DrawTexture(thinBloodTex, p, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM);
		}
		// Find platform texture:
		String pltex;
		if (charges)
		{
			switch (charges)
			{
			case 1:
				pltex = "tbldpl1";
				break;
			case 2:
				pltex = "tbldpl2";
				break;
			case 3:
				pltex = "tbldpl3";
				break;
			}
			// Highlights:
			DrawImage(pltex, plPos, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM, SinePulse(pulsefreq, 0.8, 1), style: STYLE_Add, col: col);
		}

		// Draw amount string, deducting current charge:
		int chargecount;
		[chargecount, charges] = GetWeaponCharge();
		int amt = thinblood.amount - (chargecount? charges : 0);
		DrawString (k7italicFont, "x"..amt, plPos - (0, 16), DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT);
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

	Color, int, int GetChargeVisuals()
	{
		Color col = 0xffc47933;
		int pulsefreq;
		int chargecount, charges;
		[chargecount, charges] = GetWeaponCharge();
		if (chargecount)
		{
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
		}
		return col, pulsefreq, charges;
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
		int style = STYLE_Add;
		Color col;
		int pulseFreq, charges;
		[col, pulseFreq, charges] = GetChargeVisuals();
		if (charges)
		{
			//style = Style_Add;
			alpha = SinePulse(pulsefreq, alpha*0.8, alpha);
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
			if (charges)
			{
				DrawImageRotated("K7RETCR2", (0,0), DI_SCREEN_CENTER, ang, alpha*0.5, (sc, sc), style:style);
			}
			DrawImageRotated("K7RETCR1", (0,0), DI_SCREEN_CENTER, ang, alpha, (sc, sc), style:style, col:col);
		}
	}
}