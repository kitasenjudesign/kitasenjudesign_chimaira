package objects.bg;
import js.html.Float32Array;
import sound.MyAudio;
import three.BufferAttribute;
import three.BufferGeometry;
import three.Geometry;
import three.Points;
import three.PointsMaterial;

/**
 * ...
 * @author watanabe
 */
class GridPoints extends Points
{

	
	public function new() 
	{

		var ww:Int = 100;
		var hh:Int = 1;
		var dd:Int = 100;
		
		var l:Int = ww * hh * dd;
		
		var space:Float = 50;
		var idx:Int = 0;
		
        var vertices:Float32Array = new Float32Array( l * 3 );
        for ( i in 0...ww) {
			for ( j in 0...hh) {
				for ( k in 0...dd) {
		    
					var i3:Int = idx * 3;
					var xx:Float = (k % 2) * space / 2;
					vertices[ i3 + 0 ] = (i - (ww - 1) / 2) * space + xx;
					vertices[ i3 + 1 ] = - j * space;// (j - (hh - 1) / 2) * space;
					vertices[ i3 + 2 ] = (k - (dd-1)/2) * space;
					idx++;
					
				}
			}
		}
       
		var g:BufferGeometry = new BufferGeometry();
			g.addAttribute( 'position',  new BufferAttribute( vertices, 3 ) );	
		
		var mat:PointsMaterial = new PointsMaterial( { size:1, color:0xffffff } );
		//mat.sizeAttenuation = false;
		
		super(cast g, mat);
		
		this.frustrumCulled = false;
		
	}
	
	
	/**
	 * 
	 * @param	a
	 */
	public function update(a:MyAudio):Void {
		
		
		
	}

	
}