class CK7_ReplacementHandler : EventHandler
{
	override void CheckReplacement(replaceEvent e)
	{
		if (e.Replacee is 'DoomImp' ||
			e.Replacee is 'Zombieman' ||
			e.Replacee is 'ShotgunGuy' ||
			e.Replacee is 'Cacodemon' ||
			e.Replacee is 'LostSoul')
		{
			e.Replacement = 'CK7_HeavenSmile';
		}
		if (e.Replacee is 'Demon' ||
			e.Replacee is 'Spectre')
		{
			e.Replacement = 'CK7_HeavenSmile_Fast'
		}
	}
}
