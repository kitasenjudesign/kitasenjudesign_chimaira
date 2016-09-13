package materials;
import three.UniformsUtils;
import three.WebGLShaders.ShaderLib;

/**
 * ...
 * @author watanabe
 */
class MyPhongMaterial
{

	public function new(param:Dynamic) 
	{
		
		var defines = {}; // <=============================== added
		defines[ "USE_MAP" ] = ""; //
	
		var uniforms:Dynamic = UniformsUtils.clone(ShaderLib.phong.uniforms);

        var parameters = {
            fragmentShader: ShaderLib.phong.fragmentShader,
            vertexShader: ShaderLib.phong.vertexShader,
            defines: defines, // <=============================== added
            uniforms: uniforms,
            lights: true,
            fog: false,
            side: Three.DoubleSide,
            blending: Three.NormalBlending,
            transparent: (uniforms.opacity.value < 1.0)
        };

       super(parameters);		
		
	}
	
}