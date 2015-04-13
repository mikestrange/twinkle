package org.web.sdk.display.form.lib 
{
	import flash.utils.Dictionary;
	import org.web.sdk.display.form.ActionMethod;
	import org.web.sdk.display.form.interfaces.IRender;
	import org.web.sdk.display.form.Texture;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 传入名称和动作,对应动作名或者动作列表都可以,
	 */
	public class MediaRender extends ResRender
	{ 
		private var _texMap:Dictionary;
		
		public function MediaRender(resName:String, $lock:Boolean = false) 
		{
			super(resName, $lock);
		}
		
		//如果多个动作中引用了,会存在问题
		public function addRender(key:String, res:ResRender):ResRender
		{
			if (null == _texMap) _texMap = new Dictionary;
			var prve:ResRender = _texMap[key];
			if (prve && prve != res) prve.relieve();
			if (res) {
				res.additional();
				_texMap[key] = res;
			}
			return res;
		}
		
		public function removeRender(key:String):ResRender
		{
			if (null == _texMap) return null;
			var prve:ResRender = _texMap[key];
			if (prve) {
				delete _texMap[key];
				prve.relieve();
			}
			return prve;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_texMap) {
				for each(var res:ResRender in _texMap)
				{
					res.relieve();
				}
				_texMap = null;
			}
		}
		
		//传过来的是动作名称和当前帧{action:run,frame:0}
		override public function setPowerfulRender(render:IRender, data:ActionMethod = null):void 
		{
			if (null == data) return;
			const name:String = data.getName();
			var res:ResRender = null;
			if (_texMap) res = _texMap.getValue(name);
			//不存在的时候自己创建
			if (res == null) {
				res = addRender(name, createAction(data));
			}
			//可以是单材质，也可以是动作链 
			if (res) {
				res.setPowerfulRender(render, data);
			}
		}
		
		//根据动作名称建立数据
		protected function createAction(action:ActionMethod):ResRender
		{
			return null;
		}
		
		//ends
	}

}