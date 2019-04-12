package application.view
{
	import application.ApplicationFacade;
	import application.model.DataProxy;
	import application.view.components.Menus;
	import application.view.components.TileFrame;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator//该类处理启动游戏，重启游戏等逻辑
	{
		public static const NAME:String = "ApplicationMediator";
		public static const KEY_DOWN:String = "key_down";
		
		// Model.
		private var data:DataProxy;


		
		public function ApplicationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			

			main.stage.align = StageAlign.TOP_LEFT;
			main.stage.scaleMode = StageScaleMode.NO_SCALE;

			
			main.stage.focus=main.stage;
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN,_keydown)	

			data = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;

			drawAssets();
		}
		
		private function _keydown(event:KeyboardEvent):void{
			sendNotification(KEY_DOWN,event.keyCode);
		}
		
		
		override public function listNotificationInterests():Array
		{
			return new Array();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch( notification.getName() )
			{

			}
		}
		
		public function get main():Main
		{
			return viewComponent as Main;
		}
		
	
		
		
		
		private var tileFrame:TileFrame;
		private var menu:Menus;
		private function drawAssets():void
		{

			//画上主网格布局
			tileFrame = new TileFrame(data.tileArray);
			facade.registerMediator( new TileFrameMediator(tileFrame));
			main.addChild(tileFrame);
			
			
			//画上菜单
			menu=new Menus();
			facade.registerMediator(new MenuMediator(menu));
			main.addChild(menu);
		    menu.y=tileFrame.y+tileFrame.height+20;
			
		}
		

	}
}