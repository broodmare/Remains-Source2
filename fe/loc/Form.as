package fe.loc {

	import fe.TextLoader;

	public class Form {

		private static const materialsPath:String = "Modules/core/allData/materials.json";

		public var id:String;
		public var idMirror:String;
		public var tip:int				= 0;	//1 - Foreground, 2 - Background
		
		public var vid:int;
		public var front:String;
		public var back:String;
		
		public var rear:Boolean			= false;
		public var mat:int				= 0;
		
		public var hp:int				= 0;
		public var thre:int				= 0;
		public var indestruct:Boolean	= false;
		
		public var phis:int				= 0;
		public var shelf:Boolean		= false;
		public var diagon:int			= 0;
		public var stair:int			= 0;
		public var lurk:int				= 0;

		public static var fForms:Object;
		public static var oForms:Object;

		public function Form(data:Object) {
			
			id		= data.id;
			tip		= data.ed;
			
			if ("vid" in data) {
				vid = data.vid;
			}
			else {
				front = data.id;
			}

			if ("back" in data) {
				back = data.back;
			}

			if ("rear" in data) {
				rear = data.rear;
			}

			if ("idMirror" in data) {
				idMirror = data.idMirror;
			}
			
			if ("mat" in data) {
				mat = data.mat;
			}
			
			if ("lurk" in data) {
				lurk = data.lurk;
			}
			
			if ("hp" in data) {
				hp = data.hp;
			}
			
			if ("thre" in data) {
				thre = data.thre;
			}
			
			if ("indestruct" in data) {
				indestruct = data.indestruct;
			}
			
			if ("phis" in data) {
				phis = data.phis;
			}
			
			if ("shelf" in data) {
				shelf = data.shelf;
			}
			
			if ("diagon" in data) {
				diagon = data.diagon;
			}
			
			if ("stair" in data) {
				stair = data.stair;
			}
		}
		
		public static function setForms():void {
			fForms = {};
			oForms = {};
			
			// Load the materials data
			var loader:TextLoader = new TextLoader();
			var formData:Object = loader.syncLoad(materialsPath);
			if (TextLoader.isEmpty(formData)) {
				throw new Error("Failed to load form data from: " + materialsPath);
			}
			
			// Use it to create the forms
			for each (var form:Object in formData.mats) {
				if (form.ed == 1) {
					fForms[form.id] = new Form(form);
				}
				else {
					oForms[form.id] = new Form(form);
				}
			}
		}

		public static function getMirror(formID:String):Form {
			if (oForms.hasOwnProperty(formID) && oForms[formID].idMirror != "") {
				var mirrorID:String = oForms[formID].idMirror;
				return oForms[mirrorID]; // Return the mirrored Form
			}
			else {
				trace("Form.as/getMirror() - ERROR: Could not find a mirrored form of \"" + formID + "\"");
				return null;
			}
			
		}
	}
}