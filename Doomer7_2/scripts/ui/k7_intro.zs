class K7_titlecards : ScreenJob
{
	bool soun;
	TextureID pic0, pic1, pic2, pic3;

	ScreenJob Init()
	{
		pic0 = TexMan.CheckForTexture("graphics/capcomlogo0.png");
		pic1 = TexMan.CheckForTexture("graphics/capcomlogo1.png");
		pic2 = TexMan.CheckForTexture("graphics/grasslogo0.png");
		pic3 = TexMan.CheckForTexture("graphics/grasslogo1.png");
		
		return self;
	}

	override bool OnEvent(InputEvent evt)
	{
		if (evt.type == InputEvent.Type_KeyDown)  // Any key will skip, not sure why mouse buttons don't count though...
		{
			jobstate = finished;
			return true;
		}
		return false;
	}

	override void OnTick() 
	{
		if (ticks > TICRATE && !soun) {S_StartSound("menu/cards",1); soun = true;}
		if (ticks > TICRATE * 2) pic0 = pic1;
		if (ticks > TICRATE * 5) pic2 = pic3;
		if (ticks > TICRATE * 9) jobstate = finished;
	}

	override void Draw(double smoothratio) 
	{
		int alpha1 = int(clamp(-abs((double(ticks) + smoothRatio) / TICRATE - 2.0) + 2.0, 0.0, 1.0) * 255.0);
		int alpha2 = int(clamp(-abs((double(ticks-140) + smoothRatio) / TICRATE - 2.0) + 2.0, 0.0, 1.0) * 255.0); // Fade over 1 second, hold for 2 seconds, fade over 1 second.
		Screen.DrawTexture(pic0, true, 0, 0, DTA_FullscreenEx, FSMode_ScaleToFit, DTA_Color, (alpha1 << 24) + 0xFFFFFF);
		Screen.DrawTexture(pic2, true, 0, 0, DTA_FullscreenEx, FSMode_ScaleToFit, DTA_Color, (alpha2 << 24) + 0xFFFFFF);
	}
}

class K7_MenuStart : ScreenJob
{
	TextureID pic;

	override bool OnEvent(InputEvent evt)
	{
		if (evt.type == InputEvent.Type_KeyDown)  // Any key will skip, not sure why mouse buttons don't count though...
		{
			jobstate = finished;
			return true;
		}
		return false;
	}

	override void OnTick() 
	{
		if (ticks > TICRATE * 4) jobstate = finished;
	}

	override void Draw(double smoothratio) 
	{
		
	}
}

class K7intro ui
{
	static void DoIntroCutscene(ScreenJobRunner runner)
	{
		runner.Append(new("K7_titlecards").Init() );
		//runner.Append(new("K7_MenuStart") );
	}
}
