package objects.objs;
import camera.ExCamera;
import materials.MaterialParams;
import materials.Textures;
import objects.objs.eye.Eye;
import objects.objs.eye.PrimitiveObj;
import objects.objs.line.HattoriLine;
import objects.objs.moji.MojiGeo;
import sound.MyAudio;
import three.BoxGeometry;
import three.Geometry;
import three.IcosahedronGeometry;
import three.Matrix4;
import three.Mesh;
import three.MeshPhongMaterial;
import three.OctahedronGeometry;
import three.Plane;
import three.SphereGeometry;
import three.TetrahedronGeometry;
import three.Texture;
import three.TorusGeometry;
import three.TorusKnotGeometry;
import three.Vector3;
import tween.TweenMax;
import tween.TweenMaxHaxe;
import video.MovieData;

/**
 * ...
 * @author watanabe
 */
class Primitives extends MatchMoveObects
{

	private var _meshes:Array<PrimitiveObj>;
	private var _rad:Float = 0;
	private var _line:HattoriLine;
	private var _material:MeshPhongMaterial;
	private var _count:Int = 0;
	private var _twn:TweenMaxHaxe;
	private var _matIndex:Int = 0;
	var _geoIndex:Int = 0;
	var _geos:Array<Geometry>;
	
	public function new() 
	{
		super();
	}

	
	override public function init():Void {
		
		_meshes = [];
		
		if (_geos == null) {
			
			var size:Float = 100;
			_geos = [
				new BoxGeometry(size,size,size,1,1,1),
				new TetrahedronGeometry(size/2),
				new TorusGeometry(size / 2, size / 4),
				new OctahedronGeometry(size/2)
				//new TorusKnotGeometry(size / 2, size / 4)
			];
			
		}
		
		
		_material = new MeshPhongMaterial( { color:0xffffff } );
		_material.shading = Three.FlatShading;
		_material.vertexColors = Three.VertexColors;
		_material.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 0.8 )];//
		_material.clipShadows = true;
		_material.side = Three.FrontSide;		
		
		for(i in 0...5){
			
			var obj:PrimitiveObj = new PrimitiveObj(_geos[0],_material);
			obj.position.y = 100;
			obj.rotation.x = -Math.PI / 2;
			obj.castShadow = true;
			_meshes.push(obj);
			add(obj);
			
		}		
		
	}
	
	

	/**
	 * show
	 * @param	data
	 */
	override public function show(data:MovieData):Void {
		
		_data = data;		
		this.visible = true;
		
		var pos:Array<Vector3> = _data.camData.positions;
		var ss:Float = _data.size;
		var yy:Float = _data.offsetY;
		_geoIndex++;
		var g:Geometry = _geos[_geoIndex % _geos.length];
		MojiGeo.changeColor( g );
		
		for (i in 0..._meshes.length) {
			
			if (i < pos.length) {
				
				var p:Vector3 = pos[i];
				_meshes[i].visible = true;
				_meshes[i].changeGeo(g, ss);
				//_meshes[i].scale.set(ss, ss, ss);
				_meshes[i].position.x = p.x;
				_meshes[i].position.y = p.y + yy;
				_meshes[i].position.z = p.z;
				
			}else {
				
				_meshes[i].visible = false;				
			}

		}		
		
		_changeMat();
		_move();
		
	}
	
	//changeMat wo kak
	private function _changeMat():Void {
		
		_matIndex++;
		MaterialParams.setParam3(_material, _matIndex % 4);
		
		//_currentGeo.updateColor();
		_material.needsUpdate = true;
		
	}	
		
	
	/**
	 * _move
	 */
	private function _move():Void {
		
		if (_twn != null)_twn.kill();
		
		var pos:Array<Vector3> = _data.camData.positions;
		var yy:Float = _data.offsetY;
		
		for (i in 0..._meshes.length) {
			var p:Vector3 = pos[ _count % pos.length ];
			_meshes[i].tween(p,yy, 0.3);
			_count++;
		}
		_twn = TweenMax.delayedCall(4, _move);
		
	}
	
	private function _onMove():Void {
		
	}
	
	
	
	override public function setEnvMap(texture:Texture):Void
	{
		if(_material!=null){
			_material.envMap = texture;
		}
		//if (_eyeball!=null) {
		//	untyped _eyeball.material.envMap = texture;	
		//}
	}		
	
	/**
	 * 
	 * @param	a
	 */
	override public function update(a:MyAudio):Void {
		
		_rad += 0.1;
		var camPos:Vector3 = Main3d.getCamera().position;

		for (i in 0..._meshes.length) {
			
			//_meshes[i].rotation.z += 0.03;
			_meshes[i].update(a);
			
		}
		
		//if (_line != null) {
		//	_line.update(a);
		//}
	}	
	
	override public function kill():Void {

		if (_twn != null)_twn.kill();

	}
	
	
	
}