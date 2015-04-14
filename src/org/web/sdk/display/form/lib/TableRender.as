package org.web.sdk.display.form.lib 
{
	import flash.utils.Dictionary;
	import org.web.sdk.display.form.AttainMethod;
	import org.web.sdk.display.form.interfaces.IRender;
	import org.web.sdk.display.form.Texture;
	import org.web.sdk.display.form.type.RayType;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 多媒体，可以动态建立也可以初始化的时候建立
	 */
	public class TableRender extends ResRender
	{ 
		private var _texMap:Dictionary;
		
		public function TableRender(resName:String, $lock:Boolean = false) 
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
		override public function setPowerfulRender(render:IRender, data:AttainMethod = null):void 
		{
			if (null == data) return;
			const name:String = data.getName();
			if (name == null) return;
			var res:ResRender = null;
			if (_texMap) res = _texMap[name];
			//不存在的时候自己创建
			if (res == null) {
				if (asset.hasRes(name)) {
					res = addRender(name, asset.getResource(name));
				}else {
					res = addRender(name, createAction(data));
				}
			}
			//不能调用render去渲染，那样会去问题
			if (res) res.setPowerfulRender(render, data);
		}
		
		//子类覆盖可以扩充不同的建立
		protected function createAction(action:AttainMethod):ResRender
		{
			const name:String = action.getName();
			switch(action.getType())
			{
				case RayType.CLASS:	return new ClassRender(name);
				case RayType.LIST:	return new VectorRender(name);
				case RayType.MAP:	return new TableRender(name);
			}
			return null;
		}
		
		//ends
	}

}