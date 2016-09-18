package objects.objs;
import common.Dat;
import common.Key;
import common.SimpleDAELoader;
import js.Browser;
import objects.objs.eye.PrimitiveObj;
import objects.objs.Eyes;
import objects.objs.Faces;
import objects.objs.moji.MojiMaker;
import objects.objs.Mojis;
import sound.MyAudio;
import three.Geometry;
import three.Matrix4;
import three.MeshPhongMaterial;
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

	public static var geoMouse:Geometry;
	
	private var _currentData:MovieData;
	private var _currentObj:MatchMoveObects;
	private var _mojis	:Mojis;
	private var _eyes	:Eyes;
	private var _faces	:Faces;
	private var _primitives:Primitives;
	private var _index	:Int = 0;
	private var _objects:Array<MatchMoveObects>;
	private var _loader:SimpleDAELoader;
	private var _callback:Void->Void;
	var _nextIndex:Int = 0;
	
	//private var _faces;//Faces;
	
	public function new() 
	{
		super();
	}
	
	/**
	 * init
	 */
	public function init(callback:Void->Void):Void {
		
		_callback = callback;
		_loader = new SimpleDAELoader();
		_loader.load("dae/mouse.dae", _onLoad);
		
	}
	
	private function _onLoad():Void {
		
		//Browser.window.alert(""+_loader.meshes.length);
		geoMouse = new Geometry();// _loader.meshes[0].geometry;
		
		var mat4:Matrix4 = new Matrix4();
		mat4.multiply( new Matrix4().makeTranslation(0, 0, 10) );
		geoMouse.merge(_loader.meshes[0].geometry, mat4);		
		
		
		//_movieData
		//_movieData.camData	
		_mojis = new Mojis();
		_mojis.init();
		//add(_mojis);
		
		_faces = new Faces();
		_faces.init();
		//add(_faces);
		_primitives = new Primitives();
		_primitives.init();
		//_hand = new Hands();
		//_hand.init();
		
		_objects = [
			//_logos,
			_faces,			
			_mojis,
			_primitives			
			//_eyes
			//_faces
		];
				
		Dat.gui.add(this, "_index").listen();
		Key.board.addEventListener(Key.keydown, _onDown);
		
		if (_callback != null) {
			_callback();
		}
	}
	
	private function _onDown(e):Void {
		switch( e.keyCode ) {
			case Dat.Q:
				_nextIndex = 0;
			case Dat.W:
				_nextIndex = 1;				
			case Dat.E:
				_nextIndex = 2;			
		}
		
	}
	
	
	/*
	 *	start
	 */
	public function start(data:MovieData):Void {
		
		_currentData = data;
		hideAll();
		//Browser.window.alert("next " + _index);		
		if (_currentObj != null) {
			_currentObj.kill();
		}
		
		//_currentObj = _objects[_index%_objects.length];
		
		//scenario
		
		_currentObj = _objects[_nextIndex];
		/*
		if (_index < 10) {
			//kanarazu kao
			_currentObj = _objects[0];
		}else{
			//random
			_currentObj = _objects[Math.floor(Math.random() * _objects.length)];
		}*/
		
		
		
		
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