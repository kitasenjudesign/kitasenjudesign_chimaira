package objects.objs;
import common.Path;
import js.Browser;
import materials.Textures;
import objects.MyDAELoader;
import objects.objs.motion.FaceMotion;
import sound.MyAudio;
import three.Color;
import three.ImageUtils;
import three.MeshPhongMaterial;
import three.Plane;
import three.Texture;
import three.Vector3;
import video.MovieData;

/**
 * ...
 * @author watanabe
 */
class Faces extends MatchMoveObects
{

	
	public static inline var MAT_WIREFRAME	:Int = 4;
	public static inline var MAT_MIRROR		:Int = 1;
	public static inline var MAT_COLOR		:Int = 0;
	public static inline var MAT_NET		:Int = 3;
	public static inline var MAT_NET_RED	:Int = 2;
	public static inline var MAT_NUM:Int = 5;
	
	//public static var MATERIALS
	
	private var _faces		:Array<MyFaceSingle>;
	private var _material	:MeshPhongMaterial;
	private var _texture:Texture;
	private var _loader:MyDAELoader;
	private var _matIndex:Int = -1;
	private var _offsetY:Float = 0;
	private var _motion:FaceMotion;
	var _redTexture:Texture;
	var _offsetX:Float=0;
	var _count:Int = 0;
	
	public function new() 
	{
		super();
	}
	
	/**
	 * 
	 */
	override public function init():Void {

		_motion = new FaceMotion();
		_loader = new MyDAELoader();
		_loader.load(_onInit0);
		
	}
	
	private function _onInit0():Void {
		
		_texture = Textures.dedeColor; //ImageUtils.loadTexture( Path.assets + "face/dede_face_diff.png" );
		//_texture.wrapS = Three.RepeatWrapping;
		//_texture.wrapT = Three.RepeatWrapping;
		//_texture.repeat.set(2, 2);
		
		_material = new MeshPhongMaterial( { color:0xffffff, map:_texture } );
		_material.refractionRatio = 0.1;
		_material.reflectivity = 0.1;
		_material.shininess = 0.01;
	
		//_material.normalMap = Textures.eyeNormal;
		//_material.wireframe = false;
		//_material.alphaMap = Textures.meshMono;
		_material.alphaTest = 0.5;
		_material.transparent = true;
		
		_material.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 1)];//0.8 )];//
		_material.clipShadows = true;
		_material.side = Three.DoubleSide;		

		
		//faces
		_faces = [];
		
		for(i in 0...6){ 
			
			var face:MyFaceSingle = new MyFaceSingle(i);
			face.init( _loader, null );
			face.dae.material = _material;	
			face.dae.castShadow = true;
			
			var ss:Float = 40 + 10 * Math.random();
			face.dae.scale.set(ss, ss, ss);
			
			face.position.x = 20 * (Math.random() - 0.5);
			face.position.y = 100;// i * -250;
			face.position.z = 20 * (Math.random() - 0.5);
			
			//face.dae.rotation.y = Math.random() * 2 * Math.PI;
			add(face);
			_faces.push(face);
			
		}		
		
		_motion.init( _faces );
		
			
	}
	
	
	
	
	/**
	 * 
	 * @param	data
	 */
	override public function show(data:MovieData):Void {
		_data = data;		
		this.visible = true;
		
		
		var rotMode:Int = 0;
		var posMode:Int = 0;
		switch(_count%4) {
			case 0:
				posMode = FaceMotion.MODE_POS_FIX;
				rotMode = FaceMotion.MODE_ROT_Y;
			case 1:
				posMode = FaceMotion.MODE_POS_MOVE_Y;
				rotMode = FaceMotion.MODE_ROT_XYZ;				
			case 2:
				posMode = FaceMotion.MODE_POS_FIX;
				rotMode = FaceMotion.MODE_ROT_XYZ;			
			case 3:
				posMode = FaceMotion.MODE_POS_FIX;
				rotMode = FaceMotion.MODE_ROT_XYZ;			
		}
		
		_motion.start(
			data,posMode,rotMode
		);
		_count++;
		
		
		_changeMat();
		
	}	
	
	private function _changeMat():Void {
		
		/*

	public static inline var MAT_WIREFRAME	:Int = 0;
	public static inline var MAT_MIRROR		:Int = 1;
	public static inline var MAT_COLOR		:Int = 2;
	public static inline var MAT_MESH		:Int = 3;
	public static inline var MAT_MESH_RED	:Int = 4;	
		*/
	
		//3pattern
		_matIndex++;
		_matIndex = _matIndex % MAT_NUM;
		
		
		switch(_matIndex) {
			case MAT_WIREFRAME://0
				//normal
				_material.map = Textures.colorWhite;
				_material.color = (Math.random() < 0.5) ? new Color(0xffffff) : new Color(0xee0000); 
				_material.refractionRatio = 0.7;
				_material.reflectivity = 0.7;				
				_material.wireframe = true;
				_material.transparent = false;
				
			case MAT_MIRROR://1
				_material.map = Textures.colorWhite;
				_material.transparent = false;				
				_material.refractionRatio = 0.7;
				_material.reflectivity = 0.7;
				//_material.shininess = 0.01;				
				_material.wireframe = false;
				
				
			case MAT_COLOR,MAT_NET_RED://2
				
				_material.map = Textures.dedeColor;
				_material.color = new Color(0xffffff);// Math.random() < 0.5 ? new Color(0xffffff) : new Color(0xee4444); 
				_material.transparent = false;
				_material.refractionRatio = 0.1;
				_material.reflectivity = 0.1;
				_material.wireframe = false;
			
			case MAT_NET://3
				//Browser.window.alert("net!! " + _matIndex);
				//_material.map = Textures.dedeColor;
				_material.transparent = true;
				_material.alphaTest = 0.5;				
				_material.alphaMap = Textures.meshMono;				
				_material.wireframe = false;
			
					/*
			case MAT_NET_RED:
				//Browser.window.alert("red!! " + _matIndex);
				//_material.map = ImageUtils.loadTexture("mate3.png");
				_redTexture = Textures.moji1;// Math.random() < 0.5 ? Textures.moji1 : Textures.meshRed;
				_material.wireframe = false;
				_material.map = _redTexture;
				_material.alphaMap = Textures.colorWhite;
				_material.refractionRatio = 0.7;
				_material.reflectivity = 0.7;				
				_material.side = Three.DoubleSide;*/
				
		}
	
		_material.needsUpdate = true;
	}
		
	
	
	/**
	 * 
	 * @param	texture
	 */
	override public function setEnvMap(texture:Texture):Void
	{
		_material.envMap = texture;
	}		
	
	/**
	 * 
	 * @param	a
	 */
	override public function update(a:MyAudio):Void {
		
		if (!this.visible) return;
		
		
		//update
		if ( _matIndex == MAT_NET ) {
			/*
			Tracer.debug("yy>>>"+_offsetY);
			_offsetY += 0.01;
			Textures.meshMono.offset.set(_offsetY, 0);
			Textures.meshMono.repeat.set(1 + _offsetY/2, 1 + _offsetY/2);
			_material.needsUpdate = true;
			Textures.meshMono.needsUpdate = true;
			*/
		
		}else if ( _matIndex == MAT_NET_RED ) {
			
			//_offsetX += a.freqByteData[4] / 255 * 0.1;
			//_offsetY += a.freqByteData[7] / 255 * 0.1;
			//_redTexture.offset.set(_offsetX, _offsetY);	
			//_material.needsUpdate = true;
		
		}		
		
		if (_faces.length > 0) {
			
			_motion.update(a);
			
			/*
			for(i in 0..._faces.length){
				
				_faces[i].rotation.y += 0.03 + i / 340;
				_faces[i].updateSingle(a);
				
				if (_faces[i].position.y > 500) {
					_faces[i].position.y = -500;
					
					_faces[i].rotation.set(0, Math.random() * 2 * Math.PI, 0);
					
					var ss:Float = 50 + 30 * Math.random();
					_faces[i].scale.set(ss, ss, ss);
			
					//_faces[i]
				}
			}
			*/
		}		
		
		
		
	}	
	
	
	
}