package objects.objs.line;
import sound.MyAudio;
import three.Geometry;
import three.Line;
import three.Material;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class HattoriLine extends GeoBase
{
	
	private var _line:Line;

	public function new() 
	{
		super();
	}
	
	/**
	 * 
	 * @param	base
	 * @param	m
	 */
	override public function init(base:Geometry,m:Material):Void {
		
		if(_base==null){
			super.init(base, m);
			_line = new Line(_geo, m);
			add(_line);
		}
		
	}
	
	/**
	 * update
	 * @param	a
	 */
	override public function update(a:MyAudio):Void {
		
		var len:Int = _base.vertices.length;
		
		for (i in 0...len) {
			
			var v:Vector3 = _geo.vertices[i];
			var base:Vector3 = _base.vertices[ Math.floor(Math.random() * len) ];
			base.y = 100 * Math.random();
			v.copy( base );
			
		}
		_geo.verticesNeedUpdate = true;
		
		
		
	}	
	
	
}