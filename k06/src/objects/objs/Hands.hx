package objects.objs;
import common.SimpleDAELoader;
import js.Browser;
import materials.Textures;
import sound.MyAudio;
import three.Mesh;
import three.MeshPhongMaterial;
import three.Plane;
import three.Vector3;
import video.MovieData;

/**
 * ...
 * @author watanabe
 */
class Hands extends MatchMoveObects
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
		_loader.load("dae/hand.dae", null);
		
	}
	
	override public function show(data:MovieData):Void {
		_data = data;		
		this.visible = true;
		
		var m:MeshPhongMaterial = new MeshPhongMaterial();
		m.map = Textures.handColor;
		
		//m.normalMap = Textures.handNormal;		
		m.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 1)];//0.8 )];//
		m.clipShadows = true;		
		
		
		_mesh = _loader.meshes[0];		
		_mesh.scale.set(300, 300, 300);
		_mesh.position.y = -50;
		
		_mesh.rotation.x = -Math.PI / 2;
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
	
	override public function update(a:MyAudio):Void {
		
		
		_mesh.rotation.z += 0.03;
		
	}	
	
}