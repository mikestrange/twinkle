package  
{
	import com.greensock.TweenLite;
	import org.web.sdk.admin.WinManager;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.bar.BaseButton;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.core.text.TextEditor;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.interfaces.rest.IPanel;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public class TestPanel extends BaseSprite implements IPanel 
	{
		/* INTERFACE org.web.sdk.interfaces.rest.IPanel */
		public function onEnter(data:Object):void 
		{
			AppWork.director.getRoot().addChild(this);
			//
			var btn:BaseButton = new BaseButton("btn_b_down", "btn_b_keep", "btn_b_over", "btn_b_die");
			this.addDisplay(btn);
			btn.setAlign(AlignType.LEFT_CENTER);
			var text:TextEditor = TextEditor.quick("lable", null, 16, 0xffff00)
			btn.setTitle(text);
			//点击处理
			btn.clickHandler = function(event:Object):void
			{
				btn.setEnabled(false);
				this.setScale(.2, .2);
				this.moveTo(50, stage.stageHeight);
				TweenLite.to(this, 2, { x:100, y:200, scaleX:1, scaleY:1,onComplete:removeFromAdmin } );
			}
			//添加到显示
			
		}
		
		public function onExit(value:Boolean = true):void 
		{
			this.finality();
		}
		
		public function update(data:Object):void 
		{
			
		}
		
		final public function removeFromAdmin():void 
		{
			WinManager.exit("test", false);
		}
		//ends
	}

}