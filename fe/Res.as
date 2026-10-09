package fe {

	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	
	// Resource Manager and text parsing
	public class Res {

		private static var istxtCache:Object	= {};
		private static var txtCache:Object		= {};
		private static var cachedData:Object;		// The language data the caches were built from

		// The single letter text types used by txt() and istxt() -> categories in the localization JSON
		private static const categoryDictionary:Object = {
			'u':'unit', 'w':'weapon', 'a':'armor', 'o':'object', 'i':'items',
			'e':'effect', 'f':'info', 'p':'pip', 'k':'keys', 'g':'gui', 'm':'map'
		};

		// The 'razd' of txt() -> field of a localization entry
		private static const fieldDictionary:Object = {
			0:'string', 1:'description', 2:'message', 3:'help'
		};

		// The current language's localization data (see LanguageManager)
		private static function getLanguageData():Object {
			var data:Object = LanguageManager.reference ? LanguageManager.reference.data : null;

			// The language changed, so the cached strings are out of date
			if (data != cachedData) {
				istxtCache	= {};
				txtCache	= {};
				cachedData	= data;
			}

			return data;
		}

		// Returns the entry with this id from a category of the localization data, or null if there isn't one
		private static function getEntry(category:String, id:String):Object {
			var data:Object = getLanguageData();

			if (data == null || id == null || !data.hasOwnProperty(category)) {
				return null;
			}

			var categoryData:Object = data[category];
			return categoryData.hasOwnProperty(id) ? categoryData[id] : null;
		}

		// Returns a dialogue (a conversation, tutorial message, note, etc.) or null if there isn't one with this id
		// Eg. {"Key":"trJump", "s1":"keyJump", "Lines":[{"text":"Press @1 to jump. [br]Hold the key to jump higher"}]}
		public static function dialogue(id:String):Object {
			return getEntry("dialogue", id);
		}

		// Check if a string has a localization
		public static function istxt(tip:String, id:String):Boolean {
			getLanguageData();	// Resets the caches if the language changed

			// Check previously cached lookups
			var key:String = tip + id;
			if (key in istxtCache) {
				return istxtCache[key];
			}

			var result:Boolean = getEntry(categoryDictionary[tip], id) != null;
			istxtCache[key] = result;
			return result;
		}

		/*
		* Retrieves and formats the localized text based on the provided parameters.
		* @tip   -- The type of text, eg. 'w' for 'weapon'
		* @id    -- Internal name of the string
		* @razd  -- String variations?
		* @dop   -- Extra formatting?
		*/
		public static function txt(tip:String, id:String, razd:int = 0, dop:Boolean = false):String {
			getLanguageData();	// Resets the caches if the language changed

			// Return the formatted string if it's already cached
			// (razd and dop both change the result, so they're part of the key - eg. name vs. description of the same id)
			var key:String = tip + "|" + id + "|" + razd + "|" + dop;
			if (txtCache[key]) {
				return txtCache[key];
			}

			var category:String = categoryDictionary[tip];
			var entry:Object = getEntry(category, id);
			var value:* = (entry != null) ? entry[fieldDictionary[razd]] : null;
			var s:String = (value is String) ? value : null;	// String representation of localized text.

			// Handle cases where no data was found
			if (!s) {
				if (tip == "o") return "";
				if (razd == 0) return "*" + category + "_" + id;
				return "";
			}

			if (razd >= 1 || dop) {
				s = addKeys(s, entry);

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
							return ""; // Needed for compile, shouldn't ever actually get here
					}
				});
			}

			var controlCharsRegExp:RegExp = /[\b\r\t]/g;
			
			if (dop) {
				s = s.replace(controlCharsRegExp, '');
			}
			
			if (tip == 'f' || tip == 'e' && razd == 2 || razd >= 1 && entry.style != null) {
				s = "<span class='r" + (entry.style != null ? entry.style : "") + "'>" + s + "</span>";
			}

			txtCache[key] = s; // Cache the formatted string
			return s;
		}

		/*
		* Retrieves and formats message texts (dialogues and quests), potentially including multiple lines and speaker names.
		* @id   -- Internal name of the string
		* @v    -- Returns either the text or the description (only quests have one), eg. v=0: "Chosen-24" v=1: "A few months earlier, the "Chosen-24" was entrusted.."
		* @imp  -- If false, only returns messages that have an importance level (notes)
		*/
		public static function messText(id:String, v:int = 0, imp:Boolean = true):String {
			var dial:Object = dialogue(id);
			var quest:Object = (dial == null) ? getEntry("quest", id) : null;
			
			if (dial == null && quest == null) {
				return "";
			}
			
			var tip:int = (dial != null) ? int(dial.imp) : 0;

			if (!imp && !(tip > 0)) {
				return "";
			}
			
			var s:String = "";
			
			if (v == 1) {
				if (quest != null) {
					s = quest.description;
				}
			}
			else if (quest != null) {
				s = quest.string;
			}
			else if (isPlainText(dial)) {
				s = dial.Lines[0].text;
			}
			else {
				for each (var line:Object in dial.Lines) {
					var s1:String = line.text;
					
					if (line.m) {
						var sar:Array = s1.split('|');
						
						if (World.w.matFilter && sar.length > 1) s1 = sar[1];
						else s1 = sar[0];
					}
					
					s1 = addKeys(s1, line, 'yellow');
					s1 = s1.replace(/[\b\r\t]/g,'');
					
					if (tip==1) {
						if (line.Portrait == null) s+="<span class='dark'>"+s1+"</span>"+'<br>';
						else {
							var pers:String = line.Portrait;
							
							if (pers.indexOf("lp") == 0) s += "<span class='light'>" + ' - ' + s1 + "</span>" + '<br>';
							else s += ' - ' + s1 + '<br>';
						}
					} 
					else s += s1+'<br>';
				}
			}
			
			s = lpName(s);
			s = s.replace(/\[br]/g,'<br>');
			
			if (dial != null) {
				s = addKeys(s, dial, 'r2');
			}
			
			return s;
		}

		// True for dialogues that are one line of text without a speaker or any settings (these were plain text in the old XML)
		private static function isPlainText(dial:Object):Boolean {
			if (dial.Lines == null || dial.Lines.length != 1) {
				return false;
			}
			
			for (var field:String in dial.Lines[0]) {
				if (field != "text") {
					return false;
				}
			}
			
			return true;
		}
		
		// Unit Reply text? Retrieves a randomized reply text based on id and act, with an option to handle gender-specific replies.
		public static function repText(id:String, act:String, msex:Boolean=true):String {
			var lines:Array = getEntry("barks", id + "_" + act) as Array;

			if (lines == null || lines.length == 0) {
				return "";
			}
			
			var num:int = Math.floor(Math.random() * lines.length);
			
			var s:String = lines[num];
			var n1:int = s.indexOf('#');
			
			if (n1 >= 0) {
				var n2:int = s.lastIndexOf('#');
				var ss:String = s.substring(n1 + 1, n2);
				s = s.substring(0, n1) + ss.split('|')[msex ? 0 : 1] + s.substring(n2 + 1);
			}
			
			s = s.replace('@lp', World.w.pers.persName);
			
			return s;
		}

		// Retrieves an array of names based the ID
		public static function namesArr(id:String):Array {
			var entry:Object = getEntry("name", id);
			
			if (entry == null || !(entry.names is Array)) {
				return null;
			}
			
			return (entry.names as Array).concat(); // A copy, since the caller removes names from it as they're used
		}

		// Replaces the placeholder @lp with the player's name
		public static function lpName(s:String):String {
			if (s == null || s == "") {
				return "";
			}
			
			var name:String = "Littlepip";
			
			if (World.w.pers && World.w.pers.persName) {
				name = World.w.pers.persName;
			}
			else {
				trace("Res.as/lpName() - ERROR: World.w.pers.persName was null");
			}
			
			return s.replace(/@lp/g, name);
		}

		// Formats a timestamp into a human-readable date string
		public static function getDate(num:Number):String {
			var date:Date = new Date(num);
			return date.fullYear + '.' + (date.month >= 9 ? '':'0') + (date.month + 1) + '.' + (date.date >= 10 ? '':'0') + date.date + '  ' + date.hours + ':' + (date.minutes >= 10 ? '':'0') + date.minutes;
		}

		// Formats a number to one decimal place
		public static function numb(n:Number):String {
			var k:int = Math.round(n * 10);
			
			if (k%10 == 0) {
				return (k / 10).toString();
			}
			else {
				if (n < 0) {
					return Math.ceil(k / 10) + "." + Math.abs(k%10);
				}				
				
				return int(k/10)+'.'+(k%10);
			}
		}
		
		// Replaces @1-@5 in a string with the keys bound to the controls named by 's1'-'s5' of a localization entry or dialogue line
		// Eg. "Press @1 to jump" with {"s1":"keyJump"} -> "Press <span class='imp'>Space</span> to jump"
		public static function addKeys(s:String, keys:Object, style:String = 'imp'):String {
			if (s == null) {
				return "";
			}

			if (keys == null) {
				return s;
			}

			for (var i:int = 1; i <= 5; i++) {
				if (keys['s' + i])  {
					s = s.replace('@' + i, "<span class='" + style + "'>" + World.w.ctr.retKey(keys['s' + i]) + "</span>");
				}
			}

			return s;
		}
		
		// Replaces carriage return and newline characters with HTML <br> tags
		public static function formatText(s:String):String {
			// Replace line breaks
			s = s.replace(/\r\n/g, '<br>');
			
			// Replace color tags in plain text with HTML spans, eg. [color:yellow]text[/color] -> <span class='yellow'>text</span>
			s = s.replace(/\[color:([a-zA-Z]+)\](.*?)\[\/color\]/g, "<span class='$1'>$2</span>");
			
			return s;
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
			var res:String = "";
			var rainbowcol:Array = ["red", "orange", "yellow", "green", "blue", "purple"];

			for (var i:int = 0; i < s.length; i++) {
				res += "<span class='" + rainbowcol[n] + "'>" + s.charAt(i) + "</span>";
				n++;
				if (n >= 6) {
					n = 0;
				}
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
			
			if (r) {
				return new r();
			}
			else {
				return null;
			}
		}

		// Retrieves a class by its primary ID, backup ID, and/or an optional default
		public static function getClass(id1:String, id2:String = null, def:Class = null):Class {
			var r:Class;
			
			try {
				r = getDefinitionByName(id1) as Class;
			} 
			catch (err:ReferenceError) {
				trace('ERROR: (00:1C) - Could not retrieve class with ID1: "' + id1 + '".');
				if (id2 == null) {
					r = def;
				}
				else {
					try {
						r = getDefinitionByName(id2) as Class;
					}
					catch (err:ReferenceError) {
						trace('ERROR: (00:1D) - Could not retrieve class with ID2: "' + id2 + '".');
						r = def;
					}
				}
			}
			
			return r;
		}
	}	
}