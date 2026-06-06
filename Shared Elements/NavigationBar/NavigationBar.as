import gfx.controls.Button;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import gfx.io.GameDelegate;

import FTA.Defines.NavBar;

import FTA.Utility;

/**
 * This is the code for the Navigation Bar element
 * 
 * 
 * Examples:
 * 
 * NavBar.tabTypes = {"CustomMenu", "CustomMenu"}
 * NavBar.tabIdentifiers = {}
 * NavBar.tabNames = {"Character", "Skills"}
 * 
 * NavBar.initButtons();
 * 
 */
class NavigationBar extends gfx.core.UIComponent
{
	private var background_mc: MovieClip;
	private var divider_mc: MovieClip;
	private var ornamentLeft_mc: MovieClip;
	private var ornamentRight_mc: MovieClip;
	private var buttons_mc: MovieClip;
	private var current_btn: MovieClip;
	private var new_btn: MovieClip;

	static var ALPHA_VISIBLE: Number = 100;
	static var ALPHA_HIDDEN: Number = 0;
	static var FRAME_SELECTED: String = "selected";
	static var FRAME_NORMAL: String = "normal";
	static var FRAME_UP: String = "up";
	static var FRAME_OVER: String = "over";
	static var FRAME_IDLE: String = "idle";
	static var FRAME_MOVE_IN: String = "moveIn";
	static var TEXT_FIELD_PADDING: Number = 5;

	static var DEFAULT_BUTTON_NAME: String = "nav_btn";

	static var KEYCODE_Q: Number = 81;
	static var KEYCODE_E: Number = 13;

	private var allButtons: Array = [];

	private var _tabs: Array = [];
	private var _active: Number = -1;
	private var _switchMenus: Boolean = true;
	private var _horizontal: Number = 640;
	private var _vertical: Number = 124;
	private var _margin: Number = 30;
	private var _showBackground: Boolean = true;
	private var _ornamentLeft: String = "";
	private var _ornamentRight: String = "";
	private var _showDivider: Boolean = true;


	public function NavigationBar()
	{
		super();
	}


	// Setter and Getter
	public function get buttons(): Array { return allButtons; }
	public function get tabs(): Array { return _tabs; }

	// ==============================================================
	// Required to build the buttons
	// ==============================================================
	public function get tabTypes(): Array { return _tabs[0]; }
	public function set tabTypes(types: Array): Void { _tabs[0] = types; }

	public function get tabIdentifiers(): Array { return _tabs[1]; }
	public function set tabIdentifiers(types: Array): Void { _tabs[1] = types; }

	public function get tabNames(): Array { return _tabs[2]; }
	public function set tabNames(types: Array): Void { _tabs[2] = types; }
	// ==============================================================

	public function get active(): Number { return _active; }
	public function set active(value: Number): Void { _active = value; }

	public function get switchMenus(): Boolean { return _switchMenus; }
	public function set switchMenus(value: Boolean): Void { _switchMenus = value; }

	public function get width(): Number { return _horizontal; }
	public function set width(value: Number): Void
	{
		_horizontal = value;
		invalidate();
	}

	public function get height(): Number { return _vertical; }
	public function set height(value: Number): Void
	{
		_vertical = value;
		invalidate();
	}

	public function get margin(): Number { return _margin; }
	public function set margin(value: Number): Void
	{
		_margin = value;
		invalidate();
	}

	public function get showBackground(): Boolean { return _showBackground; }
	public function set showBackground(value: Boolean): Void
	{
		_showBackground = value;
		invalidate();
	}

	public function get ornamentLeft(): String { return _ornamentLeft; }
	public function set ornamentLeft(value: String): Void
	{
		_ornamentLeft = value;
		invalidate();
	}

	public function get ornamentRight(): String { return _ornamentRight; }
	public function set ornamentRight(value: String): Void
	{
		_ornamentRight = value;
		invalidate();
	}

	public function get showDivider(): Boolean { return _showDivider; }
	public function set showDivider(value: Boolean): Void
	{
		_showDivider = value;
		invalidate();
	}

	/*
		==========================
		===> PUBLIC FUNCTIONS <===
		==========================
	
		The public API for this component
	*/
	// This will create the buttons. This needs to be called at the start of the menu
	// after all buttons definitions have been defined.
	public function initButtons(): Void
	{
		for (var i: Number = 0; i < allButtons.length; i++)
			allButtons[i].removeMovieClip();

		allButtons = [];

		for (var i: Number = 0; i < _tabs[2].length; i++)
		{
			allButtons[i] = buttons_mc.attachMovie("btnText", DEFAULT_BUTTON_NAME + "_" + i, buttons_mc.getNextHighestDepth());

			allButtons[i].disableFocus = true;
			allButtons[i].label = allButtons[i].textField.text = Utility.translate(_tabs[2][i]);

			allButtons[i].identifier = _tabs[1][i];
			if (_switchMenus)
				allButtons[i].menuType = _tabs[0][i];

			allButtons[i].addEventListener("click", this, "onButtonClick");
			allButtons[i].addEventListener("rollOver", this, "onButtonRollOver");
			allButtons[i].addEventListener("rollOut", this, "onButtonRollOut");
		}

		invalidate();

		Key.addListener(this);
	}

	public function SetActive(a_iIndex: Number): Void
	{
		_active = a_iIndex;

		for (var i: Number = 0; i < allButtons.length; i++)
		{
			setButtonState(allButtons[i], FRAME_IDLE, FRAME_UP);
			setPointerAlpha(allButtons[i], ALPHA_HIDDEN);
		}

		// Else the button can flicker
		updateButtonWidth(current_btn);

		current_btn = allButtons[a_iIndex];
		setButtonState(current_btn, FRAME_SELECTED, FRAME_SELECTED);
		updateButtonWidth(current_btn);
		setPointerAlpha(current_btn, ALPHA_VISIBLE);
	}

	/*
		==========================
		==> PRIVATE FUNCTIONS <===
		==========================
	
		The private API for this component
	*/
	// Prevent the default behavior of the Tab key
	private function draw(): Void
	{
		super.draw();

		// Background
		background_mc._alpha = _showBackground ? background_mc._alpha : ALPHA_HIDDEN;
		if (_showBackground)
		{
			background_mc._width = _horizontal;
			background_mc._height = _vertical;
		}

		// Ornament Left
		ornamentLeft_mc.gotoAndStop(ornamentLeft);
		var useOrnamentLeft: Boolean = ornamentLeft != NavBar.EMPTY && ornamentLeft != "";
		if (useOrnamentLeft)
		{
			var originalRatio: Number = ornamentLeft_mc._width / ornamentLeft_mc._height;

			ornamentLeft_mc._height = _vertical - 10;
			ornamentLeft_mc._width = ornamentLeft_mc._height * originalRatio;

			ornamentLeft_mc._y = (_vertical - ornamentLeft_mc._height) / 2;
		}

		// Ornament Right
		ornamentRight_mc.gotoAndStop(ornamentRight);
		var useOrnamentRight: Boolean = ornamentRight != NavBar.EMPTY && ornamentRight != "";
		if (useOrnamentRight)
		{
			var originalRatio: Number = ornamentRight_mc._width / ornamentRight_mc._height;

			ornamentRight_mc._height = _vertical - 10;
			ornamentRight_mc._width = ornamentRight_mc._height * originalRatio;

			ornamentRight_mc._x = _horizontal;
			ornamentRight_mc._y = (_vertical - ornamentRight_mc._height) / 2;
		}

		// Divider
		divider_mc._alpha = _showDivider ? divider_mc._alpha : ALPHA_HIDDEN;
		if (_showDivider)
		{
			divider_mc._width = _horizontal;
			divider_mc._x = background_mc._x;
			divider_mc._y = background_mc._y + _vertical
		}

		// Buttons
		updateButtonDimensions();
	}

	private function updateButtonDimensions(): Void
	{
		buttons_mc._y = _vertical / 2;

		var totalWidth: Number = 0;
		for (var i: Number = 0; i < allButtons.length; i++)
		{
			updateButtonWidth(allButtons[i]);

			allButtons[i].rightPointer._x = allButtons[i].textField._width + allButtons[i].leftPointer._width;
			allButtons[i].leftPointer._alpha = allButtons[i].rightPointer._alpha = ALPHA_HIDDEN;

			allButtons[i]._x = (i > 0) ? allButtons[i - 1]._x + allButtons[i - 1]._width + margin : 0;

			totalWidth += allButtons[i]._width + (i < _tabs[2].length - 1 ? margin : 0);
		}

		buttons_mc._x = (_width - totalWidth) / 2;

		if (_active != -1)
			SetActive(_active);
	}

	private function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		// Prevent the default behavior of the Tab key
		if (details.navEquivalent == NavigationCode.TAB)
			return true;

		return false;
	}

	private function onKeyDown(a_controllerIdx: Number): Void
	{
		var keyCode = Key.getCode(a_controllerIdx);
		if (keyCode == KEYCODE_Q || keyCode == KEYCODE_E)
		{
			var nextMenuID: Number = Utility.clamp((keyCode == KEYCODE_Q ? _active - 1 : _active + 1), 0, _tabs[2].length - 1);
			new_btn = buttons_mc[DEFAULT_BUTTON_NAME + "_" + nextMenuID]

			if (_switchMenus && _active != nextMenuID)
				onFadedOut();
			else if (!_switchMenus)
			{
				SetActive(new_btn.identifier);
				dispatchEvent({type:"selectTab", newTab: new_btn, id: new_btn.identifier});
			}
		}
	}

	private function onButtonClick(event: Object): Void
	{
		new_btn = event.target;

		if (current_btn == new_btn)
		{
			setButtonState(current_btn, FRAME_SELECTED, FRAME_SELECTED);
			updateButtonWidth(current_btn);
			setPointerAlpha(current_btn, ALPHA_VISIBLE);

			return;
		}

		if (_switchMenus)
			_parent.gotoAndPlay("fadeOut");
		else
		{
			SetActive(new_btn.identifier);
			dispatchEvent({type:"selectTab", newTab: new_btn, id: new_btn.identifier});
		}
	}

	private function onFadedOut(): Void
	{
		if (current_btn)
		{
			skse.CloseMenu(current_btn.menuType == "CustomMenu" ? current_btn.menuType : current_btn.identifier);
			_parent.onCloseComplete(1);
		}

		if (current_btn.menuType == "CustomMenu")
			skse.SendModEvent("SKYBUIOpenCustomMenu", new_btn.identifier, 1);
		else
			skse.OpenMenu(new_btn.menuType);
	}

	private function getMovieClipIndex(mcArray: Array, mcTarget: MovieClip): Number
	{
		for (var i: Number = 0; i < mcArray.length; i++)
			if (mcArray[i] === mcTarget)
				return i;

		return -1;
	}

	private function onButtonRollOver(event: Object): Void
	{
		var target: MovieClip = event.target;

		setPointerAlpha(target, ALPHA_VISIBLE);
		updateButtonWidth(target);

		if (current_btn == target)
			setButtonState(target, FRAME_SELECTED, FRAME_SELECTED);
		else
			setButtonState(target, FRAME_MOVE_IN, FRAME_OVER);
	}

	private function onButtonRollOut(event: Object): Void
	{
		var target: MovieClip = event.target;

		updateButtonWidth(target);
	
		if (current_btn == target)
			setButtonState(target, FRAME_SELECTED, FRAME_SELECTED);
		else
		{
			setButtonState(target, FRAME_NORMAL, FRAME_UP);
			setPointerAlpha(target, ALPHA_HIDDEN);
		}
	}

	private function setButtonState(button: MovieClip, sFrame: String, sFrame2: String): Void
	{
		button.gotoAndPlay(sFrame2);
		button.leftPointer.gotoAndPlay(sFrame);
		button.rightPointer.gotoAndPlay(sFrame);
		button.textField.text = button.label;
	}

	private function updateButtonWidth(button: MovieClip): Void
	{
		button.textField._width = button.textField.textWidth + TEXT_FIELD_PADDING;
		button.border._width = button.textField._width + button.leftPointer._width * 2;
	}

	private function setPointerAlpha(button: MovieClip, alpha: Number): Void
	{
		button.leftPointer._alpha = button.rightPointer._alpha = alpha;
	}
}