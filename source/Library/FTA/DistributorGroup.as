import FTA.Distributor;


class FTA.DistributorGroup extends gfx.core.UIComponent
{
	var allDistributors: Array = [];
	var allValueInc: Array = [];

	var parent: MovieClip;

	var maxSelected: Number = 8;
	var maxPoints: Number = 10;


	function DistributorGroup()
	{
		super();
	}


	function construct(parent: MovieClip, maxSelected: Number, maxPoints: Number, steps: Number, values: Array, limit: Number): Void
	{
		this.parent = parent;
		this.maxSelected = maxSelected;
		this.maxPoints = maxPoints;

		var i: Number = 0;
		var lastDistributor: Boolean = false;
		while (!lastDistributor)
		{
			var newDistributor: Distributor = this["distributor" + i];

			if (newDistributor)
			{
				allDistributors[i] = newDistributor;
				newDistributor.construct(this, steps, values[i], limit);
				allValueInc[i] = 0;
			}
			else
				lastDistributor = true;

			i++;
		}
	}

	function valueChange(value: Number, selected: Number): Void
	{
		var combinedValue: Number = 0;
		var numberSelected: Number = 0;

		for (var i: Number = 0; i < allDistributors.length; i++)
		{
			var distributor: Distributor = allDistributors[i];
			combinedValue += distributor.valueInc;
			allValueInc[i] = distributor.valueInc;

			if (distributor.selected)
				numberSelected += 1;
		}

		for (var i: Number = 0; i < allDistributors.length; i++)
		{
			var distributor: Distributor = allDistributors[i];
			var enable: Boolean = combinedValue < maxPoints;

			if (!distributor.selected)
				enable = enable && numberSelected < maxSelected;

			distributor.enableRightArrows(enable);
		}

		if (parent != undefined)
			parent.valueChange(combinedValue, numberSelected);
	}
}