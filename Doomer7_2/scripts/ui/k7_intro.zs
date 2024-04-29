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
	const tilt = 0.24;
	bool soun;
	array<K7TitleBar> Bar;
	array<K7TitleBar> Part;
	Vector2 ScreenSize;
	Shape2DTransform interp;
	TextureId Title, Tglow;
	TextureID pic0, pic1, pic2, pic3;
	Double BarsAlpha, LogoAlpha;
	//lettertilt = -0.225 , 1
	//7 tilt = -0,57, 1
	
	void NewBar(Double pos, Double ofs, Double Size, Double Vel, Double Alpha, Bool Vertical)
	{
		K7TitleBar Br = New("K7TitleBar");
		Br.Vertical = Vertical;
		Br.Alpha = ofs;
		Br.Alpha1 = Alpha*0.05;
		Br.Alpha2 = Alpha;
		Br.rhomboid = New("Shape2D");
		Br.transform = New("Shape2DTransform");
		
		If(Vertical) 
		{
			Size /= 1080;
			Br.rhomboid.PushVertex((-tilt,0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size-tilt,0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((0,-0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size,-0.5)); Br.rhomboid.PushCoord((0,0));
			Br.transform.Scale((ScreenSize.y, ScreenSize.y));
			Pos /= 1080;
			Br.Pos = (Pos-tilt*Ofs +tilt, Ofs-0.5)*ScreenSize.y + (ScreenSize.x*0.5,0);
			Br.Vel = Vel*ScreenSize.y*( -tilt, 1 );
		}
		else 
		{
			Size /= 1080;
			Br.rhomboid.PushVertex((-1,Size)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((0,Size)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((-1,0)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((0,0)); Br.rhomboid.PushCoord((0,0));
			Br.transform.Scale((ScreenSize.x,ScreenSize.y));
			Pos /= 1080;
			Br.Pos = (Ofs*ScreenSize.x,Pos*ScreenSize.y);
			Br.Vel.x = Vel*ScreenSize.x;
		}
		Br.rhomboid.PushTriangle(0,1,2);
		Br.rhomboid.PushTriangle(1,2,3);
		Br.transform.Translate(Br.Pos);
		Br.rhomboid.SetTransform(Br.transform);
		//Br.transform.Clear();
		
		Bar.Push(Br);
	}
	
	void NewCharPart(Double x, Double y, Double Size, Double Vel, Double Alpha, Bool Seven = false)
	{
		K7TitleBar Br = New("K7TitleBar");
		Br.Alpha2 = 0.7;
		Br.Alpha1 = 0.02;
		Br.Alpha = Alpha;
		Br.rhomboid = New("Shape2D");
		Br.transform = New("Shape2DTransform");
		
		If(Seven) 
		{
			Br.rhomboid.PushVertex((-0.57,0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size-0.57,0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((0,-0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size,-0.5)); Br.rhomboid.PushCoord((0,0));
			Br.Pos = (x-0.57*y,y)*ScreenSize.y;
		}
		else 
		{
			Br.rhomboid.PushVertex((-tilt,0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size-tilt,0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((0,-0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size,-0.5)); Br.rhomboid.PushCoord((0,0));
			Br.Pos = (x-tilt*y,y)*ScreenSize.y;
		}
		Br.transform.Scale((0.01,0.01)*ScreenSize.y);
		Br.rhomboid.PushTriangle(0,1,2);
		Br.rhomboid.PushTriangle(1,2,3);
		Br.transform.Translate(Br.Pos);
		Br.rhomboid.SetTransform(Br.transform);
		
		Part.Push(Br);
	}
	
	
	
	
	ScreenJob Init()
	{
		TGlow = TexMan.CheckForTexture("graphics/Doomer7Glow.png");
		Title = TexMan.CheckForTexture("graphics/Doomer7Logo.png");
		Pic0 = TexMan.CheckForTexture("graphics/LogoLines0.png");
		ScreenSize = (Screen.GetWidth(), Screen.GetHeight() );
		Interp = New("Shape2DTransform");
		NewBar( 326, 0.000,	12,	0.008,	0.3, 0);
		NewBar( 198,	-0.02,	72,	0.0082,	0.3, 0);
		NewBar( 239, -0.70,	22,	0.009,	0.2, 0);
		NewBar( 473, -0.10,	63,	0.003,	0.3, 0);
		NewBar( 131, -0.14,	37,	0.003,	0.3, 0);
		NewBar( 143, -0.40,	3 ,	0.005,	0.3, 0);
		NewBar( 277, -0.20,	29,	0.0045,	0.2, 0);
		NewBar( 290, -0.14,	16,	0.006,	0.2, 0);
		NewBar( 290, -0.26,	45,	0.004,	0.2, 0);
		NewBar( 347, -0.24,	33,	0.0043,	0.1, 0);
		NewBar( 221, -0.80,	63,	0.007,	0.05, 0);
		
		//-960 + pos -1
		NewBar( -426, -0.040,	25,	0.005,	0.2, 1);
		NewBar( -480, -0.40,	67,	0.007,	0.2, 1);
		Return Self;
	}
	override bool OnEvent(InputEvent evt)
	{
		if (evt.type == InputEvent.Type_KeyDown)  // Any key will skip, not sure why mouse buttons don't count though...
		{
			System.StopAllSounds(); 
			jobstate = finished;
			menu.SetMenu("MainMenu");
			S_StartSound("menu/select",1);
			return true;
		}
		return false;
	}

	override void OnTick() 
	{
		if (!soun) {System.StopAllSounds(); S_StartSound("menu/start",1); soun = true;}
		ForEach(B : Bar)
		{ 
			If(B.Vel.x || B.Vel.y)
			{
				B.Pos += B.Vel;
				B.Alpha += Min(B.Alpha2-B.Alpha,B.Alpha1);
				If(B.Vertical && B.Pos.y > ScreenSize.y*0.5) {B.Pos.y = ScreenSize.y*0.5; B.Vel = (0,0);}
				If(!B.Vertical && B.Pos.x > ScreenSize.x) {B.Pos.x = ScreenSize.x; B.Vel = (0,0);}
				B.transform.Translate(B.Vel);
				B.rhomboid.SetTransform(B.transform); 
			}
		}
	}

	override void Draw(double smoothratio) 
	{
		screen.DrawTexture(TGlow, true, 46, 41, DTA_VirtualWidth, 600, DTA_VirtualHeight, 450, DTA_FullscreenScale, FSMode_ScaleToFit43,
		DTA_ScaleX, 0.17, DTA_ScaleY , 0.155, DTA_Alpha, 0.2 );
		screen.DrawTexture(Title, true, 46, 41, DTA_VirtualWidth, 600, DTA_VirtualHeight, 450, DTA_FullscreenScale, FSMode_ScaleToFit43,
		DTA_ScaleX, 0.17, DTA_ScaleY , 0.155, DTA_Alpha, 1 );
		Screen.DrawTexture(pic0, true, 0, 0, DTA_FullscreenEx, FSMode_ScaleToFit, DTA_LegacyRenderStyle, STYLE_Add );
		ForEach(B : Bar)
		{
			Screen.DrawShapeFill("0000FF",B.Alpha,B.rhomboid);
		}
	}
	
}

class K7TitleBar ui
{
	Vector2 Pos;
	Vector2 Vel;
	Double Interp;
	Double Alpha, Alpha1, Alpha2;
	Bool Vertical;
	Shape2D rhomboid;
	Shape2DTransform transform;
}

class K7intro ui
{
	static void DoIntroCutscene(ScreenJobRunner runner)
	{
		runner.Append(new("K7_titlecards").Init() );
		runner.Append(new("K7_MenuStart").Init() );
	}
}
