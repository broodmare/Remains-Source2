package.fe
{
    import flash.utils.Dictionary;
    import flash.events.Event;

    public class UnitLoader
    {
        private static const unitsFileTarget:String = 'Modules/core/AllData/units.json';

        private static var unitJSON:Object;
        private static var isLoaded:Boolean = false;
        
        private static var unitDictionary:Dictionary;
    }

    public static function loadUnits(callback:Function):void // Load units and then run the specified function
    {
        if (isLoaded)
        {
            callback(unitDictionary);
        }
        else
        {
            JSONLoader.importFile(unitsFileTarget, function(jsonObject:Object):void
            {
                addUnitsToDictionary(jsonObject);
                isLoaded = true;
                callback(unitDictionary);
            });
        }
    }

    private static function addUnitsToDictionary(jsonObject:Object):void
    {
        var unitCount:int = 0;

        for (var unit:Object in jsonObject)
        {
            var id:String = unit.id;    // Get 'id' as the key
            unitDictionary[id] = unit;  // Store the entire unit object with 'id' as the key
            unitCount++;
        }

        trace("Added: " + unitCount + " units to unitDictionary");
    }

    public static function getUnitData(unitID:String):Object
    {
        return unitDictionary[unitID];
    }
}