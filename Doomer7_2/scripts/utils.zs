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
	PLayerPawn pp;
	Actor looktarget;
	sightline sightline;
	static K7_LookTargetController Create(PLayerPawn pp)
	{
		let ltc = New("K7_LookTargetController");
		if (ltc)
		{
			ltc.pp = pp;
		}
		return ltc;
	}
	
	//has the function of CheckSight() but with exact position and direction
	Bool, TraceResults SightCheck(actor Obj, vector3 start, Sector sec, vector3 direction, double maxDist)
	{
		If(!SightLine) SightLine = New("SightLine");
		SightLine.Obj = Obj;
		SightLine.Trace(start,sec,direction,maxDist,TRACE_ReportPortals);
		Return SightLine.Results.HitActor == Obj, SightLine.Results;
	}
	
	Bool CheckInsideCone(Actor Who, Actor Obj, Vector3 FirePos, Vector3 Dir, Double Length = 500, Double Spread = 30)
	{
		Bool Hit;
		Double ObjHei = Obj.Height*0.5;
		Vector3 ObjPos = Obj.Pos.PlusZ(ObjHei);
		Vector3 ObjOfs = ObjPos-FirePos;
		Double ObjDist = ObjOfs.Length();
		
		Double Dist = ObjOfs Dot Dir;
		Vector3 Push = ObjOfs - Dir*Dist;
		//Bool inv = Push.z < 0;
		Push.z = Max(0, Abs(Push.z) - ObjHei); //Turns Z upwards
		//If(Inv) Push.z *= -1;
		Vector2 HorzPush = Push.xy.Unit();
		Push -= (0,0,0) + HorzPush*Clamp(HorzPush dot Push.xy,0,Obj.Radius);
		Double PushLeng = Push.Length();
		
		If( Dist+Obj.Radius > 0 && Dist-Obj.Radius <= Length && PushLeng <= Dist*Tan(Spread) )
		{
			Vector3 Sir = ObjOfs;
			If(ObjDist != 0) Sir /= ObjDist;
			Hit = SightCheck(obj,FirePos,who.cursector,sir,Length);
		}
		Return Hit;
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
		pp.LineTrace(pp.angle, 2048, pp.pitch, offsetz: pp.player.viewz - pp.pos.z, data:lt);
		let ha = lt.HitActor;
		if (lt.HitType == TRACE_HitActor && ha && ha.bISMONSTER && ha.bSHOOTABLE && ha.health > 0)
		{
			looktarget = ha;
		}
		else
		{
			looktarget = null;
		}
		vector3 dir = (cos(pp.angle)*cos(pp.pitch), sin(pp.angle)*cos(pp.pitch), sin(-pp.pitch));
		vector3 lookpos = (pp.pos.x,pp.pos.y,pp.player.viewz);
		double ang = 7*tan(pp.player.fov*0.5);
		BlockThingsIterator it = BlockThingsIterator.Create(pp, 2048);
		Actor obj;
		while (it.Next())
		{
			obj = it.thing;
			If (Obj is "CK7_HS_CritSpot")
			{
				Bool insight = CheckInsideCone(pp,obj,lookpos,dir,2048,ang);
				If(Insight) Obj.Alpha = 1;
			}
		}
		
	}
}

class SightLine : CK7_Hitscan
{
	Actor Obj;
	
    override ETraceStatus TraceCallback()
    {
		if (results.HitType == TRACE_HitActor)
        {
			If( results.HitActor == Obj) 
			{
				return TRACE_Stop;
			}
            return TRACE_Skip;
        }
		
		If (results.HitType == Trace_HitFloor || results.HitType == Trace_HitCeiling || results.HitType == TRACE_HasHitSky)
		{	
			Return TRACE_Stop;
		}
		
		If (results.HitLine)
		{
			If (results.Tier != TIER_Middle || results.HitLine.Sidedef[Line.Back] == Null || BlockingLineInTheWay(results.HitLine,BLITW_HitscansOnly) )
			{
				Return TRACE_Stop;
			}
		}
		Return TRACE_Skip;
    }
}