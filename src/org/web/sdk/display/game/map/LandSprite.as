package org.web.sdk.display.game.map 
{
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.form.core.Image;
	import org.web.sdk.load.DownLoader;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.display.core.BaseSprite;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 地图容器
	 */
	public class LandSprite extends BaseSprite 
	{
		//地图ID和地图名称
		public var mapId:uint;
		public var mapName:String;
		//块尺寸
		public var titleWidth:int;
		public var titleHeight:int;
		//整块地图大小
		public var M_width:Number;
		public var M_height:Number;
		//节点长度
		public var wLeng:int;
		public var hLeng:int;
		//小地图
		public var smallUrl:String;
		//所有节点
		private var _mapList:Array;
		//当前渲染部分
		private var _nowHash:Dictionary;
		//偏移缓冲区
		private const OFF_SET:int = 2;
		//打开地图下载
		public var openLoad:Boolean = false;
		//缩略地图，也可以是小地图
		private var _smallMap:Image;
		//地图的层
		private var _mapRoot:BaseSprite;
		
		public function LandSprite(data:MapDatum = null) 
		{
			this.addDisplay(_mapRoot = new BaseSprite);
			if (data) layout(data);
		}
		
		//注册节点
		public function layout(data:MapDatum):void
		{
			this.mapId = data.mapId;
			this.mapName = data.mapName;
			this.M_width = data.M_width;
			this.M_height = data.M_height;
			this.wLeng = data.wLeng;
			this.hLeng = data.hLeng;
			this.titleWidth = data.titleWidth;
			this.titleHeight = data.titleHeight;
			this.smallUrl = data.smallUrl;
			//初始化缓冲
			_nowHash = new Dictionary;
			_mapList = new Array;
			for (var i:int = 0; i < hLeng; i++)
			{
				_mapList[i] = new Array;
				for (var j:int = 0; j < wLeng; j++)
				{
					_mapList[i][j] = new MapItem(mapId, j, i, titleWidth, titleHeight);
				}
			}
			//限制宽高
			setLimit(M_width, M_height);
			openLoad = true;
			//loadSmall();
		}
		
		public function loadSmall():void
		{
			if (_smallMap) {
				_smallMap.finality();
				_smallMap.removeFromFather();
			}
			_smallMap = new Image;
			_smallMap.setLimit(M_width, M_height);
			_smallMap.resource = smallUrl;
			this.addDisplay(_smallMap, 0);
		}
		
		//这里并不是移动地图
		public function setRenderPosition(posx:Number = 0, posy:Number = 0):void 
		{
			if (!openLoad) return;
			//计算中心偏移
			var offsetx:int = Math.ceil((AppWork.winWidth / titleWidth) >> 1) + OFF_SET;
			var offsety:int = Math.ceil((AppWork.winHeight / titleHeight) >> 1) + OFF_SET;
			//计算中心点
			var dx:int = Math.ceil((posx + (AppWork.winWidth / OFF_SET)) / titleWidth);
			var dy:int = Math.ceil((posy + (AppWork.winHeight / OFF_SET)) / titleHeight);
			//trace("偏移：",offsetx, offsety, dx, dy);
			//分析前后需要的块数
			var startX:int = Math.max(0, dx - offsetx);
			var endX:int = Math.min(_mapList[0].length, dx + offsetx);
			var startY:int = Math.max(0, dy - offsety);
			var endY:int = Math.min(_mapList.length, dy + offsety);
			//trace("航行记录  "+startX,endX,startY,endY);
			//检测
			var node:MapItem = null;
			for (var i:int = startY; i < endY; i++)
			{
				for (var j:int = startX; j < endX; j++)
				{
					node = getNode(i, j);
					if(node){
						addNode(node);
						node.startLoad();	//下载失败后继续下载
					}
				}
			}
			//渲染位图
			refresh();
		}
		
		//显示该显示的，移除不显示的
		private function refresh():void
		{
			//渲染之后立刻关闭
			for each(var node:MapItem in _nowHash)
			{
				if (!node.isOpen) removeNode(node);
				//关闭
				node.isOpen = false;
			}
		}
		
		//添加到将被显示的列表
		private function addNode(node:MapItem):void
		{
			node.isOpen = true;
			if(hasNode(node)) return;
			_nowHash[node.url] = node;
			node.setParent(_mapRoot);
		}
		
		//显示列表移除
		private function removeNode(node:MapItem):void
		{
			if (hasNode(node))
			{
				_nowHash[node.url] = null;
				delete _nowHash[node.url];
				node.setParent(null);
				node.isOpen = false;
			}
		}
		
		private function hasNode(node:MapItem):Boolean
		{
			return undefined != _nowHash[node.url];
		}
		
		//取分块
		protected function getNode(x:int = 0, y:int = 0):MapItem
		{
			return _mapList[x][y];
		}
		
		//释放地图，需要手动调用
		private function dispose():void 
		{
			_nowHash = null;
			if (_mapList) {
				//
				var node:MapItem;
				var list:Array;
				while (_mapList.length)
				{
					list = _mapList.shift() as Array;
					while (list.length) {
						node = list.shift() as MapItem;
						node.free();
					}
				}
				_mapList = null;
			}
		}
		
		override public function finality(value:Boolean = true):void 
		{
			this.dispose();
			super.finality(value);
		}
		
		override protected function hideEvent():void 
		{
			super.hideEvent();
			this.finality();
		}
		//ends
	}
}