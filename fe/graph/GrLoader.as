package fe.graph
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import flash.events.Event;
    import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    public class GrLoader {
        
        var gr:Grafon;            // Reference to the Grafon instance
        
        public var id:int;
        public var loader:Loader;
        private var loaderName:String;
        public var progressLoad:Number = 0;
        public var isLoad:Boolean = false;
        public var res:*;        // Holds loaded SWF content
        
        public var type:String; // 'looseImage' or 'swf'

        public static var kol:int = 0;
        public static var kolIsLoad:int = 0;

        private static const textureDirectory:String = 'Modules/core/textures/';

        private static var manifestLoaded:Boolean = false;
        public static var manifest:Object;
        private var textureSet:Object;

        // For 'looseImage' type
        private var imageLoaders:Array;
        private var imagesLoaded:int = 0;
        private var totalImages:int = 0;
        private var imageDictionary:Object;

        /**
         * Constructor for GrLoader.
         * @param nid Unique identifier for the loader.
         * @param url URL of the resource to load.
         * @param ngr Reference to the Grafon instance.
         * @param loadType Type of resource: 'looseImage' or 'swf'.
         */
        public function GrLoader(nid:int, url:String, ngr:Grafon, loadType:String = "swf") {
            
            gr = ngr;
            id = nid;
            type = loadType;
            res = null;
            loaderName = url;

            kol++;

            
            // Load images from a swf
            if (type == "swf") {
                loader = new Loader();
                var swfFile:File = File.applicationDirectory.resolvePath(url);
                var swfURLReq:URLRequest = new URLRequest(swfFile.url);
                trace("GrLoader/GrLoader() - Loading SWF: " + url + ", type: " + loadType);
                
                // Add event listeners
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, funLoaded);
                loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, funProgress);
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                
                // Start loading
                loader.load(swfURLReq);
            }
            // Load loose images from a folder
            else if (type == "looseImage") {
                trace("GrLoader/GrLoader() - Loading loose files: " + url + ", type: " + loadType);
                // If needed, initialize the manifest of all textures
                if (!manifestLoaded) {
                    var manifestURL:String = textureDirectory + 'manifest.json';
                    trace("GrLoader/GrLoader() - Loading manifest file: " + manifestURL);
                    
                    var file:File = File.applicationDirectory.resolvePath(manifestURL);
                    var stream:FileStream = new FileStream();
                    try {
                        // Open the local file synchronously for reading, then parse the entire file into a string
                        stream.open(file, FileMode.READ);
                        var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
                        manifest = JSON.parse(fileData);
                        manifestLoaded = true;
                        trace("GrLoader/GrLoader() - Manifest loaded successfully");
                    }
                    catch (error:Error) {
                        trace("GrLoader/GrLoader() - Error: Failure while loading manifest: " + file.nativePath + " Error: " + error.message);
                    }
                }
                // Otherwise grab the textureSet from the manifest
                textureSet = manifest.texture;  // WARNING -- HARDCODED TO ONLY LOAD IN THE 'TEXTURE' TEXTURESET!!
                if (textureSet == null) {
                    trace("GrLoader/GrLoader() - Error: manifest was not parsed successfully")
                }

                isLoad = false; // Indicate this loader hasn't loaded all textures yet

                // Initialize dictionary to store images
                imageDictionary = {};
                imageLoaders = [];
                for (var key:String in textureSet) {
                    var imageRelativePath:String = textureDirectory + textureSet[key]; // Note: Grabs the pair here 
                    var imageFile:File = File.applicationDirectory.resolvePath(imageRelativePath);
                    trace("GrLoader - Loading image: " + imageRelativePath);
                    
                    var imageLoader:Loader = new Loader();
                    imageLoaders.push({loader: imageLoader, key: key});
                    
                    // Add event listeners
                    imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
                    imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, funProgress);
                    imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                    imageLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                    
                    // Start loading
                    totalImages++;
                    imageLoader.load(new URLRequest(imageRelativePath));
                }
            }
        }
        
        // Handler for when a single image has finished loading.
        private function onImageLoaded(event:Event):void {
            var loaderInfo = event.target;
            var bitmap:Bitmap = loaderInfo.content as Bitmap;
            if(bitmap) {
                // Retrieve the key associated with this loader
                var imageLoader:Loader = loaderInfo.loader;
                var imageURL:String = imageLoader.contentLoaderInfo.url;
                // Store the loaded data by...
                for each (var loaderData:Object in imageLoaders) {
                    // Iterating through each loader to find the one with the correct url
                    if (loaderData.loader.contentLoaderInfo.url == imageURL) {
                        // Then copying the loader's data to the dictionary using the url as a key
                        imageDictionary[loaderData.key] = bitmap.bitmapData;
                        break;
                    }
                }
            }
            else {
                trace("GrLoader/onImageLoaded() - Failed to load bitmap for URL:", loaderInfo.url);
            }

            imagesLoaded++;

            if (imagesLoaded == imageLoaders.length) {
                trace("GrLoader/onImageLoaded() - Loader finished importing all textures for set: " + loaderName);
                isLoad = true;
                progressLoad = 1;
                kolIsLoad++;
                gr.checkLoaded(id);
                // Remove event listeners
                for each (var imgLoaderData:Object in imageLoaders) {
                    var imgLoader:Loader = imgLoaderData.loader;
                    imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
                    imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, funProgress);
                    imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
                    imgLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                }
            }

            gr.allProgress();
        }

        // Handler for a SWF has finished loading.
        private function funLoaded(event:Event):void {
            if(type == 'swf') {
                res = event.target.content;
            }
            isLoad = true;
            progressLoad = 1;
            kolIsLoad++;
            gr.checkLoaded(id);
            
            // Remove event listeners
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, funLoaded);  
            loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, funProgress);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            
            gr.allProgress();
        }

        /**
         * Handler for progress events during loading.
         */
        private function funProgress(event:ProgressEvent):void {
            if (type == "swf") {
                progressLoad = event.bytesLoaded / event.bytesTotal;
            }
            else if (type == "looseImage") {
                progressLoad = imagesLoaded / totalImages;
            }
            gr.allProgress();
        }

        //Handler for IO errors during loading
        private function onIOError(event:IOErrorEvent):void {
            trace("GrLoader/onIOError() - Failed to load: " + event.text);
            handleError();
        }

        //Handler for Security errors during loading
        private function onSecurityError(event:SecurityErrorEvent):void {
            trace("GrLoader/onSecurityError() - Security error: " + event.text);
            handleError();
        }

        //Common error handling
        private function handleError():void {
            isLoad = false;
            progressLoad = 0;
            kolIsLoad++;
            gr.checkLoaded(id);
            // Remove event listeners if applicable
            if (type == "swf" && loader) {
                loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, funLoaded);
                loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, funProgress);
                loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
                loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            }
            else if (type == "looseImage") {
                for each (var imgLoaderData:Object in imageLoaders) {
                    var imgLoader:Loader = imgLoaderData.loader;
                    imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
                    imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, funProgress);
                    imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
                    imgLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                }
            }
            gr.allProgress();
        }

        /**
         * Retrieves an object (texture) by name.
         * @param textureName The key/name of the texture to retrieve.
         * @return The requested texture object.
         */
        public function getObj(textureName:String):* {
            if (type == "swf") {
                return res.getObj(textureName);
            }
            else if (type == "looseImage") {
                return imageDictionary[textureName];
            }
            return null;
        }
    }
}