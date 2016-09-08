package objects;
import three.Object3D;

/**
 * ...
 * @author watanabe
 */
class MatchMoveObects extends Object3D
{

	
	public function new() 
	{
		
	}
	
	public function init():Void {
		
		cubes = [];
		for(i in 0...10){
			var cube2:Mesh = new Mesh(
				new BoxGeometry(10, 10, 10,2,2, 2),
				new MeshBasicMaterial( { color:0xff0000 } )
			);
			cube2.position.x = 190 + 30*i;		
			cube2.position.y = 20 + 40*Math.random();		
			cube2.position.z = -200 + 400*Math.random();
			_scene.add(cube2);
			cubes.push(cube2);
		}		
	}
	
	public function update():Void {
		
	}
	
}