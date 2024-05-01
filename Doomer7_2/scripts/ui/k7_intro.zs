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
		Screen.DrawTexture(pic0, true, 0, 0, DTA_FullscreenEx, FSMode_ScaleToFill, DTA_Color, (alpha1 << 24) + 0xFFFFFF);
		Screen.DrawTexture(pic2, true, 0, 0, DTA_FullscreenEx, FSMode_ScaleToFill, DTA_Color, (alpha2 << 24) + 0xFFFFFF);
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
	
	override bool OnEvent(InputEvent evt)
	{
		if (evt.type == InputEvent.Type_KeyDown && !LogoAlpha)  // Any key will skip, not sure why mouse buttons don't count though...
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
		if (ticks > TICRATE * 17.63)
		{
			//System.StopAllSounds(); 
			jobstate = finished;
			menu.SetMenu("MainMenu");
			//S_StartSound("menu/select",1);
		}
		if (ticks > TICRATE * 17) LogoAlpha = 1;
		if (ticks > TICRATE*14.2) 
		{
			If(BarsAlpha>0) BarsAlpha -= 0.01;
			ForEach(B : Part)
			{ 
				If(LogoAlpha == 1) B.Alpha -= 0.032;
				else If(B.Alpha<B.Alpha2) B.Alpha += Min(B.Alpha2-B.Alpha,B.Alpha1);
			}
		}
		else ForEach(B : Bar)
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
		screen.DrawTexture(Title, true, 46, 41, DTA_VirtualWidth, 600, DTA_VirtualHeight, 450, DTA_FullscreenScale, FSMode_ScaleToFit43,
		DTA_ScaleX, 0.17, DTA_ScaleY , 0.155, DTA_Alpha, LogoAlpha );
		ForEach(B : Bar) Screen.DrawShapeFill("0000FF",B.Alpha*BarsAlpha,B.rhomboid);
		ForEach(B : Part) Screen.DrawShapeFill("0000FF",B.Alpha,B.rhomboid);
	}
	
	void NewBar(Double pos, Double ofs, Double Size, Double Vel, Double Alpha, Bool Vertical)
	{
		K7TitleBar Br = New("K7TitleBar");
		Br.Vertical = Vertical;
		Br.Alpha = ofs*0.5;
		Br.Alpha1 = vel*0.5;
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
	
	void NewCharPart(Double x, Double y, Double Size, Double h, Double Alpha, Bool Seven = false)
	{
		K7TitleBar Br = New("K7TitleBar");
		h /= 1080;
		Size /= 1080;
		X /= 1080;
		Y /= 1080;
		Br.Alpha2 = 0.7;
		Br.Alpha1 = 0.02;
		Br.Alpha = Alpha;
		Br.rhomboid = New("Shape2D");
		Br.transform = New("Shape2DTransform");
		
		double tlit = 0.24;
		If(Seven) tlit = 0.622;
		
			Br.rhomboid.PushVertex((-tlit*h,h)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size-tlit*h,h)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((0,0)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size,0)); Br.rhomboid.PushCoord((0,0));
			Br.Pos = (x-tlit*y,y)*ScreenSize.y + (ScreenSize.x*0.5,0);
			
		Br.transform.Scale((1,1)*ScreenSize.y);
		Br.rhomboid.PushTriangle(0,1,2);
		Br.rhomboid.PushTriangle(1,2,3);
		Br.transform.Translate(Br.Pos);
		Br.rhomboid.SetTransform(Br.transform);
		
		Part.Push(Br);
	}
	
	
	ScreenJob Init()
	{
		BarsAlpha = 1;
		Title = TexMan.CheckForTexture("graphics/Doomer7Logo.png");
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
		NewBar( -204, -0.14,	13,	0.006,	0.2, 1);
		NewBar( -480, -0.40,	67,	0.007,	0.2, 1);
		//-960 + (55+pos) 
		NewBar( -319, Frandom(-0.2,-0.7),	63,Frandom(0.0045,0.008),Frandom(0.1,0.2), 1);
		NewBar( -268, Frandom(-0.2,-0.3),	70,Frandom(0.0045,0.008),Frandom(0.1,0.2), 1);
		NewBar( -262, Frandom(-0.2,-0.3),	20,Frandom(0.0045,0.008),Frandom(0.1,0.2), 1);
		NewBar( -192, Frandom(-0.2,-0.3),	51,Frandom(0.0045,0.008),Frandom(0.1,0.2), 1);
		NewBar( -192, Frandom(-0.2,-0.7),	80,Frandom(0.0045,0.008),Frandom(0.1,0.2), 1);
		NewBar( -101, Frandom(-0.2,-0.7),	43,Frandom(0.0045,0.008),Frandom(0.1,0.2), 1);
		
		NewBar( -63, Frandom(-0.2,-0.7),	111,Frandom(0.0045,0.007),Frandom(0.1,0.2), 1);
		NewBar( 0, Frandom(-0.2,-0.7),	51,Frandom(0.003,0.008),Frandom(0.1,0.2), 1);
		NewBar( 48, Frandom(-0.2,-0.7),	82,Frandom(0.003,0.008),Frandom(0.1,0.2), 1);
		NewBar( 62, Frandom(-0.2,-0.7),	6,Frandom(0.003,0.008),Frandom(0.1,0.2), 1);
		
		NewBar( 126, Frandom(-0.2,-0.7),	56,Frandom(0.0045,0.007),Frandom(0.1,0.2), 1);
		NewBar( 176, Frandom(-0.2,-0.7),	23,Frandom(0.0045,0.007),Frandom(0.1,0.2), 1);
		NewBar( 190, Frandom(-0.2,-0.7),	53,Frandom(0.0045,0.007),Frandom(0.1,0.2), 1);
		
		NewBar( 239, Frandom(-0.2,-0.7),	20,Frandom(0.0045,0.008),Frandom(0.1,0.2), 1);
		NewBar( 252, Frandom(-0.2,-0.7),	20,Frandom(0.003,0.007),Frandom(0.1,0.2), 1);
		NewBar( 314, Frandom(-0.2,-0.7),	20,Frandom(0.0045,0.008),Frandom(0.1,0.2), 1);
		NewBar( 362, Frandom(-0.2,-0.7),	20,Frandom(0.003,0.007),Frandom(0.1,0.2), 1);
		//-960 + (50+pos) 
		NewBar( 341, -0.21,	7,	0.006,	0.2, 1);
		NewBar( 440, -0.25,	2,	0.005,	0.2, 1);
		NewBar( 582, -0.17,	9,	0.0065,	0.2, 1);
		
		//-960+x+38
		//D
		//NewCharPart(-480,159,146,44,Frandom(-1,0) );
		NewCharPart(-480,159,146-8,8,Frandom(-1,0) );
		NewCharPart(-480,159+8,146,36,Frandom(-1,0) );
		NewCharPart(-480,203,66,18,Frandom(-1,0) );
		NewCharPart(-480,221,66,18,Frandom(-1,0) );
		NewCharPart(-480,239,66,15,Frandom(-1,0) );
		NewCharPart(-480,254,66,23,Frandom(-1,0) );
		NewCharPart(-480,277,66,13,Frandom(-1,0) );
		NewCharPart(-480,290,66,14,Frandom(-1,0) );
		NewCharPart(-400,203,66,18,Frandom(-1,0) );
		NewCharPart(-400,221,66,18,Frandom(-1,0) );
		NewCharPart(-400,239,66,15,Frandom(-1,0) );
		NewCharPart(-400,254,66,23,Frandom(-1,0) );
		NewCharPart(-400,277,66,13,Frandom(-1,0) );
		NewCharPart(-400,290,66,14,Frandom(-1,0) );
		//NewCharPart(-480,304,146,44,Frandom(-1,0) );
		NewCharPart(-480,304+36,146-8,8,Frandom(-1,0) );
		NewCharPart(-480,304,146,36,Frandom(-1,0) );
		//O
		NewCharPart(-320,199,114,30,Frandom(-1,0) );
		NewCharPart(-320,229,51,10,Frandom(-1,0) );
		NewCharPart(-320,239,51,15,Frandom(-1,0) );
		NewCharPart(-320,254,51,23,Frandom(-1,0) );
		NewCharPart(-320,277,51,13,Frandom(-1,0) );
		NewCharPart(-320,290,51,14,Frandom(-1,0) );
		NewCharPart(-320,304,51,14,Frandom(-1,0) );
		NewCharPart(-257,229,51,10,Frandom(-1,0) );
		NewCharPart(-257,239,51,15,Frandom(-1,0) );
		NewCharPart(-257,254,51,23,Frandom(-1,0) );
		NewCharPart(-257,277,51,13,Frandom(-1,0) );
		NewCharPart(-257,290,51,14,Frandom(-1,0) );
		NewCharPart(-257,304,51,14,Frandom(-1,0) );
		NewCharPart(-320,318,114,30,Frandom(-1,0) );
		//O
		NewCharPart(-191,199,114,30,Frandom(-1,0) );
		NewCharPart(-191,229,51,10,Frandom(-1,0) );
		NewCharPart(-191,239,51,15,Frandom(-1,0) );
		NewCharPart(-191,254,51,23,Frandom(-1,0) );
		NewCharPart(-191,277,51,13,Frandom(-1,0) );
		NewCharPart(-191,290,51,14,Frandom(-1,0) );
		NewCharPart(-191,304,51,14,Frandom(-1,0) );
		NewCharPart(-128,229,51,10,Frandom(-1,0) );
		NewCharPart(-128,239,51,15,Frandom(-1,0) );
		NewCharPart(-128,254,51,23,Frandom(-1,0) );
		NewCharPart(-128,277,51,13,Frandom(-1,0) );
		NewCharPart(-128,290,51,14,Frandom(-1,0) );
		NewCharPart(-128,304,51,14,Frandom(-1,0) );
		NewCharPart(-191,318,114,30,Frandom(-1,0) );
		//M
		NewCharPart(-63,199,112,30,Frandom(-1,0) );
		NewCharPart(49,199,63,30,Frandom(-1,0) );
		NewCharPart(-63,229,51,10,Frandom(-1,0) );
		NewCharPart(-63,239,51,15,Frandom(-1,0) );
		NewCharPart(-63,254,51,23,Frandom(-1,0) );
		NewCharPart(-63,277,51,13,Frandom(-1,0) );
		NewCharPart(-63,290,51,14,Frandom(-1,0) );
		NewCharPart(-63,304,51,14,Frandom(-1,0) );
		NewCharPart(-63,318,51,30,Frandom(-1,0) );
		NewCharPart(0,229,51,10,Frandom(-1,0) );
		NewCharPart(0,239,51,15,Frandom(-1,0) );
		NewCharPart(0,254,51,23,Frandom(-1,0) );
		NewCharPart(0,277,51,13,Frandom(-1,0) );
		NewCharPart(0,290,51,14,Frandom(-1,0) );
		NewCharPart(0,304,51,14,Frandom(-1,0) );
		NewCharPart(0,318,51,30,Frandom(-1,0) );
		NewCharPart(61,229,51,10,Frandom(-1,0) );
		NewCharPart(61,239,51,15,Frandom(-1,0) );
		NewCharPart(61,254,51,23,Frandom(-1,0) );
		NewCharPart(61,277,51,13,Frandom(-1,0) );
		NewCharPart(61,290,51,14,Frandom(-1,0) );
		NewCharPart(61,304,51,14,Frandom(-1,0) );
		NewCharPart(61,318,51,30,Frandom(-1,0) );
		//E
		NewCharPart(126,199,51,30,Frandom(-1,0) );
		NewCharPart(177,199,12,30,Frandom(-1,0) );
		NewCharPart(189,199,51,30,Frandom(-1,0) );
		NewCharPart(126,229,51,10,Frandom(-1,0) );
		NewCharPart(126,239,51,15,Frandom(-1,0) );
		NewCharPart(126,254,51,23,Frandom(-1,0) );
		NewCharPart(126,277,51,13,Frandom(-1,0) );
		NewCharPart(126,290,51,14,Frandom(-1,0) );
		NewCharPart(126,304,51,14,Frandom(-1,0) );
		NewCharPart(126+51,251,12,27,Frandom(-1,0) );
		
		NewCharPart(189,229,51,10,Frandom(-1,0) );
		NewCharPart(189,239,51,15,Frandom(-1,0) );
		NewCharPart(189,254,51,24,Frandom(-1,0) );
		NewCharPart(189,288,51,2,Frandom(-1,0) );
		NewCharPart(189,290,51,14,Frandom(-1,0) );
		NewCharPart(189,304,51,14,Frandom(-1,0) );
		NewCharPart(126,318,51,30,Frandom(-1,0) );
		NewCharPart(177,318,12,30,Frandom(-1,0) );
		NewCharPart(189,318,51,30,Frandom(-1,0) );
		//R
		NewCharPart(254,199,51,30,Frandom(-1,0) );
		NewCharPart(305,199,12,30,Frandom(-1,0) );
		NewCharPart(317,199,51,30,Frandom(-1,0) );
		NewCharPart(305,229,12,8,Frandom(-1,0) );
		NewCharPart(254,229,51,10,Frandom(-1,0) );
		NewCharPart(254,239,51,15,Frandom(-1,0) );
		NewCharPart(254,254,51,23,Frandom(-1,0) );
		NewCharPart(254,277,51,13,Frandom(-1,0) );
		NewCharPart(254,290,51,14,Frandom(-1,0) );
		NewCharPart(254,304,51,14,Frandom(-1,0) );
		NewCharPart(254,318,51,30,Frandom(-1,0) );
		
		NewCharPart(317,229,51,10,Frandom(-1,0) );
		NewCharPart(317,239,51,15,Frandom(-1,0) );
		NewCharPart(317,254,51,24,Frandom(-1,0) );
		
		//7
		NewCharPart(527-124,143,243,33,Frandom(-1,0),1 );
		NewCharPart(527-124,176,243,23,Frandom(-1,0),1 );
		NewCharPart(527-124,199,124,22,Frandom(-1,0),1 );
		
		NewCharPart(527,199,119,30,Frandom(-1,0),1 );
		NewCharPart(527,229,119,10,Frandom(-1,0),1 );
		NewCharPart(527,239,119,15,Frandom(-1,0),1 );
		NewCharPart(527,254,119,23,Frandom(-1,0),1 );
		NewCharPart(527,277,119,13,Frandom(-1,0),1 );
		NewCharPart(527,290,119,14,Frandom(-1,0),1 );
		NewCharPart(527,304,119,14,Frandom(-1,0),1 );
		NewCharPart(527,318,119,30,Frandom(-1,0),1 );
		NewCharPart(527,348,119,32,Frandom(-1,0),1 );
		NewCharPart(527,380,119,94,Frandom(-1,0),1 );
		
		Return Self;
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
