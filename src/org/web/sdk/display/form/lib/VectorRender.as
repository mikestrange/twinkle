package org.web.sdk.display.form.lib 
{
	import org.web.sdk.display.form.AttainMethod;
	import org.web.sdk.display.form.interfaces.IRender;
	import org.web.sdk.display.form.rule.RuleFactory;
	import org.web.sdk.display.form.Texture;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 绑定资源，增加其引用，防止其他地方释放
	 */
	public class VectorRender extends ResRender
	{
		private var _lists:Vector.<Texture>;
		
		public function VectorRender(resName:String, vector:Vector.<Texture> = null)
		{
			if (vector) _lists = vector;
			super(resName, false);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_lists) {
				while (_lists.length) {
					_lists.shift().dispose();
				}
				_lists = null;
			}
		}
		
		override public function setPowerfulRender(render:IRender, data:AttainMethod = null):void 
		{
			if (null == _lists) {
				_lists = render.supplyHandler(this) as Vector.<Texture>;
			}
			//传入材质链，不做渲染
			if (data) data.actionHandler(_lists);
		}
		
		//ends
	}

}