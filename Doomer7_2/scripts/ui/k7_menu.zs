
class k7_MainMenu : ListMenu
{
	TextureID pic, Title, Glow;
	Double Allpha;
	Double Glang;

	override void Init(Menu parent, ListMenuDescriptor baseDesc)
	{
		Allpha = 1;
		pic = TexMan.CheckForTexture("graphics/d7menu.png");
		Title = TexMan.CheckForTexture("graphics/Doomer7Logo.png");
		Glow = TexMan.CheckForTexture("graphics/Doomer7Glow.png");
		// clone the descriptor; baseDesc is exactly what's
		// in menudef, so we don't want to mutate it
		let desc = CloneListDescriptor(baseDesc);
		Super.Init(parent, desc);

		// construct the main menu, filtering out a
		// few things based on the ingame status
		bool ingame = gamestate == GS_LEVEL;
		AddTextItem(desc, "$MNU_NEWGAME", "n", "PlayerclassMenu");
		AddTextItem(desc, "$MNU_LOADGAME", "l", "LoadGameMenu");
		AddTextItem(desc, "$MNU_SAVEGAME", "s", "SaveGameMenu", ingame);
		AddTextItem(desc, "$MNU_OPTIONS", "o", "OptionsMenu");
		//AddTextItem(desc, "" , "c", "ReadThisMenu", !ingame);
		//AddTextItem(desc, ""  , "r", "EndGameMenu", ingame);
		AddTextItem(desc, "$MNU_QUITGAME", "e", "QuitMenu");
	}
	
	override void Drawer ()
	{
		Screen.Dim( color(255,0,0,0),1,0,0,Screen.GetWidth(),Screen.GetHeight() );
		//Screen.DrawTexture(pic, true, 0, 0, DTA_FullscreenEx, FSMode_ScaleToFit);
		int w = mDesc ? mDesc.DisplayWidth() : ListMenuDescriptor.CleanScale;
		int h = mDesc ? mDesc.DisplayHeight() : -1;
		screen.DrawTexture(Glow, true, 46, 41, DTA_VirtualWidth, w, DTA_VirtualHeight, h, DTA_FullscreenScale, FSMode_ScaleToFit43,
		DTA_ScaleX, 0.17, DTA_ScaleY , 0.155, DTA_Alpha, Sin(Glang)*Allpha );
		screen.DrawTexture(Title, true, 46, 41, DTA_VirtualWidth, w, DTA_VirtualHeight, h, DTA_FullscreenScale, FSMode_ScaleToFit43,
		DTA_ScaleX, 0.17, DTA_ScaleY , 0.155, DTA_Alpha, Allpha );
		Super.Drawer();
	}
	
	override void Ticker() 
	{
		Glang += Glang>90 ? 1.2 : 2;
		If(Glang > 180) Glang = 0;
		If(Allpha < 1 && Allpha > 0) Allpha -= 0.1;
		super.ticker();
	}
	
	void LaughSelect()
	{
		Allpha = 0.9;
		for(int i=0;i<mDesc.mItems.Size(); i++)
		{
			if (mDesc.mItems[i] is "K7_MenuItem") K7_MenuItem(mDesc.mItems[i]).Off = true;
		}
	}
	void LaughBack()
	{
		Allpha = 1;
		for(int i=0;i<mDesc.mItems.Size(); i++)
		{
			if (mDesc.mItems[i] is "K7_MenuItem") K7_MenuItem(mDesc.mItems[i]).Off = false;
		}
	}
	
	//just to select with hovering and entering with click
	override bool OnUIEvent(UIEvent ev)
	{
		if (ev.Type == UIEvent.Type_KeyDown && ev.KeyChar > 0)
		{
			// tolower
			int ch = ev.KeyChar;
			ch = ch >= 65 && ch < 91 ? ch + 32 : ch;

			for(int i = mDesc.mSelectedItem + 1; i < mDesc.mItems.Size(); i++)
			{
				if (mDesc.mitems[i].Selectable() && mDesc.mItems[i].CheckHotkey(ch))
				{
					mDesc.mSelectedItem = i;
					//MenuSound("menu/cursor");
					return true;
				}
			}
			for(int i = 0; i < mDesc.mSelectedItem; i++)
			{
				if (mDesc.mitems[i].Selectable() && mDesc.mItems[i].CheckHotkey(ch))
				{
					mDesc.mSelectedItem = i;
					//MenuSound("menu/cursor");
					return true;
				}
			}
		}
		//return Super.OnUIEvent(ev);
		bool res = false;
		int y = ev.MouseY;
		if (ev.type == UIEvent.Type_LButtonDown)
		{
			if (mMouseCapture)
			{
				SetCapture(false);
				res = MouseEventBack(MOUSE_Release, ev.MouseX, y);
				if (res) y = -1;	
				res |= MouseEvent(MOUSE_Release, ev.MouseX, y);
			}
		}
		else if (ev.type == UIEvent.Type_MouseMove)
		{
			res = MouseEventBack(MOUSE_Click, ev.MouseX, y);
			// make the menu's mouse handler believe that the current coordinate is outside the valid range
			if (res) y = -1;	
			res |= MouseEvent(MOUSE_Click, ev.MouseX, y);
			if (res)
			{
				SetCapture(true);
			}
		}
		/*
		else if (ev.type == UIEvent.Type_LButtonUp)
		{
			BackbuttonTime = 4*GameTicRate;
			if (mMouseCapture || m_use_mouse == 1)
			{
				res = MouseEventBack(MOUSE_Move, ev.MouseX, y);
				if (res) y = -1;	
				res |= MouseEvent(MOUSE_Move, ev.MouseX, y);
			}
		}*/
		return false; 
	}
	override bool MouseEvent(int type, int x, int y)
	{
		int sel = -1;

		int w = mDesc.DisplayWidth();
		double sx, sy;
		if (w == ListMenuDescriptor.CleanScale)
		{
			// convert x/y from screen to virtual coordinates, according to CleanX/Yfac use in DrawTexture
			x = ((x - (screen.GetWidth() / 2)) / CleanXfac) + 160;
			y = ((y - (screen.GetHeight() / 2)) / CleanYfac) + 100;
		}
		else
		{
			// for fullscreen scale, transform coordinates so that for the given rect the coordinates are within (0, 0, w, h)
			int h = mDesc.DisplayHeight();
			double fx, fy, fw, fh;
			[fx, fy, fw, fh] = Screen.GetFullscreenRect(w, h, FSMode_ScaleToFit43);

			x = int((x - fx) * w / fw);
			y = int((y - fy) * h / fh);
		}

		if (mFocusControl != NULL)
		{
			mFocusControl.MouseEvent(type, x, y);
			return true;
		}
		else
		{
			if ((mDesc.mWLeft <= 0 || x > mDesc.mWLeft) &&
				(mDesc.mWRight <= 0 || x < mDesc.mWRight))
			{
				for(int i=0;i<mDesc.mItems.Size(); i++)
				{
					if (mDesc.mItems[i].Selectable() && mDesc.mItems[i].CheckCoordinate(x, y))
					{
						if (i != mDesc.mSelectedItem)
						{
							MenuSound("menu/cursor");
						}
						mDesc.mSelectedItem = i;
						mDesc.mItems[i].MouseEvent(type, x, y);
						return true;
					}
				}
			}
		}
		mDesc.mSelectedItem = -1;
		return menu.MouseEvent(type, x, y);
	}
	
	/* Taken from Supplice
	 * Clones a list descriptor. This is super-useful for
	 * mixing MENUDEF and code; modifying the passed-in
	 * descriptor in Init will change it permanently otherwise
	 */
	static ListMenuDescriptor CloneListDescriptor(ListMenuDescriptor desc) 
	{
		ListMenuDescriptor newDesc = new('ListMenuDescriptor');
		if(desc) {
			newDesc.mItems.Copy(desc.mItems);
			newDesc.mSelectedItem       = desc.mSelectedItem;
			newDesc.mSelectOfsX         = desc.mSelectOfsX;
			newDesc.mSelectOfsY         = desc.mSelectOfsY;
			newDesc.mSelector           = desc.mSelector;
			newDesc.mDisplayTop         = desc.mDisplayTop;
			newDesc.mXpos               = desc.mXpos;
			newDesc.mYpos               = desc.mYpos;
			newDesc.mWLeft              = desc.mWLeft;
			newDesc.mWRight             = desc.mWRight;
			newDesc.mLinespacing        = desc.mLinespacing;
			newDesc.mAutoselect         = desc.mAutoselect;
			newDesc.mFont               = desc.mFont;
			newDesc.mFontColor          = desc.mFontColor;
			newDesc.mFontColor2         = desc.mFontColor2;
			newDesc.mCenter             = desc.mCenter;
			newDesc.mAnimatedTransition = desc.mAnimatedTransition;
			newDesc.mAnimated           = desc.mAnimated;
			newDesc.mDontBlur           = desc.mDontBlur;
			newDesc.mDontDim            = desc.mDontDim;
			newDesc.mVirtWidth          = desc.mVirtWidth;
			newDesc.mVirtHeight         = desc.mVirtHeight;
		}
		return newDesc;
	}

	void AddTextItem(ListMenuDescriptor desc, String text, String hotkey, Name child, bool condition = true) 
	{
		if(condition) 
		{
			let item = new('K7_MenuItem');
			item.Init(desc, text, hotkey, child);
			int leng = Stringtable.Localize(text).Length();
			item.Kmenu = self;
			desc.mItems.Push(item);
			For(int i; i<leng; i++)
			{
				item.drop.Push(New("K7_LetterDrop") );
			}
			// some necessaryish housekeeping; this is done in the MENUDEF parser
			desc.mYpos += desc.mLinespacing;
			if (desc.mSelectedItem == -1) {
				desc.mSelectedItem = desc.mItems.Size() - 1;
			}
		}
	}
	
}


class K7_MenuItem: ListMenuItemTextItem
{
	k7_MainMenu KMenu;
	Double Alfa;
	int count;
	array<K7_LetterDrop> drop;
	Bool Select;
	Bool Off;
	int space;
	
	override void Draw(bool selected, ListMenuDescriptor desc)
	{
		Select = selected;
		int color = selected||count ? 0xFFFF0000 : 0xFFEEEEFF;//selected ? mColorSelected : mColor;
		let fnt = menuDelegate.PickFont(mFont);
		int w = desc ? desc.DisplayWidth() : ListMenuDescriptor.CleanScale;
		int h = desc ? desc.DisplayHeight() : -1;
		string itext = Stringtable.Localize(mText);
		double charx;
		int leng = itext.Length();
		
		ForEach(D:Drop)
		{
			screen.DrawChar(fnt, font.CR_UNTRANSLATED, D.x, D.y, D.chr, DTA_VirtualWidth, w, DTA_VirtualHeight, h, 
			DTA_FullscreenScale, FSMode_ScaleToFit43, DTA_Color, D.color,
			DTA_ScaleX, 0.8, DTA_ScaleY, 0.8*D.height, DTA_Alpha, D.alpha*KMenu.Allpha);
		}
		
		For(int i; i < leng; i++)
		{
			double x = charx+mXpos; double y = mYpos;
			If(count) {x +=Random(-8,8); y += Random(-8,8);}
			else if (drop[i].timer<1) dropchar(i,itext.ByteAt(i),x,y);
			
			screen.DrawChar(fnt, font.CR_UNTRANSLATED, x, y, itext.ByteAt(i), DTA_VirtualWidth, w, DTA_VirtualHeight, h, 
			DTA_FullscreenScale, FSMode_ScaleToFit43, DTA_Color, color,
			DTA_ScaleX, 0.8, DTA_ScaleY, 0.8, DTA_Alpha, KMenu.Allpha + Alfa);
			
			charx += 12 + space;//fnt.GetCharWidth(mText.ByteAt(i) ) + space;
		}
	}
	
	void dropchar(int i, int chr, double x, double y)
	{
		K7_LetterDrop Dr = drop[i];
		Dr.x = x;
		Dr.y = y+random(-10,4);
		Dr.chr = chr;
		Dr.color = 0xFF880000;
		Dr.Alpha = 0;
		Dr.Fall = 0;
		Dr.height = 1;
		Dr.fallthre = frandom(1.2,1.8);
		Dr.vel = frandom(0.01,0.04);
		Dr.Timer = Random(20,50);
		Return;
	}
	
	override bool Activate()
	{
		If(gamestate == GS_LEVEL)
		{
			KMenu.MenuSound("hs_hurt1");
			Menu.SetMenu(mAction, mParam);
		}
		else
		{
			KMenu.MenuSound("hs_laugh1");
			Alfa = 4.9;
			Count = 62;
			KMenu.LaughSelect();
		}
		return true;
	}
	override bool Selectable()
	{
		return mEnabled > 0 && !Off;
	}

	Override void Ticker() 
	{
		If(Count) {
			If(Count == 1) {Menu.SetMenu(mAction, mParam); KMenu.LaughBack();}
			Count--;
		}
		
		If(Select || Count) {
			If(space < 46) space += 6; }
		else {
			If(space > 0) space -= 3; }
			
		If(Alfa>0) Alfa -= 0.1;
		
		ForEach(D:Drop)
		{
			If(D) D.Ticker();
		}
	}
}

class K7_LetterDrop : Object ui//ListMenuItem
{
	int color;
	int timer;
	int chr;
	bool fall;
	double alpha;
	double fallthre;
	double vel;
	double height;
	int x,y;
	vector2 pos;
	
	
	void ticker()
	{
		if(alpha<0) 
		{
			timer--;
		}
		
		If(fall)
		{
			height -= vel;
			y += 2;
			alpha -= 0.05;
		}
		else
		{
			alpha += 0.03;
			if(alpha>fallthre)  {fall = true; alpha = 1;}
			height += vel;
			y += 0.2;
		}
		
		return;
	}
}