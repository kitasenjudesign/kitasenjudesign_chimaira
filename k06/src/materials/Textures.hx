package materials;
import common.Path;
import three.ImageUtils;
import three.Texture;

/**
 * ...
 * @author watanabe
 */
class Textures
{

	public static var dedeColor:Texture;
	public static var meshMono:Texture;
	public static var meshRed:Texture;
	public static var colorWhite:Texture;
	
	public static var handColor:Texture;
	public static var handNormal:Texture;
	
	public static var eyeColor:Texture;
	public static var eyeNormal:Texture;
	
	public function new() 
	{
		
	}

	public static function init():Void {
		
		dedeColor 	= ImageUtils.loadTexture( Path.assets + "face/dede_face_diff.png" );
		
		meshMono	= ImageUtils.loadTexture( "mate.png" );
		meshMono.wrapS = Three.RepeatWrapping; 
		meshMono.wrapT = Three.RepeatWrapping; 
		meshMono.repeat.set(1, 1);
				
		meshRed		= ImageUtils.loadTexture( "mate3.png" );
		colorWhite	= ImageUtils.loadTexture( "color/white.png");
		
		handColor = ImageUtils.loadTexture("dae/hand_color.png");
		handNormal = ImageUtils.loadTexture("dae/hand_normal.png");
		
		handColor = ImageUtils.loadTexture("dae/hand_color.png");
		handNormal = ImageUtils.loadTexture("dae/hand_normal.png");
		
		eyeColor = ImageUtils.loadTexture( Path.assets + "eye/eye_color.jpg" );
		eyeColor.wrapS = Three.ClampToEdgeWrapping;
		eyeColor.wrapT = Three.ClampToEdgeWrapping;
		
		
		eyeNormal = ImageUtils.loadTexture( Path.assets + "eye/eye_normal.png");
		
	}
	
	
	
}