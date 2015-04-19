package org.web.sdk.display.game.ssh 
{
	import flash.utils.getTimer;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.paddy.build.SheetPeasants;
	import org.web.sdk.display.paddy.covert.FormatMethod;
	import org.web.sdk.display.paddy.covert.SmartRender;
	import org.web.sdk.display.paddy.covert.TexturePacker;
	import org.web.sdk.display.paddy.RayAnimation;
	import org.web.sdk.display.paddy.Texture;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.load.DownLoader;
	import org.web.sdk.load.LoadEvent;
	
	/**
	 * ...
	 * @author Main
	 * 远程资源效果
	 */
	public class LoadEffect extends RayAnimation 
	{
		private var _loader:DownLoader;
		private var _loadTime:int;
		private var _effName:String;
		
		public function LoadEffect(effName:String)
		{
			_effName = effName;
			this.setAlignOffset(0, 0, AlignType.CENTER_BOTTOM);
			load();
		}
		
		public function getUrl():String
		{
			return "http://127.0.0.1/game/asset/ui/skill/" + _effName+".swf";
		}
		
		protected function load():void
		{
			if (AppWork.appDomains.has(getUrl())) {
				startFrom();
			}else {
				_loader = new DownLoader(complete);
				_loadTime = getTimer();
				_loader.load(getUrl());
				_loader.start();
			}
		}
		
		private function complete(event:LoadEvent):void
		{
			if (event.isError) {
				this.removeFromFather(true);
			}else {
				event.shareDomain();
				startFrom(getTimer() - _loadTime);
			}
		}
		
		protected function startFrom(time:int = 0):void
		{
			this.setCompulsory("a%t", getUrl());
			play(Math.ceil(time / frameRate));
		}
		
		override protected function getNewRender(data:FormatMethod):SmartRender 
		{
			return new TexturePacker(data.resource, 
			SheetPeasants.fromList(data.format, data.namespaces));
		}
		
		override public function frameRender(float:int = 0):void 
		{
			if (currentFrame >= totals) {
				this.removeFromFather(true);
			}else {
				super.frameRender(float);
			}
		}
		
		override public function dispose():void 
		{
			if (_loader) {
				_loader.clean();
				_loader = null;
			}
			super.dispose();
		}
		
		override public function setTexture(texture:Texture):void 
		{
			super.setTexture(texture);
			this._updateAlign();
		}
		//ends
		//end
	}

}