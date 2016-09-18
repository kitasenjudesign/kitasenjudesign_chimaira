package objects.objs.eye;
import camera.ExCamera;
import sound.MyAudio;
import three.Geometry;
import three.Matrix4;
import three.Mesh;
import three.MeshPhongMaterial;
import three.Vector3;
import tween.TweenMax;
import tween.TweenMaxHaxe;

/**
 * ...
 * @author watanabe
 */
class Eye extends Mesh
{

	private var _lookTarget:Vector3;
	private var _rotV:Vector3;
	
	private var _tween:TweenMaxHaxe;
	/**
	 * 
	 * @param	g
	 * @param	m
	 */
	public function new(g:Geometry, m:MeshPhongMaterial) 
	{
		super(g, m);
		_rotV = new Vector3();
		_lookTarget = new Vector3();
	}
	
	
	public function tween(tgt:Vector3,yy:Float,time:Float):Void {
		
		if (_tween != null) {
			_tween.kill();
		}
				
		_tween = TweenMax.to(this.position, time, {
			x:tgt.x,
			y:tgt.y + yy * 4 * Math.random(),
			z:tgt.z
		});
		
	}
	
	public function update(a:MyAudio):Void {
		
		//dounikasuru
		
	}
	
	public function kill():Void {
		
		if (_tween != null) {
			_tween.kill();
		}
		
	}
	
	/**
	 * look
	 * @param	lookTarget
	 * @param	audio
	 */
	public function look(lookTarget:Vector3,audio:MyAudio):Void
	{
		
		if ( Math.pow(audio.freqByteData[4]/255,2) > 0.3 ) {

			_rotV.x += (Math.random() - 0.5) * 0.1;
			_rotV.y += (Math.random() - 0.5) * 0.1;
			_rotV.z += (Math.random() - 0.5) * 0.1;
			this.rotation.x += _rotV.x;
			this.rotation.y += _rotV.y; 
			this.rotation.z += _rotV.z;
			_rotV.x *= 0.9;
			_rotV.y *= 0.9;
			_rotV.z *= 0.9;
			
		}else{
		
			_lookTarget.x += (lookTarget.x - _lookTarget.x) / 4;
			_lookTarget.y += (lookTarget.y - _lookTarget.y) / 4;
			_lookTarget.z += (lookTarget.z - _lookTarget.z) / 4;
			this.lookAt(_lookTarget);
		}
	}
	
}