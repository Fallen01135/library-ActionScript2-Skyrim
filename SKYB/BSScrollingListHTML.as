import Shared.BSScrollingList;

class SKYB.BSScrollingListHTML extends BSScrollingList
{
	/* GamepadDoubleClick fix */
	var canCall: Boolean = true;
	var curSelected;


	function BSScrollingListHTML()
	{
		super();
	}

	function moveSelectionUp()
	{
		if (EntriesA.length != 1)
			scrollPosition = scrollPosition - 1;
	}

	function moveSelectionDown()
	{
		if (EntriesA.length != 1)
			scrollPosition = scrollPosition + 1;
	}

	function SetEntryText(aEntryClip, aEntryObject)
	{
		if (aEntryClip.textField != undefined)
		{
			if (textOption == BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT)
				aEntryClip.textField.textAutoSize = "shrink";
			else if (textOption == BSScrollingList.TEXT_OPTION_MULTILINE)
				aEntryClip.textField.verticalAutoSize = "top";

			if (aEntryObject.text != undefined)
				aEntryClip.textField.SetText(aEntryObject.text, true);
			else
				aEntryClip.textField.SetText(" ");
		}
	}
}