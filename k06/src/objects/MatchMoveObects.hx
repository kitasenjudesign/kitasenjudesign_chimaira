package objects;
import sound.MyAudio;
import three.Object3D;
import three.Texture;
import video.MovieData;

/**
 * ...
 * @author watanabe
 */
class MatchMoveObects extends Object3D
{

	private var _data:MovieData;
	
	public function new() 
	{
		super();
	}
	
	public function init():Void {
		
		
	}
	
	public function show(data:MovieData):Void {
		_data = data;		
		this.visible = true;
	}
	
	public function hide():Void {

		this.visible = false;		
		
	}
	
	
	public function setEnvMap(texture:Texture):Void
	{
		//_material.envMap = texture;
		//if (_eyeball!=null) {
		//	untyped _eyeball.material.envMap = texture;	
		//}
	}	
	
	
	public function update(a:MyAudio):Void {
		
		if ( ! this.visible ) {
			return;
		}
		//update
		
	}
	
	public function kill():Void {
		
		//kill
		
	}
	
}