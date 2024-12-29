package fe.serv {
	
	import fe.*;
	import fe.TextLoader;
	import fe.unit.Invent;
	import fe.unit.Unit;

	public class Vendor {
		
		private var _id:String = "vendor";	// Inventory list name
		private var _vendorData:Object;		// The vendor's items for sale and quests
		
		public var buys:Array = [];		// Items currently for sale by this vendor
		public var buys2:Object = {};		// ??
		public var kolBou:Number = 0;		// Something bought?
		public var kolSell:Number = 0;		// Something sold?
		public var money:int = 0;			// Vendor money
		public var multPrice:Number = 1;	// Item price multiplier

		// Constructor
		public function Vendor() {

		}

		public function get vendorData():Object {
			return _vendorData;
		}
		public function set vendorData(data:Object):void {
			_vendorData = data;
		}

		public function get id():String {
			return _id;
		}
		public function set id(s:String):void {
			_id = s;
		}

		// Clear how many of each item the vendor bought or sold in the current transaction?
		public function reset():void {
			kolBou = 0;
			for (var i in buys) {
				buys[i].bou = 0;
			}
		}

		public function save():* {
			if (id == null) {
				return null;
			}
			
			var arr:Array = [];
			
			for each (var b:Item in buys) {
				arr.push(b.save());
			}
			
			return arr;
		}
	}	
}