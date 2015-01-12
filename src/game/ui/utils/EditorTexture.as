package game.ui.utils 
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import org.web.sdk.display.TextEditor;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.gpu.texture.VRayTexture;
	
	public class EditorTexture 
	{
		private static var text:TextEditor = new TextEditor; 
		
		public static function draw(name:String, color:uint = 0xff0000, font:String = "大宋"):VRayTexture
		{
			text.empty();
			text.filters = [new GlowFilter(0, 1, 2, 2, 5, 2)];
			text.addText(name, false, color, -1, font);
			return new VRayTexture(Multiple.draw(text));
		}
		
		//ends
	}

}