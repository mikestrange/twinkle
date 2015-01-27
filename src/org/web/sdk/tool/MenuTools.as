package org.web.sdk.tool 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	//import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class MenuTools 
	{
		private static var _version:String = "0.0.0";
		private static var _context:ContextMenu;
		
		public function MenuTools() 
		{
			throw Error("do not new this");
		}
		
		//版本号
		public static function get VERSION():String
		{
			return _version;
		}
		
		//设置主menu，设置版本号
		public static function setMenu(menu:DisplayObjectContainer, version:String = null, ...rest):void
		{
			if(null==_context) _context = new ContextMenu;
			_context.hideBuiltInItems();
			if (version) {
				_version = version;
				//添加版本号
				rest.unshift(createMenuItem("version: " + _version));
			}
			_context.customItems = rest;
			menu.contextMenu = _context;
		}
		
		public static function createMenuItem(caption:String, onclick:Function = null):ContextMenuItem
		{
			var menuItem:ContextMenuItem = new ContextMenuItem(caption);
			if (onclick is Function) {
				menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onclick, false, 0, true);
			}
			return menuItem;
		}
		//ends
	}

}