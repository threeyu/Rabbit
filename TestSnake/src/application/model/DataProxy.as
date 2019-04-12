package application.model
{
	import application.ApplicationFacade;
	import application.controller.ReDrawSnakeCommand;
	import application.model.VO.TileObj;
	import application.view.TileFrameMediator;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DataProxy extends Proxy implements IProxy//proxy不监听notification
	{
		public static const NAME:String = "DataProxy";
		public static const TILE_REFRESH:String = "tile_refresh";
		
		//常量
		public const TILE_WIDTH:int=50;
		public const TILE_HEIGHT:int=30;
		
		public var direction:int;//方向
		
		public var tileArray:Array;
		
		private var snakeArr:Array;
		private var headNo:int;
		
		private var food:int;
		
		public function DataProxy()
		{
			super(NAME);
			//注册command
			facade.registerCommand(TILE_REFRESH,ReDrawSnakeCommand)

			
			tileArray=new Array(TILE_WIDTH,TILE_HEIGHT);
			//初始化区块数据模型
			initTiles();
			
			
			trace("DataProxy.ctor");
		}
		public function initTiles():void{
			var len:int=TILE_WIDTH*TILE_HEIGHT;
			for(var i:int=0;i<len;i++){
				//最简单的行列标识公式，在制作翻页中常可以使用
				var tx:int=i%TILE_WIDTH;
				var ty:int=i/TILE_WIDTH;	
				tileArray[i]=new TileObj(tx,ty,0);
			}
			
			
			//初始化蛇的区块
			headNo=len/2+20
			snakeArr=[headNo,headNo+1,headNo+2,headNo+3]//这里不另外定义头部，就用第一元素作为头部

			for(i=0;i<snakeArr.length;i++){
				tileArray[snakeArr[i]].state=1;
			}
			
			
			
		}
		
		public function restartTiles():void{
			initTiles();
			sendNotification(TILE_REFRESH,{ref:tileArray,fullTileArr:tileArray})
			
		}
		
		public function setFood(foodNo:int):void{//设置食物
			food=foodNo;
			tileArray[food].state=2;
			sendNotification(TILE_REFRESH,{ref:[tileArray[food]],fullTileArr:tileArray})
		}

		
		private function getNextHeadNo():int{//判断下一次运动头部位置
			var tNextNo:int;
			switch(direction){
				case 0://上
				  if(Math.floor(headNo/TILE_WIDTH)==0){//在第一排  
					 tNextNo=headNo+(TILE_HEIGHT-1)*TILE_WIDTH;
				  }else{
					 tNextNo=headNo-TILE_WIDTH
				  }	
					break;
				case 1://下
				  if(Math.floor(headNo/TILE_WIDTH)==TILE_HEIGHT-1){//在第最后一排  
					 tNextNo=headNo-(TILE_HEIGHT-1)*TILE_WIDTH;
				  }else{
					 tNextNo=headNo+TILE_WIDTH
				  }		
					break;
				case 2://左
				if(Math.floor(headNo/TILE_WIDTH)==headNo/TILE_WIDTH){//最左边
					tNextNo=headNo+TILE_WIDTH-1;
				}else{
					tNextNo=headNo-1;
				}
					break;
				case 3://右
				if(Math.floor((headNo+1)/TILE_WIDTH)==(headNo+1)/TILE_WIDTH){//最右边	
					   tNextNo=headNo-TILE_WIDTH+1										
				}else{
					tNextNo=headNo+1;
				}
					break;
			}
//			trace(tNextNo)
			return tNextNo;
		}
		
		
		
		private var refTiles:Array//需要刷新的区块
		private var preDir:int=-1
		public function modifyTiles(d:int):void{//执行一次蛇的动作
			
			refTiles=new Array;
			
			
			if(Math.abs(d-preDir)!=1||d+preDir==3)direction=d;;//取消直接反向的操作
			
			preDir=direction;
			if(direction==-1)return;
			

			//新蛇头的区块，
			headNo=getNextHeadNo();
			//判断是否死亡
			if(isDead()){
				direction=-1;
				sendNotification(TileFrameMediator.GAME_OVER)
				return;
			}
			
			
			TileObj(tileArray[headNo]).x=headNo%TILE_WIDTH;
			TileObj(tileArray[headNo]).y=int(headNo/TILE_WIDTH);
			var tstate:int=TileObj(tileArray[headNo]).state;
			TileObj(tileArray[headNo]).state=1;
			
			snakeArr.unshift(headNo)//设置数组中的第一个元素为蛇头位置
			refTiles.push({x:tileArray[headNo].x,y:tileArray[headNo].y,state:tileArray[headNo].state})
			
			//原蛇尾的区块
			var end:int=snakeArr.length-1
			if(tstate!=2){
			tileArray[snakeArr[end]].state=0;//设置为非蛇体
			refTiles.push({x:tileArray[snakeArr[end]].x,y:tileArray[snakeArr[end]].y,state:tileArray[snakeArr[end]].state});
			snakeArr.pop();
			}

				
			
			
			
			sendNotification(TILE_REFRESH,{ref:refTiles,fullTileArr:tileArray})
			if(tstate==2)sendNotification(TileFrameMediator.RND_FOOD)
		}
		
		private function isDead():Boolean{
			for(var i:int=0;i<snakeArr.length;i++){
				if(headNo==snakeArr[i]){//如果新的蛇头位置是原蛇体
					return true;
					break;
				}
			}
			return false;
		}
		
		

		
		
		
		
		

	}
}