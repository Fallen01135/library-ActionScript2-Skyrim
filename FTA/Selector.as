import FTA.Colour;


class FTA.Selector extends gfx.controls.Button
{
	var icon: MovieClip;
	var textField: TextField;
	var valueField: TextField;

	var _text: String = "";
	var _value: Number = 0;
	var _valueExtra: Number = 0;
	var _steps: Number = 0;
	var _selected: Boolean = false;
	var _block: Boolean = false;
	var _identifier: Number = 0;


	function Selector()
	{
		super();

		textField.html = true;
		valueField.html = true;
	}

	function construct(value: Number, steps: Number): Void
	{
		if (value != undefined && value != -1)
			this.value = value;

		if (steps != undefined && steps != -1)
			this.steps = steps;
	}

	private function changeFocus(): Void
	{
		if (block)
			return;

		super.changeFocus()
	}

	private function handleMouseRollOver(controllerIdx: Number): Void
	{
		if (block)
			return;

		super.handleMouseRollOver(controllerIdx);

		gotoAndPlay("over");
		updateText(Colour.GREY_NEUTRAL);
	}

	private function handleMouseRollOut(controllerIdx: Number): Void
	{
		if (block)
			return;

		super.handleMouseRollOut(controllerIdx);

		gotoAndPlay("out");
		updateText(Colour.WHITE);
	}

	private function handleMousePress(controllerIdx: Number, keyboardOrMouse: Number, button: Number): Void
	{
		if (block)
			return;

		super.handleMousePress(controllerIdx, keyboardOrMouse, button)

		selected = !selected;
		toggleIcon(selected);
		updateText(Colour.GREY_NEUTRAL);

		dispatchEvent({type: "selected", identifier: identifier});
	}

	private function handlePress(controllerIdx: Number): Void
	{
		if (block)
			return;

		super.handlePress(controllerIdx)

		selected = !selected;
		toggleIcon(selected);
		updateText(Colour.GREY_NEUTRAL);

		dispatchEvent({type: "selected", identifier: identifier});
	}

	private function handleMouseRelease(controllerIdx: Number, keyboardOrMouse: Number, button: Number): Void
	{
		if (block)
			return;

		super.handleMouseRelease(controllerIdx, keyboardOrMouse, button)
	}

	private function handleRelease(controllerIdx:Number): Void
	{
		if (block)
			return;

		super.handleRelease(controllerIdx)
	}

	private function handleDragOver(controllerIdx: Number, button: Number): Void
	{
		if (block)
			return;

		super.handleDragOver(controllerIdx, button)
	}

	private function handleDragOut(controllerIdx: Number, button: Number): Void
	{
		if (block)
			return;

		super.handleDragOut(controllerIdx, button)
	}

	private function handleReleaseOutside(controllerIdx: Number, button: Number): Void
	{
		if (block)
			return;

		super.handleReleaseOutside(controllerIdx, button)
	}

	//#region Setters/Getters
	function set value(value: Number): Void
	{
		_value = value;
		valueField.text = valueText(true);
	}

	function get value(): Number
	{
		return _value;
	}

	function set valueExtra(value: Number): Void
	{
		_valueExtra = value;
		valueField.text = valueText(true);
	}

	function get valueExtra(): Number
	{
		return _valueExtra;
	}

	function set steps(value: Number): Void
	{
		_steps = value;
	}
	
	function get steps(): Number
	{
		return _steps;
	}

	function set selected(value: Boolean): Void
	{
		_selected = value;
	}
	
	function get selected(): Boolean
	{
		return _selected;
	}

	function set block(value: Boolean): Void
	{
		_block = value;
	}
	
	function get block(): Boolean
	{
		return _block;
	}

	function set identifier(value: Number): Void
	{
		_identifier = value;
	}
	
	function get identifier(): Number
	{
		return _identifier;
	}
	//#endregion

	function toggleIcon(state: Boolean): Void
	{
		icon._alpha = state ? 100 : 0;
		selected = state;
	}

	function changeState(state: Boolean): Void
	{
		if (selected)
			return;

		block = disabled = state;
		updateText()
	}

	function updateText(highlight: Object): Void
	{
		if (highlight == undefined)
			highlight = Colour.WHITE;

		textField.htmlText = "<font color='" + (block ? Colour.GREY_LIGHTEST.html : highlight.html) + "'>" + label + "</font>";
		valueField.htmlText = "<font color='" + (block ? Colour.GREY_LIGHTEST.html : selected ? Colour.GREEN_BRIGHT.html : Colour.WHITE.html) + "'>" + valueText(selected) + "</font>";
	}

	function valueText(withSteps: Boolean): String
	{
		return "" + (value + valueExtra + (withSteps ? steps : 0));
	}
}