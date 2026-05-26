import gfx.controls.Button;
import FTA.Utility;
import FTA.Colour;
import mx.utils.Delegate;
import skyui.util.Translator;


class FTA.Distributor extends gfx.core.UIComponent
{
	var Right: Button;
	var Left: Button;
	var Icon: MovieClip;
	var HitBox: MovieClip;
	var textField: TextField;
	var valueField: TextField;
	var increaseField: TextField;

	var partner: MovieClip;

	var _text: String = "";
	var _value: Number = 0;
	var _valueInc: Number = 0;
	var _limit: Number = 0;
	var _selected: Boolean = false;
	var _steps: Number = 1;


	function Distributor()
	{
		super();
	}

	function construct(partner: MovieClip, steps: Number, value: Number, limit: Number): Void
	{
		this.partner = partner;
		this.steps = steps;
		this.value = value;
		this.limit = limit;

		initEvents();
		valueField.html = true;

		if (_valueInc == 0)
		{
			toggleIcon(false);
			Left.disabled = true;
			Left._visible = false;
		}
	}

	function initEvents(): Void
	{
		// Init Increase Button
		Right.addEventListener("press", this, "onIncrease")
		Right.addEventListener("rollOver", this, "buttonOver")
		Right.addEventListener("rollOut", this, "buttonOut")

		// Init Decrease Button
		Left.addEventListener("press", this, "onDecrease")
		Left.addEventListener("rollOver", this, "buttonOver")
		Left.addEventListener("rollOut", this, "buttonOut")

		HitBox.onRollOver = Delegate.create(this, handleMouseRollOver);
		HitBox.onRollOut = Delegate.create(this, handleMouseRollOut);
	}

	//#region Events
	function buttonOver(event: Object): Void
	{
		handleMouseRollOver();
	}

	function buttonOut(event: Object): Void
	{
		var over: Boolean = HitBox.hitTest(_root._xmouse, _root._ymouse, true)

		if (!over)
			gotoAndPlay("up");
	}

	function handleMouseRollOver(): Void
	{
		gotoAndPlay("over");
	}

	function handleMouseRollOut(): Void
	{
		var over: Boolean = Right.hitTest(_root._xmouse, _root._ymouse, true) || Left.hitTest(_root._xmouse, _root._ymouse, true)

		if (!over)
			gotoAndPlay("up");
	}
	//#endregion

	//#region Setters/Getters
	function set text(text: String): Void
	{
		_text = text;
		textField.text = _text;
	}
	
	function get text(): String
	{
		return _text;
	}

	function set value(value: Number): Void
	{
		_value = value;
		valueField.text = "" + _value;
	}
	
	function get value(): Number
	{
		return _value;
	}

	function set valueInc(value: Number): Void
	{
		_valueInc = value;
		increaseField.text = "" + _valueInc;
		valueField.htmlText = "<font color='" + (_valueInc > 0 ? Colour.GREEN_BRIGHT.html : Colour.WHITE.html) + "'>" + (_value + _valueInc) + "</font>";
	}
	
	function get valueInc(): Number
	{
		return _valueInc;
	}

	function set limit(value: Number): Void
	{
		_limit = value;
	}
	
	function get limit(): Number
	{
		return _limit;
	}

	function set selected(value: Boolean): Void
	{
		_selected = value;
	}
	
	function get selected(): Boolean
	{
		return _selected;
	}

	function set steps(value: Number): Void
	{
		_steps = value;
	}
	
	function get steps(): Number
	{
		return _steps;
	}
	//#endregion

	//#region Utilities
	function toggleIcon(state: Boolean): Void
	{
		Icon._alpha = state ? 100 : 0;
		selected = state;
	}

	function enableRightArrows(enable: Boolean): Void
	{
		var isMax: Boolean = valueInc == limit;
		
		Right.disabled = !enable || isMax;
		Right._visible = !Right.disabled;
	}

	function enableLeftArrows(enable: Boolean): Void
	{
		var isIncreased: Boolean = valueInc > 0;

		Left.disabled = !enable || !isIncreased;
		Left._visible = !Left.disabled;
	}
	//#endregion

	function onIncrease(): Void
	{
		use(steps);
	}

	function onDecrease(): Void
	{
		use(-steps);
	}

	function use(steps: Number): Void
	{
		valueInc = Utility.clamp(valueInc + steps, 0, limit);

		var isIncreased: Boolean = valueInc > 0;

		toggleIcon(isIncreased);
		enableRightArrows(true);
		enableLeftArrows(true);

		if (partner != undefined)
			partner.valueChange(valueInc, isIncreased ? 1 : 0);
	}
}