package objects.objs;
import common.SimpleDAELoader;
import sound.MyAudio;
import three.Mesh;
import three.MeshPhongMaterial;
import three.Plane;
import three.Texture;
import three.Vector3;
import video.MovieData;

/**
 * DEDELOGO
 * @author watanabe
 */
class Dedes extends MatchMoveObects
{

	private var _loader:SimpleDAELoader;
	private var _mesh:Mesh;
	
	
	public function new() 
	{
		super();
	}
	
	override public function init():Void {
		
		//men tama 
		_loader = new SimpleDAELoader();
		_loader.load("dae/mouse.dae", null);
		
	}
	
	
	override public function show(data:MovieData):Void {
		_data = data;		
		this.visible = true;
		
		var m:MeshPhongMaterial = new MeshPhongMaterial({color:0xffffff});		
		//m.normalMap = Textures.handNormal;		
		m.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 1)];//0.8 )];//
		m.clipShadows = true;		
		
		_mesh = _loader.meshes[0];		
		_mesh.scale.set(0.2, 0.2, 0.2);
		_mesh.material = cast m;
		_mesh.castShadow = true;
		add(_mesh);
		
		/*
		var geo:Geometry = _data.camData.getPointsGeo();
		if (geo != null) {
			
			var points:PointCloud = new PointCloud(
				geo, new PointCloudMaterial( { color:0xffffff, size:4 } )
			);
			//var points:Line = new Line(geo, new LineBasicMaterial( { color:0xff0000 } ));
			add(points);
		}*/
		
		
	}

	
	override public function setEnvMap(texture:Texture):Void
	{
		if(_mesh!=null){
			untyped _mesh.material.envMap = texture;
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
		
		_mesh.rotation.x += 0.005;
		_mesh.rotation.y += 0.012;		
		_mesh.rotation.z += 0.018;
		
	}		
	
}