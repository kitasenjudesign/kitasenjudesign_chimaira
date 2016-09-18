package light;
import camera.ExCamera;
import common.Dat;
import three.SpotLight;
import three.SpotLightHelper;
import three.Vector3;
import video.MovieData;

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
			//fuga.shadow = new THREE.LightShadow( new THREE.PerspectiveCamera( 30, 16/9, 200, 6000 ) );
			fuga.shadow = new THREE.LightShadow( new THREE.PerspectiveCamera( 30, 16/9, 200, 6000 ) );
			
			fuga.shadow.bias = -0.0000022;// 0.001;// -0.000222;
			fuga.shadow.mapSize.width = 2048;
			fuga.shadow.mapSize.height = 2048;		
			fuga.shadow.onlyShadow = true;
		");
		
		this.onlyShadow = true;
		this.lookAt( new Vector3());
		
		instance = this;
		//_scene.add(light);
		
		Dat.gui.add(this.position, "x", -3000, 3000);
		Dat.gui.add(this.position, "y", -3000, 3000);
		Dat.gui.add(this.position, "z", -3000, 3000);
		
	}
	
	//camera to gyaku houkou
	public function setSize(data:MovieData):Void {
		
		var f:Float = data.size;
		/*
		position.normalize();
		position.x *= 6000 * f; 
		position.y *= 6000 * f;
		position.z *= 6000 * f;
		*/
		
		var cam:ExCamera = Main3d.getCamera();
		
		var pos:Vector3 = new Vector3(0, 0, -1);
		pos.applyQuaternion(cam.quaternion);
		
		
		var v:Vector3 = new Vector3(
			-cam.position.x,
			0,
			-cam.position.z
		);
		v = v.normalize();
		/*
		position.x = v.x * 400 * f;
		position.y = 5000 * f;
		position.z = v.z * 400 * f;
		*/
		
		if ( data.id == "OSHO") {
			
			
			this.lookAt( new Vector3() );// cam.position );
		}else{
		
			position.x = v.x * 100 * f;
			position.y = 2000 * f;
			position.z = v.z * 100 * f;
			
			this.lookAt( new Vector3() );// cam.position );
		}
	}
	
	//lightwo 
	
	
}