package materials;
import three.MeshPhongMaterial;
import three.Plane;

/**
 * ...
 * @author watanabe
 */
class MyFaceMaterial extends MeshPhongMaterial
{

	
	
	public function new() 
	{
		
		
		var p:Plane = new Plane(
			new Vector3( 0, 1, 0 ), 0.8 
		);		
		
		//_texture = ImageUtils.loadTexture( "mate3.png" );
		_texture = ImageUtils.loadTexture( Path.assets + "face/dede_face_diff.png" );
		
		
		/*
		_texture.wrapS = Three.RepeatWrapping;
		_texture.wrapT = Three.RepeatWrapping;
		_texture.repeat.set(2, 2);
		*/
		_material = new MeshPhongMaterial( { color:0xffffff, map:_texture } );
		//_material.alphaMap = _texture;
		
		//_material.alphaTest = 0.5;
		//_material.transparent = true;
		_material.clippingPlanes = [p];//
		_material.clipShadows = true;
		_material.side = Three.DoubleSide;		
		
		//super();
		
	}
	
	
	
	
	
}