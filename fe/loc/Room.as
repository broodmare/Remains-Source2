package fe.loc {
	
	//класс шаблона комнаты
	
	public class Room {
		
		public var xml:XML;
		public var id:String;
		public var tip:String;
		
		public var rx:int=0;
		public var ry:int=0;
		public var rz:int=0;
		
		public var lvl:int=0;
		public var back:String;
		
		public var kol=2;
		public var rnd:Boolean=true;	//возможно использовать в качестве рандомной
		
		public static var nornd:Array = ["beg0","back","roof","pass","passroof","roofpass","vert","surf"];

		public function Room(nxml:XML) {
			xml=nxml;
			id=xml.@name;
			if (xml.@x.length()) rx=xml.@x;
			if (xml.@y.length()) ry=xml.@y;
			if (xml.@z.length()) rz=xml.@z;
			if (xml.options.length()) {
				if (xml.options.@tip.length()) tip=xml.options.@tip;
				if (xml.options.@level.length()) lvl=xml.options.@level;
				if (xml.options.@back.length()) back=xml.options.@back;
				if (tip=="uniq") kol=1;
				if (xml.options.@uniq.length()) kol=1;
				for each (var st in nornd) {
					if (tip==st) {
						rnd=false;
						break;
					}
				}
				if (xml.options.@nornd.length()) rnd=false;
				if (xml.options.@test.length()) {
					kol=4;
					lvl=0;
				}
			}
		}

	}
	
}
