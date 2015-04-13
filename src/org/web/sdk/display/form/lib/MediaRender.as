package org.web.sdk.display.form.lib 
{
	import flash.utils.Dictionary;
	import org.web.sdk.display.form.Texture;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 传入名称和动作,对应动作名或者动作列表都可以,
	 */
	public class MediaRender extends ResRender
	{ 
		private var _textureMap:Dictionary;
		
		public function MediaRender(resName:String, $lock:Boolean = false) 
		{
			super(resName, $lock);
		}
		
		//如果多个动作中引用了,会存在问题
		public function addRender(key:String, res:ResRender):ResRender
		{
			if (null == _textureMap) _textureMap = new Dictionary;
			var prve:ResRender = _textureMap[key];
			if (prve && prve != res) prve.unlock();
			if (res) {
				res.addHold();
				_textureMap[key] = res;
			}
			return res;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_textureMap) {
				for each(var res:ResRender in _textureMap)
				{
					res.shiftHold();
				}
				_textureMap = null;
			}
		}
		
		//传过来的是动作名称和当前帧{action:run,frame:0}
		override public function createUpdate(data:Object):Texture 
		{
			if (data == null) return null;
			const action:String = data.action;
			//var frame:int = data.frame;
			var res:ResRender = null;
			if(_textureMap) res = _textureMap.getValue(action)
			
			if (res == null) res = addRender(action, createAction(action));
			
			if(res) return res.setPowerfulRender(data.frame);
			return null;
		}
		
		//根据动作建立材质，列表或者单一材质
		protected function createAction(action:String):ResRender
		{
			return null;
		}
		
		//ends
	}

}