package materials;
import three.Color;
import three.MeshPhongMaterial;

/**
 * ...
 * @author watanabe
 */
class MaterialParams
{

	public static inline var MAT_COLOR		:Int = 0;
	public static inline var MAT_MIRROR		:Int = 1;
	public static inline var MAT_NET_RED	:Int = 2;		
	public static inline var MAT_NET		:Int = 3;
	public static inline var MAT_WIREFRAME	:Int = 4;

	
	public function new() 
	{
		
	}

	//setmaterial
	
	public static function setParam(material:MeshPhongMaterial,matIndex:Int):Void {
		
		/*
			public static inline var MAT_WIREFRAME	:Int = 0;
			public static inline var MAT_MIRROR		:Int = 1;
			public static inline var MAT_COLOR		:Int = 2;
			public static inline var MAT_MESH		:Int = 3;
			public static inline var MAT_MESH_RED	:Int = 4;	
		*/
	
		//3pattern
		//matIndex++;
		//matIndex = matIndex % MAT_NUM;
		
		
		switch(matIndex) {
			case MAT_WIREFRAME://0
				//normal
				material.map = Textures.colorWhite;
				material.color = (Math.random() < 0.5) ? new Color(0xffffff) : new Color(0xee1111); 
				material.refractionRatio = 0.3;
				material.reflectivity = 0.3;				
				material.wireframe = true;
				material.transparent = false;
				
			case MAT_MIRROR://1
				material.map = Textures.colorWhite;
				material.transparent = false;				
				material.refractionRatio = 0.7;
				material.reflectivity = 0.7;
				//_material.shininess = 0.01;				
				material.wireframe = false;
				
				
			case MAT_COLOR://2
				
				material.map = Textures.dedeColor;
				material.color = Math.random() < 0.5 ? new Color(0xffffff) : new Color(0xee1111); 
				material.transparent = false;
				material.refractionRatio = 0.1;
				material.reflectivity = 0.1;
				material.wireframe = false;
			
			case MAT_NET://3
				//Browser.window.alert("net!! " + _matIndex);
				material.map = Textures.dedeColor;
				material.transparent = true;
				material.alphaTest = 0.5;				
				material.alphaMap = Math.random() < 0.5 ? Textures.moji1 : Textures.meshMono;				
				material.wireframe = false;
			
					
			case MAT_NET_RED:
				//Browser.window.alert("red!! " + _matIndex);
				//_material.map = ImageUtils.loadTexture("mate3.png");
				material.wireframe = false;
				material.map = Math.random() < 0.5 ? Textures.moji1 : Textures.meshRed;
				material.alphaMap = Textures.colorWhite;
				material.refractionRatio = 0.7;
				material.reflectivity = 0.7;				
				material.side = Three.DoubleSide;
				
		}
	
		material.needsUpdate = true;
	}
	
	
}