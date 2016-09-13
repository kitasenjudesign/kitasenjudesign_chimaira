package light;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshLambertMaterial;
import three.PlaneGeometry;
import three.Scene;
import three.ShadowMaterial;

/**
 * ...
 * @author watanabe
 */
class ShadowPlane extends Mesh
{

	private var _geo:PlaneGeometry;
	public static var instance:ShadowPlane;
	
	public function new() 
	{
		//var mm:ShadowMaterial = new ShadowMaterial();
		//mm.opacity = 0.3;
		
		var mm:MeshLambertMaterial = new MeshLambertMaterial( { color:0xff0000 } );
		//shadow no ookisa
		super(
			new PlaneGeometry(1000, 1000, 5, 5),
			mm
		);
		receiveShadow = true;
		position.y = 0;
		rotation.x = -Math.PI / 2;
		
		instance = this;
	}

	/**
	 * 
	 * @param	s
	 */
	public static function setScale(s:Float):Void {
		
		//instance.scale.set(s, s, s);
		
	}
	
}