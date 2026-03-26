class Components.BlinkOnEmptyMeter extends Components.Meter
{
	var meterMovieClip: MovieClip;
	var CurrentPercent: Number;
	var Empty: Number;


	function BlinkOnEmptyMeter(aMeterClip: MovieClip)
	{
		super(aMeterClip);
	}

	function Update(): Void
	{
		super.Update();

		var currentFrame: Number = meterMovieClip._currentframe;
		if (CurrentPercent <= 0 && currentFrame == Empty)
		{
			meterMovieClip.gotoAndPlay(Empty + 1);
			var newFrame: Number = meterMovieClip._currentframe;
		}
	}
}