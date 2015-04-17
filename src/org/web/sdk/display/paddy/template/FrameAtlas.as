package org.web.sdk.display.paddy.template 
{
	import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
	/*
	 * 这里只获取一个动作的行为偏移法则
	 * */
    public class FrameAtlas
    {
		//截取之后是否释放原材质，释放吧
		private static const NONE:int = 0;
        private static var bufferNames:Vector.<String> = new <String>[];
        
		//-----因为1个xml对应一个动画组合
		private var frameInfo:Dictionary;
		//获取swf名称，直接去下载
		private var titleName:String = "";	
		
        public function FrameAtlas(atlasXml:XML = null)
        {
            frameInfo = new Dictionary();
            if (atlasXml) parseAtlasXml(atlasXml);
        }
        
		//因为以后的每一帧都是相对于第一帧的偏移
		//应该把元件放到x>0,y>0的位置，然后取绝对值或者负数就得到了帧位置
        protected function parseAtlasXml(atlasXml:XML):void
        {
            const scale:Number = 1;
            //解析straling xml文件
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
                //裁剪范围
                const region:Rectangle = new Rectangle(x, y, width, height);
				//帧位置
				var frame:Rectangle = null;
				if (!isNaN(frameWidth) && frameWidth > NONE && !isNaN(frameHeight) && frameHeight > NONE)
				{
					frame = new Rectangle(frameX, frameY, frameWidth, frameHeight);
				}
				//保存帧信息
				if (!isNaN(frameX) && !isNaN(frameY)) frameInfo[name] = new Point(frameX, frameY);
            }
        }
        
        //取一个信息
        public function getInfo(name:String):Point
        {
            return frameInfo[name];
        }
        
		//取一个资源信息集合
        public function getInfos(prefix:String = ""):Vector.<Point>
        {
           var result:Vector.<Point>  = new <Point>[];
            for each (var name:String in getNames(prefix, bufferNames))
			{
                result.push(getInfo(name)); 
			}
            bufferNames.length = NONE;
            return result;
        }
        
        public function getNames(prefix:String = "", result:Vector.<String> = null):Vector.<String>
        {
            if (result == null) result = new <String>[];
            //
            for (var name:String in frameInfo)
			{
                if (name.indexOf(prefix) == NONE)
				{
                    result.push(name);
				}
			}
            result.sort(Array.CASEINSENSITIVE);
            return result;
        }
        
        // utility methods
        private static function parseBool(value:String):Boolean
        {
            return value.toLowerCase() == "true";
        }
		
		//ends
    }
}

