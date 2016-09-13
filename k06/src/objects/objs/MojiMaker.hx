package objects.objs;
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
		if(dedemouse==null){
			dedemouse = getGeo("デデマウス");
			hexpixels = getGeo("ヘックスピクセルズ");
			kitasenju = getGeo("北千住デザイン");
			kimaira = getGeo("キマイラ");
			
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
	
	/**
	 * 
	 * @param	src
	 * @param	shape
	 * @return
	 */
	public static function getGeo(src:String):Geometry {
		
		var space:Float = 210;
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
		
		//color
		for (i in 0...g.vertices.length) {
			g.colors[i] = new Color(Math.floor(Math.random() * 0xffffff));
		}
		g.colorsNeedUpdate = true;
		
		return g;
	}
	
	/*
		var all:String = "デデマウス";
		// "は東京都足立区千住をベースに活動するデザイン集団です。";// 主にプログラミングを使った映像やグラフィックの研究・開発を行っています。そのほかホームページ制作・記事執筆・ロゴ制作・同人誌制作なども行っています。お問い合わせはツイッター@_nabeよりお願いたします。";
		//var all:String = "あけましておめでとうございます。今年もよろしくお願いします。";
		var list:Array<String> = [];
		var nn:Int = all.length;
		for (i in 0...Math.floor( all.length / nn+1 )) {
			list.push(all.substr(i * nn, nn));
		}
		
		var space:Float = 230;
		var spaceY:Float = 250;
		
		var g:Geometry = new Geometry();
		
		for (i in 0...list.length) {
			var src:String = list[i];
			for(j in 0...src.length){
			
				var shapes:Array<Shape> = _shape.getShapes(src.substr(j,1), true);
				var geo:ExtrudeGeometry = new ExtrudeGeometry(shapes, { bevelEnabled:true, amount:30 } );
				
				var mat4:Matrix4 = new Matrix4();
				mat4.multiply( new Matrix4().makeScale(2, 2, 2) );
				var vv:Vector3 = 
					new Vector3( 
						(j * space - (nn - 1) / 2 * space)*0.5, 
						(- i * spaceY)*0.5, 
						0
				);
				mat4.multiply( new Matrix4().makeTranslation(vv.x,vv.y,vv.z));
				g.merge(geo, mat4);
			
			}
		}
	
	
	*/
	
	
	
	
}