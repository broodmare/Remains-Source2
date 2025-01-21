package fe {
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.errors.IllegalOperationError;

	public class SymbolFactory {
		//Dynamically creates an instance of a symbol from the main SWF.
		public static function createSymbol(className:String):* {
			try {
				// Retrieve the class reference from the global namespace
				var SymbolClass:Class = getDefinitionByName(className) as Class;
				
				if (SymbolClass == null) {
					throw new IllegalOperationError("Class " + className + " not found.");
				}
				
				// Instantiate and return the symbol
				return new SymbolClass();
			}
			catch (error:ReferenceError) {
				trace("Error: Symbol '" + className + "' does not exist in the main SWF.");
				throw error;
			}
			catch (error:IllegalOperationError) {
				trace(error.message);
				throw error;
			}
		}
	}
}