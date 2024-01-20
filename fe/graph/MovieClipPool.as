package fe.graph
{
    import flash.display.MovieClip;
    import flash.utils.Dictionary;

    public class MovieClipPool
    {
        // A dictionary to hold arrays of MovieClips for each type
        private static var pools:Dictionary = new Dictionary();

        public function MovieClipPool()
        {
            
        }

        public static function getMovieClip(classType:Class):MovieClip
        {
            // No MovieClips of the requested type in the pool, create a new one
            if (pools[classType] == undefined || pools[classType].length == 0) return new classType();
            // Remove the MovieClip from the pool and return it
            else return pools[classType].pop();
        }

        // Method to return a MovieClip to the pool
        public static function returnMovieClip(mc:MovieClip, classType:Class):void
        {
            // Reset the MovieClip state if necessary
            mc.stop();
            mc.x = 0;
            mc.y = 0;
            mc.rotation = 0;
            mc.scaleX = mc.scaleY = 1;

            // Add the MovieClip to the pool
            if (pools[classType] == undefined) pools[classType] = [mc];
            else pools[classType].push(mc);
        }
    }
}