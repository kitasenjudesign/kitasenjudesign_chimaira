package objects.objs;

import common.Path;
import objects.MyDAELoader;
import objects.MyFaceSingle;
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
	private var _meshes:Array<Mesh>;
	private var _loader:MyDAELoader;
	private var _rad:Float=0;
	private var _videoPlane:VideoPlane;
	private var _texture:Texture;
	private var _offsetY:Float = 0;
	private var _eyeball:Mesh;
	

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
		// "は東京都足立区千住をベースに活動するデザイン集団です。";// 主にプログラミングを使った映像やグラフィックの研究・開発を行っています。そのほかホームページ制作・記事執筆・ロゴ制作・同人誌制作なども行っています。お問い合わせはツイッター@_nabeよりお願いたします。";
		//var all:String = "あけましておめでとうございます。今年もよろしくお願いします。";
		var list:Array<String> = [];
		var nn:Int = all.length;
		for (i in 0...Math.floor( all.length / nn+1 )) {
			list.push(all.substr(i * nn, nn));
		}
		
		var space:Float = 230;
		var spaceY:Float = 250;
		
		var g:Geometry = new Geometry();
		
		for (i in 0...list.length) {
			var src:String = list[i];
			for(j in 0...src.length){
			
				var shapes:Array<Shape> = _shape.getShapes(src.substr(j,1), true);
				var geo:ExtrudeGeometry = new ExtrudeGeometry(shapes, { bevelEnabled:true, amount:30 } );
				
				var mat4:Matrix4 = new Matrix4();
				mat4.multiply( new Matrix4().makeScale(2, 2, 2) );
				var vv:Vector3 = 
					new Vector3( 
						(j * space - (nn - 1) / 2 * space)*0.5, 
						(- i * spaceY)*0.5, 
						0
				);
				mat4.multiply( new Matrix4().makeTranslation(vv.x,vv.y,vv.z));
				g.merge(geo, mat4);
			
			}
		}
		
		////material
		//_texture = ImageUtils.loadTexture( Path.assets + "face/dede_face_diff.png" );
		_material = new MeshPhongMaterial( { color:0xffffff } );
		//_material.wireframe = true;
		//_material.alphaMap = _texture;
		//_material.alphaTest = 0.5;
		//_material.transparent = true;
		_material.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 0.8 )];//
		_material.clipShadows = true;
		_material.side = Three.FrontSide;		
		
		_meshes = [];
		
		for (i in 0...5) {
			var m:Mesh = new Mesh(g, _material);
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
			_meshes[i].rotation.x += 0.001*(i+1); 
			_meshes[i].rotation.y += 0.003*(i+1);
			_meshes[i].rotation.z += 0.004*(i + 1);
		}
		//cube.rotation.x += 0.016;

	}
		
	

	
}