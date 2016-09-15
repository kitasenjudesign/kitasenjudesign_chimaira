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
	
	public static var moji1:Texture;
	
	public static var parkBg:Texture;
	
	public function new() 
	{
		
	}

	public static function init():Void {
		
		dedeColor 	= ImageUtils.loadTexture( Path.assets + "face/dede_face_diff.png" );
		
		meshMono	= ImageUtils.loadTexture( "mate.png" );
		meshMono.wrapS = Three.MirroredRepeatWrapping; 
		meshMono.wrapT = Three.MirroredRepeatWrapping; 
		meshMono.repeat.set(5, 5);
				
		meshRed		= ImageUtils.loadTexture( "mate3.png" );
		meshRed.wrapS = Three.MirroredRepeatWrapping; 
		meshRed.wrapT = Three.MirroredRepeatWrapping; 
		meshRed.repeat.set(1.5, 1.5);		
		
		colorWhite	= ImageUtils.loadTexture( "color/white.png");
		
		handColor = ImageUtils.loadTexture("dae/hand_color.png");
		handNormal = ImageUtils.loadTexture("dae/hand_normal.png");
		
		handColor = ImageUtils.loadTexture("dae/hand_color.png");
		handNormal = ImageUtils.loadTexture("dae/hand_normal.png");
		
		eyeColor = ImageUtils.loadTexture( Path.assets + "eye/eye_color2.png" );
		//eyeColor.wrapS = Three.ClampToEdgeWrapping;
		//eyeColor.wrapT = Three.ClampToEdgeWrapping;
		meshMono.wrapS = Three.MirroredRepeatWrapping; 
		meshMono.wrapT = Three.MirroredRepeatWrapping; 
		meshMono.repeat.set(5, 5);
		
		parkBg = ImageUtils.loadTexture( "bg/bg.jpg" );
		
		moji1 = ImageUtils.loadTexture( Path.assets + "face/bg.png" );
		moji1.wrapS = Three.RepeatWrapping; 
		moji1.wrapT = Three.RepeatWrapping; 
		moji1.repeat.set(2, 2);
		
		eyeNormal = ImageUtils.loadTexture( Path.assets + "eye/eye_normal.png");
		
	}
	
	
	
}