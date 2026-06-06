class Tooltip extends MovieClip
{
	var image_mc: MovieClip;
	var background_mc: MovieClip;
	var name_txt: TextField;
	var mod_txt: TextField;
	var type_txt: TextField;
	var description_txt: TextField;

	var _label: String = "";
	var _modifier: String = "";
	var _type: String = "";
	var _description: String = "";
	var _image: String = "";

	static var DESCRIPTION_DEFAULT_HEIGHT: Number = 300;
	static var BACKGROUND_PADDING: Number = 40;


	public function Tooltip()
	{
		super();
	}


	public function get label(): String { return _label; }
	public function set label(label: String): Void
	{
		_label = label;

		name_txt.html = true;
		name_txt.htmlText = label;

		name_txt._width = name_txt.textWidth + 5;

		invalidate();
	}

	public function get modifier(): String { return _modifier; }
	public function set modifier(modifier: String): Void
	{
		_modifier = modifier;

		mod_txt.html = true
		mod_txt.htmlText = modifier;

		invalidate();
	}

	public function get type(): String { return _type; }
	public function set type(type: String): Void
	{
		_type = type;

		type_txt.html = true
		type_txt.htmlText = type;

		invalidate();
	}

	public function get description(): String { return _description; }
	public function set description(description: String): Void
	{
		_description = description;
		
		description_txt.html = true
		description_txt.htmlText = description;

		invalidate();
	}

	public function get image(): String { return _image; }
	public function set image(image: String): Void
	{
		_image = image;

		if (image != "")
			image_mc.loadMovie(image);

		invalidate();
	}


	public function setTooltipData(label: String, modifier: String, type: String, description: String, image: String): Void
	{
		if (!this)
			return;

		this.label = label;
		this.modifier = modifier;
		this.type = type;
		this.description = description;
		this.image = image;
	}

	public function setTooltipPosition(target: Button, reference: MovieClip, mode: Number): Void
	{
		if (!this)
			return;

		_visible = true;

		// Calculate the tooltip's height
		var iCurrentHeight: Number = Math.max(background_mc._height, image_mc._height / 2 + image_mc._y);

		var bIsOutOfBoundsX: Boolean;
		var bIsOutOfBoundsY: Boolean;
		if (mode == 0)
		{
			// Check if the tooltip will go out of bounds based on mouse position
			bIsOutOfBoundsX = (_root._xmouse + BACKGROUND_PADDING + _width > Stage.width - 10);
			bIsOutOfBoundsY = (_root._ymouse + BACKGROUND_PADDING + iCurrentHeight > Stage.height - 10);

			// Set the tooltip's position based on mouse position
			_x = bIsOutOfBoundsX ? _root._xmouse - _width : _root._xmouse + BACKGROUND_PADDING;
			_y = bIsOutOfBoundsY ? _root._ymouse - iCurrentHeight : _root._ymouse + BACKGROUND_PADDING;
		}
		else
		{
			// Manually calculate global position by traversing the hierarchy
			var globalPoint: Object = {x: target._x, y: target._y};
			reference.localToGlobal(globalPoint);

			// Check if the tooltip will go out of bounds
			bIsOutOfBoundsX = (globalPoint.x + _width > Stage.width);
			bIsOutOfBoundsY = (globalPoint.y + iCurrentHeight > Stage.height);

			// Set the tooltip's position
			_x = bIsOutOfBoundsX 
				? globalPoint.x - _width // Adjust if it goes out of bounds
				: globalPoint.x + target._width - 10; // Default positioning
			_y = bIsOutOfBoundsY 
				? globalPoint.y - iCurrentHeight // Adjust if it goes out of bounds
				: globalPoint.y; // Default positioning
		}
	}

	public function turnOffTooltip(): Void
	{
		if (!this)
			return;

		_visible = false;
		_x = _y = 9999;
	}


	private function draw(): Void
	{
		super.draw();

		description_txt._height = DESCRIPTION_DEFAULT_HEIGHT;
		mod_txt._x = name_txt._x + name_txt._width + 5;

		var iTextBoxSize: Number = ((image_mc._x - description_txt._x) - image_mc._width / 2) - 10;
		description_txt._width = iTextBoxSize;
		
		var totalHeight: Number = name_txt.textHeight + type_txt.textHeight + description_txt.textHeight;
		background_mc._height = totalHeight + BACKGROUND_PADDING;

		description_txt._height = description_txt.textHeight + 10;
	}
}