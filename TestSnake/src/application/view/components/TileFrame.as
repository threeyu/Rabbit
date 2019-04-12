package application.view.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.sendToURL;

	public class TileFrame extends Sprite
	{
		
		private var _data:Array;
		public function TileFrame(data:Array)
		{	_data=data;					
			initFrame();	
		}
		
		public function initFrame():void{
			for(var i:int=0;i<_data.length;i++){
				var tx:int=_data[i].x;
				var ty:int=_data[i].y;
				var tstate:int=_data[i].state;
				
				var tTile:Tile=new Tile();
				this.addChild(tTile);
				tTile.x=tx*tTile.width;
				tTile.y=ty*tTile.height;
				tTile.drawRect(tstate);
				tTile.name=tx+"_"+ty;//使用getchildbyname来寻找具体区块
				
			}
		}
		public function rndAFood():int{
			
			var foodTileNo:int=Math.random()*(_data.length-1);

			while (_data[foodTileNo].state!=0){
				foodTileNo=Math.random()*(_data.length-1);
			}
			//获得一个随机食物点后，不是直接修改view，而是通知数据层修改数据模型
			
			return foodTileNo;
			
		}
		public function refreshTile(arr:Array,fullTileArr:Array):void{
			_data=fullTileArr;//及时获得最新的数据模型
			for(var i:int=0;i<arr.length;i++){
				var tname:String=arr[i].x+"_"+arr[i].y;
				var tTile:Tile=this.getChildByName(tname) as Tile;
				tTile.drawRect(arr[i].state)
			}
		}
		
		public function drawTile(no:int):void{
			var tname:String=_data[no].x+"_"+_data[no].y;
			var tTile:Tile=this.getChildByName(tname) as Tile;
			tTile.drawRect(_data[no].state)
		}
		
	}
}