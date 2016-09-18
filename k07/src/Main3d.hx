package ;

import camera.CamAngle;
import camera.ExCamera;
import common.Dat;
import common.TimeCounter;
import data.DataManager;
import js.Browser;
import objects.CatsBase;
import objects.CatsGenerators;
import objects.CatsLoader;
import objects.DimentionCats;
import objects.FlyingCats;
import objects.LongCats;
import objects.MyCATLoader;
import objects.MyDAELoader;
import sound.DummyBars;
import sound.MyAudio;
import three.Color;
import three.Mesh;
import three.Object3D;
import three.Scene;
import three.WebGLRenderer;
/**
 * ...
 * @author nabe
 */

class Main3d
{
	
	public static  var W:Int = 1280;// 1280;
	public static  var H:Int = 720;// 768;// 1920;
	
	
	private var _scene		:Scene;
	private var _camera		:ExCamera;
	private var _renderer	:WebGLRenderer;
	
	//private var _cubeCamera:CubeCamera;
	private var dae:MyDAELoader;
	private var _audio:MyAudio;
	private var _dataManager:DataManager;
	
	private var _angle:CamAngle;

	static private var clearColor:Color;
	private var _generators:CatsGenerators;
	private var _longCats:LongCats;
	private var _cats:Array<CatsBase>=[];
	
	//private var _camAngle:CamAngle
	
	private var _mode:Int = 2;
	private var _flyingCats:FlyingCats;

	private var _currentCats:CatsBase;
	var _dimention:DimentionCats;
	
	public function new() 
	{
		//_init();
	}
	
	public function init() 
	{
		
		//WebfontLoader.load([WebfontLoader.ROBOTO_CONDENSED_700400], _onLoad);
		_onLoad();	
	}
	
	private function _onLoad():Void {
	
		Dat.init(_onLoad2);
	}
	
	private function _onLoad2():Void{
		
		TimeCounter.start();
		
		clearColor = new Color(0xff55ff);
		
		_audio = new MyAudio();
		_audio.init(_onInit);
	}
	
	private function _onInit():Void{
		_scene = new Scene();
		_camera = new ExCamera(60, W / H, 10, 10000);
		
		_angle = new CamAngle(_camera);
		
		_camera.near = 5;
		_camera.far = 10000;
		_camera.amp = 1000;
		//var light:AmbientLight = new AmbientLight(0xffffff);
		//_scene.add(light);
		
		//_lines = new DummyBars();
		//_lines.init();
		//_scene.add(_lines);
		
		//_renderer
		_renderer = new WebGLRenderer({ /*preserveDrawingBuffer: true,*/ antialias:true, devicePixelRatio:1});
		//_renderer.shadowMapEnabled = true;
		_renderer.setClearColor(new Color(0x000000));
		_renderer.setSize(W, H);
		//_renderer.domElement.width = W;// + "px";
		//_renderer.domElement.height = H;// + "px";
		
		_camera.init(_renderer.domElement);	
        Browser.document.body.appendChild(_renderer.domElement);
		
		Browser.window.onresize = _onResize;
		_onResize(null);
		
		//_camera.radY = Math.PI / 4;

		//_neko = new MyDAELoader();
		_dataManager = DataManager.getInstance();
		_dataManager.load(_onLoad1);
		
		Dat.gui.add(_camera, "amp", 0, 9000).listen();
		Dat.gui.add(_camera, "radX", 0, 2*Math.PI).step(0.01).listen();
		Dat.gui.add(_camera, "radY", 0, 2 * Math.PI).step(0.01).listen();
		Dat.gui.add(_camera, "tgtOffsetY", -1000, 1000).step(1).listen();	
		Dat.gui.add(this, "_force");
		
		Dat.gui.add(this, "_goNext");
		
		Browser.document.addEventListener("keydown", _onKeyDown);
		
	}
	
	private function _onKeyDown(e):Void {
		if(Std.parseInt(e.keyCode)==Dat.RIGHT) {		
			_goNext();
		}
	}
	
	/**
	 * _goNext
	 */
	private function _goNext():Void {
	
		_mode++;
		_mode = _mode % _cats.length;
		
		for (i in 0..._cats.length) {
			if (_mode == i) {
				_cats[i].visible = true;
				_cats[i].restart();
				_scene.add(_cats[i]);
			}else {
				_cats[i].visible = false;				
				_scene.remove(_cats[i]);
				
			}
		}
		
	}
	
	private function _force():Void {
	
		_camera.setRAmp(2000+500*Math.random(), 4*(Math.random()-0.5));// 4 * Math.random());
		
	}
	
	private function _onLoad1():Void
	{
		//Browser.window.alert("init");
		
		_longCats = new LongCats();
		_scene.add(_longCats);
		
		
		//_flyingCats = new FlyingCats();
		//_scene.add(_flyingCats);
	
		_generators = new CatsGenerators();
		_scene.add(_generators);
		
		_dimention = new DimentionCats();
		_scene.add(_dimention);
		
		_cats = [
			_dimention,
			//_flyingCats,
			_longCats,
			_generators
		];
		
		for (i in 0..._cats.length) {
			_cats[i].init(_camera);
		}
		
		//Browser.window.alert("aa");
		
		_goNext();
		_run();
	}
	
	private function _run():Void
	{
		
		if(_audio != null && _audio.isStart) {
			_audio.update();
			_cats[_mode].update(_audio);
			
		}
		
		
		
		_camera.update();
		_angle.update(_audio);
	
		_renderer.render(_scene, _camera);
		//_pp.render();
		
		//Timer.delay(_run, Math.floor(1000 / 30));
		Three.requestAnimationFrame( untyped _run);
		
	}	
	
	private function fullscreen() 
	{
		_renderer.domElement.requestFullscreen();
	}
	
	function _onResize(e) 
	{
		
		//_camera.aspect = W / H;// , 10, 50000);
		//_renderer.setSize(W, H);	
		//_camera.updateProjectionMatrix();
		
		W = Browser.window.innerWidth;
		H = Browser.window.innerHeight;
		_renderer.domElement.width = W;// + "px";
		_renderer.domElement.height = H;// + "px";		
		_renderer.setSize(W, H);
		
		_camera.aspect = W / H;// , 10, 50000);
		_camera.updateProjectionMatrix();
	}
	
	
	


	public function setColor(col:Int):Void {
	
		clearColor = new Color(col);
		_renderer.setClearColor(clearColor);
	}
	
	
}