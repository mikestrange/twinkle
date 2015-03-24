package org.web.sdk.display.core.scale 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.web.sdk.display.core.ActiveSprite;
	/*
	 * 一个非常快速的九宫格的
	 * */
	public class ScaleSprite extends ActiveSprite 
	{
		//3种切割方式
		public static const NONE:int = 0;		//九宫格切割
		public static const ACROSS:int = 1;		//根据Y点上下切割
		public static const VERTICAL:int = 2;	//根据X点左右切割
		//
		private var resCopy:BitmapData;
		//原始尺寸
		private var wide:int;	
		private var heig:int;
		//9个位图以及每个区域的位置
		private var bitVector:Vector.<Bitmap>;
		private var rectVector:Vector.<Rectangle>;
		//当前尺寸
		private	var currWide:int;
		private var currHeig:int;
		//缩放范围
		private var rectScale:Rectangle;
		private var cut_type:int;
		
		public function ScaleSprite(bit:BitmapData, rect:Rectangle = null, type:int = 0)
		{
			this.resCopy = bit;
			if (rect) setScale9Grid(rect, type);
			super();
		}
		
		//直接根据一个点去设置
		public function setPoint(mx:int = 0, my:int = 0, type:int = 0):void
		{
			this.setScale9Grid(new Rectangle(mx, my, 1, 1), type);
		}
		
		public function setScale9Grid(grid:Rectangle, type:int = 0):void
		{
			if (resCopy == null) return;
			cut_type = type;
			rectScale = grid;
			wide = resCopy.width;
			heig = resCopy.height;
			//
			switch(type)
			{
				case ACROSS:
					cutWide();
				break;
				case VERTICAL:
					cutHeig();
				break;
				default:
					cutScale();
				break
			}
			copyMap();
			//释放原图
			resCopy.dispose();
			resCopy = null;
			//-----设置默认
			setSize(wide, heig);
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
				this.addChild(bit);
			}
		}
		
		private function cutScale():void
		{
			rectVector = new Vector.<Rectangle>;
			rectVector.push(new Rectangle(0, 0, rectScale.x, rectScale.y));
			rectVector.push(new Rectangle(rectScale.x, 0, rectScale.width, rectScale.y));
			rectVector.push(new Rectangle(rectScale.x + rectScale.width, 0, wide-(rectScale.x + rectScale.width), rectScale.y));
			
			rectVector.push(new Rectangle(0, rectScale.y, rectScale.x, rectScale.height));
			rectVector.push(new Rectangle(rectScale.x, rectScale.y, rectScale.width, rectScale.height));
			rectVector.push(new Rectangle(rectScale.x + rectScale.width, rectScale.y, wide-(rectScale.x + rectScale.width), rectScale.height));
			
			rectVector.push(new Rectangle(0, rectScale.y + rectScale.height, rectScale.x, heig - (rectScale.y + rectScale.height)));
			rectVector.push(new Rectangle(rectScale.x, rectScale.y + rectScale.height, rectScale.width, heig - (rectScale.y + rectScale.height)));
			rectVector.push(new Rectangle(rectScale.x + rectScale.width, rectScale.y + rectScale.height, wide-(rectScale.x + rectScale.width), heig - (rectScale.y + rectScale.height)));
		}
		
		private function cutWide():void
		{
			rectVector = new Vector.<Rectangle>;
			rectVector.push(new Rectangle(0, 0, wide, rectScale.y));
			rectVector.push(new Rectangle(0, rectScale.y, wide, rectScale.height));
			rectVector.push(new Rectangle(0, rectScale.y + rectScale.height, wide,heig-(rectScale.y + rectScale.height)));
		}
		
		private function cutHeig():void
		{
			rectVector = new Vector.<Rectangle>;
			rectVector.push(new Rectangle(0, 0, rectScale.x, heig));
			rectVector.push(new Rectangle(rectScale.x, 0, rectScale.width, heig));
			rectVector.push(new Rectangle(rectScale.x + rectScale.width, 0, wide-(rectScale.x + rectScale.width), heig));
		}
		
		//直接设置尺寸 每次只需要调整周边的位置
		public function setSize(w:int, h:int):void
		{
			if (w == currWide && currHeig == h) return;
			this.currWide = wide > w ? wide : w;
			this.currHeig = heig > h ? heig : h;
			switch(cut_type)
			{
				case ACROSS:
					setSizeByWide();
				break;
				case VERTICAL:
					setSizeByHeig();
				break;
				default:
					setSizeByScale();
				break;
			}
			//for each(var b:Bitmap in bitVector) if(b) trace("->",b.x, b.y);
		}
		
		private function setSizeByWide():void
		{
			const offy:int = 1;
			this.currWide = wide;
			var ch:int = currHeig - (heig - rectScale.height);
			bitVector[2].height = ch;
			bitVector[3].y = (rectScale.y + ch) - offy;
		}
		
		private function setSizeByHeig():void
		{
			const offx:int = 1;
			this.currHeig = heig;
			var cw:int = currWide - (wide - rectScale.width);
			bitVector[2].width = cw;
			bitVector[3].x = (rectScale.x + cw) - offx;
		}
		
		private function setSizeByScale():void
		{
			const offx:int = 1;
			const offy:int = 1;
			var cw:int = currWide - (wide - rectScale.width);
			var ch:int = currHeig - (heig - rectScale.height);
			bitVector[2].width = bitVector[5].width = bitVector[8].width = cw;
			bitVector[4].height = bitVector[5].height = bitVector[6].height = ch;
			bitVector[3].x = bitVector[6].x = bitVector[9].x = (rectScale.x + cw) - offx;
			bitVector[7].y = bitVector[8].y = bitVector[9].y = (rectScale.y + ch) - offy;
		}
		
		//直接复制输出
		public function clone():ScaleSprite
		{
			var sprt:ScaleSprite = new ScaleSprite(null);
			sprt.wide = this.wide;	
			sprt.heig = this.heig;
			sprt.cut_type = this.cut_type;
			sprt.rectVector = this.rectVector;	
			sprt.rectScale = this.rectScale;
			sprt.bitVector = new Vector.<Bitmap>;
			sprt.bitVector.push(null);
			var s_bit:Bitmap;
			for (var i:int = 0; i < this.rectVector.length; i++) {
				s_bit = new Bitmap(bitVector[i + 1].bitmapData);
				s_bit.x = this.rectVector[i].x;
				s_bit.y = this.rectVector[i].y;
				sprt.bitVector.push(s_bit);
				sprt.addChild(s_bit);
			}
			setSize(this.wide, this.heig);
			return sprt;
		}
		
		//end
	}
}