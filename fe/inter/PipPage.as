package fe.inter {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;

	import fl.controls.ScrollBar;	// Adobe Animate dependency
	import fl.events.ScrollEvent;	// Adobe Animate dependency

	import fe.*;
	import fe.unit.Invent;
	import fe.unit.Pers;
	import fe.unit.Unit;
	import fe.unit.Armor;
	import fe.unit.UnitPlayer;
	import fe.loc.Quest;
	import fe.weapon.Weapon;
	import fe.serv.Item;
	import fe.loc.LandAct;
	import fe.unit.UnitPet;
	import fe.unit.Effect;

	import fe.stubs.visPipInv;
	
	public class PipPage {

		public var vis:MovieClip;
		public var arr:Array;
		public var statArr:Array;
		public var statHead:MovieClip;
		public var pageClass:Class;
		public var itemClass:Class;
		public var maxrows:int=18;
		public var selItem:MovieClip;
		public var pip:PipBuck;
		public var inv:Invent;
		public var gg:UnitPlayer;
		public var isLC:Boolean=false;
		public var isRC:Boolean=false; //реакция на клик
		public var signs:Array=[0, 0, 0, 0, 0, 0];
		public var page2:int=1;
		private var scrl:int=0;
		private var infIco:MovieClip;
		private var itemFilter:GlowFilter=new GlowFilter(0x00FF88, 1, 3, 3, 3, 1);
		private var itemTrans:ColorTransform=new ColorTransform(1, 1, 1);
		private var pp:String;
		private var kolCats:int = 6;
		private var cat:Array = [0, 0, 0, 0, 0, 0, 0];
		public var curTip = '';
		public var tips:Array = [[]];

		public static var infoCache:Object = {}; // Global cache for item descriptions

		private static var damageTypes:Array = [
			{type: Unit.D_BUL,		label: 'bullet'},
			{type: Unit.D_EXPL,		label: 'expl'},
			{type: Unit.D_PHIS,		label: 'phis'},
			{type: Unit.D_BLADE,	label: 'blade'},
			{type: Unit.D_FANG,		label: 'fang'},
			{type: Unit.D_FIRE,		label: 'fire'},
			{type: Unit.D_LASER,	label: 'laser'},
			{type: Unit.D_PLASMA,	label: 'plasma'},
			{type: Unit.D_SPARK,	label: 'spark'},
			{type: Unit.D_CRIO,		label: 'crio'},
			{type: Unit.D_VENOM,	label: 'venom'},
			{type: Unit.D_ACID,		label: 'acid'},
			{type: Unit.D_NECRO,	label: 'necro'}
		];
		
		//setStatItems - обновить все элементы, не перезагружая страницу
		//setStatus - полностью обновить страницу

		// Constructor
		public function PipPage(npip:PipBuck, npp:String) {
			
			pip = npip;
			pp = npp;

			if (pageClass == null) {
				pageClass = visPipInv;
			}
			
			vis=new pageClass();
			vis.x=165;
			vis.y=72;
			vis.visible=false;
			
			if (vis.pers) {
				vis.pers.visible = false
			}
			
			if (vis.skill) {
				vis.skill.visible = false;
			}
			
			if (vis.item) {
				vis.item.visible = false
			}
			
			pip.vis.addChild(vis);
			
			vis.scBar.addEventListener(ScrollEvent.SCROLL, statScroll); // Adobe Animate Dependency
			vis.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel1);
			statArr = [];
			
			var item:MovieClip;
			
			for (var i:int = -1; i < maxrows; i++) {
				item = new itemClass(); 
				item.x = 30;
				item.y = 100 + i * 30;
				
				if (item.nazv) {
					setStyle(item.nazv);
				}
				
				vis.addChild(item);
				
				if (item.ramka) item.ramka.visible=false;
				
				if (i<0) {
					item.back.visible=false;
					statHead=item;
				}
				else {
					if (isLC) item.addEventListener(MouseEvent.CLICK,itemClick);
					if (isRC) item.addEventListener(MouseEvent.RIGHT_CLICK,itemRightClick);
					item.addEventListener(MouseEvent.MOUSE_OVER,statInfo);
					statArr.push(item);
				}
			}
			
			for (var j:int = 1; j <= 5; j++) {
				item = vis.getChildByName('but' + j) as MovieClip;
				item.addEventListener(MouseEvent.CLICK, page2Click);
				item.text.text = Res.pipText(pp + j);
				item.id.text = j;
				item.id.visible = false;
			}
			
			vis.butOk.visible=false;
			vis.butDef.visible=false;
			
			if (vis.cats) {
				vis.cats.visible = false;
			}
			
			setStyle(vis.info);
			setStyle(vis.bottext);
		}
		
		public static function setStyle(tt:TextField):void {
			var style:StyleSheet = new StyleSheet(); 
			var styleObj:Object = new Object();
			styleObj.color = "#00FF99"; 
			style.setStyle(".r0", styleObj); 	//по умолчанию зелёный
			
			styleObj.color = "#FF3333"; 
			style.setStyle(".red", styleObj);	//красный
			styleObj.color = "#FFFF33"; 
			style.setStyle(".yellow", styleObj);	//жёлтый
			styleObj.color = "#FF9900"; 
			style.setStyle(".or", styleObj);	//оранжевый
			styleObj.color = "#FC7FED"; 
			style.setStyle(".pink", styleObj);	//розовый
			styleObj.color = "#00FFFF"; 
			style.setStyle(".blue", styleObj);	//голубой
			styleObj.color = "#99CCFF"; 
			style.setStyle(".lightBlue", styleObj);	//серо-голубой
			styleObj.color = "#007E4B"; 
			style.setStyle(".dark", styleObj);	//7 - тёмно-зелёный
			styleObj.color = "#8AFFD0"; 
			style.setStyle(".light", styleObj);	//7 - светло-зелёный
			styleObj.color = "#33FF33"; 
			style.setStyle(".green", styleObj);	//зелёный
			styleObj.color = "#B466FF"; 
			style.setStyle(".purp", styleObj);	//фиолет
			tt.styleSheet=style;
		}
		
		//Print colored text
		public static function textAsColor(color:String, text:String):String {
			return "<span class = " + "'" + color + "'" + ">" + text + "</span>";
		}

		public static function numberAsColor(color:String, number:Number):String {
			return "<span class = " + "'" + color + "'" + ">" + number.toString() + "</span>";
		}

		public function updateLang():void {
			for (var i:int = 1; i <= 5; i++) {
				var button:MovieClip = vis.getChildByName('but'+i) as MovieClip;
				button.text.text = Res.pipText(pp + i);
			}
		}

		// Clicking on one of the sub-categories at the top of the page
		protected function page2Click(event:MouseEvent):void {
			if (World.w.ctr.setkeyOn) {
				return;
			}

			var clickedPage:int = int(event.currentTarget.id.text);
			trace("PipPage.as/page2Click() - Current page2: " + page2 + ", Clicked page: " + clickedPage);

			// Check if the clicked subcategory is the same as the current one
			if (clickedPage == page2) {
				trace("PipPage.as/page2Click() - Selected the same sub-category, aborting");
				pip.snd(2);    // Play the button press sound anyway
				return;
			}

			// Update the current subcategory
			page2 = clickedPage;
			trace("PipPage.as/page2Click() - Changing page2 to: " + page2);

			setStatus();
			pip.snd(2);
		}
		
		private function setButtons():void {
			for (var i:int = 1; i <= 5; i++) {
				var item:MovieClip = vis.getChildByName('but' + i) as MovieClip;
				
				if (page2 == i) {
					item.gotoAndStop(2);
				}
				else if (signs[i] > 0) {
					item.gotoAndStop(signs[i] + 2);
				}
				else {
					item.gotoAndStop(1);
				}
			}
		}
		
		public function setStatus(flop:Boolean=true):void {
			trace("PipPage.as/setStatus() - ");
			pip.reqKey = false;
			statHead.id.text = '';
			vis.visible = true;
			vis.info.text = '';
			vis.nazv.text = '';
			vis.bottext.text = '';
			vis.emptytext.text = '';
			arr = [];
			
			if (flop) {
				scrl = 0;
			}
			
			if (vis.scText) {
				vis.scText.visible = false;
			}
			
			gg = pip.gg;
			inv = pip.inv;
			pip.vis.toptext.visible = false;
			pip.vis.butHelp.visible = false;
			pip.vis.butMass.visible = false;
			pip.vishelp.visible = false;
			
			setSubPages();
			
			setStatItems(flop?0:-1);

			var sc:ScrollBar = vis.scBar; // Adobe Animate dependency

			if (arr.length>maxrows) {
				sc.visible=true;
				sc.minScrollPosition=0
				sc.maxScrollPosition=arr.length-maxrows;
				sc.scrollPosition=scrl;
			} 
			else sc.visible=false;

			setSigns();
			setButtons();
		}
		
		//подготовка страниц
		protected function setSubPages():void {

		}

		//определение подсвеченности кнопок
		protected function setSigns():void {
			signs = [0,0,0,0,0,0];
		}
		
		//показ одного элемента
		protected function setStatItem(item:MovieClip, obj:Object):void {

		}
		
		//информация об элементе
		protected function statInfo(event:MouseEvent):void {

		}
		
		protected function itemClick(event:MouseEvent):void {

		}

		protected function itemRightClick(event:MouseEvent):void {

		}
		
		//показ всех элементов
		protected function setStatItems(n:int=-1):void {
			if (n >= 0) scrl = n;
			for (var i:int = 0; i < statArr.length; i++) {
				if (i+scrl>=arr.length) {
					statArr[i].visible=false;
				}
				else {
					statArr[i].visible=true;
					setStatItem(statArr[i],arr[i+scrl]);
				}
			}
		}
		
		protected function setIco(tip:int = 0, id:String = ''):void {
			if (infIco && vis.ico.contains(infIco)) vis.ico.removeChild(infIco);
			vis.pers.visible = false;
			vis.skill.visible = false;
			vis.item.gotoAndStop(1);
			vis.info.y = vis.ico.y;
			if (tip == 1) { // Weapon 
				var w:Weapon = pip.arrWeapon[id];
				if (w.tip == 5) {
					tip = 3;
					if (id.charAt(id.length-2)=='^') id=id.substr(0,id.length-2);
				}
				else {
					var vWeapon:Class = w.vWeapon;
					var node:XML = Weapon.getWeaponInfo(id);
					if (node != null) {
						if (node.vis.length() && node.vis[0].@vico.length()) vWeapon=Res.getClass(node.vis[0].@vico, null);
					}
					if (vWeapon==null) {
						vWeapon=Res.getClass('vis'+id, null);
					}
					if (vWeapon!=null) {
						infIco=new vWeapon();
						infIco.stop();
						if (infIco.lez) infIco.lez.stop();
						var r:Number=1;
						if (node != null && node.vis.length()) {
							if (node.vis.@icomult.length()) r=infIco.scaleX=infIco.scaleY=node.vis.@icomult;
						}
						infIco.x=-infIco.getRect(infIco).left*r+140-infIco.width/2;
						infIco.y=-infIco.getRect(infIco).top;
						vis.ico.addChild(infIco);
						vis.info.y=vis.ico.y+vis.ico.height+10;
						infIco.transform.colorTransform=itemTrans;
						infIco.filters=[itemFilter];
					}
				}
			}
			if (tip==2) {//бронька
				pip.setArmor(id);
				vis.pers.gotoAndStop(2);
				vis.pers.gotoAndStop(1);
				vis.pers.head.morda.magic.visible=false;
				vis.pers.visible=true;
				vis.info.y=vis.pers.y+25;
			}
			if (tip==3) {
				vis.item.visible=true;
				try
				{
					vis.item.gotoAndStop(id);
					vis.info.y = vis.item.y + vis.item.height + 25;
				}
				catch(err)
				{
					//trace('ERROR: (00:35) - invalid icon ID: "' + id + '"!');
					vis.item.gotoAndStop(1);
					vis.item.visible = false;
					vis.info.y = vis.ico.y;
				}
			}
			if (tip==5) {//перки
				vis.skill.visible=true;
				try
				{
					vis.skill.gotoAndStop(id);
					vis.info.y=vis.ico.y+220;
				}
				catch(err)
				{
					trace('ERROR: (00:36)');
					vis.skill.visible=false;
					vis.info.y=vis.ico.y;
				}
			}
		}

		// [add values ​​to text string]
		public static function addVar(s:String, xml:XML):String {
			for (var i:int = 1; i <= 5; i++) {
				if (xml.attribute('s' + i).length())  s = s.replace('#' + i, "<span class='yellow'>" + xml.attribute('s' + i) + "</span>");
			}
			return s;
		}
		
		// [dlvl=1 if the perk is not current, but selectable]
		public static function effStr(tip:String, id:String, dlvl:int=0):String {
			var s:String;
			if (tip=='item') s=Res.txt('i',id,1)
			else s=Res.txt('e',id,1);
			if (id.substr(-3)=='_ad') id=id.substr(0,id.length-3);

			var typeName:String = tip + 's';
			var dp = Effect.getEffectInfo(id);

			if (dp == null) return s;
			dp = dp.(@id==id);
			if (dp.length()==0) return s;
			dp=dp[0];
			//определение текущего уровня
			var lvl:int = 1;
			var pers:Pers = World.w.pers;

			if (tip == 'perk') {
				lvl = pers.perks[id];
				if (lvl < 0) lvl = 0;
			}
			else if (tip == 'skill') {
				lvl = pers.getSkLevel(pers.skills[id]);
			}
			else if (dp.@him == '2') {
				var ad = pers.addictions[id];
				if (ad >= pers.ad2) lvl = 2;
				if (ad >= pers.ad3) lvl = 3;
			}
			else if (dp.@him == '1') {
				lvl = pers.himLevel;
			}
			
			lvl += dlvl;
			
			// [Inserting numeric values ​​into text]
			if (lvl > 1 && dp.textvar[lvl - 1]) s = addVar(s, dp.textvar[lvl - 1]);
			else if (dp.textvar.length()) s = addVar(s, dp.textvar[0]);
			
			// [Adding special effects]
			if (dp.eff.length() && lvl > 0) {
				s+='<br>';
				for each(var eff in dp.eff) {
					s+='<br>'+(eff.@id.length()?Res.pipText(eff.@id):Res.pipText('refeff'))+': '+textAsColor('yellow', eff.attribute('n'+lvl));
				}
			}
			
			// [Adding weight effects]
			if (World.w.hardInv && dp.sk.length()) {
				s += '<br>';
				for each(var sk in dp.sk) {
					if (sk.@tip == 'm') {
						var add:String = textAsColor('lightBlue', '+1');
						
						if (sk.@vd > 0) {
							add = textAsColor('lightBlue', '+' + sk.@vd) + ' ' + Res.pipText('perlevel');
						}
						
						if (sk.@v1 > 0) {
							add = textAsColor('lightBlue', '+' + sk.@v1);
						}
						
						s+='<br>'+Res.pipText('add_'+sk.@id)+' '+add;
					}
				}
			}
			
			// [Adding requirements]
			if (dp.req.length()) {
				s += '<br><br>' + Res.pipText('requir');
				lvl--;
				for each(var req in dp.req) {
					
					var reqlevel:int = 1;
					
					if (req.@lvl.length()) reqlevel = req.@lvl;
					
					if (lvl > 0 && req.@dlvl.length()) reqlevel += lvl * req.@dlvl;
					
					var s1:String = '<br>';
					var ok:Boolean = true;
					
					if (req.@id=='level') {
						s1+=Res.pipText('level');
						if (pers.level<reqlevel) ok=false;
					}
					else if (req.@id=='guns') {
						s1+=Res.txt('e','smallguns')+' '+Res.pipText('orange')+' '+Res.txt('e','energy');
						if (pers.getSkLevel(pers.skills['smallguns'])<reqlevel && pers.getSkLevel(pers.skills['energy'])<reqlevel) ok=false;
					}
					else {
						s1+=Res.txt('e',req.@id);
						if (pers.getSkLevel(pers.skills[req.@id])<reqlevel) ok=false;
					}
					
					s1 += ': ' + reqlevel;
					
					if (ok)	{
						s += textAsColor('yellow', s1);
					}
					else {
						s += textAsColor('red', s1);
					}
				}
			}
			return s;
		}
		
		
		public static function infoStr(tip:String, id:String):String {
			// Generate a unique cache key
			var cacheKey:String = tip + ":" + id;

			// Check if the value is already cached
			if (infoCache[cacheKey] != null) {
				return infoCache[cacheKey];
			}
			
			var s:String='';
			var pip:PipBuck = World.w.pip;
			var gg:UnitPlayer = World.w.gg;
			var inv:Invent=World.w.invent;
			
			if (tip==Item.L_ARMOR && inv.armors[id]==null && pip.arrArmor[id]==null) tip=Item.L_ITEM;
			if (tip==Item.L_WEAPON && inv.weapons[id] && inv.weapons[id].spell) tip=Item.L_ITEM;
			if (tip==Item.L_WEAPON || tip==Item.L_EXPL) {
				var w:Weapon = pip.arrWeapon[id];
				if (w==null) return '';
				w.setPers(gg,gg.pers);
				var skillConf:int = 1;
				var razn:int = w.lvl-gg.pers.getWeapLevel(w.skill);
				if (razn == 1) skillConf = 0.75;
				if (razn >= 2) skillConf = 0.5;
				w.skillConf = skillConf;
				s += Res.pipText('weapontip') + ': ' + textAsColor('yellow', Res.pipText('weapontip' + w.skill));
				if (w.lvl>0) {
					s+='\n'+Res.pipText('lvl')+': '+numberAsColor('yellow', w.lvl);
					s += '\n' + Res.pipText('islvl') + ': ' + textAsColor('yellow', gg.pers.getWeapLevel(w.skill).toString());
					if (razn>0) s+="<span class = 'red'>";
					if (w.lvlNoUse && razn>0 || razn>2) s+=' ('+Res.pipText('weapnouse')+')</span>';
					else if (razn>0){
						if (razn==2) {
							s+=' (-40% ';
						}
						else if (razn==1) {
							s+=' (-20% ';
						}
						if (w.tip==1) s+=Res.pipText('rapid')
						else if (w.tip==4) s+=Res.pipText('distance');
						else s+=Res.pipText('precision');
						s+=")</span>";
					}
				}
				if (w.perslvl>0) {
					s+='\n'+Res.pipText('perslvl')+': '+numberAsColor('yellow', w.perslvl);
					s+='\n'+Res.pipText('isperslvl')+': '+textAsColor('yellow', gg.pers.level.toString());
					if (gg.pers.level<w.perslvl) s+=textAsColor('red', ' ('+Res.pipText('weapnouse')+')');
				}
				s+='\n'+Res.pipText('damage')+': ';
				var wdam:Number = w.damage;
				var wdamexpl:Number = w.damageExpl;
				if (w.damage>0) {
					s+=numberAsColor('yellow', Math.round(w.damage*10)/10);
					wdam=w.resultDamage(w.damage,gg.pers.weaponSkills[w.skill]);
					if (wdam!=w.damage) {
						s+=' ('+numberAsColor('yellow', Math.round(wdam*10)/10)+')';
					}
				}
				if (w.damage>0 && w.damageExpl>0) s+=' + ';
				if (w.damageExpl>0) {
					s+=numberAsColor('yellow', Math.round(w.damageExpl*w.damMult*10)/10);
					wdamexpl=w.resultDamage(w.damageExpl,gg.pers.weaponSkills[w.skill]);
					if (wdamexpl!=w.damageExpl) {
						s+=' ('+numberAsColor('yellow', Math.round(wdamexpl*10)/10)+')';
					}
					s+=' '+Res.pipText('expldam');
				}
				if (w.kol>1) s+=' [x'+w.kol+']';
				if (w.explKol>1) s+=' [x'+w.explKol+']';
				var wrapid:int = w.resultRapid(w.rapid);
				if (w.tip!=4) {
					s+='\n'+Res.pipText('aps')+': '+textAsColor('yellow', Number(World.fps/wrapid).toFixed(1));
					s+='\n'+Res.pipText('dps')+': '+textAsColor('yellow', Number((wdam+wdamexpl)*w.kol*World.fps/wrapid).toFixed(1));
					if (w.holder) s+=' ('+textAsColor('yellow', Number((wdam+wdamexpl)*w.kol*World.fps/(wrapid+w.reload*w.reloadMult/w.holder*w.rashod)).toFixed(1))+')';
				}
				s+='\n'+Res.pipText('critch')+': '+textAsColor('yellow', Math.round((w.critCh+w.critchAdd+gg.critCh)*100)+'%');
				s+='\n'+Res.pipText('tipdam')+': '+textAsColor('blue', Res.pipText('tipdam'+w.tipDamage));
				if (w.tip<4 && w.holder>0) s+='\n'+Res.pipText('inv5')+': '+textAsColor('yellow', Res.txt('i',w.ammo));
				if (w.tip<4 && w.holder>0) s+='\n'+Res.pipText('holder')+': '+numberAsColor('yellow', w.holder);
				if (w.rashod>1) s+=' ('+numberAsColor('yellow', w.rashod)+' '+Res.pipText('rashod')+')';
				if (w.tip==5) s+='\n'+Res.pipText('dmana')+': '+numberAsColor('yellow', Math.round(w.mana));
				if (w.precision>0) s+='\n'+Res.pipText('prec')+': '+numberAsColor('yellow', Math.round(w.precision*w.precMult/40));
				if (w.pier+w.pierAdd>0) s+='\n'+Res.pipText('pier')+': '+numberAsColor('yellow', Math.round(w.pier+w.pierAdd));
				if (!w.noSats) {
					s+='\n'+Res.pipText('ap')+': ';
					if (razn>0) s+="<span class = 'red'>";
					else s+="<span class = 'yellow'>";
					s+=Math.round(w.satsCons*w.consMult/skillConf*gg.pers.satsMult);
					s+="</span>";
					if (w.satsQue>1) s+=' (x'+numberAsColor('yellow', w.satsQue)+')';
				}
				if (w.destroy>=100) {
					s+='\n'+Res.pipText('destroy');
				}
				if (w.opt && w.opt.perk) {
					s+='\n'+Res.pipText('refperk')+': '+textAsColor('pink', Res.txt('e',w.opt.perk));
				}
				var sinf:String = Res.txt('w', id, 1);
				if (sinf=='') sinf=Res.txt('w',w.id,1);
				if (World.w.hardInv && w.tip<4) s+='\n'+Res.pipText('mass2')+": <span class = 'mass'>"+w.mass+"</span>";
				if (World.w.hardInv && w.tip==4) s+='\n\n'+Res.pipText('mass')+": <span class = 'mass'>"+inv.items[id].xml.@m+"</span> ("+Res.pipText('vault'+inv.items[id].invCat)+')';
				s+='\n\n'+sinf;
			}
			else if (tip==Item.L_ARMOR) {
				var a:Armor = inv.armors[id];
				if (a == null) a = pip.arrArmor[id];

				// Print all armor bonuses if they exist
				if (a.armor_qual>0) s+=Res.pipText('aqual')+': '+textAsColor('yellow', Math.round(a.armor_qual*100)+'%');
				if (a.armor>0) s+='\n'+Res.pipText('armor')+': '+numberAsColor('yellow', Math.round(a.armor));
				if (a.marmor>0) s+='\n'+Res.pipText('marmor')+': '+numberAsColor('yellow', Math.round(a.marmor));
				if (a.dexter!=0) s+='\n'+Res.pipText('dexter')+': '+textAsColor('yellow', Math.round(a.dexter*100)+'%');
				if (a.sneak!=0) s+='\n'+Res.pipText('sneak')+': '+textAsColor('yellow', Math.round(a.sneak*100)+'%');
				if (a.meleeMult!=1) s+='\n'+Res.pipText('meleedamage')+': +'+textAsColor('yellow', Math.round((a.meleeMult-1)*100)+'%');
				if (a.gunsMult!=1) s+='\n'+Res.pipText('gunsdamage')+': +'+textAsColor('yellow', Math.round((a.gunsMult-1)*100)+'%');
				if (a.magicMult!=1) s+='\n'+Res.pipText('spelldamage')+': +'+textAsColor('yellow', Math.round((a.magicMult-1)*100)+'%');
				if (a.crit!=0) s+='\n'+Res.pipText('critch')+': +'+textAsColor('yellow', Math.round(a.crit*100)+'%');
				if (a.radVul<1) s+='\n'+Res.pipText('radx')+': '+textAsColor('yellow', Math.round((1-a.radVul)*100)+'%');
				
				// Print all armor resistances if they exist
				for (var i:int = 0; i < damageTypes.length; i++)
				{
					var damageType:Object = damageTypes[i];
					if (a.resist[damageType.type] != 0) {
						s += '\n' + Res.pipText(damageType.label) + ': ' + textAsColor('yellow', Math.round(a.resist[damageType.type] * 100) + '%');
					}
				}
				
				s += '\n\n'+Res.txt('a',id,1);
			}
			else if (tip==Item.L_AMMO) {
				var ammo:XML = inv.items[id].xml;
				if (Weapon.getWeaponInfo(id) != null) {
					s = Res.txt('w',id,1);
				}
				else if (ammo.@base.length()) {
					s=Res.txt('i',ammo.@base,1);
					if (ammo.@mod>0) {
						s+='\n\n'+Res.txt('p','ammomod_'+ammo.@mod,1);
					}
				}
				else s = Res.txt('i', id, 1);
				s+='\n';
				if (ammo.@damage.length()) s+='\n'+Res.pipText('damage')+': x'+textAsColor('yellow', ammo.@damage);
				if (ammo.@pier.length()) s+='\n'+Res.pipText('pier')+': '+textAsColor('yellow', ammo.@pier);
				if (ammo.@armor.length()) s+='\n'+Res.pipText('tarmor')+': x'+textAsColor('yellow', ammo.@armor);
				if (ammo.@prec.length()) s+='\n'+Res.pipText('prec')+': x'+textAsColor('yellow', ammo.@prec);
				if (ammo.@det>0) s+='\n'+Res.pipText('det');
				if (World.w.hardInv && ammo.@m>0) s+='\n\n'+Res.pipText('mass')+": <span class = 'mass'>"+ammo.@m+"</span> ("+Res.pipText('vault'+inv.items[id].invCat)+')';
				if (ammo.@sell>0) s+='\n'+Res.pipText('sell')+": "+textAsColor('yellow', ammo.@sell);
			}
			else {
				var hhp:Number=0;
				s=Res.txt('i',id,1)+'\n';
				var pot:XML = inv.items[id].xml;
				tip=pot.@tip;
				if (tip=='instr' || tip=='impl'|| tip=='art') {
					s=effStr('item',id)+'\n';
				}
				if (tip=='med' || tip=='food'|| tip=='pot' || tip=='him') {
					if (pot.@hhp.length() || pot.@hhplong.length())
					s+='\n'+Res.pipText('healhp')+': '+numberAsColor('yellow', Math.round(pot.@hhp*World.w.pers.healMult));
					if (pot.@hhplong.length()) s+='+'+numberAsColor('yellow', Math.round(pot.@hhplong*World.w.pers.healMult));
					if (pot.@hrad.length()) s+='\n'+Res.pipText('healrad')+': '+numberAsColor('yellow', Math.round(pot.@hrad*World.w.pers.healMult));
					if (pot.@hcut.length()) s+='\n'+Res.pipText('healcut')+': '+numberAsColor('yellow', Math.round(pot.@hcut));
					if (pot.@hpoison.length()) s+='\n'+Res.pipText('healpoison')+': '+numberAsColor('yellow', Math.round(pot.@hpoison));
					if (pot.@horgan.length()) s+='\n'+Res.pipText('healorgan')+': '+numberAsColor('yellow', Math.round(pot.@horgan));
					if (pot.@horgans.length()) s+='\n'+Res.pipText('healorgans')+': '+numberAsColor('yellow', Math.round(pot.@horgans));
					if (pot.@hblood.length()) s+='\n'+Res.pipText('healblood')+': '+numberAsColor('yellow', Math.round(pot.@hblood));
					if (pot.@hmana.length()) s+='\n'+Res.pipText('healmana')+': '+numberAsColor('yellow', Math.round(pot.@hmana*World.w.pers.healManaMult));
					if (pot.@alc.length()) s+='\n'+Res.pipText('alcohol')+': '+numberAsColor('yellow', Math.round(pot.@alc));
					if (pot.@rad.length()) s+='\n'+Res.pipText('rad')+': '+numberAsColor('yellow', Math.round(pot.@rad));
					if (pot.@effect.length()) s+='\n'+Res.pipText('refeff')+': '+effStr('eff',pot.@effect);
					if (pot.@perk.length()) s+='\n'+textAsColor('pink', Res.txt('e',pot.@perk))+': '+Res.pipText('level')+' '+(World.w.pers.perks[pot.@perk]>0?World.w.pers.perks[pot.@perk]:'0');
					if (pot.@maxperk.length()) s+='/'+pot.@maxperk;
				}
				if (tip=='book') {
					if (World.w.pers.skills[id]!=null) s+='\n'+Res.pipText('skillup')+': '+textAsColor('pink', Res.txt('e',id));
				}
				if (tip=='spell') {
					s+='\n'+Res.pipText('dmana2')+': '+textAsColor('yellow', pot.@mana)+' ('+numberAsColor('yellow', Math.round(pot.@mana*World.w.pers.allDManaMult))+')';
					s+='\n'+Res.pipText('culd')+': '+textAsColor('yellow', pot.@culd+Res.guiText('sec'))+' ('+textAsColor('yellow', Math.round(pot.@culd*World.w.pers.spellDown)+Res.guiText('sec'))+')';
					s+='\n'+Res.pipText('is1')+': '+textAsColor('pink', (pot.@tele>0)?Res.txt('e','tele'):Res.txt('e','magic'));
				}
				if (id=='rep') {
					if (pot.@hp.length()) hhp=pot.@hp*gg.pers.repairMult;
					if (hhp>0) s+='\n'+Res.pipText('effect')+': '+numberAsColor('yellow', Math.round(hhp));
				}
				if (pot.@pet_info.length()) {
					var pet:UnitPet=gg.pets[pot.@pet_info];
					if (pet) {
						s+='\n'+Res.pipText('hp')+': '+numberAsColor('yellow', Math.round(pet.hp))+'/'+numberAsColor('yellow', Math.round(pet.maxhp));
						s+='\n'+Res.pipText('skin')+': '+numberAsColor('yellow', Math.round(pet.skin));
						if (pet.allVulnerMult<1) s+='\n'+Res.pipText('allresist')+': '+textAsColor('yellow', Math.round((1-pet.allVulnerMult)*100)+'%');
						s+='\n'+Res.pipText('damage')+': '+numberAsColor('yellow', Math.round(pet.dam));
					}
				}
				if (tip=='paint') s=Res.txt('p','paint',1);
				if (World.w.hardInv && pot.@m>0) s+='\n\n'+Res.pipText('mass')+": <span class = 'mass'>"+pot.@m+"</span> ("+Res.pipText('vault'+inv.items[id].invCat)+')';
				if (pot.@sell>0) s+='\n'+Res.pipText('sell')+": "+textAsColor('yellow', pot.@sell);
			}

			// Cache the result before returning
			infoCache[cacheKey] = s;
			return s;
		}
		
		protected function infoItem(tip:String, itemID:String, nazv:String, craft:int=0):void {
			vis.nazv.text = nazv;

			var s:String;
			var id:String = itemID;

			if (itemID.indexOf('s_') == 0) {
				id = itemID.substr(2);
				craft = 1;
				
				if (Weapon.getWeaponInfo(id))		tip = Item.L_WEAPON;
				else if (Armor.getArmorInfo(id))	tip = Item.L_ARMOR;
				else tip = Item.L_ITEM;
			}

			if (tip == Item.L_WEAPON || tip == Item.L_EXPL) {
				if (craft > 0) setIco();
				else setIco(1, id);

				s = infoStr(tip, id);
				if (craft == 1) s += craftInfo(id);
				if (craft == 2) s += craftInfo(id.substr(0, id.length - 2));
			}
			else if (tip == Item.L_ARMOR) {
				var a:Armor=inv.armors[id];
				if (a == null) a = pip.arrArmor[id];

				if (craft > 0) setIco();
				else if (a.tip == 3) setIco(3, id);
				else setIco(2, id);

				s = infoStr(tip, id);
				if (craft == 2)
				{
					var cid:String = a.idComp;
					var kolcomp:int = a.needComp();
					s += "\n\n<span class = 'orange'>" + Res.txt('i', cid) +  " - " + kolcomp + " <span ";
					if (!World.w.loc.base && kolcomp>inv.items[cid].kol || World.w.loc.base && kolcomp>inv.items[cid].kol+inv.items[cid].vault) s+="class='red'"
					s += "> ("+inv.items[cid].kol;
					if (World.w.loc.base && inv.items[cid].vault > 0) s += ' +' + inv.items[cid].vault;
					s += ")</span></span>";
				}
				if (craft == 1) s += craftInfo(id);
			}
			else if (tip == Item.L_AMMO) {
				var ammo:XML = inv.items[id].xml;
				if (ammo.@base.length())
				{
					vis.nazv.text = Res.txt('i', ammo.@base);

					if (ammo.@mod > 0) vis.nazv.text += '\n' + Res.pipText('ammomod_' + ammo.@mod);
					else vis.nazv.text += '\n' + Res.pipText('ammomod_0');
				}
				setIco();
				s = infoStr(tip, id);
			}
			else {
				if (craft > 0) setIco();
				else setIco(3, id);
				s = infoStr(tip, id);
				if (craft == 1) s += craftInfo(id);
			}

			vis.info.htmlText = s;
			vis.info.height = 680 - vis.info.y;
			vis.info.scaleX = 1;
			vis.info.scaleY = 1;

			if (vis.scText) vis.scText.visible = false;

			if (vis.info.height<vis.info.textHeight && vis.scText) {
				vis.scText.maxScrollPosition = vis.info.maxScrollV;
				vis.scText.visible = true;
			}
		}
		
		public function craftInfo(id:String):String {
			var s:String='\n';
			var cs:String = 's_' + id;
			var sch:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "items", "id", cs);
			var kol:int=1;
			if (sch.@kol.length()) kol=sch.@kol;
			if (sch.@perk=='potmaster' && gg.pers.potmaster) kol*=2;
			if (kol>1) s+=Res.pipText('crekol')+": "+kol+"\n";
			if (sch.@skill.length() && sch.@lvl.length()) {
				s+="\n"+Res.pipText('needskill')+": <span class = '";
				if (gg.pers.getSkillLevel(sch.@skill)<sch.@lvl) s+="red";
				else s+="pink";
				s+="'>"+Res.txt('e',sch.@skill)+" - "+sch.@lvl+"</span>\n";
			}
			for each(var c:XML in sch.craft) {
				s+="\n<span class = 'orange'>"+Res.txt('i',c.@id)+ " - "+c.@kol+" <span ";
				if (!World.w.loc.base && c.@kol>inv.items[c.@id].kol
				  || World.w.loc.base && c.@kol>inv.items[c.@id].kol+inv.items[c.@id].vault) s+="class='red'";
				s+=">("+inv.items[c.@id].kol;
				if (World.w.loc.base && inv.items[c.@id].vault>0) s+=' +'+inv.items[c.@id].vault;
				s+=")</span></span>";
			}
			return s;
		}
		
		protected function infoQuest(id:String):String {
				var q:Quest=World.w.game.quests[id];
				if (q==null) return '';
				vis.nazv.text=q.nazv;
				var s:String=q.info;
				if (q.empl) s+='<br><br>'+Res.txt('u',q.empl);
				s+='\n';
				var n:int=1;
				for each(var st:Quest in q.subs) {
					if (st.invis && st.state<2) continue;
					s+="\n";
					if (st.state==2) s+="<span class = 'dark'>";
					s+=textAsColor('yellow', n+'.')+" "
					if (st.hidden && st.state<2 && st.est<=0) s+='?????';
					else s+=st.nazv;
					if (st.collect && st.colTip==0) {
						if (st.give) {
							s+=' ('+textAsColor('yellow', st.gived+'/'+st.kol)+')';
							if (st.est>0 && st.state<2) s+=' ('+textAsColor('yellow', '+'+st.est)+')';
						} else s+=' ('+textAsColor('yellow', st.est+'/'+st.kol)+')';
					}
					if (st.nn) s+=' ('+Res.pipText('nn')+')';
					if (st.state==2) s+="</span>";
					n++;
				}
				return s;
		}
		
		protected function factor(id:String):String {
			var s:String='', s1:String;
			var ok:Boolean = false;
			if (World.w.pers.factor[id] is Array) {
				var paramList:XMLList = XMLDataGrabber.getNodesWithName("core", "AllData", "params", "param");

				var xml = paramList.(@v==id);
				if (xml.@tip=='4') s+='- '+Res.pipText('begvulner')+': '+textAsColor('yellow', '100%')+'\n';
				for each (var obj in World.w.pers.factor[id]) {
					if (obj.id=='beg') {
						if (xml.@nobeg>0) continue;
						if (xml.@tip=='0') {
							if (obj.res!=0) s+='- '+Res.pipText('begval')+': '+textAsColor('yellow', Res.numb(obj.res))+'\n';
						} else if (xml.@tip=='3') {
							s+='- '+Res.pipText('begvulner')+': '+textAsColor('yellow', Res.numb(obj.res*100)+'%')+'\n';
						} else {
							s+='- '+Res.pipText('begval')+': '+textAsColor('yellow', Res.numb(obj.res*100)+'%')+'\n';
						}
					}
					else {
						if (obj.ref=='add' && obj.val==0 || obj.ref=='mult' && obj.val==1) continue;
						ok=true;
						if (obj.tip!=null) s1=Res.txt(obj.tip,obj.id);
						else if (Res.istxt('e',obj.id)) s1=Res.txt('e',obj.id);
						else if (Res.istxt('i',obj.id)) s1=Res.txt('i',obj.id);
						else if (Res.istxt('a',obj.id)) s1=Res.txt('a',obj.id);
						else s1='???';
						if (s1.substr(0,6)=='*eff_f') s1=Res.txt('e','food');
						s+='- '+s1+': ';
						if (obj.ref=='add') {
							if (xml.@tip=='0') {
								s+=(obj.val>0?'+':'-')+' '+numberAsColor('yellow', Math.abs(obj.val));
								s+=' = '+textAsColor('yellow', Res.numb(obj.res));
							}
							else {
								s+=(obj.val>0?'+':'-')+' '+textAsColor('yellow', Res.numb(Math.abs(obj.val*100))+'%');
								s+=' = '+textAsColor('yellow', Res.numb(obj.res*100)+'%');
							}
						}
						else if (obj.ref=='mult') {
							if (xml.@tip=='0') {
								s+='× '+textAsColor('yellow', obj.val)+' = '+textAsColor('yellow', Res.numb(obj.res));
							}
							else if (xml.@tip=='3' || xml.@tip=='4') {
								s+='× (1 '+(obj.val<1?'-':'+')+' '+numberAsColor('yellow', Math.abs(Math.round(100-obj.val*100))*0.01)+')';
								s+=' = '+textAsColor('yellow', Res.numb(obj.res*100)+'%');
							}
							else {
								s+='× '+textAsColor('yellow', obj.val);
								s+=' = '+textAsColor('yellow', Res.numb(obj.res*100)+'%');
							}
						}
						else if (obj.ref=='min') {
								s+='- '+textAsColor('yellow', Res.numb(Math.abs(obj.val*100))+'%');
								s+=' = '+textAsColor('yellow', Res.numb((obj.res)*100)+'%');
						}
						else {
							if (xml.@tip=='0') {
								s+=textAsColor('yellow', obj.val);
							}
							else {
								s+=textAsColor('yellow', Res.numb(obj.val*100)+'%');
							}
						}
						s+='\n';
					}
				}
				if (obj && (xml.@tip=='3' || xml.@tip=='4')) {
					s+='- '+Res.pipText('result')+': 100% - '+textAsColor('yellow', Res.numb(obj.res*100)+'%')+' = '+textAsColor('yellow', Res.numb((1-obj.res)*100)+'%');
				}
			}
			if (ok) s=Res.pipText('factor')+':\n'+s;
			else return '';
			return s;
		}
		
		protected function setTopText(s:String=''):void {
			if (s=='') {
				pip.vis.toptext.visible=false;
			}
			else {
				pip.vis.toptext.visible=true;
				var ins:String=Res.txt('p',s,0,true);
				var myPattern:RegExp = /@/g; 
				pip.vis.toptext.txt.htmlText=ins.replace(myPattern,'\n');
			}
		}
		
		// [Checking the quest for availability]
		protected function checkQuest(task:Object):Boolean {
			// [Land access check]
			if (task.land) {
				var land:LandAct = World.w.game.lands[task.land];
				
				if (land == null) {
					return false;
				}
				
				if (!land.access && !land.visited && World.w.pers.level < land.dif) {
					return false;
				}
			}
			
			// [Trigger check]
			if (task.trigger) {
				if (World.w.game.triggers[task.trigger] != 1) {
					return false;
				}
			}
			
			// [Skill check]
			if (task.skill && task.skilln) {
				if (World.w.pers.skills[task.skill] < task.skilln) {
					return false;
				}
			}
			return true;
		}
		
		protected function initCats():void {
			for (var i:int = 0; i <= kolCats; i++) {
				vis.cats['cat' + i].addEventListener(MouseEvent.CLICK,selCatEvent);
			}
			
			selCat();
		}
		
		// Initialize filter buttons
		protected function setCats():void {
			var arr = tips[page2];
			
			if (arr == null) {
				vis.cats.visible = false;
				return;
			}
			
			vis.cats.visible = true;
			
			var ntip;
			
			for (var i:int  = 1; i <= kolCats; i++) {
				ntip = arr[i];
				
				if (ntip == null || ntip == "") {
					vis.cats['cat' + i].visible = false;
				}
				else {
					if (ntip is Array) ntip = ntip[0];
					vis.cats['cat' + i].visible = true;
					try {
						vis.cats['cat' + i].ico.gotoAndStop(ntip);
					}
					catch (err) {
						trace("PipPage.as/setCats() - " + err + " | ntip: " + ntip);
						vis.cats['cat' + i].ico.gotoAndStop(1); // Default to frame 1
					}
				}
			}
			
			selCat(cat[page2]);
		}

		
		// selecting an inventory subcategory
		protected function selCatEvent(event:MouseEvent):void {
			// Get the 4th letter of the target's name 'cat1, cat2, etc.
			var n:int = event.currentTarget.name.charCodeAt(3) - 48; // 0 as a character is '48', so 1 would be '49' etc
			trace('Selecting filter category: "' + n + '".');
			cat[page2] = n;
			setStatus();
		}
		
		// What to do when a filter button is clicked
		protected function selCat(n:int = 0):void {
			for (var i = 0; i <= kolCats; i++) {
				vis.cats['cat' + i].fon.gotoAndStop(1);
			}
			
			vis.cats['cat' + n].fon.gotoAndStop(2);
			
			try {
				curTip = tips[page2][n];
			}
			catch (err) {
				trace('ERROR: (00:38) - No icon for: "' + n + '"!');
			}
			
			if (curTip == null) curTip = '';
		}
		
		//проверить соответствии категории
		protected function checkCat(tip:String):Boolean {
			if (curTip=='' || curTip==null || curTip==tip) return true;
			if (curTip is Array) {
				for each (var t in curTip) if (t==tip) return true;
			}
			return false;
		}
		
		public function statScroll(event:ScrollEvent):void { // Adobe Animate dependency
			setStatItems(event.position);
		}

		public function onMouseWheel1(event:MouseEvent):void {
			if (World.w.ctr.setkeyOn) return;
			try {
				if (vis.scText && vis.scText.visible && vis.mouseX>vis.info.x) return;
			}
			catch(err) {
				trace('ERROR: (00:39)');
			}
			scroll(event.delta);
			if (!vis.scBar.visible) return;
			if (event.delta < 0) (event.currentTarget as MovieClip).scBar.scrollPosition++;
			if (event.delta > 0) (event.currentTarget as MovieClip).scBar.scrollPosition--;
			event.stopPropagation();
		}

		public function scroll(dn:int=0):void {

		}

		public function step():void {

		}

		private function crash():void {
			var obj:Object = null;
			trace(obj.someProperty); // Crashes with a null reference error
		}
	}	
}