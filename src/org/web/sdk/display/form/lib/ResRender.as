package org.web.sdk.display.form.lib 
{
	import org.web.sdk.display.form.Texture;
	/*
	 * 资源渲染器
	 * 你无法通过他去渲染，只能通过IAcceptor来主动取的他的渲染物件
	 * 不同渲染只需要子类去复写self_render就能改变
	 * 
	 * 假设不给他命名：
	 * 1，_lock = false的时候，表示不是弱引用的，relieve的时候就会被释放
	 * 2，_lock = true的时候，表示是强引用的，只能自身调用dispose才能释放
	 * */
	public class ResRender 
	{
		//
		public static const asset:AssetManager = AssetManager.gets();
		//
		private static const NONE:int = 0;
		//
		private var _resName:String;
		private var _quote:int = NONE;	//引用数目
		private var _lock:Boolean = false;
		
		//没有名称milde=true的时候会在清楚的时候被删除，默认是一个强引用
		public function ResRender(resName:String = null, $lock:Boolean = false)
		{
			this._resName = resName;
			if ($lock) lock();
		}
		
		public function lock():void
		{
			_lock = true;
		}
		
		//如果解除，没有引用，那么就报废
		public function unlock():void
		{
			_lock = false;
			if (_quote <= NONE) this.dispose();
		}
		
		public function isLock():Boolean
		{
			return _lock;
		}
		
		public function getResName():String
		{
			return _resName;
		}
		
		//被束缚的
		public function isHamper():Boolean
		{
			return _resName != null && _resName != "";
		}
		
		//可以通过自身直接释放
		public function dispose():void 
		{
			if (isHamper()) asset.remove(_resName);
		}
		
		internal function setName(value:String):void
		{
			this._resName = value;
		}
		
		//通过它去渲染，强制渲染[会增加一个引用]
		public function setPowerfulRender(data:Object = null):Texture
		{
			addHold();	
			return createUpdate(data);
		}
		
		//增加一个引用
		public function addHold():void
		{
			if (isHamper()) {
				_quote++;
				asset.register(this);
			}
		}
		
		public function shiftHold():void
		{
			//如果没有被注入，你调用这个必定被删除
			_quote--;
			if (!_lock && _quote <= NONE) this.dispose();
		}
		
		public function get length():int
		{
			return _quote;
		}
		
		//解除,如果没有保存在内存，如果是弱引用那么背解除后直接释放
		public function relieve():void
		{
			if (isHamper()) {
				shiftHold();
			}else {
				if (!_lock) dispose();
			}
		}
		
		//子类复写就可以了  如果不把引用的对象传过来，那么就非常单一的回应
		//虽然可以不传，但是为了更好的扩展，必须传
		//这里只用于刷新
		public function createUpdate(data:Object):Texture
		{
			return null;
		}
		
		//ends
	}

}