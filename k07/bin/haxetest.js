(function () { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
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
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
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
	this._mode = 2;
	this._cats = [];
};
Main3d.prototype = {
	init: function() {
		this._onLoad();
	}
	,_onLoad: function() {
		common.Dat.init($bind(this,this._onLoad2));
	}
	,_onLoad2: function() {
		common.TimeCounter.start();
		Main3d.clearColor = new THREE.Color(16733695);
		this._audio = new sound.MyAudio();
		this._audio.init($bind(this,this._onInit));
	}
	,_onInit: function() {
		this._scene = new THREE.Scene();
		this._camera = new camera.ExCamera(60,Main3d.W / Main3d.H,10,10000);
		this._angle = new camera.CamAngle(this._camera);
		this._camera.near = 5;
		this._camera.far = 10000;
		this._camera.amp = 1000;
		this._renderer = new THREE.WebGLRenderer({ antialias : true, devicePixelRatio : 1});
		this._renderer.setClearColor(new THREE.Color(0));
		this._renderer.setSize(Main3d.W,Main3d.H);
		this._camera.init(this._renderer.domElement);
		window.document.body.appendChild(this._renderer.domElement);
		window.onresize = $bind(this,this._onResize);
		this._onResize(null);
		this._dataManager = data.DataManager.getInstance();
		this._dataManager.load($bind(this,this._onLoad1));
		common.Dat.gui.add(this._camera,"amp",0,9000).listen();
		common.Dat.gui.add(this._camera,"radX",0,2 * Math.PI).step(0.01).listen();
		common.Dat.gui.add(this._camera,"radY",0,2 * Math.PI).step(0.01).listen();
		common.Dat.gui.add(this._camera,"tgtOffsetY",-1000,1000).step(1).listen();
		common.Dat.gui.add(this,"_force");
		common.Dat.gui.add(this,"_goNext");
		window.document.addEventListener("keydown",$bind(this,this._onKeyDown));
	}
	,_onKeyDown: function(e) {
		if(Std.parseInt(e.keyCode) == 39) this._goNext();
	}
	,_goNext: function() {
		this._mode++;
		this._mode = this._mode % this._cats.length;
		var _g1 = 0;
		var _g = this._cats.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._mode == i) {
				this._cats[i].visible = true;
				this._cats[i].restart();
				this._scene.add(this._cats[i]);
			} else {
				this._cats[i].visible = false;
				this._scene.remove(this._cats[i]);
			}
		}
	}
	,_force: function() {
		this._camera.setRAmp(2000 + 500 * Math.random(),4 * (Math.random() - 0.5));
	}
	,_onLoad1: function() {
		this._longCats = new objects.LongCats();
		this._scene.add(this._longCats);
		this._generators = new objects.CatsGenerators();
		this._scene.add(this._generators);
		this._dimention = new objects.DimentionCats();
		this._scene.add(this._dimention);
		this._cats = [this._dimention,this._longCats,this._generators];
		var _g1 = 0;
		var _g = this._cats.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._cats[i].init(this._camera);
		}
		this._goNext();
		this._run();
	}
	,_run: function() {
		if(this._audio != null && this._audio.isStart) {
			this._audio.update();
			this._cats[this._mode].update(this._audio);
		}
		this._camera.update();
		this._angle.update(this._audio);
		this._renderer.render(this._scene,this._camera);
		window.requestAnimationFrame($bind(this,this._run));
	}
	,fullscreen: function() {
		this._renderer.domElement.requestFullscreen();
	}
	,_onResize: function(e) {
		Main3d.W = window.innerWidth;
		Main3d.H = window.innerHeight;
		this._renderer.domElement.width = Main3d.W;
		this._renderer.domElement.height = Main3d.H;
		this._renderer.setSize(Main3d.W,Main3d.H);
		this._camera.aspect = Main3d.W / Main3d.H;
		this._camera.updateProjectionMatrix();
	}
	,setColor: function(col) {
		Main3d.clearColor = new THREE.Color(col);
		this._renderer.setClearColor(Main3d.clearColor);
	}
};
var IMap = function() { };
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
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
var Tracer = function() {
};
Tracer.assert = function(condition,p1,p2,p3,p4,p5) {
};
Tracer.clear = function(p1,p2,p3,p4,p5) {
};
Tracer.count = function(p1,p2,p3,p4,p5) {
};
Tracer.debug = function(p1,p2,p3,p4,p5) {
};
Tracer.dir = function(p1,p2,p3,p4,p5) {
};
Tracer.dirxml = function(p1,p2,p3,p4,p5) {
};
Tracer.error = function(p1,p2,p3,p4,p5) {
};
Tracer.group = function(p1,p2,p3,p4,p5) {
};
Tracer.groupCollapsed = function(p1,p2,p3,p4,p5) {
};
Tracer.groupEnd = function() {
};
Tracer.info = function(p1,p2,p3,p4,p5) {
};
Tracer.log = function(p1,p2,p3,p4,p5) {
};
Tracer.markTimeline = function(p1,p2,p3,p4,p5) {
};
Tracer.profile = function(title) {
};
Tracer.profileEnd = function(title) {
};
Tracer.time = function(title) {
};
Tracer.timeEnd = function(title,p1,p2,p3,p4,p5) {
};
Tracer.timeStamp = function(p1,p2,p3,p4,p5) {
};
Tracer.trace = function(p1,p2,p3,p4,p5) {
};
Tracer.warn = function(p1,p2,p3,p4,p5) {
};
var camera = {};
camera.CamAngle = function(cam) {
	this._addRadY = 0;
	this._addRadX = 0;
	this._addAmp = 0;
	this._tgtRadY = 0;
	this._tgtRadX = 0;
	this._tgtAmp = 0;
	this._count = 0;
	this._camera = cam;
	window.document.addEventListener("keydown",$bind(this,this._onKeyDown));
};
camera.CamAngle.prototype = {
	_onKeyDown: function(e) {
		var _g = Std.parseInt(e.keyCode);
		switch(_g) {
		case 39:
			break;
		}
	}
	,update: function(audio) {
		if(audio != null && audio.isStart) {
			this._count++;
			this._addRadX = Math.sin(this._count / 20) * 0.3;
			this._addRadY = Math.cos(this._count / 20) * 0.3;
		}
	}
	,setCam: function(d) {
		this._camera.amp = d.amp;
		this._camera.radX = d.radX;
		this._camera.radY = d.radY;
		this._tgtAmp = d.amp;
		this._tgtRadX = d.radX;
		this._tgtRadY = d.radY;
		this._camera.setPolar(d.amp,d.radX,d.radY);
	}
};
camera.CamData = function(n,a,rx,ry) {
	this.amp = 0;
	this.radY = 0;
	this.radX = 0;
	this.name = "";
	this.name = n;
	this.amp = a;
	this.radX = rx;
	this.radY = ry;
};
camera.CamData.setRandom = function(cam,isV) {
	if(isV) camera.CamData.setCam(cam,camera.CamData.camsV[Math.floor(Math.random() * camera.CamData.camsV.length)]); else camera.CamData.setCam(cam,camera.CamData.cams[Math.floor(Math.random() * camera.CamData.cams.length)]);
};
camera.CamData.setCam = function(cam,d) {
	cam.amp = d.amp;
	cam.radX = d.radX;
	cam.radY = d.radY;
	cam.setPolar(d.amp,d.radX,d.radY);
};
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
		console.log("setFOV = " + fov);
		this._camera.fov = fov;
		this._camera.updateProjectionMatrix();
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
	common.Dat.hide();
	if(common.Dat._callback != null) common.Dat._callback();
};
common.Dat._onKeyDown = function(e) {
	var _g = Std.parseInt(e.keyCode);
	switch(_g) {
	case 90:
		common.Dat._soundFlag = !common.Dat._soundFlag;
		TweenMax.to(sound.MyAudio.a,0.5,{ globalVolume : common.Dat._soundFlag?common.Config.globalVol:0});
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
	case 55:
		common.StageRef.fadeOut(common.Dat._goURL7);
		break;
	case 56:
		common.StageRef.fadeOut(common.Dat._goURL8);
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
	common.Dat._goURL("../../k06/bin/");
};
common.Dat._goURL7 = function() {
	common.Dat._goURL("../../k01/bin/");
};
common.Dat._goURL8 = function() {
	common.Dat._goURL("../../k07/bin/");
};
common.Dat._goURL = function(url) {
	Tracer.log("goURL " + url);
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
		Tracer.debug("_onkeydown " + n);
		this._dispatch(n);
	}
	,_dispatch: function(n) {
		if(!common.Dat.bg) this._socket.send(n);
		this.dispatchEvent({ type : "keydown", keyCode : n});
	}
});
common.QueryGetter = function() {
};
common.QueryGetter.init = function() {
	common.QueryGetter._map = new haxe.ds.StringMap();
	var str = window.location.search;
	if(str.indexOf("?") < 0) Tracer.log("query nashi"); else {
		str = HxOverrides.substr(str,1,str.length - 1);
		var list = str.split("&");
		Tracer.log(list);
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
common.StageRef = function() {
};
common.StageRef.showBorder = function() {
	var dom = window.document.getElementById("webgl");
	if(dom != null) dom.style.border = "solid 1px #cccccc";
};
common.StageRef.hideBorder = function() {
	var dom = window.document.getElementById("webgl");
	if(dom != null) dom.style.border = "solid 0px";
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
common.StringUtils = function() {
};
common.StringUtils.addCommma = function(n) {
	var s;
	if(n == null) s = "null"; else s = "" + n;
	var out = "";
	var _g1 = 0;
	var _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		out += HxOverrides.substr(s,i,1);
		var keta = s.length - 1 - i;
		if(keta % 3 == 0 && keta != 0) out += ",";
	}
	return out;
};
common.StringUtils.addCommaStr = function(s) {
	if(s.length <= 3) return s;
	var out = "";
	var lastIndex = s.length - 1;
	var last = "";
	var _g1 = 0;
	var _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		var j = lastIndex - i;
		var last1 = HxOverrides.substr(s,j,1);
		if(i % 3 == 0 && i != 0) out = last1 + "," + out; else out = last1 + out;
	}
	return out;
};
common.StringUtils.addZero = function(val,keta) {
	var valStr = "" + val;
	var sa = keta - valStr.length;
	while(sa-- > 0) valStr = "0" + valStr;
	return valStr;
};
common.StringUtils.getDecimal = function(t,keta) {
	var n = Math.pow(10,keta - 1);
	n = Math.floor(t * n) / n;
	var str = "" + n;
	if(str.length == 1) str = str + ".";
	while(true) {
		if(str.length >= keta + 1) break;
		str = str + "0";
	}
	return str;
};
common.StringUtils.date2string = function(open_date) {
	if(open_date == null) return "UNDEFINED";
	var out = open_date.getFullYear() + "/" + common.StringUtils.addZero(open_date.getMonth() + 1,2) + "/" + common.StringUtils.addZero(open_date.getDate(),2);
	return out;
};
common.StringUtils.string2date = function(s) {
	var a = s.split("-");
	var date = new Date(Std.parseInt(a[0]),Std.parseInt(a[1]) - 1,Std.parseInt(a[2]),12,0,0);
	return date;
};
common.TimeCounter = function() {
};
common.TimeCounter.start = function() {
	common.TimeCounter._time = new Date();
};
common.TimeCounter.getTime = function() {
	var now = new Date();
	var time = Math.floor(now.getTime() - common.TimeCounter._time.getTime());
	var out = "";
	var msec = time % 1000;
	msec = Math.floor(msec / 100);
	var sec = Math.floor(time / 1000);
	var secOut = sec % 60;
	var min = Math.floor(sec / 60);
	var out1 = "00:" + common.StringUtils.addZero(min,2) + ":" + common.StringUtils.addZero(secOut,2);
	return out1;
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
data.DataManager = function() {
	if(data.DataManager.internallyCalled) data.DataManager.internallyCalled = false; else throw "Singleton.getInstance()で生成してね。";
};
data.DataManager.getInstance = function() {
	if(data.DataManager.instance == null) {
		data.DataManager.internallyCalled = true;
		data.DataManager.instance = new data.DataManager();
	}
	return data.DataManager.instance;
};
data.DataManager.prototype = {
	load: function(callback) {
		this._callback = callback;
		this.cats = new objects.CatsLoader();
		this.cats.load($bind(this,this._onLoad));
	}
	,_onLoad: function() {
		console.log("==onLoad==");
		if(this._callback != null) this._callback();
	}
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
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe.Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
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
var objects = {};
objects.Cat = function() {
	this._showing = true;
	this._rotSpeed = Math.random() * Math.PI / 42;
	this._limit = 600 + 200 * Math.random();
	this.index = 0;
	THREE.Object3D.call(this);
};
objects.Cat.__super__ = THREE.Object3D;
objects.Cat.prototype = $extend(THREE.Object3D.prototype,{
	init: function(value) {
		this._rotSpeed = Math.pow(value,2);
		this._dataManager = data.DataManager.getInstance();
		this._cat = this._dataManager.cats.head.mesh.clone();
		this.add(this._cat);
		this._body = new objects.CatBody();
		this._body.scale.set(100,0.001,100);
		this._body.init();
		this._body.position.y = -63.743;
		this.add(this._body);
		this._hip = this._dataManager.cats.hip.mesh.clone();
		this.add(this._hip);
		this._showing = true;
	}
	,update: function(audio) {
		this._cat.position.y += 2;
		this.rotation.y += this._rotSpeed;
		var headPos = this._cat.position.y - 63.743;
		if(this._showing) this._body.setStart(headPos); else {
			this._body.position.y = headPos;
			this._hip.position.y = headPos - this._body.scale.y;
		}
	}
	,getPosY: function() {
		return this._cat.position.y;
	}
	,hide: function(callback) {
		if(this._showing) {
			this._showing = false;
			this._callback = callback;
			haxe.Timer.delay($bind(this,this._onHide),800);
		}
	}
	,_onHide: function() {
		this._callback(this);
	}
});
objects.CatBody = function() {
	this._base = [new THREE.Vector2(0,0.15793),new THREE.Vector2(-0.03581,0.14858),new THREE.Vector2(-0.07219,0.10586),new THREE.Vector2(-0.09726,0.05336),new THREE.Vector2(-0.09811,0.00179),new THREE.Vector2(-0.09122,-0.07178),new THREE.Vector2(-0.0645,-0.12716),new THREE.Vector2(0,-0.13991),new THREE.Vector2(0.0645,-0.12716),new THREE.Vector2(0.09122,-0.07178),new THREE.Vector2(0.09862,0.00179),new THREE.Vector2(0.09921,0.05336),new THREE.Vector2(0.07414,0.10586),new THREE.Vector2(0.03624,0.14858),new THREE.Vector2(0,0.15793)];
	this._base2 = [new THREE.Vector2(0,0.14884),new THREE.Vector2(-0.03581,0.1395),new THREE.Vector2(-0.07219,0.09677),new THREE.Vector2(-0.09726,0.04428),new THREE.Vector2(-0.09811,-0.0073),new THREE.Vector2(-0.09122,-0.08087),new THREE.Vector2(-0.0645,-0.13625),new THREE.Vector2(0,-0.149),new THREE.Vector2(0.0645,-0.13625),new THREE.Vector2(0.09122,-0.08087),new THREE.Vector2(0.09862,-0.0073),new THREE.Vector2(0.09921,0.04428),new THREE.Vector2(0.07414,0.09677),new THREE.Vector2(0.03624,0.1395),new THREE.Vector2(0,0.14884)];
	var g = new THREE.PlaneGeometry(100,100,this._base.length - 1,objects.CatBody.SEG_Z);
	var tex = THREE.ImageUtils.loadTexture("cat/body.png");
	tex.wrapS = 1000;
	tex.wrapT = 1000;
	tex.repeat.set(1,4);
	var m = new THREE.MeshBasicMaterial({ map : tex});
	THREE.Mesh.call(this,g,m);
};
objects.CatBody.__super__ = THREE.Mesh;
objects.CatBody.prototype = $extend(THREE.Mesh.prototype,{
	init: function() {
		this.geometry.verticesNeedUpdate = true;
		var depth = 1;
		var segX = this._base.length;
		var _g1 = 0;
		var _g = objects.CatBody.SEG_Z + 1;
		while(_g1 < _g) {
			var j = _g1++;
			var _g2 = 0;
			while(_g2 < segX) {
				var i = _g2++;
				var index = j * segX + i % segX;
				var vertex = this.geometry.vertices[index];
				var v = this._getPos(i,j / objects.CatBody.SEG_Z);
				var s = 1;
				vertex.x = v.x * s;
				vertex.y = -j / objects.CatBody.SEG_Z * depth;
				vertex.z = -v.y * s;
			}
		}
	}
	,updateDoubleSize: function(size) {
		this.position.y = size;
		this.scale.y = size * 2;
	}
	,updateFrontSize: function(size) {
		this.position.y = size;
		this.scale.y = size;
	}
	,update: function() {
	}
	,setStart: function(posY) {
		this.position.y = posY;
		if(posY > 0) {
			this.scale.y = posY;
			this.visible = true;
		} else this.visible = false;
	}
	,_getPos: function(i,ratio) {
		return new THREE.Vector2(this._base[i].x * (1 - ratio) + this._base2[i].x * ratio,this._base[i].y * (1 - ratio) + this._base2[i].y * ratio);
	}
});
objects.CatsBase = function() {
	THREE.Object3D.call(this);
};
objects.CatsBase.__super__ = THREE.Object3D;
objects.CatsBase.prototype = $extend(THREE.Object3D.prototype,{
	init: function(cam) {
		this._cam = cam;
	}
	,update: function(a) {
	}
	,restart: function() {
	}
});
objects.CatsGenerator = function() {
	this._showing = false;
	this._active = false;
	THREE.Object3D.call(this);
};
objects.CatsGenerator.__super__ = THREE.Object3D;
objects.CatsGenerator.prototype = $extend(THREE.Object3D.prototype,{
	init: function(index) {
		this._cats = [];
		this._index = index;
		this.ground = new objects.Ground();
		this.ground.init();
		this.add(this.ground);
	}
	,update: function(audio) {
		var value = Math.pow(audio.freqByteData[this._index] / 255,3);
		var s = value * 2 + 0.5;
		if(s > 1) s = 1;
		this.ground.setScale(s);
		if(value > 0.1) {
			if(this._activeCat == null) {
				this._activeCat = new objects.Cat();
				this._activeCat.init(value);
				this.add(this._activeCat);
				this._cats.push(this._activeCat);
				this.ground.flash();
			}
		} else if(this._activeCat != null) this._activeCat.hide($bind(this,this._onHide));
		var i = 0;
		while(true) {
			if(i >= this._cats.length) break;
			this._cats[i].update(audio);
			if(this._cats[i] != this._activeCat && this._cats[i].getPosY() > 1500) this._onRemove(i,this._cats[i]); else i++;
		}
	}
	,reset: function() {
		var _g1 = 0;
		var _g = this._cats.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.remove(this._cats[i]);
		}
		this._cats = [];
	}
	,_onRemove: function(i,cat) {
		console.log("remove!!!");
		this.remove(cat);
		this._cats.splice(i,1);
	}
	,_onHide: function(cat) {
		this._activeCat = null;
	}
});
objects.CatsGenerators = function() {
	this._count = 0;
	this.numY = 6;
	this.numX = 6;
	objects.CatsBase.call(this);
};
objects.CatsGenerators.__super__ = objects.CatsBase;
objects.CatsGenerators.prototype = $extend(objects.CatsBase.prototype,{
	init: function(cam) {
		this._cam = cam;
		this._generators = [];
		var count = 0;
		var _g1 = 0;
		var _g = this.numX;
		while(_g1 < _g) {
			var i = _g1++;
			var _g3 = 0;
			var _g2 = this.numY;
			while(_g3 < _g2) {
				var j = _g3++;
				var gen = new objects.CatsGenerator();
				if(count > 31) count = 31;
				gen.init(count);
				gen.position.x = i * 100 - 100 * this.numX / 2 + 100 / 2;
				gen.position.z = j * 100 - 100 * this.numY / 2 + 100 / 2;
				this.add(gen);
				this._generators.push(gen);
				count++;
			}
		}
		this.reposition(1,1);
	}
	,_onKeyDown: function(e) {
		console.log("keydown");
		var ary = [1,2,3,4,5,6];
		var _g = Std.parseInt(e.keyCode);
		switch(_g) {
		case 39:
			this._fuyasu();
			break;
		case 37:
			this._count--;
			if(this._count < 0) this._count = ary.length - 1;
			var n = ary[this._count];
			this.reposition(n,n);
			break;
		}
	}
	,_fuyasu: function() {
		var ary = [1,2,3,4,5,6];
		var n = ary[this._count];
		this._count++;
		this._count = this._count % ary.length;
		this.reposition(n,n);
	}
	,restart: function() {
		var _g1 = 0;
		var _g = this._generators.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._generators[i].reset();
		}
		this._cam.radX = (Math.random() - 0.5) * Math.PI * 0.4;
		this._cam.radY = (Math.random() - 0.5) * Math.PI * 0.8;
		this._cam.amp = 200 + 800 * Math.random();
		this._fuyasu();
	}
	,reposition: function(nx,ny) {
		this.rotation.x = Math.PI / 2;
		var _g1 = 0;
		var _g = this._generators.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._generators[i].visible = false;
		}
		var cnt = 0;
		var _g2 = 0;
		while(_g2 < nx) {
			var i1 = _g2++;
			var _g11 = 0;
			while(_g11 < ny) {
				var j = _g11++;
				var gen = this._generators[cnt];
				gen.visible = true;
				gen.position.x = i1 * 100 - 100 * nx / 2 + 100 / 2;
				gen.position.z = j * 100 - 100 * ny / 2 + 100 / 2;
				cnt++;
			}
		}
	}
	,update: function(a) {
		console.log("===update==");
		var _g1 = 0;
		var _g = this._generators.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._generators[i].visible) this._generators[i].update(a);
		}
	}
});
objects.CatsLoader = function() {
	THREE.Object3D.call(this);
};
objects.CatsLoader.__super__ = THREE.Object3D;
objects.CatsLoader.prototype = $extend(THREE.Object3D.prototype,{
	load: function(callback) {
		this._callback = callback;
		this.head = new objects.MyCATLoader();
		this.hip = new objects.MyCATLoader();
		this.body = new objects.MyCATLoader();
		this.circle = new objects.MyCATLoader();
		this.tail = new objects.MyCATLoader();
		this.head.load("cat/head1.dae",$bind(this,this._onLoad1));
	}
	,_onLoad1: function() {
		this.hip.load("cat/hip1.dae",$bind(this,this._onLoad2));
	}
	,_onLoad2: function() {
		this.body.load("cat/body1.dae",$bind(this,this._onLoad3));
	}
	,_onLoad3: function() {
		this.circle.load("cat/circle.dae",$bind(this,this._onLoad4));
	}
	,_onLoad4: function() {
		var materials = [new THREE.MeshBasicMaterial({ color : 16711680, wireframe : true}),new THREE.MeshBasicMaterial({ color : 65280, wireframe : true})];
		var extrudeMaterial = new THREE.MeshFaceMaterial(materials);
		var shape = new THREE.Shape();
		var _g1 = 0;
		var _g = this.circle.baseGeo.length;
		while(_g1 < _g) {
			var i = _g1++;
			var vv = this.circle.baseGeo[i];
			if(i == 0) shape.moveTo(vv.x,vv.z); else shape.lineTo(vv.x,vv.z);
		}
		var g = new THREE.ExtrudeGeometry(shape,{ steps : 10, amount : 10, bevelEnabled : false, material : 0, extrudeMaterial : 1});
		var extrudeMesh = new THREE.Mesh(g,extrudeMaterial);
		extrudeMesh.scale.set(100,100,100);
		this.add(extrudeMesh);
		if(this._callback != null) this._callback();
	}
});
objects.DimentionCat = function() {
	this._size = 30;
	this._count = 0;
	this._index = 0;
	this._mode = 0;
	THREE.Object3D.call(this);
	this.cat = new objects.LongCat();
	this.cat.init();
	this.add(this.cat);
};
objects.DimentionCat.__super__ = THREE.Object3D;
objects.DimentionCat.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		this._index = Math.floor(10 * Math.random());
		this._randomSpeed = new THREE.Vector3(Math.random() - 0.5,Math.random() - 0.5,Math.random() - 0.5);
		var sz = this.cat.setSize(30);
		this.cat.rotation.x = Math.PI / 2;
		this._box = new objects.LineBox2();
		this._box.init();
		this._box.position.z = 10;
		this._box.position.y = -10;
		this._box.scale.set(0.5,0.75,1.9 * sz / 161.643);
		this.add(this._box);
	}
	,setSize: function(size) {
		TweenMax.to(this,0.5,{ _size : size, onUpdate : $bind(this,this._onUpdateSize)});
	}
	,_onUpdateSize: function() {
		var sz = this.cat.setSize(this._size);
		this._box.scale.set(0.5,0.75,1.9 * sz / 161.643);
	}
	,prev: function() {
	}
	,setGlobal: function(b) {
	}
	,update: function(r,ss,randomMode,audio) {
		this.scale.x += (ss.x - this.scale.x) / 4;
		this.scale.y += (ss.y - this.scale.y) / 4;
		this.scale.z += (ss.z - this.scale.z) / 4;
		if(randomMode) {
			if(audio.subFreqByteData[this._index] > 10 && this._count++ > 10) {
				this._count = 0;
				this._randomSpeed.x = audio.subFreqByteData[this._index] / 255 * 0.4;
				this._randomSpeed.y = audio.subFreqByteData[this._index + 1] / 255 * 0.4;
				this._randomSpeed.z = audio.subFreqByteData[this._index + 2] / 255 * 0.4;
			}
			this.rotation.x += this._randomSpeed.x;
			this.rotation.y += this._randomSpeed.y;
			this.rotation.z += this._randomSpeed.z;
		} else {
			this.rotation.x += (r.x - this.rotation.x) / 4;
			this.rotation.y += (r.y - this.rotation.y) / 4;
			this.rotation.z += (r.z - this.rotation.z) / 4;
		}
	}
	,_remove: function() {
	}
});
objects.DimentionCats = function() {
	this._randomMode = false;
	this._mode = 0;
	this._count = 0;
	this._flag = false;
	objects.CatsBase.call(this);
};
objects.DimentionCats.__super__ = objects.CatsBase;
objects.DimentionCats.prototype = $extend(objects.CatsBase.prototype,{
	init: function(cam) {
		this._cam = cam;
		this._rot = new THREE.Vector3();
		var z = 0.001;
		this._scales = [new THREE.Vector3(1,z,1),new THREE.Vector3(1,1,z),new THREE.Vector3(z,1,1),new THREE.Vector3(1,1,1)];
		this._cats = [];
		var _g = 0;
		while(_g < 7) {
			var i = _g++;
			var _g1 = -2;
			while(_g1 < 3) {
				var j = _g1++;
				var cat = new objects.DimentionCat();
				cat.position.x = i * 150 - 450.;
				cat.position.y = j * 200;
				cat.init();
				this.add(cat);
				this._cats.push(cat);
			}
		}
		this._mode = 2;
	}
	,restart: function() {
		if(Math.random() < 0.1) {
			this._cam.radX = Math.random() * 2 * Math.PI;
			this._cam.radY = Math.random() * 2 * Math.PI;
		} else {
			this._cam.radX = 0;
			this._cam.radY = 0;
		}
		this._cam.amp = 300 + 600 * Math.random();
	}
	,update: function(a) {
		this._flag = false;
		if(!this._randomMode) {
			if(this._mode == 2) this._rot.x += Math.PI / 100; else if(this._mode == 0) this._rot.y += Math.PI / 100; else if(this._mode == 1) this._rot.z += Math.PI / 100; else {
				this._rot.x += Math.PI / 100;
				this._rot.y += Math.PI / 100;
				this._rot.z += Math.PI / 100;
			}
		}
		this._count++;
		if(a.subFreqByteData[5] > 10 && this._count > 15) {
			this._flag = true;
			this._count = 0;
			this._goNext();
		}
		var _g1 = 0;
		var _g = this._cats.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._cats[i].update(this._rot,this._scales[this._mode],this._randomMode,a);
		}
	}
	,_goNext: function() {
		var n = Math.floor(Math.random() * 3);
		if(Math.random() < 0.5) {
			n = 3;
			if(Math.random() < 0.3) this._randomMode = true; else this._randomMode = false;
			if(Math.random() < 0.25) {
				var size;
				if(Math.random() < 0.7) size = 10 + 10 * Math.random(); else size = 20 + 50 * Math.random();
				if(Math.random() < 0.1) size = 100;
				var _g1 = 0;
				var _g = this._cats.length;
				while(_g1 < _g) {
					var i = _g1++;
					this._cats[i].setSize(size);
				}
			}
		} else this._randomMode = false;
		this._mode = n;
	}
});
objects.FlyingCat = function() {
	THREE.Object3D.call(this);
	this.cat = new objects.LongCat();
	this.cat.init();
	this.add(this.cat);
};
objects.FlyingCat.__super__ = THREE.Object3D;
objects.FlyingCat.prototype = $extend(THREE.Object3D.prototype,{
	start: function(spos,scl,callback) {
		this.cat.setSize(20 + 20 * Math.random());
		this.cat.rotation.x = Math.PI / 2;
		this.cat.scale.set(scl,scl,scl);
		this.position.x = spos.x;
		this.position.y = spos.y;
		this.position.z = spos.z;
		this._startPos = spos;
		this._callback = callback;
		this.v = new THREE.Vector3();
		this.v.x = 20 * (Math.random() - 0.5);
		this.v.y = 10 + 30 * Math.random();
		this.v.z = 20 * (Math.random() - 0.5);
	}
	,update: function() {
		this.lookAt(new THREE.Vector3(this.position.x + this.v.x,this.position.y + this.v.y,this.position.z + this.v.z));
		this.position.x += this.v.x;
		this.position.y += this.v.y;
		this.position.z += this.v.z;
		this.v.y -= 0.5;
		if(this.position.y < this._startPos.y - 200) this._callback(this);
	}
	,_remove: function() {
	}
});
objects.FlyingCats = function() {
	this._rad = 0;
	this._index = 0;
	this._count = 0;
	objects.CatsBase.call(this);
};
objects.FlyingCats.__super__ = objects.CatsBase;
objects.FlyingCats.prototype = $extend(objects.CatsBase.prototype,{
	init: function(cam) {
		this._cam = cam;
		this._cats = [];
		this._factory = [];
		var _g = 0;
		while(_g < 30) {
			var i = _g++;
			var cat = new objects.FlyingCat();
			this._factory.push(cat);
		}
		var m = new THREE.Mesh(new THREE.PlaneBufferGeometry(1200,1200,20,20),new THREE.MeshBasicMaterial({ color : 0, side : 0}));
		m.rotation.x = -Math.PI / 2;
		m.position.y = -100;
		this.add(m);
		this._ground = new objects.Ground();
		this._ground.init();
		this.add(this._ground);
	}
	,_gen: function() {
		this._rad += Math.PI / 30;
		var cat = this._factory[this._index % this._factory.length];
		var v = new THREE.Vector3(0,0,0);
		var scl = 1 + Math.random();
		if(Math.random() < 0.01) scl = 3 + 5 * Math.random();
		cat.start(v,scl,$bind(this,this._onRemove));
		this.add(cat);
		this._index++;
		this._cats.push(cat);
		this._ground.setScale(scl);
		this._ground.flash();
	}
	,_onRemove: function(hoge) {
		this.remove(hoge);
		this._cats.splice(HxOverrides.indexOf(this._cats,hoge,0),1);
	}
	,restart: function() {
	}
	,update: function(a) {
		this._count++;
		if(this._count > 5 && a.subFreqByteData[0] > 10) {
			this._gen();
			this._count = 0;
		}
		var _g1 = 0;
		var _g = this._cats.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._cats[i] != null) this._cats[i].update();
		}
	}
});
objects.Ground = function() {
	this.light = 1;
	THREE.Object3D.call(this);
};
objects.Ground.__super__ = THREE.Object3D;
objects.Ground.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		var ww = 100;
		if(objects.Ground.geo == null) {
			objects.Ground.geo = new THREE.BoxGeometry(ww,ww,ww,1,1,1);
			objects.Ground.mate = new THREE.MeshBasicMaterial({ color : 0, side : 2});
			objects.Ground.lineGeo = new THREE.Geometry();
			var shape = new THREE.Shape();
			var _g = 0;
			while(_g < 20) {
				var i = _g++;
				objects.Ground.lineGeo.vertices.push(new THREE.Vector3(ww / 2 * Math.cos(i / 19 * 2 * Math.PI),0,ww / 2 * Math.sin(i / 19 * 2 * Math.PI)));
				if(i == 0) shape.moveTo(ww / 2 * Math.cos(i / 19 * 2 * Math.PI),ww / 2 * Math.sin(i / 19 * 2 * Math.PI)); else shape.lineTo(ww / 2 * Math.cos(i / 19 * 2 * Math.PI),ww / 2 * Math.sin(i / 19 * 2 * Math.PI));
			}
			objects.Ground.shapeGeo = new THREE.ShapeGeometry(shape);
		}
		this.circleMat = new THREE.MeshBasicMaterial({ color : 0});
		this.circle = new THREE.Mesh(objects.Ground.shapeGeo,this.circleMat);
		this.circle.rotation.x = -Math.PI / 2;
		this.circle.position.y = ww / 2 + 1;
		this.add(this.circle);
		this.line = new THREE.Line(objects.Ground.lineGeo,new THREE.LineBasicMaterial({ color : 14527027, linewidth : 2}));
		this.add(this.line);
		this.line.position.y = ww / 2 + 2;
		var m = new THREE.Mesh(objects.Ground.geo,objects.Ground.mate);
		this.add(m);
		this.position.y = -ww / 2;
	}
	,flash: function() {
		this.light = 0.3;
		TweenMax.to(this,0.5,{ light : 0, onUpdate : $bind(this,this._onFlash)});
	}
	,_onFlash: function() {
		this.circleMat.color.setRGB(this.light * 221 / 255,this.light * 170 / 255,this.light * 51 / 255);
	}
	,setScale: function(s) {
		this.line.scale.set(s,1,s);
		this.circle.scale.set(s,s,s);
	}
});
objects.LineBox2 = function() {
	THREE.Object3D.call(this);
};
objects.LineBox2.__super__ = THREE.Object3D;
objects.LineBox2.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		if(objects.LineBox2._geo == null) {
			objects.LineBox2._mat = new THREE.LineBasicMaterial({ color : 14527027, linewidth : 2});
			objects.LineBox2._geo = new THREE.Geometry();
			objects.LineBox2._geo.vertices.push(objects.LineBox2.T1);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.T2);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.T3);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.T4);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.T1);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B1);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B2);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B3);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B4);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B1);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B2);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.T2);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B2);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B3);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.T3);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B3);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B4);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.T4);
			objects.LineBox2._geo.vertices.push(objects.LineBox2.B4);
		}
		var line = new THREE.Line(objects.LineBox2._geo,objects.LineBox2._mat);
		this.add(line);
	}
});
objects.LongCat = function() {
	this._rot = 0;
	this._tgtScale = 1;
	this._flag = false;
	this._freqIndex = 0;
	this._mode = 0;
	this._rad = 0;
	this._showing = true;
	this._rotSpeed = Math.random() * Math.PI / 42;
	this._limit = 600 + 200 * Math.random();
	this.index = 0;
	THREE.Object3D.call(this);
};
objects.LongCat.__super__ = THREE.Object3D;
objects.LongCat.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		this._freqIndex = Math.floor(Math.random() * 10);
		this._dataManager = data.DataManager.getInstance();
		this._container = new THREE.Object3D();
		this.add(this._container);
		this._cat = this._dataManager.cats.head.mesh.clone();
		this._container.add(this._cat);
		this._body = new objects.CatBody();
		this._body.scale.set(100,0.001,100);
		this._body.init();
		this._body.position.y = -63.743;
		this._container.add(this._body);
		this._hip = this._dataManager.cats.hip.mesh.clone();
		this._container.add(this._hip);
		this._showing = true;
	}
	,setSize: function(size) {
		if(this._mode == 0) {
			this._cat.position.y = size + 63.743;
			this._body.updateDoubleSize(size);
			this._hip.position.y = -size;
		} else {
			this._cat.position.y = size + 63.743;
			this._body.updateFrontSize(size);
			this._hip.position.y = 0;
			var oy = 60. + size * 0.3;
			this._cat.position.y += oy;
			this._body.position.y += oy;
			this._hip.position.y += oy;
		}
		return size + 67.9 + 63.743;
	}
	,update: function(audio,rot) {
		this._rad += Math.PI / 100;
		if(audio.subFreqByteData[this._freqIndex] > 10) this._flag = !this._flag;
		if(this._flag) this._tgtScale += (1 - this._tgtScale) / 2; else this._tgtScale += (0.001 - this._tgtScale) / 2;
		this.rotation.y += (rot - this.rotation.y) / 2;
		this._container.scale.y += (this._tgtScale - this._container.scale.y) / 4;
	}
	,getPosY: function() {
		return this._cat.position.y;
	}
	,hide: function(callback) {
		if(this._showing) {
			this._showing = false;
			haxe.Timer.delay($bind(this,this._onHide),800);
		}
	}
	,setScale: function(xx,yy,zz) {
	}
	,_onHide: function() {
	}
});
objects.LongCats = function() {
	this._isRotation = false;
	this._count = 0;
	this._rot = 0;
	this._speedX = Math.random();
	objects.CatsBase.call(this);
};
objects.LongCats.__super__ = objects.CatsBase;
objects.LongCats.prototype = $extend(objects.CatsBase.prototype,{
	init: function(cam) {
		this._cam = cam;
		this._cats = [];
		this._waku = new objects.LongCatsWaku();
		this._waku.init();
		this.add(this._waku);
		var _g = 0;
		while(_g < 4) {
			var j = _g++;
			var _g1 = 0;
			while(_g1 < 4) {
				var i = _g1++;
				var cat = new objects.LongCat();
				cat.init();
				cat.setSize(100);
				cat.position.x = i * 100 - 150.;
				cat.position.z = j * 100 - 150.;
				this.add(cat);
				this._cats.push(cat);
			}
		}
	}
	,restart: function() {
		this._speedX = Math.random() / 100 + 0.002;
		this._cam.radY = (Math.random() - 0.5) * Math.PI * 0.8;
		this._cam.amp = 500 + 600 * Math.random();
		this._reposition(Math.floor(1 + Math.floor(Math.random() * 4)));
		if(Math.random() < 0.5) this._isRotation = true; else this._isRotation = false;
	}
	,_reposition: function(num) {
		console.log("num = " + num);
		var _g1 = 0;
		var _g = this._cats.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._cats[i].visible = false;
		}
		var sp = 120 + (4 - num) * 100;
		var idx = 0;
		var _g2 = 0;
		while(_g2 < num) {
			var j = _g2++;
			var _g11 = 0;
			while(_g11 < num) {
				var i1 = _g11++;
				this._cats[idx].visible = true;
				this._cats[idx].scale.set(5 - num,5 - num,5 - num);
				this._cats[idx].position.x = i1 * sp - (num - 1) * sp / 2;
				this._cats[idx].position.z = j * sp - (num - 1) * sp / 2;
				idx++;
			}
		}
		if(Math.random() < 0.5) this.rotation.x = Math.PI / 2; else this.rotation.x = 0;
	}
	,update: function(a) {
		this._cam.radX += this._speedX;
		if(this._isRotation) {
			this._count++;
			if(a.subFreqByteData[8] > 10 && this._count > 30) {
				this._count = 0;
				this._rot += 0.15;
			} else this._rot += 0.01;
		} else this._rot = 0;
		var _g1 = 0;
		var _g = this._cats.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._cats[i].update(a,this._rot);
		}
	}
});
objects.LongCatsWaku = function() {
	THREE.Object3D.call(this);
};
objects.LongCatsWaku.__super__ = THREE.Object3D;
objects.LongCatsWaku.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		var geo = new THREE.Geometry();
		var m = new THREE.LineBasicMaterial({ color : 14527027, linewidth : 2});
		var w = 330;
		geo.vertices.push(new THREE.Vector3(w,0,w));
		geo.vertices.push(new THREE.Vector3(w,0,-w));
		geo.vertices.push(new THREE.Vector3(-w,0,-w));
		geo.vertices.push(new THREE.Vector3(-w,0,w));
		geo.vertices.push(new THREE.Vector3(w,0,w));
		this._line = new THREE.Line(geo,m);
		this.add(this._line);
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
objects.MyDAELoader.getRatioY = function(posY,pow,posR) {
	var maxY = 1.36578;
	var minY = -1.13318;
	var r = (posY - minY) / (maxY - minY);
	if(r < posR) r = Math.pow(r,pow); else r = Math.pow(r,1 / pow);
	return r;
};
objects.MyDAELoader.getHeight = function(ratio) {
	return 2.49896000000000029 * ratio;
};
objects.MyDAELoader.prototype = {
	load: function(filename,callback) {
		this._callback = callback;
		var loader = new THREE.ColladaLoader();
		loader.options.convertUpAxis = true;
		loader.load(filename,$bind(this,this._onComplete));
	}
	,_onComplete: function(collada) {
		this.dae = collada.scene;
		this.dae.scale.x = this.dae.scale.y = this.dae.scale.z = 170;
		this.material = new THREE.MeshBasicMaterial({ map : THREE.ImageUtils.loadTexture("mae_face_.png"), side : 0});
		this.materialB = new THREE.MeshBasicMaterial({ map : THREE.ImageUtils.loadTexture("mae_face_blue.png"), side : 0});
		this.materialC = new THREE.MeshBasicMaterial({ map : THREE.ImageUtils.loadTexture("mae_faceB.png"), side : 0});
		this.materialD = new THREE.MeshBasicMaterial({ map : THREE.ImageUtils.loadTexture("mae_face_mono.png"), side : 0});
		this.geometry = this.dae.children[0].children[0].geometry;
		this.geometry.verticesNeedUpdate = true;
		this._makeBaseGeo();
		if(this._callback != null) this._callback();
	}
	,_makeBaseGeo: function() {
		this.baseGeo = [];
		var _g1 = 0;
		var _g = this.geometry.vertices.length;
		while(_g1 < _g) {
			var i = _g1++;
			var v = this.geometry.vertices[i].clone();
			this.baseGeo.push(v);
		}
	}
};
objects.MyCATLoader = function() {
	objects.MyDAELoader.call(this);
};
objects.MyCATLoader.__super__ = objects.MyDAELoader;
objects.MyCATLoader.prototype = $extend(objects.MyDAELoader.prototype,{
	load: function(filename,callback) {
		this._callback = callback;
		var loader = new THREE.ColladaLoader();
		loader.options.convertUpAxis = true;
		loader.load(filename,$bind(this,this._onComplete));
	}
	,_onComplete: function(ret) {
		var dae = ret.scene;
		var mm = new THREE.MeshBasicMaterial({ map : THREE.ImageUtils.loadTexture("./cat/cat_diff.jpg"), skinning : false, depthWrite : true, depthTest : true});
		mm.shading = 2;
		mm.alphaTest = 0.9;
		this.mesh = null;
		
			var hoge = this;
			dae.traverse( function(child){
				if( child instanceof THREE.Mesh){
					child.material = mm;
					hoge.mesh = child;
					//alert('hoge ' + child);
					//mm.specular.set(0,0,0);
				}
			});
		;
		if(this.mesh != null) this.mesh.scale.set(100,100,100);
		this.geo = this.mesh.geometry.clone();
		var m4 = new THREE.Matrix4();
		this.geo.applyMatrix(m4);
		this.geo.verticesNeedUpdate = true;
		this.mat = this.mesh.material;
		this.baseGeo = [];
		var _g1 = 0;
		var _g = this.geo.vertices.length;
		while(_g1 < _g) {
			var i = _g1++;
			var vec = new THREE.Vector3(this.geo.vertices[i].x * 4,this.geo.vertices[i].y * 4,this.geo.vertices[i].z * 4);
			this.baseGeo.push(vec);
		}
		this.geometry = this.geo;
		this.material = mm;
		if(this._callback != null) this._callback();
	}
});
var sound = {};
sound.DummyBars = function() {
	THREE.Object3D.call(this);
};
sound.DummyBars.__super__ = THREE.Object3D;
sound.DummyBars.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		this._lines = [];
		this._lines2 = [];
		var m = new THREE.LineBasicMaterial({ color : 16711680});
		var m2 = new THREE.LineBasicMaterial({ color : 16777215});
		var _g = 0;
		while(_g < 64) {
			var i = _g++;
			var g = new THREE.Geometry();
			g.vertices.push(new THREE.Vector3(0,0,0));
			g.vertices.push(new THREE.Vector3(100,0,0));
			var line = new THREE.Line(g,m);
			line.position.y = (i - 32.) * 3;
			line.position.z = 0;
			this.add(line);
			this._lines.push(line);
		}
		var _g1 = 0;
		while(_g1 < 64) {
			var i1 = _g1++;
			var g1 = new THREE.Geometry();
			g1.vertices.push(new THREE.Vector3(0,0,0));
			g1.vertices.push(new THREE.Vector3(100,0,0));
			var line1 = new THREE.Line(g1,m2);
			line1.position.y = (i1 - 32.) * 3 + 1;
			line1.position.z = 0;
			this.add(line1);
			this._lines2.push(line1);
		}
	}
	,update: function(audio) {
		if(audio != null && audio.isStart) {
			var _g1 = 0;
			var _g = this._lines.length;
			while(_g1 < _g) {
				var i = _g1++;
				this._lines[i].scale.set(audio.freqByteData[i] / 255 * 2,1,1);
				this._lines2[i].scale.set(audio.subFreqByteData[i] / 255 * 2,1,1);
			}
		}
	}
});
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
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
Main3d.W = 1280;
Main3d.H = 720;
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
camera.CamData.camA = new camera.CamData("normal_1",8000,0,0);
camera.CamData.camB = new camera.CamData("normal_2",5400,0,0);
camera.CamData.camC = new camera.CamData("normal_3",2700,0,0);
camera.CamData.camD = new camera.CamData("normal_4",7215,-0.3,-0.65);
camera.CamData.camE = new camera.CamData("normal_5",2800,1,0);
camera.CamData.camF = new camera.CamData("normal_6",3800,0,-1.419);
camera.CamData.cam1 = new camera.CamData("zoom",3800,0,0);
camera.CamData.cam2 = new camera.CamData("zoom_naname",4640,-0.609,-0.609);
camera.CamData.cam2b = new camera.CamData("zoom_naname",4640,0.581,-0.609);
camera.CamData.cam3 = new camera.CamData("zoom_down",4412,0,0.91);
camera.CamData.cam4 = new camera.CamData("zoom_yoko",6000,1.5,0);
camera.CamData.cams = [camera.CamData.camA,camera.CamData.camA,camera.CamData.camB,camera.CamData.camC,camera.CamData.camE,camera.CamData.camF];
camera.CamData.camsH = [camera.CamData.camA,camera.CamData.cam2,camera.CamData.cam3,camera.CamData.camD,camera.CamData.camF];
camera.CamData.camsV = [camera.CamData.camA,camera.CamData.cam2,camera.CamData.cam2b,camera.CamData.cam3,camera.CamData.cam4];
common.Config.canvasOffsetY = 0;
common.Config.globalVol = 1.0;
common.Config.particleSize = 10000;
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
common.Dat._soundFlag = true;
common.Key.keydown = "keydown";
common.QueryGetter.NORMAL = 0;
common.QueryGetter.SKIP = 1;
common.QueryGetter._isInit = false;
common.QueryGetter.t = 0;
common.StageRef.$name = "webgl";
data.DataManager.internallyCalled = false;
objects.CatBody.SEG_Z = 10;
objects.CatsGenerators.SPACE = 100;
objects.DimentionCats.MODE_X = 2;
objects.DimentionCats.MODE_Y = 0;
objects.DimentionCats.MODE_Z = 1;
objects.DimentionCats.MODE_NORMAL = 3;
objects.FlyingCats.MAX = 30;
objects.LineBox2.W = 50;
objects.LineBox2.T1 = new THREE.Vector3(objects.LineBox2.W,objects.LineBox2.W,objects.LineBox2.W);
objects.LineBox2.T2 = new THREE.Vector3(objects.LineBox2.W,objects.LineBox2.W,-objects.LineBox2.W);
objects.LineBox2.T3 = new THREE.Vector3(-objects.LineBox2.W,objects.LineBox2.W,-objects.LineBox2.W);
objects.LineBox2.T4 = new THREE.Vector3(-objects.LineBox2.W,objects.LineBox2.W,objects.LineBox2.W);
objects.LineBox2.B1 = new THREE.Vector3(objects.LineBox2.W,-objects.LineBox2.W,objects.LineBox2.W);
objects.LineBox2.B2 = new THREE.Vector3(objects.LineBox2.W,-objects.LineBox2.W,-objects.LineBox2.W);
objects.LineBox2.B3 = new THREE.Vector3(-objects.LineBox2.W,-objects.LineBox2.W,-objects.LineBox2.W);
objects.LineBox2.B4 = new THREE.Vector3(-objects.LineBox2.W,-objects.LineBox2.W,objects.LineBox2.W);
objects.LongCat.SIZE_HEAD = 63.743;
objects.LongCat.SIZE_HIP = 67.9;
sound.MyAudio.FFTSIZE = 64;
three._WebGLRenderer.RenderPrecision_Impl_.highp = "highp";
three._WebGLRenderer.RenderPrecision_Impl_.mediump = "mediump";
three._WebGLRenderer.RenderPrecision_Impl_.lowp = "lowp";
Main.main();
})();
