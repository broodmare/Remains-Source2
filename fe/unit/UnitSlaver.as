﻿package fe.unit {

	public class UnitSlaver extends UnitRaider {

		// Constructor
		public function UnitSlaver(cid:String = null, ndif:Number = 100, xml:XML = null, loadObj:Object = null) {
			parentId = 'slaver';
			kolTrs = 6;
			if (int(cid) > kolTrs) {
				cid = '1';
			}
			super(cid, ndif, xml, loadObj);
		}
	}
}