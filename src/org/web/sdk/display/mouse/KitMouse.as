package org.web.sdk.display.mouse 
{
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.interfaces.IAcceptor;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 保存鼠标的一切资源，包括动态
	 */
	public class KitMouse extends LibRender 
	{
		
		public function KitMouse() 
		{
			super("libMouse", true);
		}
		
		override public function update(data:Object):* 
		{
			return null;
		}
		
		//end
	}

}