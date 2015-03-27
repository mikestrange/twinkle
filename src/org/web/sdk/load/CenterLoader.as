/** 
 *org.web.sdk.load542540443@qq.com 
 *@version 1.0.0 
 * 创建时间：2013-12-5 下午11:46:04 
 **/ 
package org.web.sdk.load 
{
	import org.web.sdk.load.inters.ILoadController;
	import org.web.sdk.load.inters.ILoader;
	import org.web.sdk.load.inters.ILoadRespond;
	import org.web.sdk.load.loads.*;
	import org.web.sdk.log.Log;
	import org.web.sdk.utils.HashMap;
	import org.web.sdk.utils.list.HashList;
	/*
	 * 下载管理,完美的下载管理器
	 * */
	
	public class CenterLoader implements ILoadController 
	{
		//下载列表 下载列表比较少，所以用数组，查询也很快
		protected var load_list:Vector.<LoadFluider> = new Vector.<LoadFluider>;
		//等待列表
		protected var wait_list:HashList = new HashList;
		//最大下载  公开
		public var LOAD_MAX:int = 4;
		//不是下载
		private static const NONE:int = 0;
		
		public function CenterLoader() 
		{
			SetupLoad.setDefault();
		}
			
		/*
		 * 建立一个下载 vital=true表示当前所有下载完成后会下载此,重要的立刻为他腾出一个空间，否则添加到最开始
		 * */
		public function addWait(url:String, context:*= undefined, vital:Boolean = false):ILoadRespond
		{
			//如果在下载中，直接跳出来
			var index:int = indexOfLoad(url);
			if (index != -1) return load_list[index];
			//在等待列表
			if (wait_list.hasNode(url)) return getWaiter(url);
			//添加到等待列表
			var filder:LoadFluider = new LoadFluider(this, url, SetupLoad.getType(url), context);
			if (vital) {
				wait_list.unshift(url, filder);
			}else {
				wait_list.push(url, filder);
			}
			return filder;
		}
		
		//取等待下载
		protected function getWaiter(url:String):LoadFluider
		{
			return wait_list.getValue(url) as LoadFluider;
		}
		
		internal function removeLoad(url:String):void
		{
			var index:int = indexOfLoad(url);
			if (index != -1) load_list.splice(index, 1);
		}
		
		/*
		 * 没有等待的下载列表
		 * */
		public function isEmpty():Boolean
		{
			return wait_list.empty();
		}
		
		/*
		 * 是否存在下载
		 * */
		public function isLoad():Boolean
		{
			return load_list.length > NONE;
		}
		
		/*
		 * 是否在等待列表
		 * */
		public function isWait(url:String):Boolean
		{
			return wait_list.hasNode(url);
		}
		 
		/*
		 * 当前下载满了
		 * */
		public function isFull():Boolean 
		{
			return load_list.length >= LOAD_MAX;
		}
		
		/*
		 * 下载列表多少
		 * */
		public function loadLength():int
		{
			return load_list.length;
		}
		
		/*
		 * 等待下载列表多少
		 * */
		public function waitLength():int
		{
			return wait_list.size();
		}
		
		/*
		 * 判断是否下载中
		 * */
		public function isInLoad(url:String):Boolean
		{
			var index:int = indexOfLoad(url);
			return index != -1;
		}
		
		public function indexOfLoad(url:String):int
		{
			for (var i:int = load_list.length - 1; i >= 0; i--) {
				if (load_list[i].url == url) return i;
			}
			return -1;
		}
		
		//
		public function isInto(url:String):Boolean
		{
			return isInLoad(url) || isWait(url);
		}
		
		/*
		 * 启动下载
		 * */
		public function start():void
		{
			if (wait_list.empty()) return;
			if (isFull()) return;
			var filder:LoadFluider = wait_list.shift() as LoadFluider;
			if (filder.size == NONE) {
				filder.destroy();
			}else {
				//添加到下载列表中去 并且开始下载
				load_list.push(filder);
				filder.load(SetupLoad.createLoader(filder.type));
			}
			//多个开放
			start();
		}
		
		//直接移除
		public function remove(url:String, remove_load:Boolean = true):void
		{
			var filder:LoadFluider = wait_list.remove(url);
			if (filder) filder.destroy();
			if (remove_load) {
				var index:int = indexOfLoad(url);
				if (index != -1) {
					filder = load_list[index];
					load_list.splice(index, 1);
					filder.destroy();
					start();
				}
			}
		}
		
		/*
		 * 删除回调,删除关闭
		 * */
		public function removeRespond(url:String, called:Function = null, closeload:Boolean = true):void
		{
			if (url == null) throw Error('this url is null');
			var filder:LoadFluider = getWaiter(url);
			if (filder) {
				if (called == null || filder.removeRespond(called) == NONE) {
					Log.log(this).debug("#remove: url=" + url);
					wait_list.remove(url).destroy();
				}
			}
			if (closeload) {
				var index:int = indexOfLoad(url);
				if (index != -1) {
					filder = load_list[index];
					if (called == null || filder.removeRespond(called) == NONE) {
						Log.log(this).debug("#remove and close: url = " + url);
						load_list.splice(index, 1);
						filder.destroy();
						start();
					}
				}
			}
		}
		
		/*
		 * 停止当前所有下载，会把下载中的提到最开始,直接暂停所有并且保存就是
		 * */
		public function stop(share:Boolean = false):void
		{
			if (share) {
				while (load_list.length) stopShare(load_list.shift());
			}else {
				while (load_list.length) load_list.shift().destroy();
			}
			Log.log(this).debug('##stop loading ->share = ' + share);
		}
		
		
		protected function stopShare(filder:LoadFluider):void
		{
			//没有下载就不添加了
			if (filder.isLoad()) {
				filder.close();
				wait_list.push(filder.url, filder);	//添加到等待列表
			}
		}
		
		/*
		 * 清理所有等待
		 * */
		public function clear():void
		{
			while (!wait_list.empty()) {
				LoadFluider(wait_list.pop()).destroy();
			}
			Log.log(this).debug('##clear wait loads');
		}
		
		/*
		 * 释放所有
		 * */
		public function free():void
		{
			clear();
			stop(false);
		}
		
		public function toString():String
		{
			var chat:String = "=============== wait list->" + wait_list + "\n";
			chat += "----->load list->leng = " + load_list.length+"\n";
			for (var i:int = 0; i < load_list.length; i++) chat += "index:" + i + ", url:" + load_list[i].url + "\n";
			chat+="==================end==============="
			return chat;
		}
		
		//利用一个全局
		private static var _ins:CenterLoader;
		
		public static function gets():CenterLoader
		{
			if (_ins == null) _ins = new CenterLoader;
			return _ins;
		}
		//ends
	}

}


