package video;
import haxe.Http;
import haxe.Json;

/**
 * ...
 * @author watanabe
 */
class Config
{

	private var _http		:Http;
	private var _callback	:Void->Void;
	
	//public var camJsonPath	:String;
	//public var movPath		:String;
	//public var offset		:Int;
	
	public var list:Array<MovieData>;
	
	public function new() 
	{
		
	}
	
	public function load(filename:String, callback:Void->Void):Void {
		
		_callback = callback;

		_http = new Http(filename);
		_http.onData = _onData;
		_http.request();		
		
	}
	
	/**
	 * 
	 * @param	data
	 */
	private function _onData(data:String):Void {
		
		var d:Dynamic = Json.parse(data);
		
		list = [];
		for (i in 0...d.data.length) {
			list.push(
				new MovieData(d.data[i])
			);
		}
		
		/*
		camJsonPath = data.cam;
		movPath = data.mov;
		offset = data.offset;
		*/
		if (_callback != null) {
			_callback();
		}
	}	
}