package objects.objs;
import camera.ExCamera;
import materials.Textures;
import objects.objs.eye.Eye;
import objects.objs.line.HattoriLine;
import sound.MyAudio;
import three.Geometry;
import three.Matrix4;
import three.Mesh;
import three.MeshPhongMaterial;
import three.Plane;
import three.SphereGeometry;
import three.Texture;
import three.Vector3;
import tween.TweenMax;
import video.MovieData;

/**
 * ...
 * @author watanabe
 */
class Eyes extends MatchMoveObects
{

	private var _mesh:Mesh;
	private var _eyes:Array<Eye>;
	private var m:MeshPhongMaterial;
	private var _rad:Float = 0;
	private var _line:HattoriLine;
	private var _material:MeshPhongMaterial;
	private var _count:Int = 0;
	
	public function new() 
	{
		super();
	}

	
	override public function init():Void {
		
		//mendama
		if (_material != null) return;

		//_meshes
		_material = new MeshPhongMaterial({color:0xff0000});
		_material.map = Textures.eyeColor;			
		_material.normalMap = Textures.eyeNormal;
		//m.normalMap = Textures.handNormal;		
		_material.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 1)];//0.8 )];//
		_material.clipShadows = true;		
		_material.combine = Three.AddOperation;// Three.MultiplyOperation;
		_material.reflectivity = 0.1;
		_material.refractionRatio = 0.1;
		//
		
		//ippai tsukuru
		//var geo:SphereGeometry = new SphereGeometry(50, 50, 10, 10);
		var geo:Geometry = new Geometry();
		var mat4:Matrix4 = new Matrix4();
		mat4.multiply( new Matrix4().makeRotationX(Math.PI / 2));
		mat4.multiply( new Matrix4().makeRotationZ(Math.PI));
		
		//mat4.multiply( new Matrix4().makeRotationY(Math.PI));
		//mat4.multiply( new Matrix4().makeRotationZ(Math.PI / 2));
		
		
		geo.merge(new SphereGeometry(50, 50, 10, 10), mat4);		
		
		
		_eyes = [];
		
		for(i in 0...5){
			
			var eye:Eye = new Eye(geo,_material);
			eye.position.y = 100;
			eye.rotation.x = -Math.PI / 2;
			eye.castShadow = true;
			_eyes.push(eye);
			
			add(eye);
			
		}		
		
	}
	
	/**
	 * show
	 * @param	data
	 */
	override public function show(data:MovieData):Void {
		
		_data = data;		
		this.visible = true;
		
		var pos:Array<Vector3> = _data.camData.positions;
		var ss:Float = _data.size;
		var yy:Float = _data.offsetY;
		
		for (i in 0..._eyes.length) {
			
			if (i < pos.length) {
				
				var p:Vector3 = pos[i];
				_eyes[i].visible = true;
				//_meshes[i].geometry = MojiMaker.getGeo(_getIndex);
				_eyes[i].scale.set(ss, ss, ss);
				_eyes[i].position.x = p.x;
				_eyes[i].position.y = p.y + yy;
				_eyes[i].position.z = p.z;
				
			}else {
				
				_eyes[i].visible = false;				
			}

		}		
		
		_move();
		
	}
	
	/**
	 * _move
	 */
	private function _move():Void {
		
		var pos:Array<Vector3> = _data.camData.positions;
		for (i in 0..._eyes.length) {
			var p:Vector3 = pos[ _count % pos.length ];
			_eyes[i].tween(p, 0.5);
			_count++;
		}
		TweenMax.delayedCall(2, _move);
		
	}
	
	
	
	
	override public function setEnvMap(texture:Texture):Void
	{
		if(m!=null){
			m.envMap = texture;
		}
		//if (_eyeball!=null) {
		//	untyped _eyeball.material.envMap = texture;	
		//}
	}		
	
	/**
	 * 
	 * @param	a
	 */
	override public function update(a:MyAudio):Void {
		
		_rad += 0.1;
		var camPos:Vector3 = Main3d.getCamera().position;

		Textures.eyeColor.offset.set(0, -0.1+0.2 * a.freqByteData[3] / 255 );
		
		for (i in 0..._eyes.length) {
			
			//_eyes[i].rotation.z += 0.03;
			_eyes[i].look(camPos, a);
			
		}
		
		//if (_line != null) {
		//	_line.update(a);
		//}
	}	
	
	override public function kill():Void {
		
		
	}
	
	
	
}