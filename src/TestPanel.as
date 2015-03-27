package  
{
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import org.web.sdk.display.core.ActiveSprite;
	import org.web.sdk.display.bar.BaseButton;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.bar.utils.ScaleSprite;
	import org.web.sdk.display.core.text.TextEditor;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.tool.Scale9Bitmap;
	
	public class TestPanel extends ActiveSprite
	{
		private var curret:BaseButton;
		
		override protected function showEvent():void 
		{
			//没被添加到舞台就释放不了
			//var dis:RayDisplayer = ScaleSprite.byPoint("panelBg1", 320, 140, 800, 400);
			//this.addDisplay(dis);
			//
			//var text:TextEditor = TextEditor.quick("HeroTie", this, 30, 0xffff00);
			//text.setAlign(AlignType.CENTER_TOP, 0, 20);
			//
			var btn:BaseButton
			for (var i:int = 0; i < 1; i++) {
				btn = new BaseButton("btn_b_down", "btn_b_keep", "btn_b_over", "btn_b_die");
				btn.setProvoke(onTouch)
				this.addDisplay(btn);
				btn.setAlign(AlignType.LEFT_CENTER, 10 + i * btn.width);
				var text:TextEditor = TextEditor.quick("测试按钮", null, 16, 0xffff00)
				btn.setTitle(text);
			}
			//
		}
		
		
		private function onTouch(but:Object):void
		{
			if (curret) curret.setEnabled(true);
			curret = but as BaseButton;
			curret.setEnabled(false);
			this.setScale(.2, .2);
			this.moveTo(50,stage.stageHeight)
			TweenLite.to(this,2,{x:100,y:200,scaleX:1,scaleY:1})
		}
		
		//end
	}

}