(function () { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var FontShapeMaker = function() {
};
FontShapeMaker.main = function() {
	new FontShapeMaker();
};
FontShapeMaker.prototype = {
	add: function(m) {
	}
	,remove: function(m) {
	}
	,init: function(json,callback) {
		FontShapeMaker.font = new net.badimon.five3D.typography.GenTypography3D();
		if(callback == null) FontShapeMaker.font.initByString(json); else FontShapeMaker.font.init(json,callback);
	}
	,getWidth: function(moji) {
		return FontShapeMaker.font.getWidth(moji);
	}
	,getHeight: function() {
		return FontShapeMaker.font.getHeight();
	}
	,getGeometry: function(moji,isCentering) {
		if(isCentering == null) isCentering = true;
		var shapes = this.getShapes(moji,isCentering);
		var geo = new THREE.ShapeGeometry(shapes,{ });
		return geo;
	}
	,getShapes: function(moji,isCentering) {
		if(isCentering == null) isCentering = false;
		var scale = 1;
		var shapes = [];
		var shape = null;
		var g = null;
		var motif = FontShapeMaker.font.motifs.get(moji);
		var ox = 0;
		var oy = 0;
		var s = scale;
		if(isCentering) {
			ox = -FontShapeMaker.font.widths.get(moji) / 2;
			oy = -FontShapeMaker.font.height / 2;
		}
		var len = motif.length;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			var tgt = motif[i][0];
			if(tgt == "M" || tgt == "H") {
				if(tgt == "H") {
					g = new THREE.Path();
					shape.holes.push(g);
				} else {
					shape = new THREE.Shape();
					shapes.push(shape);
					g = shape;
				}
				g.moveTo(s * (motif[i][1][0] + ox),-s * (motif[i][1][1] + oy));
			} else if(tgt == "L") g.lineTo(s * (motif[i][1][0] + ox),-s * (motif[i][1][1] + oy)); else if(tgt == "C") g.quadraticCurveTo(s * (motif[i][1][0] + ox),-s * (motif[i][1][1] + oy),s * (motif[i][1][2] + ox),-s * (motif[i][1][3] + oy));
		}
		return shapes;
	}
};
var HxOverrides = function() { };
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
var Lambda = function() { };
Lambda.exists = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
};
var List = function() {
	this.length = 0;
};
List.prototype = {
	iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
};
var Main = function() { };
Main.main = function() {
	window.onload = Main._init;
};
Main._init = function() {
	Main._main = new Main3d();
	Main._main.init();
};
var Main3d = function() {
};
Main3d.prototype = {
	init: function() {
		this._renderer = new THREE.WebGLRenderer({ alpha : true, antialias : true, devicePixelRatio : 1});
		this._renderer.domElement.id = "webgl";
		common.Dat.init($bind(this,this._onInitA));
	}
	,_onInitA: function() {
		this._mojis = new objects.Mojis();
		this._mojis.init($bind(this,this._onInit0));
	}
	,_onInit0: function() {
		this._camera = new camera.ExCamera(33.235,Main3d.W / Main3d.H,10,10000);
		this._camera.amp = 1000;
		this._scene = new THREE.Scene();
		this._video = new video.VideoPlayer();
		this._video.init(this._camera,$bind(this,this._onInit1));
	}
	,_onInit1: function() {
		this._audio = new sound.MyAudio();
		this._audio.init($bind(this,this._onInit2));
	}
	,_onInit2: function() {
		this._bg = new objects.CgBg();
		this._bg.init();
		this._scene.add(this._bg);
		this._scene.add(this._mojis);
		this._scene.add(this._video);
		this._renderer.localClippingEnabled = true;
		this._renderer.shadowMap.enabled = true;
		this._renderer.shadowMap.type = THREE.BasicShadowMap;
		this._renderer.setClearColor(new THREE.Color(0),0);
		this._renderer.setSize(Main3d.W,Main3d.H);
		this._renderer.domElement.style.position = "absolute";
		this._camera.init(this._renderer.domElement);
		window.document.body.appendChild(this._renderer.domElement);
		var light = new THREE.SpotLight(16777215,1.5);
		light.position.x = 30;
		light.position.y = 3000;
		light.position.z = 100;
		light.castShadow = true;
		
			light.shadow = new THREE.LightShadow( new THREE.PerspectiveCamera( 30, 16/9, 200, 4000 ) );
			light.shadow.bias = 0.001;// -0.000222;
			light.shadow.mapSize.width = 2048;
			light.shadow.mapSize.height = 2048;		
		;
		this._scene.add(light);
		var a = new THREE.AmbientLight(5592405);
		this._scene.add(a);
		this._skyboxMat = new common.SkyboxTexture();
		this._skyboxMat.init(THREE.ImageUtils.loadTexture("mate.png"));
		this._skyboxMat.update(this._renderer);
		this._video.setInitCallback($bind(this,this._onStartVideo));
		this._updateTexture();
		var mm = new THREE.ShadowMaterial();
		mm.opacity = 0.5;
		this._shadowGround = new THREE.Mesh(new THREE.PlaneGeometry(700,700,5,5),mm);
		this._shadowGround.receiveShadow = true;
		this._shadowGround.position.y = 0;
		this._shadowGround.rotation.x = -Math.PI / 2;
		this._scene.add(this._shadowGround);
		this._pp = new effect.PostProcessing2();
		this._pp.init(this._scene,this._camera,this._renderer,null);
		common.Dat.gui.add(this,"_showVideo");
		common.Dat.gui.add(this,"_hideVideo");
		common.Dat.gui.add(this._camera.rotation,"x").name("rotX").listen();
		common.Dat.gui.add(this._camera.rotation,"y").name("rotY").listen();
		common.Dat.gui.add(this._camera.rotation,"z").name("rotZ").listen();
		common.Dat.gui.add(this._camera.position,"x").name("posX").listen();
		common.Dat.gui.add(this._camera.position,"y").name("posY").listen();
		common.Dat.gui.add(this._camera.position,"z").name("posZ").listen();
		window.onresize = $bind(this,this._onResize);
		this._onResize(null);
		this._run(true);
		common.Key.board.addEventListener("keydown",$bind(this,this._onKeyDown));
	}
	,_onKeyDown: function(e) {
		var _g = Std.parseInt(e.keyCode);
		switch(_g) {
		case 65:
			this._showVideo();
			break;
		case 83:
			this._hideVideo();
			break;
		}
	}
	,_showVideo: function() {
		this._video.show();
		this._bg.hide();
	}
	,_hideVideo: function() {
		this._video.hide();
		this._bg.show();
	}
	,_onStartVideo: function() {
		this._updateTexture();
	}
	,_updateTexture: function() {
		window.document.getElementById("loading").style.display = "none";
		this._skyboxMat.init(this._video.getTexture());
	}
	,_update: function() {
		this._run(false);
	}
	,_run: function(loop) {
		if(loop == null) loop = false;
		if(this._audio != null && this._audio.isStart) this._audio.update();
		this._skyboxMat.update(this._renderer);
		this._mojis.setEnvMap(this._skyboxMat.getTexture());
		this._video.update(this._camera);
		if(!this._video.getEnded()) this._mojis.update(this._audio);
		this._pp.update(this._audio);
		if(loop) window.requestAnimationFrame($bind(this,this._run));
	}
	,_onResize: function(d) {
		Main3d.W = window.innerWidth;
		Main3d.H = Math.floor(Main3d.W * 9 / 16);
		var oy = -(Main3d.H - window.innerHeight) / 2;
		this._renderer.domElement.width = Main3d.W;
		this._renderer.domElement.height = Main3d.H;
		this._renderer.domElement.style.top = oy + "px";
		this._renderer.setSize(Main3d.W,Main3d.H);
		this._camera.aspect = Main3d.W / Main3d.H;
		this._camera.updateProjectionMatrix();
		this._video.resize(Main3d.W,Main3d.H,oy);
	}
	,fullscreen: function() {
		this._renderer.domElement.requestFullscreen();
	}
};
var IMap = function() { };
var Reflect = function() { };
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) return null; else if(o.__properties__ && (tmp = o.__properties__["get_" + field])) return o[tmp](); else return o[field];
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
Std.parseFloat = function(x) {
	return parseFloat(x);
};
var _Three = {};
_Three.CullFace_Impl_ = function() { };
_Three.FrontFaceDirection_Impl_ = function() { };
_Three.ShadowMapType_Impl_ = function() { };
_Three.Side_Impl_ = function() { };
_Three.Shading_Impl_ = function() { };
_Three.Colors_Impl_ = function() { };
_Three.BlendMode_Impl_ = function() { };
_Three.BlendingEquation_Impl_ = function() { };
_Three.BlendingDestinationFactor_Impl_ = function() { };
_Three.TextureConstant_Impl_ = function() { };
_Three.WrappingMode_Impl_ = function() { };
_Three.Filter_Impl_ = function() { };
_Three.DataType_Impl_ = function() { };
_Three.PixelType_Impl_ = function() { };
_Three.PixelFormat_Impl_ = function() { };
_Three.TextureFormat_Impl_ = function() { };
_Three.LineType_Impl_ = function() { };
var Three = function() { };
Three.requestAnimationFrame = function(f) {
	return window.requestAnimationFrame(f);
};
Three.cancelAnimationFrame = function(f) {
	window.cancelAnimationFrame(id);
};
var camera = {};
camera.ExCamera = function(fov,aspect,near,far) {
	this._flag = false;
	this.tgtOffsetY = 0;
	this._countSpeed = 0;
	this._rAmp = 0;
	this._count = 0;
	this.isActive = false;
	this.radY = 0.001;
	this.radX = 0.001;
	this.amp = 300.0;
	this._oRadY = 0;
	this._oRadX = 0;
	this._height = 0;
	this._width = 0;
	this._mouseY = 0;
	this._mouseX = 0;
	this._downY = 0;
	this._downX = 0;
	this._down = false;
	THREE.PerspectiveCamera.call(this,fov,aspect,near,far);
};
camera.ExCamera.__super__ = THREE.PerspectiveCamera;
camera.ExCamera.prototype = $extend(THREE.PerspectiveCamera.prototype,{
	init: function(dom) {
		this._camera = this;
		this.target = new THREE.Vector3();
		dom.onmousedown = $bind(this,this.onMouseDown);
		dom.onmouseup = $bind(this,this.onMouseUp);
		dom.onmousemove = $bind(this,this.onMouseMove);
		dom.onmousewheel = $bind(this,this.onMouseWheel);
		window.addEventListener("DOMMouseScroll",$bind(this,this.onMouseWheelFF));
	}
	,_onResize: function() {
	}
	,onMouseWheelFF: function(e) {
		this.amp += e.detail * 0.5;
		if(this.amp > 18000) this.amp = 18000;
		if(this.amp < 100) this.amp = 100;
	}
	,onMouseWheel: function(e) {
		this.amp += e.wheelDelta * 0.5;
		if(this.amp > 18000) this.amp = 18000;
		if(this.amp < 100) this.amp = 100;
	}
	,onMouseUp: function(e) {
		e.preventDefault();
		this._down = false;
	}
	,onMouseDown: function(e) {
		e.preventDefault();
		this._down = true;
		this._downX = e.clientX;
		this._downY = e.clientY;
		this._oRadX = this.radX;
		this._oRadY = this.radY;
	}
	,onMouseMove: function(e) {
		e.preventDefault();
		this._mouseX = e.clientX;
		this._mouseY = e.clientY;
	}
	,update: function() {
		if(this._down) {
			var dx = -(this._mouseX - this._downX);
			var dy = this._mouseY - this._downY;
			this.radX = this._oRadX + dx / 100;
			this.radY = this._oRadY + dy / 100;
			if(this.radY > Math.PI / 2) this.radY = Math.PI / 2;
			if(this.radY < -Math.PI / 2) this.radY = -Math.PI / 2;
		}
		if(this._camera != null) this._updatePosition(0.25);
	}
	,setFOV: function(fov) {
		if(this._camera != null) {
			this._camera.fov = fov;
			this._camera.updateProjectionMatrix();
		}
	}
	,resize: function() {
		this._width = window.innerWidth;
		this._height = window.innerHeight;
		this._camera.aspect = this._width / this._height;
		this._camera.updateProjectionMatrix();
	}
	,reset: function(target) {
		var p = this._camera.position;
		this.amp = Math.sqrt(p.x * p.x + p.y * p.y + p.z * p.z);
		this.radX = Math.atan2(p.x,p.z);
		this.radY = Math.atan2(p.y,p.z);
		this._updatePosition();
		if(this.radY > Math.PI / 2 * 0.96) this.radY = Math.PI / 2 * 0.96;
		if(this.radY < -Math.PI / 2 * 0.96) this.radY = -Math.PI / 2 * 0.96;
		if(target != null) this._camera.lookAt(target);
	}
	,setPolar: function(a,rx,ry) {
		this.amp = a;
		this.radX = rx;
		this.radY = ry;
		this._updatePosition();
	}
	,setRAmp: function(rAmp,countSpeed) {
		this._flag = true;
		this._rAmp += rAmp;
		this._countSpeed += countSpeed;
	}
	,_onAmp: function() {
		this._flag = false;
	}
	,_updatePosition: function(spd) {
		if(spd == null) spd = 1;
		var amp1 = this.amp * Math.cos(this.radY);
		this._count += this._countSpeed;
		var ox = this._rAmp * Math.cos(this._count / 30 * 2 * Math.PI);
		var oy = this._rAmp * Math.sin(this._count / 30 * 2 * Math.PI);
		this._rAmp *= 0.97;
		this._countSpeed *= 0.95;
		var x = this.target.x + amp1 * Math.sin(this.radX) + ox;
		var y = this.target.y + this.amp * Math.sin(this.radY) + oy;
		var z = this.target.z + amp1 * Math.cos(this.radX);
		this._camera.position.x += (x - this._camera.position.x) * spd;
		this._camera.position.y += (y - this._camera.position.y) * spd;
		this._camera.position.z += (z - this._camera.position.z) * spd;
		var t = this.target.clone();
		t.y += this.tgtOffsetY;
		this.target2 = t;
		this._camera.lookAt(t);
	}
});
var common = {};
common.Callback = function() {
};
common.Callback.create = function(scope,func,args) {
	return function() {
		func.apply(scope,args);
	};
};
common.Config = function() {
};
common.Config.prototype = {
	load: function(callback) {
		this._callback = callback;
		this._http = new haxe.Http("../../config.json");
		this._http.onData = $bind(this,this._onData);
		this._http.request();
	}
	,_onData: function(str) {
		var data = JSON.parse(str);
		common.Config.host = data.host;
		var win = window;
		win.host = common.Config.host;
		if(common.QueryGetter.getQuery("host") != null) win.host = common.QueryGetter.getQuery("host");
		common.Config.canvasOffsetY = data.canvasOffsetY;
		common.Config.globalVol = data.globalVol;
		common.Config.particleSize = data.particleSize;
		common.Config.bgLight = data.bgLight;
		if(this._callback != null) this._callback();
	}
};
common.Dat = function() {
};
common.Dat.init = function(callback) {
	common.StageRef.fadeIn();
	common.Dat._callback = callback;
	common.Dat._config = new common.Config();
	common.Dat._config.load(common.Dat._onInit);
};
common.Dat._onInit = function() {
	common.Dat.bg = window.location.hash == "#bg";
	common.Dat.gui = new dat.GUI({ autoPlace: false });
	window.document.body.appendChild(common.Dat.gui.domElement);
	common.Dat.gui.domElement.style.position = "absolute";
	common.Dat.gui.domElement.style.right = "0px";
	var yy = window.innerHeight / 2 + common.StageRef.get_stageHeight() / 2 + common.Config.canvasOffsetY;
	common.Dat.gui.domElement.style.top = Math.floor(yy / 2) + "px";
	common.Dat.gui.domElement.style.opacity = 1;
	common.Dat.gui.domElement.style.zIndex = 1000;
	common.Dat.gui.domElement.style.transformOrigin = "1 0";
	common.Dat.gui.domElement.style.transform = "scale(0.8,0.8)";
	common.Key.init();
	common.Key.board.addEventListener("keydown",common.Dat._onKeyDown);
	common.Dat.show(false);
	if(common.Dat._callback != null) common.Dat._callback();
};
common.Dat._onKeyDown = function(e) {
	var _g = Std.parseInt(e.keyCode);
	switch(_g) {
	case 65:
		break;
	case 68:
		if(common.Dat.gui.domElement.style.display == "block") common.Dat.hide(); else common.Dat.show(true);
		break;
	case 49:
		common.StageRef.fadeOut(common.Dat._goURL1);
		break;
	case 50:
		common.StageRef.fadeOut(common.Dat._goURL2);
		break;
	case 51:
		common.StageRef.fadeOut(common.Dat._goURL3);
		break;
	case 52:
		common.StageRef.fadeOut(common.Dat._goURL4);
		break;
	case 53:
		common.StageRef.fadeOut(common.Dat._goURL5);
		break;
	case 54:
		common.StageRef.fadeOut(common.Dat._goURL6);
		break;
	}
};
common.Dat._goURL1 = function() {
	common.Dat._goURL("../../k04/bin/");
};
common.Dat._goURL2 = function() {
	common.Dat._goURL("../../k05/bin/");
};
common.Dat._goURL3 = function() {
	common.Dat._goURL("../../k02/bin/");
};
common.Dat._goURL4 = function() {
	common.Dat._goURL("../../k03/bin/");
};
common.Dat._goURL5 = function() {
	common.Dat._goURL("../../k00/bin/");
};
common.Dat._goURL6 = function() {
	common.Dat._goURL("../../k01/bin/");
};
common.Dat._goURL = function(url) {
	console.log("goURL " + url);
	window.location.href = url + window.location.hash;
};
common.Dat.show = function(isBorder) {
	if(isBorder == null) isBorder = false;
	if(isBorder) common.StageRef.showBorder();
	common.Dat.gui.domElement.style.display = "block";
};
common.Dat.hide = function() {
	common.StageRef.hideBorder();
	common.Dat.gui.domElement.style.display = "none";
};
common.FadeSheet = function(ee) {
	this.opacity = 1;
	this.element = ee;
};
common.FadeSheet.prototype = {
	fadeIn: function() {
		if(this.element != null) {
			this.element.style.opacity = "0";
			this.opacity = 0;
			if(this._twn != null) this._twn.kill();
			this._twn = TweenMax.to(this,0.8,{ opacity : 1, delay : 0.2, ease : Power0.easeInOut, onUpdate : $bind(this,this._onUpdate)});
		}
	}
	,fadeOut: function(callback) {
		if(this._twn != null) this._twn.kill();
		this._twn = TweenMax.to(this,0.5,{ opacity : 0, ease : Power0.easeInOut, onUpdate : $bind(this,this._onUpdate), onComplete : callback});
	}
	,_onUpdate: function() {
		if(this.element != null) this.element.style.opacity = "" + this.opacity;
	}
};
common.Key = function() {
	THREE.EventDispatcher.call(this);
};
common.Key.init = function() {
	if(common.Key.board == null) {
		common.Key.board = new common.Key();
		common.Key.board.init2();
	}
};
common.Key.__super__ = THREE.EventDispatcher;
common.Key.prototype = $extend(THREE.EventDispatcher.prototype,{
	init2: function() {
		window.document.addEventListener("keydown",$bind(this,this._onKeyDown));
		this._socket = new common.WSocket();
		this._socket.init();
		if(common.Dat.bg) this._socket.addCallback($bind(this,this._onKeyDown));
	}
	,_onKeyDown: function(e) {
		var n = Std.parseInt(e.keyCode);
		console.debug("_onkeydown " + n);
		this._dispatch(n);
	}
	,_dispatch: function(n) {
		if(!common.Dat.bg) this._socket.send(n);
		this.dispatchEvent({ type : "keydown", keyCode : n});
	}
});
common.Path = function() {
};
common.QueryGetter = function() {
};
common.QueryGetter.init = function() {
	common.QueryGetter._map = new haxe.ds.StringMap();
	var str = window.location.search;
	if(str.indexOf("?") < 0) console.log("query nashi"); else {
		str = HxOverrides.substr(str,1,str.length - 1);
		var list = str.split("&");
		console.log(list);
		var _g1 = 0;
		var _g = list.length;
		while(_g1 < _g) {
			var i = _g1++;
			var fuga = list[i].split("=");
			common.QueryGetter._map.set(fuga[0],fuga[1]);
		}
	}
	if(common.QueryGetter._map.get("t") != null) common.QueryGetter.t = Std.parseInt(common.QueryGetter._map.get("t"));
	common.QueryGetter._isInit = true;
};
common.QueryGetter.getQuery = function(idd) {
	if(!common.QueryGetter._isInit) common.QueryGetter.init();
	return common.QueryGetter._map.get(idd);
};
common.SkyboxTexture = function() {
};
common.SkyboxTexture.prototype = {
	init: function(texture) {
		if(this._scene == null) {
			this._cubeCam = new THREE.CubeCamera(10,500,256);
			this._boxMaterial = new THREE.MeshBasicMaterial({ color : 16777215, side : 2});
			this._scene = new THREE.Scene();
			this._scene.add(this._cubeCam);
			this._box = new THREE.Mesh(new THREE.SphereGeometry(100,10,10),this._boxMaterial);
			this._scene.add(this._box);
		}
		this._boxMaterial.map = texture;
	}
	,getTexture: function() {
		return this._cubeCam.renderTarget.texture;
	}
	,update: function(renderer) {
		this._cubeCam.updateCubeMap(renderer,this._scene);
	}
};
common.StageRef = function() {
};
common.StageRef.__properties__ = {get_stageHeight:"get_stageHeight",get_stageWidth:"get_stageWidth"}
common.StageRef.showBorder = function() {
	var dom = window.document.getElementById("webgl");
	dom.style.border = "solid 1px #cccccc";
};
common.StageRef.hideBorder = function() {
	var dom = window.document.getElementById("webgl");
	dom.style.border = "solid 0px";
};
common.StageRef.fadeIn = function() {
	if(common.StageRef.sheet == null) common.StageRef.sheet = new common.FadeSheet(window.document.getElementById("webgl"));
	common.StageRef.sheet.fadeIn();
};
common.StageRef.fadeOut = function(callback) {
	if(common.StageRef.sheet == null) common.StageRef.sheet = new common.FadeSheet(window.document.getElementById("webgl"));
	common.StageRef.sheet.fadeOut(callback);
};
common.StageRef.setCenter = function(offsetY) {
	if(offsetY == null) offsetY = 0;
	var dom = window.document.getElementById("webgl");
	var yy = window.innerHeight / 2 - common.StageRef.get_stageHeight() / 2 + common.Config.canvasOffsetY + offsetY;
	dom.style.position = "absolute";
	dom.style.zIndex = "1000";
	dom.style.top = Math.round(yy) + "px";
};
common.StageRef.get_stageWidth = function() {
	return window.innerWidth;
};
common.StageRef.get_stageHeight = function() {
	return window.innerHeight;
};
common.WSocket = function() {
};
common.WSocket.prototype = {
	init: function() {
		var win = window;
		if(win.io != null) {
			this._socket = io.connect(window.host);
			this._socket.on("server_to_client",$bind(this,this._onRecieve));
		} else {
		}
	}
	,send: function(key) {
		if(this._socket != null) this._socket.emit("client_to_server",{ value : key});
	}
	,addCallback: function(callback) {
		this._callback = callback;
	}
	,_onRecieve: function(data) {
		data.keyCode = data.value;
		if(this._callback != null) this._callback(data);
	}
};
var data = {};
data.TexLoader = function() {
};
data.TexLoader.getNearestTexture = function(url) {
	var t = THREE.ImageUtils.loadTexture(url);
	t.minFilter = 1003;
	t.magFilter = 1003;
	return t;
};
var effect = {};
effect.PostProcessing2 = function() {
	this.strength = 0;
	this._rad = 0;
	this._mode = 0;
	this._modeList = ["MODE_NORMAL","MODE_DISPLACEMENT_A","MODE_DISPLACEMENT_B","MODE_COLOR"];
};
effect.PostProcessing2.prototype = {
	init: function(scene,camera,renderer,callback) {
		this._callback = callback;
		this._scene = scene;
		this._camera = camera;
		this._renderer = renderer;
		this._renderPass = new THREE.RenderPass(scene,camera,null,new THREE.Color(16711680),0);
		this._copyPass = new THREE.ShaderPass(effect.shaders.CopyShader.getObject());
		this._composer = new THREE.EffectComposer(renderer);
		this._composer.addPass(this._renderPass);
		this._composer.renderTarget1.format = 1021;
		this._composer.renderTarget2.format = 1021;
		var s = new THREE.ShaderPass(effect.shaders.MyTiltShiftShader.getObject());
		this._composer.addPass(s);
		s.enabled = false;
		var s2 = new THREE.ShaderPass(effect.shaders.VignetteShader.getObject());
		this._displacePass = new effect.pass.DisplacementPass();
		this._displacePass.enabled = false;
		this._composer.addPass(this._displacePass);
		this._xLoopPass = new effect.pass.XLoopPass();
		this._xLoopPass.enabled = true;
		this._composer.addPass(this._xLoopPass);
		this._colorPass = new effect.pass.ColorMapPass();
		this._colorPass.enabled = false;
		this._composer.addPass(this._colorPass);
		this.changeCol();
		this._composer.addPass(this._copyPass);
		this._copyPass.clear = true;
		this._copyPass.renderToScreen = true;
		if(this._callback != null) this._callback();
		common.Dat.gui.add(this,"changeCol");
	}
	,changeCol: function() {
		this._colorPass.setMono(false);
		this._colorPass.setTexture();
	}
	,changeDisplace: function(data) {
		var _g = data.displaceType;
		switch(_g) {
		case 0:
			this._xLoopPass.enabled = false;
			this._displacePass.enabled = false;
			break;
		case 1:
			this._xLoopPass.enabled = true;
			this._xLoopPass.setTexture(false,true);
			this._displacePass.enabled = false;
			break;
		case 2:
			this._xLoopPass.enabled = false;
			this._displacePass.enabled = true;
			this._displacePass.setTexture(false,true);
			break;
		}
	}
	,nextTexture: function() {
		this._displacePass.setTexture(false,true);
	}
	,changeColor: function(data) {
		var _g = data.colorType;
		switch(_g) {
		case 0:
			this._colorPass.enabled = false;
			break;
		case 2:
			this._colorPass.enabled = true;
			this._colorPass.setMono(true);
			this._colorPass.setTexture();
			break;
		case 1:
			this._colorPass.enabled = true;
			this._colorPass.setMono(false);
			this._colorPass.setTexture();
			break;
		}
	}
	,update: function(audio) {
		this._xLoopPass.update(audio);
		this._displacePass.update(audio);
		this._colorPass.update(audio);
		this._composer.render();
	}
	,resize: function(w,h) {
		this._composer.setSize(w,h);
	}
};
effect.pass = {};
effect.pass.ColorMapPass = function() {
	this._fragment = "\r\n\t\t\t\t\tuniform sampler2D tDiffuse;\r\n\t\t\t\t\tuniform sampler2D texture;\r\n\t\t\t\t\tuniform float strength;\r\n\t\t\t\t\tuniform float counter;\r\n\t\t\t\t\tuniform float mono;\r\n\t\t\t\t\tvarying vec2 vUv;\r\n\t\t\t\t\tvoid main() {\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tvec4 texel = texture2D( tDiffuse, vUv );\r\n\t\t\t\t\t\tvec4 out1 = vec4(0.0);\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t//mono == false\r\n\t\t\t\t\tif ( mono == 0.0) {\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tvec2 pp = vec2( 0.5, fract( (texel.x+texel.y+texel.z)*0.333 ) );//akarusanioujite\t\r\n\t\t\t\t\t\t//float rr = texel.x * 2.0;\r\n\t\t\t\t\t\t//if (rr > 1.0) rr = 1.0;\r\n\t\t\t\t\t\tout1 = texture2D( texture, pp ) * 0.7 + texel * 0.2;\r\n\t\t\t\t\t\t//out1 = vec4(texel.x*0.9+0.1, 0.0, 0.0, 1.0);\r\n\t\t\t\t\t\t//out1 = vec4(texel.x*0.9+0.1, 0.0, 0.0, 1.0);\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t/*\r\n\t\t\t\t\t\tif ( pp.y < 0.5) {\r\n\t\t\t\t\t\t\t\tpp.y = pp.y * 2.0;\r\n\t\t\t\t\t\t\t\tout1 = texture2D( texture, pp ) * rr;\t\t\t\t\t\r\n\t\t\t\t\t\t}else {\r\n\t\t\t\t\t\t\t\tpp.y = (1.0 - (pp.y - 0.5) * 2.0);\t\t\t\t\r\n\t\t\t\t\t\t\t\tout1 = texture2D( texture, pp ) * rr;\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tif ( texel.x == 0.0 ) {\r\n\t\t\t\t\t\t\t\tout1 = vec4(0.0, 0.0, 0.0, 1.0);\r\n\t\t\t\t\t\t}\t\t*/\r\n\t\t\t\t\t\r\n\t\t\t\t\t}else{\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t//bakibaki\r\n\t\t\t\t\t\tfloat nn = 10000. + 9995. * sin(counter*0.01);\r\n\t\t\t\t\t\tif ( texel.x == 0.0 || mod( floor( texel.x * nn ),2.0) == 0.0 ) {\r\n\t\t\t\t\t\t\tout1.x = 0.0;\r\n\t\t\t\t\t\t\tout1.y = 0.0;\r\n\t\t\t\t\t\t\tout1.z = 0.0;\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t}else {\r\n\t\t\t\t\t\t\tout1.x = 1.0;\r\n\t\t\t\t\t\t\tout1.y = 1.0;\r\n\t\t\t\t\t\t\tout1.z = 1.0;\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t}\r\n\t\t\t\t\t\tgl_FragColor = out1;// out1;// texel;\r\n\t\t\t\t\t\t//gl_FragColor =  out1;// texel;\r\n\t\t\t\t\t}\r\n\t";
	this._vertex = "\r\n\t\tvarying vec2 vUv;\r\n\t\tvoid main() {\r\n\t\t\tvUv = uv;\r\n\t\t\tgl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );\r\n\t\t}\t\t\r\n\t";
	this._textures = [];
	this._textures.push(THREE.ImageUtils.loadTexture("../../assets/" + "grade/grade.png"));
	this._textures.push(THREE.ImageUtils.loadTexture("../../assets/" + "grade/grade2.png"));
	this._textures.push(THREE.ImageUtils.loadTexture("../../assets/" + "grade/grade3.png"));
	this._textures.push(THREE.ImageUtils.loadTexture("../../assets/" + "grade/grade4.png"));
	this._textures.push(THREE.ImageUtils.loadTexture("../../assets/" + "grade/grade5.png"));
	this._textures.push(THREE.ImageUtils.loadTexture("../../assets/" + "grade/grade6.png"));
	this._textures.push(THREE.ImageUtils.loadTexture("../../assets/" + "grade/grade7.png"));
	THREE.ShaderPass.call(this,{ uniforms : { tDiffuse : { type : "t", value : null}, texture : { type : "t", value : this._textures[0]}, strength : { type : "f", value : 0}, counter : { type : "f", value : 0}, mono : { type : "f", value : 1}}, vertexShader : this._vertex, fragmentShader : this._fragment});
};
effect.pass.ColorMapPass.__super__ = THREE.ShaderPass;
effect.pass.ColorMapPass.prototype = $extend(THREE.ShaderPass.prototype,{
	update: function(audio) {
		if(!this.enabled) return;
		this.uniforms.strength.value = Math.pow(audio.freqByteData[3] / 255,2) * 1000;
		this.uniforms.counter.value += audio.freqByteData[3] / 255 * 0.8;
	}
	,setTexture: function() {
		this.uniforms.texture.value = this._textures[Math.floor(Math.random() * this._textures.length)];
	}
	,setColor: function() {
	}
	,setMono: function(b) {
		if(b) this.uniforms.mono.value = 1; else this.uniforms.mono.value = 0;
	}
});
effect.pass.DisplacementPass = function() {
	this._dispY = 0.75;
	this._dispX = 0.3;
	this._index = 0;
	this._fragment = "\r\n\t\t\t\t\tuniform sampler2D tDiffuse;\r\n\t\t\t\t\tuniform sampler2D disTexture;\r\n\t\t\t\t\tuniform sampler2D colTexture;\r\n\t\t\t\t\tuniform float strengthX;\r\n\t\t\t\t\tuniform float strengthY;\r\n\t\t\t\t\tuniform float counter;\r\n\t\t\t\t\tuniform float isDisplace;\r\n\t\t\t\t\tuniform float isColor;\r\n\t\t\t\t\tvarying vec2 vUv;\r\n\t\t\t\t\t\r\n\t\t\t\t\tvec4 getColor(vec4 texel) {\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tvec4 out1 = vec4(0.0);\r\n\t\t\t\t\t\tvec2 pp = vec2( 0.5, fract( texel.x + counter ) );\r\n\t\t\t\t\t\t\tif ( pp.y < 0.5) {\r\n\t\t\t\t\t\t\t\tpp.y = pp.y * 2.0;\r\n\t\t\t\t\t\t\t\tout1 = texture2D( colTexture, pp );\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t}else {\r\n\t\t\t\t\t\t\t\tpp.y = (1.0 - (pp.y - 0.5) * 2.0);\t\t\t\t\r\n\t\t\t\t\t\t\t\tout1 = texture2D( colTexture, pp );\r\n\t\t\t\t\t\t\t}\r\n\t\t\t\t\t\t\tif ( texel.x == 0.0 ) {\r\n\t\t\t\t\t\t\t\tout1 = vec4(0.0, 0.0, 0.0, 0.0);\r\n\t\t\t\t\t\t\t}\t\t\r\n\t\t\t\t\t\t\treturn out1;\r\n\t\t\t\t\t}\r\n\t\t\t\t\t\r\n\t\t\t\t\tvoid main() {\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t//dispace\r\n\t\t\t\t\t\tvec4 texel = vec4(0.0);\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tif(isDisplace == 1.0){\r\n\t\t\t\t\t\t\tvec4 col = texture2D( disTexture, vUv);\r\n\t\t\t\t\t\t\tfloat f1 = strengthX * sin(counter*0.17);// pow(counter, 2.0 + 3.0 * col.x);//sin(counter * 3.9) * 0.23;\r\n\t\t\t\t\t\t\tfloat f2 = strengthY * sin(counter*0.22);// pow(counter, 2.0 + 3.0 * col.x) * 0.001;// pow(counter, 2.0 + 3.0 * col.y);//cos(counter * 3.7) * 0.23;\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\tvec2 axis = vec2( \r\n\t\t\t\t\t\t\t\tvUv.x + (col.y-0.5)*f1, vUv.y + (col.z-0.5)*f2\r\n\t\t\t\t\t\t\t);\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\ttexel = texture2D( tDiffuse, axis );\r\n\t\t\t\t\t\t}else {\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\ttexel = texture2D( tDiffuse, vUv );\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t//vec4 texel = texture2D( colTexture, axis );\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t//vec3 luma = vec3( 0.299, 0.587, 0.114 );\r\n\t\t\t\t\t\t//float v = dot( texel.xyz, luma );//akarusa\r\n\t\t\t\t\t\t//vec2 axis = vec2( 0.5,v );\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t//position\r\n\t\t\t\t\t\tvec4 out1 = vec4(0.0);\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tif( isColor == 1.0){\r\n\t\t\t\t\t\t\tout1 = getColor(texel);\r\n\t\t\t\t\t\t}else {\r\n\t\t\t\t\t\t\tout1 = texel;\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t\r\n\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t/*\r\n\t\t\t\t\t\tif ( texel.x == 0.0 || mod( floor( texel.x * 1000.0 + counter ),2.0) == 0.0 ) {\r\n\t\t\t\t\t\t\ttexel.x = 0.0;\r\n\t\t\t\t\t\t\ttexel.y = 0.0;\r\n\t\t\t\t\t\t\ttexel.z = 0.0;\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t}else {\r\n\t\t\t\t\t\t\ttexel.x = out1.x;//1.0;\r\n\t\t\t\t\t\t\ttexel.y = out1.y;//1.0;\r\n\t\t\t\t\t\t\ttexel.z = out1.z;//1.0;\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t}*/\r\n\t\t\t\t\t\t/*\r\n\t\t\t\t\t\t\ttexel.x = out1.x;//1.0;\r\n\t\t\t\t\t\t\ttexel.y = out1.y;//1.0;\r\n\t\t\t\t\t\t\ttexel.z = out1.z;//1.0;\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t*/\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tgl_FragColor = out1;\r\n\t\t\t\t\t\t//gl_FragColor =  out1;// texel;\r\n\t\t\t\t\t}\r\n\t";
	this._vertex = "\r\n\t\tvarying vec2 vUv;\r\n\t\tvoid main() {\r\n\t\t\tvUv = uv;\r\n\t\t\tgl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );\r\n\t\t}\t\t\r\n\t";
	this._textures = [];
	this._textures.push(data.TexLoader.getNearestTexture("../../assets/" + "displace/displaceV2.png"));
	this._textures.push(data.TexLoader.getNearestTexture("../../assets/" + "displace/displaceA.png"));
	this._textures.push(data.TexLoader.getNearestTexture("../../assets/" + "displace/displace.png"));
	this._textures.push(data.TexLoader.getNearestTexture("../../assets/" + "displace/displaceH.png"));
	this._colors = [THREE.ImageUtils.loadTexture("../../assets/" + "/grade/grade.png"),THREE.ImageUtils.loadTexture("../../assets/" + "/grade/grade2.png"),THREE.ImageUtils.loadTexture("../../assets/" + "/grade/grade3.png"),THREE.ImageUtils.loadTexture("../../assets/" + "/grade/grade4.png")];
	THREE.ShaderPass.call(this,{ uniforms : { tDiffuse : { type : "t", value : null}, isDisplace : { type : "f", value : 1}, isColor : { type : "f", value : 1}, disTexture : { type : "t", value : this._textures[0]}, colTexture : { type : "t", value : this._colors[3]}, strengthX : { type : "f", value : 0}, strengthY : { type : "f", value : 0}, counter : { type : "f", value : 0}}, vertexShader : this._vertex, fragmentShader : this._fragment});
	common.Dat.gui.add(this,"_dispX",0,1).step(0.01).listen();
	common.Dat.gui.add(this,"_dispY",0,1).step(0.01).listen();
};
effect.pass.DisplacementPass.__super__ = THREE.ShaderPass;
effect.pass.DisplacementPass.prototype = $extend(THREE.ShaderPass.prototype,{
	update: function(audio) {
		if(!this.enabled) return;
		this.uniforms.strengthX.value = Math.pow(audio.freqByteData[3] / 255,4) * this._dispX;
		this.uniforms.strengthY.value = Math.pow(audio.freqByteData[7] / 255,4) * this._dispY;
		this.uniforms.counter.value += audio.freqByteData[3] / 255 * 0.8;
	}
	,setTexture: function(isColor,isDisplace) {
		if(isColor) this.uniforms.isColor.value = 1; else this.uniforms.isColor.value = 0;
		if(isDisplace) this.uniforms.isDisplace.value = 1; else this.uniforms.isDisplace.value = 0;
		this.uniforms.disTexture.value = this._textures[this._index % this._textures.length];
		this.uniforms.colTexture.value = this._colors[this._index % this._colors.length];
		this._index++;
	}
});
effect.pass.XLoopPass = function() {
	this._fragment = "\r\n\t\t\t\t\tuniform sampler2D tDiffuse;\r\n\t\t\t\t\t//uniform sampler2D disTexture;\r\n\t\t\t\t\t//uniform sampler2D colTexture;\r\n\t\t\t\t\tuniform float strength;\r\n\t\t\t\t\tuniform float counter;\r\n\t\t\t\t\tuniform float isDisplace;\r\n\t\t\t\t\tuniform float isColor;\r\n\t\t\t\t\tvarying vec2 vUv;\r\n\t\t\t\t\t\r\n\t\t\t\t\tfloat yama(float rr, float beki) {\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tfloat hoge = 0.5 + 0.5 * sin(rr * 3.14 - 3.14 * 0.5);\r\n\t\t\t\t\t\t//out = pow(out, beki);\r\n\t\t\t\t\t\treturn hoge;// out;\r\n\t\t\t\t\t\r\n\t\t\t\t\t}\r\n\r\n\t\t\t\t\tfloat yama2(float rr, float beki) {\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tfloat hoge = rr * 2.0;\r\n\t\t\t\t\t\tif ( hoge < 1.0) {\r\n\t\t\t\t\t\t\thoge = pow(hoge, 1./beki) * 0.5;\r\n\t\t\t\t\t\t}else {\r\n\t\t\t\t\t\t\thoge = pow(hoge-1.0, beki) * 0.5 + 0.5;\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t\t//out = pow(out, beki);\r\n\t\t\t\t\t\treturn hoge;// out;\r\n\t\t\t\t\t\r\n\t\t\t\t\t}\r\n\t\t\t\t\t\r\n\t\t\t\t\t\r\n\t\t\t\t\tvoid main() {\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t//dispace\r\n\t\t\t\t\t\tvec4 texel = vec4(0.0);\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t//0.4-0.6 no hani wo kurikaesu\r\n\t\t\t\t\t\tfloat minX = 0.45;\r\n\t\t\t\t\t\tfloat maxX = 0.55;\r\n\t\t\t\t\t\tfloat amp = maxX - minX;\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t//float xx = clamp( vUv.x, minX, maxX );\r\n\t\t\t\t\t\t//xx = (xx - minX) / len;//0-1\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\tfloat nn = 10. * sin( counter * 0.07 );\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\tfloat xx = minX + amp * (0.5 + 0.5 * sin(yama2(vUv.x, 2.0) * nn * 3.14 - 3.14 * 0.5));\r\n\t\t\t\t\t\tfloat minA = 0.3;// 1;\r\n\t\t\t\t\t\tfloat maxA = 0.7;// 9;\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tif (vUv.x < minA) {\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\txx = xx * pow(vUv.x / minA, 0.2);\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t}else if (vUv.x > maxA) {\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\txx = mix(xx, vUv.x, pow((vUv.x - maxA) / (1.0 - maxA), 7.0));\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\txx += 0.01 * sin(vUv.y * 2. * 3.14);\r\n\t\t\t\t\t\tfloat yy = vUv.y + 0.05 * sin(vUv.x * 6.0 * 3.14);\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t//float ss = strength;\r\n\t\t\t\t\t\tfloat ss = 0.5 + 0.5 * sin(counter * 0.1);\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tss = ss * strength * vUv.y;\r\n\t\t\t\t\t\txx = mix(vUv.x, xx, ss );\r\n\t\t\t\t\t\tyy = mix(vUv.y, yy, ss );\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t//xx = 0.5+0.5*sin( 2.*3.14*vUv.x -3.14/2.0);\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t//xx = 0.5 + 0.5 * sin(xx * 2.0 * 3.14 * 5.0);\r\n\t\t\t\t\t\t//vUv.x\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tvec2 axis = vec2( xx, yy );\r\n\t\t\t\t\t\ttexel = texture2D( tDiffuse, axis );\r\n\t\t\t\t\t\tvec4 out1 = texel;\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\tgl_FragColor = out1;\r\n\t\t\t\t\t\t//gl_FragColor =  out1;// texel;\r\n\t\t\t\t\t}\r\n\t";
	this._vertex = "\r\n\t\tvarying vec2 vUv;\r\n\t\tvoid main() {\r\n\t\t\tvUv = uv;\r\n\t\t\tgl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );\r\n\t\t}\t\t\r\n\t";
	this._textures = [];
	THREE.ShaderPass.call(this,{ uniforms : { tDiffuse : { type : "t", value : null}, isDisplace : { type : "f", value : 1}, isColor : { type : "f", value : 1}, strength : { type : "f", value : 0}, counter : { type : "f", value : 0}}, vertexShader : this._vertex, fragmentShader : this._fragment});
};
effect.pass.XLoopPass.__super__ = THREE.ShaderPass;
effect.pass.XLoopPass.prototype = $extend(THREE.ShaderPass.prototype,{
	update: function(audio) {
		if(!this.enabled) return;
		this.uniforms.strength.value = 0.7 + audio.freqByteData[5] / 255 * 0.3;
		this.uniforms.counter.value += audio.freqByteData[3] / 255 * 0.8;
	}
	,setTexture: function(isColor,isDisplace) {
		if(isColor) this.uniforms.isColor.value = 1; else this.uniforms.isColor.value = 0;
		if(isDisplace) this.uniforms.isDisplace.value = 1; else this.uniforms.isDisplace.value = 0;
	}
});
effect.shaders = {};
effect.shaders.CopyShader = function() {
};
effect.shaders.CopyShader.getObject = function() {
	var obj = { uniforms : { tDiffuse : { type : "t", value : null}, opacity : { type : "f", value : 1.0}}, vertexShader : "varying vec2 vUv;\r\n\r\n\t\t\t\tvoid main() {\r\n\r\n\t\t\t\t\tvUv = uv;\r\n\t\t\t\t\tgl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );\r\n\r\n\t\t\t\t}", fragmentShader : "uniform float opacity;\r\n\t\t\t\tuniform sampler2D tDiffuse;\r\n\r\n\t\t\t\tvarying vec2 vUv;\r\n\t\t\t\tvoid main() {\r\n\t\t\t\t\tvec4 texel = texture2D( tDiffuse, vUv );\r\n\t\t\t\t\tgl_FragColor = opacity * texel;\r\n\t\t\t\t}"};
	return obj;
};
effect.shaders.MyTiltShiftShader = function() {
};
effect.shaders.MyTiltShiftShader.getObject = function() {
	return { uniforms : { tDiffuse : { type : "t", value : null}, v : { type : "f", value : 0.0021484375}, r : { type : "f", value : 0.5}, k : { type : "fv1", value : [1.0,4.0,6.0,4.0,1.0,4.0,16.0,24.0,16.0,4.0,6.0,24.0,36.0,24.0,6.0,4.0,16.0,24.0,16.0,4.0,1.0,4.0,6.0,4.0,1.0]}}, vertexShader : "\r\n\t\t\t\tvarying vec2 vUv;\r\n\t\t\t\tvoid main() {\r\n\t\t\t\t\tvUv = uv;\r\n\t\t\t\t\tgl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );\r\n\t\t\t\t}", fragmentShader : "\r\n\t\t\t\tuniform sampler2D tDiffuse;\r\n\t\t\t\tuniform float v;\r\n\t\t\t\tuniform float r;\r\n\t\t\t\tuniform float k[25];\r\n\t\t\t\tvarying vec2 vUv;\r\n\r\n\t\t\t\tvoid main() {\r\n\r\n\t\t\t\t\tvec4 sum = vec4( 0.0 );\r\n\t\t\t\t\tfloat vv = v * abs( r - vUv.y );\r\n\t\t\t\t\t\r\n\t\t\t\t\tfor(float i=-1.0;i<=1.0;i++){\r\n\t\t\t\t\t\tfor(float j = -1.0; j <=1.0; j++) {\r\n\t\t\t\t\t\t\tsum += texture2D( tDiffuse, vec2( vUv.x + i * vv, vUv.y + j * vv ) ) / 9.0;\r\n\t\t\t\t\t\t\t//idx += 1;\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t}\r\n\t\t\t\t\t\r\n\t\t\t\t\tgl_FragColor = sum;\r\n\r\n\t\t\t\t}"};
};
effect.shaders.VignetteShader = function() {
};
effect.shaders.VignetteShader.getObject = function() {
	return { uniforms : { tDiffuse : { type : "t", value : null}, fl : { type : "f", value : 0.0}, offset : { type : "f", value : 1.0}, darkness : { type : "f", value : 1}, k : { type : "fv1", value : [1.0,4.0,6.0,4.0,1.0,4.0,16.0,24.0,16.0,4.0,6.0,24.0,36.0,24.0,6.0,4.0,16.0,24.0,16.0,4.0,1.0,4.0,6.0,4.0,1.0]}, mcolor : { type : "v3", value : new THREE.Vector3(1.1,1.05,1.0)}, ocolor : { type : "v3", value : new THREE.Vector3(-0.02,-0.04,-0.06)}}, vertexShader : "varying vec2 vUv;\r\n\t\t\t\tvoid main() {\r\n\t\t\t\t\tvUv = uv;\r\n\t\t\t\t\tgl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );\r\n\t\t\t\t}", fragmentShader : "uniform float offset;\r\n\t\t\t\tuniform float darkness;\r\n\t\t\t\tuniform float fl;\r\n\t\t\t\tuniform sampler2D tDiffuse;\r\n\t\t\t\tvarying vec2 vUv;\r\n\t\t\t\tuniform float k[25];\r\n\t\t\t\tuniform vec3 mcolor;\r\n\t\t\t\tuniform vec3 ocolor;\r\n\t\t\t\t\r\n\t\t\t\tvoid main() {\r\n\t\t\t\t\tvec4 texel = vec4( 0.0 );\r\n\t\t\t\t\t\r\n\t\t\t\t\tfloat vx = 1.0 / 1280.0;\r\n\t\t\t\t\tfloat vy = 1.0 / 720.0;\r\n\t\t\t\t\t\r\n\t\t\t\t\ttexel = texture2D( tDiffuse, vUv);\r\n\t\t\t\t\t//filter\r\n\t\t\t\t\t/*\r\n\t\t\t\t\ttexel += texture2D( tDiffuse, vec2( vUv.x - vx, vUv.y - vy ) ) * 1.0/16.0;\r\n\t\t\t\t\ttexel += texture2D( tDiffuse, vec2( vUv.x, vUv.y - vy ) ) * 2.0/16.0;\r\n\t\t\t\t\ttexel += texture2D( tDiffuse, vec2( vUv.x + vx, vUv.y - vy ) ) * 1.0/16.0;\r\n\t\t\t\t\t\r\n\t\t\t\t\ttexel += texture2D( tDiffuse, vec2( vUv.x - vx, vUv.y ) ) * 2.0 / 16.0;\r\n\t\t\t\t\ttexel += texture2D( tDiffuse, vec2( vUv.x, vUv.y ) ) * 4.0 / 16.0;\r\n\t\t\t\t\ttexel += texture2D( tDiffuse, vec2( vUv.x + vx, vUv.y ) ) * 2.0 / 16.0;\r\n\t\t\t\t\t\r\n\t\t\t\t\ttexel += texture2D( tDiffuse, vec2( vUv.x - vx, vUv.y + vy ) ) * 1.0/16.0;\r\n\t\t\t\t\ttexel += texture2D( tDiffuse, vec2( vUv.x, vUv.y + vy ) ) * 2.0/16.0;\r\n\t\t\t\t\ttexel += texture2D( tDiffuse, vec2( vUv.x + vx, vUv.y + vy ) ) * 1.0/16.0;\r\n\t\t\t\t\t*/\r\n\t\t\t\t\t\r\n\t\t\t\t\tvec2 uv = ( vUv - vec2( 0.5 ) ) * vec2( offset );\r\n\t\t\t\t\tfloat l = 1.0 - darkness;\r\n\t\t\t\t\t\r\n\t\t\t\t\t//float offset = \r\n\t\t\t\t\tvec3 col = mix( texel.rgb, vec3( l, l,l ), dot( uv, uv ) );\r\n\t\t\t\t\tcol = col + vec3(0.00, 0.06, 0.12);\r\n\t\t\t\t\tcol = col + vec3(fl, fl, fl);\r\n\t\t\t\t\t\r\n\t\t\t\t\tcol.x = col.x * mcolor.x + ocolor.x;// 2.0;\r\n\t\t\t\t\tcol.y = col.y * mcolor.y + ocolor.y;// 1.5;\r\n\t\t\t\t\tcol.z = col.z * mcolor.z + ocolor.z;// 1.0;\t\r\n\t\t\t\t\t\r\n\t\t\t\t\tgl_FragColor = vec4( col, texel.a );\r\n\t\t\t\t}"};
};
var haxe = {};
haxe.Http = function(url) {
	this.url = url;
	this.headers = new List();
	this.params = new List();
	this.async = true;
};
haxe.Http.prototype = {
	request: function(post) {
		var me = this;
		me.responseData = null;
		var r = this.req = js.Browser.createXMLHttpRequest();
		var onreadystatechange = function(_) {
			if(r.readyState != 4) return;
			var s;
			try {
				s = r.status;
			} catch( e ) {
				s = null;
			}
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) {
				me.req = null;
				me.onData(me.responseData = r.responseText);
			} else if(s == null) {
				me.req = null;
				me.onError("Failed to connect or resolve host");
			} else switch(s) {
			case 12029:
				me.req = null;
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.req = null;
				me.onError("Unknown host");
				break;
			default:
				me.req = null;
				me.responseData = r.responseText;
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var $it0 = this.params.iterator();
			while( $it0.hasNext() ) {
				var p = $it0.next();
				if(uri == null) uri = ""; else uri += "&";
				uri += encodeURIComponent(p.param) + "=" + encodeURIComponent(p.value);
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e1 ) {
			me.req = null;
			this.onError(e1.toString());
			return;
		}
		if(!Lambda.exists(this.headers,function(h) {
			return h.header == "Content-Type";
		}) && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var $it1 = this.headers.iterator();
		while( $it1.hasNext() ) {
			var h1 = $it1.next();
			r.setRequestHeader(h1.header,h1.value);
		}
		r.send(uri);
		if(!this.async) onreadystatechange(null);
	}
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
};
haxe.ds = {};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
};
var js = {};
js.Browser = function() { };
js.Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw "Unable to create XMLHttpRequest object.";
};
var net = {};
net.badimon = {};
net.badimon.five3D = {};
net.badimon.five3D.typography = {};
net.badimon.five3D.typography.Typography3D = function() {
	this.motifs = new haxe.ds.StringMap();
	this.widths = new haxe.ds.StringMap();
};
net.badimon.five3D.typography.Typography3D.prototype = {
	getMotif: function($char) {
		return this.motifs.get($char);
	}
	,getWidth: function($char) {
		return this.widths.get($char);
	}
	,getHeight: function() {
		return this.height;
	}
};
net.badimon.five3D.typography.GenTypography3D = function() {
	net.badimon.five3D.typography.Typography3D.call(this);
};
net.badimon.five3D.typography.GenTypography3D.__super__ = net.badimon.five3D.typography.Typography3D;
net.badimon.five3D.typography.GenTypography3D.prototype = $extend(net.badimon.five3D.typography.Typography3D.prototype,{
	init: function(uri,callback) {
		this._callback = callback;
		var http = new haxe.Http(uri);
		http.onData = $bind(this,this._onLoad);
		http.request(false);
	}
	,initByString: function(jsonStr) {
		this._onLoad(jsonStr);
	}
	,_onLoad: function(data) {
		var o = JSON.parse(data);
		var _g = 0;
		var _g1 = Reflect.fields(o);
		while(_g < _g1.length) {
			var key = _g1[_g];
			++_g;
			if(key == "height") this.height = Reflect.getProperty(o,key); else this._initTypo(key,Reflect.getProperty(o,key));
		}
		this._callback();
	}
	,_initTypo: function(key,ary) {
		this.widths.set(key,ary[0]);
		var motif = [];
		var _g1 = 1;
		var _g = ary.length;
		while(_g1 < _g) {
			var i = _g1++;
			motif.push(this._initAry(ary[i]));
		}
		this.motifs.set(key,motif);
	}
	,_initAry: function(str) {
		var list = str.split(",");
		var out = [];
		out[0] = list[0];
		if(out[0] == "C") out[1] = [Std.parseFloat(list[1]),Std.parseFloat(list[2]),Std.parseFloat(list[3]),Std.parseFloat(list[4])]; else out[1] = [Std.parseFloat(list[1]),Std.parseFloat(list[2])];
		return out;
	}
});
var objects = {};
objects.CgBg = function() {
	THREE.Object3D.call(this);
};
objects.CgBg.__super__ = THREE.Object3D;
objects.CgBg.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		this._ground = new THREE.Mesh(new THREE.PlaneBufferGeometry(2000,2000,10,10),new THREE.MeshBasicMaterial({ color : 16776960, wireframe : true}));
		this._ground.rotation.x = Math.PI / 2;
	}
	,show: function() {
		this.visible = true;
	}
	,hide: function() {
		this.visible = false;
	}
});
objects.Mojis = function() {
	this._offsetY = 0;
	this._faces = [];
	this._rad = 0;
	THREE.Object3D.call(this);
};
objects.Mojis.__super__ = THREE.Object3D;
objects.Mojis.prototype = $extend(THREE.Object3D.prototype,{
	init: function(callback) {
		this._callback = callback;
		this._shape = new FontShapeMaker();
		this._shape.init("AOTFProM4.json",$bind(this,this._onInitA));
	}
	,_onInitA: function() {
		this._loader = new objects.MyDAELoader();
		this._loader.load($bind(this,this._onInit0));
	}
	,_onInit0: function() {
		var all = "北千住デザイン";
		var list = [];
		var nn = 8;
		var _g1 = 0;
		var _g = Math.floor(all.length / nn + 1);
		while(_g1 < _g) {
			var i = _g1++;
			list.push(HxOverrides.substr(all,i * nn,nn));
		}
		var space = 200;
		var spaceY = 250;
		var g = new THREE.Geometry();
		var _g11 = 0;
		var _g2 = list.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			var src = list[i1];
			var _g3 = 0;
			var _g21 = src.length;
			while(_g3 < _g21) {
				var j = _g3++;
				var shapes = this._shape.getShapes(HxOverrides.substr(src,j,1),true);
				var geo = new THREE.ExtrudeGeometry(shapes,{ bevelEnabled : true, amount : 50});
				var mat4 = new THREE.Matrix4();
				mat4.multiply(new THREE.Matrix4().makeScale(2,2,2));
				var vv = new THREE.Vector3((j * space - (nn - 1) / 2 * space) * 0.5,-i1 * spaceY * 0.5,0);
				mat4.multiply(new THREE.Matrix4().makeTranslation(vv.x,vv.y,vv.z));
				g.merge(geo,mat4);
			}
		}
		this._texture = THREE.ImageUtils.loadTexture("../../assets/" + "face/dede_face_diff.png");
		this._material = new THREE.MeshPhongMaterial({ color : 16777215, map : this._texture});
		this._material.clippingPlanes = [new THREE.Plane(new THREE.Vector3(0,1,0),0.8)];
		this._material.clipShadows = true;
		this._material.side = 2;
		this._meshes = [];
		var _g4 = 0;
		while(_g4 < 4) {
			var i2 = _g4++;
			var m = new THREE.Mesh(g,this._material);
			m.castShadow = true;
			var rr = Math.random() * 0.1;
			m.scale.set(0.2 + rr,0.2 + rr,0.2 + rr);
			m.position.y += 60 * (Math.random() - 0.5);
			this._meshes.push(m);
		}
		var _g5 = 0;
		while(_g5 < 4) {
			var i3 = _g5++;
			var face = new objects.MyFaceSingle(0);
			face.init(this._loader,null);
			face.dae.material = this._material;
			face.dae.castShadow = true;
			var ss = 40 + 10 * Math.random();
			face.dae.scale.set(ss,ss,ss);
			face.dae.position.x = 20 * (Math.random() - 0.5);
			face.dae.position.y = i3 * -250;
			face.dae.position.z = 20 * (Math.random() - 0.5);
			this.add(face.dae);
			this._faces.push(face);
		}
		if(this._callback != null) this._callback();
	}
	,setEnvMap: function(texture) {
		this._material.envMap = texture;
		if(this._eyeball != null) this._eyeball.material.envMap = texture;
	}
	,update: function(a) {
		if(this._texture != null) {
		}
		if(this._eyeball != null) {
			this._eyeball.rotation.x += 0.01;
			this._eyeball.rotation.y += 0.015;
			this._eyeball.rotation.z += 0.018;
		}
		if(this._faces.length > 0) {
			var _g1 = 0;
			var _g = this._faces.length;
			while(_g1 < _g) {
				var i = _g1++;
				this._faces[i].dae.rotation.y += 0.03 + i / 340;
				this._faces[i].updateSingle(a);
				this._faces[i].dae.position.y += 0.4;
				if(this._faces[i].dae.position.y > 500) {
					this._faces[i].dae.position.y = -500;
					this._faces[i].dae.rotation.set(0,Math.random() * 2 * Math.PI,0);
					var ss = 50 + 30 * Math.random();
					this._faces[i].dae.scale.set(ss,ss,ss);
					this._faces[i].changeIndex(i);
				}
			}
		}
		var _g11 = 0;
		var _g2 = this._meshes.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			this._meshes[i1].rotation.x += 0.001 * (i1 + 1);
			this._meshes[i1].rotation.y += 0.003 * (i1 + 1);
			this._meshes[i1].rotation.z += 0.004 * (i1 + 1);
			this._meshes[i1].position.y = 100 * Math.sin(this._rad + Math.PI / 2) + i1 * 10;
		}
	}
});
objects.MyDAELoader = function() {
};
objects.MyDAELoader.getPosY = function(ratio) {
	ratio = 1 - ratio;
	var maxY = 1.36578;
	var minY = -1.13318;
	return minY + (maxY - minY) * ratio;
};
objects.MyDAELoader.getRatioY = function(posY) {
	var maxY = 1.36578;
	var minY = -1.13318;
	return (posY - minY) / (maxY - minY);
};
objects.MyDAELoader.getHeight = function(ratio) {
	return 2.49896000000000029 * ratio;
};
objects.MyDAELoader.prototype = {
	load: function(callback) {
		this._callback = callback;
		var loader = new THREE.ColladaLoader();
		loader.options.convertUpAxis = true;
		loader.load("../../assets/" + "face/dede_c4d.dae",$bind(this,this._onComplete));
	}
	,_onComplete: function(collada) {
		this.dae = collada.scene;
		this.dae.scale.x = this.dae.scale.y = this.dae.scale.z = 150;
		var url = "face/Texture_001.jpg";
		this.geometry = this.dae.children[0].children[0].geometry;
		this.geometry.verticesNeedUpdate = true;
		this.baseGeo = [];
		this.baseAmp = [];
		this.baseRadX = [];
		this.baseRadY = [];
		var max = new THREE.Vector3();
		var min = new THREE.Vector3();
		var _g1 = 0;
		var _g = this.geometry.vertices.length;
		while(_g1 < _g) {
			var i = _g1++;
			var vv = this.geometry.vertices[i].clone();
			var a = vv.length();
			this.baseGeo.push(vv);
			this.baseAmp.push(a);
			this.baseRadX.push(-Math.atan2(vv.z,vv.x));
			this.baseRadY.push(Math.asin(vv.y / a));
			max.x = Math.max(vv.x,max.x);
			max.y = Math.max(vv.y,max.y);
			max.z = Math.max(vv.z,max.z);
			min.x = Math.min(vv.x,min.x);
			min.y = Math.min(vv.y,min.y);
			min.z = Math.min(vv.z,min.z);
		}
		if(this._callback != null) this._callback();
	}
	,changeMap: function(isWire) {
		if(!isWire) this.material.map = this._texture1; else if(Math.random() < 0.5) this.material.map = this._texture2; else this.material.map = this._texture3;
	}
};
objects.MyFaceSingle = function(idx) {
	this._mode = "";
	this.index = 0;
	this.isActive = true;
	this.isSplit = false;
	this.borderHeight = 0;
	this.border = 0;
	this._bottom = false;
	this._idxZengoRatio = 19;
	this._idxYokoSpeed = 13;
	this._idxYokoRatio = 5;
	this._idxScale = 1;
	this._idxNoiseSpeed = 19;
	this._idxSphere = 4;
	this._idxSpeed = 8;
	this._idxNoise = 12;
	this._idxNejireY = 18;
	this._idxNejireX = 16;
	this.music = "";
	this.vr = 0;
	this._scale = 1;
	this._zengoRatio = 0;
	this._yokoSpeed = 0;
	this._yokoRatio = 0;
	this._noiseSpeed = 0.1;
	this._noise = 0.8;
	this._nejireY = 0;
	this._nejireX = 0.5;
	this._sphere = 0.1;
	this._speed = 0.01;
	this._count = 0;
	this.s = 1;
	this.index = idx;
	THREE.Object3D.call(this);
};
objects.MyFaceSingle.__super__ = THREE.Object3D;
objects.MyFaceSingle.prototype = $extend(THREE.Object3D.prototype,{
	init: function(d,cubecam) {
		if(common.Dat.bg) return;
		this._daeLoader = d;
		this.dae = new THREE.Mesh(this._daeLoader.geometry.clone(),new THREE.MeshDepthMaterial());
		if(this.index == 0) this.dae.castShadow = true;
		this.dae.scale.set(70,70,70);
		this.add(this.dae);
		this._base = d.baseGeo;
		this._baseAmp = d.baseAmp;
		this._baseRadX = d.baseRadX;
		this._baseRadY = d.baseRadY;
		this.vr = (Math.random() - 0.5) * Math.PI / 140;
	}
	,changeIndex: function(idx) {
		if(idx == null) idx = 0;
		if(idx % 2 == 0) {
			this._idxNejireX = 16;
			this._idxNejireY = 18;
			this._idxNoise = 12;
			this._idxSpeed = 8;
			this._idxSphere = 4;
			this._idxNoiseSpeed = 19;
			this._idxScale = 1;
			this._idxYokoRatio = 5;
			this._idxYokoSpeed = 13;
			this._idxZengoRatio = 19;
		} else {
			this._idxNejireX = Math.floor(20 * Math.random());
			this._idxNejireY = Math.floor(20 * Math.random());
			this._idxNoise = Math.floor(20 * Math.random());
			this._idxSpeed = Math.floor(20 * Math.random());
			this._idxSphere = Math.floor(20 * Math.random());
			this._idxNoiseSpeed = Math.floor(20 * Math.random());
			this._idxScale = Math.floor(20 * Math.random());
			this._idxYokoRatio = Math.floor(20 * Math.random());
			this._idxYokoSpeed = Math.floor(20 * Math.random());
			this._idxZengoRatio = Math.floor(20 * Math.random());
		}
	}
	,_getNoise: function(xx,yy,zz) {
		var f = noise.perlin3;
		var n = f(xx,yy,zz);
		return n;
	}
	,updateSingle: function(audio) {
		if(common.Dat.bg) return;
		if(this.dae == null) return;
		this._audio = audio;
		var g = this.dae.geometry;
		g.verticesNeedUpdate = true;
		this._count += this._speed;
		if(this._audio != null && this._audio.isStart) {
			this._audio.update();
			if(this._audio.freqByteData.length > 19) {
				this._nejireX = Math.pow(this.s * this._audio.freqByteData[this._idxNejireX] / 255,1.5) * 10;
				this._nejireY = Math.pow(this.s * this._audio.freqByteData[this._idxNejireY] / 255,2) * Math.PI * 2;
				this._noise = Math.pow(this.s * this._audio.freqByteData[this._idxNoise] / 255,1) * 4.5;
				this._speed = Math.pow(this.s * this._audio.freqByteData[this._idxSpeed] / 255,2) * 0.5;
				this._sphere = Math.pow(this.s * this._audio.freqByteData[this._idxSphere] / 255,5);
				this._noiseSpeed = 0.1 + Math.pow(this.s * this._audio.freqByteData[this._idxNoiseSpeed] / 255,4) * 0.05;
				this._scale = 1 + Math.pow(this.s * this._audio.freqByteData[this._idxScale] / 255,3) * 0.4;
				this._yokoRatio = Math.pow(this.s * this._audio.freqByteData[this._idxYokoRatio] / 255,2);
				this._yokoSpeed = Math.pow(this.s * this._audio.freqByteData[this._idxYokoSpeed] / 255,2) * 4;
				this._zengoRatio = Math.pow(this.s * this._audio.freqByteData[this._idxZengoRatio] / 255,2);
			}
		} else return;
		var _g1 = 0;
		var _g = g.vertices.length;
		while(_g1 < _g) {
			var i = _g1++;
			var vv = this._base[i];
			var a = this._baseAmp[i];
			var radX = this._baseRadX[i] + vv.y * Math.sin(this._count) * this._nejireX;
			var radY = this._baseRadY[i];
			var amp = (1 - this._sphere) * a + this._sphere;
			amp += Math.sin(this._count * 0.7) * this._getNoise(vv.x,vv.y + this._count * this._noiseSpeed,vv.z) * this._noise;
			var yoko = Math.sin(0.5 * (vv.y * 2 * Math.PI) + this._count * this._yokoSpeed) * this._yokoRatio;
			var zengo = Math.cos(0.5 * (vv.y * 2 * Math.PI) + this._count * 3) * 0.2 * this._zengoRatio;
			var tgtX = amp * Math.sin(radX) * Math.cos(radY) + zengo;
			var tgtY = amp * Math.sin(radY);
			var tgtZ = amp * Math.cos(radX) * Math.cos(radY) + yoko;
			g.vertices[i].x += (tgtX - g.vertices[i].x) / 2;
			g.vertices[i].y += (tgtY - g.vertices[i].y) / 2;
			g.vertices[i].z += (tgtZ - g.vertices[i].z) / 2;
			if(this.isSplit) this._splitSpirit(g.vertices[i],tgtX,tgtY,tgtZ);
		}
		g.computeVertexNormals();
	}
	,_splitSpirit: function(vv,tgtX,tgtY,tgtZ) {
		var border1 = this.border + this.borderHeight / 2;
		var border2 = this.border - this.borderHeight / 2;
		if(tgtY > border1) this._splitSpirit2(border1,vv,tgtX,tgtY,tgtZ); else if(tgtY < border2) this._splitSpirit2(border2,vv,tgtX,tgtY,tgtZ);
	}
	,_splitSpirit2: function(th,vv,tgtX,tgtY,tgtZ) {
		var dy = tgtY - th;
		var dist = Math.abs(dy);
		var ratio = dist / 0.4;
		if(ratio > 1) ratio = 1;
		ratio = 1 - ratio;
		ratio = Math.pow(ratio,0.1);
		vv.x = tgtX * ratio;
		vv.z = tgtZ * ratio;
		vv.y = th - dy / 100;
	}
});
objects.data = {};
objects.data.EffectData = function(o) {
	this.wireframe = false;
	this.name = "";
	this.strength = 1;
	this.displaceType = 0;
	this.colorType = 0;
	if(o != null) {
		this.name = o.name;
		this.colorType = o.colorType;
		this.displaceType = o.displaceType;
		this.strength = o.strength;
		this.wireframe = o.wireframe;
	}
};
objects.data.EffectData.getNext = function() {
	objects.data.EffectData._count++;
	objects.data.EffectData._count = objects.data.EffectData._count % objects.data.EffectData.effects.length;
	return objects.data.EffectData.effects[objects.data.EffectData._count];
};
objects.data.EffectData.getPrev = function() {
	objects.data.EffectData._count--;
	if(objects.data.EffectData._count < 0) objects.data.EffectData._count = objects.data.EffectData.effects.length - 1;
	return objects.data.EffectData.effects[objects.data.EffectData._count];
};
var sound = {};
sound.MyAudio = function() {
	this.globalVolume = 0.897;
	this.isStart = false;
	this.freqByteDataAryEase = [];
	this._impulse = [];
};
sound.MyAudio.prototype = {
	init: function(callback) {
		this.globalVolume = common.Config.globalVol;
		this._callback = callback;
		sound.MyAudio.a = this;
		var nav = window.navigator;
		nav.getUserMedia = nav.getUserMedia || nav.webkitGetUserMedia || nav.mozGetUserMedia || nav.msGetUserMedia;
		nav.getUserMedia({ audio : true},$bind(this,this._handleSuccess),$bind(this,this._handleError));
	}
	,_handleError: function(evt) {
		window.alert("err");
	}
	,_handleSuccess: function(evt) {
		var audioContext = new AudioContext();
		var source = audioContext.createMediaStreamSource(evt);
		this.analyser = audioContext.createAnalyser();
		this.analyser.fftSize = 64;
		this._impulse = [];
		this.subFreqByteData = [];
		this.freqByteDataAry = [];
		this._oldFreqByteData = [];
		var _g = 0;
		while(_g < 64) {
			var i = _g++;
			this.subFreqByteData[i] = 0;
			this.freqByteDataAryEase[i] = 0;
			this._oldFreqByteData[i] = 0;
		}
		source.connect(this.analyser,0);
		this.isStart = true;
		common.Dat.gui.add(this,"globalVolume",0,3.00).step(0.01).listen();
		common.Dat.gui.add(this,"setImpulse");
		this.setImpulse();
		this.update();
		this._callback();
	}
	,update: function() {
		if(!this.isStart) {
			console.log("not work");
			return;
		}
		this.freqByteData = new Uint8Array(this.analyser.frequencyBinCount);
		this.analyser.getByteFrequencyData(this.freqByteData);
		var _g1 = 0;
		var _g = this.freqByteData.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.subFreqByteData[i] = this.freqByteData[i] - this._oldFreqByteData[i];
		}
		var _g11 = 0;
		var _g2 = this.freqByteData.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			this._oldFreqByteData[i1] = this.freqByteData[i1];
		}
		this.timeData = new Uint8Array(this.analyser.fftSize);
		this.analyser.getByteTimeDomainData(this.timeData);
		var _g12 = 0;
		var _g3 = this.freqByteData.length;
		while(_g12 < _g3) {
			var i2 = _g12++;
			this.freqByteData[i2] = Math.floor(this.freqByteData[i2] * this.globalVolume) + Math.floor(this._impulse[i2]);
		}
		var _g13 = 0;
		var _g4 = this.freqByteData.length;
		while(_g13 < _g4) {
			var i3 = _g13++;
			this.subFreqByteData[i3] = Math.floor(this.subFreqByteData[i3] * this.globalVolume);
		}
		var _g14 = 0;
		var _g5 = this.freqByteData.length;
		while(_g14 < _g5) {
			var i4 = _g14++;
			this.timeData[i4] = Math.floor(this.timeData[i4] * this.globalVolume);
		}
		var _g15 = 0;
		var _g6 = this.freqByteData.length;
		while(_g15 < _g6) {
			var i5 = _g15++;
			this.freqByteDataAry[i5] = this.freqByteData[i5];
			this.freqByteDataAryEase[i5] += (this.freqByteData[i5] - this.freqByteDataAryEase[i5]) / 2;
		}
		this._updateInpulse();
	}
	,_updateInpulse: function() {
		var _g = 0;
		while(_g < 64) {
			var i = _g++;
			this._impulse[i] += (0 - this._impulse[i]) / 2;
		}
	}
	,setImpulse: function(stlength) {
		if(stlength == null) stlength = 1;
		var _g = 0;
		while(_g < 64) {
			var i = _g++;
			this._impulse[i] = 255 * Math.random() * stlength;
		}
	}
	,tweenVol: function(tgt) {
		TweenMax.to(this,0.2,{ globalVolume : tgt});
	}
};
var three = {};
three.Face = function() { };
three.IFog = function() { };
three.Mapping = function() { };
three.Renderer = function() { };
three._WebGLRenderer = {};
three._WebGLRenderer.RenderPrecision_Impl_ = function() { };
var video = {};
video.CameraData = function() {
	this._fov = 0;
	this._qw = 0.001;
	this._qz = 0.001;
	this._qy = 0.001;
	this._qx = 0.001;
	this._rz = 0.001;
	this._ry = 0.001;
	this._rx = 0.001;
};
video.CameraData.prototype = {
	load: function(filename,callback) {
		this._callback = callback;
		this._http = new haxe.Http(filename);
		this._http.onData = $bind(this,this._onData);
		this._http.request();
	}
	,_onData: function(data) {
		var data1 = JSON.parse(data);
		this._frameData = data1.frames;
		this._points = data1.points;
		var p = data1.positions;
		this._positions = [];
		var _g1 = 0;
		var _g = p.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._positions[i] = new THREE.Vector3(p[i][0],p[i][1],-p[i][2]);
		}
		if(this._callback != null) this._callback();
	}
	,getPositions: function() {
		return this._positions;
	}
	,getPointsGeo: function() {
		var g = new THREE.Geometry();
		if(this._points == null) return null;
		var _g1 = 0;
		var _g = this._points.length;
		while(_g1 < _g) {
			var i = _g1++;
			g.vertices.push(new THREE.Vector3(this._points[i][0],this._points[i][1],-this._points[i][2]));
		}
		return g;
	}
	,getFrameData: function(frame) {
		return this._frameData[frame];
	}
	,update: function(f,cam) {
		if(f >= this._frameData.length) return;
		var q = this._frameData[f].q;
		var qtn = new THREE.Quaternion(q[0],q[1],q[2],q[3]);
		cam.quaternion.copy(qtn);
		cam.position.x = this._frameData[f].x;
		cam.position.y = this._frameData[f].y;
		cam.position.z = this._frameData[f].z;
		this._qx = q[0];
		this._qy = q[1];
		this._qz = q[2];
		if(Math.abs(this._fov - this._frameData[f].fov) > 0.5) {
			this._fov = this._frameData[f].fov;
			console.log("change fov");
			cam.setFOV(this._fov);
		}
	}
	,getV: function(f) {
		return new THREE.Vector3(this._frameData[f].x,this._frameData[f].y,this._frameData[f].z);
	}
	,getQ: function(f) {
		var q = this._frameData[f].q;
		var qtn = new THREE.Quaternion(q[0],q[1],q[2],q[3]);
		return qtn;
	}
	,_getMatrix: function(a) {
		var m = new THREE.Matrix4();
		m.set(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15]);
		return m;
	}
};
video.Config = function() {
};
video.Config.prototype = {
	load: function(filename,callback) {
		this._callback = callback;
		this._http = new haxe.Http(filename);
		this._http.onData = $bind(this,this._onData);
		this._http.request();
	}
	,_onData: function(data) {
		var d = JSON.parse(data);
		this.list = [];
		var _g1 = 0;
		var _g = d.data.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.list.push(new video.MovieData(d.data[i]));
		}
		if(this._callback != null) this._callback();
	}
};
video.MovieData = function(o) {
	this.offset = 0;
	if(o != null) {
		this.pathCam = o.cam;
		this.pathMov = o.mov;
		this.offset = o.offset;
	}
};
video.MovieData.prototype = {
	loadCamData: function(callback) {
		if(this.camData != null) {
			callback();
			return;
		}
		this.camData = new video.CameraData();
		this.camData.load(this.pathCam,callback);
	}
};
video.VideoPlane = function() {
	this._geo = new THREE.PlaneBufferGeometry(2,2,10,10);
	this._mat = new video.VideoShader();
	THREE.Mesh.call(this,this._geo,this._mat);
};
video.VideoPlane.__super__ = THREE.Mesh;
video.VideoPlane.prototype = $extend(THREE.Mesh.prototype,{
	init: function(vi) {
		this._vi = vi;
	}
	,show: function() {
		this.frustumCulled = false;
		this.visible = true;
	}
	,hide: function() {
		this.frustumCulled = true;
		this.visible = false;
	}
	,update: function() {
		if(!this.visible) return;
		this._mat.update(this._vi);
	}
});
video.VideoPlayer = function() {
	this._loading = false;
	this._fov = 34;
	this._index = 0;
	THREE.Object3D.call(this);
};
video.VideoPlayer.__super__ = THREE.Object3D;
video.VideoPlayer.prototype = $extend(THREE.Object3D.prototype,{
	init: function(camera,callback) {
		this._tgt = new THREE.Vector3();
		this._camera = camera;
		this._callback = callback;
		this._config = new video.Config();
		this._config.load("config.json",$bind(this,this._onInit));
	}
	,_onInit: function() {
		this._list = this._config.list;
		var _this = window.document;
		this._video = _this.createElement("video");
		this._video.style.position = "absolute";
		this._video.style.zIndex = "0";
		this._video.style.top = "0";
		this._video.style.left = "0";
		window.document.body.appendChild(this._video);
		this._videoPlane = new video.VideoPlane();
		this._videoPlane.init(this._video);
		this.setInitCallback(this._callback);
		this._start();
	}
	,setInitCallback: function(cb) {
		this._callback2 = cb;
	}
	,_start: function() {
		this._loading = true;
		this._video.src = "";
		this._movieData = this._list[this._index % this._list.length];
		this._movieData.loadCamData($bind(this,this._onLoad));
	}
	,_onDown: function(e) {
		this._onFinish(null);
	}
	,_onLoad: function() {
		this._video.src = this._movieData.pathMov;
		this._video.addEventListener("canplay",$bind(this,this._onLoad2));
	}
	,_onLoad2: function(e) {
		this._camData = this._movieData.camData;
		var frameData = this._camData.getFrameData(0);
		var geo = this._camData.getPointsGeo();
		if(geo != null) {
		}
		var q = frameData.q;
		this._q = new THREE.Quaternion(q[0],q[1],q[2],q[3]);
		this._fov = frameData.fov;
		this._camera.position.x = frameData.x;
		this._camera.position.y = frameData.y;
		this._camera.position.z = frameData.z;
		this._camera.quaternion.copy(this._q);
		this._camera.lookAt(this._tgt);
		this._camera.setFOV(this._fov);
		this._loading = false;
		this._video.addEventListener("ended",$bind(this,this._onFinish));
		this._video.volume = 0;
		this._video.play();
		window.document.addEventListener("keydown",$bind(this,this._onKeyDown));
		if(this._callback2 != null) this._callback2();
	}
	,_onKeyDown: function(e) {
		var _g = Std.parseInt(e.keyCode);
		switch(_g) {
		case 39:
			this._onFinish(null);
			break;
		}
	}
	,_onFinish: function(hoge) {
		this._video.removeEventListener("ended",$bind(this,this._onFinish));
		var nextIndex = this._index + 1;
		if(this._index == nextIndex) {
			this._index = this._index + 1;
			this._index = this._index % this._list.length;
		} else this._index = nextIndex;
		this._start();
	}
	,show: function() {
		this.visible = true;
		this._videoPlane.show();
	}
	,hide: function() {
		this.visible = false;
		this._videoPlane.hide();
	}
	,getVideo: function() {
		return this._video;
	}
	,update: function(camera) {
		this._videoPlane.update();
		if(this._camData != null && !this._loading) this._camData.update(Math.floor(this._video.currentTime * 30) + this._movieData.offset,camera);
	}
	,getTexture: function() {
		var canvas;
		var _this = window.document;
		canvas = _this.createElement("canvas");
		var ww = 512;
		var hh = 512;
		canvas.width = ww;
		canvas.height = hh;
		var contex = canvas.getContext("2d");
		contex.drawImage(this._video,0,0,960,540,0,0,ww,hh);
		var tex = new THREE.Texture(canvas);
		tex.needsUpdate = true;
		return tex;
	}
	,getEnded: function() {
		if(this._video != null) return this._video.ended; else return true;
	}
	,resize: function(w,h,oy) {
		this._video.width = w;
		this._video.height = h;
		this._video.style.top = oy + "px";
	}
});
video.VideoShader = function() {
	this.ff = "\r\n\t\r\n\t\tuniform sampler2D texture;\r\n\t\tvarying vec2 vUv;                                             \r\n\t\tvoid main()\r\n\t\t{\r\n\t\t\tgl_FragColor = texture2D(texture, vUv);\r\n\t\t}\t\r\n\t\r\n\t";
	this.vv = "\r\n\t\r\n\t\tvarying vec2 vUv;\r\n\t\tvoid main()\r\n\t\t{\r\n\t\t\tvUv = uv;\r\n\t\t\t//position.x = sin(position.y) * 0.1 + position.x;\r\n\t\t\tvec4 hoge = vec4(position, 1.0);//matrix keisan shinai\r\n\t\t\thoge.z = 1.0;\r\n\t\t\tgl_Position = hoge;\r\n\t\t}\t\r\n\t\r\n\t";
	var _this = window.document;
	this._canvas = _this.createElement("canvas");
	this._canvas.width = 1024;
	this._canvas.height = 512;
	this._context = this._canvas.getContext("2d");
	this._texture = new THREE.Texture(this._canvas);
	this._texture.needsUpdate = true;
	THREE.ShaderMaterial.call(this,{ vertexShader : this.vv, fragmentShader : this.ff, uniforms : { texture : { type : "t", value : this._texture}}});
};
video.VideoShader.__super__ = THREE.ShaderMaterial;
video.VideoShader.prototype = $extend(THREE.ShaderMaterial.prototype,{
	update: function(vi) {
		if(vi != null) {
			this._context.drawImage(vi,0,0,vi.width,vi.height,0,0,this._canvas.width,this._canvas.height);
			this._texture.needsUpdate = true;
		}
	}
});
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
Main3d.W = 960;
Main3d.H = 540;
_Three.CullFace_Impl_.None = 0;
_Three.CullFace_Impl_.Back = 1;
_Three.CullFace_Impl_.Front = 2;
_Three.CullFace_Impl_.FrontBack = 3;
_Three.FrontFaceDirection_Impl_.CW = 0;
_Three.FrontFaceDirection_Impl_.CCW = 1;
_Three.ShadowMapType_Impl_.BasicShadowMap = 0;
_Three.ShadowMapType_Impl_.PCFShadowMap = 1;
_Three.ShadowMapType_Impl_.PCFSoftShadowMap = 2;
_Three.Side_Impl_.FrontSide = 0;
_Three.Side_Impl_.BackSide = 1;
_Three.Side_Impl_.DoubleSide = 2;
_Three.Shading_Impl_.NoShading = 0;
_Three.Shading_Impl_.FlatShading = 1;
_Three.Shading_Impl_.SmoothShading = 2;
_Three.Colors_Impl_.NoColors = 0;
_Three.Colors_Impl_.FaceColors = 1;
_Three.Colors_Impl_.VertexColors = 2;
_Three.BlendMode_Impl_.NoBlending = 0;
_Three.BlendMode_Impl_.NormalBlending = 1;
_Three.BlendMode_Impl_.AdditiveBlending = 2;
_Three.BlendMode_Impl_.SubtractiveBlending = 3;
_Three.BlendMode_Impl_.MultiplyBlending = 4;
_Three.BlendMode_Impl_.CustomBlending = 5;
_Three.BlendingEquation_Impl_.AddEquation = 100;
_Three.BlendingEquation_Impl_.SubtractEquation = 101;
_Three.BlendingEquation_Impl_.ReverseSubtractEquation = 102;
_Three.BlendingDestinationFactor_Impl_.ZeroFactor = 200;
_Three.BlendingDestinationFactor_Impl_.OneFactor = 201;
_Three.BlendingDestinationFactor_Impl_.SrcColorFactor = 202;
_Three.BlendingDestinationFactor_Impl_.OneMinusSrcColorFactor = 203;
_Three.BlendingDestinationFactor_Impl_.SrcAlphaFactor = 204;
_Three.BlendingDestinationFactor_Impl_.OneMinusSrcAlphaFactor = 205;
_Three.BlendingDestinationFactor_Impl_.DstAlphaFactor = 206;
_Three.BlendingDestinationFactor_Impl_.OneMinusDstAlphaFactor = 207;
_Three.BlendingDestinationFactor_Impl_.DstColorFactor = 208;
_Three.BlendingDestinationFactor_Impl_.OneMinusDstColorFactor = 209;
_Three.BlendingDestinationFactor_Impl_.SrcAlphaSaturateFactor = 210;
_Three.TextureConstant_Impl_.MultiplyOperation = 0;
_Three.TextureConstant_Impl_.MixOperation = 1;
_Three.TextureConstant_Impl_.AddOperation = 2;
_Three.WrappingMode_Impl_.RepeatWrapping = 1000;
_Three.WrappingMode_Impl_.ClampToEdgeWrapping = 1001;
_Three.WrappingMode_Impl_.MirroredRepeatWrapping = 1002;
_Three.Filter_Impl_.NearestFilter = 1003;
_Three.Filter_Impl_.NearestMipMapNearestFilter = 1004;
_Three.Filter_Impl_.NearestMipMapLinearFilter = 1005;
_Three.Filter_Impl_.LinearFilter = 1006;
_Three.Filter_Impl_.LinearMipMapNearestFilter = 1007;
_Three.Filter_Impl_.LinearMipMapLinearFilter = 1008;
_Three.DataType_Impl_.UnsignedByteType = 1009;
_Three.DataType_Impl_.ByteType = 1010;
_Three.DataType_Impl_.ShortType = 1011;
_Three.DataType_Impl_.UnsignedShortType = 1012;
_Three.DataType_Impl_.IntType = 1013;
_Three.DataType_Impl_.UnsignedIntType = 1014;
_Three.DataType_Impl_.FloatType = 1015;
_Three.PixelType_Impl_.UnsignedShort4444Type = 1016;
_Three.PixelType_Impl_.UnsignedShort5551Type = 1017;
_Three.PixelType_Impl_.UnsignedShort565Type = 1018;
_Three.PixelFormat_Impl_.AlphaFormat = 1019;
_Three.PixelFormat_Impl_.RGBFormat = 1020;
_Three.PixelFormat_Impl_.RGBAFormat = 1021;
_Three.PixelFormat_Impl_.LuminanceFormat = 1022;
_Three.PixelFormat_Impl_.LuminanceAlphaFormat = 1023;
_Three.TextureFormat_Impl_.RGB_S3TC_DXT1_Format = 2001;
_Three.TextureFormat_Impl_.RGBA_S3TC_DXT1_Format = 2002;
_Three.TextureFormat_Impl_.RGBA_S3TC_DXT3_Format = 2003;
_Three.TextureFormat_Impl_.RGBA_S3TC_DXT5_Format = 2004;
_Three.LineType_Impl_.LineStrip = 0;
_Three.LineType_Impl_.LinePieces = 1;
Three.CullFaceNone = 0;
Three.CullFaceBack = 1;
Three.CullFaceFront = 2;
Three.CullFaceFrontBack = 3;
Three.FrontFaceDirectionCW = 0;
Three.FrontFaceDirectionCCW = 1;
Three.BasicShadowMap = 0;
Three.PCFShadowMap = 1;
Three.PCFSoftShadowMap = 2;
Three.FrontSide = 0;
Three.BackSide = 1;
Three.DoubleSide = 2;
Three.NoShading = 0;
Three.FlatShading = 1;
Three.SmoothShading = 2;
Three.NoColors = 0;
Three.FaceColors = 1;
Three.VertexColors = 2;
Three.NoBlending = 0;
Three.NormalBlending = 1;
Three.AdditiveBlending = 2;
Three.SubtractiveBlending = 3;
Three.MultiplyBlending = 4;
Three.CustomBlending = 5;
Three.AddEquation = 100;
Three.SubtractEquation = 101;
Three.ReverseSubtractEquation = 102;
Three.ZeroFactor = 200;
Three.OneFactor = 201;
Three.SrcColorFactor = 202;
Three.OneMinusSrcColorFactor = 203;
Three.SrcAlphaFactor = 204;
Three.OneMinusSrcAlphaFactor = 205;
Three.DstAlphaFactor = 206;
Three.OneMinusDstAlphaFactor = 207;
Three.MultiplyOperation = 0;
Three.MixOperation = 1;
Three.AddOperation = 2;
Three.RepeatWrapping = 1000;
Three.ClampToEdgeWrapping = 1001;
Three.MirroredRepeatWrapping = 1002;
Three.NearestFilter = 1003;
Three.NearestMipMapNearestFilter = 1004;
Three.NearestMipMapLinearFilter = 1005;
Three.LinearFilter = 1006;
Three.LinearMipMapNearestFilter = 1007;
Three.LinearMipMapLinearFilter = 1008;
Three.UnsignedByteType = 1009;
Three.ByteType = 1010;
Three.ShortType = 1011;
Three.UnsignedShortType = 1012;
Three.IntType = 1013;
Three.UnsignedIntType = 1014;
Three.FloatType = 1015;
Three.UnsignedShort4444Type = 1016;
Three.UnsignedShort5551Type = 1017;
Three.UnsignedShort565Type = 1018;
Three.AlphaFormat = 1019;
Three.RGBFormat = 1020;
Three.RGBAFormat = 1021;
Three.LuminanceFormat = 1022;
Three.LuminanceAlphaFormat = 1023;
Three.RGB_S3TC_DXT1_Format = 2001;
Three.RGBA_S3TC_DXT1_Format = 2002;
Three.RGBA_S3TC_DXT3_Format = 2003;
Three.RGBA_S3TC_DXT5_Format = 2004;
Three.LineStrip = 0;
Three.LinePieces = 1;
common.Config.canvasOffsetY = 0;
common.Config.globalVol = 1.0;
common.Config.particleSize = 3000;
common.Config.bgLight = 0.5;
common.Dat.UP = 38;
common.Dat.DOWN = 40;
common.Dat.LEFT = 37;
common.Dat.RIGHT = 39;
common.Dat.SPACE = 32;
common.Dat.K1 = 49;
common.Dat.K2 = 50;
common.Dat.K3 = 51;
common.Dat.K4 = 52;
common.Dat.K5 = 53;
common.Dat.K6 = 54;
common.Dat.K7 = 55;
common.Dat.K8 = 56;
common.Dat.K9 = 57;
common.Dat.K0 = 58;
common.Dat.A = 65;
common.Dat.B = 66;
common.Dat.C = 67;
common.Dat.D = 68;
common.Dat.E = 69;
common.Dat.F = 70;
common.Dat.G = 71;
common.Dat.H = 72;
common.Dat.I = 73;
common.Dat.J = 74;
common.Dat.K = 75;
common.Dat.L = 76;
common.Dat.M = 77;
common.Dat.N = 78;
common.Dat.O = 79;
common.Dat.P = 80;
common.Dat.Q = 81;
common.Dat.R = 82;
common.Dat.S = 83;
common.Dat.T = 84;
common.Dat.U = 85;
common.Dat.V = 86;
common.Dat.W = 87;
common.Dat.X = 88;
common.Dat.Y = 89;
common.Dat.Z = 90;
common.Dat.hoge = 0;
common.Dat.bg = false;
common.Dat._showing = true;
common.Key.keydown = "keydown";
common.Path.assets = "../../assets/";
common.QueryGetter.NORMAL = 0;
common.QueryGetter.SKIP = 1;
common.QueryGetter._isInit = false;
common.QueryGetter.t = 0;
common.StageRef.$name = "webgl";
effect.PostProcessing2.MODE_NORMAL = "MODE_NORMAL";
effect.PostProcessing2.MODE_DISPLACEMENT_A = "MODE_DISPLACEMENT_A";
effect.PostProcessing2.MODE_DISPLACEMENT_B = "MODE_DISPLACEMENT_B";
effect.PostProcessing2.MODE_COLOR = "MODE_COLOR";
objects.MyDAELoader.MAX_Y = 1.36578;
objects.MyDAELoader.MIN_Y = -1.13318;
objects.data.EffectData.COLOR_NONE = 0;
objects.data.EffectData.COLOR_GRADE = 1;
objects.data.EffectData.COLOR_MONO = 2;
objects.data.EffectData.DISPLACE_NONE = 0;
objects.data.EffectData.DISPLACE_X = 1;
objects.data.EffectData.DISPLACE_MAP = 2;
objects.data.EffectData.EFFECT_NORMAL = new objects.data.EffectData({ name : "EFFECT_NORMAL", colorType : 0, displaceType : 0, strength : 1, wireframe : false});
objects.data.EffectData.EFFECT_MONO = new objects.data.EffectData({ name : "EFFECT_MONO", colorType : 2, displaceType : 0, strength : 1, wireframe : false});
objects.data.EffectData.EFFECT_DISPLACE_X = new objects.data.EffectData({ name : "EFFECT_DISPLACE_X", colorType : 0, displaceType : 1, strength : 0.3, wireframe : false});
objects.data.EffectData.EFFECT_DISPLACE_MAP = new objects.data.EffectData({ name : "EFFECT_DISPLACE_MAP", colorType : 0, displaceType : 2, strength : 0.8, wireframe : false});
objects.data.EffectData.EFFECT_COLOR = new objects.data.EffectData({ name : "EFFECT_COLOR", colorType : 1, displaceType : 0, strength : 1, wireframe : false});
objects.data.EffectData.EFFECT_COLOR_WIRE = new objects.data.EffectData({ name : "EFFECT_COLOR_WIRE", colorType : 1, displaceType : 0, strength : 1, wireframe : true});
objects.data.EffectData.effects = [objects.data.EffectData.EFFECT_NORMAL,objects.data.EffectData.EFFECT_DISPLACE_X,objects.data.EffectData.EFFECT_DISPLACE_MAP];
objects.data.EffectData._count = -1;
sound.MyAudio.FFTSIZE = 64;
three._WebGLRenderer.RenderPrecision_Impl_.highp = "highp";
three._WebGLRenderer.RenderPrecision_Impl_.mediump = "mediump";
three._WebGLRenderer.RenderPrecision_Impl_.lowp = "lowp";
Main.main();
})();

//# sourceMappingURL=haxetest.js.map