class FTA.INI
{
	public static function parse(text: String): Object
	{
		var result: Object = {};
		var currentSection: String = null;
		var lines: Array = text.split("\n");

		var inMultiline: Boolean = false;
		var multilineKey: String = "";
		var multilineValue: String = "";

		for (var i: Number = 0; i < lines.length; i++)
		{
			var rawLine: String = lines[i];
			var line: String = rawLine.split("\r").join("");
			var trimmed: String = FTA.INI.trim(line);

			if (!inMultiline && (trimmed.length == 0 || trimmed.indexOf(";") == 0 || trimmed.indexOf("#") == 0 || trimmed.indexOf("//") == 0))
				continue;

			if (!inMultiline && trimmed.indexOf("=\"\"\"") > -1)
			{
				var eqIndex: Number = trimmed.indexOf("=");
				multilineKey = FTA.INI.trim(trimmed.substring(0, eqIndex));
				multilineValue = trimmed.substring(eqIndex + 4) + "\n"; // skip ="""
				inMultiline = true;
				continue;
			}

			if (inMultiline)
			{
				if (trimmed.indexOf("\"\"\"") > -1)
				{
					multilineValue += trimmed.substring(0, trimmed.indexOf("\"\"\""));
					multilineValue = FTA.INI.decodeEscapes(multilineValue);

					if (currentSection != null)
						result[currentSection][multilineKey] = multilineValue;
					else
						result[multilineKey] = multilineValue;

					inMultiline = false;
					multilineKey = "";
					multilineValue = "";
				}
				else
				{
					multilineValue += rawLine + "\n";
				}
				continue;
			}

			if (trimmed.charAt(0) == "[" && trimmed.charAt(trimmed.length - 1) == "]")
			{
				currentSection = trimmed.substring(1, trimmed.length - 1);
				result[currentSection] = {};
				continue;
			}

			var eqIndex: Number = trimmed.indexOf("=");
			if (eqIndex > -1)
			{
				var key: String = FTA.INI.trim(trimmed.substring(0, eqIndex));
				var value: String = FTA.INI.trim(trimmed.substring(eqIndex + 1));
				value = FTA.INI.decodeEscapes(value);

				if (currentSection != null)
					result[currentSection][key] = value;
				else
					result[key] = value;
			}
		}

		return result;
	}

	private static function trim(str: String): String
	{
		while (str.charAt(0) == " ") str = str.substring(1);
		while (str.charAt(str.length - 1) == " ") str = str.substring(0, str.length - 1);
		return str;
	}

	private static function decodeEscapes(text: String): String
	{
		text = text.split("\\n").join("\n");
		text = text.split("\\t").join("\t");
		text = text.split("\\\\").join("\\");
		return text;
	}
}