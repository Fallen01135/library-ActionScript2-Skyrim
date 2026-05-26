import gfx.io.GameDelegate;
import Shared.Proxy;
import Shared.ButtonChange;

class SKYB.PlatformButtons extends SKYB.ButtonHTML
{
	var ButtonArt: MovieClip;
	var ButtonArt_mc: MovieClip;
	var ButtonArtSecondary: MovieClip;
	var ButtonArtSecondary_mc: MovieClip;
	var border: MovieClip;

	var textField: TextField;

	var CurrentPlatform: Number;

	var PS3Swapped: Boolean;

	var PCButton: String;
	var XBoxButton: String;
	var PS3Button: String;
	var PCButtonSecondary: String = null;
	var XBoxButtonSecondary: String = null;
	var PS3ButtonSecondary: String = null;

	var OnTextFieldChanged: Function;


	function PlatformButtons()
	{
		super();
		textField.onChanged = Proxy.create(this, Reposition);
		GameDelegate.call("myLog", ["PlatformButtons::PlatformButtons"]);
	}

	function onLoad(): Void
	{
		super.onLoad();

		if (_parent.onButtonLoad != undefined)
		{
			_parent.onButtonLoad(this);
		}

		GameDelegate.call("myLog", ["PlatformButtons::onLoad"]);
	}

	function swapPS3Buttons(button: String): String
	{
		if (button == "PS3_A") return "PS3_B";
		if (button == "PS3_B") return "PS3_A";
		return button;
	}

	function mapToPS5Buttons(button: String): String
	{
		return button.replace("PS3_", "PS5_");
	}

	function adjustArtPositioning(): Void
	{
		var originalRatio: Number = ButtonArt_mc._width / ButtonArt_mc._height;
		ButtonArt_mc._height = border._height;
		ButtonArt_mc._width = ButtonArt_mc._height * originalRatio;
		ButtonArt_mc._y = (_height - ButtonArt_mc._height) / 2;

		// ButtonArt_mc._x -= ButtonArt_mc._width * 2 + 2;
		ButtonArt_mc._y = (_height - ButtonArt_mc._height) / 2;

		if (ButtonArtSecondary_mc != null)
		{
			var ratioSecondary: Number = ButtonArtSecondary_mc._width / ButtonArtSecondary_mc._height;
			ButtonArtSecondary_mc._height = border._height;
			ButtonArtSecondary_mc._width = ButtonArtSecondary_mc._height * ratioSecondary;

			ButtonArtSecondary_mc._y = ButtonArt_mc._y;
			ButtonArtSecondary_mc._x = ButtonArt_mc._width;
		}

		textField._x = ButtonArt_mc._width + (ButtonArtSecondary_mc != null ? ButtonArtSecondary_mc._width : 0) + 5;

		textField._width = textField.textWidth + 10;
		border._width = textField.textWidth + ButtonArt_mc._width + (ButtonArtSecondary_mc != null ? ButtonArtSecondary_mc._width : 0) + 10;
	}

	function Reposition(): Void
	{
		// if (ButtonArtSecondary_mc != null)
		// 	ButtonArtSecondary_mc._x = textField._width;

		if (OnTextFieldChanged != undefined)
			OnTextFieldChanged.call();
	}

	function SetPlatform(aiPlatform: Number, aSwapPS3: Boolean): Void
	{
		GameDelegate.call("myLog", ["PlatformButtons::SetPlatform"]);

		if (aiPlatform != undefined)
		{
			CurrentPlatform = aiPlatform;

			// if (aiPlatform != 0)
				// textField.textColor = 0xFFFFFF;
		}

		if (aSwapPS3 != undefined)
			PS3Swapped = aSwapPS3;

		RefreshArt();
	}

	function RefreshArt(): Void
	{
		if (ButtonArt != undefined)
			ButtonArt.removeMovieClip();
	
		if (ButtonArtSecondary != undefined)
			ButtonArtSecondary.removeMovieClip();

		switch (CurrentPlatform)
		{
			case ButtonChange.PLATFORM_PC:
				if (PCButton != "None")
					ButtonArt_mc = attachMovie(PCButton, "ButtonArt", getNextHighestDepth());

				if (PCButtonSecondary != null)
					ButtonArtSecondary_mc = attachMovie(PCButtonSecondary, "ButtonArtSecondary", getNextHighestDepth());

				break;
			case ButtonChange.PLATFORM_PC_GAMEPAD:
			case ButtonChange.PLATFORM_360:
			case ButtonChange.PLATFORM_SCARLETT:
				if (PS3Swapped && ButtonChange.PLATFORM_PC_GAMEPAD)
				{
					ButtonArt_mc = attachMovie(PS3Button, "ButtonArt", getNextHighestDepth());
					if (XBoxButtonSecondary != null)
						ButtonArtSecondary_mc = attachMovie(PS3ButtonSecondary, "ButtonArtSecondary", getNextHighestDepth());
				}
				else
				{
					ButtonArt_mc = attachMovie(XBoxButton, "ButtonArt", getNextHighestDepth());
					if (XBoxButtonSecondary != null)
						ButtonArtSecondary_mc = attachMovie(XBoxButtonSecondary, "ButtonArtSecondary", getNextHighestDepth());
				}

				break;
			case ButtonChange.PLATFORM_PS3:
			case ButtonChange.PLATFORM_PROSPERO:
			default:
				var ps3PrimaryButton: String = PS3Button;
				var ps3SecondaryButton: String = PS3ButtonSecondary;

				GameDelegate.call("myLog", [String(ps3PrimaryButton)]);

				if (PS3Swapped)
				{
					ps3PrimaryButton = swapPS3Buttons(ps3PrimaryButton);
					ps3SecondaryButton = swapPS3Buttons(ps3SecondaryButton);
				}

				if (CurrentPlatform == ButtonChange.PLATFORM_PROSPERO)
				{
					ps3PrimaryButton = mapToPS5Buttons(ps3PrimaryButton);
					ps3SecondaryButton = mapToPS5Buttons(ps3SecondaryButton);
				}

				GameDelegate.call("myLog", [String(ps3PrimaryButton)]);

				ButtonArt_mc = attachMovie(ps3PrimaryButton, "ButtonArt", getNextHighestDepth()) || attachMovie(PS3Button, "ButtonArt", getNextHighestDepth());
				if (ps3SecondaryButton != null)
					ButtonArtSecondary_mc = attachMovie(ps3SecondaryButton, "ButtonArtSecondary", getNextHighestDepth()) || attachMovie(PS3ButtonSecondary, "ButtonArtSecondary", getNextHighestDepth());
		}

		adjustArtPositioning();
		Reposition();

		border._visible = false;
	}

	function GetArt(): Object
	{
		return {
			PCArt: PCButton,
			XBoxArt: XBoxButton,
			PS3Art: PS3Button,
			PCArtSecondary: PCButtonSecondary,
			XBoxArtSecondary: XBoxButtonSecondary,
			PS3ArtSecondary: PS3ButtonSecondary
		};
	}

	function SetArt(aPlatformArt: Object): Void
	{
		PCArt = aPlatformArt.PCArt;
		XBoxArt = aPlatformArt.XBoxArt;
		PS3Art = aPlatformArt.PS3Art;

		if (aPlatformArt.PCArtSecondary != undefined)
		{
			PCArtSecondary = aPlatformArt.PCArtSecondary;
			XBoxArtSecondary = aPlatformArt.XBoxArtSecondary;
			PS3ArtSecondary = aPlatformArt.PS3ArtSecondary;
		}

		RefreshArt();
	}

	function get XBoxArt(): String
	{
		return null;
	}

	function set XBoxArt(aValue: String): Void
	{
		if (aValue != "")
			XBoxButton = aValue;
	}

	function get XBoxArtSecondary(): String
	{
		return null;
	}

	function set XBoxArtSecondary(aValue: String): Void
	{
		if (aValue != "")
			XBoxButtonSecondary = aValue;
	}

	function get PS3Art(): String
	{
		return null;
	}

	function set PS3Art(aValue: String): Void
	{
		if (aValue != "")
			PS3Button = aValue;
	}

	function get PS3ArtSecondary(): String
	{
		return null;
	}

	function set PS3ArtSecondary(aValue: String): Void
	{
		if (aValue != "")
			PS3ButtonSecondary = aValue;
	}

	function get PCArt(): String
	{
		return null;
	}

	function set PCArt(aValue: String): Void
	{
		if (aValue != "")
			PCButton = aValue;
	}

	function get PCArtSecondary(): String
	{
		return null;
	}

	function set PCArtSecondary(aValue: String): Void
	{
		if (aValue != "")
			PCButtonSecondary = aValue;
	}
}