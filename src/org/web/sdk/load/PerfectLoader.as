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
	import org.web.apk.beyond_challenge;
	
	/*
	 * 下载管理,完美的下载管理器
	 * */
	use namespace beyond_challenge;
	
	public class PerfectLoader implements ILoadController 
	{
		//下载列表
		beyond_challenge var hashLoad:HashMap = new HashMap;
		//等待列表
		beyond_challenge var hashWait:HashMap = new HashMap;
		//等待的第一个下载地址
		beyond_challenge var firstUrl:String = null;
		//列表的最后一个下载
		beyond_challenge var lastUrl:String = null;
		//不是下载
		public static const NONE:int = 0;
		public static const HAVE:int = 1;
		public static const LOAD:int = 2;
		//最大下载  公开
		public var LOAD_MAX:int = 4;
		//下载蓝图列表,默认，可以更改
		beyond_challenge var LoaderBlueprint:Array = [];
		
		public function PerfectLoader()
		{
			this.initialization();
		}
		
		protected function initialization():void
		{
			setLoader(LoadEvent.TXT, TextLoader);
			setLoader(LoadEvent.SWF, ResourceLoader);
			setLoader(LoadEvent.IMG, ImgLoader);
			setLoader(LoadEvent.BYTE, ByteLoader);
		}
		
		//设置下载器
		public function setLoader(type:int, className:Class):void
		{
			LoaderBlueprint[type] = className;
		}
		
		//取一个下载器
		beyond_challenge function getLoader(type:int):ILoader
		{
			return new LoaderBlueprint[type] as ILoader;
		}
		
		/*
		 * 建立一个下载 vital=true表示当前所有下载完成后会下载此,重要的立刻为他腾出一个空间，否则添加到最开始
		 * */
		public function addWait(url:String, type:int = 0, context:*= undefined, vital:Boolean = false):ILoadRespond
		{
			//如果在下载中，直接跳出来
			if (hashLoad.isKey(url)) return hashLoad.getValue(url);
			//在等待列表
			if (hashWait.isKey(url)) return hashWait.getValue(url);
			//添加到等待列表
			var filder:LoadFluider = new LoadFluider(this, url, type, context);
			if (hashWait.isEmpty()) {
				lastUrl = firstUrl = url;
			}else {
				//vital true 放到最前面 false 放到最后
				if (vital) {
					filder.setNext(getWaiter(firstUrl));
					firstUrl = url;
				}else {
					filder.setPrev(getWaiter(lastUrl));
					lastUrl = url;
				}
			}
			//添加
			hashWait.put(url, filder);
			return filder;
		}
		
		//取等待下载
		beyond_challenge function getWaiter(url:String):LoadFluider
		{
			return hashWait.getValue(url) as LoadFluider;
		}
		
		//取下载中管理
		beyond_challenge function getWorker(url:String):LoadFluider
		{
			return hashLoad.getValue(url) as LoadFluider;
		}
		
		/*
		 * 是否为最后等待下载
		 * */
		public function isLast(url:String):Boolean 
		{
			if (url == null) throw Error('this url is null');
			return url == lastUrl;
		}
		
		/*
		 * 是否为最开始等待下载
		 * */
		public function isBegin(url:String):Boolean
		{
			if (url == null) throw Error('this url is null');
			return url == firstUrl;
		}
		
		/*
		 * 没有等待的下载列表
		 * */
		public function isEmpty():Boolean
		{
			return hashWait.size == NONE;
		}
		
		/*
		 * 是否存在下载
		 * */
		public function isLoad():Boolean
		{
			return hashLoad.size != NONE;
		}
		
		/*
		 * 是否在等待列表
		 * */
		public function isWait(url:String):Boolean
		{
			return hashWait.isKey(url);
		}
		 
		/*
		 * 当前下载满了
		 * */
		public function isLoadFull():Boolean 
		{
			return hashLoad.size >= LOAD_MAX;
		}
		
		/*
		 * 下载列表多少
		 * */
		public function loadLength():int
		{
			return hashLoad.size;
		}
		
		/*
		 * 等待下载列表多少
		 * */
		public function waitLength():int
		{
			return hashWait.size;
		}
		
		/*
		 * 判断是否下载中
		 * */
		public function isInLoad(url:String):Boolean
		{
			return hashLoad.isKey(url);
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
			if (isEmpty()) return;
			if (isLoadFull()) return;
			var filder:LoadFluider = getNext();
			if (filder.size == NONE) {
				filder.destroy();
			}else {
				addToLoad(filder);
				filder.load(getLoader(filder.type));
			}
			//多个开放
			start();
		}
		
		//添加到下载列表中去 放心添加，不会重复
		beyond_challenge function addToLoad(filder:LoadFluider):void
		{
			hashLoad.put(filder.url, filder);
		}
		
		//直接移除
		public function remove(url:String):void
		{
			var filder:LoadFluider = recompose(url);
			if (filder) filder.destroy();
			filder = hashLoad.remove(url);
			if (filder) filder.destroy();
		}
		
		//删除下载中列表
		beyond_challenge function removeLoad(url:String):LoadFluider
		{
			return hashLoad.remove(url) as LoadFluider;
		}
		
		//取下一个等待下载
		beyond_challenge function getNext():LoadFluider
		{
			return recompose(firstUrl) as LoadFluider;
		}
		
		//删除其中一个下载  然后重组
		beyond_challenge function recompose(url:String):LoadFluider
		{
			var filder:LoadFluider = hashWait.remove(url) as LoadFluider;
			if (filder) {
				//第一个也是最后一个
				if (isEmpty()) {
					firstUrl = null;
					lastUrl = null;
				}else if (filder.isNext() && filder.isPrev()) {
					//设置前后两个兑换
					getWaiter(filder.prevPath).setNext(getWaiter(filder.nextPath));
				}else if (isBegin(url)) {
					firstUrl = filder.nextPath;
					//设置下一个为第一个
					getWaiter(filder.nextPath).setPrev(null);
				}else if (isLast(url)) {
					//这个删除的是最后一个，而且有前面
					lastUrl = filder.prevPath;
					//设置前面一个为最后一个
					getWaiter(filder.prevPath).setNext(null);
				}
				filder.setPrev(null);
				filder.setNext(null);
			}
			return filder;
		}
		
		/*
		 * 删除回调,删除关闭
		 * */
		public function removeRespond(url:String, called:Function = null):void
		{
			if (url == null) throw Error('this url is null');
			var filder:LoadFluider = hashWait.getValue(url);
			if (filder) {
				if (called == null || filder.removeRespond(called) == NONE) {
					recompose(url).destroy();
				}
			}
			filder = hashLoad.getValue(url);
			if (filder) {
				if (called == null || filder.removeRespond(called) == NONE) {
					hashLoad.remove(url);
					filder.destroy();
					start();
				}
			}
		}
		
		/*
		 * 停止当前所有下载，会把下载中的提到最开始,直接暂停所有并且保存就是
		 * */
		public function stop(share:Boolean = false):void
		{
			if (!isLoad()) return;
			if (share) {
				hashLoad.eachKey(stopLoader);
			}else {
				clearLoad();
			}
			Log.log(this).debug('##stop loading ->share=', share);
		}
		
		
		beyond_challenge function stopLoader(url:String):void
		{
			var filder:LoadFluider = getWorker(url);
			//没有下载就不添加了
			if (filder.isLoad()) {
				filder.close();
				hashLoad.remove(url);
				addWaitByRespond(filder);
			}
		}
		
		//直接添加到下载列表 添加到的是最开始
		beyond_challenge function addWaitByRespond(filder:LoadFluider):void
		{
			if (hashLoad.isKey(filder.url)) throw Error("下载列表中..")
			if (hashWait.isKey(filder.url)) throw Error("等待列表中..")
			if(hashWait.isEmpty()) {
				lastUrl = firstUrl = filder.url;
			}else {
				filder.setNext(getWaiter(firstUrl));
				firstUrl = filder.url;
			}
			hashWait.put(filder.url, filder);
		}
		
		/*
		 * 清除所有下载  ,不公开
		 * */
		private function clearLoad():void
		{
			hashLoad.eachKey(remove);
		}
		
		/*
		 * 清理所有等待
		 * */
		public function clear():void
		{
			if (hashWait.isEmpty()) return;
			hashWait.eachKey(remove);
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
			return "===============\nwait list->\n"+hashWait + "\n load list->\n" + hashLoad+"\n===================";
		}
		
		//利用一个全局
		private static var _ins:PerfectLoader;
		
		public static function gets():PerfectLoader
		{
			if (_ins == null) _ins = new PerfectLoader;
			return _ins;
		}
		//ends
	}

}


