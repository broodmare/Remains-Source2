package fe.weapon  {
	import flash.display.MovieClip;
	
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.unit.Pers;
	import fe.loc.Tile;
	import fe.*;
	
	public class WClub extends Weapon {
		
		var anim:Number=0;
		var rapid_act:Number=10;	//актуальная скорость атаки
		var sin0:Number,cos0:Number,sin1:Number,cos1:Number,sin2:Number,cos2:Number;
		var vzz:Array;
		var kolvzz:int=0;
		var visvzz:MovieClip;	//шлейф за оружием
		var stepdlina:int=10;
		var del:Object={x:0, y:0};
		var lasM:Boolean=false;
		var mtip:int=0;		//тип холодного оружия
		
		var powerMult:Number=1;
		var curDam:Number=0;
		var combo:int=0;
		var t_combo:int=0;
		var sndPl:Boolean=false;
		
		var blumR:Number=0;
		var plX:Number=0, plY:Number=0;
		var atDlina:Number=100;
		var celRX:Number=0, celRY:Number=0;

		var celX:Number, celY:Number;
		var meleeR:Number=1;	//радиус действия телекинеза
		var levitRun:Number=10;	//скорость перемещения телекинезом
		
		var rapidMult:Number=1;
		public var quakeX:Number=0;
		public var quakeY:Number=0;
		
		public var powerfull:Boolean=false;	//можно усиливать удар
		public var combinat:Boolean=false;	//каждый 4й удар усиленный

		public function WClub(own:Unit, id:String, nvar:int=0){
			var node=AllData.d.weapon.(@id==id)[0];
			if (node.vis[0].@lasm>0) lasM=true;
			if (!lasM) {
				visvzz=new visVzz();
			} else {
				visvzz=new MovieClip() 
			}
			visvzz.visible=false;
			visvzz.stop();
			super(own,id,nvar);
			vis.stop();
			speed=15;
			//noPerc=true;
			satsMelee=noTrass=true;
			if (node.@mtip.length()) mtip=node.@mtip;
			if (node.phis[0].@long>0) dlina=node.phis[0].@long;
			if (node.phis[0].@minlong>0) mindlina=node.phis[0].@minlong;
			else mindlina=dlina;
			if (node.char[0].@pow.length()) powerfull=true;
			if (node.char[0].@combo.length()) combinat=true;
			visvzz.scaleX=visvzz.scaleY=dlina/100;
			visvzz.alpha=10/rapid;
			if (visvzz.alpha>1) visvzz.alpha=1;
			kolvzz=Math.round((dlina-mindlina)/stepdlina);
			vzz=new Array();
			storona=owner.storona;
			b=new Bullet(own,X-(dlina/2)*storona,Y-dlina,null,false);
			b.weap=this;
			b.tipBullet=1;
			setBullet(b);
			b.knockx=storona;
			b.knocky=-0.2;
			b.liv=10;
			b.probiv=0.75;
			b.dx=b.dy=b.vel=0;
			if (node.@crack.length()) b.crack=node.@crack;
			//if (mtip>0) 
			checkLine=true;
			b.checkLine=checkLine;
			//b.flare='bum';
			rot=-Math.PI/2-(Math.PI/6)*storona;
			cos0=Math.cos(rot), sin0=Math.sin(rot);
			for (var i=0; i<=kolvzz; i++) {
				var nx=X+cos2*(mindlina+i*stepdlina)+anim*storona*(mindlina+i*stepdlina);
				var ny=Y+sin2*(mindlina+i*stepdlina);
				vzz[i]={X:0,Y:0};
			}
			if (!auto && !powerfull)combinat=true;
		}
		
		public override function addVisual() {
			super.addVisual();
			if (visvzz) World.w.grafon.visObjs[sloy].addChild(visvzz);
		}
		public override function remVisual() {
			super.remVisual();
			if (visvzz && visvzz.parent) visvzz.parent.removeChild(visvzz);
		}
		public override function setPers(gg:UnitPlayer, pers:Pers) {
			super.setPers(gg,pers);
			rapidMult=1/pers.meleeSpdMult;
			damMult*=pers.meleeDamMult;
		}
		
		public function lineCel():int {
			var res=0;
			var bx:Number=owner.X;
			var by:Number=owner.Y-owner.scY*0.75;
			var ndx:Number=(celX-bx);
			var ndy:Number=(celY-by);
			var div=Math.floor(Math.max(Math.abs(ndx),Math.abs(ndy))/World.maxdelta)+1;
			for (var i=1; i<div; i++) {
				celX=bx+ndx*i/div;
				celY=by+ndy*i/div;
				var t:Tile=World.w.loc.getAbsTile(Math.floor(celX),Math.floor(celY));
				if (t.phis==1 && celX>=t.phX1 && celX<=t.phX2 && celY>=t.phY1 && celY<=t.phY2) {
					return 0
				}
			}
			return 1;
		}
		
		public override function actions() {
			var ds=40*owner.storona;
			meleeR=World.w.pers.meleeR;
			if (loc && loc.sky) meleeR*=10;
			if (owner.player) {
				levitRun=(owner as UnitPlayer).pers.meleeRun;
				if (loc.sky) levitRun*=4;
				if (mtip==0) {
					celX=owner.celX-dlina*0.8*storona;
					celY=owner.celY+dlina*0.3;
					lineCel();
					storona=(owner.celX>owner.X-100*owner.storona)?1:-1;
					del.x=(celX-(owner.X+ds));
					del.y=(celY-owner.weaponY);
					norma(del,meleeR);
					ds=(owner as UnitPlayer).pers.meleeS*owner.storona;
				} else {
					if (mtip==2 || t_attack<=0) {
						celRX=owner.celX;
						celRY=owner.celY;
					} /*else if (mtip==1) {
						del.x=(celX-owner.weaponX);
						del.y=(celY-owner.weaponY);
						norma(del,100);
						celRX=del.x;
						celRX=del.y;
					}*/
					celX=celRX;
					celY=celRY;
					if (mtip==2 || t_attack<=0) {
						(owner as UnitPlayer).lineCel();
						celRX=owner.celX;
						celRY=owner.celY;
					}
					if (mtip==2) {
						del.x=(celRX-(owner.X+ds));
						del.y=(celRY-owner.weaponY);
						norma(del,dlina-(dlina-mindlina)/2);
						celRX-=del.x;
						celRY-=del.y;
					}
					storona=(celRX>owner.X)?1:-1;
					del.x=(celRX-(owner.X+ds));
					del.y=(celRY-owner.weaponY);
					norma(del,meleeR);
					ds=(owner as UnitPlayer).pers.meleeS*owner.storona;
				}
			} else {
				if (mtip==0) {
					celX=owner.celX-dlina*0.8*storona;
					celY=owner.celY+dlina*0.3;
				} else {
					celX=owner.celX;
					celY=owner.celY;
				}
				storona=owner.storona;
				ready=true;
			}
			if (krep>0 || !X) {
				X=owner.weaponX;
				Y=owner.weaponY;
				ready=true;
				//rot=Math.atan2(owner.celY-Y, Math.abs(owner.celX-X)*owner.storona);
			} else {
				var tx=celX-X;
				var ty=celY-Y;
				if (mtip!=0) {
					tx=celRX-X;
					ty=celRY-Y;
				}
				ready=((tx*tx+ty*ty)<100);			//вот тут баг с копьями
				del.x=((owner.X+ds+del.x)-X)/2;
				del.y=((owner.weaponY+del.y)-Y)/2;
				if (owner.player) {
					norma(del,Math.max(levitRun,1/massa));
				}
				blumR=(del.x*storona+del.y)/2;
				X+=del.x;//(tx)/Math.max(3,massa*50);
				Y+=del.y;//(ty)/Math.max(3,massa*50);
				//rot=Math.atan2(owner.celY-Y, owner.celX-X);
			}
			visvzz.visible=false;
			if (t_attack>0) {
				var isPow:Boolean=false;
				if (powerfull && t_attack<rapid_act*5/6 && pow>2 && pow<rapid_act*2.15) {
					//trace(Math.round(pow/(rapid_act*2.15)*100));
					anim=-1/4;
					if (mtip==1) quakeY=pow/(rapid_act*2.15)*30*(Math.random()-0.5);
					else quakeY=pow/(rapid_act*2.15)*30;
					powerMult=1+pow/(rapid_act*2.15);
					b.damage=curDam*powerMult;
					b.otbros=otbros*otbrosMult*powerMult;
					isPow=true;
					//усиление удара
				} 
				if (!isPow) {
					if (t_attack==1)is_shoot=true;
					if (t_attack>=rapid_act*5/6) {
						anim=-(rapid_act-t_attack)/rapid_act*1.5;
					} else if (t_attack>=rapid_act/2 && t_attack<rapid_act*5/6) {
						anim=-1/4+((rapid_act-t_attack)/rapid_act-1/6)*3.75;
					} else {
						anim=t_attack*2/rapid_act;
					}
				}
				if (mtip==0) {
					rot=-Math.PI/2+(-Math.PI/6+anim*Math.PI)*storona;
					if (t_attack>=rapid_act/2 && t_attack<rapid_act*5/6) {
						if (!isPow) {
							visvzz.visible=true;
							if (powerMult>1.5) {
								visvzz.alpha=1;
								visvzz.gotoAndStop(2);
							} else {
								visvzz.alpha=Math.min(10/rapid_act,1);
								visvzz.gotoAndStop(1);
							}
						}
						cos2=Math.cos(rot), sin2=Math.sin(rot);
						for (var i=0; i<=kolvzz; i++) {
							var nx=X+cos2*(mindlina+i*stepdlina);//+anim*storona*(mindlina+i*stepdlina);
							var ny=Y+sin2*(mindlina+i*stepdlina);
							if (!isPow) b.bindMove(nx,ny, vzz[i].X, vzz[i].Y);
							vzz[i].X=nx, vzz[i].Y=ny;
						}
						if (lasM) vis.gotoAndStop(3);
						if (!isPow && sndShoot!='' && !sndPl) {
							Snd.ps(sndShoot,X,Y,0,Math.random()*0.5+0.5);
							sndPl=true;
						}
					} else {
						if (lasM) vis.gotoAndStop(2);
						sndPl=false;
					}
				} else if (mtip==1) {
					rot=Math.atan2(celY-(owner.Y-owner.scY/2),celX-owner.X);
					cos2=Math.cos(rot), sin2=Math.sin(rot);
					plX=cos2*anim*atDlina;
					plY=sin2*anim*atDlina;
					if (t_attack>=rapid_act/2 && t_attack<rapid_act*5/6) {
						nx=X+cos2*dlina+plX;
						ny=Y+sin2*dlina+plY;
						if (!isPow) b.bindMove(nx,ny, vzz[0].X, vzz[0].Y);
						vzz[0].X=nx, vzz[0].Y=ny;
						if (lasM) vis.gotoAndStop(3);
						if (!isPow && sndShoot!='' && !sndPl) {
							Snd.ps(sndShoot,X,Y,0,Math.random()*0.5+0.5);
							sndPl=true;
						}
					} else {
						if (lasM) vis.gotoAndStop(2);
						sndPl=false;
					}
				} else if (mtip==2) {
					rot=Math.atan2(celY-(owner.Y-owner.scY/2),celX-owner.X);
					cos2=Math.cos(rot), sin2=Math.sin(rot);
					if (t_attack==1) {
						cos2=Math.cos(rot), sin2=Math.sin(rot);
						b.bindMove(X+cos2*mindlina, Y+sin2*mindlina, X+cos2*dlina, Y+sin2*dlina);
						if (lasM) vis.gotoAndStop(3);
						if (sndShoot!='' && !sndPl) {
							Snd.ps(sndShoot,X,Y,0,Math.random()*0.5+0.5);
							sndPl=true;
						}
					} else {
						if (lasM) vis.gotoAndStop(2);
						sndPl=false;
					}
				}
				if (!isPow) t_attack--;
			
			} else {
				if (lasM) vis.gotoAndStop(1);
				sin1=sin2=sin0; cos1=cos2=cos0;
				if (mtip==0) {
					rot=-Math.PI/2-Math.PI/6*storona;
				} else {
					rot=Math.atan2(celY-(owner.Y-owner.scY/2),celX-owner.X);
				}
			}
			if (sndPrep!='') {
				if (!is_pattack && is_attack) {
					sndCh=Snd.ps(sndPrep,X,Y,t_prep*30);
				}	//звук раскрутки
				if (is_attack && sndCh!=null && sndCh.position>snd_t_prep2-300) {
					sndCh.stop();
					sndCh=Snd.ps(sndPrep,X,Y,snd_t_prep1+200);
				}//	звук продолжения
				if (is_pattack && !is_attack && t_prep>0 && sndCh!=null && sndCh.position<snd_t_prep2-400)	{
					sndCh.stop();
					sndCh=Snd.ps(sndPrep,X,Y,snd_t_prep2+100);
				}	//звук остановки
			}
			if (recharg && hold<holder && t_attack==0) {
				t_rech--;
				if (t_rech<=0) {
					hold++;
					t_rech=recharg;
				}
			}
			if (t_auto>0) {
				t_auto--;
			} else pow=0;
			if (t_combo>0) {
				t_combo--;
			} else combo=0;
			if (t_attack==0 && t_reload>0) t_reload--;
			if (t_reload==Math.round(10*reloadMult)) reloadWeapon();
			is_pattack=is_attack;
			is_attack=false;
		}
		protected override function shoot():Bullet {
			var sk=1;
			if (owner) {
				sk=owner.weaponSkill;
				if (owner.player) sk=weaponSkill;
			}
			if (hp<maxhp/2) breaking=(maxhp-hp)/maxhp*2-1;
			else breaking=0;
			b.off=false;
			b.loc=owner.loc;
			b.knockx=storona;
			curDam=resultDamage(damage,sk);
			b.damage=curDam*ammoDamage;
			b.otbros=otbros*otbrosMult;
			b.dist=0;
			b.tilehit=false;
			b.parr=null;
			b.partEmit=true;
			if (mtip==0) {
				sin2=sin0; cos2=cos0;
				for (var i=0; i<=kolvzz; i++) {
					vzz[i].X=X+cos2*(mindlina+i*stepdlina);
					vzz[i].Y=Y+sin2*(mindlina+i*stepdlina);
				}
			} else {
				cos2=Math.cos(rot), sin2=Math.sin(rot);
				vzz[0].X=X+cos2*(dlina-0.25*atDlina);
				vzz[0].Y=Y+sin2*(dlina-0.25*atDlina);
			}
			b.X=X+cos2*dlina;
			b.Y=Y+sin2*dlina;
			b.inWater=0;
			if (loc.getAbsTile(b.X, b.Y).water>0) b.inWater=1;
			if (mtip==0) {
				b.tileX=Math.floor(owner.celX/World.tileX);
				b.tileY=Math.floor(owner.celY/World.tileY);
			}
			if (mtip==2) {
				quakeX=Math.random()*otbros;
				quakeY=Math.random()*otbros;
			}
			if (holder>0 && hold>0) {
				hold-=rashod;
				if (owner.player && loc.train && ammo!='recharg') World.w.invent.items[ammo].kol+=rashod;
			}
			//b=new Bullet(owner,X-(dlina/2)*owner.storona,Y-dlina,vBullet);
			t_auto=3;
			return b;
		}

		//результирующий урон
		public override function resultDamage(dam0:Number, sk:Number=1):Number {
			return (dam0+damAdd)*damMult*sk*skillPlusDam*(1-breaking*0.6);
		}
		//результирующее время атаки
		public override function resultRapid(rap0:Number, sk:Number=1):Number {
			if (mtip==2) return rap0/skillConf;
			return rap0/skillConf*rapidMult/owner.rapidMultCont;
		}
		
		protected override function weaponAttack() {
			powerMult=1;
			if (t_attack<=0) {
				setBullet(b);
				rapid_act=resultRapid(rapid);
				if (loc.getAbsTile(X,Y).water) rapid_act*=2; 
				visvzz.alpha=Math.min(10/rapid_act,1);
				t_attack=rapid_act;
				shoot();
				if (combinat) {
					t_combo=rapid_act+20;
					combo++;
					if (combo>=4) {
						powerMult=2;
						b.damage=curDam*powerMult;
						b.otbros=otbros*otbrosMult*powerMult;
						combo=0;
					}
				}
			} else if (t_attack>10) combo=0;
		}
		
		public override function crash(dam:int=1) {
			if (owner.player) {
				if (!loc.train && !World.w.alicorn) hp-=dam+ammoHP;
				if (hp<0) hp=0;
				World.w.gui.setWeapon();
			}
			if (otbros>5) {
				World.w.quake(otbros*b.dx/b.vel, otbros*b.dy/b.vel);
			}
			if (mtip==0 || mtip==1) {
				quakeX=-otbros*b.dx/b.vel;
				quakeY=-otbros*b.dy/b.vel;
			} else {
				quakeX=Math.random()*otbros*2;
				quakeY=Math.random()*otbros*2;
			}
		}
		
		public override function animate() {
			if (quakeX!=0) {
				quakeX*=(Math.random()*0.3+0.5);
				if (quakeX<1 && quakeX>-1) quakeX=0;
			}
			if (quakeY!=0) {
				quakeY*=(Math.random()*0.3+0.5);
				if (quakeY<1 && quakeY>-1) quakeY=0;
			}
			vis.y=Y+plY+quakeY;
			if (krep==0) {
				vis.x=X+plX+quakeX;//+anim*storona*dlina;
				vis.scaleY=storona;
				vis.rotation=rot*180/Math.PI+blumR; //-90-((30-anim*180)*owner.storona);//+rot*180/Math.PI+(1-owner.storona)*90;
				visvzz.x=vis.x;
				visvzz.y=vis.y;
				visvzz.rotation=vis.rotation;
				visvzz.scaleY=dlina/100*storona;
			} else {
				vis.x=X;
				vis.scaleY=owner.storona;
				vis.rotation=90*owner.storona-90+owner.weaponR*owner.storona;// 90*owner.storona-90-owner.weaponR*owner.storona; //-90-((30-anim*180)*owner.storona);//+rot*180/Math.PI+(1-owner.storona)*90;
			}
		}
	}
	
}
