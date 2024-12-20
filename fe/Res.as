package fe {

	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
 
	public class Res {

		public static var currentLanguageData:XML; 		// Current localization file eg. 'text_en.xml'
		public static var fallbackLanguageData:XML;		// Default language that is used a fallback if an error occurs.

		private static const typeDictionary:Object = {
			'u':'unit', 'w':'weapon', 'a':'armor', 'o':'obj', 'i':'item',
			'e':'eff', 'f':'info', 'p':'pip', 'k':'key', 'g':'gui', 'm':'map',
			0:'n', 1:'info', 2:'mess', 3:'help'
		};

                /*
                * Checks if a localized text exists for the given tip and id.
                * It first searches in currentLanguageData, and if not found, it searches in fallbackLanguageData.
                * @tip  -- What category to search for the string in.
                * @id   -- The internal name of the string we want to find the localization for.
                */
		public static function istxt(tip:String, id:String):Boolean {
			var xmlList:XMLList = currentLanguageData[typeDictionary[tip]].(@id == id); // Check currentLanguageData for matching nodes.
			if (xmlList.length() == 0) {
				xmlList = fallbackLanguageData[typeDictionary[tip]].(@id == id); // If no matching nodes are found, check fallbackLanguageData.
				if (xmlList.length() == 0) return false; // If there's still no matching nodes, return false.
			}
			return true;
		}

                /*
                * Retrieves and formats the localized text based on the provided parameters.
                * @tip   -- The type of text, eg. 'w' for 'weapon'
                * @id    -- Internal name of the string
                * @razd  -- String variations?
                * @dop   -- Extra formatting?
                */
		public static function txt(tip:String, id:String, razd:int = 0, dop:Boolean = false):String {
			if (id == '') return '';
			try {
				// Reduce redundant dictionary lookups
				var tipType:String = typeDictionary[tip];
				var razdType:String = typeDictionary[razd];

				var s:String;	// String representation of localized text.
				var xl1:XMLList; // XML List of all returned nodes for the type[id].

				// Try to get a localized string from currentLanguage or fallbackLanguage
				for each (var langData in [currentLanguageData, fallbackLanguageData]) {
					if (!s) // Skip checking fallback if string was found {
						xl1 = langData[tipType].(@id == id);
						if (xl1.length() > 0) s = xl1[razdType][0];
					}
				}

				// Handle cases where no data was found
				if (!s) {
					if (tip == 'o') return '';
					if (razd == 0) return '*' + tipType + '_' + id;
					return '';
				}

				var xl2:XML = xl1[0];

				if (xl2.@m == '1') { // Strings with profanity
					var spl:Array = s.split('|');
					if (spl.length >= 2) s = spl[World.w.matFilter ? 1:0];
				}
				if (razd >= 1 || dop) {
					if (xl2.@s1.length()) s = addKeys(s, xl2);
					if (xl2[razdType][0].@s1.length()) s = addKeys(s, xl2[razdType][0]);

					//Merged all 3 regex searches instead of iterating 3 times per string.
					var combinedRegExp:RegExp = /\[br]|\[|]/g;
					s = s.replace(combinedRegExp, function(match:String, ...args):String {
						switch (match) {
							case "[br]":
								return "<br>";
							case "[":
								return "<span class='yellow'>";
							case "]":
								return "</span>";
							default:
								return ''; // Needed for compile, shouldn't ever actually get here
						}
					});
				}

				var controlCharsRegExp:RegExp = /[\b\r\t]/g;
				if (dop) s = s.replace(controlCharsRegExp, '');
				if (tip == 'f' || tip == 'e' && razd == 2 || razd >= 1 && xl2.@st.length()) s = "<span class='r" + xl2.@st + "'>" + s + "</span>";
			}
			catch(err:Error) {
				trace('ERROR: (00:19) - Could not get localization for "' + typeDictionary[tip] + '(' + id + ')"!');
				s = '';
				return s;
			}

			return s;
		}

                // TODO: Obsolete, remove 
		public static function guiText(id:String):String {
			return txt('g', id);
		}

                // TODO: Obsolete, remove
		public static function pipText(id:String):String {
			return txt('p', id);
		}

                /*
                * Retrieves and formats message texts, potentially including multiple lines and speaker names.
                * @id   -- Internal name of the string
                * @v    -- Variations?
                * @imp  -- Displays a message based on it's importance level
                */
		public static function messText(id:String, v:int = 0, imp:Boolean = true):String {
			var s:String = '';
			try {
				var xml:XMLList = currentLanguageData.txt.(@id == id);
				if (xml.length()==0) {
					xml = fallbackLanguageData.txt.(@id == id);
				}
				if (xml.length()==0) return '';

				if (!imp && !(xml.@imp > 0)) return '';
				var tip:int = xml.@imp;
				if (v==1) {
					s = xml.info[0];
				}
				else {
					if (xml.n[0].r.length()) {
						for each (var node:XML in xml.n[0].r) {
							var s1:String=node.toString();
							if (node.@m.length()) {
								var sar:Array=s1.split('|');
								if (sar) {
									if (World.w.matFilter && sar.length>1) s1=sar[1];
									else s1 = sar[0];
								}
							}
							if (node.@s1.length()) {
								for (var i:int = 1; i <= 5; i++) {
									if (node.attribute('s'+i).length())  s1=s1.replace('@'+i,"<span class='yellow'>"+World.w.ctr.retKey(node.attribute('s'+i))+"</span>");
								}
							}
							s1=s1.replace(/[\b\r\t]/g,'');
							if (tip==1) {
								if (node.@p.length()==0) s+="<span class='dark'>"+s1+"</span>"+'<br>';
								else {
									//TODO: Figure out how to declare this without breaking notes.
									var pers = node.@p;
									if (pers.indexOf("lp") == 0) s += "<span class='light'>" + ' - ' + s1 + "</span>" + '<br>';
									else s += ' - ' + s1 + '<br>';
								}
							} 
							else s += s1+'<br>';
						}
					}
                                        else s = xml.n[0];
				}
				s = lpName(s);
				s = s.replace(/\[br]/g,'<br>');
				if (xml.@s1.length()) {
					for (var j:int = 1; j <= 5; j++) {
						if (xml.attribute('s' + j).length())  s = s.replace('@' + j, "<span class='r2'>" + World.w.ctr.retKey(xml.attribute('s' + j)) + "</span>");
					}
				}
			}
			catch (err) {
				trace('ERROR: (00:1A)');
				return 'err: ' + id;
			}
			return (s == null) ? '':s;
		}

                // The advice widget at the bottom of the main menu
		public static function advText(n:int):String {
			var xml:XML = currentLanguageData.advice[0]; // Grab the entire advice node with all its child 'a' nodes.
			var s:String = xml.a[n];
			return (s == null) ? '':s;
		}

                // Retrieves a randomized reply text based on id and act, with an option to handle gender-specific replies.
		public static function repText(id:String, act:String, msex:Boolean=true):String {
			var xl:XMLList = currentLanguageData.replic[0].rep.(@id==id && @act==act);

			if (xl.length()==0) return '';
			xl = xl[0].r;
			var n:int = xl.length();
			if (n == 0) return '';
			var num:int = Math.floor(Math.random() * n);
			if (World.w.matFilter && xl[num].@m.length()) return '';
			var s:String = xl[num];
			var n1:int = s.indexOf('#');
			if (n1>=0) {
				var n2:int = s.lastIndexOf('#');
				var ss:String=s.substring(n1+1,n2);
				s=s.substring(0,n1)+ss.split('|')[msex?0:1]+s.substring(n2+1);
			}
			s = s.replace('@lp',World.w.pers.persName);
			return s;
		}

                // Retrieves an array of names based the ID
		public static function namesArr(id:String):Array {
			var xl:XMLList = currentLanguageData.names;
			if (xl.length()==0) return null;
			xl=xl[0].name.(@id==id);
			if (xl.length()==0) return null;
			xl=xl[0].r;
			var arr:Array = [];
			for each (var n:XML in xl) arr.push(n.toString());
			return arr;
		}

                // Replaces the placeholder @lp with the player's name
		public static function lpName(s:String):String {
			return s.replace(/@lp/g,World.w.pers.persName);
		}

                // Formats a timestamp into a human-readable date string
		public static function getDate(num:Number):String {
			var date:Date = new Date(num);
			return date.fullYear + '.' + (date.month >= 9 ? '':'0') + (date.month + 1) + '.' + (date.date >= 10 ? '':'0') + date.date + '  ' + date.hours + ':' + (date.minutes >= 10 ? '':'0') + date.minutes;
		}

                // Formats a number to one decimal place
		public static function numb(n:Number):String {
			var k:int=Math.round(n*10);
			if (k%10==0) return (k/10).toString();
			else {
				if (n<0) return Math.ceil(k/10)+'.'+Math.abs(k%10);					
				return int(k/10)+'.'+(k%10);
			}
		}
		
		//Inserts key representations into a string based on XML attributes.
		public static function addKeys(s:String, xml:XML):String {
			if (s==null) return '';
			for (var i:int = 1; i <= 5; i++) {
				if (xml.attribute('s'+i).length())  s=s.replace('@'+i,"<span class='imp'>"+World.w.ctr.retKey(xml.attribute('s'+i))+"</span>");
			}
			return s;
		}
		
		// Replaces carriage return and newline characters with HTML <br> tags
		public static function formatText(s:String):String {
			return s.replace(/\r\n/g,'<br>');
		}
		
		// Formats game time from milliseconds to HH:MM:SS format
		public static function gameTime(n:Number):String {
			var sec:int = Math.round(n/1000);
			var h:int = int(sec/3600);
			var m:int = int((sec-h*3600)/60);
			var s:int = sec%60;
			return h.toString()+':'+((m<10)?'0':'')+m+':'+((s<10)?'0':'')+s;
		}

                // Wraps each character in the input string with a <span> tag assigning it a color from a rainbow sequence
		public static function rainbow(s:String):String {
			var n:int = 0;
			var res:String = '';
			var rainbowcol:Array = ['red', 'orange', 'yellow', 'green', 'blue', 'purple'];

			for (var i:int = 0; i < s.length; i++) {
				res += "<span class='" + rainbowcol[n] + "'>" + s.charAt(i) + "</span>";
				n++;
				if (n >= 6) n = 0;
			}
			return res;
		}

                // Dynamically retrieves a MovieClip class by its name
		public static function getVis(id:String, def:Class = null):MovieClip {
			var r:Class;
			try {
				r = getDefinitionByName(id) as Class;
			}
			catch (err:ReferenceError) {
				trace('ERROR: (00:1B)');
				r = def;
			}
			if (r) return new r()
			else return null;
		}

                // Retrieves a class by its primary ID, backup ID, and/or an optional default
                public static function getClass(id1:String, id2:String=null, def:Class=null):Class {
			var r:Class;
			try {
				r = getDefinitionByName(id1) as Class;
			} 
			catch (err:ReferenceError) {
				//trace('ERROR: (00:1C) - Could not retrieve class with ID1: "' + id1 + '".');
				if (id2 == null) r = def;
				else {
					try {
						r = getDefinitionByName(id2) as Class;
					}
					catch (err:ReferenceError) {
						//trace('ERROR: (00:1D) - Could not retrieve class with ID2: "' + id2 + '".');
						r = def;
					}
				}
			}
			return r;
		}
	}	
}
