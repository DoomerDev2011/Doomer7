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
	bool soun;
	array<K7TitleBar> Bar;
	Vector2 ScreenSize;
	Shape2DTransform interp;
	
	void NewBar(Vector2 pos, Double Size, Double Vel, Bool Vertical)
	{
		K7TitleBar Br = New("K7TitleBar");
		Br.Pos = Pos*ScreenSize.y;
		Br.Vertical = Vertical;
		Br.Alpha = 0.5;
		Br.rhomboid = New("Shape2D");
		Br.transform = New("Shape2DTransform");
		
		If(Vertical) 
		{
			Br.rhomboid.PushVertex((-0.25,0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size-0.25,0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((0,-0.5)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((Size,-0.5)); Br.rhomboid.PushCoord((0,0));
			Br.transform.Scale((ScreenSize.y, ScreenSize.y));
			Br.Vel = Vel*ScreenSize.y*( -0.25, 1 );
		}
		else 
		{
			Br.rhomboid.PushVertex((-1,Size)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((0,Size)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((-1,-Size)); Br.rhomboid.PushCoord((0,0));
			Br.rhomboid.PushVertex((0,-Size)); Br.rhomboid.PushCoord((0,0));
			Br.transform.Scale((ScreenSize.x,ScreenSize.x));
			Br.Vel.x = Vel*ScreenSize.x;
		}
		Br.rhomboid.PushTriangle(0,1,2);
		Br.rhomboid.PushTriangle(1,2,3);
		Br.transform.Translate(Br.Pos);
		Br.rhomboid.SetTransform(Br.transform);
		//Br.transform.Clear();
		
		Bar.Push(Br);
	}
	
	ScreenJob Init()
	{
		ScreenSize = (Screen.GetWidth(), Screen.GetHeight() );
		Interp = New("Shape2DTransform");
		NewBar( (1.5,-0.4) ,0.05,0.005,1);
		NewBar( (1.1,-0.5) ,0.02,0.01,1);
		NewBar( (0,0.5) ,0.05,0.005,0);
		Return Self;
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
		if (!soun) {System.StopAllSounds(); S_StartSound("menu/start",1); soun = true;}
		if (ticks > TICRATE * 20) jobstate = finished;
		ForEach(B : Bar)
		{ 
			If(B.Vel.x || B.Vel.y)
			{
				B.Pos += B.Vel;
				If(B.Vertical && B.Pos.y > ScreenSize.y*0.5) {B.Pos.y = ScreenSize.y*0.5; B.Vel = (0,0);}
				If(!B.Vertical && B.Pos.x > ScreenSize.x) {B.Pos.x = ScreenSize.x; B.Vel = (0,0);}
				B.transform.Translate(B.Vel);
				B.rhomboid.SetTransform(B.transform); 
			}
		}
	}

	override void Draw(double smoothratio) 
	{
		ForEach(B : Bar)
		{
			Screen.DrawShapeFill("00FF00",B.Alpha,B.rhomboid);
		}
	}
	
}

class K7TitleBar ui
{
	Vector2 Pos;
	Vector2 Vel;
	Double Interp;
	Double Alpha;
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
