package fe.loc {
	
	import fe.*;
	public class Form {
		
		public var id:String;
		public var idMirror:String;
		public var tip:int=0;	//1  передний план, 2-задний план
		
		public var front:String;
		public var back:String;
		public var vid:int;
		public var rear:Boolean=false;
		public var mat:int=0;
		
		public var hp:int=0;
		public var thre:int=0;
		public var indestruct:Boolean=false;
		
		public var phis:int=0;
		public var shelf:Boolean=false;
		public var diagon:int=0;
		public var stair:int=0;
		public var lurk:int=0;

		public function Form(node:XML=null) {
			if (node!=null) {
				id=node.@id;
				if (node.@m.length()) idMirror=node.@m;
				tip=node.@ed;
				if (node.@vid>0) vid=node.@vid;
				else front=node.@id;
				if (node.@back.length()) back=node.@back;
				if (node.@mat.length()) mat=node.@mat;
				if (node.@rear.length()) rear=true;
				if (node.@lurk.length()) lurk=node.@lurk;
				
				if (node.@hp>0) hp=node.@hp;
				if (node.@thre>0) thre=node.@thre;
				if (node.@indestruct>0) indestruct=true;
				
				if (node.@phis.length()) phis=node.@phis;
				if (node.@shelf.length()) shelf=true;
				if (node.@diagon.length()) diagon=node.@diagon;
				if (node.@stair.length()) stair=node.@stair;
			}
		}
		
		public static var fForms:Array;
		public static var oForms:Array;
		
		public static function setForms() {
			fForms=new Array();
			oForms=new Array();
			for each (var node in AllData.d.mat) {
				if (node.@ed==1) fForms[node.@id]=new Form(node);
				else oForms[node.@id]=new Form(node);
			}
		}

	}
	
}
