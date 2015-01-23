package org.web.sdk.gpu 
{
	import flash.display.BitmapData;
	import org.web.sdk.gpu.VRayMap;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.SunEngine;
	import org.web.sdk.gpu.shader.*;
	import org.web.sdk.inters.IEscape;
	import org.web.sdk.beyond_challenge;
	
	use namespace beyond_challenge
	/**
	 * GPU渲染的基类
	 */
	public class GpuBase extends VRayMap implements IEscape
	{
		//渲染速度
		public static var RENDER_FPS:int = 4;
		
		beyond_challenge var _conductor:CryRenderer;
		
		//简化接口
		protected function setShader(code:String):void
		{
			setConductor(ShaderManager.gets().getConductor(code));
		}
		
		//能够改变自身的渲染
		final public function setConductor(value:CryRenderer):void
		{
			if (_conductor == value) return;	//重复的不改变
			if (value == null) throw Error("this TextureConductor is null:" + this);
			if (_conductor) {
				_conductor.unmark();	//取消之前的标记
				_conductor = null;
			}
			if (!value.isValid()) throw Error("无效材质：" + value);
			_conductor = value;
			_conductor.mark();
		}
		
		//子类不允许更改
		final public function getRenderer():CryRenderer
		{
			return _conductor;
		}
		
		//重新渲染的时候调用
		public function updateRender(code:String, data:*= undefined):void
		{
			
		}
		
		//通知渲染器
		final public function sendRender(type:String, data:Object = null):void
		{
			if (isValid()) getRenderer().render(type, this, data);
		}
		
		//材质是否有效
		final public function isValid():Boolean
		{
			if (_conductor == null) return false;
			return _conductor.isValid();
		}
		
		//释放元素
		override public function dispose():void 
		{
			removeFromFather();
			if (_conductor) {
				_conductor.unmark();
				_conductor = null;
			}
		}
		//ends
	}
}