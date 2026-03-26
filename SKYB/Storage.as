class SKYB.Storage
{
	static function save(slot: Number, data: Array): Void
	{
		var payload: String = data.join("|");
		skse.SendModEvent("SKYBSaveData", payload, slot);
	}

	static function load(slot: Number, menuName: String, callbackPath: String): Void
	{
		var callString: String = menuName + "," + callbackPath;
		skse.SendModEvent("SKYBLoadData", callString, slot);
	}

	static function clear(slot: Number): Void
	{
		skse.SendModEvent("SKYBClearData", "", slot);
	}

	static function parseCSV(payload: String, type: String): Array
	{
		var outputArray: Array = payload.split("|");
			
		for (var i: Number = 0; i < outputArray.length; i++)
		{
			switch(type)
			{
				case "number":
					outputArray[i] = Number(outputArray[i]);
					break;
				case "float":
					outputArray[i] = parseFloat(outputArray[i]);
					break;
				case "boolean":
					outputArray[i] = outputArray[i] == "true";
					break;
			}
		}
			
		return outputArray;
	}
}