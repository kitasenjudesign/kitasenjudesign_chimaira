package faces;
import common.Path;
import js.html.Uint8Array;
import objects.shaders.CurlNoise;
import sound.MyAudio;
import three.ImageUtils;
import three.ShaderMaterial;
import three.Texture;
import three.Vector3;


/**
 * ...
 * @author watanabe
 */
class MaeShaderMaterial extends ShaderMaterial
{

	private var ff:String = "
		//uniform 変数としてテクスチャのデータを受け取る
		uniform sampler2D texture;
		uniform sampler2D colTexture;
		uniform vec3 _lightPosition; //光源位置座標
		uniform float _wireframe;
		uniform float _isColor;
		uniform float _brightness;
		uniform float _counter;
		uniform float _colLoop;
		
		// vertexShaderで処理されて渡されるテクスチャ座標
		varying vec2 vUv;                                             
		varying vec3 vNormal;
		varying vec3 vPos;
		varying vec4 vLight;
		varying vec4 vAbs;
		varying vec4 vVertex;
		
		void main()
		{
			if ( _wireframe == 1.0 ) {
				
				gl_FragColor = vec4( _brightness, _brightness, _brightness, 1.0 );
				
			}else{
			
			
				// テクスチャの色情報をそのままピクセルに塗る
				vec4 col = texture2D( texture, vec2( vUv.x, vUv.y ) )*1.0;
				//gl_FragColor = col;// texture2D(texture, vUv);
				
				//視点座標系における光線ベクトル
				vec4 viewLightPosition = vLight;// 
				//vec4 viewLightPosition = viewMatrix * vec4( _lightPosition, 0.0);
				//vec3 lightDirection = normalize(vPos - _lightPosition);
				//float dotNL = clamp(dot( vLight.xyz, vNormal), 0.0, 1.0);
				
				//ベクトルの規格化
				vec3 N = normalize(vNormal);                //法線ベクトル
				vec3 L = normalize(viewLightPosition.xyz); //光線ベクトル
				
				//法線ベクトルと光線ベクトルの内積
				float dotNL = dot(N, L);

				//拡散色の決定
				vec3 diffuse = col.xyz * dotNL * 0.4 + col.xyz * 0.6;
				
				//diffuse = diffuse * vAbs.xyz;
				
				if ( _isColor == 1.0 ) {
						//vPos
						//vec2 pp = vec2( 0.5, fract( length(vAbs) + _counter ) );
						vec2 pp = vec2( 0.5, fract( length(vVertex.z*_colLoop) + _counter ) );
						if ( pp.y < 0.5) {
							pp.y = pp.y * 2.0;
						}else {
							pp.y = (1.0 - (pp.y - 0.5) * 2.0);				
						}
						//0-1 ni suru
						
						//vec2 pp = vec2( fract(vUv.x+vAbs.x*0.03), fract(vUv.y+vAbs.z*0.03) );
						vec4 out1 = texture2D( colTexture, pp );
						
						//float ratio = clamp(length(vAbs), 0.0, 1.0) / 1.0;
						//diffuse = diffuse.xyz * (1.0-ratio) + out1.xyz * (ratio);
						diffuse = diffuse.xyz * 0.2 + out1.xyz * 0.9;
						//diffuse = out1.xyz * dotNL * 0.1 + out1.xyz * 0.9;
						
						
						
						/*
						float mNear = 400.0;
						float mFar = 800.0;
						float depth = gl_FragCoord.z / gl_FragCoord.w;
						float color = 1.0 - smoothstep( mNear, mFar, depth );
						diffuse = vec3( color );
						*/
						
						//diffuse.x += out1.x;
						//diffuse.y += out1.y;
						//diffuse.z += out1.z;
				}
				
				//diffuse.x *= vVertex.z / 5000.0;
				//diffuse.y *= vVertex.z / 5000.0;
				//diffuse.z *= vVertex.z / 5000.0;
				
				diffuse.x *= _brightness;
				diffuse.y *= _brightness;
				diffuse.z *= _brightness;
				
				//if ( length( diffuse ) > 0.5 ){
					gl_FragColor = vec4( diffuse, 1.0);			
					//gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0);			
					
				//}
			}
		}	
	";
	
	
	
	private var vv:String = CurlNoise.glsl + "

const float PI = 3.141592653;
	
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vNormal;
varying vec4 vLight;
varying vec4 vAbs;
varying vec4 vVertex;
uniform float _noise;
uniform float _count;
uniform float _freqByteData[32];
uniform vec3 _lightPosition; //光源位置座標
uniform float _strength;

void main()
{
	vUv = uv;
	//頂点法線ベクトルを視点座標系に変換する行列=normalMatrix
	//vNormal = (normal * normalMatrix);
	//vec4 fuga = projectionMatrix * vec4( normal * normalMatrix , 0.0);
	vNormal = normalMatrix * normal;
	
	//視点座標系における光線ベクトル
	vLight = (viewMatrix * vec4( _lightPosition, 0.0));

	
	vPos = (modelMatrix * vec4(position, 1.0 )).xyz;
	
	//vecNormal = (modelMatrix * vec4(normal, 0.0)).xyz;
	//patams
	
	float nejireX		= pow( _freqByteData[16] / 255.0, 1.5) * 15.0;
	float nejireY		= pow(_freqByteData[18] / 255.0, 2.0) * PI * 2.0;// * 0.5;
	float noise 		= pow(_freqByteData[12] / 255.0, 1.0) * _noise;//1.5;
	float speed 		= pow(_freqByteData[8] / 255.0, 2.0) * 0.5;
	float sphere 		= pow(_freqByteData[4]/255.0, 2.0);
	float noiseSpeed 	= 0.1 + pow( _freqByteData[19] / 255.0, 4.0) * 0.25;
	float scale 		= 1.0 + pow(_freqByteData[1] / 255.0, 3.0) * 0.4;				
	float yokoRatio 	= pow(_freqByteData[5] / 255.0, 2.0);
	float yokoSpeed 	= pow(_freqByteData[13] / 255.0, 2.0) * 4.0;
	float zengoRatio 	= pow(_freqByteData[19] / 255.0, 2.0);		
	float tate			= 1.0 + ( pow(_freqByteData[14] / 255.0, 2.0) * 1.0 - pow(_freqByteData[3] / 255.0, 2.0) * 1.0 );
	
	nejireX *= _strength;
	nejireY *= _strength;
	noise *= _strength;
	speed *= _strength;
	sphere *= _strength;
	noiseSpeed *= _strength;
	scale *= _strength;
	yokoRatio *= _strength;
	yokoSpeed *= _strength;
	zengoRatio *= _strength;
	tate *= _strength;
	
	////////////////////
	vec3 vv = position;
	/*
		var a:Float = Math.sqrt( vv.x * vv.x + vv.y * vv.y + vv.z * vv.z);
		var radX:Float = -Math.atan2(vv.z, vv.x) + vv.y * Math.sin(_count) * _nejireX;//横方向の角度
		var radY:Float = Math.asin(vv.y / a);// + _nejireY;// * Math.sin(_count * 0.8);//縦方向の角度	
	*/	
	float a = length(vv);
	float radX = (-atan(vv.z, vv.x) + PI * 0.5) + vv.y * sin(_count) * nejireX;//横方向の角度
	float radY = asin(vv.y / a);
	
	/*
		var amp:Float = (1-_sphere) * a + (_sphere) * 1;
		amp += Math.sin(_count * 0.7) * _getNoise(vv.x, vv.y + _count * _noiseSpeed, vv.z) * _noise;
	*/

	//float snoise(vec3 v) { 
	float amp = (1.0 - sphere) * a + sphere * 1.0;
	vec3 snoisePos = vec3(vv.x, vv.y + _count * noiseSpeed, vv.z);
	amp += sin(_count * 0.7) * snoise(snoisePos) * noise;
	
	/*
		var yoko:Float = Math.sin( 0.5*( vv.y * 2 * Math.PI ) + _count * _yokoSpeed ) * _yokoRatio;
		var zengo:Float = Math.cos( 0.5*( vv.y * 2 * Math.PI ) + _count * 3 ) * 0.2 * _zengoRatio;
			
		var tgtX:Float = amp * Math.sin( radX ) * Math.cos(radY) + zengo;//横
		var tgtY:Float = amp * Math.sin( radY );//縦
		var tgtZ:Float = amp * Math.cos( radX ) * Math.cos(radY) + yoko;//横	
	*/

	float yoko = sin( 0.5*( vv.y * 2.0 * PI ) + _count * yokoSpeed ) * yokoRatio;
	float zengo = cos( 0.5*( vv.y * 2.0 * PI ) + _count * 3.0 ) * 0.2 * zengoRatio;	
	
	vec3 hoge = vec3(0.0);
		hoge.x = amp * sin( radX ) * cos(radY) + zengo;//横
		hoge.y = amp * sin( radY ) * tate;//縦
		hoge.z = amp * cos( radX ) * cos(radY) + yoko;//横	
		
	// 変換：ローカル座標 → 配置 → カメラ座標
	vec4 mvPosition = modelViewMatrix * vec4(hoge, 1.0);//vec4(vv, 1.0);    
	
	//vLight =  projectionMatrix * viewMatrix * vec4( _lightPosition, 0.0);
	vAbs = vec4(0.0);
	vAbs.x = hoge.x - position.x;
	vAbs.y = hoge.y - position.y;
	vAbs.z = hoge.z - position.z;
	
	
	vVertex = mvPosition;
	// 変換：カメラ座標 → 画面座標
	gl_Position = projectionMatrix * mvPosition;
	
	
}

	";
	
	//akarusa wo setsuru
	public static var MAT_COLOR_RANDOM:Int = 0;
	public static var MAT_COLOR_RED:Int = 1;
	
	private static var _texture1:Texture;
	private static var _colorTextures:Array<Texture>;
	private static var _colorTexturesRed:Array<Texture>;
	
	private var _indecies:Array<Int>;
	private var _freq:Array<Float>;
	private var _currentTexture:Texture;
	/**
	 * new
	 * @param	tt
	 * @param	t2
	 */
	public function new() 
	{
		if (_texture1 == null) {
			_texture1 = ImageUtils.loadTexture(Path.assets+ "face/dede_face_diff.png");// mae_face.png");
		}
		
		_indecies = [];
		_freq = [];
		for (i in 0...MyAudio.a.freqByteDataAry.length) {
			_indecies[i] = Math.floor( Math.random() * MyAudio.a.freqByteDataAry.length);
			_freq[i] = 0;
		}
		
		changeTexture();
		super({
				vertexShader: vv,
				fragmentShader: ff,
				uniforms: {
					texture: { type: 't', 		value: _texture1 },
					colTexture:  { type: 't', 	value: _currentTexture },
					_noise: { type: 'f', 		value: 1.5+Math.random() },
					_freqByteData:{type:"fv1",	value:MyAudio.a.freqByteDataAry},//Uint8Array
					_count: { type:'f', 		value:100 * Math.random() },					
					_lightPosition: { type: "v3", value: new Vector3(0, 100, 50) },
					_wireframe: { type:"f",		value:1 },
					_isColor: { type:"f",		value:1 },
					_brightness: { type:"f",		value:1 },
					_strength: { type:"f", value:1 },
					_counter: { type:"f", value:0 },
					_colLoop: { type:"f",value:1 }
					
				}
		});
		
		this.wireframe = true;
		//this.side = Three.DoubleSide;
		//this.transparent = true;
		//this.alphaTest = 0.5;
		
	}
	
	
	
	public function changeTexture():Void {
		
		if ( _colorTextures == null ) {
			_colorTextures = [
				ImageUtils.loadTexture(Path.assets + "grade/grade.png"),
				ImageUtils.loadTexture(Path.assets + "grade/grade2.png"),
				ImageUtils.loadTexture(Path.assets + "grade/grade3.png"),
				ImageUtils.loadTexture(Path.assets + "grade/grade4.png"),
				ImageUtils.loadTexture(Path.assets + "grade/grade8.png")
			];
		}
		_currentTexture = _colorTextures[Math.floor(_colorTextures.length * Math.random())];

	}

	public function changeTextureRed():Void {
		
		if ( _colorTexturesRed == null ) {
			_colorTexturesRed = [
				ImageUtils.loadTexture(Path.assets + "grade/grade_red1.jpg"),
				ImageUtils.loadTexture(Path.assets + "grade/grade_red2.jpg"),
				ImageUtils.loadTexture(Path.assets + "grade/grade_red3.jpg")
			];
		}
		_currentTexture = _colorTexturesRed[Math.floor(_colorTexturesRed.length*Math.random())];
		
	}
	
	
	private function _getIndex():Array<Int>
	{
		var ary:Array<Int> = [];
		for (i in 0...10) {
			ary[i] = Math.floor(25 * Math.random());
		}
		return ary;
	}
	
	public function setColor(b:Bool,texType:Int):Void {
		
		if (b) {
			uniforms._isColor.value = 1;//colorful
			if (texType == MAT_COLOR_RANDOM) {
				changeTexture();
			}else {
				changeTextureRed();				
			}
			uniforms.colTexture.value = _currentTexture;

		}else {
			uniforms._isColor.value = 0;//normal
		}
		
	}
	
	
	public function setWireframe(b:Bool):Void {
		
		if (b) {
			uniforms._wireframe.value = 1;
			this.wireframe = true;
			this.wireframeLinewidth = 0;
		}else {
			uniforms._wireframe.value = 0;		
			this.wireframe = false;			
		}
		//this.wireframe = true;
		
	}
	
	
	public function update(a:MyAudio,lifeRatio:Float):Void {
		//color.uniforms.texture.value = _texture1;
		//trace(this.uniforms.counter.value);
		if(a!=null && a.isStart){
			_updateFreq(a, lifeRatio);
			var speed:Float 
			= Math.pow( a.freqByteData[_indecies[8]] / 255, 2) * 0.5;
			uniforms._count.value += speed;// Math.random();// Math.random();
			uniforms._freqByteData.value = _freq;// Math.random();// Math.random();
			uniforms._colLoop.value = 0.01+Math.pow( a.freqByteData[_indecies[3]] / 255, 1.5)*100;// Math.random();// Math.random();
			
			uniforms._counter.value += 0.01;
		}
		//needsUpdate = true;
		
	}
	
	public function setBrightness(bright:Float):Void {
		
		uniforms._brightness.value = 0.8+0.2*bright;
		
	}
	
	public function setStrength(f:Float):Void {

		uniforms._strength.value = f;
				
	}
	
	//
	private function _updateFreq(audio:MyAudio,lifeRatio:Float):Void {
		
		for(i in 0..._freq.length){
			_freq[i] = audio.freqByteDataAryEase[_indecies[i]];
		}
		
	}
	
	
}