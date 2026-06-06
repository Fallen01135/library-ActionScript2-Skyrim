import skyui.util.Translator;


class SKYBTextHeader extends MovieClip
{
	var textField: TextField;
	var lineLeft: MovieClip;
	var lineRight: MovieClip;
	var pointerLeft: MovieClip;
	var pointerRight: MovieClip;

	var _text: String = "HeaderText";
	var _textOption: String = "shrink";
	var _font: String = "$EverywhereMediumFont"; // The font to use for the text
	var _textSize: Number = 26; // The size of the font in pixels
	var _boxWidth: Number = 200; // Default size of the text box
	var _baseLineWidth: Number = 220; // Default width of the line, without the text
	var _pointerScale: Number = 100; // The scale of the pointer, if it exists
	var _padding: Number = 10; // The padding between the text and the line
	var _alphaValue: Number = 100; // The alpha value of the pointers or the lines
	var _textColour: Number = 0x000000; // The colour of the text


	function SKYBTextHeader()
	{
		super();
	}

	function set label(text: String): Void
	{
		if (text == null || text == "")
			return;

		_text = text;
	}

	function get label(): String
	{
		return _text;
	}

	function set textOption(option: String): Void
	{
		_textOption = option;
	}

	function get textOption(): String
	{
		return _textOption;
	}

	function set font(value: String): Void
	{
		_font = value;
	}

	function get font(): String
	{
		return _font;
	}

	function set textSize(size: Number): Void
	{
		_textSize = size;
	}

	function get textSize(): Number
	{
		return _textSize;
	}

	function set textBoxWidth(value: Number): Void
	{
		_boxWidth = value;
	}

	function get textBoxWidth(): Number
	{
		return _boxWidth;
	}

	function set baseLineWidth(width: Number): Void
	{
		_baseLineWidth = width;
	}

	function get baseLineWidth(): Number
	{
		return _baseLineWidth;
	}

	function set pointerScale(scale: Number): Void
	{
		_pointerScale = scale
	}

	function get pointerScale(): Number
	{
		return _pointerScale;
	}

	function set padding(value: Number): Void
	{
		_padding = value;
	}

	function get padding(): Number
	{
		return _padding;
	}

	function set alpha(value: Number): Void
	{
		_alphaValue = value;
	}

	function get alpha(): Number
	{
		return _alphaValue;
	}

	function set textColour(color: Number): Void
	{
		_textColour = color;
	}

	function get textColour(): Number
	{
		return _textColour;
	}

	// This updates the header, so that it displays the correct text and layout
	function updateLayout(): Void
	{
		textField.textAutoSize = _textOption;

		// Set the text
		textField.html = true;
		textField.htmlText = Translator.translate(_text);

		// Set the text size
		var format: TextFormat = new TextFormat();
		format.size = _textSize;
		format.font = _font;
		format.color = _textColour;
		textField.setTextFormat(format);

		// Set the text field to the correct size
		textField._width = _boxWidth;
		textField._height = textField.textHeight + 10;
		textField._x = -textField._width / 2;
		textField._y = 0;

		var fTextWidth: Number = textField.textWidth / 2;
		var fTextHeight: Number = textField.textHeight / 2;

		if (pointerLeft != undefined && pointerRight != undefined)
		{
			pointerRight._xscale = pointerRight._yscale = pointerLeft._xscale = pointerLeft._yscale = _pointerScale;

			pointerLeft._x = -_padding - fTextWidth;
			pointerRight._x = _padding + fTextWidth;

			pointerLeft._y = textField._y + (textField._height - pointerLeft._height) / 2 + pointerLeft._height / 2;
			pointerRight._y = textField._y + (textField._height - pointerRight._height) / 2 + pointerRight._height / 2;

			pointerLeft._alpha = _alphaValue;
			pointerRight._alpha = _alphaValue;
		}
		else
		{
			lineRight._xscale = lineRight._yscale = lineLeft._xscale = lineLeft._yscale = _pointerScale;

			// Set the line positions and widths
			var lineWidth: Number = _baseLineWidth - fTextWidth - _padding;
			lineRight._x = _baseLineWidth;
			lineLeft._x = -_baseLineWidth;

			if (lineWidth < 0)
				lineWidth = 0;

			lineRight._width = lineLeft._width = lineWidth;

			// Saubere Zentrierung an der Textbox selbst
			lineLeft._y  = textField._y + (textField._height / 2);
			lineRight._y = textField._y + (textField._height / 2);

			lineLeft._alpha = _alphaValue;
			lineRight._alpha = _alphaValue;
		}
	}
}