class FTA.ButtonHTML extends gfx.controls.Button
{
	var menuType: String = "";
	var identifier: String = "";
	var btnID: Number = -1;


	function Button()
	{
		super();
	}


	function set label(value: String): Void
	{
		_label = value;
		if (initialized)
		{
			if (textField != null)
			{
				textField.html = true;
				textField.htmlText = _label;
			}

			if (autoSize != "none")
				sizeIsInvalid = true;

			updateAfterStateChange();
		}
	}

	function updateAfterStateChange(): Void
	{
		if (!initialized)
			return;

		if (textField != null && _label != null)
		{
			textField.html = true;
			textField.htmlText = _label;
		}

		validateNow();

		if (constraints != null)
			constraints.update(width, height);

		dispatchEvent({type: "stateChange", state: state});
	}
}