package objects.objs.line;
import sound.MyAudio;
import three.Geometry;
import three.LineSegments;
import three.Material;
import three.Object3D;

/**
 * ...
 * @author watanabe
 */
class GeoBase extends Object3D
{

	private var _geo	:Geometry;
	private var _base	:Geometry;	
	
	public function new() 
	{
		super();
	}
	
	
	public function init(base:Geometry,m:Material):Void {
		
		if (_base != null) return;
		
		_base = base;
		_geo = base.clone();
		
		//_line = new LineSegments(_geo, m);
		//add(_line);
		
	}	
	
	public function update(a:MyAudio):Void {
		
		//
		
	}
	
}