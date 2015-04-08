package org.web.sdk.fot.wrapper 
{
	import org.web.sdk.fot.interfaces.IRoutine;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public class TactVector 
	{
		private var _target:IRoutine;
		private var _link:Vector.<String>
		
		public function TactVector(target:IRoutine) 
		{
			this._target = target;
			
		}
		
		public function match(value:IRoutine):Boolean
		{
			return _target == value;
		}
		
		public function getLinks():Vector.<String>
		{
			return _link;
		}
		
		public function setLinks(value:Vector.<String>):void
		{
			_link = value;
		}
		
		//ends
	}

}