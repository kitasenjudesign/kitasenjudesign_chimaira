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

/**
 * ...
 * @author watanabe
 */
class VideoPlayerOld extends Object3D
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
	private var _plane:Mesh;
	private var _plane2:Mesh;
	private var _isTweening:Bool=false;
	
	public function new() 
	{
		super();
	}
	
	/**
	 * init
	 * @param	filename
	 * @param	callback
	 */
	public function init(scene:Scene, camera:ExCamera,callback:Void->Void):Void {

		_scene = scene;
		_tgt = new Vector3();
		_camera = camera;
		_callback = callback;
		//_changeCallback = changeCallback;
		_config = new Config();
		_config.load("config.json", _onInit);
		
	}
	
	private function _onInit():Void
	{
		///Browser.window.alert("_onInit");
		_list = _config.list;
		
		_video = Browser.document.createVideoElement();
		/*
		_video.style.position = "absolute";
		_video.style.zIndex = "0";
		_video.style.top = "0";
		_video.style.left = "0";
		_video.style.visibility = "hidden";
		//Browser.document.body.appendChild(_video);
		*/
		//Browser.document.body.appendChild(_video);
		
		//_video = cast Browser.document.getElementById("vi");
		
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
		var nextIndex:Int = _index + 1;// Math.floor( Math.random() * _list.length );
		if (_index == nextIndex) {
			_index = _index + 1;
			_index = _index % _list.length;
		}else {
			_index = nextIndex;
		}
		_video.src = "";
		_movieData = _list[_index%_list.length];
		_movieData.loadCamData(_onLoad);
		
		Browser.window.onmousedown = _onDown;
	}
	
	function _onDown(e) 
	{
		if(!_isTweening)_onFinish(null);
	}
	
	/**
	 * 
	 */
	private function _onLoad():Void {
		
		_video.src = _movieData.pathMov;
		//_video.style.display = "none";
		_video.addEventListener("canplay", _onLoad2);
		
	}
	
	private function _onLoad2(e):Void{
		
		//load suru
		//Browser.window.alert("_onLoad");
		_camData	= _movieData.camData;
		var frameData:Dynamic = _camData.getFrameData(0);
		
		
		_plane2 = _makePlane2(_camData.getQ(0), _camData.getV(0), frameData.fov,true);//plane 
		_scene.add( _plane2 );		
		
		var mm:Mesh = _camData.getArea();
		if ( mm!=null ) {
			add(mm);
		}
		
		
		
		
		var geo:Geometry = _camData.getPointsGeo();
		if (geo != null) {
			/*
			var points:PointCloud = new PointCloud(
				geo, new PointCloudMaterial( { color:0xffffff, size:4 } )
			);*/
			var points:Line = new Line(geo, new LineBasicMaterial( { color:0xff0000 } ));
			//add(points);
		}
		
		var m2:Mesh = new Mesh(
			cast new PlaneBufferGeometry(400, 400, 5, 5), 
			new MeshBasicMaterial( { color:0x00ff00, wireframe:true } )
		);
		m2.rotation.x = Math.PI / 2;
		add(m2);
		
		
		
		_isTweening = true;
		var o:Object3D = new Object3D();
		
		var q:Array<Float> = frameData.q;
		_q = new Quaternion( q[0],q[1],q[2],q[3] );
		o.quaternion.copy(_q);
		var camTgtPos:Vector3 = new Vector3(frameData.x, frameData.y, frameData.z);
		
		var time:Float = 0;
		TweenMax.to(this, time, {
			_fov:frameData.fov,
			onUpdateFov:_onUpdateFov,
			ease:Sine.easeInOut
		});
		TweenMax.to(_camera.position, time, {
			x:camTgtPos.x,
			y:camTgtPos.y,
			z:camTgtPos.z,
			ease:Sine.easeInOut
		});
		TweenMax.to(_camera.quaternion, time, {
			x:_q.x,
			y:_q.y,
			z:_q.z,
			w:_q.w,
			onComplete:_start2,
			ease:Power0.easeInOut
		});
		if(_plane!=null){
			TweenMax.to(_plane.scale, time*0.95, {
				x:0,
				y:0,
				z:0,
				ease:Sine.easeIn
			});
		}
		
		
	}
	
	function _onUpdateLook() 
	{
		_camera.lookAt(_tgt );
	}
	
	
	
	private function _onUpdateFov():Void
	{
		_camera.setFOV(_fov);
	}
	
	private function _start2():Void{
	
		if (_plane != null) {
			_scene.remove( _plane );
		}		
		if (_plane2 != null) {
			_scene.remove( _plane2 );
		}
		
		_loading = false;
		//trace("movie = " + _movieData.pathMov);
		_isTweening = false;
		_video.addEventListener("ended", _onFinish);
		//_video.style.display = "none";		
		_video.play();
		
		Browser.document.addEventListener("keydown" , _onKeyDown);
		
		if (_callback2 != null) {
			_callback2();
			//_callback2 = null;
		}		
		
	}
	
	private function _onKeyDown(e):Void {
	
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

		_plane = _makePlane(_camera.quaternion, _camera.position, _camera.fov,false);//plane 
		_scene.add( _plane );		
		
		//_index++;
		_start();
		//_video.src = "";
	}
	
	/**
	 * 
	 * @return
	 */
	private function _makePlane(q:Quaternion,lookPos:Vector3,fov:Float,isWire:Bool):Mesh {
		
		var tex:Texture = getTexture();
		tex.needsUpdate = true;
		return _makePlane2(q, lookPos, fov, isWire, tex);
		
	}
	
	
	private function _makePlane2(q:Quaternion,lookPos:Vector3,fov:Float,isWire:Bool,tex:Texture=null):Mesh{
		var p:Mesh = new Mesh(
			new PlaneGeometry(960, 540, 3, 3), 
			new MeshBasicMaterial( { color:0xffffff, side:Three.FrontSide, map:tex,wireframe:isWire } )
		);
		
		var dis:Float = getDist(_camera, 960, fov);
		var pos:Vector3 = new Vector3(0, 0, - dis);
		pos.applyQuaternion( q );//////quaternion
		p.position.copy( lookPos.clone().add(pos) );	
		p.quaternion.copy( q.clone() );
		
		//p.lookAt(lookPos);
		//getDist
				
		
		return p;
		
	}
	
	
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
	
	public function getDist(camera:PerspectiveCamera, width:Float,fov:Float):Float {
		 var h:Float    = width / camera.aspect * 0.5;
		 var rad:Float  = ( fov * Math.PI / 180 ) * 0.5;     
		 var dist:Float = h / Math.tan( rad );
		 return dist;
	}	
	
	/**
	 * 
	 */
	public function next():Void {
		
		
		
	}
	
	public function getVideo():VideoElement {
		return _video;
	}
	
	public function update(camera:ExCamera):Void {
		
		
		if(_camData!=null && !_loading ){
			_camData.update(
				Math.floor((_video.currentTime) * 30) + _movieData.offset,
				camera
			);
			
		}
		
	}
	
	public function getEnded():Bool {
		return _video != null ? _video.ended : true;
	}
	
	public function resize(w:Int, h:Int,oy:Float) 
	{
		_video.width = w;
		_video.height = h;
		//_video.style.top = oy+"px";// -(h - Browser.window.innerHeight) / 2;
	}
}