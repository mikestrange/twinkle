package game.ui.eff 
{
	import game.ui.core.GreatTexture;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.Phoebus;
	import org.web.sdk.gpu.actions.ActionMovie;
	import org.web.sdk.gpu.actions.texture.ActionTexture;
	import org.web.sdk.gpu.core.CreateTexture;
	import org.web.sdk.gpu.core.TextureConductor;
	
	public class EffectAction extends GreatTexture implements IStepper 
	{
		public const actionName:String = "start_%s000";
		//
		private var _next:EffectAction;
		private var _remove:Boolean;
		
		public function EffectAction(type:String, point:int = 0, nexteff:EffectAction = null, remove:Boolean = false) 
		{
			super(type, point, actionName, null);
			_remove = remove;
			setNext(nexteff);
		}
		
		override public function restore():void 
		{
			super.restore();
			this.setAction(this.getAction());
		}
		
		public function setNext(nexteff:EffectAction):void
		{
			if (_next) _next.cut();
			_next = nexteff;
		}
		
		public function getNext():EffectAction
		{
			return _next;
		}
		
		/* INTERFACE org.web.sdk.display.engine.IStepper */
		public function run():void 
		{
			restore();
			Phoebus.run(this);
		}
		
		public function step(event:Object):void 
		{
			this.render();
		}
		
		//运行一次就删除
		override protected function doFrame(value:int):void 
		{
			if (value == 0) {
				if (_next) {
					_next.moveTo(this.x, this.y);
					_next.setMark(this.getMark());
					_next.run();
					if (parent) parent.addChild(_next);
					_next = null;
				}
				if(_remove) cut();
			}
		}
		
		public function cut(type:String = null):void 
		{
			Phoebus.cut(this);
			this.kill();
		}
		
		//替代了释放
		public function kill():void 
		{
			this.dispose();
		}
		//end
	}

}