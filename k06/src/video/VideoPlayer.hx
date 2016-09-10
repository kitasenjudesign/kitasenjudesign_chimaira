package video;
import camera.ExCamera;
import common.Dat;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.VideoElement;
import three.Geometry;
import three.Line;
import three.LineBasicMaterial;
import three.LineSegments;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PerspectiveCamera;
import three.PlaneBufferGeometry;
import three.PlaneGeometry;
import three.Quaternion;
import three.Scene;
import three.Texture;
import three.Vector3;
import tween.easing.Power0;
import tween.easing.Sine;
import tween.TweenMax;
import video.Config;
import video.MovieData;
import video.VideoPlane;

/**
 * ...
 * @author watanabe
 */
class VideoPlayer extends Object3D
{

	private var _video:VideoElement;
	private var _filename:String;
	private var _config:Config;
	
	private var _callback:Void->Void;
	private var _callback2:Void->Void;
	
	private var _index:Int = 0;
	private var _list:Array<MovieData>;
	
	private var _movieData	:MovieData;
	private var _camData	:CameraData;
	private var _fov		:Float = 34;
	private var _camera:ExCamera;
	private var _loading:Bool = false;
	private var _q:Quaternion;
	private var _tgt:Vector3;
	private var _scene:Scene;
	private var _videoPlane:VideoPlane;
	
	public function new() 
	{
		super();
	}
	
	/**
	 * init
	 * @param	filename
	 * @param	callback
	 */
	public function init(camera:ExCamera,callback:Void->Void):Void {

		_tgt = new Vector3();
		_camera = camera;
		_callback = callback;
		//_changeCallback = changeCallback;
		_config = new Config();
		_config.load("config.json", _onInit);
		
	}
	
	private function _onInit():Void
	{
		_list = _config.list;
		
		_video = Browser.document.createVideoElement();
		
		_video.style.position = "absolute";
		_video.style.zIndex = "0";
		_video.style.top = "0";
		_video.style.left = "0";
		//_video.style.visibility = "hidden";
		Browser.document.body.appendChild(_video);		
		
		_videoPlane = new VideoPlane();
		_videoPlane.init(_video);
		//add(_videoPlane);
		
		//_callback();
		setInitCallback(_callback);
		_start();
	}
	
	/**
	 * start
	 */
	public function setInitCallback(cb:Void->Void):Void {
		_callback2 = cb;	
	}
	
	private function _start():Void {
		
		//trace("_start " + _index);
		_loading = true;
		_video.src = "";
		_movieData = _list[_index%_list.length];
		_movieData.loadCamData(_onLoad);
		
		//Browser.window.onmousedown = _onDown;
	}
	
	
	private function _onDown(e):Void
	{
		_onFinish(null);
	}
	
	/**
	 * 
	 */
	private function _onLoad():Void {
		
		/////////////////////////////////////いろいろ変える

		//_movieData
		//_movieData.camData
		
		_video.src = _movieData.pathMov;
		//_video.style.display = "none";
		_video.addEventListener("canplay", _onLoad2);
		
	}
	
	private function _onLoad2(e):Void{
		
		//load suru
		//Browser.window.alert("_onLoad");
		_camData	= _movieData.camData;
		var frameData:Dynamic = _camData.getFrameData(0);
		
		var geo:Geometry = _camData.getPointsGeo();
		if (geo != null) {
			/*
			var points:PointCloud = new PointCloud(
				geo, new PointCloudMaterial( { color:0xffffff, size:4 } )
			);*/
			//var points:LineSegments = new LineSegments(geo, new LineBasicMaterial( { color:0xff0000 } ));
			//add(points);
		}
		
		//////////////////////////////////////////////setting
		var q:Array<Float> = frameData.q;
		_q = new Quaternion( q[0],q[1],q[2],q[3] );
		
		_fov = frameData.fov;
		
		_camera.position.x = frameData.x;
		_camera.position.y = frameData.y;
		_camera.position.z = frameData.z;
		
		_camera.quaternion.copy(_q);
		_camera.lookAt(_tgt );
		_camera.setFOV(_fov);
	
		_loading = false;
		_video.addEventListener("ended", _onFinish);
		_video.volume = 0;
		_video.play();
		
		//
		Browser.document.addEventListener("keydown" , _onKeyDown);
		
		//callback2
		if (_callback2 != null) {
			_callback2();
			//_callback2 = null;
		}		
		
	}
	
	/**
	 * _onKeyDown
	 * @param	e
	 */
	private function _onKeyDown(e):Void {
		//
		switch(Std.parseInt(e.keyCode)) {
			case Dat.RIGHT :
				_onFinish(null);
		}
	}
	
	/**
	 * 
	 */
	private function _onFinish(hoge:Dynamic):Void {
		_video.removeEventListener("ended", _onFinish);
		
		var nextIndex:Int = _index + 1;// Math.floor( Math.random() * _list.length );
		if (_index == nextIndex) {
			_index = _index + 1;
			_index = _index % _list.length;
		}else {
			_index = nextIndex;
		}		
		_start();
	}
	
	
	public function show():Void {
		
		visible = true;
		_videoPlane.show();
		
	}
	
	public function hide():Void {

		visible = false;		
		_videoPlane.hide();		
		
	}
	
	
	public function getVideo():VideoElement {
		return _video;
	}
	
	public function update(camera:ExCamera):Void {
		
		_videoPlane.update();
		
		if(_camData!=null && !_loading ){
			_camData.update(
				Math.floor((_video.currentTime) * 30) + _movieData.offset,
				camera
			);
			
		}
		
	}
	
	
	//getTexture
	public function getTexture():Texture {
		
		var canvas:CanvasElement = Browser.document.createCanvasElement();
		var ww:Int = 512;
		var hh:Int = 512;
		canvas.width = ww;
		canvas.height = hh;
		
		var contex:CanvasRenderingContext2D = canvas.getContext2d();
		contex.drawImage(_video, 0, 0, 960, 540, 0, 0, ww, hh);
		//contex.fillStyle = '#0000ff';
		//contex.fillRect(0, 0, ww-1, hh-1);

		var tex:Texture = new Texture(canvas);	
		tex.needsUpdate = true;
		return tex;
		
	}	
	
	public function getEnded():Bool {
		return _video != null ? _video.ended : true;
	}
	
	public function resize(w:Int, h:Int,oy:Float) 
	{
		_video.width = w;
		_video.height = h;
		_video.style.top = oy+"px";// -(h - Browser.window.innerHeight) / 2;
	}
}