package light;
import camera.ExCamera;
import three.SpotLight;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class MySpotLight extends SpotLight
{

	
	public static var instance:MySpotLight; 
	
	
	public function new() 
	{
		
		super( 0xff0000, 0);// 1.5 );
		
		//light.position.x = 10*(Math.random()-0.5);
		position.x = 200;
		position.y = 3000;
		position.z = 200;
		
		castShadow = true;
		
	
		
		
		var fuga:MySpotLight = this;
		untyped __js__("
			fuga.shadow = new THREE.LightShadow( new THREE.PerspectiveCamera( 30, 16/9, 200, 6000 ) );
			fuga.shadow.bias = 0;// 0.001;// -0.000222;
			fuga.shadow.mapSize.width = 2048;
			fuga.shadow.mapSize.height = 2048;		
			fuga.shadow.onlyShadow = true;
		");
		
		this.onlyShadow = true;
		this.lookAt( new Vector3());
		
		instance = this;
		//_scene.add(light);
	}
	
	//camera to gyaku houkou
	public function setSize(f:Float):Void {
		
		
		position.normalize();
		position.x *= 6000 * f; 
		position.y *= 6000 * f;
		position.z *= 6000 * f;
		
		/*
		var v:Vector3 = new Vector3(
			-cam.position.x,
			0
			-cam.position.z
		);
		v = v.normalize();
		position.x = v.x * 1000;
		position.z = v.z * 1000;
		
		this.lookAt( new Vector3());
		*/
	}
	//lightwo 
	
	
}