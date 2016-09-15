package video;
import js.html.VideoElement;
import three.Mesh;
import three.PlaneBufferGeometry;

/**
 * ...
 * @author watanabe
 */
class VideoPlane extends Mesh
{

	private var _geo	:PlaneBufferGeometry;
	private var _mat	:VideoShader;
	private var _vi:VideoElement;
	
	public function new() 
	{
		_geo = new PlaneBufferGeometry(2, 2, 10, 10);
		_mat = new VideoShader();
		
		super(
			cast _geo, _mat
		);
	
		this.frustumCulled = false;
		
		//hide();
	}
	
	public function init(vi:VideoElement):Void {
		_vi = vi;
	}
	
	public function show():Void {
		frustumCulled = false;
		visible = true;		
	}
	
	public function hide():Void {
		frustumCulled = true;
		visible = false;		
	}
	
	public function update():Void {
		
		if (!visible) return;
		
		_mat.update(_vi);
		
	}
	
}