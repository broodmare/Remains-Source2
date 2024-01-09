package fe.inter {
	
	import fe.*;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class PipPageApp extends PipPage{
		

		public function PipPageApp(npip:PipBuck, npp:String) {
			itemClass=visPipQuestItem;
			super(npip,npp);
			vis.but1.visible=vis.but2.visible=vis.but3.visible=vis.but4.visible=vis.but5.visible=false;
		}
		
		//принять настройки внешности
		public function funVidOk() {
			World.w.gg.refreshVis();
			pip.onoff(-1);
		}
		//принять настройки внешности
		public function funVidCancel() {
			pip.onoff(-1);
		}

		override function setSubPages() {
			vis.bottext.visible=false;
			vis.butOk.visible=false;
			statHead.visible=false;

			setTopText();
			if (page2==1) {
				pip.ArmorId='';
				World.w.app.attach(vis,funVidOk,funVidCancel);
				World.w.app.vis.y=400;
				World.w.app.vis.x=444;
				World.w.app.vis.fon.visible=false;
			}
		}
		
		
	}
	
}
