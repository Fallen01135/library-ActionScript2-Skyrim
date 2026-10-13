class Shared.Proxy
{
	function Proxy()
	{
	}

	static function create(oTarget: Object, fFunction: Function): Function
	{
		var aParameters: Array = new Array();
		var numArguments: Number = arguments.length;

		for (var i: Number = 2; i < numArguments; i++)
			aParameters[i - 2] = arguments[i];

		var callbackFunction: Function = function(): Void
		{
			var args: Array = arguments.concat(aParameters);
			fFunction.apply(oTarget, args);
		};

		return callbackFunction;
	}
}