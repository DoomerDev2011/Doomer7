class CK7_Utils
{
	static clearscope bool IsVoodooDoll(PlayerPawn mo)
	{
		return !mo.player || !mo.player.mo || mo.player.mo != mo;
	}

	static clearscope double LinearMap(double val, double source_min, double source_max, double out_min, double out_max, bool clampIt = false) 
	{
		double sourceDiff = (source_max - source_min);
		if (sourceDiff == 0.0)
		{
			return 0;
		}
		double d = (val - source_min) * (out_max - out_min) / sourceDiff + out_min;
		if (clampit) 
		{
			double truemax = out_max > out_min ? out_max : out_min;
			double truemin = out_max > out_min ? out_min : out_max;
			d = Clamp(d, truemin, truemax);
		}
		return d;
	}

	static clearscope vector2 GetLineNormal(vector2 ppos, Line lline)
	{
		vector2 linenormal;
		linenormal = (-lline.delta.y, lline.delta.x).unit();
		if (!Level.PointOnLineSide(ppos, lline))
		{
			linenormal *= -1;
		}
		
		return linenormal;
	}

	static play vector3, bool GetNormalFromPos(Actor source, double dist, double angle, double pitch, FLineTraceData normcheck)
	{
		if (!source)
		{
			return (0,0,0), false;
		}

		source.LineTrace(angle, dist, pitch, TRF_THRUACTORS|TRF_NOSKY, data:normcheck);
		vector3 hitnormal = normcheck.HitLocation;

		hitnormal = -normcheck.HitDir;
		if (normcheck.HitType == TRACE_HitFloor)
		{
			if (normcheck.Hit3DFloor) 
				hitnormal = -normcheck.Hit3DFloor.top.Normal;
			else 
				hitnormal = normcheck.HitSector.floorplane.Normal;
			return hitnormal, true;
		}
		else if (normcheck.HitType == TRACE_HitCeiling)
		{
			if (normcheck.Hit3DFloor) 
				hitnormal = -normcheck.Hit3DFloor.bottom.Normal;
			else 
				hitnormal = normcheck.HitSector.ceilingplane.Normal;
			return hitnormal, true;
		}
		else if (normcheck.HitType == TRACE_HitWall && normcheck.HitLine)
		{
			hitnormal.xy = CK7_Utils.GetLineNormal(source.pos.xy, normcheck.HitLine);
			hitnormal.z = 0;
			return hitnormal, true;
		}
		
		return hitnormal, false;
	}
}

class K7_LookTargetController : Thinker
{
	protected PlayerPawn pp;
	Actor looktarget;
	static K7_LookTargetController Create(PlayerPawn pp)
	{
		let ltc = New("K7_LookTargetController");
		if (ltc)
		{
			ltc.pp = pp;
		}
		return ltc;
	}

	override void Tick()
	{
		if (!pp)
		{
			Destroy();
			return;
		}
		if (!pp.player || pp.health <= 0)
			return;
		
		FLineTraceData lt;
		pp.LineTrace(pp.angle, 2048, pp.pitch, offsetz: pp.height * 0.5 - pp.floorclip + pp.AttackZOffset*pp.player.crouchFactor, data:lt);
		let ha = lt.HitActor;
		if (lt.HitType == TRACE_HitActor && ha && ha.bISMONSTER && ha.bSHOOTABLE && ha.health > 0)
		{
			looktarget = ha;
		}
		else
		{
			looktarget = null;
		}
	}
}