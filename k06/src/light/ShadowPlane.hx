package light;
import common.Dat;
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
	private var _mat:ShadowMaterial;
	private var _mat2:MeshLambertMaterial;
	private var _flag:Bool = false;
	
	public static var instance:ShadowPlane;
	
	public function new() 
	{
		_mat = new ShadowMaterial();
		_mat.opacity = 0.3;
		
		_mat2 = new MeshLambertMaterial( { color:0xff0000 } );
		//shadow no ookisa
		super(
			new PlaneGeometry(1500, 1000, 5, 5),
			_mat
		);
		receiveShadow = true;
		position.y = 0;
		rotation.x = -Math.PI / 2;
		
		instance = this;
		
		Dat.gui.add(this, "_changeMat");
		
	}
	
	/**
	 * 
	 */
	private function _changeMat():Void {
		
		material = _flag ? _mat : _mat2;
		_flag = !_flag;
		
	}
	

	/**
	 * 
	 * @param	s
	 */
	public static function setSize(s:Float):Void {
		
		//instance.scale.set(s, s, s);
		
	}
	
}