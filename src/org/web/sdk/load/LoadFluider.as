/** 
 *org.web.sdk.load542540443@qq.com 
 *@version 1.0.0 
 * 创建时间：2013-12-5 下午11:46:04 
 **/ 
package org.web.sdk.load 
{
	import flash.utils.Dictionary;
	import org.web.apk.beyond_challenge;
	
	use namespace beyond_challenge;
	//下载流体
	internal class LoadFluider implements IRespond 
	{
		//必须参数
		beyond_challenge var _url:String;
		beyond_challenge var _type:int;
		beyond_challenge var _context:*;
		//回调
		beyond_challenge var _hash:Dictionary;
		beyond_challenge var _leng:int;
		//下载链
		beyond_challenge var _nextPath:String;
		beyond_challenge var _prevPath:String;
		//只有在下载的时候进行短暂的交易
		beyond_challenge var _isstart:Boolean = false;
		beyond_challenge var _loader:ILoader;		//下载器
		beyond_challenge var _leader:PerfectLoader;	//控制器
		//
		public static const DEF_MARK:String = 'defmark';
		
		public function LoadFluider(url:String, type:int = 0, context:*= undefined) 
		{
			this._url = url;
			this._type = type;
			this._context = context;
			this._hash = new Dictionary;
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
		public function addRespond(mark:String, called:Function, only:Object = null):void
		{
			if (mark == null || mark == '') mark = DEF_MARK;
			var next:LoadRespond = getRespond(mark);
			if (next) next.free();
			else _leng++;
			//
			_hash[mark] = new LoadRespond(mark, called, only);
		}
		
		public function removeRespond(mark:String):int
		{
			var respond:LoadRespond = getRespond(mark);
			if (respond) {
				_leng--;
				delete _hash[mark];
				respond.free();
			}
			return _leng;
		}
		
		//开始下载
		public function load(leader:PerfectLoader, loader:ILoader):void
		{
			if (_isstart) return;
			_isstart = true;
			_leader = leader;
			_loader = loader;
			_loader.downLoad(_url, _context, complete);
		}
		
		//清理所有
		public function clear():void
		{
			_isstart = false;
			_nextPath = null;
			_prevPath = null;
			_loader = null;
			_leader = null;
			var mark:String;
			for (mark in _hash) removeRespond(mark);
		}
		
		//调用所有监听,open,opress,error,complete
		beyond_challenge function invokes(target:Object, eventType:String):void
		{
			var mark:String;
			for (mark in _hash) getRespond(mark).respond(new LoadEvent(target, _url, eventType, _type));
		}
		
		protected function getRespond(mark:String):LoadRespond
		{
			return _hash[mark] as LoadRespond;
		}
		
		beyond_challenge function complete(target:Object, eventType:String):void
		{
			if (!_isstart) return;
			var bool:Boolean;
			if (eventType == LoadEvent.COMPLETE || eventType == LoadEvent.ERROR) {
				//在这里下载就已经结束,无论失败还是成功
				bool = true;
				_isstart = false;
				trace('#加载完成->url:', _url, ',context:' + _context, ",type:" + eventType);
			}
			//派发下载所需要的回执
			invokes(target, eventType);
			//清理 并且通知下载下一个，如果当前的没有close，那么会启动下一个,否则暂停下载
			if (bool) {
				if (_leader) _leader.loadOver(_url);
				//清理
				clear();
			}
		}
		
		//只要关闭，就不给回调,必须重新下载
		public function close():void
		{
			_leader = null;	//命令器
			if (_isstart) {
				_isstart = false;
				try {
					_loader.close();
				}catch (e:Error) {
					trace('#关闭下载出错:下载已经完成或者下载未开始', _url);
				}
			}
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
			return _leng;
		}
		
		//是否下载 没有开始就表示下载[_isstart=true表示下载中]
		public function isLoad():Boolean
		{
			return _isstart;
		}
		//ends
	}

}


//下载监听
import org.web.sdk.load.LoadEvent;

class LoadRespond 
{
	private var _called:Function;
	private var _only:Object;
	private var _islife:Boolean = true;
	private var _mark:String;
		
	public function LoadRespond(mark:String, called:Function, only:Object = null) 
	{
		_called = called;
		_only = only;
		_mark = mark;
	}
		
	//这里是一个借口
	public function respond(event:LoadEvent):void
	{
		if (_islife) {
			event.data = _only;
			_called(event);
		}
	}
	
	public function get data():Object
	{
		return _only;
	}
		
	public function free():void
	{
		_islife = false;
		_called = null;
		_only = null;
	}
		
	//ends
}
