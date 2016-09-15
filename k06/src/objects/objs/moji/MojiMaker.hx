package objects.objs.moji;
import three.Color;
import three.ExtrudeGeometry;
import three.Geometry;
import three.Matrix4;
import three.Shape;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class MojiMaker
{

	public static var dedemouse:Geometry;
	public static var kitasenju:Geometry;
	public static var hexpixels:Geometry;
	public static var kimaira:Geometry;
	
	private static var geos:Array<Geometry> = [];
	
	
	static private var _shape:FontShapeMaker;
	
	
	
	public function new() 
	{
		
	}

	public static function init(shape:FontShapeMaker):Void {	
		
		_shape = shape;
		if (dedemouse == null) {
			
			dedemouse = getGeometry("デデマウス");
			hexpixels = getGeometry("ヘックスピクセルズ");
			kitasenju = getGeometry("北千住デザイン");
			kimaira = getGeometry("キマイラ");
			
			geos = [
				dedemouse,
				hexpixels,
				kitasenju,
				kimaira
			];
			
		}
	}
	
	
	public static function getRandomGeo():Geometry {
		
		
		return geos[ Math.floor(geos.length * Math.random()) ];
		
	}
	
	
	public static function getGeo(index:Int):Geometry {
		return geos[index];
	}
	
	
	/**
	 * 
	 * @param	src
	 * @param	shape
	 * @return
	 */
	public static function getGeometry(src:String):Geometry {
		
		var space:Float = 215;
		var spaceY:Float = 250;//
		var nn:Int = src.length;
		var g:Geometry = new Geometry();
		
		for(j in 0...src.length){
			
				var shapes:Array<Shape> = _shape.getShapes(src.substr(j,1), true);
				var geo:ExtrudeGeometry = new ExtrudeGeometry(shapes, { bevelEnabled:true, amount:30 } );
				
				var mat4:Matrix4 = new Matrix4();
				mat4.multiply( new Matrix4().makeScale(2, 2, 2) );
				var vv:Vector3 = 
					new Vector3( 
						(j * space - (nn - 1) / 2 * space)*0.5, 
						0,//(- i * spaceY)*0.5, 
						0
				);
				mat4.multiply( new Matrix4().makeTranslation(vv.x,vv.y,vv.z));
				g.merge(geo, mat4);
			
		}
		
		/*
		for (i in 0...g.vertices.length) {
			
			g.vertices[i].x = g.vertices[i].x + 10 * (Math.random() - 0.5);
			g.vertices[i].y = g.vertices[i].y + 10 * (Math.random() - 0.5);
			g.vertices[i].z = g.vertices[i].z + 10 * (Math.random() - 0.5);
			
		}*/
		
		//color
		/*
		for (i in 0...g.vertices.length) {
			g.colors[i] = new Color(Math.floor(Math.random() * 0xffffff));
		}
		g.colorsNeedUpdate = true;
		*/
		
		return g;
	}
	
	
	
	
}