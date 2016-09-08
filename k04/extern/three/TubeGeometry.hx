package three;

@:native("THREE.TubeGeometry")
extern class TubeGeometry extends Geometry {
	function new(path:Path, ?segments:Int, ?radius:Float, ?radiusSegments:Int, ?closed:Bool, ?debug:Object3D) : Void;
}
