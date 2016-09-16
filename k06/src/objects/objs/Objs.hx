package objects.objs;
import js.Browser;
import objects.objs.Eyes;
import objects.objs.Faces;
import objects.objs.Mojis;
import sound.MyAudio;
import three.Object3D;
import three.Texture;
import tween.TweenMax;
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
	private var _hand	:Hands;
	private var _logos	:Dedes;
	private var _index	:Int = 0;
	private var _objects:Array<MatchMoveObects>;
	
	//private var _faces;//Faces;
	
	public function new() 
	{
		super();
	}
	
	/**
	 * 
	 */
	public function init(callback:Void->Void):Void {
		
		//_movieData
		//_movieData.camData	
		_mojis = new Mojis();
		_mojis.init();
		//add(_mojis);
		
		_eyes = new Eyes();
		_eyes.init();
		//add(_eyes);
		
		_faces = new Faces();
		_faces.init();
		//add(_faces);
		_logos = new Dedes();
		_logos.init();
		//_hand = new Hands();
		//_hand.init();
		
		_objects = [
			//_logos,
			//_faces,
			_mojis
			//_eyes
			//_faces
		];
		
		TweenMax.delayedCall(0.1, callback);
	}
	
	
	
	/*
	 *	start
	 */
	public function start(data:MovieData):Void {
		
		_currentData = data;
		hideAll();
		//Browser.window.alert("next " + _index);		
		
		//_currentObj = _objects[_index%_objects.length];
		_currentObj = _objects[Math.floor(Math.random() * _objects.length)];
		
		_currentObj.show( data );
		add(_currentObj);
		
		_index++;
	}
	
	/**
	 * hideAll
	 */
	public function hideAll():Void {
		
		for (i in 0..._objects.length) {
			_objects[i].hide();
			remove(_objects[i]);
		}
		
	}
	
	
	public function setEnvMap(t:Texture):Void{
		
		if( _currentObj != null ){
			_currentObj.setEnvMap( t );// _skyboxMat.getTexture() );
		}
	}
	
	
	//setEnvMap
	
	
	/**
	 * update 
	 * @param	a
	 */
	public function update(a:MyAudio):Void {
		
		if(_currentObj!=null){
			_currentObj.update(a);
		}
		
	}
	
	
	
	
}