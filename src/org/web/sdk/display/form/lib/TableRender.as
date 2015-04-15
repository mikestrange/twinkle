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
	 * 他不会因为域名而改变，因为他只是一个数据表，真正的资源在Vector和Class中
	 */
	public class TableRender extends ResRender
	{ 
		private var _texMap:Dictionary;
		private var _isshare:Boolean;
		
		public function TableRender(resName:String, share:Boolean = false) 
		{
			_isshare = share;
			super(resName, false);
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
			if (null == data || data.getFile() == null) return;
			const file:String = data.getFile();
			//名称已经被改变
			var res:ResRender = asset.getResource(file);
			//不存在的时候自己创建
			if (res == null) res = createRender(file, data);
			//资源重载
			if (res) {
				//资源保存的话，那么就不频繁new
				if (_isshare) addRender(file, res);
				//资源渲染
				res.setPowerfulRender(render, data);
			}
		}
		
		//数据表中自己建立容器
		protected function createRender(name:String, data:AttainMethod):ResRender
		{
			switch(data.getType())
			{
				case RayType.CLASS: 	return new ClassRender(name);
				case RayType.LIST: 		return new VectorRender(name);
				case RayType.MAP: 		return new TableRender(name);
			}
			return null;
		}
		
		//ends
	}

}