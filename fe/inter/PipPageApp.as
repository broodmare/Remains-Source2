package fe.inter {

	import fe.*;

	import fe.stubs.visPipQuestItem;
	
	// The player appearance editor
	public class PipPageApp extends PipPage {

		public function PipPageApp(npip:PipBuck, npp:String):void {
			itemClass = visPipQuestItem;
			super(npip, npp);
			vis.but1.visible = false;
			vis.but2.visible = false;
			vis.but3.visible = false;
			vis.but4.visible = false;
			vis.but5.visible = false;
		}
		
		// [Accept appearance settings]
		public function funVidOk():void {
			World.w.gg.refreshVis();
			pip.onoff(-1);
		}
		
		// [Accept appearance settings]
		public function funVidCancel():void {
			pip.onoff(-1);
		}

		override protected function setSubPages():void {
			vis.bottext.visible = false;
			vis.butOk.visible = false;
			statHead.visible = false;

			setTopText();
			if (page2 == 1) {
				pip.armorID = '';
				World.w.app.attach(vis, funVidOk, funVidCancel);
				World.w.app.vis.y = 400;
				World.w.app.vis.x = 444;
				World.w.app.vis.fon.visible = false;
			}
		}	
	}	
}