class Components.BlinkOnDemandMeter extends Components.Meter
{
	var blinkMovieClip: MovieClip;
	var meterMovieClip: MovieClip;

	function BlinkOnDemandMeter(aMeterMovieClip: MovieClip, aBlinkMovieClip: MovieClip)
	{
		super(aMeterMovieClip);

		blinkMovieClip = aBlinkMovieClip;
		blinkMovieClip.gotoAndStop("StartFlash");
	}

	function StartBlinking(): Void
	{
		meterMovieClip._parent.PlayForward(meterMovieClip._parent._currentframe);
		blinkMovieClip.gotoAndPlay("StartFlash");
	}
}