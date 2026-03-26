class Shared.ButtonChange extends gfx.events.EventDispatcher
{
	var iCurrPlatform: Number = Shared.ButtonChange.PLATFORM_360;

	static var PLATFORM_PC: Number = 0;
	static var PLATFORM_PC_GAMEPAD: Number = 1;
	static var PLATFORM_360: Number = 2;
	static var PLATFORM_PS3: Number = 3;
	static var PLATFORM_SCARLETT: Number = 4;
	static var PLATFORM_PROSPERO: Number = 5;


	function ButtonChange()
	{
		super();
		gfx.events.EventDispatcher.initialize(this);
	}

	function get Platform(): Number
	{
		return iCurrPlatform;
	}

	function IsGamepadConnected(): Boolean
	{
		return iCurrPlatform >= Shared.ButtonChange.PLATFORM_PC_GAMEPAD
	}

	function SetPlatform(aSetPlatform: Number, aSetSwapPS3: Boolean): Void
	{
		iCurrPlatform = aSetPlatform;
		dispatchEvent
		(
			{
				target: this,
				type: "platformChange",
				aPlatform: aSetPlatform,
				aSwapPS3: aSetSwapPS3
			}
		);
	}

	function SetPS3Swap(aSwap: Boolean): Void
	{
		dispatchEvent
		(
			{
				target: this,
				type: "SwapPS3Button",
				Boolean: aSwap
			}
		);
	}
}