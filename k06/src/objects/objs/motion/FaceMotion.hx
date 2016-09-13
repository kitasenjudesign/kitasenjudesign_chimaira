package objects.objs.motion;
import sound.MyAudio;
import three.Vector3;
import video.MovieData;

/**
 * ...
 * @author watanabe
 */
class FaceMotion
{

	public static inline var MODE_ROT_Y:Int = 0;//y kaiten
	public static inline var MODE_ROT_XYZ:Int = 1;// xyz kaiten

	public static inline var MODE_POS_FIX:Int = 10;//fix
	public static inline var MODE_POS_MOVE_Y:Int = 11;//ugoku
	
	
	private var _faces:Array<MyFaceSingle>;
	
	private var _modeRot:Int = 0;
	private var _modePos:Int = 0;
	
	private var _data:MovieData;
	
	public function new() 
	{
		
	}
	
	/**
	 * 
	 * @param	faces
	 */
	public function init(faces:Array<MyFaceSingle>):Void {
		
		_faces = faces;
		
	}
	
	/**
	 * start
	 * @param	data
	 */
	public function start(data:MovieData,posMode:Int,rotMode:Int):Void {
		
		_data = data;
		_modeRot = rotMode;
		_modePos = posMode;
		
		var pos:Array<Vector3> = _data.camData.positions;
		var ss:Float = _data.size;
		var yy:Float = _data.offsetY;
		
		//shokichi set
		if (Math.random() < 0.1) {
			ss = ss * 2.2;
		}
		
		for (i in 0..._faces.length) {
			
			if (i < pos.length) {
				var p:Vector3 = pos[i];
				
				_faces[i].scale.set(ss, ss, ss);
				_faces[i].position.x = p.x;
				_faces[i].position.y = p.y + yy;
				_faces[i].position.z = p.z;
				_faces[i].changeIndex(i);		
				_faces[i].visible = true;
				
			}else {
				_faces[i].visible = false;				
				
			}
			
		}		
		
		for (i in 0..._faces.length) {
			//reset
			_faces[i].resetRot();
		}
		
		
	}
	

	/**
	 * 
	 * @param	a
	 */
	public function update(a:MyAudio):Void {
		
		for(i in 0..._faces.length){
			_faces[i].updateSingle(a);
		}		
		
		_updateRot(a);
		_updatePos(a);
		
	}
	
	/**
	 * _updateRot
	 * @param	a
	 */
	private function _updatePos(a:MyAudio):Void {
		
		//position
		switch( _modePos ) {
			
			case MODE_POS_FIX:
				//Y wa ugokasanai
				
				
			case MODE_POS_MOVE_Y:
				//y wo ugokasu		
				for(i in 0..._faces.length){
					
					_faces[i].position.y+=1;
					if (_faces[i].position.y > 500) {
						_faces[i].position.y = -500;
					}
					
				}
			
		}		
		
	}
	
	/**
	 * _updatePos
	 * @param	a
	 */
	private function _updateRot(a:MyAudio):Void {
		
		//rotation
		switch( _modeRot ) {
			
			case MODE_ROT_Y:
				//y dake rot
				for(i in 0..._faces.length){
					
					_faces[i].rotation.y += 0.03 + i / 340;
					
				}
				
			case MODE_ROT_XYZ:
				//xyz rot
				for(i in 0..._faces.length){
					//
					_faces[i].addRot(
						Math.pow( a.freqByteData[3] / 255, 3),
						Math.pow( a.freqByteData[2] / 255, 3),
						Math.pow( a.freqByteData[1] / 255, 3)
					);
					
				}
				
		}	
	}

		
		

		
	
	
	
	
	
}