package fe.game.ui {

	import fe.game.GameContainer;

	import fe.game.stubs.visPipQuestItem;
	
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
			GameContainer.reference.gg.refreshVis();
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
				pip.armorID = "";
				GUIManager.reference.app.attach(vis, funVidOk, funVidCancel);
				GUIManager.reference.app.vis.y = 400;
				GUIManager.reference.app.vis.x = 444;
				GUIManager.reference.app.vis.fon.visible = false;
			}
		}	
	}	
}