package game.ui.core 
{
	import flash.display.BitmapData;
	import org.web.rpg.utils.MapPath;
	import org.web.sdk.display.asset.KitAction;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.asset.KitFactory;
	import org.web.sdk.display.asset.KitBitmap;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.core.base.ActionMovie;
	
	public class RangeMotion extends ActionMovie 
	{
		private var _point:int;
		private var _order:String;		//动作指令
		private var _playtimes:uint;	//动作运行次数
		private var _end_order:String;
		private var _type:int;
		
		public function RangeMotion(type:int, $order:String, $point:int = 4)
		{
			_type = type;
			setLiberty("user:type_id_" + _type, this, RayDisplayer.ACTION_TAG);
			doAction($order, $point);
			this.play();
		}
		
		public function get type():int
		{
			return _type;
		}
		
		//设置当前动作结束后的动作
		public function setEnder(order:String = null):void
		{
			_end_order = order;	//结束动作
		}
		
		//这个是动作
		public function getFormt():String
		{
			return _order.replace("%s", _point);
		}
		
		//最后是否强制跟新
		public function doAction(order:String, point:int, times:int = 0, forced:Boolean = false):void
		{
			_playtimes = times;
			if (order == null) order = _order;
			if (point == -1) point = _point;
			if (_order == order && _point == point && !forced) return;
			_order = order;
			_point = point;
			setAction(getFormt());				//设置动作
			this.position = 1;					//恢复到第一帧
			this.flush(this);	//设置自己的渲染部分
		}
		
		//没有动作就建立动作
		override public function createAction(action:String):Vector.<BitmapData> 
		{
			return KitFactory.fromVector(action + ".png", "%d", -1, url);
		}
		
		override public function frameRender(float:int = 0):void 
		{
			super.frameRender(float);
			if (_playtimes > 0 && position == totals && --_playtimes <= 0) {
				_playtimes = 0;
				doAction(_end_order, _point, 0);
			}
		}
		
		//可以动态下载
		protected function get url():String
		{
			return "http://127.0.0.1/game/asset/ui/001_player.swf";
		}
		
		public function get point():int
		{
			return _point;
		}
		
		public function get order():String
		{
			return _order;
		}
		
		//ends
	}

}