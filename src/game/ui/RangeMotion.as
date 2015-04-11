package game.ui 
{
	import flash.display.BitmapData;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.asset.AssetFactory;
	import org.web.sdk.display.asset.BaseRender;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.core.RayMovieClip;
	
	public class RangeMotion extends RayMovieClip 
	{
		private var _type:int;
		private var _point:int;
		private var _order:String;			//动作指令
		private var _playtimes:uint;		//动作运行次数
		private var _end_order:String;		//当前结束执行
		private var _actionName:String;
		
		public function RangeMotion(type:int, $order:String, $point:int = 4)
		{
			_type = type;
			setLiberty("user:type_id_" + _type, { action:action, url:url } , RayDisplayer.MOTION_TAG);
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
			setAction(getFormt());						//设置动作
			this.position = 1;							//恢复到第一帧
			this.flush( { action:action, url:url } );	//设置自己的渲染部分
		}
		
		override protected function handlerFrame():void 
		{
			if (_playtimes > 0 && position == totals && --_playtimes <= 0) {
				_playtimes = 0;
				doAction(_end_order, _point, 0);
			}
		}
		
		public function setAction(name:String):void
		{
			_actionName = name;
		}
		
		public function get action():String
		{
			return _actionName;
		}
		
		public function get defName():String
		{
			return null;
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