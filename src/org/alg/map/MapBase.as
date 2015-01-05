package org.alg.map 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import org.alg.utils.ConvertMesh;
	import org.alg.utils.DrawLine;
	import org.alg.utils.MapPath;
	import org.web.sdk.FrameWork;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	
	public class MapBase
	{
		//
		public static function showMap(id:uint, called:Function):void
		{
			FrameWork.downLoad(MapPath.getMapConfig(id), LoadEvent.TXT, "map+", complete, called);
		}
		
		private static function complete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) return;
			var called:Function = e.data as Function;
			if (called is Function) called(collocation(new XML(e.target as String)));
		}
		
		//一旦下载xml，那么地图就会自动被初始化
		public static function collocation(xml:XML):MeshMap
		{
			var shallow:MapShallow = new MapShallow();
			shallow.mapId = xml.mapdata[0].@mapId;
			shallow.mapName = xml.mapdata[0].@mapName;
			shallow.titleWidth = int(xml.mapdata[0].@tileWidth);
			shallow.titleHeight = int( xml.mapdata[0].@tileHeight);
			shallow.M_width = int( xml.mapdata[0].@mapWidth);
			shallow.M_height = int(xml.mapdata[0].@mapHeight);
			shallow.wLeng = Math.ceil(shallow.M_width / shallow.titleWidth);
			shallow.hLeng = Math.ceil(shallow.M_height / shallow.titleHeight);
			shallow.layout();
			//fileUrl:String=xml.mapdata[0].@file; 
			var across:int = int(xml.grid[0].@across);
			var vertical:int = int(xml.grid[0].@vertical);
			var sizeWidth:int = int(xml.grid[0].@nodeWidth);
			var sizeHeight:int = int(xml.grid[0].@nodeHeight);
			var mapArr:Array = String(xml.grid[0].@markData).split(",");
			//构建网格地表
			var gridmap:MeshMap = new MeshMap(ConvertMesh.onlyLong(mapArr, across, vertical, sizeWidth, sizeHeight));
			//初始化分块
			gridmap.setDesktop(shallow);
			return gridmap;
		}	
		
		//ends
	}

}