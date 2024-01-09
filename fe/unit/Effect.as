package fe.unit {
	
	import fe.*;
	import fe.graph.Emitter;
	import flash.geom.ColorTransform;
	
	public class Effect {
		
		public var owner:Unit;
		public var id:String;
		public var tip:int=0;
		public var forever:Boolean=false;
		public var t:int=1;
		public var lvl:int=1;
		public var lvl1:int=0, lvl2:int=0, lvl3:int=0;					//уровни эффекта
		public var val:Number;
		public var player:Boolean=false;		//эффект относится к гг
		public var params:Boolean=false;		//эффект изменяет параметры
		public var add:Boolean=false;			//время эффекта складывается
		public var se:Boolean=true;				//сообщение
		public var him:int=0;					//эффект вызван химией, 1-положительный, 2-отрицательный																						
		public var ad:Boolean=false;			//зависимость от химии
		public var post:String;
		var postBad:Boolean=false;
		var del:Array;
		
		
		public var vse:Boolean=false;		//действие окончено

		public function Effect(nid:String, own:Unit=null, nval:Number=0) {
			if (own==null) owner=World.w.gg;
			else owner=own;
			player=owner.player;
			id=nid;
			val=nval;
			getXmlParam();
		}
		
		function getXmlParam() {
			t=1;
			post=null;
			postBad=false;
			del=new Array();
			him=0;
			lvl=1;
			forever=false;
			var node=AllData.d.eff.(@id==id);
			if (node.length()) {
				tip=node.@tip;
				t=node.@t*30;
				if (World.w.testEff) t=node.@t*3;
				if (val==0) val=node.@val;
				if (node.sk.length()) params=true;
				if (node.@post.length()) post=node.@post;
				if (node.@postbad.length()) {
					post=node.@postbad;
					postBad=true;
				}
				if (node.@him.length()) him=node.@him;
				if (node.@lvl1.length()) lvl1=node.@lvl1;
				if (node.@lvl2.length()) lvl2=node.@lvl2;
				if (node.@lvl3.length()) lvl3=node.@lvl3;
				if (node.@add.length()) add=true;
				//if (player && him
				if (node.del.length()) {
					for each(var ndel in node.del) del.push(ndel.@id);
				}
			}
			if (t==0) {
				t=30;
				forever=true;
			}
		}
		
		public function setEff() {
			if (del.length) {
				for each(var ndel in del) {
					for each(var eff:Effect in owner.effects) {
						if (eff.id==ndel) {
							eff.unsetEff(false,false,false);
							break;
						}
					}
				}
			}
			if (params) {
				if (player) (owner as UnitPlayer).pers.setParameters();
				else owner.setEffParams();
			}
			if (id=='potion_fly' || id=='potion_shadow') {
				owner.newPart('black',15);
			}
			if (id=='potion_shadow') {
				if (player) {
					(owner as UnitPlayer).uncallPet(true);
					(owner as UnitPlayer).changeWeapon('not');
				}
			}
			if (id=='potion_rat') {
				if (player) (owner as UnitPlayer).ratOn();
			}
			if (id=='potion_infra') {
				World.w.grafon.warShadow();
			}
			if (id=='reanim' && player) {
				(owner as UnitPlayer).noReanim=true;
			}
			if (id=='stupor' && player) {
				(owner as UnitPlayer).stam=0;
			}
			if (id=='fetter' && player) {
				(owner as UnitPlayer).fetX=owner.X;
				(owner as UnitPlayer).fetY=owner.Y;
			}
			if (id=='stealth' || id=='stealth_armor') {
				(owner as UnitPlayer).f_stealth=true;
				(owner as UnitPlayer).setFilters();
			}
			if (id=='bloodinv' && player) {
				(owner as UnitPlayer).f_inv=true;
				(owner as UnitPlayer).setFilters();
				owner.newPart('blood',30);
			}
			if (id=='curse') World.w.game.triggers['curse']=1;
			visEff();
		}
		
		//проверить уровень эффекта
		public function checkT() {
			if (lvl1>0) {
				var plvl=lvl;
				lvl=1;
				if (t/30>lvl1) lvl=2;
				if (t/30>lvl2) lvl=3;
				if (t/30>lvl3) lvl=4;
				if (plvl!=lvl && params) {
					if (player) (owner as UnitPlayer).pers.setParameters();
					else owner.setEffParams();
				}
			}
		}
		
		public function visEff() {
			if (id=='potion_shadow' && player) {
				(owner as UnitPlayer).f_shad=true;
				(owner as UnitPlayer).setFilters();
			}
			if (id=='inhibitor') {
				if (owner.vis.inh) {
					owner.vis.inh.visible=true;
					owner.vis.inh.gotoAndPlay(1);
					//owner.vis.inh.scaleX=owner.vis.inh.scaleY=val/50;
				}
			}
			if (id=='freezing') {
				var freezTransform:ColorTransform=new ColorTransform(0.7,0.7,1,1,100,100,130);
				if (owner.cTransform) freezTransform.concat(owner.cTransform);
				owner.vis.transform.colorTransform=freezTransform;
			}
		}
		
		public function unsetEff(onPost:Boolean=true, inf:Boolean=true, setParam:Boolean=true) {
			if (id=='potion_rat') {
				if ((owner as UnitPlayer).ratOff()) {
					if ((owner as UnitPlayer).retPet!='') (owner as UnitPlayer).callPet((owner as UnitPlayer).retPet,true);
				} else {
					if (t<20) t=29;
					return;
				}
			}
			vse=true;
			if (player && inf && se) {
				if (tip==3) World.w.gui.infoText('endFoodEffect',Res.txt('e',id));
				else World.w.gui.infoText('endEffect',Res.txt('e',id));
			}
			if (post && onPost) {		//замена эффекта пост-эффектом
				//if (!player || !postBad || World.w.pers.himBad>0) {
					id=post;
					var isBad:Boolean=postBad;
					getXmlParam();
					if (isBad) {
						var proc=World.w.pers.addictions[id];
						if (proc>=World.w.pers.ad1) {
							forever=true;
							ad=true;
						}
						if (proc>=World.w.pers.ad2) lvl=2;
						if (proc>=World.w.pers.ad3) lvl=3;
					}
					vse=false;
					//if (player && isBad) t*=World.w.pers.himBad;
				//}
			}
			if (params && setParam) {
				if (player) (owner as UnitPlayer).pers.setParameters();
				else owner.setEffParams();
			}
			if (id=='stealth' || id=='stealth_armor') {
				(owner as UnitPlayer).f_stealth=false;
				(owner as UnitPlayer).setFilters();
			}
			if (id=='potion_fly') {
				owner.isFly=false;
				owner.newPart('black',15);
			}
			if (id=='potion_shadow' && player) {
				(owner as UnitPlayer).f_shad=false;
				(owner as UnitPlayer).f_stealth=false;
				(owner as UnitPlayer).setFilters();
				if ((owner as UnitPlayer).retPet!='') (owner as UnitPlayer).callPet((owner as UnitPlayer).retPet,true);
			}
			if (id=='potion_infra') {
				World.w.grafon.warShadow();
			}
			if (id=='reanim' && player) {
				(owner as UnitPlayer).noReanim=false;
			}
			if (id=='inhibitor') {
				if (owner.vis.inh) owner.vis.inh.visible=false;
			}
			if (id=='freezing') {
				if (owner.cTransform) owner.vis.transform.colorTransform=owner.cTransform;
				else owner.vis.transform.colorTransform=new ColorTransform();
			}
			if (id=='sacrifice' && player) {
				(owner as UnitPlayer).noReanim=false;
			}
			if (id=='bloodinv' && player) {
				(owner as UnitPlayer).f_inv=false;
				(owner as UnitPlayer).setFilters();
			}
		}
		
		public function secEffect() {
			checkT();
			if (id=='burning') {
				if (owner.isPlav) t=1;
				else {
					owner.damage(val,Unit.D_FIRE,null,true);
					owner.shok=33;
				}
			}
			if (id=='pinkcloud') {
				owner.damage(val,Unit.D_PINK,null,true);
			}
			if (id=='blindness' && player) {
				if (owner.sost<4) Emitter.emit('blind',owner.loc,owner.X-300+Math.random()*600,owner.Y-200+Math.random()*400);
			}
			if (id=='chemburn') {
				owner.damage(val,Unit.D_ACID,null,true);
			}
			if (id=='drunk' && lvl>3) {
				owner.damage(val,Unit.D_POISON,null,true);
				Emitter.emit('poison',owner.loc,owner.X+owner.storona*20,owner.Y-40);
			}
			if (id=='namok') {
				if (!owner.isPlav && owner.sost<4) Emitter.emit('kap',owner.loc,owner.X,owner.Y-owner.scY*0.25,{md:0.1});
			}
			if (id=='hydra' && owner.sost==1) {
				owner.heal(val);
				if (owner.player) {
					owner.heal(val/2, 3, false);
					(owner as UnitPlayer).pers.heal(val,4);
					(owner as UnitPlayer).pers.heal(val,5);
				}
			}
			if (id=='inhibitor') {
				for each (var un:Unit in owner.loc.units) {
					if (owner.isMeet(un) && un.fraction!=owner.fraction && un.rasst2<val*val) un.slow=40;
				}
			}
			if (id=='fetter') {
				Emitter.emit('slow',owner.loc,(owner as UnitPlayer).fetX,(owner as UnitPlayer).fetY);
			}
		}
		public function stepEffect() {
			if (id=='burning') {
				if (owner.sost<4) Emitter.emit('flame',owner.loc,owner.X,owner.Y-owner.scY/2);
			}
			if (id=='sacrifice' && t==5) {
				owner.damage(owner.maxhp*0.5,Unit.D_INSIDE);
				owner.newPart('blood',50);
			}
		}
		
		public function step() {
			if (t%30==0) {
				secEffect();
			}
			stepEffect();
			t--; 
			//t-=5;
			if (t<=0) {
				if (forever) t=30;
				else {
					unsetEff();
				}
			}
		}

	}
	
}
