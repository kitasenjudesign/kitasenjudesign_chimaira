package effect.shaders;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class VignetteShader
{

	public function new() 
	{
		
	}
	
	/**
	 * 
	 * @return
	 */
	public static function getObject():Dynamic {
		
		return {
			//
			uniforms: {
				"tDiffuse"	: { type: "t", value: null },
				"fl"		: { type: "f", value: 0.0 },
				"offset"	: { type: "f", value: 1.0 },
				"darkness"	: { type: "f", value: 1 },//1.5 },
				"k"  : { type: "fv1", value: [
					1.0, 4.0, 6.0, 4.0, 1.0,
					4.0, 16.0, 24.0, 16.0, 4.0,
					6.0, 24.0, 36.0, 24.0, 6.0,
					4.0, 16.0, 24.0, 16.0, 4.0,
					1.0, 4.0, 6.0, 4.0, 1.0
				] },
				"mcolor"	: { type: "v3", value: new Vector3(1.1, 1.05, 1.0) },
				"ocolor"	: { type: "v3",  value: new Vector3(-0.02,-0.04,-0.06) }
			},
			
			//
			vertexShader:
				"varying vec2 vUv;
				void main() {
					vUv = uv;
					gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
				}",
				
			//
			fragmentShader:
				"uniform float offset;
				uniform float darkness;
				uniform float fl;
				uniform sampler2D tDiffuse;
				varying vec2 vUv;
				uniform float k[25];
				uniform vec3 mcolor;
				uniform vec3 ocolor;
				
				void main() {
					vec4 texel = vec4( 0.0 );
					
					float vx = 1.0 / 1280.0;
					float vy = 1.0 / 720.0;
					
					texel = texture2D( tDiffuse, vUv);
					//filter
					/*
					texel += texture2D( tDiffuse, vec2( vUv.x - vx, vUv.y - vy ) ) * 1.0/16.0;
					texel += texture2D( tDiffuse, vec2( vUv.x, vUv.y - vy ) ) * 2.0/16.0;
					texel += texture2D( tDiffuse, vec2( vUv.x + vx, vUv.y - vy ) ) * 1.0/16.0;
					
					texel += texture2D( tDiffuse, vec2( vUv.x - vx, vUv.y ) ) * 2.0 / 16.0;
					texel += texture2D( tDiffuse, vec2( vUv.x, vUv.y ) ) * 4.0 / 16.0;
					texel += texture2D( tDiffuse, vec2( vUv.x + vx, vUv.y ) ) * 2.0 / 16.0;
					
					texel += texture2D( tDiffuse, vec2( vUv.x - vx, vUv.y + vy ) ) * 1.0/16.0;
					texel += texture2D( tDiffuse, vec2( vUv.x, vUv.y + vy ) ) * 2.0/16.0;
					texel += texture2D( tDiffuse, vec2( vUv.x + vx, vUv.y + vy ) ) * 1.0/16.0;
					*/
					
					vec2 uv = ( vUv - vec2( 0.5 ) ) * vec2( offset );
					float l = 1.0 - darkness;
					
					//float offset = 
					vec3 col = mix( texel.rgb, vec3( l, l,l ), dot( uv, uv ) );
					col = col + vec3(0.00, 0.06, 0.12);
					col = col + vec3(fl, fl, fl);
					
					col.x = col.x * mcolor.x + ocolor.x;// 2.0;
					col.y = col.y * mcolor.y + ocolor.y;// 1.5;
					col.z = col.z * mcolor.z + ocolor.z;// 1.0;	
					
					gl_FragColor = vec4( col, texel.a );
				}"

		};
	
	}
	
}