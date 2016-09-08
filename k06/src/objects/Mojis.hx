package objects;

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
import video.VideoPlane;
import video.VideoPlayer;

/**
 * ...
 * @author watanabe
 */
class Mojis extends Object3D
{
	private var _shape:FontShapeMaker;
	private var _callback:Void->Void;
	//private var _mesh:Mesh;
	private var _material:MeshPhongMaterial;
	private var _meshes:Array<Mesh>;
	private var _loader:MyDAELoader;
	private var _face:Mesh;
	private var _rad:Float=0;
	private var _faces:Array<MyFaceSingle> = [];
	private var _videoPlane:VideoPlane;
	private var _texture:Texture;
	private var _offsetY:Float = 0;
	var _eyeball:Mesh;
	

	public function new() 
	{
		super();
	}
	
	/*
	 * 
	 * 
	 * 
	 */
	public function init(callback:Void->Void):Void {
		
		_callback = callback;
		_shape = new FontShapeMaker();
		_shape.init("AOTFProM4.json", _onInitA);
		
	}
	
	private function _onInitA():Void {
		//_onInit0();
		_loader = new MyDAELoader();
		_loader.load(_onInit0);
		
	}

	private function _onInit0():Void {
		
		var all:String = "北千住デザイン";
		// "は東京都足立区千住をベースに活動するデザイン集団です。";// 主にプログラミングを使った映像やグラフィックの研究・開発を行っています。そのほかホームページ制作・記事執筆・ロゴ制作・同人誌制作なども行っています。お問い合わせはツイッター@_nabeよりお願いたします。";
		//var all:String = "あけましておめでとうございます。今年もよろしくお願いします。";
		var list:Array<String> = [];
		var nn:Int = 8;
		for (i in 0...Math.floor( all.length / nn+1 )) {
			list.push(all.substr(i * nn, nn));
		}
		
		var space:Float = 200;
		var spaceY:Float = 250;
		
		var g:Geometry = new Geometry();
		
		for (i in 0...list.length) {
			var src:String = list[i];
			for(j in 0...src.length){
			
			var shapes:Array<Shape> = _shape.getShapes(src.substr(j,1), true);
			var geo:ExtrudeGeometry = new ExtrudeGeometry(shapes, { bevelEnabled:true, amount:50 } );
			
			var mat4:Matrix4 = new Matrix4();
			mat4.multiply( new Matrix4().makeScale(2, 2, 2) );
			var vv:Vector3 = 
				new Vector3( 
					(j * space - (nn - 1) / 2 * space)*0.5, 
					(- i * spaceY)*0.5, 
				0);
			mat4.multiply( new Matrix4().makeTranslation(vv.x,vv.y,vv.z));
			g.merge(geo, mat4);
			
			}
		}
		
		
		var p:Plane = new Plane(
			new Vector3( 0, 1, 0 ), 0.8 
		);
		
		_texture = ImageUtils.loadTexture( "mate3.png" );
		_texture.wrapS = Three.RepeatWrapping;
		_texture.wrapT = Three.RepeatWrapping;
		_texture.repeat.set(2, 2);
		
		_material = new MeshPhongMaterial( { color:0xffffff, map:_texture } );
		//_material.alphaMap = _texture;
		_material.alphaTest = 0.5;
		_material.transparent = true;
		_material.clippingPlanes = [p];
		_material.clipShadows = true;
		_material.side = Three.DoubleSide;
		
		
		_meshes = [];
		for(i in 0...4){
			var m:Mesh = new Mesh(g, _material);
			m.castShadow = true;
			//m.receiveShadow = true;
			var rr:Float = Math.random() * 0.1;
			m.scale.set(0.2 + rr, 0.2 + rr, 0.2 + rr);
			m.position.y += 60 * ( Math.random() - 0.5);
			//position.y = 100;
			//add(m);
			_meshes.push(m);
		}
		
		for(i in 0...4){
			
			var face:MyFaceSingle = new MyFaceSingle(0);
			face.init( _loader, null );
			face.dae.material = _material;	
			face.dae.castShadow = true;
			var ss:Float = 50 + 30 * Math.random();
			face.dae.scale.set(ss, ss, ss);
			
			face.dae.position.x = 20 * (Math.random() - 0.5);
			face.dae.position.y = i * -250;
			face.dae.position.z = 20 * (Math.random() - 0.5);
			
			face.dae.rotation.y = Math.random() * 2 * Math.PI;
			//add(face.dae);
			_faces.push(face);
			
		}
		
		
		var eyeMat:MeshPhongMaterial = _material.clone();
		eyeMat.map = ImageUtils.loadTexture( 		Path.assets + "eye/eye_color.jpg");
		eyeMat.normalMap = ImageUtils.loadTexture( 	Path.assets + "eye/eye_normal.png" );
		eyeMat.refractionRatio = 0.2;
		eyeMat.reflectivity = 0.2;
		//eyeMat.emissive = 0.5;
		
		//= new MeshPhongMaterial( { 
		//			map:ImageUtils.loadTexture( 		Path.assets + "eye/eye_color.jpg"), 
		//			normalMap:ImageUtils.loadTexture( 	Path.assets + "eye/eye_normal.png" ) 
		//	} );
		_eyeball = new Mesh(
			new SphereGeometry(100, 100, 10, 10),
			eyeMat
		);
		_eyeball.position.y = 120;
		add(_eyeball);
		
		/*
		var hoge:SkeltonLoader = new SkeltonLoader();
		hoge.load(null);
		add(hoge);*/
		
		//_videoPlane = new VideoPlane();
		//_videoPlane.init();
		//add( _videoPlane );
		/*
		var cube:Mesh = new Mesh(
			new BoxGeometry(400, 50, 50), 
			new MeshBasicMaterial( { color:0xffffff, wireframe:true,clippingPlanes:[p] } )
		);
		add(cube);*/
		
		if (_callback != null) {
			_callback();
		}
		
	}
	
	/**
	 * 
	 * @param	texture
	 */
	public function setEnvMap(texture:Texture) 
	{
		_material.envMap = texture;
		if (_eyeball!=null) {
			untyped _eyeball.material.envMap = texture;
			
		}
	}
	
	
	public function update(a:MyAudio):Void
	{
		
		//if (_videoPlane != null) {
		//	_videoPlane.update(vi);
		//}
		
		if (_texture != null) {
			_offsetY += 0.003;
			_texture.offset.set(0, _offsetY);
		}
		
		
		if (_eyeball != null) {
			_eyeball.rotation.x += 0.01;
			_eyeball.rotation.y += 0.015;
			_eyeball.rotation.z += 0.018;
		}
		
		if (_faces.length > 0) {
			
			for(i in 0..._faces.length){
				
				_faces[i].dae.rotation.x += 0.001 + i / 2350;
				_faces[i].dae.rotation.y += 0.03 + i / 340;
				_faces[i].dae.rotation.z += 0.0015 + i / 2300;
				
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
		
		for(i in 0..._meshes.length){
			_meshes[i].rotation.x += 0.001*(i+1); 
			_meshes[i].rotation.y += 0.003*(i+1);
			_meshes[i].rotation.z += 0.004*(i + 1);
			_meshes[i].position.y = 100 * Math.sin(_rad + Math.PI / 2) + i * 10;
		}
		//cube.rotation.x += 0.016;

	}
		
	
	
}