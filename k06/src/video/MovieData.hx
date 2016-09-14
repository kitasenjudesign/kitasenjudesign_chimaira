package video;
import video.CameraData;

/**
 * ...
 * @author watanabe
 */
class MovieData
{

	public var id			:String;

	public var pathMov		:String;
	public var pathCam		:String;
	public var offsetFrame		:Int = 0;//frame
	
	public var camData	:CameraData;
	public var offsetY:Float = 0;
	public var size:Float = 0;
	
	public function new(o:Dynamic) 
	{
		if (o != null) {
			
			id = o.id;
			pathCam = o.cam;
			pathMov = o.mov;
			offsetFrame = o.offsetFrame;
			size = o.size;
			offsetY = o.y;
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