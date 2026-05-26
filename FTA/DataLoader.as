import SKYB.INI;
import SKYB.JSON;


/*
	Can be used to load INI and JSON files.
	example:

	DataLoader.load
	(
		"ConfigFiles/SKYBUIConfig.ini",
		Delegate.create(this, onLoadComplete),
		true,
		null,
		Delegate.create(this, onLoadError),
		Delegate.create(this, onLoadProgress)
	);


	function onLoadComplete(data: Object, extraData: Object): Void
	{
		bPS3Swap = Boolean(Number(data.General.bUsePS3Buttons));
	}

	function onLoadError(errorMessage: String): Void
	{
	}

	function onLoadProgress(progress: Number): Void
	{
	}
*/


class SKYB.DataLoader
{
	static var _cache: Object = {};
	static var _logger: Function = null;

	// Set a logger function
	static function setLogger(logger: Function): Void
	{
		_logger = logger;
	}

	// Improved load method with better error handling
	static function load(filePath: String, onComplete: Function, useCache: Boolean, extraData: Object, onError: Function, progressCallback: Function): Void
	{
		// Fallbacks for optional parameters
		if (useCache == undefined)
			useCache = true;

		if (extraData == undefined)
			extraData = null;

		if (onError == undefined)
			onError = null;

		if (progressCallback == undefined)
			progressCallback = null;

		var cb = onComplete;
		var err = onError;
		var progress = progressCallback;

		if (useCache && _cache[filePath] != undefined)
		{
			cb(_cache[filePath], extraData);
			return;
		}

		var parser: Function = getParser(filePath);
		if (parser == null)
		{
			logError("Unknown Fileformat: " + filePath);

			if (err != null) err("Unknown Fileformat: " + filePath);
				return;
		}

		var loader: LoadVars = new LoadVars();
		loader.onData = function(data: String): Void
		{
			if (!data || data == "")
			{
				logError("File is empty or could not be loaded: " + filePath);

				if (err != null) err("File is empty or could not be loaded: " + filePath);
					return;
			}

			var parsed: Object = parser(data);
			if (parsed == undefined)
			{
				logError("Error while parsing: " + filePath);
				if (err != null)
					err("Error while parsing: " + filePath);

				return;
			}

			_cache[filePath] = parsed;

			// Optional: Report progress
			if (progress != null)
				progress(100);

			if (cb != null)
				cb(parsed, extraData);
		};

		// Report progress (for example, 50% after the start)
		if (progress != null)
			progress(50);

		loader.load(filePath);
	}

	// Determines parser function based on file extension
	// Modular design allows for easy addition of new parsers in the future
	static function getParser(filePath: String): Function
	{
		var ext: String = filePath.substr(filePath.lastIndexOf(".") + 1).toLowerCase();
		switch (ext)
		{
			case "ini":
				return INI.parse;
			case "json":
				return JSON.parse;
			default:
				return null;
		}
	}

	// Logging utility for errors
	static function logError(message: String): Void
	{
		if (_logger != null)
			_logger(message);
	}

	// Access cache data by file path
	static function getCacheData(filePath: String): Object
	{
		return _cache[filePath];
	}

	static function removeCache(filePath: String): Void
	{
		delete _cache[filePath];
	}

	// Clear cache
	static function clearCache(): Void
	{
		_cache = {};
	}

	// Check cache status (whether a file is in the cache)
	static function isCached(filePath: String): Boolean
	{
		return _cache[filePath] != undefined;
	}

	// Sets specific cache data
	static function setCache(filePath: String, data: Object): Void
	{
		_cache[filePath] = data;
	}
}