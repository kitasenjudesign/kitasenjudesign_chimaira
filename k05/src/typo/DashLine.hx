package typo;
import createjs.easeljs.Graphics;
import createjs.easeljs.Point;

/**
 * ...
 * @author nab
 */
class DashLine
{

			//GC
		public var graphics:Graphics;
		
		//破線のサイズ
		public var dashsize:Float;
		public var spacesize:Float;
		private var blocksize:Float;
		
		//前の点
		private var px:Float;
		private var py:Float;
		
		//描画し始める長さ
		private var draw_start:Float;
		private var _points:Array<Point>;
		
		/**
		* コンストラクタ
		*/
		public function new( g:Graphics, size:Float ){
			graphics = g;
			dashsize = spacesize = size;
			blocksize = dashsize + spacesize;
			px = py = 0;
			draw_start = 0.0;
		}
		
		
		/**
		* moveTo
		*/
		public function moveTo( x:Float, y:Float, offset:Float = 0 ):Void {
			_points = [];
			_moveTo(x, y);
			//初期化
			px = x;
			py = y;
			draw_start = offset%blocksize;
			if( draw_start<=-dashsize ){
				draw_start += blocksize;
			}
		}
		
		
		/**
		* lineTo
		*/
		public function lineTo( x:Float, y:Float ):Void{
			
			//ベクトル
			var v:Point = new Point( x-px, y-py );
			
			//描画長
			var length:Float = Math.sqrt(v.x * v.x + v.y * v.y);//v.length;
			
			if( draw_start>=length ){
				//空線中
				draw_start -= length;
				
			}else if( draw_start<0 && (dashsize + draw_start)>length ){
				//線分中
				graphics.lineTo( x, y );
				draw_start -= length;
				
			}else{
				//正規化
				//v.normalize(1.0);
				v.x = v.x / length;
				v.y = v.y / length;
				
				//破線描画単位
				var dx:Float = dashsize*v.x;
				var dy:Float = dashsize*v.y;
				
				//始点
				if( draw_start<0 ){
					//最初の線分の長さ
					var length0:Float = dashsize + draw_start;
					graphics.lineTo( px + length0*v.x, py + length0*v.y );
					draw_start += blocksize;
				}
				
				if( draw_start<length ){
					//破線
					var dx0:Float;
					var dy0:Float;
					var len:Float = draw_start;
					var draw_len:Float = length - blocksize;
					
					//for ( len = draw_start ; len < draw_len; len += blocksize ) {
					len = draw_start;
					while (true) {
						if (len >= draw_len) break;
						
						dx0 = px + len*v.x;
						dy0 = py + len * v.y;
						
						//graphics.drawCircle(dx0, dy0, 2);
						//graphics.moveTo( dx0, dy0 );
						_moveTo(dx0, dy0);
						graphics.lineTo( dx0 + dx, dy0 + dy );
						
						len += blocksize;
					}
					
					//終点
					dx0 = px + len*v.x;
					dy0 = py + len*v.y;
					var lastLen:Float = length - len;
					if( lastLen>dashsize ){
						//空線で終わる
						draw_start = blocksize - lastLen;
						lastLen = dashsize;
					}else{
						//破線途中で終わる
						draw_start = -lastLen;
					}
					//graphics.drawCircle(dx0, dy0, 2);
					//graphics.moveTo( dx0, dy0 );
					_moveTo(dx0, dy0);
					graphics.lineTo( dx0 + lastLen*v.x, dy0 + lastLen*v.y );
					
				}else{
					draw_start -= length;
				}
			}
			
			px = x;
			py = y;
			
			if(_points!=null)_points.push(new Point(x, y));

		}
		
		
		/**
		* curveTo
		*/
		public function curveTo( cx:Float, cy:Float, x:Float, y:Float ):Void{
			
			var bezje:Bezje2D = new Bezje2D( new Point(px, py), new Point(x, y), new Point(cx, cy));
			
			//描画長
			var length:Float = bezje.getLength();// length;
			
			if( draw_start>=length ){
				//空線中
				draw_start -= length;
				
			}else if( draw_start<0 && (dashsize + draw_start)>length ){
				//線分中
				graphics.curveTo( cx, cy, x, y );
				draw_start -= length;
				
			}else{
				
				//始点
				if( draw_start<0 ){
					//破線の途中
					var length0:Float = dashsize + draw_start;
					var t1:Float = bezje.length2T( length0, 0.1 );
					drawSegmentCurve( new Point(px,py), bezje.f(t1), bezje.diff(0), bezje.diff(t1) );
					draw_start += blocksize;
				}
				
				
				if( draw_start<length ){
					//終点
					var len:Float  = draw_start;
					var draw_len:Float = length - blocksize;
					
					//破線
					//for( len=draw_start; len<draw_len ; len+=blocksize ){
					len=draw_start;
					while (true) {
						if (length >= draw_len) break;
						drawCurve( bezje, len, len + dashsize );
						length += blocksize;
					}
					
					//終点
					var lastLen:Float = length - len;
					if( lastLen>dashsize ){
						//空線で終わる
						draw_start = blocksize - lastLen;
						drawCurve( bezje, len, len+dashsize );
					}else{
						//破線途中で終わる
						var t0:Float = bezje.length2T( len, 0.1 );
						var p0:Point  = bezje.f(t0);
						//graphics.moveTo( p0.x, p0.y );
						_moveTo(p0.x, p0.y);
						
						drawSegmentCurve( p0, new Point(x,y), bezje.diff(t0), bezje.diff(1.0) );
						draw_start = -lastLen;
					}
					
				}else{
					draw_start -= length;
				}
			}
			
			px = x;
			py = y;
			
			if(_points!=null)_points.push(new Point(x, y));
		}
		
		
		/**
		* 曲線の破線
		*/
		private function drawCurve( bezje:Bezje2D, len0:Float, len1:Float ):Void{
			var t0:Float = bezje.length2T( len0, 0.1 );
			var t1:Float = bezje.length2T( len1, 0.1 );
			var p0:Point  = bezje.f(t0);
			//graphics.moveTo( p0.x, p0.y );
			//_moveTo(p0.x, p0.y);
			
			drawSegmentCurve( p0, bezje.f(t1), bezje.diff(t0), bezje.diff(t1) );
		}
		
		
		/**
		* ベジェ曲線の分割曲線
		*/
		private function drawSegmentCurve(p0:Point, p1:Point, pv0:Point, pv1:Point):Void {
			
			//graphics.drawCircle(p0.x, p0.y, 2);
			//return;
			
			_moveTo(p1.x, p1.y);
			
			
			var dx:Float = p1.x-p0.x;
			var dy:Float = p1.y-p0.y;
			var a:Float;
			if( dx != 0 ){
				a = dx/(pv1.x+pv0.x);
				graphics.curveTo( p0.x + a*pv0.x, p0.y + a*pv0.y, p1.x, p1.y );
			}else if( dy != 0 ){
				a = dy/(pv1.y+pv0.y);
				graphics.curveTo( p0.x + a*pv0.x, p0.y + a*pv0.y, p1.x, p1.y );
			}
		}
		
		
		private function _moveTo(xx:Float, yy:Float):Void {
			//trace(graphics, _points);
			graphics.drawCircle(xx, yy, 2);
			graphics.moveTo( xx, yy );		
			if(_points!=null)_points.push(new Point(xx, yy));
				
		}
		
		public function getPoints():Array<Point> 
		{
			return _points;
		}
	
			
}