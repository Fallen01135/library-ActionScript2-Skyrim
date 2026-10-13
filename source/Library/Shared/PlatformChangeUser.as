import Components.CrossPlatformButtons;

class Shared.PlatformChangeUser extends MovieClip
{
	static var PlatformChange;


	function PlatformChangeUser()
	{
		super();
		Shared.PlatformChangeUser.PlatformChange = new Shared.ButtonChange();
	}

	function RegisterPlatformChangeListener(aCrossPlatformButton: CrossPlatformButtons)
	{
		Shared.PlatformChangeUser.PlatformChange.addEventListener("platformChange", aCrossPlatformButton, "SetPlatform");
		Shared.PlatformChangeUser.PlatformChange.addEventListener("SwapPS3Button", aCrossPlatformButton, "SetPS3Swap");
	}
}