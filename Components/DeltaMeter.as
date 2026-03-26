import Shared.GlobalFunc;

class Components.DeltaMeter extends Components.Meter
{
	var deltaMeterClip: MovieClip;
	var deltaEmptyFrame: Number;
	var deltaFullFrame: Number;


	function DeltaMeter(aMovieClip: MovieClip)
	{
		super(aMovieClip);

		deltaMeterClip = aMovieClip.DeltaIndicatorInstance;
		deltaMeterClip.gotoAndStop("Empty");
		deltaEmptyFrame = deltaMeterClip._currentframe;
		deltaMeterClip.gotoAndStop("Full");
		deltaFullFrame = deltaMeterClip._currentframe;
	}

	function SetDeltaPercent(aPercent: Number): Void
	{
		var clampedPercent: Number = Math.min(100, Math.max(aPercent, 0));
		var targetFrame: Number = Math.floor(GlobalFunc.Lerp(deltaEmptyFrame, deltaFullFrame, 0, 100, clampedPercent));

		deltaMeterClip.gotoAndStop(targetFrame);
	}
}