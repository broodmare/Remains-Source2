package fe.inter {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import fl.controls.ScrollBar;
	import fl.events.ScrollEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	
	import fe.*;
	import fe.unit.Invent;
	import fe.unit.Pers;
	import fe.unit.Unit;
	import fe.unit.Armor;
	import fe.unit.UnitPlayer;
	import fe.loc.Quest;
	import fe.weapon.Weapon;
	import fe.serv.Item;
	import fe.serv.LootGen;
	import fe.loc.LandAct;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import fe.unit.UnitPet;
	
	public class PipPage {

		var vis:MovieClip;

		var arr:Array;
		var statArr:Array;
		var statHead:MovieClip;
		var pageClass:Class;
		var itemClass:Class;

		var maxrows:int=18;
		var selItem:MovieClip;
		
		var pip:PipBuck;
		var inv:Invent;
		var gg:UnitPlayer;
		
		var isLC:Boolean=false, isRC:Boolean=false; //реакция на клик
		
		var signs:Array=[0,0,0,0,0,0];
		
		var page2:int=1;
		var scrl:int=0;
		
		var infIco:MovieClip;
		var itemFilter:GlowFilter=new GlowFilter(0x00FF88,1,3,3,3,1);
		//var itemTrans:ColorTransform=new ColorTransform(0,1,0.5);
		var itemTrans:ColorTransform=new ColorTransform(1,1,1);
		
		var pp:String;
		
		var kolCats:int=6;
		var cat:Array=[0,0,0,0,0,0,0];
		var curTip='';
		var tips:Array=[[]];
		
		//setStatItems - обновить все элементы, не перезагружая страницу
		//setStatus - полностью обновить страницу

		public function PipPage(npip:PipBuck, npp:String) {
			
			pip=npip;
			
			pp=npp;
			if (pageClass==null) pageClass=visPipInv;
			vis=new pageClass();
			vis.x=165;
			vis.y=72;
			vis.visible=false;
			if (vis.pers) vis.pers.visible=false
			if (vis.skill) vis.skill.visible=false;
			if (vis.item) vis.item.visible=false
			pip.vis.addChild(vis);
			
			vis.scBar.addEventListener(ScrollEvent.SCROLL,statScroll);
			vis.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel1);
			statArr=new Array();
			var item:MovieClip;
			for (var i=-1; i<maxrows; i++) {
				item=new itemClass(); 
				item.x=30;
				item.y=100+i*30;
				if (item.nazv) setStyle(item.nazv);
				vis.addChild(item);
				if (item.ramka) item.ramka.visible=false;
				//item.hitArea=item.back;
				if (i<0) {
					item.back.visible=false;
					statHead=item;
				} else {
					if (isLC) item.addEventListener(MouseEvent.CLICK,itemClick);
					if (isRC) item.addEventListener(MouseEvent.RIGHT_CLICK,itemRightClick);
					item.addEventListener(MouseEvent.MOUSE_OVER,statInfo);
					statArr.push(item);
				}
			}
			for (i=1; i<=5; i++) {
				item=vis.getChildByName('but'+i) as MovieClip;
				item.addEventListener(MouseEvent.CLICK,page2Click);
				item.text.text=Res.pipText(pp+i);
				//if (ons[i]==0) item.visible=false;
				item.id.text=i;
				item.id.visible=false;
			}
			vis.butOk.visible=false;
			vis.butDef.visible=false;
			if (vis.cats) vis.cats.visible=false;
			
			setStyle(vis.info);
			setStyle(vis.bottext);
		}
		
		public static function setStyle(tt:TextField) {
			var style:StyleSheet = new StyleSheet(); 
			var styleObj:Object = new Object(); 
			styleObj.color = "#00FF99"; 
			style.setStyle(".r0", styleObj); 	//по умолчанию зелёный
			
			styleObj.color = "#FF3333"; 
			style.setStyle(".red", styleObj);	//красный
			styleObj.color = "#FFFF33"; 
			style.setStyle(".yel", styleObj);	//жёлтый
			styleObj.color = "#FF9900"; 
			style.setStyle(".or", styleObj);	//оранжевый
			styleObj.color = "#FC7FED"; 
			style.setStyle(".pink", styleObj);	//розовый
			styleObj.color = "#00FFFF"; 
			style.setStyle(".blu", styleObj);	//голубой
			styleObj.color = "#99CCFF"; 
			style.setStyle(".mass", styleObj);	//серо-голубой
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
		
		public function updateLang() {
			for (var i=1; i<=5; i++) {
				var item=vis.getChildByName('but'+i) as MovieClip;
				item.text.text=Res.pipText(pp+i);
			}
		}

		public function page2Click(event:MouseEvent) {
			if (World.w.ctr.setkeyOn) return;
			page2=int(event.currentTarget.id.text);
			setStatus();
			pip.snd(2);
		}
		
		function setButtons() {
			for (var i=1; i<=5; i++) {
				var item:MovieClip=vis.getChildByName('but'+i) as MovieClip;
				if (page2==i) item.gotoAndStop(2);
				else if (signs[i]>0) item.gotoAndStop(signs[i]+2);
				else item.gotoAndStop(1);
			}
		}
		
		public function setStatus(flop:Boolean=true) {
			pip.reqKey=false;
			statHead.id.text='';
			vis.visible=true;
			vis.info.text='';
			vis.nazv.text='';
			vis.bottext.text='';
			vis.emptytext.text='';
			arr=new Array();
			if (flop) scrl=0;
			if (vis.scText) vis.scText.visible=false;
			
			gg=pip.gg;
			inv=pip.inv;
			pip.vis.toptext.visible=false;
			pip.vis.butHelp.visible=pip.vis.butMass.visible=false;
			pip.vishelp.visible=false;
			setSubPages();
			setStatItems(flop?0:-1);

			var sc:ScrollBar=vis.scBar;
			if (arr.length>maxrows) {
				sc.visible=true;
				sc.minScrollPosition=0
				sc.maxScrollPosition=arr.length-maxrows;
				sc.scrollPosition=scrl;
			} else {
				sc.visible=false;
			}
			setSigns();
			setButtons();
		}
		
		//подготовка страниц
		function setSubPages() {
		}
		//определение подсвеченности кнопок
		function setSigns() {
			signs=[0,0,0,0,0,0];
		}
		
		//показ одного элемента
		function setStatItem(item:MovieClip, obj:Object) {
		}
		
		//информация об элементе
		function statInfo(event:MouseEvent) {
		}
		
		function itemClick(event:MouseEvent) {
		}
		function itemRightClick(event:MouseEvent) {
		}
		
		//показ всех элементов
		public function setStatItems(n:int=-1) {
			if (n>=0) scrl=n;
			for (var i=0; i<statArr.length; i++) {
				if (i+scrl>=arr.length) {
					statArr[i].visible=false;
				} else {
					statArr[i].visible=true;
					setStatItem(statArr[i],arr[i+scrl]);
				}
			}
		}
		
		public function setIco(tip:int=0, id:String='') {
			if (infIco && vis.ico.contains(infIco)) vis.ico.removeChild(infIco);
			vis.pers.visible=vis.skill.visible=false;
			vis.item.gotoAndStop(1);
			//vis.ico.y=vis.nazv.y+vis.nazv.textHeight+20;
			vis.info.y=vis.ico.y;
			if (tip==1) {//оружие
				var w:Weapon=pip.arrWeapon[id];
				if (w.tip==5) {
					tip=3;
					if (id.charAt(id.length-2)=='^') id=id.substr(0,id.length-2);
				} else {
					var vWeapon:Class=w.vWeapon;
					var node=AllData.d.weapon.(@id==id);
					if (node.length()) {
						node=node[0];
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
						if (node.length() && node.vis.length()) {
							if (node.vis.@icomult.length()) {
								r=infIco.scaleX=infIco.scaleY=node.vis.@icomult;
							}
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
				//var child:DisplayObject;
				pip.setArmor(id);
				vis.pers.gotoAndStop(2);
				vis.pers.gotoAndStop(1);
				vis.pers.head.morda.magic.visible=false;
				vis.pers.visible=true;
				vis.info.y=vis.pers.y+25;
			}
			if (tip==3) {
				vis.item.visible=true;
				try {
					vis.item.gotoAndStop(id);
					vis.info.y=vis.item.y+vis.item.height+25;
				} catch(err) {
					vis.item.gotoAndStop(1);
					vis.item.visible=false;
					vis.info.y=vis.ico.y;
				}
			}
			if (tip==5) {//перки
				vis.skill.visible=true;
				try {
					vis.skill.gotoAndStop(id);
					vis.info.y=vis.ico.y+220;
				} catch(err) {
					vis.skill.visible=false;
					vis.info.y=vis.ico.y;
				}
			}
		}
		
		public static function yel(s):String {
			return "<span class = 'yel'>"+s+"</span>";
		}
		public static function red(s):String {
			return "<span class = 'red'>"+s+"</span>";
		}
		public static function pink(s):String {
			return "<span class = 'pink'>"+s+"</span>";
		}
		public static function mass(s):String {
			return "<span class = 'mass'>"+s+"</span>";
		}
		public static function blue(s):String {
			return "<span class = 'blu'>"+s+"</span>";
		}
		
		//добавить в текстовую строку значения
		public static function addVar(s:String, xml):String {
			for (var i=1; i<=5; i++) {
				if (xml.attribute('s'+i).length())  s=s.replace('#'+i,"<span class='yel'>"+xml.attribute('s'+i)+"</span>");
			}
			return s;
		}
		
		//dlvl=1 если перк не текущий, а выбираемый
		public static function effStr(tip:String, id:String, dlvl:int=0):String {
			var s:String;
			if (tip=='item') s=Res.txt('i',id,1)
			else s=Res.txt('e',id,1);
			if (id.substr(-3)=='_ad') id=id.substr(0,id.length-3);
			var dp=AllData.d[tip];
			if (dp.length()==0) return s;
			dp=dp.(@id==id);
			if (dp.length()==0) return s;
			dp=dp[0];
			//определение текущего уровня
			var lvl=1;
			var pers=World.w.pers;
			if (tip=='perk') {
				lvl=pers.perks[id];
				if (lvl==null) lvl=0;
			} else if (tip=='skill') {
				lvl=pers.getSkLevel(pers.skills[id]);
			} else if (dp.@him=='2') {
				var ad=pers.addictions[id];
				if (ad>=pers.ad2) lvl=2;
				if (ad>=pers.ad3) lvl=3;
			} else if (dp.@him=='1') lvl=pers.himLevel;
			lvl+=dlvl;
							//trace(id, lvl);
			//вставка в текст числовых значений
			if (lvl>1 && dp.textvar[lvl-1]) s=addVar(s,dp.textvar[lvl-1]);
			else if (dp.textvar.length()) s=addVar(s,dp.textvar[0]);
			//добавление особых эффектов
			if (dp.eff.length() && lvl>0) {
				s+='<br>';
				for each(var eff in dp.eff) {
					s+='<br>'+(eff.@id.length()?Res.pipText(eff.@id):Res.pipText('refeff'))+': '+yel(eff.attribute('n'+lvl));
				}
			}
			//добавление эффектов веса
			if (World.w.hardInv && dp.sk.length()) {
				s+='<br>';
				for each(var sk in dp.sk) {
					if (sk.@tip=='m') {
						var add=mass('+1');
						if (sk.@vd>0) add=mass('+'+sk.@vd)+' '+Res.pipText('perlevel');
						if (sk.@v1>0) add=mass('+'+sk.@v1);
						s+='<br>'+Res.pipText('add_'+sk.@id)+' '+add;
					}
				}
			}
			//добавление требований
			if (dp.req.length()) {
				s+='<br><br>'+Res.pipText('requir');
				lvl--;
				for each(var req in dp.req) {
					var reqlevel:int=1;
					if (req.@lvl.length()) reqlevel=req.@lvl;
					if (lvl>0 && req.@dlvl.length()) reqlevel+=lvl*req.@dlvl;
					var s1:String='<br>';
					var ok:Boolean=true;
					if (req.@id=='level') {
						s1+=Res.pipText('level');
						if (pers.level<reqlevel) ok=false;
					} else if (req.@id=='guns') {
						s1+=Res.txt('e','smallguns')+' '+Res.pipText('or')+' '+Res.txt('e','energy');
						if (pers.getSkLevel(pers.skills['smallguns'])<reqlevel && pers.getSkLevel(pers.skills['energy'])<reqlevel) ok=false;
					} else {
						s1+=Res.txt('e',req.@id);
						if (pers.getSkLevel(pers.skills[req.@id])<reqlevel) ok=false;
					}
					s1+=': '+reqlevel;
					if (ok)	s+=yel(s1);
					else s+=red(s1);
				}
			}
			return s;
		}
		
		
		public static function infoStr(tip:String, id:String):String {
			var s:String='';
			var pip=World.w.pip;
			var gg=World.w.gg;
			var inv:Invent=World.w.invent;
			if (tip==Item.L_ARMOR && inv.armors[id]==null && pip.arrArmor[id]==null) tip=Item.L_ITEM;
			if (tip==Item.L_WEAPON && inv.weapons[id] && inv.weapons[id].spell) tip=Item.L_ITEM;
			if (tip==Item.L_WEAPON || tip==Item.L_EXPL) {
				var w:Weapon=pip.arrWeapon[id];
				if (w==null) return '';
				w.setPers(gg,gg.pers);
				var skillConf=1;
				var razn=w.lvl-gg.pers.getWeapLevel(w.skill);
				if (razn==1) skillConf=0.75;
				if (razn>=2) skillConf=0.5;
				w.skillConf=skillConf;
				s+=Res.pipText('weapontip')+': '+yel(Res.pipText('weapontip'+w.skill));
				if (w.lvl>0) {
					s+='\n'+Res.pipText('lvl')+': '+yel(w.lvl);
					s+='\n'+Res.pipText('islvl')+': '+yel(gg.pers.getWeapLevel(w.skill));
					if (razn>0) s+="<span class = 'red'>";
					if (w.lvlNoUse && razn>0 || razn>2) s+=' ('+Res.pipText('weapnouse')+')</span>';
					else if (razn>0){
						if (razn==2) {
							s+=' (-40% ';
						} else if (razn==1) {
							s+=' (-20% ';
						}
						if (w.tip==1) s+=Res.pipText('rapid')
						else if (w.tip==4) s+=Res.pipText('distance');
						else s+=Res.pipText('precision');
						s+=")</span>";
					}
				}
				if (w.perslvl>0) {
					s+='\n'+Res.pipText('perslvl')+': '+yel(w.perslvl);
					s+='\n'+Res.pipText('isperslvl')+': '+yel(gg.pers.level);
					if (gg.pers.level<w.perslvl) s+=red(' ('+Res.pipText('weapnouse')+')');
				}
				s+='\n'+Res.pipText('damage')+': ';
				var wdam=w.damage, wdamexpl=w.damageExpl;
				if (w.damage>0) {
					s+=yel(Math.round(w.damage*10)/10);
					wdam=w.resultDamage(w.damage,gg.pers.weaponSkills[w.skill]);
					if (wdam!=w.damage) {
						s+=' ('+yel(Math.round(wdam*10)/10)+')';
					}
				}
				if (w.damage>0 && w.damageExpl>0) s+=' + ';
				if (w.damageExpl>0) {
					s+=yel(Math.round(w.damageExpl*w.damMult*10)/10);
					wdamexpl=w.resultDamage(w.damageExpl,gg.pers.weaponSkills[w.skill]);
					if (wdamexpl!=w.damageExpl) {
						s+=' ('+yel(Math.round(wdamexpl*10)/10)+')';
					}
					s+=' '+Res.pipText('expldam');
				}
				if (w.kol>1) s+=' [x'+w.kol+']';
				if (w.explKol>1) s+=' [x'+w.explKol+']';
				var wrapid=w.resultRapid(w.rapid);
				if (w.tip!=4) {
					s+='\n'+Res.pipText('aps')+': '+yel(Number(World.fps/wrapid).toFixed(1));
					s+='\n'+Res.pipText('dps')+': '+yel(Number((wdam+wdamexpl)*w.kol*World.fps/wrapid).toFixed(1));
					if (w.holder) s+=' ('+yel(Number((wdam+wdamexpl)*w.kol*World.fps/(wrapid+w.reload*w.reloadMult/w.holder*w.rashod)).toFixed(1))+')';
				}
				s+='\n'+Res.pipText('critch')+': '+yel(Math.round((w.critCh+w.critchAdd+gg.critCh)*100)+'%');
				//s+='\n'+Res.pipText('critmult')+': '+yel(Math.round((w.critDamPlus+gg.critDamMult)*100)+'%');
				s+='\n'+Res.pipText('tipdam')+': '+blue(Res.pipText('tipdam'+w.tipDamage));
				if (w.tip<4 && w.holder>0) s+='\n'+Res.pipText('inv5')+': '+yel(Res.txt('i',w.ammo));
				if (w.tip<4 && w.holder>0) s+='\n'+Res.pipText('holder')+': '+yel(w.holder);
				if (w.rashod>1) s+=' ('+yel(w.rashod)+' '+Res.pipText('rashod')+')';
				if (w.tip==5) s+='\n'+Res.pipText('dmana')+': '+yel(Math.round(w.mana));
				if (w.precision>0) s+='\n'+Res.pipText('prec')+': '+yel(Math.round(w.precision*w.precMult/40));
				if (w.pier+w.pierAdd>0) s+='\n'+Res.pipText('pier')+': '+yel(Math.round(w.pier+w.pierAdd));
				if (!w.noSats) {
					s+='\n'+Res.pipText('ap')+': ';
					if (razn>0) s+="<span class = 'red'>";
					else s+="<span class = 'yel'>";
					s+=Math.round(w.satsCons*w.consMult/skillConf*gg.pers.satsMult);
					s+="</span>";
					if (w.satsQue>1) s+=' (x'+yel(w.satsQue)+')';
				}
				if (w.destroy>=100) {
					s+='\n'+Res.pipText('destroy');
				}
				if (w.opt && w.opt.perk) {
					s+='\n'+Res.pipText('refperk')+': '+pink(Res.txt('e',w.opt.perk));
				}
				var sinf=Res.txt('w',id,1);
				if (sinf=='') sinf=Res.txt('w',w.id,1);
				if (World.w.hardInv && w.tip<4) s+='\n'+Res.pipText('mass2')+": <span class = 'mass'>"+w.mass+"</span>";
				if (World.w.hardInv && w.tip==4) s+='\n\n'+Res.pipText('mass')+": <span class = 'mass'>"+inv.items[id].xml.@m+"</span> ("+Res.pipText('vault'+inv.items[id].invCat)+')';
				s+='\n\n'+sinf;
			} else if (tip==Item.L_ARMOR) {
				var a:Armor=inv.armors[id];
				if (a==null) a=pip.arrArmor[id];
				if (a.armor_qual>0) s+=Res.pipText('aqual')+': '+yel(Math.round(a.armor_qual*100)+'%');
				if (a.armor>0) s+='\n'+Res.pipText('armor')+': '+yel(Math.round(a.armor));
				if (a.marmor>0) s+='\n'+Res.pipText('marmor')+': '+yel(Math.round(a.marmor));
				if (a.dexter!=0) s+='\n'+Res.pipText('dexter')+': '+yel(Math.round(a.dexter*100)+'%');
				if (a.sneak!=0) s+='\n'+Res.pipText('sneak')+': '+yel(Math.round(a.sneak*100)+'%');
				if (a.meleeMult!=1) s+='\n'+Res.pipText('meleedamage')+': +'+yel(Math.round((a.meleeMult-1)*100)+'%');
				if (a.gunsMult!=1) s+='\n'+Res.pipText('gunsdamage')+': +'+yel(Math.round((a.gunsMult-1)*100)+'%');
				if (a.magicMult!=1) s+='\n'+Res.pipText('spelldamage')+': +'+yel(Math.round((a.magicMult-1)*100)+'%');
				if (a.crit!=0) s+='\n'+Res.pipText('critch')+': +'+yel(Math.round(a.crit*100)+'%');
				if (a.radVul<1) s+='\n'+Res.pipText('radx')+': '+yel(Math.round((1-a.radVul)*100)+'%');
				if (a.resist[Unit.D_BUL]!=0) s+='\n'+Res.pipText('bullet')+': '+yel(Math.round(a.resist[Unit.D_BUL]*100)+'%');
				if (a.resist[Unit.D_EXPL]!=0) s+='\n'+Res.pipText('expl')+': '+yel(Math.round(a.resist[Unit.D_EXPL]*100)+'%');
				if (a.resist[Unit.D_PHIS]!=0) s+='\n'+Res.pipText('phis')+': '+yel(Math.round(a.resist[Unit.D_PHIS]*100)+'%');
				if (a.resist[Unit.D_BLADE]!=0) s+='\n'+Res.pipText('blade')+': '+yel(Math.round(a.resist[Unit.D_BLADE]*100)+'%');
				if (a.resist[Unit.D_FANG]!=0) s+='\n'+Res.pipText('fang')+': '+yel(Math.round(a.resist[Unit.D_FANG]*100)+'%');
				if (a.resist[Unit.D_FIRE]!=0) s+='\n'+Res.pipText('fire')+': '+yel(Math.round(a.resist[Unit.D_FIRE]*100)+'%');
				if (a.resist[Unit.D_LASER]!=0) s+='\n'+Res.pipText('laser')+': '+yel(Math.round(a.resist[Unit.D_LASER]*100)+'%');
				if (a.resist[Unit.D_PLASMA]!=0) s+='\n'+Res.pipText('plasma')+': '+yel(Math.round(a.resist[Unit.D_PLASMA]*100)+'%');
				if (a.resist[Unit.D_SPARK]!=0) s+='\n'+Res.pipText('spark')+': '+yel(Math.round(a.resist[Unit.D_SPARK]*100)+'%');
				if (a.resist[Unit.D_CRIO]!=0) s+='\n'+Res.pipText('crio')+': '+yel(Math.round(a.resist[Unit.D_CRIO]*100)+'%');
				if (a.resist[Unit.D_VENOM]!=0) s+='\n'+Res.pipText('venom')+': '+yel(Math.round(a.resist[Unit.D_VENOM]*100)+'%');
				if (a.resist[Unit.D_ACID]!=0) s+='\n'+Res.pipText('acid')+': '+yel(Math.round(a.resist[Unit.D_ACID]*100)+'%');
				if (a.resist[Unit.D_NECRO]!=0) s+='\n'+Res.pipText('necro')+': '+yel(Math.round(a.resist[Unit.D_NECRO]*100)+'%');
				s+='\n\n'+Res.txt('a',id,1);
			} else if (tip==Item.L_AMMO) {
				var ammo=inv.items[id].xml;
				if (AllData.d.weapon.(@id==id).length()) {
					s=Res.txt('w',id,1);
				} else if (ammo.@base.length()) {
					s=Res.txt('i',ammo.@base,1);
					if (ammo.@mod>0) {
						s+='\n\n'+Res.txt('p','ammomod_'+ammo.@mod,1);
					}
				} else {
					s=Res.txt('i',id,1);
				}
				s+='\n';
				if (ammo.@damage.length()) s+='\n'+Res.pipText('damage')+': x'+yel(ammo.@damage);
				if (ammo.@pier.length()) s+='\n'+Res.pipText('pier')+': '+yel(ammo.@pier);
				if (ammo.@armor.length()) s+='\n'+Res.pipText('tarmor')+': x'+yel(ammo.@armor);
				if (ammo.@prec.length()) s+='\n'+Res.pipText('prec')+': x'+yel(ammo.@prec);
				if (ammo.@det>0) s+='\n'+Res.pipText('det');
				if (World.w.hardInv && ammo.@m>0) s+='\n\n'+Res.pipText('mass')+": <span class = 'mass'>"+ammo.@m+"</span> ("+Res.pipText('vault'+inv.items[id].invCat)+')';
				if (ammo.@sell>0) s+='\n'+Res.pipText('sell')+": "+yel(ammo.@sell);
			} else {
				var hhp:Number=0;
				s=Res.txt('i',id,1)+'\n';
				var pot=inv.items[id].xml;
				tip=pot.@tip;
				if (tip=='instr' || tip=='impl'|| tip=='art') {
					s=effStr('item',id)+'\n';
				}
				if (tip=='med' || tip=='food'|| tip=='pot' || tip=='him') {
					if (pot.@hhp.length() || pot.@hhplong.length())
					s+='\n'+Res.pipText('healhp')+': '+yel(Math.round(pot.@hhp*World.w.pers.healMult));
					if (pot.@hhplong.length()) s+='+'+yel(Math.round(pot.@hhplong*World.w.pers.healMult));
					if (pot.@hrad.length()) s+='\n'+Res.pipText('healrad')+': '+yel(Math.round(pot.@hrad*World.w.pers.healMult));
					if (pot.@hcut.length()) s+='\n'+Res.pipText('healcut')+': '+yel(Math.round(pot.@hcut));
					if (pot.@hpoison.length()) s+='\n'+Res.pipText('healpoison')+': '+yel(Math.round(pot.@hpoison));
					if (pot.@horgan.length()) s+='\n'+Res.pipText('healorgan')+': '+yel(Math.round(pot.@horgan));
					if (pot.@horgans.length()) s+='\n'+Res.pipText('healorgans')+': '+yel(Math.round(pot.@horgans));
					if (pot.@hblood.length()) s+='\n'+Res.pipText('healblood')+': '+yel(Math.round(pot.@hblood));
					if (pot.@hmana.length()) s+='\n'+Res.pipText('healmana')+': '+yel(Math.round(pot.@hmana*World.w.pers.healManaMult));
					if (pot.@alc.length()) s+='\n'+Res.pipText('alcohol')+': '+yel(Math.round(pot.@alc));
					if (pot.@rad.length()) s+='\n'+Res.pipText('rad')+': '+yel(Math.round(pot.@rad));
					if (pot.@effect.length()) {
						s+='\n'+Res.pipText('refeff')+': '+effStr('eff',pot.@effect);
						//if (tip=='him' && gg.pers.himLevel>1) s+=effStr('eff',pot.@effect,gg.pers.himLevel-1);
						//else s+=;
					}
					if (pot.@perk.length()) s+='\n'+pink(Res.txt('e',pot.@perk))+': '+Res.pipText('level')+' '+(World.w.pers.perks[pot.@perk]>0?World.w.pers.perks[pot.@perk]:'0');
					if (pot.@maxperk.length()) s+='/'+pot.@maxperk;
				}
				if (tip=='book') {
					if (World.w.pers.skills[id]!=null) s+='\n'+Res.pipText('skillup')+': '+pink(Res.txt('e',id));
				}
				if (tip=='spell') {
					s+='\n'+Res.pipText('dmana2')+': '+yel(pot.@mana)+' ('+yel(Math.round(pot.@mana*World.w.pers.allDManaMult))+')';
					s+='\n'+Res.pipText('culd')+': '+yel(pot.@culd+Res.guiText('sec'))+' ('+yel(Math.round(pot.@culd*World.w.pers.spellDown)+Res.guiText('sec'))+')';
					s+='\n'+Res.pipText('is1')+': '+pink((pot.@tele>0)?Res.txt('e','tele'):Res.txt('e','magic'));
				}
				if (id=='rep') {
					if (pot.@hp.length()) hhp=pot.@hp*gg.pers.repairMult;
					if (hhp>0) s+='\n'+Res.pipText('effect')+': '+yel(Math.round(hhp));
				}
				if (pot.@pet_info.length()) {
					var pet:UnitPet=gg.pets[pot.@pet_info];
					if (pet) {
						s+='\n'+Res.pipText('hp')+': '+yel(Math.round(pet.hp))+'/'+yel(Math.round(pet.maxhp));
						s+='\n'+Res.pipText('skin')+': '+yel(Math.round(pet.skin));
						if (pet.allVulnerMult<1) s+='\n'+Res.pipText('allresist')+': '+yel(Math.round((1-pet.allVulnerMult)*100)+'%');
						s+='\n'+Res.pipText('damage')+': '+yel(Math.round(pet.dam));
					}
				}
				if (tip=='paint') s=Res.txt('p','paint',1);
				if (World.w.hardInv && pot.@m>0) s+='\n\n'+Res.pipText('mass')+": <span class = 'mass'>"+pot.@m+"</span> ("+Res.pipText('vault'+inv.items[id].invCat)+')';
				if (pot.@sell>0) s+='\n'+Res.pipText('sell')+": "+yel(pot.@sell);
			}
			return s;
		}
		
		function infoItem(tip:String, id:String, nazv:String, craft:int=0) {
			vis.nazv.text=nazv;
			var s:String='';
			if (id.substr(0,2)=='s_') {
				id=id.substr(2);
				craft=1;
				if (AllData.d.weapon.(@id==id).length()) tip=Item.L_WEAPON;
				else if (AllData.d.armor.(@id==id).length()) tip=Item.L_ARMOR;
				else tip=Item.L_ITEM;
			}
			//trace(tip);
			if (tip==Item.L_WEAPON || tip==Item.L_EXPL) {
				if (craft>0) setIco();
				else setIco(1,id);
				s=infoStr(tip, id);
				if (craft==1) s+=craftInfo(id);
				if (craft==2) s+=craftInfo(id.substr(0,id.length-2));
			} else if (tip==Item.L_ARMOR) {
				var a:Armor=inv.armors[id];
				if (a==null) a=pip.arrArmor[id];
				if (craft>0) setIco();
				else if (a.tip==3) setIco(3,id);
				else setIco(2,id);
				s=infoStr(tip, id);
				if (craft==2) {
					var cid:String=a.idComp;
					var kolcomp:int=a.needComp();
					s+="\n\n<span class = 'or'>"+Res.txt('i',cid)+ " - "+kolcomp+" <span ";
					if (!World.w.loc.base && kolcomp>inv.items[cid].kol || World.w.loc.base && kolcomp>inv.items[cid].kol+inv.items[cid].vault) s+="class='red'"
					s+="> ("+inv.items[cid].kol;
					if (World.w.loc.base && inv.items[cid].vault>0) s+=' +'+inv.items[cid].vault;
					s+=")</span></span>";
				}
				if (craft==1) s+=craftInfo(id);
			} else if (tip==Item.L_AMMO) {
				var ammo=inv.items[id].xml;
				if (ammo.@base.length()) {
					vis.nazv.text=Res.txt('i',ammo.@base);
					if (ammo.@mod>0) {
						vis.nazv.text+='\n'+Res.pipText('ammomod_'+ammo.@mod);
					} else {
						vis.nazv.text+='\n'+Res.pipText('ammomod_0');
					}
				}
				setIco();
				s=infoStr(tip, id);
			} else {
				if (craft>0) setIco();
				else setIco(3,id);
				s=infoStr(tip, id);
				if (craft==1) s+=craftInfo(id);
			}
			vis.info.htmlText=s;
			vis.info.height=680-vis.info.y; //475;
			vis.info.scaleX=vis.info.scaleY=1;
			if (vis.scText) vis.scText.visible=false;
			if (vis.info.height<vis.info.textHeight && vis.scText) {
				vis.scText.maxScrollPosition=vis.info.maxScrollV;
				vis.scText.visible=true;
				//vis.info.scaleX=vis.info.scaleY=0.8;
				//vis.info.height=vis.info.textHeight+5;
			}
		}
		
		public function craftInfo(id:String):String {
			var s:String='\n';
			var sch=AllData.d.item.(@id=='s_'+id);
			if (sch.length()) sch=sch[0];
			else return '';
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
			for each(var c in sch.craft) {
				s+="\n<span class = 'or'>"+Res.txt('i',c.@id)+ " - "+c.@kol+" <span ";
				if (!World.w.loc.base && c.@kol>inv.items[c.@id].kol
				  || World.w.loc.base && c.@kol>inv.items[c.@id].kol+inv.items[c.@id].vault) s+="class='red'";
				s+=">("+inv.items[c.@id].kol;
				if (World.w.loc.base && inv.items[c.@id].vault>0) s+=' +'+inv.items[c.@id].vault;
				s+=")</span></span>";
			}
			return s;
		}
		
		function infoQuest(id:String):String {
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
					s+=yel(n+'.')+" "
					if (st.hidden && st.state<2 && st.est<=0) s+='?????';
					else s+=st.nazv;
					if (st.collect && st.colTip==0) {
						if (st.give) {
							s+=' ('+yel(st.gived+'/'+st.kol)+')';
							if (st.est>0 && st.state<2) s+=' ('+yel('+'+st.est)+')';
						} else s+=' ('+yel(st.est+'/'+st.kol)+')';
					}
					if (st.nn) s+=' ('+Res.pipText('nn')+')';
					if (st.state==2) s+="</span>";
					n++;
				}
				return s;
		}
		
		public function factor(id:String):String {
			var s:String='', s1:String;
			var ok=false;
			if (World.w.pers.factor[id] is Array) {
				var xml=AllData.d.param.(@v==id);
				if (xml.@tip=='4') s+='- '+Res.pipText('begvulner')+': '+yel('100%')+'\n';
				for each (var obj in World.w.pers.factor[id]) {
					if (obj.id=='beg') {
						if (xml.@nobeg>0) continue;
						if (xml.@tip=='0') {
							if (obj.res!=0) s+='- '+Res.pipText('begval')+': '+yel(Res.numb(obj.res))+'\n';
						} else if (xml.@tip=='3') {
							s+='- '+Res.pipText('begvulner')+': '+yel(Res.numb(obj.res*100)+'%')+'\n';
						} else {
							s+='- '+Res.pipText('begval')+': '+yel(Res.numb(obj.res*100)+'%')+'\n';
						}
					} else {
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
								s+=(obj.val>0?'+':'-')+' '+yel(Math.abs(obj.val));
								s+=' = '+yel(Res.numb(obj.res));
							} else {
								s+=(obj.val>0?'+':'-')+' '+yel(Res.numb(Math.abs(obj.val*100))+'%');
								s+=' = '+yel(Res.numb(obj.res*100)+'%');
							}
						} else if (obj.ref=='mult') {
							if (xml.@tip=='0') {
								s+='× '+yel(obj.val)+' = '+yel(Res.numb(obj.res));
							} else if (xml.@tip=='3' || xml.@tip=='4') {
								s+='× (1 '+(obj.val<1?'-':'+')+' '+yel(Math.abs(Math.round(100-obj.val*100))*0.01)+')';
								s+=' = '+yel(Res.numb(obj.res*100)+'%');
							} else {
								s+='× '+yel(obj.val);
								s+=' = '+yel(Res.numb(obj.res*100)+'%');
							}
						} else if (obj.ref=='min') {
								s+='- '+yel(Res.numb(Math.abs(obj.val*100))+'%');
								s+=' = '+yel(Res.numb((obj.res)*100)+'%');
						} else {
							if (xml.@tip=='0') {
								s+=yel(obj.val);
							} else {
								s+=yel(Res.numb(obj.val*100)+'%');
							}
						}
						s+='\n';
					}
				}
				if (obj && (xml.@tip=='3' || xml.@tip=='4')) {
					s+='- '+Res.pipText('result')+': 100% - '+yel(Res.numb(obj.res*100)+'%')+' = '+yel(Res.numb((1-obj.res)*100)+'%');
				}
			}
			if (ok) s=Res.pipText('factor')+':\n'+s;
			else return '';
			return s;
		}
		
		public function setTopText(s:String='') {
			if (s=='') {
				pip.vis.toptext.visible=false;
			} else {
				pip.vis.toptext.visible=true;
				var ins:String=Res.txt('p',s,0,true);
				var myPattern:RegExp = /@/g; 
				pip.vis.toptext.txt.htmlText=ins.replace(myPattern,'\n');
			}
		}
		
		//проверка квеста на доступность
		public function checkQuest(task):Boolean {
			//проверка на доступ к местности
			if (task.@land.length()) {
				var land:LandAct=World.w.game.lands[task.@land];
				if (land==null) return false;
				if (!land.access && !land.visited && World.w.pers.level<land.dif) return false;
			}
			//проверка триггера
			if (task.@trigger.length()) {
				if (World.w.game.triggers[task.@trigger]!=1) return false;
			}
			//проверка скилла
			if (task.@skill.length() && task.@skilln.length()) {
				if (World.w.pers.skills[task.@skill]<task.@skilln) return false;
			}
			return true;
		}
		
		function initCats() {
			for (var i=0; i<=kolCats; i++) {
				vis.cats['cat'+i].addEventListener(MouseEvent.CLICK,selCatEvent);
			}
			selCat();
		}
		
		//установить кнопки категорий
		function setCats() {
			var arr=tips[page2];
			if (arr==null) {
				vis.cats.visible=false;
				return;
			}
			vis.cats.visible=true;
			var ntip;
			for (var i=0; i<=kolCats; i++) {
				ntip=arr[i];
				if (ntip==null) vis.cats['cat'+i].visible=false;
				else {
					if (ntip is Array) ntip=ntip[0];
					vis.cats['cat'+i].visible=true;
					try {
						vis.cats['cat'+i].ico.gotoAndStop(ntip);
					} catch (err) {
						vis.cats['cat'+i].ico.gotoAndStop(1);
					}
				}
			}
			selCat(cat[page2]);
		}

		
		//выбор подкатегории инвентаря
		function selCatEvent(event:MouseEvent) {
			var n:int=int(event.currentTarget.name.substr(3));
			cat[page2]=n;
			setStatus();
		}
		
		function selCat(n:int=0) {
			for (var i=0; i<=kolCats; i++) {
				vis.cats['cat'+i].fon.gotoAndStop(1);
			}
			vis.cats['cat'+n].fon.gotoAndStop(2);
			try {
				curTip=tips[page2][n];
			} catch (err) {
				curTip='';
			}
			if (curTip==null) curTip='';
			//trace(curTip);
		}
		
		//проверить соответствии категории
		function checkCat(tip:String):Boolean {
			if (curTip=='' || curTip==null || curTip==tip) return true;
			if (curTip is Array) {
				for each (var t in curTip) if (t==tip) return true;
			}
			return false;
		}
		
		public function statScroll(event:ScrollEvent) {
			setStatItems(event.position);
		}
		public function onMouseWheel1(event:MouseEvent):void {
			if (World.w.ctr.setkeyOn) return;
			try {
				if (vis.scText && vis.scText.visible && vis.mouseX>vis.info.x) return;
			} catch(err){}
			scroll(event.delta);
			if (!vis.scBar.visible) return;
			if (event.delta<0) (event.currentTarget as MovieClip).scBar.scrollPosition++;
			if (event.delta>0) (event.currentTarget as MovieClip).scBar.scrollPosition--;
			event.stopPropagation();
		}
		public function scroll(dn:int=0) {
		}
		public function step() {
		}
	}
	
}
