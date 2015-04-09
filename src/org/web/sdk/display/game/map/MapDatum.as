package org.web.sdk.display.game.map 
{
	import org.web.sdk.display.game.astar.Grid;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 地图的一些数据
	 */
	public class MapDatum 
	{
		//---------------map data-----------
		//地图地址   这只是地图包路径
		public var mapId:uint;
		public var mapName:String;
		//分小块地图的尺寸
		public var titleWidth:int;
		public var titleHeight:int;
		//整块地图大小
		public var M_width:Number;
		public var M_height:Number;
		//节点长度
		public var wLeng:int;
		public var hLeng:int;
		//----------------grid-------------
		//节点 横 竖
		public var across:int;
		public var vertical:int;
		//节点尺寸
		public var sizeWidth:int;
		public var sizeHeight:int;
		//节点
		public var mapArr:Array;
		//网格
		public var grid:Grid;
		
		//通过解析xml
		public function analyze(xml:XML):void
		{
			this.mapId = xml.mapdata[0].@mapId;
			this.mapName = xml.mapdata[0].@mapName;
			this.titleWidth = int(xml.mapdata[0].@tileWidth);
			this.titleHeight = int( xml.mapdata[0].@tileHeight);
			this.M_width = int( xml.mapdata[0].@mapWidth);
			this.M_height = int(xml.mapdata[0].@mapHeight);
			this.wLeng = Math.ceil(this.M_width / this.titleWidth);
			this.hLeng = Math.ceil(this.M_height / this.titleHeight);
			//fileUrl:String=xml.mapdata[0].@file; 
			this.across = int(xml.grid[0].@across);
			this.vertical = int(xml.grid[0].@vertical);
			this.sizeWidth = int(xml.grid[0].@nodeWidth);
			this.sizeHeight = int(xml.grid[0].@nodeHeight);
			//可行节点
			this.mapArr = String(xml.grid[0].@markData).split(",");
			//
			grid = Grid.createByArray(mapArr, across, vertical, sizeWidth, sizeHeight);
		}
		
		//小地图路径
		public function get smallUrl():String
		{
			return MapPath.getMapSmall(mapId);
		}
		
		//全局
		private static var _ins:MapDatum;
		
		public static function create(xml:XML):MapDatum
		{
			if (null == _ins) _ins = new MapDatum;
			_ins.analyze(xml);
			return _ins;
		}
		
		//ends
	}

}