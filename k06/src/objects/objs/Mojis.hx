package objects.objs;

import common.Path;
import materials.MyPhongMaterial;
import materials.Textures;
import objects.MyDAELoader;
import objects.MyFaceSingle;
import objects.objs.moji.MojiMaker;
import objects.objs.moji.MojiMesh;
import sound.MyAudio;
import three.ExtrudeGeometry;
import three.Geometry;
import three.ImageUtils;
import three.Matrix4;
import three.Mesh;
import three.MeshPhongMaterial;
import three.Object3D;
import three.Plane;
import three.Shape;
import three.SphereGeometry;
import three.Texture;
import three.Vector3;
import three.WebGLShaders.ShaderLib;
import video.MovieData;
import video.VideoPlane;

/**
 * ...
 * @author watanabe
 */
class Mojis extends MatchMoveObects
{
	private var _shape:FontShapeMaker;
	//private var _callback:Void->Void;
	//private var _mesh:Mesh;
	private var _material:MeshPhongMaterial;
	private var _meshes:Array<MojiMesh>;
	private var _loader:MyDAELoader;
	private var _rad:Float=0;
	private var _videoPlane:VideoPlane;
	private var _texture:Texture;
	private var _offsetY:Float = 0;
	private var _eyeball:Mesh;
	private var _index:Int = 0;
	private var _getIndex:Int = 0;

	public function new() 
	{
		super();
	}
	
	/*
	 * 
	 */
	override public function init():Void {
		
		_shape = new FontShapeMaker();
		_shape.init("AOTFProM3.json", _onInitA);
		
	}
	
	private function _onInitA():Void {
		//_onInit0();
		_loader = new MyDAELoader();
		_loader.load(_onInit0);
		
	}

	private function _onInit0():Void {
		
		var all:String = "デデマウス";
		
		MojiMaker.init(_shape);
		var g:Geometry = MojiMaker.hexpixels;
		
		
		
		////material
		//_texture = ImageUtils.loadTexture( Path.assets + "face/dede_face_diff.png" );
		_material = new MeshPhongMaterial( { color:0xffffff } );
		//cast new MyPhongMaterial(null);//
		//_material.vertexColors = true;
		//_material.map = Textures.meshRed;
		//_material.wireframe = true;
		//_material.alphaMap = _texture;
		//_material.alphaTest = 0.5;
		//_material.transparent = true;
		
		_material.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 0.8 )];//
		_material.clipShadows = true;
		_material.side = Three.FrontSide;		
		
		_meshes = [];
		
		for (i in 0...5) {
			var m:MojiMesh = new MojiMesh(g, _material);
			
			m.scale.set(0.1, 0.1, 0.1);
			m.castShadow = true;
			add(m);
			_meshes.push(m);			
		}
		
		
	}
	
	/**
	 * 
	 * @param	data
	 */
	override public function show(data:MovieData):Void {
		_data = data;		
		this.visible = true;
		
		
		var pos:Array<Vector3> = _data.camData.positions;
		var ss:Float = _data.size;
		var yy:Float = _data.offsetY;
		
		for (i in 0..._meshes.length) {
			
			if (i < pos.length) {
				var p:Vector3 = pos[i];
				_meshes[i].visible = true;
				_meshes[i].setGeo( MojiMaker.getGeo(_getIndex) );
				//_meshes[i].geometry = MojiMaker.getGeo(_getIndex);
				_meshes[i].scale.set(0.2, 0.2, 0.2);
				_meshes[i].position.x = p.x;
				_meshes[i].position.y = p.y + yy;
				_meshes[i].position.z = p.z;
				
			}else {
				_meshes[i].visible = false;				
			}

			
		}		
	}
	
	/**
	 * 
	 * @param	texture
	 */
	override public function setEnvMap(texture:Texture) 
	{
		_material.envMap = texture;
		//if (_eyeball!=null) {
		//	untyped _eyeball.material.envMap = texture;
		//}
	}
	
	
	override public function update(a:MyAudio):Void
	{
		
		//if (_videoPlane != null) {
		//	_videoPlane.update(vi);
		//}
		
		if (_texture != null) {
			//_offsetY += 0.003;
			//_texture.offset.set(0, _offsetY);
		}
		
		
		for(i in 0..._meshes.length){
			//_meshes[i].rotation.x += 0.001*(i+1); 
			//_meshes[i].rotation.y += 0.003*(i+1);
			//_meshes[i].rotation.z += 0.004 * (i + 1);
			_meshes[i].update(a);
			
		}
		//cube.rotation.x += 0.016;

	}
		
	

	
}