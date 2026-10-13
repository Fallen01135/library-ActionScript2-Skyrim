class FTA.Utility
{
	static function logObject(obj: Object, indent: String): Void
	{
		for (var key in obj)
		{
			var value = obj[key];
			if (typeof(value) == "object")
			{
				skse.Log(indent + key + ": {");
				logObject(value, indent + "  ");
				skse.Log(indent + "}");
			}
			else
				skse.Log(indent + key + ": " + value);
		}
	}
	
	static function toSigned32Bit(num: Number): Number
	{
		return (num > 2147483647) ? num - 4294967296 : num;
	}

	static function convertToHex(input: Number): String
	{
		return input.toString(16).toUpperCase();
	}

	static function sortByIndex(a, b): Number
	{
		return a.index - b.index;
	}

	static function processFormID(input: String): String
	{
		// Split the input string at the "|" character
		var parts: Array = input.split("|");
		return (parts.length == 2)
			? parseInt(parts[0], 16) + "|" + parts[1]
			: null;
	}

	static function flattenArray(arr: Array): Array
	{
		var result: Array = [];

		for (var i: Number = 0; i < arr.length; i++)
			result = result.concat(arr[i] instanceof Array ? flattenArray(arr[i]) : arr[i]);

		return result;
	}

	static function clamp(value: Number, min: Number, max: Number): Number
	{
		return Math.max(min, Math.min(value, max))
	}

	static function shortenFloat(floatValue: Number, decimalPlaces: Number): Number
	{
		var pow: Number = Math.pow(10, decimalPlaces);
		return Math.round(floatValue * pow) / pow;
	}

	static function setCursorPosition(x: Number, y: Number, stageWidth: Number, stageHeight: Number): Void
	{
		var cursor: Object =
		{
			x: (x / stageWidth) * 640, 
			y: (y / stageHeight) * 480
		};

		var msg: String = x + "," + y + "," + cursor.x + "," + cursor.y;
		skse.SendModEvent("SetCursorPosition", msg);
	}

	static function setGradient(mc: MovieClip, colours: Array, alphas: Array, ratios: Array): Void
	{
		if (mc != null && colours.length > 0)
		{
			var fillType: String = "linear";
			var matrix: Object = {matrixType: "box", x: 0, y: 0, w: mc._width, h: mc._height, r: 0};

			mc.clear();
			mc.beginGradientFill(fillType, colours, alphas, ratios, matrix);
			mc.moveTo(0, 0);
			mc.lineTo(mc._width, 0);
			mc.lineTo(mc._width, mc._height);
			mc.lineTo(0, mc._height);
			mc.lineTo(0, 0);
			mc.endFill();
		}
	}

	static function setColour(mc: MovieClip, colour: Number): Void
	{
		if (mc != null)
		{
			var myColour: Color = new Color(mc);
			myColour.setRGB(colour)
		}
	}

	static var translateBox: TextField;
	static function translate(text: String): String
	{
		if (!translateBox)
		{
			translateBox = _root.createTextField("translateBox", _root.getNextHighestDepth(), 0, 0, 1, 1);

			translateBox._alpha = 0;
			translateBox._visible = false;
		}

		translateBox.text = text;

		return translateBox.text;
	}
}