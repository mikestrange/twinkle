package org.alg.map 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import org.alg.astar.Node;
	import org.alg.utils.MapPath;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.FrameWork;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	/*
	 * 背景地图，完美的封装了
	 * */
	public class MapShallow extends Sprite
	{
		//单个地图大小
		public var titleWidth:int;
		public var titleHeight:int;
		//整块地图大小
		public var M_width:Number;
		public var M_height:Number;
		//节点长度
		public var wLeng:int;
		public var hLeng:int;
		//地图地址   这只是地图包路径
		public var mapId:uint;
		public var mapName:String;
		//所有节点
		private var _mapList:Array;
		//当前渲染部分
		private var _nowHash:Dictionary;
		//偏移缓冲区
		private const OFF_SET:int = 2;
		//开始下载地图
		public var openLoad:Boolean = false;
		
		//注册节点
		public function layout():void
		{
			_nowHash = new Dictionary;
			_mapList = new Array;
			for (var i:int = 0; i < hLeng; i++)
			{
				_mapList[i] = new Array;
				for (var j:int = 0; j < wLeng; j++)
				{
					_mapList[i][j] = new NodeTexture(mapId, j, i, titleWidth, titleHeight);
				}
			}
			draw();	//下载小地图
			FrameWork.downLoad(MapPath.getMapSmall(mapId), LoadEvent.IMG, complete);
		}
		
		private function complete(e:LoadEvent):void
		{
			var bitmapdata:BitmapData = null;
			if (e.eventType == LoadEvent.COMPLETE) bitmapdata = e.target as BitmapData;
			draw(bitmapdata);
			//模糊地图下载完成
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function draw(bit:BitmapData = null):void
		{
			this.graphics.clear();
			if (bit) {
				var matrix:Matrix = new Matrix();
				matrix.scale(M_width / bit.width, M_height / bit.height);
				this.graphics.beginFill(0);
				this.graphics.beginBitmapFill(bit, matrix);
				this.graphics.drawRect(0, 0, M_width, M_height);
				this.graphics.endFill();
			}else {
				this.graphics.beginFill(0xcccccc);
				this.graphics.drawRect(0, 0, M_width, M_height);
				this.graphics.endFill();
			}
		}
		
		//设置位置 目测是 bg相反值
		public function setLocation(x:Number = 0, y:Number = 0):void
		{
			if (!openLoad) return;
			var _present_x:Number = x;
			var _present_y:Number = y;
			launch(-x, -y);
		}
		
		//启动
		private function launch(x:Number,y:Number):void
		{
			//计算中心偏移
			var offsetx:int = Math.ceil((FrameWork.winWidth / titleWidth) >> 1) +OFF_SET;
			var offsety:int = Math.ceil((FrameWork.winHeight / titleHeight) >> 1) +OFF_SET;
			//计算中心点
			var dx:int = Math.ceil((x + (FrameWork.winWidth / OFF_SET)) / titleWidth);
			var dy:int = Math.ceil((y + (FrameWork.winHeight / OFF_SET)) / titleHeight);
			//trace("偏移：",offsetx, offsety, dx, dy);
			//分析前后需要的块数
			var startX:int = Math.max(0, dx - offsetx);
			var endX:int = Math.min(_mapList[0].length, dx + offsetx);
			var startY:int = Math.max(0, dy - offsety);
			var endY:int = Math.min(_mapList.length, dy + offsety);
			//trace("航行记录  "+startX,endX,startY,endY);
			//检测
			for (var i:int = startY; i < endY; i++)
			{
				for (var j:int = startX; j < endX; j++)
				{
					var node:NodeTexture = getNode(i, j);
					if(node){
						addNode(node);
						node.startLoad();
					}
				}
			}
			PerfectLoader.gets().start();
			//渲染位图
			refresh();
		}
		
		private function refresh():void
		{
			var node:NodeTexture;
			for(var url:* in _nowHash)
			{
				node = _nowHash[url];
				if(node.isOpen)
				{
					node.show(this);
				}else{
					removeNode(node);
				}
				node.isOpen = false;
			}
		}
		
		//添加到将被显示的列表
		private function addNode(node:NodeTexture):void
		{
			node.isOpen = true;
			if(hasNode(node)) return;
			_nowHash[node.url]=node;	
		}
		
		//显示列表移除
		private function removeNode(node:NodeTexture):void
		{
			if(hasNode(node)){
				_nowHash[node.url] = null;
				delete _nowHash[node.url];
				node.hide();
				node.isOpen = false;
			}
		}
		
		private function hasNode(node:NodeTexture):Boolean
		{
			return undefined != _nowHash[node.url];
		}
		
		//取分块
		protected function getNode(x:int = 0, y:int = 0):NodeTexture
		{
			return _mapList[x][y];
		}
		
		//释放地图
		public function dispose():void 
		{
			if (_nowHash) {
				for (var url:* in _nowHash) delete _nowHash[url];
				_nowHash = null;
			}
			
			if (_mapList) {
				//
				var node:NodeTexture;
				var list:Array;
				while (_mapList.length)
				{
					list = _mapList.shift() as Array;
					while (list.length) {
						node = list.shift() as NodeTexture;
						node.free();
					}
				}
				_mapList = null;
			}
			while (this.numChildren) this.removeChildAt(0);
		}
		
		//ends
	}
}