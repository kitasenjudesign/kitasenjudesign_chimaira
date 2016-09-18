package ;

import camera.ExCamera;
import common.Dat;
import common.Key;
import common.SkyboxTexture;
import common.StageRef;
import effect.PostProcessing2;
import haxe.Http;
import js.Browser;
import light.MySpotLight;
import light.ShadowPlane;
import materials.Textures;
import objects.CgBg;
import objects.MyFaceSingle;
import objects.objs.Mojis;
import objects.MyDAELoader;
import objects.objs.Objs;
import sound.MyAudio;
import three.AmbientLight;
import three.Color;
import three.DirectionalLight;
import three.Fog;
import three.ImageUtils;
import three.Mesh;
import three.MeshBasicMaterial;
import three.PerspectiveCamera;
import three.PlaneGeometry;
import three.Scene;
import three.ShadowMaterial;
import three.SpotLight;
import three.SpotLightHelper;
import three.Vector3;
import three.WebGLRenderer;
import video.MovieData;
import video.VideoPlayer;
//import effect.PostProcessing2;
/**
 * ...
 * @author nabe
 */

class Main3d
{
	
	public static  var W:Int = 960;// 1280;
	public static  var H:Int = 540;// 768;// 1920;

	private var _scene		:Scene;
	private static var _camera		:ExCamera;
	private var _renderer	:WebGLRenderer;
	private var _audio:MyAudio;
	private var _skyboxMat:SkyboxTexture;
	private var _video:VideoPlayer;
	private var http:Http;
	private var _shadowGround:Mesh;
	
	private var _objects:Objs;
	private var _light:DirectionalLight;
	private var _dae:MyDAELoader;
	private var _pp:PostProcessing2;
	private var _bg:CgBg;
	private var _isPP:Bool = true;
	
	
	///loader wo kaku
	//loader
	
	public function new() 
	{

	}
	
	
	public function init() 
	{
		
		_renderer = new WebGLRenderer({
			/*preserveDrawingBuffer: true,*/ 
			//alpha:true,
			antialias:true, 
			devicePixelRatio:1	
		});
		_renderer.domElement.id = StageRef.name;		
		
		Textures.init();
		
		Dat.init(_onInitA);
		
	}
	
	private function _onInitA():Void{

		_objects = new Objs();
		_objects.init(_onInitB);
		
	}
	
	private function _onInitB():Void{
	
		_camera = new ExCamera(33.235, W / H, 10, 10000);
		_camera.amp = 1000;		
		_scene = new Scene();
		
		_video = new VideoPlayer();
		_video.init(_camera,_onInit1);
	}
	
	private function _onInit1():Void {
		
		_audio = new MyAudio();
		_audio.init( _onInit2 );
		
	}
	
	
	private function _onInit2():Void{
	
		_bg = new CgBg();
		_bg.init();
		_scene.add(_bg);		
		
		_scene.add(_objects);
		_scene.add(_video);
		
		untyped _renderer.localClippingEnabled = true;
		untyped _renderer.shadowMap.enabled = true;
		untyped _renderer.shadowMap.type = untyped __js__("THREE.BasicShadowMap");
		
		_renderer.setClearColor(new Color(0),0);
		_renderer.setSize(W, H);
		_renderer.domElement.style.position = "absolute";
		//_renderer.domElement.style.zIndex = "100";
		
		_camera.init(_renderer.domElement);	
        Browser.document.body.appendChild(_renderer.domElement);
	
		//var light:DirectionalLight = new DirectionalLight(0xffffff);
		var light:MySpotLight = new MySpotLight();
		_scene.add(light);
		
		_light = new DirectionalLight(0x887766, 1);
		_scene.add(_light);
		
		//var hoge:SpotLightHelper = new SpotLightHelper(light);
		//_scene.add(hoge);
		
		/*
		Dat.gui.add(_light.position, "x", -100, 100).listen();
		Dat.gui.add(_light.position, "y", -100, 100).listen();
		Dat.gui.add(_light.position, "z", -100, 100).listen();
		*/
		
		
		var a:AmbientLight = new AmbientLight(0x999999);
		_scene.add(a);
		
		_skyboxMat = new SkyboxTexture();
		_skyboxMat.init(ImageUtils.loadTexture("mate.png"));
		_skyboxMat.update(_renderer);

		_video.setStartCallback(_onStartVideo);
		_video.start();
		//_updateTexture();
		
		_shadowGround = new ShadowPlane();
		_scene.add(_shadowGround);
		
		_pp = new PostProcessing2();
		_pp.init(_scene, _camera, _renderer, null);
		
		//Dat.gui.add(this, "_frame", 0, 300).onChange(_update);
		//Dat.gui.add(this, "_fov", 10, 100).step(0.1).onFinishChange(_onResize);
		Dat.gui.add(this, "_showVideo");
		Dat.gui.add(this, "_hideVideo");
		
		Browser.window.onresize = _onResize;
		_onResize(null);
		
		//_run(true);
		_run(true);
		
		Key.board.addEventListener("keydown" , _onKeyDown);
		
	}
	
	private function _onKeyDown(e):Void {
	
		//Browser.window.alert("bg=" + bg +" / "+ e.keyCode);
		
		switch(Std.parseInt(e.keyCode)) {
			
			case Dat.A:
				_showVideo();
				
			case Dat.S:
				_hideVideo();
				
			case Dat.UP:
				MyFaceSingle.isActive = true;
				
			case Dat.DOWN:
				MyFaceSingle.isActive = false;
				
		}
		
	}
	
	private function _showVideo():Void {
		_isPP = true;
		_video.show();
		_bg.hide();
	}
	
	private function _hideVideo():Void {
		_isPP = false;		
		_video.hide();		
		_bg.show();		
	}
	
	
	private function _onStartVideo():Void {
		
		var data:MovieData = _video.getMovieData();
		_objects.start( data );
		_updateTexture( data );
		
	}
	
	/**
	 * 	updateTexture
	 */
	public function _updateTexture(data:MovieData):Void {
		
		Browser.document.getElementById("loading").style.display = "none";
		
		if( data.id == "FUKAN" ){
			_skyboxMat.init( Textures.parkBg );// );
		}else {
			_skyboxMat.init( _video.getTexture() );
		}
		
		_skyboxMat.update( _renderer );
		
	}
	
	private function _update():Void
	{
		_run(false);
	}
	

	private function _run(loop:Bool=false):Void
	{
		if(_audio != null && _audio.isStart) {
			_audio.update();
		}		
		
		//_skyboxMat.update( _renderer );
		_video.update(_camera);
		
		if (!_video.getEnded()) {
			
			_objects.setEnvMap( _skyboxMat.getTexture() );
			_objects.update( _audio );
			//_objects.visible = true;
		}
		
		if(_isPP){
			_pp.update(_audio);
		}else {
			_renderer.render(_scene, _camera);
		}
		
		
		var vv:Vector3 = new Vector3(1, 0.3, 0);
		vv.applyQuaternion(_camera.quaternion.clone());
		_light.position.copy(vv);		
		
		
		//Timer.delay(_run, Math.floor(1000 / 30));
		if(loop)Three.requestAnimationFrame( untyped _run);
	}	
	
	
	/**
	 * _onResize
	 * @param	d
	 */
	private function _onResize(d:Dynamic):Void
	{
		//trace("set " + _fov);
		W = Browser.window.innerWidth;
		H = Math.floor(W * 9 / 16);//540;// Browser.window.innerHeight;
		var oy:Float = (- (H - Browser.window.innerHeight) / 2);
		_renderer.domElement.width = W;// + "px";
		_renderer.domElement.height = H;// + "px";	
		_renderer.domElement.style.top = oy+"px";
		_renderer.setSize(W, H);
		//_camera.setFOV(_fov);
		_camera.aspect = W / H;// , 10, 50000);
		_camera.updateProjectionMatrix();

	
		
		//_video.resize(960, 540, oy);
		_video.resize(W, H, oy);
	}
	
	
	
	private function fullscreen() 
	{
		_renderer.domElement.requestFullscreen();
	}
	
	
	public static function getCamera():ExCamera {
		return _camera;
	}
	
}