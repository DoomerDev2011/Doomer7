Class CK7_Hud : BaseStatusBar 
{
	HUDFont k7HudFont;
	Inventory a1, a2;
	int timer;
	int damageWipeOfs;
	const HUDRESX = 1920;
	const HUDRESY = 1080;
	int damageWipeDuration;
	TextureID thinBloodTex;
	transient CVar c_xhair;
	transient CVar c_xhair_alpha;
	
	override void Init()
	{
		Super.Init();
		timer = 0;
		damageWipeOfs = 0;
		damageWipeDuration = 200;
		SetSize( 0, 1920, 1080 );
		Font fnt = "K7Font";
		k7HudFont = HUDFont.Create( fnt, fnt.GetCharWidth("0"), Mono_CellLeft, -8, -8 );
	}

	override void Tick()
	{
		super.Tick();
		if (damageWipeOfs > 0)
		{
			damageWipeOfs -= 1;
		}
	}
	
	override void Draw( int state, double TicFrac )
	{
		BeginHUD( 1, true, 1920, 1080);
		
		Super.Draw( state, TicFrac );
		
		DrawImage( "KHUDA0", ( 0, 0 ), DI_ITEM_OFFSETS );
		
		DrawK7Crosshair();
		
		if ( a2 )
		{
			DrawString( k7HudFont, FormatNumber( a2.amount, 3 ), ( 70, 400 ) );
		}

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
	
	void StartDamageWipe(int duration = 20)
	{
		if (damageWipeOfs <= 0)
		{
			damageWipeOfs = duration;
		}
		else
		{
			damageWipeOfs = Clamp(damageWipeOfs + duration*0.25, 0, duration*0.5);
		}
		damageWipeDuration = duration;
	}
	
	void DrawDamageWipe()
	{
		if (damageWipeOfs <= 0)
			return;
	
		TextureID tex = TexMan.CheckForTexture('K7HUD_BG');
		if (tex.IsValid())
		{
			Vector2 texSize = TexMan.GetScaledSize(tex);
			double xpos;
			double slideInTime = damageWipeDuration * 0.75;
			double slideOutTime = damageWipeDuration * 0.25;
			if (damageWipeOfs > slideOutTime)
			{
				xpos = CK7_Utils.LinearMap(damageWipeOfs, damageWipeDuration, slideInTime, -texSize.x, 0, true);
				
			}
			else
			{
				xpos = CK7_Utils.LinearMap(damageWipeOfs, slideOutTime, 0, 0, -texSize.x, true);
			}
			DrawTexture(tex, (xpos, 0), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			//DrawString( k7HudFont, FormatNumber( CPlayer.health, 3 ), (xpos, 150), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			//DrawString( k7HudFont, "Health", (xpos, 180), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			//DrawString( k7HudFont, FormatNumber( CK7_ThinBlood.Amount, 3 ), (xpos, 210), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			//DrawString( k7HudFont, "Thin blood", (xpos, 240), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			
			/*
			DrawString( k7HudFont, FormatNumber( CPlayer.health, 3 ), ( 70, 150 ) );
			DrawString( k7HudFont, "Health", ( 40, 180 ));
			DrawString( k7HudFont, FormatNumber( CK7_ThinBlood.Amount, 3 ), ( 40, 210 ));
			DrawString( k7HudFont, "Thin blood", ( 40, 240 ));
			*/
		}
	}
	
	void PrintItemNotif(class<Inventory> item)
	{
		StartDamageWipe(60);
	}
	
	double GetHealthFraction()
	{
		double frac = double(CPlayer.mo.health) / CPlayer.mo.GetMaxHealth(true);
		return frac;
	}
}