package objects;
import sound.MyAudio;
import three.ImageUtils;
import three.MeshPhongMaterial;
import three.Texture;
import video.MovieData;

/**
 * ...
 * @author watanabe
 */
class Faces extends MatchMoveObects
{

	private var _faces		:Array<MyFaceSingle>;
	private var _material	:MeshPhongMaterial;
	private var _texture:Texture;
	
	public function new() 
	{
		
	}
	
	/**
	 * 
	 */
	override public function init():Void {

		_loader = new MyDAELoader();
		_loader.load(_onInit0);
		
	}
	
	private function _onInit0():Void{
		_texture = ImageUtils.loadTexture( Path.assets + "face/dede_face_diff.png" );
		_material = new MeshPhongMaterial( { color:0xffffff, map:_texture } );
		//_material.alphaMap = _texture;
		//_material.alphaTest = 0.5;
		//_material.transparent = true;
		_material.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 0.8 )];//
		_material.clipShadows = true;
		_material.side = Three.DoubleSide;		

		
		//faces
		_faces = [];
		
		for(i in 0...4){
			
			var face:MyFaceSingle = new MyFaceSingle(0);
			face.init( _loader, null );
			face.dae.material = _material;	
			face.dae.castShadow = true;
			
			var ss:Float = 40 + 10 * Math.random();
			face.dae.scale.set(ss, ss, ss);
			
			face.dae.position.x = 20 * (Math.random() - 0.5);
			face.dae.position.y = i * -250;
			face.dae.position.z = 20 * (Math.random() - 0.5);
			
			//face.dae.rotation.y = Math.random() * 2 * Math.PI;
			add(face.dae);
			_faces.push(face);
			
		}		
			
	}
	
	
	/**
	 * 
	 * @param	data
	 */
	public function show(data:MovieData):Void {
		_data = data;		
		this.visible = true;
		
		
	}	
	
	/**
	 * 
	 * @param	texture
	 */
	override public function setEnvMap(texture:Texture):Void
	{
		_material.envMap = texture;
		//if (_eyeball!=null) {
		//	untyped _eyeball.material.envMap = texture;	
		//}
	}		
	
	/**
	 * 
	 * @param	a
	 */
	override public function update(a:MyAudio):Void {
		
		if (!this.visible) return;
		
		
		if (_faces.length > 0) {
			
			for(i in 0..._faces.length){
				
				//_faces[i].dae.rotation.x += 0.001 + i / 2350;
				_faces[i].dae.rotation.y += 0.03 + i / 340;
				//_faces[i].dae.rotation.z += 0.0015 + i / 2300;
				
				_faces[i].updateSingle(a);
				_faces[i].dae.position.y += 0.4;
				if (_faces[i].dae.position.y > 500) {
					_faces[i].dae.position.y = -500;
					
					_faces[i].dae.rotation.set(0, Math.random() * 2 * Math.PI, 0);
					
					var ss:Float = 50 + 30 * Math.random();
					_faces[i].dae.scale.set(ss, ss, ss);
			
					_faces[i].changeIndex(i);
					//_faces[i]
				}
			}
		}		
	}	
	
	
	
}