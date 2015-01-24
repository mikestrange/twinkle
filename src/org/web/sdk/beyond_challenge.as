package org.web.sdk 
{
	import flash.geom.Point;
	import org.web.sdk.inters.IDisplayObject;
	import org.web.sdk.utils.Maths;
	/*
	 * sdk空间
	 * */
	public namespace beyond_challenge = 'tianwangame';
	
	//是否
	/*
	public function renderMove(dis:IDisplayObject, vector:Vector.<Point>, index:int = 0, speed:int = 10):Boolean
	{
		if (index < 0 || index >= vector.length) return false;
		var angle:Number = Maths.atanAngle(dis.x, dis.y, vector[index].x, vector[index].y);	//计算两点之间的角度
		var mpo:Point = Maths.resultant(angle, speed);										//计算增量
		dis.x -= mpo.x;
		dis.y -= mpo.y;
		//两点之间的长度
		if (Maths.distance(dis.x, dis.y, vector[index].x, vector[index].y) <= speed) {
			dis.moveTo(vector[index].x, vector[index].y);
			return true;
		}
		return false;
	}
	*/
}