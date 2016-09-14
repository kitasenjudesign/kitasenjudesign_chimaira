package materials;
import three.Color;
import three.DirectionalLight;
import three.Plane;
import three.ShaderMaterial;
import three.UniformsUtils;
import three.Vector3;
import three.WebGLShaders.ShaderLib;

/**
 * ...
 * @author watanabe
 */
class MyPhongMaterial extends ShaderMaterial
{

	
	
	public function new(param:Dynamic) 
	{
		
		var defines = {USE_MAP:""}; // <=============================== added
		//defines.USE_MAP = "";// [ "USE_MAP" ] = ""; //
	
		var uniforms:Dynamic = UniformsUtils.clone(ShaderLib.phong.uniforms);

		uniforms.clippingPlanes = [new Plane(new Vector3( 0, 1, 0 ), 0.8 )];//
		uniforms.clipShadows = true;
		//uniforms.map = Textures.colorWhite;
		
		uniforms.diffuse.value.r = 1;
		uniforms.diffuse.value.g = 1;
		uniforms.diffuse.value.b = 1;
		
		uniforms.ambientLightColor.value = [1, 1, 1];
		
		//uniforms.directionalLights.value = [new DirectionalLight(0x888888, 1)];
		/*
		diffuse {
	type : c, 
	value : {
		r : 0.9333333333333333, 
		g : 0.9333333333333333, 
		b : 0.9333333333333333
	}
}
MyPhongMaterial.hx:32 opacity {
	type : 1f, 
	value : 1
}
MyPhongMaterial.hx:32 map {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 offsetRepeat {
	type : v4, 
	value : {
		x : 0, 
		y : 0, 
		z : 1, 
		w : 1
	}
}
MyPhongMaterial.hx:32 specularMap {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 alphaMap {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 envMap {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 flipEnvMap {
	type : 1f, 
	value : -1
}
MyPhongMaterial.hx:32 reflectivity {
	type : 1f, 
	value : 1
}
MyPhongMaterial.hx:32 refractionRatio {
	type : 1f, 
	value : 0.98
}
MyPhongMaterial.hx:32 aoMap {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 aoMapIntensity {
	type : 1f, 
	value : 1
}
MyPhongMaterial.hx:32 lightMap {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 lightMapIntensity {
	type : 1f, 
	value : 1
}
MyPhongMaterial.hx:32 emissiveMap {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 bumpMap {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 bumpScale {
	type : 1f, 
	value : 1
}
MyPhongMaterial.hx:32 normalMap {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 normalScale {
	type : v2, 
	value : {
		x : 1, 
		y : 1
	}
}
MyPhongMaterial.hx:32 displacementMap {
	type : t, 
	value : null
}
MyPhongMaterial.hx:32 displacementScale {
	type : 1f, 
	value : 1
}
MyPhongMaterial.hx:32 displacementBias {
	type : 1f, 
	value : 0
}
haxetest.js:1300 fogDensity {
	type : 1f, 
	value : 0.00025
}
haxetest.js:1300 fogNear {
	type : 1f, 
	value : 1
}
haxetest.js:1300 fogFar {
	type : 1f, 
	value : 2000
}
haxetest.js:1300 fogColor {
	type : c, 
	value : {
		r : 1, 
		g : 1, 
		b : 1
	}
}
haxetest.js:1300 ambientLightColor {
	type : 3fv, 
	value : []
}
haxetest.js:1300 directionalLights {
	type : sa, 
	value : [], 
	properties : {
		direction : {
			type : v3
		}, 
		color : {
			type : c
		}, 
		shadow : {
			type : 1i
		}, 
		shadowBias : {
			type : 1f
		}, 
		shadowRadius : {
			type : 1f
		}, 
		shadowMapSize : {
			type : v2
		}
	}
}
haxetest.js:1300 directionalShadowMap {
	type : tv, 
	value : []
}
haxetest.js:1300 directionalShadowMatrix {
	type : m4v, 
	value : []
}
haxetest.js:1300 spotLights {
	type : sa, 
	value : [], 
	properties : {
		color : {
			type : c
		}, 
		position : {
			type : v3
		}, 
		direction : {
			type : v3
		}, 
		distance : {
			type : 1f
		}, 
		coneCos : {
			type : 1f
		}, 
		penumbraCos : {
			type : 1f
		}, 
		decay : {
			type : 1f
		}, 
		shadow : {
			type : 1i
		}, 
		shadowBias : {
			type : 1f
		}, 
		shadowRadius : {
			type : 1f
		}, 
		shadowMapSize : {
			type : v2
		}
	}
}
haxetest.js:1300 spotShadowMap {
	type : tv, 
	value : []
}
haxetest.js:1300 spotShadowMatrix {
	type : m4v, 
	value : []
}
haxetest.js:1300 pointLights {
	type : sa, 
	value : [], 
	properties : {
		color : {
			type : c
		}, 
		position : {
			type : v3
		}, 
		decay : {
			type : 1f
		}, 
		distance : {
			type : 1f
		}, 
		shadow : {
			type : 1i
		}, 
		shadowBias : {
			type : 1f
		}, 
		shadowRadius : {
			type : 1f
		}, 
		shadowMapSize : {
			type : v2
		}
	}
}
haxetest.js:1300 pointShadowMap {
	type : tv, 
	value : []
}
haxetest.js:1300 pointShadowMatrix {
	type : m4v, 
	value : []
}
haxetest.js:1300 hemisphereLights {
	type : sa, 
	value : [], 
	properties : {
		direction : {
			type : v3
		}, 
		skyColor : {
			type : c
		}, 
		groundColor : {
			type : c
		}
	}
}
haxetest.js:1300 emissive {
	type : c, 
	value : {
		r : 0, 
		g : 0, 
		b : 0
	}
}
haxetest.js:1300 specular {
	type : c, 
	value : {
		r : 0.06666666666666667, 
		g : 0.06666666666666667, 
		b : 0.06666666666666667
	}
}
haxetest.js:1300 shininess {
	type : 1f, 
	value : 30
}
haxetest.js:1300 clippingPlanes [{
		normal : {
			x : 0, 
			y : 1, 
			z : 0
		}, 
		constant : 0.8
	}]
haxetest.js:1300 clipShadows true*/
		
		for (key in Reflect.fields(uniforms)) {
			Tracer.warn(key + " " + Reflect.field(uniforms, key));
		}
		
		
        var parameters = {
			//color:0xffffff,
            fragmentShader: ShaderLib.phong.fragmentShader,
            vertexShader: ShaderLib.phong.vertexShader,
            defines: defines, // <=============================== added
            uniforms: uniforms,
            lights: true,
            fog: false,
            side: Three.DoubleSide,
            blending: Three.NormalBlending,
            transparent: true// (uniforms.opacity.value < 1.0)
        };

       super(parameters);		
		
	}
	
}