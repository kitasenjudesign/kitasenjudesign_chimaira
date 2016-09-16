package objects.objs.moji;
import sound.MyAudio;
import three.Geometry;
import three.Material;
import three.Mesh;
import three.Object3D;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class MojiMesh extends Mesh
{

	private var ovx:Float = 0;
	private var ovy:Float = 0;
	private var ovz:Float = 0;
	private var _targetV:Vector3 = new Vector3();
	private var _count:Float=0;

	private var idx1:Int = 0;
	private var idx2:Int = 0;
	private var idx3:Int = 0;
	
	
	public function new(g:Geometry,m:Material) 
	{
		super(g, m);
	}
	
	public function setGeo(g:Geometry):Void {
	
		idx1 = Math.floor(20 * Math.random());
		idx2 = Math.floor(20 * Math.random());
		idx3 = Math.floor(20 * Math.random());
		ovx = (Math.random() - 0.5) * 0.01;
		ovy = (Math.random() - 0.5) * 0.01;
		ovz = (Math.random() - 0.5) * 0.01;
		
		this.geometry = g;
		
		rotation.x = Math.random() * 2 * Math.PI;
		rotation.y = Math.random() * 2 * Math.PI;
		rotation.z = Math.random() * 2 * Math.PI;
		
	}
	
	
	
	public function update(a:MyAudio):Void {

		_count++;
		if( a.subFreqByteData[3] > 9 && _count>30 ){
		
			_count = 0;
			_targetV.x += a.subFreqByteData[idx1]/100;
			_targetV.y += a.subFreqByteData[idx2]/100;
			_targetV.z += a.subFreqByteData[idx3]/100;
			
			//limit
			if (_targetV.length() > Math.PI/5) {
				_targetV = _targetV.normalize();
				_targetV.x *= Math.PI/5;
				_targetV.y *= Math.PI/5;
				_targetV.z *= Math.PI/5;				
			}
			
		}
		
		_targetV.x *= 0.9;
		_targetV.y *= 0.9;
		_targetV.z *= 0.9;
		
		rotation.x += _targetV.x + ovx;
		rotation.y += _targetV.y + ovy;
		rotation.z += _targetV.z + ovz;
		
		
		//yukkuri ugoite kaiten
		
	}
	
}