package fe {
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.errors.IllegalOperationError;

	public class SymbolFactory {
		//Dynamically creates an instance of a symbol from the main SWF.
		public static function createInstance(className:String):* {
			try {
				// Retrieve the class reference from the global namespace
				var SymbolClass:Class = getDefinitionByName(className) as Class;
				return new SymbolClass();
			}
			catch (error:ReferenceError) {
				trace("Error: Symbol '" + className + "' does not exist in the main SWF.");
			}
			catch (error:IllegalOperationError) {
				trace(error.message);
				throw error;
			}
		}

		//Dynamically gets a reference to the class of the symbol (but does not instantiate an instance yet)
		public static function fetchSymbolClass(className:String):* {
			if (className == null) {
				return null;
			}
			
			try {
				return Class(getDefinitionByName(className));
			}
			catch (error:ReferenceError) {
				trace("Error: Symbol '" + className + "' does not exist.");
				return null;
			}
		}
	}
}