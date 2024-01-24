package fe.graph
{
	import flash.display.MovieClip;
	import fe.*;
	import fe.loc.Location;
	import fe.loc.Tile;
	
	public class BackObj
	{
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

		private static var cachedBackObjs:Object = {}; // Save all objects that have been used before to avoid parsing XML for lots of objects.
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		public function BackObj(nloc:Location, nid:String, nx:Number, ny:Number, xml:XML=null)
		{
			id	= nid;
			X	= nx;
			Y	= ny;
			
			var node:XML = getBackObjInfo(id);

			var wid=node.@x2*tileX;
			if (xml && xml.@w.length()) wid=xml.@w*tileX
			if (!(wid>0)) wid=tileX;
			if (nloc && nloc.mirror)
			{
				if (node.@mirr == '2' && Math.random() < 0.5)
				{
					X = nloc.maxX - X;
					scX = -1;
				}
				else if (node.@mirr == '1')
				{
					X = nloc.maxX - X;
					scX = -1;
				}
				else X = nloc.maxX - X - wid;
			}
			else if (node.@mirr=='2' && Math.random() < 0.5)
			{
				X = nx + wid;
				scX = -1;
			} 
			vis		= World.w.grafon.getObj('back_'+ (node.@tid.length()?node.@tid:id) +'_t',Grafon.numbBack);
			erase	= World.w.grafon.getObj('back_'+ (node.@tid.length()?node.@tid:id) +'_e',Grafon.numbBack);
			light	= World.w.grafon.getObj('back_'+ (node.@tid.length()?node.@tid:id) +'_l',Grafon.numbBack);

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
			if (frame>0)
			{
				if (vis) vis.gotoAndStop(frame);
				if (erase) erase.gotoAndStop(frame);
				if (light) light.gotoAndStop(frame);
			}
			if (node.@loff.length()) frameOff=node.@loff;
			if (node.@lon.length()) frameOn=node.@lon;

			function getBackObjInfo(id:String):XML
			{
				var node:XML;
				// Check if the node is already cached
				if (cachedBackObjs[id] != undefined) node = cachedBackObjs[id];
				else
				{
					node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "backs", "id", id);
					cachedBackObjs[id] = node;
				}
				return node;
			}
		}
		
		public function onoff(n:int)
		{
			if (n>0 && frameOn) frame=frameOn;
			if (n<0 && frameOff) frame=frameOff;
			if (frame>0)
			{
				if (vis) vis.gotoAndStop(frame);
				if (erase) erase.gotoAndStop(frame);
				if (light) light.gotoAndStop(frame);
			}
		}
	}
}