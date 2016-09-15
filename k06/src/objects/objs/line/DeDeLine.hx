package objects.objs.line;
import sound.MyAudio;
import three.Geometry;
import three.Line;
import three.LineSegments;
import three.Material;
import three.Object3D;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class DeDeLine extends GeoBase
{

	
	private var _count	:Int = 0;
	private var _line	:LineSegments;
	
	public function new() 
	{
		super();
	}
	
	override public function init(base:Geometry,m:Material):Void {
		
		if(_base==null){
			super.init(base, m);
			_line = new LineSegments(_geo, m);
			add(_line);
		}
		
	}
	
	/**
	 * update
	 * @param	a
	 */
	override public function update(a:MyAudio):Void {
		
		var len:Int = _base.vertices.length;
		
		_count++;
		_count = Math.floor( Math.pow(a.freqByteData[3] / 255, 3) * len );//_count % len;
		
		//
		for (i in 0...len) {
			
			var v:Vector3 = _geo.vertices[i];
			var b:Vector3 = _base.vertices[i];
			
			v.x = b.x + Math.pow(a.freqByteData[5] / 255, 2) * 500 * Math.random();//
			v.y = b.y + Math.pow(a.freqByteData[7] / 255, 2) * 500 * Math.random();//
			v.z = b.z * Math.pow(a.freqByteData[3] / 255, 2) * 100 * Math.random();//
			
		}
		_geo.verticesNeedUpdate = true;
		
	}
	
}