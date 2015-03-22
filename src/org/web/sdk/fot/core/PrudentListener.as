package org.web.sdk.fot.core 
{
	import org.web.sdk.fot.interfaces.IMixture;
	import org.web.sdk.fot.wrapper.MixtureWrapper;
	import org.web.sdk.fot.tracker.Tracker;
	/**
	 * 谨慎机制->需要自己手动释放
	 * [属于危险模式，不删除会泄露内存]
	 * 最高级，但是不是最智能的
	 */
	public class PrudentListener extends CompositeListener
	{
		
		public function addVent(vent:IMixture, ...parameter):void
		{
			if (!vent.isCumulative()) removeVent(vent);
			var v:Vector.<String> = vent.getLinks();
			if (parameter.length) {
				if (v == null) v = new Vector.<String>;
				var name:String = null;
				for (var i:int = 0; i < parameter.length; i++) {
					name = parameter[i];
					var index:int = v.indexOf(name);
					if (index == -1) {
						v.push(name);
						addWrapper(name, new MixtureWrapper(vent, name));
					}
				}
			}
			//每次注册都重新设置
			vent.setLinks(this, v);
		}
		
		public function removeVent(vent:IMixture):void
		{
			var v:Vector.<String> = vent.getLinks();
			if (v) {
				vent.setLinks(this, null);
				for (var i:int = 0; i < v.length; i++) {
					removeWrapper(v[i], vent);
				}
			}
		}
		//end
	}

}