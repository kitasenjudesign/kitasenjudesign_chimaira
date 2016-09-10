package materials;
import three.MeshPhongMaterial;

/**
 * ...
 * @author watanabe
 */
class MaterialManager
{


	
	public function new() 
	{
		
	}	
	
	/*******************************************************/
	private static var instance=null;
    private static var internallyCalled:Bool = false;
	
    public function new() {
        if(internallyCalled){
            internallyCalled=false;
        }else{
            throw "Singleton.getInstance()で生成してね。";
        }
    }

    public static function getInstance():MaterialManager{
        if(DataManager.instance==null){
            internallyCalled = true;
            instance = new MaterialManager();
        }
        return instance;		
    }
	/*******************************************************/	
	
	

	/**
	 * 
	 */
	public function init():Void {
		
	}
	
	private function getDummy() {
		
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
		
	}
	
	//
	
	
	
	
	
	
	
	
	
	
	
}