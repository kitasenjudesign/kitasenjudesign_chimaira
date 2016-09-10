package objects;
import three.Object3D;
import video.MovieData;

/**
 * ...
 * @author watanabe
 */
class Objs extends Object3D
{


	private var _currentData:MovieData;
	private var _currentObj:MatchMoveObects;
	private var _mojis	:Mojis;
	private var _eyes	:Eyes;
	private var _faces	:Faces;
	private var _index	:Int = 0;
	private var _objects:Array<MatchMoveObects>;
	
	//private var _faces;//Faces;
	
	public function new() 
	{
		super();
	}
	
	
	public function init():Void {
		
		//_movieData
		//_movieData.camData	
		_mojis = new Mojis();
		_mojis.init();
		add(_mojis);
		
		_eyes = new Eyes();
		_eyes.init();
		add(_eyes);
		
		_faces = new Faces();
		_faces.init();
		add(_faces);
		
		_objects = [
			_mojis,
			_eyes,
			_faces		
		];
		
	}
	
	
	
	/*
	 * 
	 *
	 */
	public function start(data:MovieData):Void {
		
		_currentData = data;
		hideAll();
		_currentObj = _objects[_index];
		_currentObj.show( data );
		
	}
	
	
	public function hideAll():Void {
		
		for (i in 0..._objects.length) {
			_objects[i].hide();
		}
		_currentObj = _objects[index];
		_currentObj.init();
		_currentObj.show();
	}
	
	
	public function update():Void {
		
		
		
		
	}
	
	
	
	
}