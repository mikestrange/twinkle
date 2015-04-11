package org.web.sdk.display.atlas 
{
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    public class TextureAtlas
    {
		private static const NONE:int = 0;
        private static var sNames:Vector.<String> = new <String>[];
        
		//-----
		private var mTextureInfos:Dictionary;
		
        public function TextureAtlas(atlasXml:XML = null)
        {
            mTextureInfos = new Dictionary();
            if (atlasXml) parseAtlasXml(atlasXml);
        }
        
        protected function parseAtlasXml(atlasXml:XML):void
        {
            const scale:Number = 1;
            
            for each (var subTexture:XML in atlasXml.SubTexture)
            {
                var name:String        = subTexture.attribute("name");
                var x:Number           = parseFloat(subTexture.attribute("x")) / scale;
                var y:Number           = parseFloat(subTexture.attribute("y")) / scale;
                var width:Number       = parseFloat(subTexture.attribute("width")) / scale;
                var height:Number      = parseFloat(subTexture.attribute("height")) / scale;
                var frameX:Number      = parseFloat(subTexture.attribute("frameX")) / scale;
                var frameY:Number      = parseFloat(subTexture.attribute("frameY")) / scale;
                var frameWidth:Number  = parseFloat(subTexture.attribute("frameWidth")) / scale;
                var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight")) / scale;
                var rotated:Boolean    = parseBool(subTexture.attribute("rotated"));
                
                var region:Rectangle = new Rectangle(x, y, width, height);
				var frame:Rectangle = null;
				if (frameWidth > NONE && frameHeight > NONE) 
				{
					frame = new Rectangle(frameX, frameY, frameWidth, frameHeight);
				}
				//信息添加
                addRegion(name, region, frame, rotated);
            }
        }
        
        //取一个资源
        public function getTexture(name:String):Object
        {
            var info:TextureInfo = mTextureInfos[name];
            if (info == null) return null;
			return info;
        }
        
		//取一个资源集合
        public function getTextures(prefix:String = ""):Vector.<Object>
        {
           var result:Vector.<Object>  = new <Object>[];
            for each (var name:String in getNames(prefix, sNames))
			{
                result.push(getTexture(name)); 
			}
            sNames.length = NONE;
            return result;
        }
        
        /** Returns all texture names that start with a certain string, sorted alphabetically. */
        public function getNames(prefix:String = "", result:Vector.<String> = null):Vector.<String>
        {
            if (result == null) result = new <String>[];
            
            for (var name:String in mTextureInfos)
			{
                if (name.indexOf(prefix) == NONE)
				{
                    result.push(name);
				}
			}
            result.sort(Array.CASEINSENSITIVE);
            return result;
        }
        
        public function getRegion(name:String):Rectangle
        {
            var info:TextureInfo = mTextureInfos[name];
            return info ? info.region : null;
        }
		
        public function getFrame(name:String):Rectangle
        {
            var info:TextureInfo = mTextureInfos[name];
            return info ? info.frame : null;
        }
        
        public function getRotation(name:String):Boolean
        {
            var info:TextureInfo = mTextureInfos[name];
            return info ? info.rotated : false;
        }
		
        public function addRegion(name:String, region:Rectangle, frame:Rectangle = null, rotated:Boolean = false):void
        {
            mTextureInfos[name] = new TextureInfo(region, frame, rotated);
        }
        
        public function removeRegion(name:String):void
        {
            if (mTextureInfos[name]) delete mTextureInfos[name];
        }
        
        // utility methods
        private static function parseBool(value:String):Boolean
        {
            return value.toLowerCase() == "true";
        }
		//ends
    }
}

import flash.geom.Rectangle;

class TextureInfo
{
    public var region:Rectangle;
    public var frame:Rectangle;
    public var rotated:Boolean;
    
    public function TextureInfo(region:Rectangle, frame:Rectangle, rotated:Boolean)
    {
        this.region = region;
        this.frame = frame;
        this.rotated = rotated;       
    }
}