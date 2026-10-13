import gfx.events.EventDispatcher;
import Shared.Proxy;

class Components.BSUIComponent extends MovieClip
{
	var _Beacon;
	var _IsDirty = false;


	function BSUIComponent()
	{
		super();

		EventDispatcher.initialize(this);
		focusEnabled = true;
		_Beacon = createEmptyMovieClip("Beacon", getInstanceAtDepth(-1) != undefined ? 0 : -1);
	}

	function SetIsDirty(): Void
	{
		_IsDirty = true;
		_Beacon.onEnterFrame = Proxy.create(this, RedrawUIComponent);
	}

	function RedrawUIComponent(): Void
	{
		_Beacon.onEnterFrame = null;
		_IsDirty = false;
	}
}