package org.web.sdk.display.game.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.asset.BaseRender;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.AppWork;
	/*
	 * 一个非常快速的九宫格的
	 * */
	public class ScaleSprite 
	{
		//3种切割方式
		public static const NONE:int = 0;		//九宫格切割
		public static const ACROSS:int = 1;		//根据Y点上下切割
		public static const VERTICAL:int = 2;	//根据X点左右切割
		//拷贝
		private var resCopy:BitmapData;
		//布局位图
		private var rectVector:Vector.<ScaleRect>;
		//原始尺寸
		private var beginWide:int;	
		private var beginHeig:int;
		//当前尺寸
		private	var currWide:int = -1;
		private var currHeig:int = -1;
		//缩放范围
		private var rectScale:Rectangle;
		//切割类型
		private var cutType:int;
		
		public function setRes(bitdata:BitmapData):void
		{
			this.resCopy = bitdata;
			beginWide = resCopy.width;
			beginHeig = resCopy.height;
		}
		
		//直接根据一个点去设置
		public function setPoint(pox:int, poy:int, sizew:int = 0, sizeh:int = 0):void
		{
			rectScale = new Rectangle(pox, poy, 1, 1);
			cutScale();
			setSize(sizew, sizeh);
			dispose();
		}
		
		//根据x切割
		public function setPointX(pox:int, size:int):void
		{
			rectScale = new Rectangle(pox, 0, 1, beginHeig);
			cutHeig();
			updateVertical(size);
			dispose();
		}
		
		public function setPointY(poy:int, size:int):void
		{
			rectScale = new Rectangle(0, poy, beginWide, 1);
			cutWide();
			updateAcross(size);
			dispose();
		}
		
		private function cutScale():void
		{
			rectVector = new Vector.<ScaleRect>;
			rectVector.push(null);
			rectVector.push(new ScaleRect(resCopy, 0, 0, rectScale.x, rectScale.y));
			rectVector.push(new ScaleRect(resCopy, rectScale.x, 0, rectScale.width, rectScale.y));
			rectVector.push(new ScaleRect(resCopy, rectScale.x + rectScale.width, 0, beginWide-(rectScale.x + rectScale.width), rectScale.y));
			
			rectVector.push(new ScaleRect(resCopy, 0, rectScale.y, rectScale.x, rectScale.height));
			rectVector.push(new ScaleRect(resCopy, rectScale.x, rectScale.y, rectScale.width, rectScale.height));
			rectVector.push(new ScaleRect(resCopy, rectScale.x + rectScale.width, rectScale.y, beginWide-(rectScale.x + rectScale.width), rectScale.height));
			
			rectVector.push(new ScaleRect(resCopy, 0, rectScale.y + rectScale.height, rectScale.x, beginHeig - (rectScale.y + rectScale.height)));
			rectVector.push(new ScaleRect(resCopy, rectScale.x, rectScale.y + rectScale.height, rectScale.width, beginHeig - (rectScale.y + rectScale.height)));
			rectVector.push(new ScaleRect(resCopy, rectScale.x + rectScale.width, rectScale.y + rectScale.height, beginWide-(rectScale.x + rectScale.width), beginHeig - (rectScale.y + rectScale.height)));
		}
		
		private function cutWide():void
		{
			rectVector = new Vector.<ScaleRect>;
			rectVector.push(null);
			rectVector.push(new ScaleRect(resCopy, 0, 0, beginWide, rectScale.y));
			rectVector.push(new ScaleRect(resCopy, 0, rectScale.y, beginWide, rectScale.height));
			rectVector.push(new ScaleRect(resCopy, 0, rectScale.y + rectScale.height, beginWide,beginHeig-(rectScale.y + rectScale.height)));
		}
		
		private function cutHeig():void
		{
			rectVector = new Vector.<ScaleRect>;
			rectVector.push(null);
			rectVector.push(new ScaleRect(resCopy, 0, 0, rectScale.x, beginHeig));
			rectVector.push(new ScaleRect(resCopy, rectScale.x, 0, rectScale.width, beginHeig));
			rectVector.push(new ScaleRect(resCopy, rectScale.x + rectScale.width, 0, beginWide-(rectScale.x + rectScale.width), beginHeig));
		}
		
		private function updateAcross(size_h:int):void
		{
			this.currHeig = beginHeig > size_h ? beginHeig : size_h;
			this.currWide = beginWide;
			var ch:int = currHeig - (beginHeig - rectScale.height);
			rectVector[2].height = ch;
			rectVector[3].y = rectScale.y + ch;
		}
		
		private function updateVertical(size_w:int):void
		{
			this.currWide = beginWide > size_w ? beginWide : size_w;
			this.currHeig = beginHeig;
			var cw:int = currWide - (beginWide - rectScale.width);
			rectVector[2].width = cw;
			rectVector[3].x = rectScale.x + cw;
		}
		
		//直接设置尺寸 每次只需要调整周边的位置
		private function setSize(size_w:int, size_h:int):void
		{
			this.currWide = beginWide > size_w ? beginWide : size_w;
			this.currHeig = beginHeig > size_h ? beginHeig : size_h;
			updateScale();
		}
		
		private function updateScale():void
		{
			var cw:int = currWide - (beginWide - rectScale.width);
			rectVector[2].width = rectVector[5].width = rectVector[8].width = cw;
			rectVector[3].x = rectVector[6].x = rectVector[9].x = rectScale.x + cw;
			//
			var ch:int = currHeig - (beginHeig - rectScale.height);
			rectVector[4].height = rectVector[5].height = rectVector[6].height = ch;
			rectVector[7].y = rectVector[8].y = rectVector[9].y = rectScale.y + ch;
		}
		
		//取结果,释放当前
		public function getResult(name:String = null):RayDisplayer
		{
			var bitdata:BitmapData = new BitmapData(currWide, currHeig, true, 0);
			bitdata.lock();
			for each(var scale:ScaleRect in rectVector) {
				if (scale) scale.draw(bitdata);
			}
			bitdata.unlock();
			//释放原图
			if (rectVector) {
				rectVector.shift();
				while (rectVector.length) {
					rectVector.shift().free();
				}
				rectVector = null;
			}
			return new RayDisplayer(new BaseRender(name, bitdata));
		}
		
		private function dispose():void
		{
			if (resCopy) {
				resCopy.dispose();
				resCopy = null;
			}
		}
		
		//全局
		private static var scale:ScaleSprite = new ScaleSprite;
		//创建单体材质的九宫格的几种方式 
		public static function byPointX(name:String, pox:int, pow:int):RayDisplayer
		{
			const libName:String = name + ":" + "pox_" + pox + "_pow_" + pow;
			if (LibRender.hasTexture(libName)) return new RayDisplayer(LibRender.getTexture(libName));
			scale.setRes(AppWork.getAsset(name) as BitmapData);
			scale.setPointX(pox, pow);
			return scale.getResult(libName);	
		}
		
		public static function byPointY(name:String, poy:int, poh:int):RayDisplayer
		{
			const libName:String = name + ":" + "poy_" + poy + "_poh_" + poh;
			if (LibRender.hasTexture(libName)) return new RayDisplayer(LibRender.getTexture(libName));
			scale.setRes(AppWork.getAsset(name) as BitmapData);
			scale.setPointY(poy, poh);
			return scale.getResult(libName);
		}
		
		public static function byPoint(name:String, pox:int, poy:int, pow:int, poh:int):RayDisplayer
		{
			const libName:String = name + ":pox_" + pox + "_poy_" + poy + "_pow_" + pow + "_poh_" + poh;
			if (LibRender.hasTexture(libName)) return new RayDisplayer(LibRender.getTexture(libName));
			scale.setRes(AppWork.getAsset(name) as BitmapData);
			scale.setPoint(pox, poy, pow, poh);
			return scale.getResult(libName);
		}
		
		public static function clear():void
		{
			
		}
		//end
	}
}

