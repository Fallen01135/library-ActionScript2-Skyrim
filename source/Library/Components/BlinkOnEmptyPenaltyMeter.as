import Shared.GlobalFunc;

class Components.BlinkOnEmptyPenaltyMeter extends Components.BlinkOnEmptyMeter
{
	var penaltyMeterMovieClip: MovieClip;

	var CurrentPenaltyPercent: Number;
	var TargetPenaltyPercent: Number;
	var Full: Number;
	var FillSpeed: Number;
	var penaltyFull: Number;
	var Empty: Number;
	var EmptySpeed: Number;
	var penaltyEmpty: Number;


	function BlinkOnEmptyPenaltyMeter(aMeterMovieClip: MovieClip, aPenaltyMeterMovieClip: MovieClip)
	{
		super(aMeterMovieClip);

		CurrentPenaltyPercent = TargetPenaltyPercent = 0;
		penaltyMeterMovieClip = aPenaltyMeterMovieClip;
		if (penaltyMeterMovieClip != undefined)
		{
			penaltyMeterMovieClip.gotoAndStop("Full");
			penaltyFull = penaltyMeterMovieClip._currentframe;
			penaltyMeterMovieClip.gotoAndStop("Empty");
			penaltyEmpty = penaltyMeterMovieClip._currentframe;
		}
	}

	function SetPenaltyPercent(aPercent: Number): Void
	{
		if (penaltyMeterMovieClip === undefined)
			return;

		CurrentPenaltyPercent = Math.min(100, Math.max(aPercent, 0));
		TargetPenaltyPercent = CurrentPenaltyPercent;
		var penaltyFrame: Number = Math.floor(GlobalFunc.Lerp(Empty, Full, 0, 100, CurrentPenaltyPercent));
		penaltyMeterMovieClip.gotoAndStop(penaltyFrame);
	}

	function SetPenaltyTargetPercent(aPercent: Number): Void
	{
		TargetPenaltyPercent = Math.min(100, Math.max(aPercent, 0));
	}

	function UpdatePenalty(): Void
	{
		if (penaltyMeterMovieClip === undefined)
			return;

		if (TargetPenaltyPercent > 0 && TargetPenaltyPercent > CurrentPenaltyPercent)
		{
			if (TargetPenaltyPercent - CurrentPenaltyPercent > FillSpeed)
			{
				CurrentPenaltyPercent += FillSpeed;
				var penaltyFrame: Number = GlobalFunc.Lerp(Empty, Full, 0, 100, CurrentPenaltyPercent);
				penaltyMeterMovieClip.gotoAndStop(penaltyFrame);
			}
			else
				SetPenaltyPercent(TargetPenaltyPercent);
		}
		else if (TargetPenaltyPercent <= CurrentPenaltyPercent)
		{
			var shouldDecrement: Boolean = CurrentPenaltyPercent - TargetPenaltyPercent > EmptySpeed;
			if ((TargetPenaltyPercent > 0 && shouldDecrement) || CurrentPenaltyPercent > EmptySpeed)
			{
				if (shouldDecrement)
					CurrentPenaltyPercent -= EmptySpeed;
				else
					CurrentPenaltyPercent = TargetPenaltyPercent;

				penaltyFrame = GlobalFunc.Lerp(Empty, Full, 0, 100, CurrentPenaltyPercent);
				penaltyMeterMovieClip.gotoAndStop(penaltyFrame);
			}
			else if (CurrentPenaltyPercent >= 0)
				SetPenaltyPercent(TargetPenaltyPercent);
		}
	}
}