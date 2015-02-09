package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import org.web.sdk.inters.IAcceptor;
	import org.web.sdk.beyond_challenge;
	use namespace beyond_challenge
	/*
	 * 资源渲染器
	 * 你无法通过他去渲染，只能通过IAcceptor来主动取的他的渲染物件
	 * 不同渲染只需要子类去复写self_render就能改变
	 * 
	 * 假设不给他命名：
	 * 1，milde = false的时候，表示不是弱引用的，relieve的时候就会被释放
	 * 2，milde = true的时候，表示是强引用的，只能自身调用dispose才能释放
	 * */
	public class LibRender 
	{
		private var _libName:String;
		private var _milde:Boolean;
		private var _quote:int = 0;	//引用数目
		//
		public static const asset:Assets = Assets.gets();
		
		public function LibRender(libName:String = null, milde:Boolean = false)
		{
			this._libName = libName;
			this._milde = milde;
		}
		
		public function get name():String
		{
			return _libName;
		}
		
		public function get milde():Boolean
		{
			return _milde;
		}
		
		//被束缚的
		public function isHamper():Boolean
		{
			return _libName != null && _libName != "";
		}
		
		//可以通过自身直接释放
		public function dispose():void 
		{
			if (isHamper()) {
				asset.remove(_libName);
			}
		}
		
		beyond_challenge function setName(value:String):void
		{
			this._libName = value;
		}
		
		//通过它去渲染,没有保存那么直接渲染
		beyond_challenge function render(mesh:IAcceptor):*
		{
			add();	
			return self_render(mesh);
		}
		
		//子类复写就可以了  如果不把引用的对象传过来，那么就非常单一的回应
		//虽然可以不传，但是为了更好的扩展，必须传
		protected function self_render(mesh:IAcceptor):*
		{
			return null;
		}
		
		protected function add():void
		{
			if (isHamper()) {
				_quote++;
				asset.register(this);
			}
		}
		
		protected function pop():void
		{
			//如果没有被注入，你调用这个必定被删除
			_quote--;
			if (_quote <= 0) this.dispose();
		}
		
		public function get length():int
		{
			return _quote;
		}
		
		//解除,如果没有保存在内存，如果是弱引用那么背解除后直接释放
		public function relieve():void
		{
			if (isHamper()) {
				pop();
			}else {
				if (_milde) dispose();
			}
		}
		
		//*****************************
		public static function release(bit:BitmapData):void
		{
			if (bit && bit.width + bit.height > 0) bit.dispose();
		}
		
		public static function hasTexture(txName:String):Boolean
		{
			return asset.has(txName);
		}
		
		public static function getTexture(txName:String):LibRender
		{
			return asset.getTexture(txName);
		}
		
		
		//ends
	}

}