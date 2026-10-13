import Shared.GlobalFunc;

class Components.BlinkOnDemandPenaltyMeter extends Components.BlinkOnDemandMeter
{
	var penaltyMeterMovieClip: MovieClip;

	var CurrentPenaltyPercent: Number;
	var TargetPenaltyPercent: Number;
	var Empty: Number;
	var EmptySpeed: Number;
	var penaltyEmpty: Number;
	var Full: Number;
	var FillSpeed: Number;
	var penaltyFull: Number;


	function BlinkOnDemandPenaltyMeter(aMeterMovieClip: MovieClip, aBlinkMovieClip: MovieClip, aPenaltyMeterMovieClip: MovieClip)
	{
		super(aMeterMovieClip, aBlinkMovieClip);

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
			var shouldEmpty: Boolean = CurrentPenaltyPercent - TargetPenaltyPercent > EmptySpeed;
			if ((TargetPenaltyPercent > 0 && shouldEmpty) || CurrentPenaltyPercent > EmptySpeed)
			{
				if (shouldEmpty)
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