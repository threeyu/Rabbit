package application.model.VO
{
	public class TileObj extends Object
	{
		
		private var _x:int,_y:int,_state:int
		public function TileObj(x:int,y:int,state:int)
		{
			_x=x;_y=y;_state=state;
		}
		
		
		//保证3个数据接口的不变
		public function get x():int{
			return _x
		}
		public function set x(tx:int):void{
			_x=tx;
		}
		
		public function get y():int{
			return _y;
			
		}
		public function set y(ty:int):void{
			_y=ty;
		}
		
		
		public function get state():int{
			return _state;
			
		}
		public function set state(tstate:int):void{
			_state=tstate;
		}
	}
}