Class CK7_Hud : BaseStatusBar 
{
	HUDFont k7HudFont;
	Inventory a1, a2;
	Inventory CK7_ThinBlood;
	int timer;
	int damageWipeOfs;
	const HUDRESX = 1920;
	const HUDRESY = 1080;
	int damageWipeDuration;
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
		k7HudFont = HUDFont.Create( fnt, fnt.GetCharWidth("0"), Mono_CellLeft, 1, 1 );
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
		
		CK7_ThinBlood = CPlayer.mo.FindInventory('CK7_ThinBlood');
		DrawImage( "KHUDA0", ( 0, 0 ), DI_ITEM_OFFSETS );
		
		DrawK7Crosshair();
		
		if ( a2 )
		{
			DrawString( k7HudFont, FormatNumber( a2.amount, 3 ), ( 70, 400 ) );
		}
		
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
	
	clearscope double LinearMap(double val, double source_min, double source_max, double out_min, double out_max, bool clampIt = false) 
	{
		double sourceDiff = (source_max - source_min);
		if (sourceDiff == 0)
			sourceDiff = 1;
		double d = (val - source_min) * (out_max - out_min) / sourceDiff + out_min;
		if (clampit) 
		{
			double truemax = out_max > out_min ? out_max : out_min;
			double truemin = out_max > out_min ? out_min : out_max;
			d = Clamp(d, truemin, truemax);
		}
		return d;
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
				xpos = LinearMap(damageWipeOfs, damageWipeDuration, slideInTime, -texSize.x, 0, true);
				
			}
			else
			{
				xpos = LinearMap(damageWipeOfs, slideOutTime, 0, 0, -texSize.x, true);
			}
			DrawTexture(tex, (xpos, 0), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			//DrawString( k7HudFont, FormatNumber( CPlayer.health, 3 ), (xpos, 150), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			//DrawString( k7HudFont, "Health", (xpos, 180), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			DrawString( k7HudFont, FormatNumber( CK7_ThinBlood.Amount, 3 ), (xpos, 210), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			DrawString( k7HudFont, "Thin blood", (xpos, 240), flags: DI_SCREEN_LEFT_CENTER|DI_ITEM_LEFT|DI_ITEM_CENTER);
			
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

Class CK7_DamageHandler : EventHandler
{
	Override void WorldThingDamaged(WorldEvent e)
	{
		if (e.thing.player && e.Damage > 0)
		{
			EventHandler.SendInterfaceEvent(e.thing.PlayerNumber(), "PlayerWasDamaged");
		}
	}
	
	override void InterfaceProcess(consoleEvent e)
	{
		if (e.name ~== "PlayerWasDamaged")
		{
			let hud = CK7_Hud(statusbar);
			if (hud)
			{
				hud.StartDamageWipe(60);
			}
		}
		
		// returns true if the event name CONTAINS "PlayedPickedUpItem" in it:
		if (e.name.IndexOf("PlayedPickedUpItem") >= 0)
		{
			array<String> cmd;
			e.name.Split(cmd, ":"); //splits the name of the event in two parts at ":"
			if (cmd.Size() == 2) // it should be exactly 2
			{
				class<Inventory> item = cmd[1]; //the second element of the array is your class name
				// check it's an existing item:
				if (!item)
					return;
				// get pointer to the HUD:
				let hud = CK7_HUD(statusbar);
				if (!hud)
					return;
				hud.PrintItemNotif(item);
			}
		}
	}
}