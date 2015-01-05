package org.web.sdk.display.core 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.inters.ISprite;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.utils.NameUtil;
	
	/*所有精灵的基础类,不必继承原来的Sprite*/
	public class BoneSprite extends Sprite implements ISprite
	{	
		//自身没有被初始化
		protected var nobody:Boolean = true;
		protected var backAlpha:Number = 1;
		
		public function initialization():void
		{
			nobody = false;
		}
		
		protected function showEvent(e:Object = null):void
		{
			
		}
		
		protected function hideEvent(e:Object = null):void
		{
			
		}
		
		public function getName():String
		{
			return this.name; 
		}
		
		//是否被添加，不一定是到舞台
		public function isshow():Boolean
		{
			return this.parent != null; 	
		}
		
		//自身显示
		public function show():void
		{
			
		}
		
		//移除
		public function hide():void
		{
			if (this.isshow()) this.parent.removeChild(this);
		}
		
		//置顶或者最顶层
		public function setDisplayLayer(any:*, index:int = -1):void
		{
			if (this.numChildren < 1) return;
			if (index == -1 || index >= this.numChildren) index = this.numChildren - 1;
			if (any is String) {
				super.setChildIndex(getChildByName(String(any)), index);
			}else if (any is DisplayObject) {
				super.setChildIndex(any as DisplayObject, index);
			}
		}
		
		//移除带名称的
		public function removeChildByName(disName:String):DisplayObject
        {
            var dis:DisplayObject = super.getChildByName(disName);
            if (dis) removeChild(dis);
			return dis;
        }
		
		//添加带名称的元素，已经添加的没问题
		public function addChildDoName(dis:DisplayObject, disName:String = null, floor:int = -1):DisplayObject
		{
			if (disName != null) {
				if (getChildByName(disName) == dis) throw Error('命名重复->' + disName);
				dis.name = disName;
			}
			if (this.numChildren < 1 || floor <= 0||floor >= this.numChildren) return this.addChild(dis);
			//
			return this.addChildAt(dis, floor);
		}
		
		//移动至
		public function moveTo(mx:Number = 0, my:Number = 0):void
		{
			this.x = mx;
			this.y = my;
		}
		
		public function moveToPoint(value:Point):void
		{
			this.x = value.x;
			this.y = value.y;
		}
		
		//跟随
		public function follow(dis:DisplayObject, ofx:Number = 0, ofy:Number = 0, global:Boolean = false):void
		{
			if (global) {
				moveToPoint(dis.localToGlobal(new Point(ofx, ofy)));
			}else {
				moveTo(dis.x + ofx, dis.y + ofy);
			}
		}
		
		//完美释放  一般调用这个接口就够了
		public function finality(value:Boolean = true):void
		{
			clearDraw();
			Multiple.wipeout(this, value);
		}
		
		//自身释放，不需父容器调用 , 自身释放过了就不再释放了
		public function dispose():void
		{
			nobody = true;
			hide();
			finality();
		}
		
		//简单意义上面的限制
		public function lock():void
		{
			if(this.mouseChildren) this.mouseChildren = false;
		}
		
		//简单
		public function unlock():void
		{
			if(!this.mouseChildren) this.mouseChildren = true;
		}
		
		//设置大小缩放方式
		public function setNorms(horizontal:Number = 1, vertical:Number = 1, ratio:Boolean = true):void
		{
			if (ratio) {
				this.scaleX = horizontal;
				this.scaleY = vertical;
			}else {
				this.width = horizontal;
				this.height = vertical;
			}
		}
		
		//清除绘制
		public function clearDraw():void
		{
			this.graphics.clear();
		} 
		
		//是否存在名称的元素
		public function isByName(name:String):Boolean
		{
			return getChildByName(name) != null;
		}
		
		//直接绘制背景
		public function drawBack(mx:Number = 0, my:Number = 0, across:Number = 0, vertical:Number = 0, color:uint = 0):void
		{
			if (across == 0) across = this.width;
			if (vertical == 0) vertical = this.height;
			this.graphics.clear();
			this.graphics.beginFill(color, backAlpha);
			this.graphics.drawRect(mx, my, across, vertical);
			this.graphics.endFill();
		}
		
		public function render():void
		{
			
		}
		
		//打印信息
		override public function toString():String 
		{
			return "[" + NameUtil.getClassName(this) + "] info={name:" + this.name+',child:' + numChildren + "}";
		}
		
		//ends
	}

}