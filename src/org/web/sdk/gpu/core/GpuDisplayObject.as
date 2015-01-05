package org.web.sdk.gpu.core 
{
	import flash.display.BitmapData;
	import org.web.sdk.display.core.Texture;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.Phoebus;
	import org.web.sdk.gpu.core.TextureConductor;
	import org.web.sdk.gpu.interfaces.IMplantation;
	
	/**
	 * 支持所有纹理
	 * 如果有坐骑，那么可以添加一个内部渲染坐骑的BaseAction,
	 * 因为主角是主体，其他配件可以通过hash管理，同时渲染
	 */
	public class GpuDisplayObject extends Texture implements IMplantation
	{
		private var _conductor:TextureConductor;
		
		public function GpuDisplayObject() 
		{
			super(null);
		}
		
		//能够改变自身的渲染
		final public function setConductor(conductor:TextureConductor):void
		{
			if (_conductor == conductor) return;	//重复的不改变
			if (conductor == null) throw Error("this TextureConductor is null:" + this);
			if (_conductor) {
				_conductor.unmark();	//取消之前的标记
				_conductor = null;
			}
			if (!conductor.isValid()) throw Error("无效材质");
			_conductor = conductor;
			_conductor.mark();
		}
		
		final public function getTexure():TextureConductor
		{
			return _conductor;
		}
		
		//需要重新渲染的时候调用,这个一般是材质调用,这里可以判断某个材质是否下载完成,然后进行渲染
		public function adaptFor(mark:String, conductor:TextureConductor):void
		{
			
		}
		
		//材质是否有效
		public function isValid():Boolean
		{
			if (_conductor == null) return false;
			return _conductor.isValid();
		}
		
		//等于
		override public function dispose():void 
		{
			trace("释放")
			closed();
			if (_conductor) {
				_conductor.unmark();
				_conductor = null;
			}
		}
		
		public function render():void
		{
			
		}
		
		//ends
	}
}