package fe.graph
{
	import flash.utils.*;
	import flash.filters.BevelFilter;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.display.BitmapData;
	import fe.World;

	import fe.stubs.TileMask;
	
	public class Material
	{
		
		public var id:String;
		public var used:Boolean = false;

		public var texture:BitmapData;
		public var alttexture:BitmapData;
		public var border:BitmapData;
		public var floor:BitmapData;
		
		public var textureMask:Class;
		public var borderMask:Class;
		public var floorMask:Class;
		public var F:Array;
		public var rear:Boolean=false;
		public var slit:Boolean=false;

		public static var fils:Object = {
		"potek"		: [ new BevelFilter(10,270,0,0,0,0.5,1,10,1,3),new GlowFilter(0,2,2,2,2,1,true) ],
		"shad"		: [ new DropShadowFilter(5,90,0,1,12,12,1,3) ],
		"cont"		: [ new GlowFilter(0,1,15,15,1,3,true) ],
		"cont_metal" : [ new GlowFilter(0,1,2,2,2,1,true), new GlowFilter(0,1,15,15,1,3,true) ],
		"cont_th"	: [ new GlowFilter(0,1,5,5,1,3,true),new GlowFilter(0,2,2,2,2,1,true) ],
		"plitka"	: [ new BevelFilter(2,70,0xFFFFFF,0.5,0,0.5,2,2,1,1),new GlowFilter(0,0.5,5,5,1,3,false) ],
		"dyrka"		: [ new DropShadowFilter(10,70,0,2,10,10,1,3,true),new BevelFilter(2,250,0xFFFFFF,0.7,0,0.7,3,3,1,1) ],
		"cloud"		: [ new DropShadowFilter(5,90,0x375774,1,5,7,1,3,true),new BevelFilter(2,250,0xFFFFFF,0.7,0,0.7,3,3,1,1) ]
		};

		public function Material(p:XML)
		{
			id = p.@id;
			texture=World.w.grafon.getObj(p.main.@tex,Grafon.numbMat);
			if (p.main.@alt.length()) alttexture=World.w.grafon.getObj(p.main.@alt,Grafon.numbMat);
			border=World.w.grafon.getObj(p.border.@tex,Grafon.numbMat);
			floor=World.w.grafon.getObj(p.floor.@tex,Grafon.numbMat);
			if (p.main.@mask.length())
			{
				try
				{
					textureMask = getDefinitionByName(p.main.@mask) as Class;
				}
				catch (err:ReferenceError)
				{
					trace("ERROR: (00:4B) - Tile: '" + id + "', Texture mask class defined in XML not found; defaulting to TileMask.");
					textureMask = TileMask;
				}
			}
			else textureMask = TileMask;

			try
			{
				borderMask=getDefinitionByName(p.border.@mask) as Class;
			}
			catch (err:ReferenceError)
			{
				//trace("ERROR: (00:4C) - Tile: '" + id + "', Border mask class defined in XML not found; defaulting to null.");
				borderMask=null;
			}
			try
			{
				floorMask=getDefinitionByName(p.floor.@mask) as Class;
			}
			catch (err:ReferenceError)
			{
				//trace("ERROR: (00:4D) - Tile: '" + id + "', Floor mask class defined in XML not found; defaulting to null.");
				floorMask=null;
			}
			if (p.filter.length()) F = fils[p.filter.@f];
			if (p.@rear > 0 || p.@ed == "2") rear = true;
			if (p.@slit > 0) slit = true;
		}
	}
}