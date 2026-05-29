import FTA.PlatformButtons;

class HotkeyBar extends MovieClip
{
	var Background: MovieClip;
	var frame: MovieClip;

	var iIndex: Number = 0;
	var spacing: Number = 15;
	var purgeButtons: Boolean = false;

	var allHotkeys: Array = [];


	function HotkeyBar()
	{
		super();
		Background._alpha = 0;
	}


	function addHotkey(iPlatform: Number, bPS3Swap: Boolean, text: String, Art: Array, bDisableConstraints: Boolean, bIsDisabled: Boolean, bDisableFocus: Boolean, bToggle: Boolean, bIsVisible: Boolean): Boolean
	{
		var hotkey: PlatformButtons = PlatformButtons(this.attachMovie("PlatformButtonLarge", "Hotkey_" + iIndex++, getNextHighestDepth()));
		if (hotkey == undefined)
		{
			iIndex--;
			return false;
		}

		allHotkeys.push(hotkey);

		hotkey.label = text;
		hotkey.textField.html = true;
		hotkey.textField.htmlText = text;

		hotkey.PCArt = Art[0];
		if (Art[1] != undefined || Art[1] != "")
			hotkey.PCArtSecondary = Art[1];

		hotkey.XBoxArt = Art[2];
		if (Art[3] != undefined || Art[3] != "")
			hotkey.XBoxArtSecondary = Art[3];

		hotkey.PS3Art = Art[4];
		if (Art[5] != undefined || Art[5] != "")
			hotkey.PS3ArtSecondary = Art[5];

		hotkey.disableConstraints = bDisableConstraints;
		// hotkey.isDisabled = bIsDisabled;
		hotkey.disableFocus = bDisableFocus;
		hotkey.toggle = bToggle;
		// hotkey.isVisible = bIsVisible;

		hotkey.SetPlatform(iPlatform, bPS3Swap);

		hotkey._x = allHotkeys.length == 1 ? 0 - hotkey._width : allHotkeys[allHotkeys.length - 2]._x - spacing - hotkey._width;
		hotkey._y = -hotkey._height / 2;

		var totalWidth: Number = 0;
		for (var i: Number = 0; i < allHotkeys.length; i++)
			totalWidth += allHotkeys[i]._width + (i > 0 ? spacing : 0);

		frame.full._width = 320 + totalWidth - 50;
		frame.fadeOut._x = frame.full._x - frame.full._width;

		return true;
	}

	function disableFrame(): Void
	{
		frame._visible = false;
	}

	function populateHotkeys(aiPlatform: Number, bPS3Swap: Boolean, bUseFrame: Boolean, keyArray: Array): Void
	{
		var iKeys: Number = 0;

		iIndex = 0;
		removeAllHotkeys();

		for (var i: Number = 0; i < keyArray.length; i++)
		{
			var hotkey = keyArray[i];
			if (hotkey.showOn == "both" || (hotkey.showOn == "gamepad" && aiPlatform != 0) || (hotkey.showOn == "keyboard" && aiPlatform == 0))
			{
				var bHotkeyAdded: Boolean = addHotkey(aiPlatform, bPS3Swap, hotkey.text, hotkey.keys, false, false, true, false, true);
				if (bHotkeyAdded)
					iKeys++;
			}
		}

		if (iKeys == 0 || !bUseFrame)
			disableFrame();
	}

	function removeAllHotkeys(): Void
	{
		for (var i: Number = 0; i < allHotkeys.length; i++)
			allHotkeys[i].removeMovieClip();

		allHotkeys = [];
	}
}