class FTA.StringTools
{
	public static function parseBoolStringToObject(inputString: String): Object
	{
		var parts: Array = inputString.split(",");
		var resultObject: Object = {};

		for (var i: Number = 0; i < parts.length; i++)
		{
			var part: String = parts[i];

			if (part == "true" || part == "false")
				resultObject["Perk" + i] = (part == "true")
			else if (part.charAt(0) == "[" && part.charAt(part.length - 1) == "]")
			{
				var arrayStr: String = part.substring(1, part.length - 1);
				var arrayParts: Array = arrayStr.split(",");
				var currentPerk: Object;

				for (var j: Number = 0; j < arrayParts.length; j++)
					currentPerk["rank" + j] = arrayParts[j] == "true";

				resultObject["Perk" + i] = currentPerk;
			}
		}

		return resultObject;
	}

/*
	public static function stringifyBoolObjectToString(inputArray: Array): String
	{
		var result: String = "";

		for (var i: Number = 0; i < inputArray.length; i++)
		{
			var element: Object = inputArray[i];

			if (element is Array)
				result += "[" + convertArrayToString(element as Array) + "]";
			else
				result += element.toString();

			if (i < inputArray.length - 1)
				result += ",";
		}

		return result;
	}
	*/
}