package org.web.sdk.display.form.lib 
{
	import flash.geom.Rectangle;
	import org.web.sdk.display.form.Texture;
	
	/**
	 * @author Mike email:542540443@qq.com
	 * 使用动态创建的方法
	 */
	public class ClassRender extends ResRender
	{
		//是否复用	
		private var _texture:Texture;
		
		public function ClassRender(resName:String, texture:Texture = null, $lock:Boolean = false) 
		{
			this._texture = texture;
			super(resName, $lock);
		}
		
		override public function createUpdate(data:Object):Texture
		{
			if (_texture == null) _texture = null;
			return _texture;
		}
		
		
		//ends
	}

}