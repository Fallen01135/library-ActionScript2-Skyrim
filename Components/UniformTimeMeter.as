import Shared.GlobalFunc;
import gfx.io.GameDelegate;

class Components.UniformTimeMeter extends Components.Meter
{
	var meterMovieClip: MovieClip;
	var AnimClip: MovieClip;

	var FrameNumber: Number;
	var CurrentPercent: Number;
	var FrameCount: Number;
	var TargetPercent: Number;
	var Empty: Number;
	var Full: Number;

	var FinishSound: String;
	var AnimStart: String;

	var bFinished: Boolean;


	function UniformTimeMeter(aMovieClip: MovieClip, aFinishSound: String, aClip: MovieClip, aAnimStart: String)
	{
		super(aMovieClip);
		FinishSound = aFinishSound;
		AnimClip = aClip;
		AnimStart = aAnimStart;
		FrameNumber = 48;
	}

	function SetTargetPercent(aPercent: Number): Void
	{
		super.SetTargetPercent(aPercent);
		bFinished = aPercent >= 100 && CurrentPercent < 100;
		FrameCount = 0;
	}

	function Update(): Void
	{
		if (FrameCount <= FrameNumber)
		{
			var currentInterpolatedPercent: Number = GlobalFunc.Lerp(CurrentPercent, TargetPercent, 0, FrameNumber, FrameCount);
			var currentFrame: Number = GlobalFunc.Lerp(Empty, Full, 0, 100, currentInterpolatedPercent);
			meterMovieClip.gotoAndStop(currentFrame);

			FrameCount += 1;
			if (FrameCount == FrameNumber && bFinished)
			{
				GameDelegate.call("PlaySound", [FinishSound]);
				if (AnimClip != undefined)
					AnimClip.gotoAndPlay(AnimStart);
			}
		}
	}
}