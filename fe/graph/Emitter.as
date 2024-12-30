package fe.graph {

	import flash.filters.GlowFilter;
	
	import fe.*;
	import fe.util.Vector2;
	import fe.entities.Part;
	import fe.loc.Location;

	public class Emitter {

		public static var arr:Array;
		public static var kols:Array=[0,0,0,0,0,0];
		public static var kol1:int=0, kol2:int=0;

		public static function init():void {
			arr = [];
			var xmlList:XMLList = XMLDataGrabber.getNodesWithName("core", "AllData", "parts", "part");

			for each(var node:XML in xmlList)
			{
				var em:Emitter = new Emitter(node);
				arr[em.id] = em;
			}

			xmlList = null; // Manual cleanup.
		}
		
		//заданный эмиттер создаёт частицу
		public static function emit(nid:String, loc:Location, nx:Number, ny:Number, param:Object=null):void {
			var em:Emitter = arr[nid];
			
			if (em) em.cast(loc,nx,ny,param);
			else trace ('Нет частицы ' + nid);
		}
		/*
				Частицы
				vis - Movieclip object
				ctrans='1' - [location color settings are applied]
				move='1' - the particle moves
				alph='1' - the particle becomes transparent at the end of its life
				
				minliv, rliv - lifetime
				minv, rv - initial speed in random direction
				rdx, rdy - random speed in x, y direction
				velocity - specified speed as [X, Y] vector
				rr - random rotation speed
				rot='1' - random initial rotation angle
				grav - degree of gravity
		*/
		public var id:String;
		
		public var vis:String;
		public var visClass:Class;
		public var sloy:int = 3;
		
		public var imp:int=0;	//1 - является важной
		
		public var blit:String;
		public var blitx:int=0;
		public var blity:int=0;
		public var blitf:int=-1;
		public var blitd:Number=1;
		
		public var ctrans:Boolean=false;
		public var alph:Boolean=false;
		public var prealph:Boolean=false;
		public var anim:int=0;
		public var blend:String='normal';
		public var rsc:Number=0;
		public var scale:Number=1;
		public var frame:int=0;
		public var dframe:int=0;
		public var otklad:int=0;
		public var filter:String;
		
		public var move:Boolean=false;
		public var minliv:int=20, rliv:int=0;
		public var minv:Number=0, rv:Number=0;
		public var rx:Number=0, ry:Number=0;
		public var rdx:Number=0, rdy:Number=0, rdr:Number=0;

		public var velocity:Vector2 = new Vector2();
		
		public var rot:int=0;
		public var brake:Number=1;
		public var grav:Number=0, rgrav:Number=0;
		
		public var water:int=0;
		public var maxkol:int=0;
		public var camscale:Boolean=false;
		
		public static var fils:Array=[];
		fils['bur']=[new GlowFilter(0xFF7700,1,8,8,1,1)];
		fils['plav']=[new GlowFilter(0x00FF00,1,8,8,1,1)];

		public function Emitter(xml:XML) {
			for each (var attr:XML in xml.attributes()) {
				var att:String = attr.name();
				if (this.hasOwnProperty(att)) {
					if (this[att] is Boolean) this[att] = true;
					else this[att] = attr;
				}
			}
			if (vis) visClass=Res.getClass(vis);
		}
		
		//эмиттер создаёт частицу
		//param может содержать свойства:
		//kol - количество
		//rx,ry - случайное отклонение от nx,ny
		//alpha, scale
		//velocity, dr - Initial velocity and rotation
		//frame - заданный кадр
		//txt - текст, используемый в текстовых частицах
		//celx+cely - ориентация
		
		public function cast(loc:Location, nx:Number, ny:Number, param:Object=null):Part {
			if (loc==null || !loc.active) return null;
			if (kol2>World.w.maxParts && imp==0) return null;
			var kol:int=1;
			if (param && param.kol) kol=param.kol;
			if (kol>50) kol=50;
			frame=dframe=0;
			var p:Part;
			for (var i:int = 1; i <= kol; i++) {
				if (maxkol>0 && kols[maxkol]>=12) return p;
				p=new Part();
				p.loc=loc;
				p.sloy=sloy;
				p.coordinates.X = nx;
				p.coordinates.Y = ny;
				if (rx) p.coordinates.X += (Math.random()-0.5)*rx;
				if (ry) p.coordinates.Y += (Math.random()-0.5)*ry;
				
				if (maxkol>0) {
					p.maxkol=maxkol;
					kols[maxkol]++;
				}
				
				p.vClass=visClass;
				var x:Number;
				var y:Number;

				if (minv + rv > 0) {
					var rot2:Number;
					var vel:Number;
					rot2 = Math.random() * Math.PI * 2;
					vel = Math.random() * rv + minv;
					p.velocity.X = Math.sin(rot2) * vel;
					p.velocity.Y = Math.cos(rot2) * vel;
				}
				if (rdx) p.velocity.X += (Math.random()-0.5) * rdx;
				if (rdy) p.velocity.Y += (Math.random()-0.5) * rdy;

				p.velocity.sumVectors(velocity)
				if (rdr) p.dr=(Math.random()-0.5)*rdr;
				if (rot) p.r=Math.random()*360;
				if (param) {
					if (param.rx) p.coordinates.X+=(Math.random()-0.5)*param.rx;
					if (param.ry) p.coordinates.Y+=(Math.random()-0.5)*param.ry;
					
					if (param.velocity) {
						p.velocity.sumVectors(param.velocity);
					}
					
					if (param.dr) p.dr+=param.dr;
					if (param.md != null) {
						// I'd prefer multiplying these as vectors
						p.velocity.X *= param.md;
						p.velocity.Y *= param.md;
					}
					if (param.frame) frame=param.frame;
					if (param.dframe) dframe=param.dframe;
					if (param.otklad) otklad=param.otklad;
				}
				
				p.ddy=World.ddy*grav;
				p.brake=brake;
				if (rgrav) p.ddy+=World.ddy*rgrav*Math.random();
				p.liv=p.mliv=int(Math.random()*rliv)+minliv;
				p.isAlph=alph;
				p.isPreAlph=prealph;
				p.isAnim=anim;
				p.isMove=(p.velocity.X != 0 || p.velocity.Y != 0 || p.ddy != 0);
				p.water=water;
				if (blitx) p.blitX=blitx;
				if (blity) p.blitY=blity;
				if (blitd) p.blitDelta=blitd;
				if (blitf>0) {
					p.blitMFrame=blitf;
					p.blitFrame=int(Math.random()*blitf);
				}
				
				if (otklad>0) {
					p.otklad=int(Math.random()*otklad+1);
				}
				if (vis) p.initVis(frame+((dframe==0)?0:int(Math.random()*dframe+1)));
				if (blit) p.initBlit(blit)
				
				if (p.vis) {
					if (param && param.alpha) p.vis.alpha=param.alpha;
					if (param && param.scale) p.vis.scaleX=p.vis.scaleY=param.scale;
					if (param && param.rotation) p.vis.rotation=param.rotation;
					p.vis.blendMode=blend;
					if (scale!=1) p.vis.scaleX=p.vis.scaleY=scale;
					if (rsc!=0) p.vis.scaleX=p.vis.scaleY=scale-rsc+Math.random()*rsc;
					if (ctrans) p.vis.transform.colorTransform=loc.cTransform;
					if (filter && Emitter.fils[filter]) p.vis.filters=Emitter.fils[filter];
					if (param && param.celx!=null && param.cely!=null && p.vis.len) {
						var gx:Number = param.celx-p.coordinates.X;
						var gy:Number = param.cely-p.coordinates.Y;
						var gr:Number = Math.sqrt(gx*gx+gy*gy);
						var gu:Number = Math.atan2(gy,gx)*180/Math.PI;
						p.vis.len.scaleX=gr/p.vis.len.width;
						p.vis.len.rotation=gu;
						if (p.vis.fl) {
							p.vis.fl.x=gx;
							p.vis.fl.y=gy;
						}
					}
					if (param && param.mirr) p.vis.scaleX=-p.vis.scaleX;
					loc.addObj(p);
					if (prealph) p.vis.alpha=0;
					if (id=='numb' && param.txt) p.vis.numb.text=param.txt;
					if ((id=='replic' || id=='replic2') && param.txt) {
						p.vis.text.text.text=param.txt;
					}
					if ((id=='gui' || id=='take') && param.txt) {
						p.vis.text.text.styleSheet=World.w.gui.style;
						p.vis.text.text.htmlText=param.txt;
					}
					if (camscale) {
						p.vis.scaleX=p.vis.scaleY=1/World.w.cam.scaleV;
						if (param && param.scale) {
							p.vis.scaleX*=param.scale;
							p.vis.scaleY*=param.scale;
						}
					}
				}
			}
			return p;
		}
	}
}