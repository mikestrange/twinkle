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
		//是否复用，出现域名的时候，我们会改变当前名称	
		private var _texture:Texture;
		
		public function ClassRender(resName:String, texture:Texture = null) 
		{
			this._texture = texture;
			super(resName, false);
		}
		
		override public function setPowerfulRender(render:IRender, data:AttainMethod = null):void 
		{
			//没有资源就去前台生成
			if (_texture == null) {
				_texture = render.supplyHandler(this) as Texture;
			}
			//生成后回传
			if (data) data.actionHandler(_texture);
			//---单材质，直接渲染
			render.setTexture(_texture);
		}
		//ends
	}

}