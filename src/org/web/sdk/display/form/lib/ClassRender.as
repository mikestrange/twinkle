package org.web.sdk.display.form.lib 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.form.AttainMethod;
	import org.web.sdk.display.form.interfaces.IRender;
	import org.web.sdk.display.form.rule.RuleFactory;
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
		
		override public function setPowerfulRender(render:IRender, data:AttainMethod = null):void 
		{
			if (_texture == null) _texture = RuleFactory.getTexture(getResName());
			if (data) data.actionHandler(_texture);
			render.setTexture(_texture);
		}
		//ends
	}

}