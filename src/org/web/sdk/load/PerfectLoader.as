/** 
 *org.web.sdk.load542540443@qq.com 
 *@version 1.0.0 
 * 创建时间：2013-12-5 下午11:46:04 
 **/ 
package org.web.sdk.load 
{
	import org.web.sdk.load.loads.*;
	import org.web.sdk.utils.HashMap;
	import org.web.apk.beyond_challenge;
	
	/*
	 * 下载管理,完美的下载管理器
	 * */
	use namespace beyond_challenge;
	
	public class PerfectLoader 
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
		
		/*
		 * 建立一个下载 vital=true表示当前所有下载完成后会下载此,重要的立刻为他腾出一个空间，否则添加到最开始
		 * */
		public function addWait(url:String, type:int = 0, context:*= undefined, vital:Boolean = false):IRespond
		{
			//如果在下载中，直接跳出来
			if (isLoadIng(url)) return getFluiderByLoad(url);
			//在等待列表
			if (isWait(url)) return getFluider(url);
			//添加到等待列表
			var fluider:LoadFluider = new LoadFluider(url, type, context);
			if (isEmpty()) {
				lastUrl = firstUrl = url;
			}else {
				//vital true 放到最前面 false 放到最后
				if (vital) {
					fluider.setNext(getFluider(firstUrl));
					firstUrl = url;
				}else {
					fluider.setPrev(getFluider(lastUrl));
					lastUrl = url;
				}
			}
			//添加
			hashWait.put(url, fluider);
			return fluider;
		}
		
		//直接添加到下载列表 添加到的是最开始
		beyond_challenge function addWaitByFluider(fluider:LoadFluider):void
		{
			if (isEmpty()) {
				lastUrl = firstUrl = fluider.url;
			}else {
				fluider.setNext(getFluider(firstUrl));
				firstUrl = fluider.url;
			}
			hashWait.put(fluider.url, fluider);
		}
			
		//取等待下载
		beyond_challenge function getFluider(url:String):LoadFluider
		{
			return hashWait.getValue(url) as LoadFluider;
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
		 * 启动下载
		 * */
		public function startLoad():void
		{
			if (isEmpty()) return;
			if (isLoadFull()) return;
			var fluider:LoadFluider = getNext();
			if (fluider.size == NONE) {
				fluider.clear(); //没有回调就清理
			}else {
				fluider.load(this, getLoader(fluider.type));
				addToLoad(fluider);
			}
			//多个开放
			startLoad();
		}
		
		//添加到下载列表中去 放心添加，不会重复
		beyond_challenge function addToLoad(fluider:LoadFluider):void
		{
			hashLoad.put(fluider.url, fluider);
		}
		
		/*
		 * 判断是否下载中
		 * */
		public function isLoadIng(url:String):Boolean
		{
			return hashLoad.isKey(url);
		}
		
		//
		public function isInto(url:String):Boolean
		{
			return isLoadIng(url) || isWait(url);
		}
		
		//取下载中管理
		beyond_challenge function getFluiderByLoad(url:String):LoadFluider
		{
			return hashLoad.getValue(url) as LoadFluider;
		}
		
		//关闭清理所有下载 或者清理单个下载
		beyond_challenge function closeAndRemove(url:String = null):void
		{
			if (url == null) {
				hashLoad.eachKey(closeAndRemove);
			}else {
				if (isLoadIng(url)) {
					var fluider:LoadFluider = removeLoadIng(url);
					fluider.close();
					fluider.clear();
				}
			}
		}
		
		//下载完成 提供给LoadFluider
		internal function loadOver(url:String):void
		{
			removeLoadIng(url);
			startLoad();
		}
		
		//删除下载中列表
		beyond_challenge function removeLoadIng(url:String):LoadFluider
		{
			return hashLoad.remove(url) as LoadFluider;
		}
		
		//取一个下载器
		beyond_challenge function getLoader(type:int):ILoader
		{
			return new LoaderBlueprint[type] as ILoader;
		}
		
		//取下一个等待下载
		beyond_challenge function getNext():LoadFluider
		{
			return removePath(firstUrl) as LoadFluider;
		}
		
		//删除其中一个下载
		beyond_challenge function removePath(url:String):LoadFluider
		{
			var flder:LoadFluider = hashWait.remove(url) as LoadFluider;
			if (flder) {
				//第一个也是最后一个
				if (isEmpty()) {
					firstUrl = null;
					lastUrl = null;
				}else if (flder.isNext() && flder.isPrev()) {
					//设置前后两个兑换
					getFluider(flder.prevPath).setNext(getFluider(flder.nextPath));
				}else if (isBegin(url)) {
					firstUrl = flder.nextPath;
					//设置下一个为第一个
					getFluider(flder.nextPath).setPrev(null);
				}else if (isLast(url)) {
					//这个删除的是最后一个，而且有前面
					lastUrl = flder.prevPath;
					//设置前面一个为最后一个
					getFluider(flder.prevPath).setNext(null);
				}
				flder.setPrev(null);
				flder.setNext(null);
			}
			return flder;
		}
		
		/*
		 * 删除回调,删除关闭
		 * */
		public function removeMark(url:String, mark:String = null):void
		{
			if (url == null) throw Error('this url is null');
			var flder:LoadFluider;
			if (isWait(url)) {
				if (mark == null) {
					removePath(url).clear();
				}else {
					flder = getFluider(url);
					if (flder.removeRespond(mark) == NONE) removeMark(url);
				}
			}
			if (isLoadIng(url)) {
				//关闭后开启下一个加载
				if (mark == null) {
					closeAndRemove(url);
					startLoad();
				}else {
					flder = getFluiderByLoad(url);
					if (flder.removeRespond(mark) == NONE) removeMark(url);
				}
			}
			trace('##delete url=', url, ',mark=', mark);
		}
		
		/*
		 * 清理所有等待
		 * */
		public function clearWait():void
		{
			hashWait.eachKey(removeMark);
			trace('##clear wait loads');
		}
		
		/*
		 * 停止当前所有下载，会把下载中的提到最开始,直接暂停所有并且保存就是
		 * */
		public function stop(share:Boolean = true):void
		{
			if (!share) {
				closeAndRemove();
			}else {
				hashLoad.eachKey(addLoadToWait);
			}
			trace('##stop loading ->share=', share);
		}
		
		//暂停被添加到等待列表
		beyond_challenge function addLoadToWait(url:String):void
		{
			var flder:LoadFluider = getFluiderByLoad(url);
			//已经下载过，可能回调没有结束
			if (!flder.isLoad()) {
				flder.close();
				removeLoadIng(url);	//不清理其他回调
			}else {
				//没有下载
				flder.close();
				addWaitByFluider(flder);
			}
		}
		
		/*
		 * 释放所有
		 * */
		public function free():void
		{
			if (!isEmpty()) clearWait();
			if (isLoad()) stop(false);
		}
		
		public function toString():String
		{
			return "===============\nwait list->\n"+hashWait + "\n load list->\n" + hashLoad+"\n===================";
		}
		
		//利用一个全局
		private static var _ins:PerfectLoader;
		
		public static function gets():PerfectLoader
		{
			if (_ins == null) {
				_ins = new PerfectLoader;
				_ins.initialization();
			}
			return _ins;
		}
		
		//ends
	}

}


