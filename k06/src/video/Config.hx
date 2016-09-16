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
		/*
		_http = new Http(filename);
		_http.onData = _onData;
		_http.request();		
		
	}
	
	private function _onData(data:String):Void {
		*/
	
		
		//var d:Dynamic = Json.parse(data);
		
		var d:Dynamic = {
			"data":[
				{
					"id":"HACHI",
					"cam":"mov2/cam_hachi.json",
					"mov":"mov2/03_hachi.mp4",
					"size":0.3,
					"y":2,
					"offsetFrame":0
				},
				{
					"id":"WWW",			
					"cam":"mov2/cam_www.json",
					"mov":"mov2/00_www.mp4",
					"size":0.5,
					"y":50,
					"offsetFrame":0
				},
				{
					"id":"SCRAMBLE",					
					"cam":"mov2/cam_scramble.json",
					"mov":"mov2/01_scramble.mp4",
					"size":0.8,
					"y":50,
					"offsetFrame":0
				},
				{
					"id":"OSHO",
					"cam":"mov2/cam_osho.json",
					"mov":"mov2/07_osho.mp4",
					"size":0.3,
					"y":40,
					"offsetFrame":0
				},		
				{
					"id":"FUKAN",			
					"cam":"mov2/cam_fukan.json",
					"mov":"mov2/04_fukan.mp4",
					"size":0.25,
					"y":10,
					"offsetFrame":0
				},		


				{
					"id":"STATION",
					"cam":"mov2/cam_station.json",
					"mov":"mov2/02_station.mp4",
					"size":0.6,
					"y":50,
					"offsetFrame":0
				},
				{
					"id":"HACHI",
					"cam":"mov2/cam_hachi.json",
					"mov":"mov2/03_hachi.mp4",
					"size":0.3,
					"y":2,
					"offsetFrame":0
				},
				{
					"id":"KOKA",
					"cam":"mov2/cam_koka.json",
					"mov":"mov2/05_koka.mp4",
					"size":0.3,
					"y":2,
					"offsetFrame":0
				},
				{
					"id":"WWW3",
					"cam":"mov2/cam_www3.json",
					"mov":"mov2/08_www3.mp4",
					"size":0.4,
					"y":50,
					"offsetFrame":0
				}				
				
			]
		};
		
		
		
		
		
		
		
		
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