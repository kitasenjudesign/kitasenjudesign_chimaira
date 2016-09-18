package objects.objs.eye;
import sound.MyAudio;
import three.BoxGeometry;
import three.BoxGeometry;
import three.Geometry;
import three.IcosahedronGeometry;
import three.Mesh;
import three.MeshPhongMaterial;
import three.SphereGeometry;
import three.TetrahedronGeometry;
import three.Vector3;
import tween.TweenMax;
import tween.TweenMaxHaxe;

/**
 * ...
 * @author watanabe
 */
class PrimitiveObj extends Mesh
{

	public static inline var CUBE:Int = 0;
	public static inline var SPHERE:Int = 1;
	public static inline var TRI:Int = 2;
	
	private var _lookTarget	:Vector3;
	private var _rotV		:Vector3;
	private var _tween		:TweenMaxHaxe;
	private var _tgtRot		:Vector3;
	
	
	private static var _geos:Array<Geometry>;
	var _count:Int=0;
	var _scale:Float=1;
	/**
	 * 
	 * @param	g
	 * @param	m
	 */
	public function new(g:Geometry,m:MeshPhongMaterial) 
	{
		
		_tgtRot = new Vector3();
		_rotV = new Vector3();
		_lookTarget = new Vector3();
		
		
		
		super(g, m);
	}
	
	/**
	 * 
	 * @param	n
	 */
	public function changeGeo(g:Geometry,ss:Float):Void {
		
		this.geometry = g;// _geos[n % _geos.length];
		_scale = ss;
	}
	
	/**
	 * 
	 * @param	tgt
	 * @param	yy
	 * @param	time
	 */
	public function tween(tgt:Vector3,yy:Float,time:Float):Void {
		
		if (_tween != null) {
			_tween.kill();
		}
				
		_tween = TweenMax.to(this.position, time, {
			x:tgt.x,
			y:tgt.y + yy*0.2 + yy * 3 * Math.random(),
			z:tgt.z
		});
		
	}
	
	public function update(a:MyAudio):Void {
		
		
		
		_count++;
		if (a.subFreqByteData[3] > 8 && _count>15) {
			_count = 0;
			_tgtRot.x += (Math.random() < 0.5) ? Math.PI / 2 : -Math.PI / 2;
			_tgtRot.y += (Math.random() < 0.5) ? Math.PI / 2 : -Math.PI / 2;
			_tgtRot.z += (Math.random() < 0.5) ? Math.PI / 2 : -Math.PI / 2;
		}
		rotation.x += (_tgtRot.x - rotation.x) / 10;
		rotation.y += (_tgtRot.y - rotation.y) / 10;
		rotation.z += (_tgtRot.z - rotation.z) / 10;
		
		var ss:Float = _scale + Math.pow(a.subFreqByteData[5] / 255, 3) * 0.5;
		scale.set(ss,ss,ss);
		//kaiten
		//rotation.x += 0.001;
		//rotation.y += 0.0015;
		//rotation.z += 0.0003;
		
	}
	
	public function kill():Void {
		
		if (_tween != null) {
			_tween.kill();
		}
		
	}
	
}