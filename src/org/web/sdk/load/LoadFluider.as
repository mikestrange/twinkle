/** 
 *org.web.sdk.load542540443@qq.com 
 *@version 1.0.0 
 * 创建时间：2013-12-5 下午11:46:04 
 **/ 
package org.web.sdk.load 
{
	import flash.utils.Dictionary;
	import org.web.apk.beyond_challenge;
	import org.web.sdk.handler.Observer;
	import org.web.sdk.load.inters.ILoadController;
	import org.web.sdk.load.inters.ILoader;
	import org.web.sdk.load.inters.ILoadRespond;
	import org.web.sdk.log.Log;
	
	use namespace beyond_challenge;
	//下载流体
	internal class LoadFluider implements ILoadRespond 
	{
		//必须参数
		beyond_challenge var _url:String;
		beyond_challenge var _type:int;
		beyond_challenge var _context:*;
		//下载链
		beyond_challenge var _nextPath:String;
		beyond_challenge var _prevPath:String;
		//只有在下载的时候进行短暂的交易
		beyond_challenge var _loader:ILoader;			//下载器
		//回执列表
		beyond_challenge var _vector:Vector.<Observer>
		beyond_challenge var _controller:ILoadController
		private var _called:Function;
		
		public function LoadFluider(controller:ILoadController, url:String, type:int = 0, context:*= undefined) 
		{
			this._url = url;
			this._type = type;
			this._context = context;
			this._controller = controller;
			this._vector = new Vector.<Observer>;
		}
		
		public function get context():*
		{
			return _context;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		//添加一个监听回执
		public function addRespond(called:Function, only:Object = null):void
		{
			_vector.push(new Observer(this, called, only));
		}
		
		public function removeRespond(called:Function):int
		{
			for (var i:int = _vector.length - 1; i >= 0; i--) {
				if (_vector[i].handler == called) {
					_vector[i].destroy();
					_vector.splice(i, 1);
					break;
				}
			}
			return _vector.length;
		}
		
		//开始下载
		public function load(loader:ILoader):void
		{
			if (_loader) throw Error("xxxx has loader");
			_loader = loader;
			_loader.downLoad(_url, _context, invokes);
		}
		
		public function destroy():void
		{
			_nextPath = null;
			_prevPath = null;
			close();
			while (_vector.length) {
				_vector.shift().destroy(); 
			}
		}
		
		//调用所有监听,open,opress,error,complete
		beyond_challenge function invokes(target:Object, eventType:String):void
		{
			var isEnd:Boolean = (eventType == LoadEvent.COMPLETE || eventType == LoadEvent.ERROR);
			if (isEnd) {
				_loader = null;
				PerfectLoader(_controller).removeLoad(_url);
				_controller.start();
				Log.log(this).debug('#加载完成->url:' + _url + ',context:' + _context + ",type:" + eventType);
			}
			var index:int = 0;
			var list:Vector.<Observer> = _vector.slice(index, _vector.length);
			for (;index < list.length; index++) {
				list[index].handler(new LoadEvent(target, _url, eventType, list[index].getBody(), _type));
			}
			list = null;
			if (isEnd) destroy();
		}
		
		//只要关闭，就不给回调,必须重新下载
		public function close():void
		{
			if (_loader == null) return;
			try {
				_loader.close();
			}catch (e:Error) {
				Log.log(this).debug('#关闭下载出错:下载已经完成或者下载未开始', _url);
			}
			_loader = null;
		}
		
		//双向设置
		public function setNext(value:LoadFluider):void
		{
			if (value == null) {
				_nextPath = null;
			}else {
				value._prevPath = _url;
				_nextPath = value.url;
			}
		}
		
		//双向设置
		public function setPrev(value:LoadFluider):void
		{
			if (value == null) {
				_prevPath = null;
			}else {
				_prevPath = value.url;
				value._nextPath = _url;
			}
		}
		
		public function get nextPath():String
		{
			return _nextPath;
		}
		
		public function get prevPath():String
		{
			return _prevPath;
		}
		
		public function isNext():Boolean
		{
			return _nextPath != null;
		}
		
		public function isPrev():Boolean
		{
			return _prevPath != null;
		}
		
		public function get size():int
		{
			return _vector.length;
		}
		
		//是否下载 没有开始就表示下载[_isstart=true表示下载中]
		public function isLoad():Boolean
		{
			return _loader != null;
		}
		//ends
	}

}