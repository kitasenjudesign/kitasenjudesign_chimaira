package objects.objs;
import common.Path;
import js.Browser;
import materials.MaterialParams;
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
		_material.side = Three.DoubleSide;
	
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
		
		
		//kokowo set
		
		var rotMode:Int = 0;
		var posMode:Int = 0;
		
		var n:Int = _count % 4;
		if ( _count < 5) {
			n = Math.floor(Math.random() * 2);
		}
		
		switch( n ) {
			case 0:
				posMode = FaceMotion.MODE_POS_MOVE_Y;
				rotMode = FaceMotion.MODE_ROT_Y;
			case 1:
				posMode = FaceMotion.MODE_POS_MOVE_Y;
				rotMode = FaceMotion.MODE_ROT_XYZ;				
			case 2:
				posMode = FaceMotion.MODE_POS_FIX;
				rotMode = FaceMotion.MODE_ROT_Y;			
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
		
		
		//3pattern
		_matIndex++;
		//_matIndex = _matIndex ;
		
		var n:Int = _matIndex% MAT_NUM;
		if (_matIndex < 5) {
			n = 0;
		}
		MaterialParams.setParam(_material, n);
		
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
		if ( _matIndex == MaterialParams.MAT_NET_RED ) {
			
			_offsetX += a.subFreqByteData[4] / 128 * 0.01;
			_offsetY += a.subFreqByteData[7] / 128 * 0.01;
			Textures.meshRed.offset.set(_offsetX, _offsetY);	
			Textures.moji1.offset.set(_offsetX, _offsetY);	
			
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