class FTA.TextInput extends gfx.controls.TextArea
{
	function TextInput()
	{
		super();
	}

	function get textOrDefault()
	{
		return text == "" ? defaultText : text;
	}

	function changeFocus()
	{
		super.changeFocus();

		_parent.bIsInput = _focused;
		skse.AllowTextInput(_parent.bIsInput)

		if (_focused && textField.text == skyui.util.Translator.translate(defaultText))
			textField.text = "";
	}

	function updateText()
	{
		if (_text != "")
		{
			textField.html = isHtml;
			textField[isHtml ? "htmlText" : "text"] = _text;
		}
		else
		{
			textField.text = "";
			if (!_focused && defaultText != "")
				textField.text = defaultText;
		}

		textField.text == skyui.util.Translator.translate(defaultText)
		updateScrollBar();
	}
}