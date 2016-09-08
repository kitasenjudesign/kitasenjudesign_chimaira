/*
<!-- three.js r75 -->
<script src="//jsrun.it/assets/e/0/j/3/e0j3w"></script>

<!-- OrbitControls.js -->
<script src="//jsrun.it/assets/e/w/8/e/ew8eQ"></script>

<!-- collada/Animation.js -->
<script src="http://jsrun.it/assets/0/5/f/M/05fMB"></script>
<!-- collada/AnimationHandler.js -->
<script src="http://jsrun.it/assets/2/S/g/4/2Sg4B"></script>
<!-- collada/KeyFrameAnimation.js -->
<script src="http://jsrun.it/assets/4/S/c/7/4Sc71"></script>
<!-- loaders/ColladaLoader.js -->
<script src="http://jsrun.it/assets/I/I/P/L/IIPLg"></script>
*/

package objects ;
import camera.ExCamera;
import common.Path;
import js.Browser;
import sound.MyAudio;
import three.CubeCamera;
import three.Geometry;
import three.ImageUtils;
import three.Material;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshPhongMaterial;
import three.Object3D;
import three.SkinnedMesh;
import three.Texture;
import three.Vector3;
/**
 * ...
 * @author nab
 */
class SkeltonLoader extends Object3D
{
	
	private var _callback:Void->Void;
	
	private var _texture1:Texture;
	private var _texture2:Texture;
	private var _texture3:Texture;
	
	public var dae:Object3D;
	public var geometry:Geometry;
	public var material:MeshPhongMaterial;
	public var baseGeo:Array<Vector3>;
	public var baseAmp:Array<Float>;
	public var baseRadX:Array<Float>;
	public var baseRadY:Array<Float>;
	
	
	
	
	public function new() 
	{
		super();
	}

	public function load(callback:Void->Void):Void {
		
		_callback = callback;
		
		var loader = untyped __js__("new THREE.ColladaLoader()");
		loader.options.convertUpAxis = true;		
		//loader.load( 'mae_face.dae', _onComplete );

		//loader.load( 'dede_160806_2high.dae', _onComplete );
		//loader.load( Path.assets+ 'face/dede_c4d.dae', _onComplete );
		loader.load( Path.assets+ 'finger/hand.dae', _onComplete );
		
		//loader.load( Path.assets+ 'face/ossan.dae', _onComplete );

		
		//loader.load( 'dede_160805_7b.dae', _onComplete );
		//loader.load( 'mae_face_hole.dae', _onComplete );
		
		
	}
	
	
	
	private function _onComplete(collada):Void 
	{
		dae = collada.scene;
		dae.traverse( function ( child ) {

			if ( Std.is( child, SkinnedMesh ) ) {

				//var animation = new THREE.Animation( child, child.geometry.animation );
				//animation.play();

			}

		} );

		dae.scale.x = dae.scale.y = dae.scale.z = 50;
		
		add(dae);
		
		/*
		if (_callback != null) {
			_callback();
		}
		*/
		//dispatchEvent(new Event("COMPLETE", true, true));
	}
	
	
	
	
}