package org.web.sdk.display.core.scale 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.web.sdk.display.asset.SingleTexture;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.FrameWork;
	/*
	 * 一个非常快速的九宫格的
	 * */
	public class ScaleSprite 
	{
		//3种切割方式
		public static const NONE:int = 0;		//九宫格切割
		public static const ACROSS:int = 1;		//根据Y点上下切割
		public static const VERTICAL:int = 2;	//根据X点左右切割
		//
		private var resCopy:BitmapData;
		//原始尺寸
		private var beginWide:int;	
		private var beginHeig:int;
		//布局位图
		private var bitVector:Vector.<Bitmap>;
		private var rectVector:Vector.<Rectangle>;
		//当前尺寸
		private	var currWide:int = -1;
		private var currHeig:int = -1;
		//缩放范围
		private var rectScale:Rectangle;
		//切割类型
		private var cutType:int;
		
		//默认是九宫切割
		public function ScaleSprite(bit:BitmapData, rect:Rectangle = null, type:int = 0)
		{
			this.resCopy = bit;
			beginWide = resCopy.width;
			beginHeig = resCopy.height;
			if (rect) setScale9Grid(rect, type);
		}
		
		//直接根据一个点去设置
		public function setPoint(pox:int = 0, poy:int = 0, sizew:int = -1, sizeh:int = -1):void
		{
			this.setScale9Grid(new Rectangle(pox, poy, 1, 1), NONE);
			if (sizew > 0 && sizeh > 0) setSize(sizew, sizeh);
		}
		
		//根据x切割
		public function setPointX(value:int, size:int = -1):void
		{
			this.setScale9Grid(new Rectangle(value, 0, 1, beginHeig), VERTICAL);
			if (size > 0) setWidth(size);
		}
		
		public function setPointY(value:int, size:int = -1):void
		{
			this.setScale9Grid(new Rectangle(0, value, beginWide, 1), ACROSS);
			if (size > 0) setHeight(size);
		}
		
		//也可以自定义切割，一旦设置不允许更改切割方式
		public function setScale9Grid(grid:Rectangle, type:int = 0):void
		{
			if (resCopy == null) return;
			cutType = type;
			rectScale = grid;
			//
			switch(type)
			{
				case ACROSS: 	cutWide(); break;
				case VERTICAL: 	cutHeig(); break;
				default: cutScale(); break;
			}
			copyMap();
			//释放原图
			resCopy.dispose();
			resCopy = null;
			//-----设置默认
			setSize(beginWide, beginHeig);
		}
		
		private function copyMap():void
		{
			bitVector = new Vector.<Bitmap>;
			bitVector.push(null);
			var bitdata:BitmapData;
			var bit:Bitmap;
			const point:Point = new Point;
			for each(var rect:Rectangle in rectVector)
			{
				bitdata = new BitmapData(rect.width, rect.height, true, 0);
				bitdata.copyPixels(resCopy, rect, point);
				bit = new Bitmap(bitdata);
				bit.x = rect.x;
				bit.y = rect.y;
				bitVector.push(bit);
				//this.addChild(bit);
			}
		}
		
		private function cutScale():void
		{
			rectVector = new Vector.<Rectangle>;
			rectVector.push(new Rectangle(0, 0, rectScale.x, rectScale.y));
			rectVector.push(new Rectangle(rectScale.x, 0, rectScale.width, rectScale.y));
			rectVector.push(new Rectangle(rectScale.x + rectScale.width, 0, beginWide-(rectScale.x + rectScale.width), rectScale.y));
			
			rectVector.push(new Rectangle(0, rectScale.y, rectScale.x, rectScale.height));
			rectVector.push(new Rectangle(rectScale.x, rectScale.y, rectScale.width, rectScale.height));
			rectVector.push(new Rectangle(rectScale.x + rectScale.width, rectScale.y, beginWide-(rectScale.x + rectScale.width), rectScale.height));
			
			rectVector.push(new Rectangle(0, rectScale.y + rectScale.height, rectScale.x, beginHeig - (rectScale.y + rectScale.height)));
			rectVector.push(new Rectangle(rectScale.x, rectScale.y + rectScale.height, rectScale.width, beginHeig - (rectScale.y + rectScale.height)));
			rectVector.push(new Rectangle(rectScale.x + rectScale.width, rectScale.y + rectScale.height, beginWide-(rectScale.x + rectScale.width), beginHeig - (rectScale.y + rectScale.height)));
		}
		
		private function cutWide():void
		{
			rectVector = new Vector.<Rectangle>;
			rectVector.push(new Rectangle(0, 0, beginWide, rectScale.y));
			rectVector.push(new Rectangle(0, rectScale.y, beginWide, rectScale.height));
			rectVector.push(new Rectangle(0, rectScale.y + rectScale.height, beginWide,beginHeig-(rectScale.y + rectScale.height)));
		}
		
		private function cutHeig():void
		{
			rectVector = new Vector.<Rectangle>;
			rectVector.push(new Rectangle(0, 0, rectScale.x, beginHeig));
			rectVector.push(new Rectangle(rectScale.x, 0, rectScale.width, beginHeig));
			rectVector.push(new Rectangle(rectScale.x + rectScale.width, 0, beginWide-(rectScale.x + rectScale.width), beginHeig));
		}
		
		private function updateAcross():void
		{
			const offy:int = 0;
			this.currWide = beginWide;
			var ch:int = currHeig - (beginHeig - rectScale.height);
			bitVector[2].height = ch;
			bitVector[3].y = (rectScale.y + ch) - offy;
		}
		
		private function updateVertical():void
		{
			const offx:int = 0;
			this.currHeig = beginHeig;
			var cw:int = currWide - (beginWide - rectScale.width);
			bitVector[2].width = cw;
			bitVector[3].x = (rectScale.x + cw) - offx;
		}
		
		private function updateScaleHeight():void
		{
			const offy:int = 0;
			var ch:int = currHeig - (beginHeig - rectScale.height);
			bitVector[4].height = bitVector[5].height = bitVector[6].height = ch;
			bitVector[7].y = bitVector[8].y = bitVector[9].y = (rectScale.y + ch) - offy;
		}
		
		private function updateScaleWidth():void
		{
			const offx:int = 0;
			var cw:int = currWide - (beginWide - rectScale.width);
			bitVector[2].width = bitVector[5].width = bitVector[8].width = cw;
			bitVector[3].x = bitVector[6].x = bitVector[9].x = (rectScale.x + cw) - offx;
		}
		
		//直接设置尺寸 每次只需要调整周边的位置
		public function setSize(size_w:int, size_h:int):void
		{
			setWidth(size_w);
			setHeight(size_h);
		}
		
		//设置宽度
		public function setWidth(value:int):void
		{
			if (this.currWide == value) return;
			this.currWide = beginWide > value ? beginWide : value;
			switch(cutType)
			{
				case VERTICAL:
					updateVertical();
				break;
				case NONE:
					updateScaleWidth();
				break;
			}
		}
		
		//取结果,释放当前
		public function getResult():RayDisplayer
		{
			var bitdata:BitmapData = new BitmapData(currWide, currHeig, true, 0);
			bitdata.lock();
			for each(var bit:Bitmap in bitVector){
				if(bit){
					bitdata.copyPixels(bit.bitmapData, new Rectangle(0, 0, bit.width, bit.height), new Point(bit.x, bit.y));
				}	
			}
			bitdata.unlock();
			this.dispose();
			return new RayDisplayer(new SingleTexture(bitdata));
		}

		//释放所有拷贝的位图
		public function dispose():void
		{
			for each(var bit:Bitmap in bitVector){
				if(bit) bit.bitmapData.dispose();
			}
			bitVector = null;
			rectVector = null;
		}
		
		//设置高度
		public function setHeight(value:int):void
		{
			if (this.currHeig == value) return;
			this.currHeig = beginHeig > value ? beginHeig : value;
			switch(cutType)
			{
				case ACROSS:
					updateAcross();
				break;
				case NONE:
					updateScaleHeight();
				break;
			}
		}
		

		//返回九宫格
		public static function createByPointX(name:String, pox:int, width:int):RayDisplayer
		{
			var scale:ScaleSprite = new ScaleSprite(FrameWork.getAsset(name) as BitmapData)
			scale.setPointX(pox, width);
			return scale.getResult();	
		}

		public static function createByPointY(name:String, poy:int, height:int):RayDisplayer
		{
			var scale:ScaleSprite = new ScaleSprite(FrameWork.getAsset(name) as BitmapData)
			scale.setPointY(poy, height);
			return scale.getResult();
		}

		public static function createByPoint(name:String, rect:Rectangle):RayDisplayer
		{
			var scale:ScaleSprite = new ScaleSprite(FrameWork.getAsset(name) as BitmapData)
			scale.setPoint(rect.x, rect.y, rect.width, rect.height);
			return scale.getResult();
		}
		//end
	}
}