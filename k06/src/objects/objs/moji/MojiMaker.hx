package objects.objs.moji;
import three.Color;
import three.ExtrudeGeometry;
import three.Face;
import three.Face3;
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

	public static var dedemouse	:MojiGeo;
	public static var kitasenju	:MojiGeo;
	public static var hexpixels	:MojiGeo;
	public static var kimaira	:MojiGeo;
	public static var de		:MojiGeo;
	public static var mouse		:MojiGeo;
	
	private static var geos:Array<MojiGeo> = [];
	
	
	static private var _shape:FontShapeMaker;
	
	
	
	public function new() 
	{
		
	}

	public static function init(shape:FontShapeMaker):Void {	
		
		_shape = shape;
		if (dedemouse == null) {
			
			de = getGeometry("デ",6);			
			dedemouse = getGeometry("デデマウス");
			hexpixels = getGeometry("ヘックスピクセルズ",2,200);
			kitasenju = getGeometry("北千住デザイン");
			kimaira = getGeometry("キマイラ");
			
			mouse = new MojiGeo();
			mouse.init(Objs.geoMouse);
			mouse.updateColor();
			
			
			geos = [
				de,
				dedemouse,
				hexpixels,
				kitasenju,
				kimaira,
				mouse
			];
			
		}
	}
	
	
	
	
	public static function getRandomGeo():MojiGeo {
		
		
		return geos[ Math.floor(geos.length * Math.random()) ];
		
	}
	
	
	public static function getGeo(index:Int):MojiGeo {
		return geos[index % geos.length];
	}
	
	
	/**
	 * 
	 * @param	src
	 * @param	shape
	 * @return
	 */
	public static function getGeometry(src:String,scl:Float = 2,space:Float = 215):MojiGeo {
		
		//var space:Float = 215;
		var spaceY:Float = 250;//
		var nn:Int = src.length;
		var g:Geometry = new Geometry();
		
		for(j in 0...src.length){
			
				var amount:Float = 10;
				var shapes:Array<Shape> = _shape.getShapes(src.substr(j,1), true);
				var geo:ExtrudeGeometry = new ExtrudeGeometry(
						shapes, { bevelSize:1, bevelEnabled:true, amount:amount, bevelSegments:1 }
					);
				
				var mat4:Matrix4 = new Matrix4();
				mat4.multiply( new Matrix4().makeScale(scl, scl, scl) );
				var vv:Vector3 = 
					new Vector3( 
						(j * space - (nn - 1) / 2 * space)*0.5, 
						0,//(- i * spaceY)*0.5, 
						-amount/2
				);
				mat4.multiply( new Matrix4().makeTranslation(vv.x,vv.y,vv.z));
				g.merge(geo, mat4);
			
		}
		var geo:MojiGeo = new MojiGeo();
		geo.init(g);
		geo.updateColor();
		
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
		
		/*
		for ( i in 0...g.faces.length ) {

			//g.faces[i].color = new Color(Math.floor(Math.random() * 0xffffff));
			g.faces[i].color = new Color(Math.random() < 0.5 ? 0 : 0xffffff);
			
		}*/
		
		//updateColor(g);
		
		
		return geo;
	}
	

	
}