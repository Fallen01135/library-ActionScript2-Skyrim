import FTA.Selector;


class FTA.SelectorGroup extends gfx.core.UIComponent
{
	var textField: TextField;
	var valueField: TextField;

	var allSelectors: Array = [];
	var max: Number = 2;


	function SelectorGroup()
	{
		super();
	}


	function set extraValue(arr: Array): Void
	{
		for (var i: Number; i < allSelectors.length; i++)
			allSelectors[i].valueExtra = arr[i];
	}

	function get extraValue(): Array
	{
		var extra: Array;

		for (var i: Number; i < allSelectors.length; i++)
			extra[i] = allSelectors[i].valueExtra;

		return extra;
	}

	function construct(max: Number, steps: Number, values: Array): Void
	{
		this.max = max;

		var i: Number = 0;
		var lastSelector: Boolean = false;
		while (!lastSelector)
		{
			var newSelector: Selector = this["selector" + i];
			if (newSelector)
			{
				allSelectors[i] = newSelector;
				newSelector.construct(values[i], steps);
				newSelector.identifier = i;
				newSelector.addEventListener("selected", this, "onSelect")
			}
			else
				lastSelector = true;

			i++;
		}
	}

	function onSelect(event: Object): Void
	{
		skse.Log("Selecting")

		var numberSelected: Number = 0;

		for (var i: Number = 0; i < allSelectors.length; i++)
		{
			var selector: Selector = allSelectors[i];

			if (selector.selected)
				numberSelected += 1;
		}

		for (var i: Number = 0; i < allSelectors.length; i++)
		{
			var selector: Selector = allSelectors[i];
			selector.changeState(numberSelected >= max);
		}
		skse.Log("Selecting: " + numberSelected)

		dispatchEvent({type: "selected", identifier: event.target.identifier, curSelected: numberSelected});
	}
}