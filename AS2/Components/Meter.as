import Shared.GlobalFunc;

class Components.Meter
{
	var meterMovieClip: MovieClip;

	var emptyFrame: Number;
	var fullFrame: Number;
	var currentPercent: Number;
	var targetPercent: Number;
	var fillSpeed: Number;
	var emptySpeed: Number;


	function Meter(aMovieClip: MovieClip)
	{
		emptyFrame = 0;
		fullFrame = 0;
		currentPercent = 100;
		targetPercent = 100;
		fillSpeed = 2;
		emptySpeed = 3;

		meterMovieClip = aMovieClip;
		meterMovieClip.gotoAndStop("Empty");
		emptyFrame = meterMovieClip._currentframe;
		meterMovieClip.gotoAndStop("Full");
		fullFrame = meterMovieClip._currentframe;
	}

	function SetPercent(aPercent: Number): Void
	{
		currentPercent = Math.min(100, Math.max(aPercent, 0));
		targetPercent = currentPercent;
		var interpolatedFrame: Number = Math.floor(GlobalFunc.Lerp(emptyFrame, fullFrame, 0, 100, currentPercent));
		meterMovieClip.gotoAndStop(interpolatedFrame);
	}

	function SetTargetPercent(aPercent: Number): Void
	{
		targetPercent = Math.min(100, Math.max(aPercent, 0));
	}

	function SetFillSpeed(aSpeed: Number): Void
	{
		fillSpeed = aSpeed;
	}

	function SetEmptySpeed(aSpeed: Number): Void
	{
		emptySpeed = aSpeed;
	}

	function Update(): Void
	{
		if (targetPercent > 0 && targetPercent > currentPercent)
		{
			if (targetPercent - currentPercent > fillSpeed)
			{
				currentPercent += fillSpeed;
				var interpolatedFrame: Number = GlobalFunc.Lerp(emptyFrame, fullFrame, 0, 100, currentPercent);
				meterMovieClip.gotoAndStop(interpolatedFrame);
			}
			else
				SetPercent(targetPercent);
		}
		else if (targetPercent <= currentPercent)
		{
			var shouldReduce: Boolean = currentPercent - targetPercent > emptySpeed;
			if ((targetPercent > 0 && shouldReduce) || currentPercent > emptySpeed)
			{
				if (shouldReduce)
					currentPercent -= emptySpeed;
				else
					currentPercent = targetPercent;

				interpolatedFrame = GlobalFunc.Lerp(emptyFrame, fullFrame, 0, 100, currentPercent);
				meterMovieClip.gotoAndStop(interpolatedFrame);
			}
			else if (currentPercent >= 0)
				SetPercent(targetPercent);
		}
	}
}