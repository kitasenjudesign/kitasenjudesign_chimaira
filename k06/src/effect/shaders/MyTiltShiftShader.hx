package effect.shaders;

/**
 * ...
 * @author watanabe
 */
class MyTiltShiftShader
{

	public function new() 
	{
		
	}
	
	public static function getObject():Dynamic {
		
		return {
			uniforms: {

				"tDiffuse": { type: "t", value: null },
				"v":        { type: "f", value: 2 / 512.0 },
				"r":		{type:"f",value:0.5},
				"k"  : { type: "fv1", value: [
					1.0, 4.0, 6.0, 4.0, 1.0,
					4.0, 16.0, 24.0, 16.0, 4.0,
					6.0, 24.0, 36.0, 24.0, 6.0,
					4.0, 16.0, 24.0, 16.0, 4.0,
					1.0, 4.0, 6.0, 4.0, 1.0
				] },    // float array (plain)
			},

			vertexShader:'
				varying vec2 vUv;
				void main() {
					vUv = uv;
					gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
				}',


			fragmentShader:'
				uniform sampler2D tDiffuse;
				uniform float v;
				uniform float r;
				uniform float k[25];
				varying vec2 vUv;

				void main() {

					vec4 sum = vec4( 0.0 );
					float vv = v * abs( r - vUv.y );
					
					for(float i=-1.0;i<=1.0;i++){
						for(float j = -1.0; j <=1.0; j++) {
							sum += texture2D( tDiffuse, vec2( vUv.x + i * vv, vUv.y + j * vv ) ) / 9.0;
							//idx += 1;
						}
					}
					
					sum.x *= 1.0;
					sum.y *= 0.95;
					sum.z *= 0.90;
					
					sum.x += 0.02;
					sum.y += 0.02;
					sum.z += 0.02;
					
					
					gl_FragColor = sum;

				}'
		};
		
	}
	
	
}