package objects.objs.moji;
import sound.MyAudio;
import three.Geometry;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class MojiGeo
{

	public var geometry:Geometry;
	public var base:Array<Vector3>;
	
	public function new(g:Geometry) 
	{
		
	}

	public function init():Void {
		
	}
	
	
	public function update(a:MyAudio):Void {
		
		//
		var len:Int = geometry.vertices.length;
		for(i in 0...len){
			var v:Vector3 = geometry.vertices[i];
			var b:Vector3 = base[i];
			v.x = b.x + 10 * (Math.random() - 0.5);
			v.y = b.y + 10 * (Math.random() - 0.5);
			v.z = b.z + 10 * (Math.random() - 0.5); 
		}
	}
	
}