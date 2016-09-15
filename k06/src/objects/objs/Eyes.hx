package objects.objs;
import materials.Textures;
import objects.objs.line.HattoriLine;
import sound.MyAudio;
import three.Geometry;
import three.Line;
import three.LineBasicMaterial;
import three.LineSegments;
import three.Mesh;
import three.MeshPhongMaterial;
import three.Object3D;
import three.Plane;
import three.PointCloud;
import three.PointCloudMaterial;
import three.SphereGeometry;
import three.Texture;
import three.Vector3;
import video.MovieData;

/**
 * ...
 * @author watanabe
 */
class Eyes extends MatchMoveObects
{

	private var _mesh:Mesh;
	private var _meshes:Array<Mesh>;
	private var m:MeshPhongMaterial;
	private var _rad:Float = 0;
	private var _line:HattoriLine;
	
	public function new() 
	{
		super();
	}

	override public function init():Void {
		
		//men tama 
		
	}
	
	/**
	 * 
	 * @param	data
	 */
	override public function show(data:MovieData):Void {
		_data = data;		
		this.visible = true;
		
		if(_mesh==null){
			
			m = new MeshPhongMaterial({color:0xff0000});
			
			m.map = Textures.eyeColor;			
			m.normalMap = Textures.eyeNormal;
			//m.normalMap = Textures.handNormal;		
			m.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 1)];//0.8 )];//
			m.clipShadows = true;		
			m.combine = Three.AddOperation;// Three.MultiplyOperation;
			m.reflectivity = 0.1;
			m.refractionRatio = 0.1;
		
			_mesh = new Mesh(new SphereGeometry(50,50,10,10),	m);
			_mesh.position.y = 100;
			
			_mesh.rotation.x = -Math.PI / 2;
			_mesh.material = cast m;
			_mesh.castShadow = true;
			add(_mesh);
		}
		
		
		/*
		var geo:Geometry = _data.camData.getPointsGeo();
		_line = new HattoriLine();
		_line.init( geo,m );
		add(_line);
		*/
		/*
		var geo2:Geometry = new Geometry();
		if (geo != null) {
			
			for (i in 0...geo.vertices.length) {
				
				var vv:Vector3 = geo.vertices[i].clone();
				vv.y = 100 * Math.random();
				geo2.vertices.push(vv);
			}
			geo2.verticesNeedUpdate = true;
			
			var points:Line = new Line(
				geo2,
				new LineBasicMaterial( { color:0xff0000 } )
			);
			add(points);
			
		}*/
		
		
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
	
	override public function update(a:MyAudio):Void {
		
		_rad += 0.1;
		Textures.eyeColor.offset.set(0, 0.2 * a.freqByteData[3]/255 );
		_mesh.rotation.z += 0.03;
		
		//if (_line != null) {
		//	_line.update(a);
		//}
	}	
	
	
	
}