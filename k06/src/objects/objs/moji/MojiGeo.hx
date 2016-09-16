package objects.objs.moji;
import objects.objs.line.GeoBase;
import sound.MyAudio;
import three.Color;
import three.Face;
import three.Face3;
import three.Geometry;
import three.Line;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class MojiGeo 
{

	private var _base:Geometry;
	
	private var baseAmp:Array<Float> = [];
	private var baseRadX:Array<Float> = [];
	private var baseRadY:Array<Float> = [];
	private var _count:Int = 0;
	
	public var geo:Geometry;//now

	public function new() 
	{
		
	}
	
	/**
	 * 
	 * @param	base
	 * @param	m
	 */
	public function init(base:Geometry):Void {
		
		_base = base;
		geo = _base.clone();
		
		for (i in 0...geo.vertices.length) {
			
			var vv:Vector3 = geo.vertices[i].clone();
			var a:Float = vv.length();
			baseAmp.push( a );
			baseRadX.push( -Math.atan2(vv.z, vv.x) + Math.PI*0.5 );
			baseRadY.push( Math.asin(vv.y / a) );	
			
		}
		
		/*
		float a = length(vv);
	float radX = (-atan(vv.z, vv.x) + PI * 0.5) + vv.y * sin(_count) * nejireX;//横方向の角度
	float radY = asin(vv.y / a);
	vec3 hoge = vec3(0.0);
		hoge.x = amp * sin( radX ) * cos(radY) + zengo;//横
		hoge.y = amp * sin( radY ) * tate;//縦
		hoge.z = amp * cos( radX ) * cos(radY) + yoko;//横			
		*/
	}
	
	/**
	 * update
	 * @param	a
	 */
	public function update(a:MyAudio):Void {
		
		//tekitou
		
		_count++;
		//_count = _count % 10;
		
		//_updatePolar();
		_updateZ(a);
		
		geo.verticesNeedUpdate = true;		
		
		
		
	}	
	
	private function _updatePolar(a:MyAudio):Void {
		
		//polar wo update
		var len:Int = _base.vertices.length;
		for (i in 0...len) {
			
			var v:Vector3 = geo.vertices[i];
			var base:Vector3 = _base.vertices[i];
			
			if(_count%10==0){
				//v.x = base.x + Math.pow(a.freqByteData[5] / 255, 2) * 1200 * Math.random();//
				//v.y = base.y + Math.pow(a.freqByteData[7] / 255, 2) * 1200 * Math.random();//
				//v.z = base.z + base.z * Math.pow(a.freqByteData[3] / 255, 2) * 30 * Math.random();//
				var amp:Float = baseAmp[i] + 300 * Math.random() * a.freqByteData[3] / 255;
				var radX:Float = baseRadX[i];
				var radY:Float = baseRadY[i];
				
				v.x = amp * Math.sin( radX ) * Math.cos(radY);
				v.y = amp * Math.sin( radY );//縦
				v.z = amp * Math.cos( radX ) * Math.cos(radY);
				
				//var tgtX:Float = amp * Math.sin( radX ) * Math.cos(radY) + zengo;//横
				//var tgtY:Float = amp * Math.sin( radY );//縦
				//var tgtZ:Float = amp * Math.cos( radX ) * Math.cos(radY) + yoko;//横	
			}else{
				v.x += ( base.x - v.x )/2;
				v.y += ( base.y - v.y )/2;
				v.z += ( base.z - v.z )/2;			
			}
				
		}		
		
	}
	
	/**
	 * 
	 * @param	a
	 */
	private function _updateZ(a:MyAudio):Void {
		
		//polar wo update
		var len:Int = _base.vertices.length;
		for (i in 0...len) {
			
			var v:Vector3 = geo.vertices[i];
			var base:Vector3 = _base.vertices[i];
			
			if(i%10==0){
				v.x = base.x + 100 * (Math.random() - 0.5);// + Math.pow(a.freqByteData[5] / 255, 2) * 1200 * Math.random();//
				v.y = base.y + 100 * (Math.random() - 0.5);// + Math.pow(a.freqByteData[7] / 255, 2) * 1200 * Math.random();//
			}
			v.z = base.z + base.z * Math.pow(a.freqByteData[3] / 255, 2) * 30 * Math.random();//
			
			//var tgtX:Float = amp * Math.sin( radX ) * Math.cos(radY) + zengo;//横
			//var tgtY:Float = amp * Math.sin( radY );//縦
			//var tgtZ:Float = amp * Math.cos( radX ) * Math.cos(radY) + yoko;//横	
			//}else{
			//	v.x += ( base.x - v.x )/2;
			//	v.y += ( base.y - v.y )/2;
			//	v.z += ( base.z - v.z )/2;			
			//}
				
		}	
		
	}
	
	/**
	 * updateColor
	 * @param	g
	 */
	public static function updateColor(g:Geometry):Void {
		
		var faceIndices:Array<String> = [ 'a', 'b', 'c', 'd' ];
		for ( i in 0...g.faces.length ) {
	
			var face:Face  = g.faces[ i ];	
			// determine if current face is a tri or a quad
			var numberOfSides:Int  = Std.is( face, Face3 ) ? 3 : 4;
			// assign color to each vertex of current face
			for( j in 0...numberOfSides ) 
			{
				//var vertexIndex = face[ faceIndices[ j ] ];
				// initialize color variable
				var color:Color = new Color( 0xffffff );
				color.setHex( Math.floor( Math.random() * 0xffffff ) );
				face.vertexColors[ j ] = color;
			}
			
		}
		g.colorsNeedUpdate = true;
		
	}
		
	
	
}