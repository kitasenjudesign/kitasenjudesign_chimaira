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
	private var _spaceY:Float = 0;
	private var _baseY:Float = 0;
	
	private var _rad:Float = 0;
	
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
		var scales:Array<Float> = _data.camData.scales;
		var ss:Float = _data.size;
		var yy:Float = _data.offsetY;
		
		//shokichi set
		//if (_modePos == MODE_POS_MOVE_Y) {
		//	ss = ss * 2;
		//}

		_spaceY = ss * 200;
		
		
		switch(posMode) {
			case MODE_POS_MOVE_Y:
				
				//toriaezu yaru
				for (i in 0..._faces.length) {
					
					if(i<5){
						var p:Vector3 = pos[0];
						
						_faces[i].scale.set(ss, ss, ss);
						_faces[i].position.x = p.x;
						_faces[i].position.y = p.y - _spaceY * (i-0.2);// - _spaceY;//0,1,2
						_faces[i].baseY = _faces[i].position.y;
						_faces[i].position.z = p.z;
					
						_faces[i].changeIndex(Math.floor(Math.random()*3));		
						_faces[i].visible = true;
						
					}else {
						_faces[i].visible = false;
						
					}
					
				}
				
				
			case MODE_POS_FIX:
				for (i in 0..._faces.length) {
			
					if (i < pos.length) {
						var p:Vector3 = pos[i];
						
						var s1:Float = scales[i];
						_faces[i].scale.set(ss*s1, ss*s1, ss*s1);
						
						_faces[i].position.x = p.x;
						_faces[i].position.y = p.y + yy;
						_faces[i].baseY = _faces[i].position.y;
						_faces[i].position.z = p.z;
						
						_faces[i].changeIndex(Math.floor(Math.random()*3));			
						_faces[i].visible = true;
						
					}else {
						
						_faces[i].visible = false;				
						
				}
			
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
				for(i in 0..._faces.length){
					//Y wa ugokasanai
					_faces[i].position.y = _faces[i].baseY + _data.offsetY * 0.1 * Math.cos(_rad*i*0.01 + i*0.02 );
				}
				_rad += Math.PI / 120;
				
				
			case MODE_POS_MOVE_Y:
				//y wo ugokasu		
				for(i in 0..._faces.length){
					
					//_data.offsetY
					
					_faces[i].position.y+=0.1;
					if (_faces[i].position.y > _spaceY * 5) {
						_faces[i].position.y = -_spaceY * 5;
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
					if ( a.subFreqByteData[3] > 6) {
						var s:Float = 0.5;
						_faces[i].addRot(
							s*(Math.random() - 0.5),
							s*(Math.random() - 0.5),
							s*(Math.random() - 0.5)
						);
					}
					_faces[i].rotation.y += 0.01;
				}
				
		}
	}

		
		

		
	
	
	
	
	
}