package application.view
{
	import application.view.components.Menus;
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MenuMediator";
		
		
		public function MenuMediator(viewComponent:Object)
		{
			super(NAME,viewComponent)
			//这些监听也可以写在menu里,然后通过dispatch再在mediator中监听，可以保持封装性
			menus.startBtn.addEventListener(MouseEvent.CLICK,_startClick);
			menus.restartBtn.addEventListener(MouseEvent.CLICK,_restartClick);
		}
		
		private function _startClick(event:MouseEvent):void{
			sendNotification(TileFrameMediator.START_GAME);
			menus.startBtn.removeEventListener(MouseEvent.CLICK,_startClick);
			
		}
		private function _restartClick(event:MouseEvent):void{
			sendNotification(TileFrameMediator.RESTART_GAME);
			menus.startBtn.addEventListener(MouseEvent.CLICK,_startClick);
		}
		
		public function get menus():Menus
		{
			return viewComponent as Menus;
		}
	}
}