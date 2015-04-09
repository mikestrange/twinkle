//寻路
function setPath(value:Array):void
		{
			path = value;
			pathIndex = 1;
			iswait = (path == null);
		}
		
function frameRender(float:int = 0):void 
		{
			if (path) {
				if (pathIndex >= path.length) {
					path = null;
					return;
				}
				var node:Node = path[pathIndex];
				var endPos:Point = new Point;
				endPos.x = node.x * grid.nodeWidth + (grid.nodeWidth >> 1);
				endPos.y = node.y * grid.nodeHeight + (grid.nodeHeight >> 1);
				var angle:Number = maths.atanAngle(this.x, this.y, endPos.x, endPos.y);	//计算两点之间的角度
				var mpo:Point = maths.resultant(angle, speedX, speedY);										//计算增量
				this.x -= mpo.x;
				this.y -= mpo.y;
				//
				var point:int = FormatUtils.getIndexByAngle(maths.roundAngle(angle));
				this.move(point);
				//两点之间的长度
				if (maths.distance(this.x, this.y, endPos.x, endPos.y) <= speedX + speedY) {
					this.moveTo(endPos.x, endPos.y);
					pathIndex++;
					if (pathIndex >= path.length) this.stand();
				}
			}
		}