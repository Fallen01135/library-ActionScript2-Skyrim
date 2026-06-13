import Shared.GlobalFunc;

class FTA.Meters extends MovieClip
{
	var fill: MovieClip;

	var emptyFrame: Number = 0;
	var fullFrame: Number = 0;
	var currentPercent: Number = 100;
	var targetPercent: Number = 100;
	var fillSpeed: Number = 2;
	var emptySpeed: Number = 3;

	var colourID: Number;


	function Meters()
	{
		super();

		gotoAndStop("Empty");
		emptyFrame = _currentframe;
		gotoAndStop("Full");
		fullFrame = _currentframe;

		setColour(colourID);
	}


	function SetPercent(aPercent: Number): Void
	{
		currentPercent = Math.min(100, Math.max(aPercent, 0));
		targetPercent = currentPercent;
		var interpolatedFrame: Number = Math.floor(GlobalFunc.Lerp(emptyFrame, fullFrame, 0, 100, currentPercent));
		gotoAndStop(interpolatedFrame);

		setColour(colourID);
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
				gotoAndStop(interpolatedFrame);
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
				gotoAndStop(interpolatedFrame);
			}
			else if (currentPercent >= 0)
				SetPercent(targetPercent);
		}
	}

	function setColour(aColour: Number): Void
	{
		if (fill != null)
		{
			var myColour: Color = new Color(fill);
			myColour.setRGB(colourID)
		}
	}
}