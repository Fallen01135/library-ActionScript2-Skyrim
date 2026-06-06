class FTA.Button extends gfx.controls.Button
{
	var _colour;

	var mainObject: MovieClip;
	var selection: MovieClip;
	var line: MovieClip;
	var dot: MovieClip;

	var classID: Number;

	var canCall: Boolean = true;


	function Button()
	{
		super();
		mainObject = _parent._parent;
	}


	function get colour()
	{
		return this._colour;
	}

	function set colour(value)
	{
		this._colour = value;

		if (this.initialized)
		{
			if (this.selection != null)
			{
				var myColour: Color = new Color(this.selection);
				myColour.setRGB(this._colour)
			}

			if (this.line != null)
			{
				var myColour: Color = new Color(this.line);
				myColour.setRGB(this._colour)
			}

			if (this.dot != null)
			{
				var myColour: Color = new Color(this.dot);
				myColour.setRGB(this._colour)
			}
		}
	}

	function handleMousePress(controllerIdx, keyboardOrMouse, button)
	{
		if (this._disabled || (mainObject.btnSelectClass.selection._alpha == 100 && this.classID == undefined)) return undefined;

		if (!this._disableFocus)
			Selection.setFocus(this, controllerIdx);

		if (this.autoRepeat)
			this.buttonRepeatInterval = setInterval(this, "beginButtonRepeat", this.buttonRepeatDelay, controllerIdx, button);

		this.setState("down");
		this.dispatchEventAndSound({type: "press", controllerIdx: controllerIdx, button: button});
	}

	function handlePress(controllerIdx)
	{
		if (this._disabled || (mainObject.btnSelectClass.selection._alpha == 100 && this.classID == undefined)) return undefined;

		this.pressedByKeyboard = true;
		this.setState(this.focusIndicator == null ? "down" : "kb_down");
		this.dispatchEventAndSound({type: "press", controllerIdx: controllerIdx});
	}
}