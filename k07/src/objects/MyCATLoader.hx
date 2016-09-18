package objects ;
import camera.ExCamera;
import haxe.Json;
import js.Browser;
import js.html.Blob;
import sound.MyAudio;
import three.CubeCamera;
import three.Geometry;
import three.ImageUtils;
import three.Material;
import three.Matrix4;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshPhongMaterial;
import three.Object3D;
import three.Vector3;
/**
 * ...
 * @author nab
 */
class MyCATLoader extends MyDAELoader
{
	
	//private var _callback:Void->Void;
	//private var _cubecamera:CubeCamera;
	public var mesh:Mesh;
	
	//public var dae:Object3D;
	public var geo:Geometry;
	public var mat:MeshBasicMaterial;
	//public var baseGeo:Array<Vector3>;
	
	
	public function new() 
	{
		super();
	}

	override public function load(filename:String,callback:Void->Void):Void {
		
		_callback = callback;
		var loader = untyped __js__("new THREE.ColladaLoader()");
		loader.options.convertUpAxis = true;		
		//loader.load( 'cat/test_cat.dae', _onComplete );
		loader.load( filename, _onComplete );
		
	}
	
	
	
	override private function _onComplete(ret):Void 
	{
		
		var dae:Dynamic = ret.scene;
		var mm:MeshBasicMaterial = new MeshBasicMaterial({
		
		//var mm:MeshPhongMaterial = new MeshPhongMaterial({
			map :			ImageUtils.loadTexture( "./cat/cat_diff.jpg"),
			//specularMap:	ImageUtils.loadTexture( "./cat/cat_norm.jpg"),
			//normalMap: 		ImageUtils.loadTexture( "./cat/cat_spec.jpg"),
			skinning : false,
			depthWrite: true,
			depthTest: true
		});
		mm.shading = Three.SmoothShading;
		mm.alphaTest = 0.9;
		//mm.shininess = 1;// shiness = 0;
		
		
		mesh = null;
		
		untyped __js__("
			var hoge = this;
			dae.traverse( function(child){
				if( child instanceof THREE.Mesh){
					child.material = mm;
					hoge.mesh = child;
					//alert('hoge ' + child);
					//mm.specular.set(0,0,0);
				}
			});
		");
			
		
		if(mesh!=null){
			mesh.scale.set(100, 100, 100);
			//add(cast mesh);
		}
		
		geo = mesh.geometry.clone();
		
		var m4:Matrix4 = new Matrix4();
		//m4.makeRotationX(Math.PI / 3);
		//m4.makeRotationZ(Math.PI / 2);
		
		geo.applyMatrix(m4);
		geo.verticesNeedUpdate = true;
		
		mat = cast mesh.material;


		//add(dae);	
		
		baseGeo = [];
		for (i in 0...geo.vertices.length) {
			var vec:Vector3 = new Vector3( geo.vertices[i].x*4, geo.vertices[i].y*4, geo.vertices[i].z*4);
			baseGeo.push( vec );
		}
		
		this.geometry = geo;
		this.material = mm;
		
		if (_callback != null) {
			_callback();
		}
		
		//dispatchEvent(new Event("COMPLETE", true, true));
	}
	
	
	
	
	
	
}