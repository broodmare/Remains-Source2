package fe.graph {
	import flash.display.MovieClip;
	import flash.utils.*;
	import fe.*;
	import fe.loc.Location;
	
	public class BackObj {
		public var id:String;
		public var X:Number;
		public var Y:Number;
		public var scX:Number=1;
		public var scY:Number=1;
		public var vis:MovieClip, erase:MovieClip, light:MovieClip;
		public var frame:int=1;
		public var frameOn:int=0;
		public var frameOff:int=0;
		public var blend:String='normal';
		public var alpha:Number=1;
		public var sloy:int=0;
		public var er:Boolean=false;	//стирание

		public function BackObj(nloc:Location, nid:String, nx:Number, ny:Number, xml:XML=null) {
			id=nid;
			X=nx, Y=ny;
			var node:XML=AllData.d.back.(@id==id)[0];
			/*if (node.@light>0) {
				light=Grafon.resTex.getObj('back_'+ (node.@tid.length()?node.@tid:id) +'_l');
			}*/
			var wid=node.@x2*World.tileX;
			if (xml && xml.@w.length()) wid=xml.@w*World.tileX
			if (!(wid>0)) wid=World.tileX;
			if (nloc && nloc.mirror) {
				if (node.@mirr=='2' && Math.random()<0.5) {
					X=nloc.limX-X;
					scX=-1;
				} else if (node.@mirr=='1') {
					X=nloc.limX-X;
					scX=-1;
				} else {
					X=nloc.limX-X-wid;
				}
			} else if (node.@mirr=='2' && Math.random()<0.5) {
				X=nx+wid;
				scX=-1;
			} 
			vis=World.w.grafon.getObj('back_'+ (node.@tid.length()?node.@tid:id) +'_t',Grafon.numbBack);
			erase=World.w.grafon.getObj('back_'+ (node.@tid.length()?node.@tid:id) +'_e',Grafon.numbBack);
			light=World.w.grafon.getObj('back_'+ (node.@tid.length()?node.@tid:id) +'_l',Grafon.numbBack);
			if (node.@fr.length()) frame=node.@fr;
			else if (nloc.lightOn>0 && node.@lon.length()) frame=node.@lon;
			else if (nloc.lightOn<0 && node.@loff.length()) frame=node.@loff;
			else if (vis) frame=Math.floor(Math.random()*vis.totalFrames+1);
			else frame=1;
			if (node.@s.length()) sloy=node.@s;
			if (node.@blend.length()) blend=node.@blend;
			if (node.@alpha.length()) alpha=node.@alpha;
			if (node.@er.length()) er=true;
			if (xml) {
				if (xml.@w.length()) scX=xml.@w;
				if (xml.@h.length()) scY=xml.@h;
				if (xml.@a.length()) alpha=xml.@a;
				if (xml.@fr.length()) frame=xml.@fr;
				if (xml.@lon.length() && xml.@lon>1 && node.@lon.length()) frame=node.@lon;
				if (xml.@lon.length() && xml.@lon<1 && node.@loff.length()) frame=node.@loff;
			}
			if (frame>0) {
				if (vis) vis.gotoAndStop(frame);
				if (erase) erase.gotoAndStop(frame);
				if (light) light.gotoAndStop(frame);
			}
			if (node.@loff.length()) frameOff=node.@loff;
			if (node.@lon.length()) frameOn=node.@lon;
		}
		
		public function onoff(n:int) {
			if (n>0 && frameOn) frame=frameOn;
			if (n<0 && frameOff) frame=frameOff;
			if (frame>0) {
				if (vis) vis.gotoAndStop(frame);
				if (erase) erase.gotoAndStop(frame);
				if (light) light.gotoAndStop(frame);
			}
		}

	}
	
}
