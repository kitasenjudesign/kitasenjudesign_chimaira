package video;
import video.CameraData;

/**
 * ...
 * @author watanabe
 */
class MovieData
{

	
	public var pathMov		:String;
	public var pathCam		:String;
	public var offset		:Int = 0;//frame
	
	public var camData	:CameraData;
	
	public function new(o:Dynamic) 
	{
		if (o != null) {
			
			pathCam = o.cam;
			pathMov = o.mov;
			offset = o.offset;
			//"cam":"mov/cam1.json",
			//"mov":"mov/01.mp4",
			//"offset":1
		}
	}
	
	public function loadCamData(callback:Void->Void):Void {
		
		if ( camData != null) {
			callback();
			return;
		}
		camData = new CameraData();
		camData.load(pathCam,callback);
	}
	
}