package org.web.sdk.fot.core 
{
	import flash.utils.Dictionary;
	import org.web.sdk.fot.core.Container;
	import org.web.sdk.fot.tracker.Tracker;
	
	/**
	 * 集成装置监听器
	 */
	public class CompositeListener extends SimpleListener 
	{
		private var _contHash:Dictionary;
		
		public function CompositeListener() 
		{
			_contHash = new Dictionary;
		}
		
		public function createContainer(name:String):Container
		{
			var container:Container = _contHash[name];
			if (container == null) new Container(getTracker());
			return container;
		}
		
		public function removeContainer(name:String):void
		{
			var container:Container = _contHash[name];
			if (container) {
				delete _contHash[name];
				container.clear();
			}
		}
		
		override public function clearWrapper():void 
		{
			for (var k:String in _contHash) removeContainer(k);
			_contHash = new Dictionary;
			super.clearWrapper();
		}
		
		//end
	}

}