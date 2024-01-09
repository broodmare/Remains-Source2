package fe.inter
{
	import fe.*;

	import fe.stubs.visPipQuestItem;
	
	public class PipPageApp extends PipPage
	{
		public function PipPageApp(npip:PipBuck, npp:String):void
		{
			itemClass=visPipQuestItem;
			super(npip,npp);
			vis.but1.visible=vis.but2.visible=vis.but3.visible=vis.but4.visible=vis.but5.visible=false;
		}
		
		//принять настройки внешности
		public function funVidOk():void
		{
			World.w.gg.refreshVis();
			pip.onoff(-1);
		}
		
		//принять настройки внешности
		public function funVidCancel():void
		{
			pip.onoff(-1);
		}

		override protected function setSubPages():void
		{
			vis.bottext.visible=false;
			vis.butOk.visible=false;
			statHead.visible=false;

			setTopText();
			if (page2==1)
			{
				pip.ArmorId='';
				World.w.app.attach(vis,funVidOk,funVidCancel);
				World.w.app.vis.y=400;
				World.w.app.vis.x=444;
				World.w.app.vis.fon.visible=false;
			}
		}	
	}	
}