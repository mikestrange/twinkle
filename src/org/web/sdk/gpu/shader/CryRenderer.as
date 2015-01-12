package org.web.sdk.gpu.shader 
{
	import flash.display.BitmapData;
	import org.web.sdk.inters.IEscape;
	/**
	 *一个资源管理的集合
	 */
	public class CryRenderer 
	{
		protected var _code:String;
		protected var _isvalid:Boolean;
		protected var _count:int = 0;
		
		//创建就立刻标记
		public function CryRenderer(code:String)
		{
			_code = code;
			_isvalid = true;
			initialization(ShaderManager.gets().share(this));	//建立后就能再资源库中找到
		}
		
		protected function initialization(value:Boolean):void
		{
			
		}
		
		//子类继承他就可以了
		public function render(type:String, display:IEscape, data:Object = null):void
		{
			/* //test
			 * if (_isvalid) action.updateRender(this.code, data);
			 * else action.updateRender(null);
			*/
		}
		
		//标记 记入内存
		public function mark():void
		{
			_count++;
		}
		
		//取消一个标记
		public function unmark():void
		{
			_count--;
			if (_count <= 0) {
				ShaderManager.gets().remove(this);
				free();
			}
		}
		
		public function isValid():Boolean
		{
			return _isvalid;
		}
		
		public function getCode():String
		{
			return _code;
		}
		
		public function free():void
		{
			_count = 0;
			_isvalid = false;
		}
		
		//ends
	}

}


