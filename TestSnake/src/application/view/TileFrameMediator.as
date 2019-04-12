package application.view
{
	import application.controller.RestartGameCommand;
	import application.controller.RndFoodCommand;
	import application.controller.SnakeMoveCommand;
	import application.model.DataProxy;
	import application.view.components.TileFrame;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.Notification;

	public class TileFrameMediator extends Mediator implements IMediator
		//处理游戏内容
	{
		public static const NAME:String = "TileFrameMediator";
		public static const START_GAME:String="start_game";
		public static const RESTART_GAME:String="restart_game";
		public static const GAME_OVER:String="game_over";
		public static const SNAKE_MOVE:String="snake_move";
		public static const RND_FOOD:String="rnd_food";
		
		private var data:DataProxy;
		private var direction:int;
		
		
		public function TileFrameMediator(viewComponent:Object):void
		{
			super(NAME, viewComponent);
			
			
			data = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
			//注册其他command
			facade.registerCommand(SNAKE_MOVE,SnakeMoveCommand);
			facade.registerCommand(RND_FOOD,RndFoodCommand);
			facade.registerCommand(RESTART_GAME,RestartGameCommand)
			
			
			
		}
		
		
		override public function listNotificationInterests():Array
		{
			return new Array(DataProxy.TILE_REFRESH,
				ApplicationMediator.KEY_DOWN,START_GAME,GAME_OVER,RESTART_GAME);
		}
		
		
		//也可以通过command来处理消息，获得mediator和proxy的引用后，纯粹调用两部分封装的API
		override public function handleNotification(notification:INotification):void
		{
			switch( notification.getName() )
			{
				case DataProxy.TILE_REFRESH:
					//这个消息已经在redrawsnakecommand中处理
					break;
				case ApplicationMediator.KEY_DOWN:
					var keyCode:int=notification.getBody() as int
					setDir(keyCode)
					break;
				case START_GAME:
					initGame();
					break;
				case RESTART_GAME:
					pauseGame();
					break;
				case GAME_OVER:
					pauseGame();
					break;

			}
		}
		
		private function initGame():void{
			
			direction=2;
			//发送食物
			sendNotification(RND_FOOD);
			tileFrame.addEventListener(Event.ENTER_FRAME,_enterframe)
			
		}
		private function setDir(keyCode:int):void{
//					trace(keyCode)
			switch(keyCode){
				case 37://左
					direction=2;
					break;
				case 38://上
					direction=0;
					break;
				case 39://右
					direction=3;
					break;
				case 40://下
					direction=1;
					break;
			}
		}
		public function rndAFood():int{//由于在command中最好是操作mediator封装的api而不是直接操作view组件，所以这里增加一个方法
			var foodNo:int=tileFrame.rndAFood();
			return foodNo
		}
		
		public function refreshTile(arr:Array,fullTileArr:Array):void{
			tileFrame.refreshTile(arr,fullTileArr)
		}
		
		
		public function pauseGame():void{
			tileFrame.removeEventListener(Event.ENTER_FRAME,_enterframe)
		}
		
		private function _enterframe(event:Event):void{
			sendNotification(SNAKE_MOVE,direction)
		}
		

		private function get tileFrame():TileFrame
		{
			return viewComponent as TileFrame;
		}
	}
}