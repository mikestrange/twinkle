package org.web.sdk.gpu.core 
{
	import org.web.sdk.gpu.interfaces.IMplantation;
	import org.web.sdk.utils.HashMap;
	/*
	 * 缓存器
	 * */
	internal class TextureSystem 
	{	
		private static var _ins:TextureSystem;
		
		public static function gets():TextureSystem
		{
			if (_ins == null) _ins = new TextureSystem;
			return _ins;
		}
		
		//
		private var hash:HashMap;
		//引用计数
		public function TextureSystem() 
		{
			hash = new HashMap;
		}
		
		//保存一个
		public function share(value:TextureConductor):Boolean
		{
			if (!hash.isKey(value.getType())) {
				hash.put(value.getType(), new StorageData(value));
				trace("put",value.getType());
				return true;
			}
			return false;
		}
		
		public function getConductor(type:String):TextureConductor
		{
			var data:StorageData = hash.getValue(type);
			if (data) return data.conductor;
			return null;
		}
		
		//添加纹理
		public function add(value:TextureConductor):void 
		{
			if (value.isValid()) {
				var data:StorageData = hash.getValue(value.getType());
				if (data) data.add();
			}
		}
		
		//移除
		public function remove(value:TextureConductor):void 
		{
			var data:StorageData = hash.getValue(value.getType());
			if (data) {
				data.shift();
				if (data.isEmpty()) {
					trace("remove",value.getType());
					hash.remove(value.getType());
					data.dispose();
				}
			}
		}
		
		//应用
		public function renderConductor(type:String, texture:IMplantation, mark:String = null):Boolean
		{
			var data:StorageData = hash.getValue(type);
			if (data) {
				data.conductor.render(texture,mark);
				return true;
			}
			return false;
		}
		
		//ends
		public function dispose(key:String):void
		{
			var data:StorageData = hash.remove(key);
			if (data) {
				data.dispose();
				data = null;
			}
		}
		
		//ends
	}
}

import org.web.sdk.gpu.core .TextureConductor;

class StorageData{
	public var length:int = 0;
	public var conductor:TextureConductor;
	
	public function StorageData(value:TextureConductor) 
	{
		this.conductor = value;
	}
	
	public function add():void
	{
		length++;
	}
	
	public function shift():void
	{
		length--;
	}
	
	public function isEmpty():Boolean
	{
		return length <= 0;
	}
	
	public function dispose():void
	{
		trace("释放贴图:", conductor);
		conductor.free();
		conductor = null;
	}
	//ends
}