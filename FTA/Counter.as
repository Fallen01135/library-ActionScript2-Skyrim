class FTA.Counter extends gfx.core.UIComponent
{
	var textField: TextField;
	var valueField: TextField;

	var _text: String = "";
	var _value: Number = 0;


	function Counter()
	{
		super();
	}

	function construct(text: String, value: Number): Void
	{
		if (text != undefined && text != "" && text != " ")
			this.text = text;

		if (value != undefined && value != -1)
			this.value = value;
	}


	//#region Setters/Getters
	function set text(text: String): Void
	{
		_text = text;
		textField.text = text;
	}

	function get text(): String
	{
		return _text;
	}

	function set value(value: Number): Void
	{
		_value = value;
		valueField.text = String(_value);
	}

	function get value(): Number
	{
		return _value;
	}
	//#endregion
}