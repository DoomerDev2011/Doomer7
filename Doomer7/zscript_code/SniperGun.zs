Class SniperPistol_Zoomed : Inventory
{
	default{
		inventory.maxamount 2;
	}
}

Class SniperPistol : Pistol
{
  States{ 
  AltFire:
    PISG ABC 6;
    TNT1 A 0 A_JumpIfInventory("SniperPistol_Zoomed", 2, "ZoomOut");
    TNT1 A 0 A_JumpIfInventory("SniperPistol_Zoomed", 1, "Zoom2");
    //fall through
  Zoom1:
    TNT1 A 0 A_ZoomFactor(2.0);
    TNT1 A 0 A_GiveInventory ("SniperPistol_Zoomed", 1);
    Goto AltFireDone;
  Zoom2:
    TNT1 A 0 A_ZoomFactor(4.0);
    TNT1 A 0 A_GiveInventory ("SniperPistol_Zoomed", 1);
    Goto AltFireDone;
  ZoomOut:
    TNT1 A 0 A_ZoomFactor(1.0);
    TNT1 A 0 A_TakeInventory ("SniperPistol_Zoomed", 2);
    Goto AltFireDone;
  AltFireDone:
    PISG C 5 A_ReFire;
    Goto Ready;
  Deselect:
    TNT1 A 0 A_TakeInventory ("SniperPistol_Zoomed", 2);
    TNT1 A 0 A_ZoomFactor(1.0);
    Goto Super::Deselect;
  }
}