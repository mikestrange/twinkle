package org.web.sdk.utils 
{
	public class ArrayUtils 
	{
		//快速排序
		private static function quickSort(a:Array, left:int, right:int):void
		{
			if (left > right) return;
			var temp:int = a[left];
			var i:int = left;
			var j:int = right;
			var t:int;
			while (i!=j)
			{
				while (a[j]>=temp && i<j) j--;
				while (a[i]<=temp && i<j) i++;
				if (i < j)
				{
					t = a[i];
					a[i] = a[j];
					a[j] = t;
				}
			}
			a[left] = a[i];
			a[i] = temp;
			quickSort(a, left, i - 1);
			quickSort(a, i + 1, right);
		}
		
		private static function quickSortOn(a:Array, left:int, right:int, value:String):void
		{
			if (left > right) return;
			//temp中存的就是基准数 
			var temp:Object = a[left];
			var i:int = left;
			var j:int = right;
			var t:Object;
			while (i!=j)
			{
				//顺序很重要，要先从右边开始找 
				while (a[j][value]>=temp[value] && i<j) j--;
				//再找右边的 
				while (a[i][value]<=temp[value] && i<j) i++;
				//交换两个数在数组中的位置 
				if (i < j){
					t = a[i];
					a[i] = a[j];
					a[j] = t;
				}
			}
			//最终将基准数归位 
			a[left] = a[i];
			a[i] = temp;
			//继续处理左边的，这里是一个递归的过程 
			quickSortOn(a, left, i - 1, value);
			//继续处理右边的 ，这里是一个递归的过程 
			quickSortOn(a, i + 1, right, value);
		}
		
		//快速排序
		public static function quick(a:Array, value:String = null):void
		{
			if (a == null || a.length == 0) return;
			if (value) quickSortOn(a, 0, a.length - 1, value);
			else quickSort(a, 0, a.length - 1);
		}
		
		//ends
	}

}