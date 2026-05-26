class FTA.Utility
{
	static function getStatIDs(returnID: Boolean): Array
	{
		if (returnID == undefined)
			returnID = true;
		
		return [
			skyui.defines.Actor.AV_HEALTH,
			skyui.defines.Actor.AV_MAGICKA,
			skyui.defines.Actor.AV_STAMINA,
			skyui.defines.Actor.AV_CARRYWEIGHT,
			skyui.defines.Actor.AV_MAGICKARATE,
			skyui.defines.Actor.AV_STAMINARATE
		]
	}

	static function getAttributeIDs(returnID: Boolean): Array
	{
		if (returnID == undefined)
			returnID = true;

		return [
			returnID ? skyui.defines.Actor.AV_TWOHANDEDSKILLADVANCE : "$FTAAttributeStrength",
			returnID ? skyui.defines.Actor.AV_DESTRUCTIONSKILLADVANCE : "$FTAAttributeIntelligence",
			returnID ? skyui.defines.Actor.AV_ENCHANTINGSKILLADVANCE : "$FTAAttributeWillpower",
			returnID ? skyui.defines.Actor.AV_SNEAKSKILLADVANCE : "$FTAAttributeAgility",
			returnID ? skyui.defines.Actor.AV_LIGHTARMORSKILLADVANCE : "$FTAAttributeSpeed",
			returnID ? skyui.defines.Actor.AV_HEAVYARMORSKILLADVANCE : "$FTAAttributeEndurance",
			returnID ? skyui.defines.Actor.AV_SPEECHCRAFTSKILLADVANCE : "$FTAAttributePersonality",
			returnID ? skyui.defines.Actor.AV_PICKPOCKETSKILLADVANCE : "$FTAAttributeLuck"
		];
	};

	static function getSkillIDs(returnID: Boolean): Array
	{
		if (returnID == undefined)
			returnID = true;

		return [
			returnID ? skyui.defines.Actor.AV_MARKSMAN : "$FTAMarksman",
			returnID ? skyui.defines.Actor.AV_BLOCK : "$FTABlock",
			returnID ? skyui.defines.Actor.AV_HEAVYARMOR : "$FTAHeavyArmor",
			returnID ? skyui.defines.Actor.AV_ONEHANDED : "$FTAOneHanded",
			returnID ? skyui.defines.Actor.AV_SMITHING : "$FTASmithing",
			returnID ? skyui.defines.Actor.AV_TWOHANDED : "$FTATwoHanded",

			returnID ? skyui.defines.Actor.AV_ALTERATION : "$FTAAlteration",
			returnID ? skyui.defines.Actor.AV_CONJURATION : "$FTAConjuration",
			returnID ? skyui.defines.Actor.AV_DESTRUCTION : "$FTADestruction",
			returnID ? skyui.defines.Actor.AV_ENCHANTING : "$FTAEnchanting",
			returnID ? skyui.defines.Actor.AV_ILLUSION : "$FTAIllusion",
			returnID ? skyui.defines.Actor.AV_RESTORATION : "$FTARestoration",

			returnID ? skyui.defines.Actor.AV_ALCHEMY : "$FTAAlchemy",
			returnID ? skyui.defines.Actor.AV_LIGHTARMOR : "$FTALightArmor",
			returnID ? skyui.defines.Actor.AV_LOCKPICKING : "$FTALockpicking",
			returnID ? skyui.defines.Actor.AV_PICKPOCKET : "$FTAPickpocket",
			returnID ? skyui.defines.Actor.AV_SNEAK : "$FTASneak",
			returnID ? skyui.defines.Actor.AV_SPEECHCRAFT : "$FTASpeechcraft"
		];
	};

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

	// Calculates stats based on the provided data arrays.
	// dataCalc: Array containing calculation data.
	// dataAtt: Array containing attribute data. These are most likely the base values of the attributes plus the modifiers the menu has set.
	static function calculateStats(dataCalc: Object, dataAtt: Array): Array
	{
		var health: Number = int((dataCalc.healthBase + (dataAtt[5] * int(dataCalc.healthPerEnd))) + (dataCalc.playerLevel * dataCalc.healthLevelMult))
		var magicka: Number = int(dataCalc.magickaBase + (dataAtt[1] * dataCalc.magickaPerInt))
		var stamina: Number = int(dataCalc.staminaBase + (dataAtt[5] + dataAtt[0] + dataAtt[3] + dataAtt[2]))
		var carryWeight: Number = int(dataCalc.carryWeightBase + (dataAtt[0] * dataCalc.carryWeightPerStr))
		var magickaRegen: Number = Math.min(0, dataCalc.magickaReturnBase + (dataCalc.magickaReturnMult * dataAtt[5]))
		var staminaRegen: Number = dataCalc.staminaReturnBase + (dataCalc.staminaReturnMult * dataAtt[5])
		var speedMult: Number = int(dataCalc.moveCharWalkMin + (dataCalc.moveCharWalkMax - dataCalc.moveCharWalkMin) * clamp(dataAtt[4], 0.000000, 150.000000) / 100.000000)

		return [health, magicka, stamina, carryWeight, magickaRegen, staminaRegen, speedMult];
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
}