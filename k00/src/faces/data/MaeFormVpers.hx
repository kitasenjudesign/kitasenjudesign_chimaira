package faces.data;
import js.Browser;

/**
 * ...
 * @author watanabe
 */
class MaeFormVpers extends MaeFormBase
{
	private var _cams:Array<CamData> = [
		new CamData(255, 0, 0 ),//0
		new CamData(255, 0, 0 ),//1
		new CamData(255, 0, 0 ),//2
		
		new CamData(255, 0, 0 ),//3
		new CamData(255, 0, 0 ),//4
		new CamData(255, -0.73, -0.1 ),//5
		
		new CamData(255, 0, 0 ),//3
		new CamData(255, 0, 0 ),//4
		new CamData(255, 0.63, -0.1 )//5
		
	];
	
	public function new() 
	{
		super();
	}
	
	//http://www20.atpages.jp/katwat/three.js/examples/mytest2/menu.html
	
	
	override public function setFormation(faces:Array<MaeFace>):Void
	{
		_faces = faces;
		
		//30zutsu
		//var rotMode:Int = MaeFaceMesh.getRandomRot();
		var rotMode:Int = (_camIndex==0) ? MaeFaceMesh.ROT_MODE_X : MaeFaceMesh.getRandomRot();
		_setRot(rotMode);
		
		var data:CamData = _cams[_camIndex % _cams.length];
		_camIndex++;
		_camera.amp = data.amp;
		_camera.radX = data.radX;
		_camera.radY = data.radY;
		
		_camera.setFOV(45);//
		
		var spaceX:Float = 60;
		var spaceY:Float = 60;
		var xnum:Int = 9;
		var ynum:Int = 8;
		var num:Int = xnum * ynum;
		_width = spaceX * xnum;
		_height = spaceY * (ynum);
		
		var len:Int = _faces.length;
		var oz:Float = -200;
		
		//random
		if ( (_camIndex-1)%3 == 2 ) {
			//Browser.window.alert("random");
			for (i in 0...len) {
				var ff:MaeFace = _faces[i];
					ff.enabled = true;
					ff.visible = true;
					
					ff.position.x = 800*(Math.random()-0.5); 
					ff.position.y = _height * (Math.random() -0.5);
					ff.position.z = _height	* (Math.random() -0.5);
					
					ff.rotation.y = 0;
			}
			
			return;
		}
		
		
		for (i in 0...len) {
			var ff:MaeFace = _faces[i];
			ff.enabled = true;
			ff.visible = true;
			
			if (i < num) {
				var idx:Int = i;
				var xx:Float = idx % xnum - (xnum-1)/2;
				var yy:Float = Math.floor(idx / xnum) - (ynum - 1) / 2;
				
				ff.position.x = 150; 
				ff.position.y = yy * spaceX;
				ff.position.z = xx * spaceY + oz;
				
				ff.rotation.y = -Math.PI/2;
			}else if(i<num*2){
				var idx:Int = i - num;
				var xx:Float = idx % xnum - (xnum-1)/2;
				var yy:Float = Math.floor(idx / xnum) - (ynum - 1) / 2;
				
				ff.position.x = -150;
				ff.position.y = yy * spaceX;
				ff.position.z = xx * spaceY + oz;		
				ff.rotation.y = Math.PI/2;
			}else {
				ff.enabled = false;
				ff.visible = false;				
				
			}
			//30ko zutsu			
		}
	}		
	
	override public function update():Void {
		//yy houkou
		for ( i in 0..._faces.length) {
			_faces[i].position.y += 0.25;
			if ( _faces[i].position.y > _height/2) {
				_faces[i].position.y = -_height / 2;
				_faces[i].updatePlate();
			}						
		}		
	}	
	
}