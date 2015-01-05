package org.web.sdk.gpu.core 
{
	import flash.display.BitmapData;
	import org.web.sdk.gpu.interfaces.IMplantation;
	/**
	 *纹理管理,单个管理，链表管理，哈希管理
	 * 纹理积累
	 */
	public class TextureConductor 
	{
		protected var _type:String;
		protected var _isvalid:Boolean = true;
		
		//创建就立刻标记
		public function TextureConductor(type:String) 
		{
			_type = type;
			initialization(TextureSystem.gets().share(this));
		}
		
		protected function initialization(value:Boolean):void
		{
			
		}
		
		//var  至于内部怎么渲染，那是内部的事情,对一个进行渲染,动态渲染
		public function render(action:IMplantation, mark:String = null):void
		{
			if (_isvalid) action.adaptFor(mark, this);
		}
		
		//标记 记入内存
		public function mark():void
		{
			TextureSystem.gets().add(this);
		}
		
		//取消一个标记
		public function unmark():void
		{
			TextureSystem.gets().remove(this);
		}
		
		//是否有效
		public function isValid():Boolean
		{
			return _isvalid;
		}
		
		public function getType():String
		{
			return _type;
		}
		
		public function free():void
		{
			_isvalid = false;
		}
		
		//ends
	}

}


