Class CK7_Hud : BaseStatusBar 
{
	int HUDRESX;
	int HUDRESY;
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
	TextureID thinBloodTexEmpty;
	TextureID backgroundTex;
	Vector2 backgroundTexSize;

	double itemScale;
	double sideSlideTimer;
	double sideSlideDir;
	double prevMSTime;
	double deltaTime;
	double fracTic;
	double oldhealth;
	double blink;
	int reloadtime, reloadlerp;
	bool reloading;
	
	override void Init()
	{
		Super.Init();
		HUDRESY = Screen.GetHeight();
		HUDRESX = Screen.GetWidth();
		SetSize( 0, HUDRESX, HUDRESY );
		Font fnt = "K7Font";
		k7HudFont = HUDFont.Create( fnt, fnt.GetCharWidth("0"), Mono_CellLeft, -8, -6 );
		fnt = "Hiragino";
		k7italicFont = HUDFont.Create( fnt, 1, false, -6, -6 );
		backgroundTex = TexMan.CheckForTexture("K7HUD_BG");
		backgroundTexSize = TexMan.GetScaledSize(backgroundTex);
	}
	
	override void Tick()
	{
		super.Tick();
		reloadlerp = reloadtime;
		If(ReloadTime) Reloadtime--;
	}
	
	override void Draw( int state, double TicFrac )
	{
		Super.Draw( state, TicFrac );
		UpdateDeltaTime();
		if (state == HUD_None) return;
		HUDRESY = Screen.GetHeight();
		HUDRESX = Screen.GetWidth();
		ItemScale = Float(HUDRESY)/1080.0;
		BeginHUD( 1, true, HUDRESX, HUDRESY);
		fracTic = TicFrac;
		DrawReload();
		//if (reloadtime<1) //not draw while reloading
		//{
			DrawSidePanel();
			UpdateSideSlideTimer();
			DrawKeys();
			DrawCharge();
			DrawThinBlood();
			DrawHealth();
			if (!autoMapActive) DrawK7Crosshair();
		//}
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
		return double(CPlayer.mo.health) / CPlayer.mo.GetMaxHealth(true);
	}

	void DrawHealth()
	{
		double hudHealth = GetHealthFraction();
		If(hudhealth > oldhealth) blink = oldhealth;
		oldhealth = hudHealth;
		
		If(Blink > -hudHealth) 
		{
			blink -= deltatime*0.15;
			hudhealth = abs(blink);
		}
		String img = "KEYES"; 
		double eye = Clamp(4-hudhealth*4,0,3); eye += CPlayer.mo.CountInv('CK7_ThinBlood')? 0:4;
		img.AppendCharacter(65+eye); img.AppendCharacter(48);
		DrawImage( img, (54,92)*ItemScale, DI_ITEM_OFFSETS, 1.0, (-1,-1), (.115,.115)*ItemScale );
		
		Vector2 sc = (0.75,0.75);
		DrawString( k7HudFont, ""..CPlayer.health, (backgroundTexSize.x*0.5 - 64, 32), DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER, scale:sc );
		DrawString( k7HudFont, ""..GetArmorAmount(), (backgroundTexSize.x*0.5 + 64, 32), DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER, scale:sc );
	}
	
	
	static const string ReloadText[] = {"Reload1", "Reload2", "Reload3", "Reload4", "Reload5", "Reload6", "Reload7", "Reload8", "Reload9", "Reload10", "Reload11" };
	static const int ReloadSpace[] = {42, 37, 22, 37, 37, 37, 42, 42, 32, 42, 22 }; //pixel width
	void DrawReload(double alpha = 1, double scale = 2.5)
	{
		let weap = CK7_Smith_Weapon(CPlayer.readyweapon);
		if (!weap || !weap.m_fReloadTime) return; 
		psprite psp = CPlayer.FindPSprite(2); //it was easier to read the down animation since the actual reload is a bit longer
		bool reload;
		if(psp) reload = psp.curstate.InStateSequence(weap.FindState("Anim_Reload_Down"));
		
		if (Reload && !Reloading)
		{
			ReloadTime = weap.m_fReloadTime;
			reloadlerp = ReloadTime;
		}
		Reloading = Reload;
		
		If(ReloadTime > 0)
		{
			scale *= ItemScale;
			int inout = Min(12,weap.m_fReloadTime*0.5); //tics it takes for text to move in position
			int txtofs = HUDRESY*0.13; //ofset from the edge
			
			Double Move = reloadlerp + (reloadtime - reloadlerp)*fractic;
			Double Txtm1 = Min(1,(weap.m_fReloadTime-move)/inout);
			Double Txtm2 = Min(1,move/inout);
			Double Txtm3 = Txtm1 * Txtm2;
			Double Barmove = Min(1,(weap.m_fReloadTime-move)/8 ) * Min(1,move/8 );
			Double BarHeight = HUDRESY*0.167*BarMove;
			//Coundnt decide which style to use so i made it optional
			If(CVar.GetCVar('k7_reloadblink', CPlayer).GetBool() ) BarHeight += (HUDRESY*0.833)*(0.5-abs(0.5-BarMove) );
			color bars = color(int(255*alpha),0,0,0);
			Fill(bars,0,0,HUDRESX,BarHeight);
			Fill(bars,0,-BarHeight,HUDRESX,BarHeight);
			int textpos;
			For(int r; r<6; r++)
			{
				double txtx = (txtofs + textpos*Txtm3 + HUDRESX*(1-Txtm1) ) * Txtm2 -txtofs*(1-Txtm2);
				DrawImage(ReloadText[r], (txtx,HUDRESY*0.0834), 
				DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT|DI_ITEM_CENTER, alpha* Txtm2, scale: (scale,scale) );//, style:Style_Add
				textpos += ReloadSpace[r]*scale;
			}
			textpos = 0;
			For(int r = 10; r>5; r--)
			{
				double txtx = (txtofs + textpos*Txtm3 + HUDRESX*(1-Txtm1) ) * Txtm2 -txtofs*(1-Txtm2);
				DrawImage(ReloadText[r], (-txtx,-HUDRESY*0.0834), 
				DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT|DI_ITEM_CENTER, alpha* Txtm2, scale: (scale,scale) );//, style:Style_Add
				textpos += ReloadSpace[r]*scale;
			}
		}
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
		DrawTexture( backgroundTex, pos*ItemScale, DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER, scale:(ItemScale,ItemScale) );
		Vector2 cPos = (pos + (backgroundTexSize.x*0.5, 156) )*ItemScale;
		Vector2 sc = (0.85, 0.85)*ItemScale;
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
		DrawString( k7italicFont, "Charge", pos*ItemScale, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER, scale:(ItemScale,ItemScale) );
		pos.y += 50;
		DrawString( k7italicFont, String.Format("Lv. %d", charges), pos*ItemScale, DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_CENTER, scale:(ItemScale,ItemScale));
	}

	// Draw the thin blood icon and counter:
	void DrawThinBlood()
	{
		vialTimer = Clamp(vialTimer - 4.0 * deltaTime, 0, MAXVIALTIMER);

		let thinblood = CK7_ThinBlood(CPlayer.mo.FindInventory('CK7_ThinBlood'));
		if (!thinblood)
		{
			return;
		}
		if (!thinBloodTex || !thinBloodTex.IsValid())
		{
			thinBloodTex = TexMan.CheckForTexture('k7bvial1');
		}
		if (!thinBloodTexEmpty || !thinBloodTexEmpty.IsValid())
		{
			thinBloodTexEmpty = TexMan.CheckForTexture('k7bvial0');
		}
		// Vial position:
		Vector2 pos = (112, 48);
		// Side offset from the panel:
		pos.x += GetSideOffset();
		// Position for the platform:
		Vector2 plPos = (pos + (0, 20) )*ItemScale;
		// Platform:
		DrawImage("tbldpl0", plPos, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM, scale:(ItemScale,ItemScale));

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
		Vector2 vp;
		TextureID vtex;
		// Central vial (always drawn if has any):
		vtex = charges > 0 ? thinBloodTex : thinBloodTexEmpty;
		vp = vp_c  - ((vp_c - vp_r) / MAXVIALTIMER) * vialTimer;
		DrawTexture(vtex, vp*ItemScale, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM, scale:(ItemScale,ItemScale));

		// Left vial (lv. 2):
		vtex = charges > 1 ? thinBloodTex : thinBloodTexEmpty;
		vp = vp_l - ((vp_l - vp_c) / MAXVIALTIMER) * vialTimer;
		DrawTexture(vtex, vp*ItemScale, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM, scale:(ItemScale,ItemScale));

		// Right vial (lv. 3):
		vtex = charges > 2 ? thinBloodTex : thinBloodTexEmpty;
		vp = vp_r - ((vp_r - vp_l) / MAXVIALTIMER) * vialTimer;
		DrawTexture(vtex, vp*ItemScale, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM, scale:(ItemScale,ItemScale));

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
			DrawImage(pltex, plPos, DI_SCREEN_LEFT_CENTER|DI_ITEM_BOTTOM, SinePulse(pulsefreq, 0.8, 1), scale:(ItemScale,ItemScale), style: STYLE_Add, col: col);
		}

		// Draw amount string, deducting current charge:
		int chargecount;
		[chargecount, charges] = GetWeaponCharge();
		int amt = thinblood.amount - (chargecount? charges : 0);
		DrawString (k7italicFont, "x"..amt, plPos - (0, 16*ItemScale), DI_SCREEN_LEFT_CENTER|DI_TEXT_ALIGN_LEFT, scale:(ItemScale,ItemScale));
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
		Color col = 0xffde8533;//c47933;
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
			DrawImage("K7RETCB2", (0,0), DI_SCREEN_CENTER|DI_ITEM_CENTER, alpha: alpha*0.5, scale:(ItemScale,ItemScale), style:style);
		}

		DrawImage("K7RETCB1", (0,0), DI_SCREEN_CENTER|DI_ITEM_CENTER, alpha: alpha, scale:(ItemScale,ItemScale), style:style, col:col);
		
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
			double ang = CK7_Utils.LinearMap(targetTimer, 0, CROSSHAIRTIME*0.8, 0, 1, true);
			double alf = CK7_Utils.LinearMap(targetTimer*2, 0, CROSSHAIRTIME*0.8, 0, 1, true);
			double sc = CK7_Utils.LinearMap(targetTimer, 0, CROSSHAIRTIME*0.8, 1, 1.51, true)/ItemScale;
			double sc2 = CK7_Utils.LinearMap(targetTimer, 0, CROSSHAIRTIME*0.8, 1.4, 3.3, true)/ItemScale;
			if (charges)
			{
				DrawImageRotated("K7RETCR2", (0,0), DI_SCREEN_CENTER, -180*ang, alpha*0.25+alf*0.25, (sc, sc), style:style);
				DrawImageRotated("K7RETCR2", (0,0), DI_SCREEN_CENTER, 180, alpha*alf*0.5, (sc2, sc2), style:style);
			}
			DrawImageRotated("K7RETCR1", (0,0), DI_SCREEN_CENTER, -180*ang, alpha*0.5, (sc, sc), style:style, col:col);
			DrawImageRotated("K7RETCR1", (0,0), DI_SCREEN_CENTER, -180*ang, alpha*alf, (sc, sc), style:style, col:col);
			DrawImageRotated("K7RETCR1", (0,0), DI_SCREEN_CENTER, 180, alpha*alf*0.5, (sc2, sc2), style:style, col:col);
			DrawImageRotated("K7RETCR1", (0,0), DI_SCREEN_CENTER, 180, alpha*alf, (sc2, sc2), style:style, col:col);
		}
	}

	void DrawKeys(int rows = 3)
	{
		if (!CPlayer.mo.FindInventory('Key', true))
			return;
			
		int indent = 4;
		Vector2 startPos = (-indent, indent);
		Vector2 keyPos = startPos;
		Vector2 iconSize = (32,32);
		for(let item = CPlayer.mo.Inv; item; item = item.Inv)
		{
			let k = Key(item);
			if (!k)
				continue;

			TextureID icon = GetInventoryIcon(k, 0);
			if (!icon || !icon.isValid())
				continue;
			
			Vector2 size = TexMan.GetScaledSize(icon);
			DrawTexture(icon, keypos, DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP, scale: (iconSize.x / size.x, iconsize.y / size.y));
			keypos.y += iconSize.y + indent;
			if (keypos.y >= startPos.y + (iconSize.y + indent)*rows)
			{
				keyPos.y = startPos.y;
				keyPos.x -= (iconSize.x + indent);
			}
		}
	}
}