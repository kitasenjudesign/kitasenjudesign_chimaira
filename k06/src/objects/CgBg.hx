package objects;
import objects.bg.GridPoints;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PlaneBufferGeometry;
import three.Points;

/**
 * ...
 * @author watanabe
 */
class CgBg extends Object3D
{

	private var _ground:Points;
	
	public function new() 
	{
		super();
	}
	
	public function init():Void {
		/*
		_ground = new Mesh(
			cast new PlaneBufferGeometry(2000,2000,10,10),
			new MeshBasicMaterial({color:0xffff00,wireframe:true})
		);
		_ground.rotation.x = Math.PI / 2;
		*/
		//add(_ground);
		
		var p:GridPoints = new GridPoints();
		add(p);
		hide();
		
	}
	
	public function show():Void {
		
		this.visible = true;
		
	}
	
	public function hide():Void {

		this.visible = false;		
		
	}
	
	
	
}