package video;
import camera.ExCamera;
import common.Dat;
import haxe.Http;
import haxe.Json;
import js.Browser;
import three.BoxGeometry;
import three.Geometry;
import three.Matrix3;
import three.Matrix4;
import three.Mesh;
import three.MeshBasicMaterial;
import three.PerspectiveCamera;
import three.Quaternion;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class CameraData
{

	private var _frameData:Array<Dynamic>;
	private var _callback:Void->Void;
	private var _http:Http;
	
	private var _rx:Float = 0.001;
	private var _ry:Float = 0.001;
	private var _rz:Float = 0.001;

	private var _qx:Float = 0.001;
	private var _qy:Float = 0.001;
	private var _qz:Float = 0.001;
	private var _qw:Float = 0.001;

	private var _fov:Float = 0;
	private var _points:Array<Array<Float>>;
	private var _area:Dynamic;

	public var positions:Array<Vector3>;
	
	public function new() 
	{
		
	}
	
	public function load(filename:String,callback:Void->Void):Void {
		_callback = callback;

		_http = new Http(filename);
		//_http = new Http("cam.json");
		
		_http.onData = _onData;
		_http.request();
		positions = [];
		/*
		Dat.gui.add(this, "_rx",0,6.288).listen();
		Dat.gui.add(this, "_ry",0,6.288).listen();
		Dat.gui.add(this, "_rz",0,6.288).listen();
		Dat.gui.add(this, "_qx",0,6.288).listen();
		Dat.gui.add(this, "_qy",0,6.288).listen();
		Dat.gui.add(this, "_qz", 0, 6.288).listen();		
		*/
	}
	
	private function _onData(data:String):Void {
		var data:Dynamic = Json.parse(data);

		_frameData = data.frames;
		_points = data.points;
		
		
		var p:Array<Array<Float>> = data.positions;
		
		
		for (i in 0...p.length) {
			positions[i] = new Vector3(
				p[i][0],
				p[i][1],
				-p[i][2]
			);
		}
		
		//area wo kuwaeru
		
		if (_callback != null) {
			_callback();
		}
	}
	
	
	/*
	public function getArea():Mesh {
		
		if (_area == null) return null;
		
		var mesh:Mesh = new Mesh(
			new BoxGeometry(_area.sx, _area.sy, _area.sz,3,3,3),
			new MeshBasicMaterial( { color:0xff0000,wireframe:true } )
		
		);
		mesh.quaternion.copy( 
			new Quaternion(_area.q[0], _area.q[1], _area.q[2], _area.q[3])
		);
		mesh.position.set(
			_area.x,
			_area.y,
			_area.z			
		);
		return mesh;
	}*/
	
	
	public function getPointsGeo():Geometry {
		var g:Geometry = new Geometry();
		if (_points == null) return null;
		
		for ( i in 0..._points.length) {
			
			if( _points[i][1]>-2 && _points[i][1]<2 ){
			
				g.vertices.push(new Vector3(
					_points[i][0],
					_points[i][1],
					-_points[i][2]				
				));
			
			}
		}
		return g;
	}
	
	public function getFrameData(frame:Int):Dynamic {
		
		return _frameData[frame];
	}
	
	public function update(f:Int,cam:ExCamera):Void {
		
		//Tracer.debug("F"+f +" "+_frameData.length);
		
		if (f >= _frameData.length) {
			return;
		}
		
		var q:Array<Float> = _frameData[f].q;
		var qtn:Quaternion = new Quaternion( q[0],q[1],q[2],q[3] );
		cam.quaternion.copy(qtn);
		//cam.matrixWorldNeedsUpdate = true;		
		
		cam.position.x = _frameData[f].x;
		cam.position.y = _frameData[f].y;
		cam.position.z = _frameData[f].z;
		//cam.lookAt(new Vector3());
		
		_qx = q[0];
		_qy = q[1];
		_qz = q[2];
		
		//fov update
		if ( Math.abs(_fov - _frameData[f].fov)>0.5 ) {
			_fov = _frameData[f].fov;
			trace("change fov");
			cam.setFOV(_fov);
		}
		
	}
	
	public function getV(f:Int):Vector3
	{
		return new Vector3(_frameData[f].x,_frameData[f].y,_frameData[f].z);
	}	
	
	public function getQ(f:Int):Quaternion
	{
		var q:Array<Float> = _frameData[f].q;
		var qtn:Quaternion = new Quaternion( q[0], q[1], q[2], q[3] );
		return qtn;
	}
	
	private function _getMatrix(a:Array<Float>):Matrix4 {
		
		 var m:Matrix4 = new Matrix4();
		 m.set(
			a[0], a[1], a[2], a[3],
			a[4], a[5], a[6], a[7],
			a[8], a[9], a[10], a[11],
			a[12], a[13], a[14], a[15]
		);
		return m;
	}
	
	
}