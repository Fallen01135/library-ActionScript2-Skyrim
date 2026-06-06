class FTA.Meter extends Components.Meter
{
	var _colour: Number;
	var fill: MovieClip;


	function Meter(aMovieClip: MovieClip)
	{
		super();
	}


	function get colour(): Number
	{
		return _colour;
	}

	function set colour(value: Number)
	{
		_colour = value;

		if (fill != null)
		{
			var myColour: Color = new Color(fill);
			myColour.setRGB(_colour)
		}
	}
}